dofile('data/lib/lib.lua')
dofile('data/vip-system.lua')
dofile('data/AI_catmageboss.lua')
dofile('data/zombieEvent.lua')
dofile('data/lib/weapon_damage.lua')


NOT_MOVEABLE_ACTION = 100
LILITH_PIANO = 15108
VLAD_PASSAGE = 15109
PARTY_PROTECTION = 1 -- Set to 0 to disable.
ADVANCED_SECURE_MODE = 1 -- Set to 0 to disable.
STORAGEVALUE_PROMOTION = 30018

ropeSpots = {384, 418, 8278, 8592, 13189, 14435, 14436, 15635, 19518}

doors = {[1209] = 1211, [1210] = 1211, [1212] = 1214, [1213] = 1214, [1219] = 1220, [1221] = 1222, [1231] = 1233, [1232] = 1233, [1234] = 1236, [1235] = 1236, [1237] = 1238, [1239] = 1240, [1249] = 1251, [1250] = 1251, [1252] = 1254, [1253] = 1254, [1539] = 1540, [1541] = 1542, [3535] = 3537, [3536] = 3537, [3538] = 3539, [3544] = 3546, [3545] = 3546, [3547] = 3548, [4913] = 4915, [4914] = 4915, [4916] = 4918, [4917] = 4918, [5082] = 5083, [5084] = 5085, [5098] = 5100, [5099] = 5100, [5101] = 5102, [5107] = 5109, [5108] = 5109, [5110] = 5111, [5116] = 5118, [5117] = 5118, [5119] = 5120, [5125] = 5127, [5126] = 5127, [5128] = 5129, [5134] = 5136, [5135] = 5136, 
		[5137] = 5139, [5138] = 5139, [5140] = 5142, [5141] = 5142, [5143] = 5145, [5144] = 5145, [5278] = 5280, [5279] = 5280, [5281] = 5283, [5282] = 5283, [5284] = 5285, [5286] = 5287, [5515] = 5516, [5517] = 5518, [5732] = 5734, [5733] = 5734, [5735] = 5737, [5736] = 5737, [6192] = 6194, [6193] = 6194, [6195] = 6197, [6196] = 6197, [6198] = 6199, [6200] = 6201, [6249] = 6251, [6250] = 6251, [6252] = 6254, [6253] = 6254, [6255] = 6256, [6257] = 6258, [6795] = 6796, [6797] = 6798, [6799] = 6800, [6801] = 6802, [6891] = 6893, [6892] = 6893, [6894] = 6895, [6900] = 6902, [6901] = 6902, [6903] = 6904, [7033] = 7035, [7034] = 7035, [7036] = 7037, [7042] = 7044, 
		[7043] = 7044, [7045] = 7046, [7054] = 7055, [7056] = 7057, [8541] = 8543, [8542] = 8543, [8544] = 8546, [8545] = 8546, [8547] = 8548, [8549] = 8550, [9165] = 9167, [9166] = 9167, [9168] = 9170, [9169] = 9170, [9171] = 9172, [9173] = 9174, [9267] = 9269, [9268] = 9269, [9270] = 9272, [9271] = 9272, [9273] = 9274, [9275] = 9276, [10276] = 10277, [10274] = 10275, [10268] = 10270, [10269] = 10270, [10271] = 10273, [10272] = 10273, [10471] = 10472, [10480] = 10481, [10477] = 10479, [10478] = 10479, [10468] = 10470, [10469] = 10470, [10775] = 10777, [10776] = 10777, [12092] = 12094, [12093] = 12094, [12188] = 12190, [12189] = 12190, [19840] = 19842, [19841] = 19842, 
		[19843] = 19844, [19980] = 19982, [19981] = 19982, [19983] = 19984, [20273] = 20275, [20274] = 20275, [20276] = 20277, [17235] = 17236, [10784] = 10786, [10785] = 10786, [12099] = 12101, [12100] = 12101, [12197] = 12199, [12198] = 12199, [19849] = 19851, [19850] = 19851, [19852] = 19853, [19989] = 19991, [19990] = 19991, [19992] = 19993, [20282] = 20284, [20283] = 20284, [20285] = 20286, [17237] = 17238, [10780] = 10781, [12095] = 12096, [12195] = 12196, [12694] = 12695, [12702] = 12703, [19845] = 19846, [19985] = 19986, [20278] = 20279, [10789] = 10790, [12102] = 12103, [12204] = 12205, [19854] = 19855, [19994] = 19995, [20287] = 20288, [10782] = 10783, [12097] = 12098, 
		[12193] = 12194, [19847] = 19848, [19987] = 19988, [20280] = 20281, [10791] = 10792, [12104] = 12105, [12202] = 12203, [19856] = 19857, [19996] = 19997, [20289] = 20290, [22815] = 22816, [22817] = 22818, [22819] = 22820, [22821] = 22822, [22824] = 22825, [22826] = 22827, [22828] = 22829, [22830] = 22831, [25284] = 25285, [25286] = 225287, [25288] = 225289, [25291] = 25292, [25293] = 225294, [25295] = 25296, [26530] = 26531, [26533] = 26534, [30426] = 30427, [30429] = 30430, [31424] = 31425, [31427] = 31428, [31438] = 31439, [31441] = 31442, [31452] = 31453, [31455] = 31456, [31458] = 31459, [31461] = 31462, [31464] = 31465, [31467] = 31468, [31470] = 31471, [31473] = 31474, 
		[31476] = 31477, [31479] = 31480, [31482] = 31483, [31485] = 31486, [31485] = 31486, [31642] = 31643, [31645] = 31646, [31648] = 31649, [31651] = 31652, [31654] = 31655, [31657] = 31658, [31660] = 31661, [31663] = 31664, [31666] = 31667, [31669] = 31670, [31672] = 31673, [31675] = 31676, [31678] = 31679, [31681] = 31682, [31684] = 31685, [31687] = 31688, [31690] = 31691, [31693] = 31694, [31696] = 31697, [31699] = 31700, [31702] = 31703, [31705] = 31706, [31708] = 31709, [31711] = 31712, [31714] = 31715, [31717] = 31718, [31720] = 31721, [31723] = 31724, [31726] = 31727, [31729] = 31730, [31732] = 31733, [31735] = 31736, [31738] = 31739, [31741] = 31742, 
		[31744] = 31745, [31747] = 31748, [31750] = 31751, [31753] = 31754, [31756] = 31757, [31759] = 31760, [31762] = 31763, [31765] = 31766, [31768] = 31769, [31771] = 31772, [31774] = 31775, [31777] = 31778, [31780] = 31781, [31783] = 31784, [31786] = 31787, [31789] = 31790, [31792] = 31793, [31795] = 31796, [31798] = 31799, [31801] = 31802, [31804] = 31805, [31807] = 31808, [31810] = 31811, [31813] = 31814, [31816] = 31817, [31819] = 31820, [31822] = 31823, [31825] = 31826, [31828] = 31829, [31831] = 31832, [31834] = 31835, [31837] = 31838, [31840] = 31841, [31843] = 31844, [33753] = 33754, [33755] = 33756, [33757] = 33758, [33759] = 33760, [34128] = 34129, [34131] = 34132, 
		[34189] = 34190, [34192] = 34193, [34204] = 34205, [34206] = 34207, [34208] = 34209, [34210] = 34211, [34463] = 34464, [34465] = 34466, [35767] = 35768, [35770] = 35771}

verticalOpenDoors = {1211, 1220, 1224, 1228, 1233, 1238, 1242, 1246, 1251, 1256, 1260, 1540, 3546, 3548, 3550, 3552, 4915, 5083, 5109, 5111, 5113, 5115, 5127, 5129, 5131, 5133, 5142, 5145, 5283, 5285, 5289, 5293, 5516, 5737, 5749, 6194, 6199, 6203, 6207, 6251, 6256, 6260, 6264, 6798, 6802, 6902, 6904, 6906, 6908, 7044, 7046, 7048, 7050, 7055, 8543, 8548, 8552, 8556, 9167, 9172, 9269, 9274, 9274, 9269, 9278, 9282, 10270, 10275, 10279, 10283, 10479, 10481, 10485, 10483, 10786, 12101, 12199, 12695, 13021, 19851, 19853, 19991, 19993, 20284, 20286, 17238, 13021, 10790, 12103, 12205, 19855, 19995, 20288, 10792, 12105, 12203, 19857, 19997, 20290, 22825, 22827, 22829, 22831, 25292, 25294, 25296,
					26534, 30430, 31425, 31439, 31453, 31465, 31471, 31477, 31483, 31643, 31649, 31655, 31661, 31667, 31673, 31679, 31685, 31691, 31697, 31703, 31709, 31715, 31721, 31727, 31733, 31739, 31745, 31751, 31757, 31763, 31769, 31775, 31781, 31787, 31793, 31799, 31805, 31811, 31817, 31823, 31829, 31835, 31841, 33756, 33760, 33764, 33768, 34132, 34193, 34207, 34211, 34466, 35771}

horizontalOpenDoors = {1214, 1222, 1226, 1230, 1236, 1240, 1244, 1248, 1254, 1258, 1262, 1542, 3537, 3539, 3541, 3543, 4918, 5085, 5100, 5102, 5104, 5106, 5118, 5120, 5122, 5124, 5136, 5139, 5280, 5287, 5291, 5295, 5518, 5734, 5746, 6197, 6201, 6205, 6209, 6254, 6258, 6262, 6266, 6796, 6800, 6893, 6895, 6897, 6899, 7035, 7037, 7039, 7041, 7057, 8546, 8550, 8554, 8558, 9170, 9174, 9272, 9276, 9280, 9284, 10273, 10277, 10281, 10285, 10470, 10472, 10476, 10474, 10777, 12094, 12190, 12703, 13023, 19842, 19844, 19982, 19984, 20275, 20277, 17236, 13023, 10781, 12096, 12196, 19846, 19986, 20279, 10783, 12098, 12194, 19848, 19988, 20281, 22816, 22818, 22820, 22822, 25285, 25287, 25289, 
					  26531, 30427, 31428, 31442, 31456, 31459, 31462, 31468, 31474, 31480, 31486, 31646, 31652, 31658, 31664, 31670, 31676, 31682, 31688, 31694, 31700, 31706, 31712, 31718, 31724, 31730, 31736, 31742, 31748, 31754, 31760, 31766, 31772, 31778, 31784, 31790, 31796, 31802, 31808, 31814, 31820, 31826, 31832, 31838, 31844, 33454, 33754, 33758, 33762, 33766, 34129, 34190, 34205, 34209, 34464, 35768}

openSpecialDoors = {1224, 1226, 1228, 1230, 1242, 1244, 1246, 1248, 1256, 1258, 1260, 1262, 3541, 3543, 3550, 3552, 5104, 5106, 5113, 5115, 5122, 5124, 5131, 5133, 5289, 5291, 5293, 5295, 6203, 6205, 6207, 6209, 6260, 6262, 6264, 6266, 6897, 6899, 6906, 6908, 7039, 7041, 7048, 7050, 8552, 8554, 8556, 8558, 9176, 9178, 9180, 9182, 9278, 9280, 9282, 9284, 10279, 10281, 10283, 10285, 10474, 10476, 10483, 10485, 10781, 12096, 12196, 19846, 19986, 20279, 10783, 12098, 12194, 19848, 19988, 20281, 10790, 12103, 12205, 19855, 19995, 20288, 10792, 12105, 12203, 18209, 19857, 19997, 20290, 33762, 33764, 33766, 33768}

questDoors = {1223, 1225, 1241, 1243, 1255, 1257, 3542, 3551, 5105, 5114, 5123, 5132, 5288, 5290, 5745, 5748, 6202, 6204, 6259, 6261, 6898, 6907, 7040, 7049, 8551, 8553, 9175, 9177, 9277, 9279, 10278, 10280, 10475, 10484, 10782, 12097, 12193, 19847, 19987, 20280, 10791, 12104, 12202, 19856, 19996, 20289, 22814, 22823, 25286, 25293}

levelDoors = {1227, 1229, 1245, 1247, 1259, 1261, 3540, 3549, 5103, 5112, 5121, 5130, 5292, 5294, 6206, 6208, 6263, 6265, 6896, 6905, 7038, 7047, 8555, 8557, 9179, 9181, 9281, 9283, 10282, 10284, 10473, 10482, 10780, 10789, 10780, 12095, 12195, 13020, 13022, 19845, 19985, 20278, 10789, 12102, 12204, 18208, 19854, 19994, 20287, 25288, 25295}

keys = {2086, 2087, 2088, 2089, 2090, 2091, 2092, 10032}

function getDistanceBetween(firstPosition, secondPosition)
	local xDif = math.abs(firstPosition.x - secondPosition.x)
	local yDif = math.abs(firstPosition.y - secondPosition.y)
	local posDif = math.max(xDif, yDif)
	if firstPosition.z ~= secondPosition.z then
		posDif = posDif + 15
	end
	return posDif
end

function getFormattedWorldTime()
	local worldTime = getWorldTime()
	local hours = math.floor(worldTime / 60)

	local minutes = worldTime % 60
	if minutes < 10 then
		minutes = '0' .. minutes
	end
	return hours .. ':' .. minutes
end

string.split = function(str, sep)
	local res = {}
	for v in str:gmatch("([^" .. sep .. "]+)") do
		res[#res + 1] = v
	end
	return res
end

string.trim = function(str)
	return str:match'^()%s*$' and '' or str:match'^%s*(.*%S)'
end

if nextUseStaminaTime == nil then
	nextUseStaminaTime = {}
end

function Vocation.getBase(self)
    local demotion = self:getDemotion()
    while demotion do
        local tmp = demotion:getDemotion()
        if not tmp then
            return demotion
        end
        demotion = tmp
    end
    return self
end

function isInRange(pos, fromPos, toPos)
	return pos.x >= fromPos.x and pos.y >= fromPos.y and pos.z >= fromPos.z and pos.x <= toPos.x and pos.y <= toPos.y and pos.z <= toPos.z
end

function getTibianTime()
	local worldTime = getWorldTime()
	local hours = math.floor(worldTime / 60)

	local minutes = worldTime % 60
	if minutes < 10 then
		minutes = '0' .. minutes
	end
	return hours .. ':' .. minutes
end

function getBlessingsCost(level)
	if level <= 30 then
		return 2000
	elseif level >= 120 then
		return 20000
	else
		return (level - 20) * 200
	end
end

function getPvpBlessingCost(level)
	if level <= 30 then
		return 2000
	elseif level >= 270 then
		return 50000
	else
		return (level - 20) * 200
	end
end

function table.find(tab, value)
    for i = 1, #tab do
        if tab[i] == value then
            return i
        end
    end
end

function getItemAttribute(uid, key)
   local i = ItemType(Item(uid):getId())
   local string_attributes = {
     [ITEM_ATTRIBUTE_NAME] = i:getName(),
     [ITEM_ATTRIBUTE_ARTICLE] = i:getArticle(),
     [ITEM_ATTRIBUTE_PLURALNAME] = i:getPluralName(),
     ["name"] = i:getName(),
     ["article"] = i:getArticle(),
     ["pluralname"] = i:getPluralName()
   }

   local numeric_attributes = {
     [ITEM_ATTRIBUTE_WEIGHT] = i:getWeight(),
     [ITEM_ATTRIBUTE_ATTACK] = i:getAttack(),
     [ITEM_ATTRIBUTE_DEFENSE] = i:getDefense(),
     [ITEM_ATTRIBUTE_EXTRADEFENSE] = i:getExtraDefense(),
     [ITEM_ATTRIBUTE_ARMOR] = i:getArmor(),
     [ITEM_ATTRIBUTE_HITCHANCE] = i:getHitChance(),
     [ITEM_ATTRIBUTE_SHOOTRANGE] = i:getShootRange(),
     ["weight"] = i:getWeight(),
     ["attack"] = i:getAttack(),
     ["defense"] = i:getDefense(),
     ["extradefense"] = i:getExtraDefense(),
     ["armor"] = i:getArmor(),
     ["hitchance"] = i:getHitChance(),
     ["shootrange"] = i:getShootRange()
   }
 
   local attr = Item(uid):getAttribute(key)
   if tonumber(attr) then
     if numeric_attributes[key] then
       return attr ~= 0 and attr or numeric_attributes[key]
     end
   else
     if string_attributes[key] then
       if attr == "" then
         return string_attributes[key]
       end
     end
   end
return attr
end

function doItemSetAttribute(uid, key, value)
   return Item(uid):setAttribute(key, value)
end

function doItemEraseAttribute(uid, key)
   return Item(uid):removeAttribute(key)
end


getItemInfo = getItemDescriptions

exhaustion =
{
        check = function (cid, storage)
                return getPlayerStorageValue(cid, storage) >= os.time(t)
        end,
 
        get = function (cid, storage)
                local exhaust = getPlayerStorageValue(cid, storage)
                if(exhaust > 0) then
                        local left = exhaust - os.time(t)
                        if(left >= 0) then
                                return left
                        end
                end
 
                return false
        end,
 
        set = function (cid, storage, time)
                setPlayerStorageValue(cid, storage, os.time(t) + time)
        end,
 
        make = function (cid, storage, time)
                local exhaust = exhaustion.get(cid, storage)
                if(not exhaust) then
                        exhaustion.set(cid, storage, time)
                        return true
                end
 
                return false
        end
}

function isMounted(cid)
        return getCreatureOutfit(cid).lookMount > 0
end

function Position.getNextPosition(self, direction, steps)
    steps = steps or 1
    if direction == WEST then
        self.x = self.x - steps
    elseif direction == EAST then
        self.x = self.x + steps
    elseif direction == NORTH then
        self.y = self.y - steps
    elseif direction == SOUTH then
        self.y = self.y + steps
    end
    return self
end

-- AutoLoot config
    AUTO_LOOT_MAX_ITEMS = 5
 
    -- Reserved storage
    AUTOLOOT_STORAGE_START = 10000
    AUTOLOOT_STORAGE_END = AUTOLOOT_STORAGE_START + AUTO_LOOT_MAX_ITEMS
-- AutoLoot config end

PROPOSED_STATUS = 1
MARRIED_STATUS = 2
LOOK_MARRIAGE_DESCR = true
ITEM_WEDDING_RING = 2121
ITEM_ENGRAVED_WEDDING_RING = 10502
 
function getPlayerSpouse(id)
    local resultQuery = db.storeQuery("SELECT `marriage_spouse` FROM `players` WHERE `id` = " .. db.escapeString(id))
    if resultQuery ~= false then
        local ret = result.getDataInt(resultQuery, "marriage_spouse")
        result.free(resultQuery)
        return ret
    end
    return -1
end
 
function setPlayerSpouse(id, val)
    db.query("UPDATE `players` SET `marriage_spouse` = " .. val .. " WHERE `id` = " .. id)
end
 
function getPlayerMarriageStatus(id)
    local resultQuery = db.storeQuery("SELECT `marriage_status` FROM `players` WHERE `id` = " .. db.escapeString(id))
    if resultQuery ~= false then
        local ret = result.getDataInt(resultQuery, "marriage_status")
        result.free(resultQuery)
        return ret
    end
    return -1
end
 
function setPlayerMarriageStatus(id, val)
    db.query("UPDATE `players` SET `marriage_status` = " .. val .. " WHERE `id` = " .. id)
end
 
function Player:getMarriageDescription(thing)
    local descr = ""
    if getPlayerMarriageStatus(thing:getGuid()) == MARRIED_STATUS then
        playerSpouse = getPlayerSpouse(thing:getGuid())
        if self == thing then
            descr = descr .. " You are "
        elseif thing:getSex() == PLAYERSEX_FEMALE then
            descr = descr .. " She is "
        else
            descr = descr .. " He is "
        end
        descr = descr .. "married to " .. getPlayerNameById(playerSpouse) .. '.'
    end
    return descr
end
