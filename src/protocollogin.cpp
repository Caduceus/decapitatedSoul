/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2020  Mark Samman <mark.samman@gmail.com>
 * Modifications made by Caduceus <decapitatedsoulot@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include "otpch.h"

#include "protocollogin.h"

#include "outputmessage.h"
#include "tasks.h"

#include "configmanager.h"
#include "iologindata.h"
#include "ban.h"
#include "game.h"

extern ConfigManager g_config;
extern Game g_game;

void ProtocolLogin::disconnectClient(const std::string& message, uint16_t version)
{
	auto output = OutputMessagePool::getOutputMessage();

	output->addByte(version >= 1076 ? 0x0B : 0x0A);
	output->addString(message);
	send(output);

	disconnect();
}

void ProtocolLogin::addWorldInfo(OutputMessage_ptr& output, const std::string& accountName, const std::string& password, uint16_t version, bool isLiveCastLogin /*=false*/)
{
	const std::string& motd = g_config.getString(ConfigManager::MOTD);
	if (!motd.empty()) {
		//Add MOTD
		output->addByte(0x14);

		std::ostringstream ss;
		ss << g_game.getMotdNum() << "\n" << motd;
		output->addString(ss.str());
	}

	//Add session key
	output->addByte(0x28);
	output->addString(accountName + "\n" + password);

	//Add char list
	output->addByte(0x64);

	output->addByte(1); // number of worlds

	output->addByte(0); // world id
	output->addString(g_config.getString(ConfigManager::SERVER_NAME));
	output->addString(g_config.getString(ConfigManager::IP));

	if (isLiveCastLogin) {
		output->add<uint16_t>(g_config.getNumber(ConfigManager::LIVE_CAST_PORT));
	} else {
		output->add<uint16_t>(g_config.getNumber(ConfigManager::GAME_PORT));
	}
	output->addByte(0);
}

void ProtocolLogin::getCastingStreamsList(const std::string& password, uint16_t version)
{
	//dispatcher thread
	auto output = OutputMessagePool::getOutputMessage();
	addWorldInfo(output, "", password, version, true);

	const auto& casts = ProtocolGame::getLiveCasts();
	output->addByte(casts.size());
	for (const auto& cast : casts) {
		output->addByte(0);
		output->addString(cast.first->getName());
	}
	output->addByte(0);
	output->addByte(g_config.getBoolean(ConfigManager::FREE_PREMIUM));
	output->add<uint32_t>(g_config.getBoolean(ConfigManager::FREE_PREMIUM) ? 0 : (time(nullptr)));

	send(std::move(output));

	disconnect();
}

void ProtocolLogin::getCharacterList(const std::string& accountName, const std::string& password, uint16_t version)
{
	//dispatcher thread
	Account account;
	if (!IOLoginData::loginserverAuthentication(accountName, password, account)) {
		disconnectClient("Account name or password is not correct.", version);
		return;
	}

	auto output = OutputMessagePool::getOutputMessage();
	//Update premium days
	Game::updatePremium(account);

	addWorldInfo(output, accountName, password, version);

	uint8_t size = std::min<size_t>(std::numeric_limits<uint8_t>::max(), account.characters.size());
	output->addByte(size);
	for (uint8_t i = 0; i < size; i++) {
		output->addByte(0);
		output->addString(account.characters[i]);
	}

	//Add premium days
	output->addByte(0);
	if (g_config.getBoolean(ConfigManager::FREE_PREMIUM)) {
		output->addByte(0x01);
		output->add<uint32_t>(0);
	}
	else {
		output->addByte(0x00);
		auto time = std::chrono::system_clock::now() + std::chrono::hours(account.premiumDays * 24);
		std::chrono::seconds timestamp = std::chrono::duration_cast<std::chrono::seconds>(time.time_since_epoch());
		output->add<uint32_t>(timestamp.count());
	}

	send(output);

	disconnect();
}

void ProtocolLogin::onRecvFirstMessage(NetworkMessage& msg)
{
	if (g_game.getGameState() == GAME_STATE_SHUTDOWN) {
		disconnect();
		return;
	}

	msg.skipBytes(2); // client OS

	uint16_t version = msg.get<uint16_t>();
	if (version >= 971) {
		msg.skipBytes(17);
	} else {
		msg.skipBytes(12);
	}
	/*
	 * Skipped bytes:
	 * 4 bytes: protocolVersion
	 * 12 bytes: dat, spr, pic signatures (4 bytes each)
	 * 1 byte: 0
	 */

	if (version <= 760) {
		disconnectClient("Only clients with protocol " CLIENT_VERSION_STR " allowed!", version);
		return;
	}

	if (!Protocol::RSA_decrypt(msg)) {
		disconnect();
		return;
	}

	uint32_t key[4];
	key[0] = msg.get<uint32_t>();
	key[1] = msg.get<uint32_t>();
	key[2] = msg.get<uint32_t>();
	key[3] = msg.get<uint32_t>();
	enableXTEAEncryption();
	setXTEAKey(key);

	if (version < CLIENT_VERSION_MIN || version > CLIENT_VERSION_MAX) {
		disconnectClient("Only clients with protocol " CLIENT_VERSION_STR " allowed!", version);
		return;
	}

	if (g_game.getGameState() == GAME_STATE_STARTUP) {
		disconnectClient("Gameworld is starting up. Please wait.", version);
		return;
	}

	if (g_game.getGameState() == GAME_STATE_MAINTAIN) {
		disconnectClient("Gameworld is under maintenance.\nPlease re-connect in a while.", version);
		return;
	}

	BanInfo banInfo;
	auto connection = getConnection();
	if (!connection) {
		return;
	}

	if (IOBan::isIpBanned(connection->getIP(), banInfo)) {
		if (banInfo.reason.empty()) {
			banInfo.reason = "(none)";
		}

		std::ostringstream ss;
		ss << "Your IP has been banned until " << formatDateShort(banInfo.expiresAt) << " by " << banInfo.bannedBy << ".\n\nReason specified:\n" << banInfo.reason;
		disconnectClient(ss.str(), version);
		return;
	}

	std::string accountName = msg.getString();
	std::string password = msg.getString();
	auto thisPtr = std::static_pointer_cast<ProtocolLogin>(shared_from_this());
	if (accountName.empty()) {
		if (g_config.getBoolean(ConfigManager::ENABLE_LIVE_CASTING)) {
			g_dispatcher.addTask(createTask(std::bind(&ProtocolLogin::getCastingStreamsList, thisPtr, password, version)));
		}
		else {
			disconnectClient("Invalid account name.", version);
		}
		return;
	}

	g_dispatcher.addTask(createTask(std::bind(&ProtocolLogin::getCharacterList, thisPtr, accountName, password, version)));
}