local Teleport = FasterTravel.Teleport or {}
local Utils = FasterTravel.Utils
local LocationData = FasterTravel.Location.Data

-- cache for formatted zone names
local _zoneNameCache = {}

local function GetZoneName(zoneName)
    if Utils.stringIsEmpty(zoneName) == true then return zoneName end
    local localeName = _zoneNameCache[zoneName]
    if localeName == nil then
        localeName = Utils.FormatStringCurrentLanguage(zoneName)
        _zoneNameCache[zoneName] = localeName
    end
    return localeName
end

local function GetGuildPlayers(guildId)
    if guildId == nil then return {} end

    local tbl = {}

    local playerIndex = GetPlayerGuildMemberIndex(guildId)
    for i = 1, GetNumGuildMembers(guildId) do
        if i ~= playerIndex then
            local name, note, rankIndex, playerStatus, secsSinceLogoff = GetGuildMemberInfo(guildId, i)
            if playerStatus ~= PLAYER_STATUS_OFFLINE and secsSinceLogoff == 0 then
                local hasChar, charName, zoneName, classtype, alliance = GetGuildMemberCharacterInfo(guildId, i)
                if hasChar == true then
                    zoneName = GetZoneName(zoneName)
                    table.insert(tbl, { tag = name, zoneName = zoneName, name = charName })
                end
            end
        end
    end

    -- table.sort(tbl, function(x, y) return x.name < y.name end)
    return tbl
end

-- get a table of zoneName-> array of {tag, name, zoneName, alliance} from guilds
local function GetZonesGuildLookup()
    local returnValue = {}
    local gCount = GetNumGuilds()
    local pCount = 0
    local cCount = 0

    -- local pAlliance = GetUnitAlliance("player")
    local pName = string.lower(GetDisplayName())

    local id

    for g = 1, gCount do

        id = GetGuildId(g)

        pCount = GetNumGuildMembers(id)

        for p = 1, pCount do
	    local playerName, note, rankindex, playerStatus, secsSinceLogoff = GetGuildMemberInfo(id, p)
            -- only get players that are online >_<
	    if playerStatus ~= PLAYER_STATUS_OFFLINE and secsSinceLogoff == 0 and pName ~= string.lower(playerName) then
                local hasChar, charName, zoneName, classtype, alliance = GetGuildMemberCharacterInfo(id, p)

                --if hasChar == true and alliance == pAlliance then
                if hasChar == true then
                    zoneName = GetZoneName(zoneName)
                    local lowerZoneName = string.lower(zoneName)
                    returnValue[lowerZoneName] = returnValue[lowerZoneName] or {}
                    table.insert(returnValue[lowerZoneName],
                        {
                            tag = playerName,
                            zoneName = zoneName,
                            alliance = alliance,
                            name = charName
                        })
                end
            end
        end
    end
    return returnValue
end

-- get a table of {displayName,zoneName,alliance} from friends list
local function GetFriendsInfo()
    local returnValue = {}
    local fCount = GetNumFriends()

    for i = 1, fCount do
		local displayName, note, playerstatus, secsSinceLogoff = GetFriendInfo(i)

        -- only get players that are online >_<
		if playerstatus ~= PLAYER_STATUS_OFFLINE and secsSinceLogoff == 0 then

            local hasChar, charName, zoneName, classtype, alliance = GetFriendCharacterInfo(i)
            -- if hasChar == true and pAlliance == alliance then
            if hasChar == true then
                zoneName = GetZoneName(zoneName)
                table.insert(returnValue, { tag = displayName, name = charName, zoneName = zoneName, alliance = alliance })
            end
        end
    end
    return returnValue
end


-- get a table of {playerName?,zoneName,alliance,groupLeader} from group list
local function GetGroupInfo()
    local returnValue = {}

    local gCount = GetGroupSize()

    local pChar = string.lower(GetUnitName("player"))

    for i = 1, gCount do
        local unitTag = GetGroupUnitTagByIndex(i)
        local unitName = GetUnitName(unitTag)
        -- only get players that are online >_<
        if unitTag ~= nil and IsUnitOnline(unitTag) and string.lower(unitName) ~= pChar then
            local zoneName = GetUnitZone(unitTag)
            table.insert(returnValue, {
                name = unitName, -- Character nickname
                zoneName = GetZoneName(zoneName),
                alliance = GetUnitAlliance(unitTag),
                isLeader = IsUnitGroupLeader(unitTag),
                charName = GetUniqueNameForCharacter(unitName),
                tag = unitTag, -- Format: group{index}
            })
        end
    end

    return returnValue
end

local function IsPlayerReallyInGroup(playerName)
    local gCount = GetGroupSize()
    local pName = string.lower(playerName)

    for i = 1, gCount do
        local unitTag = GetGroupUnitTagByIndex(i)
        -- only get players that are online >_<
        if unitTag ~= nil and string.lower(GetUnitName(unitTag)) == pName then
            return true
        end
    end
    return IsPlayerInGroup(playerName)
end

-- search all guilds for playerName
local function IsPlayerInGuild(playerName)
    local gCount = GetNumGuilds()

    local pCount = 0
    local id
    for g = 1, gCount do

        id = GetGuildId(g)
        pCount = GetNumGuildMembers(id)

        for p = 1, pCount do
            local name = GetGuildMemberInfo(id, p)
            if string.lower(playerName) == string.lower(name) then
                return true
            end
        end
    end
    return false
end

local function IsCurrentPlayerName(playerName)
    local unitName = GetUnitName("player")
    return string.lower(playerName) == string.lower(unitName)
end

local function IsPlayerTeleportable(destination)
    if destination == nil then return false end
    local unitName = GetUnitName(string.lower(destination))
    Utils.chat(3, "Check teleportable: %s, %s", destination, unitName)
    if not Utils.stringIsEmpty(unitName) then
        return not IsCurrentPlayerName(destination)
                and (IsPlayerReallyInGroup(unitName) or IsFriend(unitName) or IsPlayerInGuild(unitName))
    else
        -- Not a player with recognizable tag.
        return false
    end
end

-- Tries to teleport to player by his login. For guildmate or friend name.
local function TeleportToPlayerByLogin(login)
    if login == nil then
		Utils.chat(3, "Empty player name to travel to.")
		return false 
	end
    Utils.chat(3, "Trying player named %s", login)
    local jumpFunction
    if IsFriend(login) then
        jumpFunction = JumpToFriend
    elseif IsPlayerInGuild(login) then
        jumpFunction = JumpToGuildMember
    else
        return false, login
    end
	Utils.chat(2, "Teleporting to player %s", Utils.bold(login))
    jumpFunction(login)
    return true, login
end

local function TeleportToPlayer(tag)
    if tag == nil then
        Utils.chat(3, "Empty player tag")
        return false, nil
    end
    local mateName = GetUnitName(tag)
	if mateName ~= "" and GetGroupIndexByUnitTag(tag) then
        Utils.chat(3, "Try tag %s, mateName %s", tag, mateName)
        -- player var contains group tag
        JumpToGroupMember(mateName)
        return true, mateName
    else
        return TeleportToPlayerByLogin(tag)
    end
end

local function TeleportToGroup()
    local target = nil
    local leaderTag = GetGroupLeaderUnitTag()
	if leaderTag == "" then
		Utils.chat(1, "Not in group")
		return false, nil
	elseif IsCurrentPlayerName(GetUnitName(leaderTag)) then
		-- you're the leader
        local groupInfo = GetGroupInfo()
		for _, player in ipairs(groupInfo) do
			if player and not IsCurrentPlayerName(player.name) then
				Utils.chat(3, "Player: %s Tag: %s CanJump: %s", player.name, player.tag,
					(CanJumpToGroupMember(player.tag) and "yes" or "no"))
				target = player.tag
				break
			end
		end
        if Utils.stringIsEmpty(target) then
			Utils.chat(2, "Failed to find group member")
		end
	else
        -- Another player is a leader.
        target = leaderTag
    end
    Utils.chat(3, "group target %s", target)
	return TeleportToPlayer(target)
end

local function IsPartialMatch(lowerZoneName, lowerKey)

    local strippedKey = lowerKey:gsub('%W', '')
    -- matches without punctuation
    if lowerZoneName == strippedKey then return true end
    --  key starts with string
    return string.sub(strippedKey, 1, string.len(lowerZoneName)) == lowerZoneName
end

local function checkPartialMatch(partialKey, name)
    if name then
        local index = string.find(string.lower(name), partialKey)
        Utils.chat(4, "Name: %s Key: %s Match found: %s", name, partialKey, (index or "false"))
		if index ~= nil then
			return true
		end
    end
    Utils.chat(4, "Name empty, no match.")
    return false
end

local function ExpandZoneName(zoneName)
	local zonesList = LocationData.GetList()
	local lowerZoneName = string.lower(zoneName)
	for k, v in pairs(zonesList) do
		if string.lower(v.name) == lowerZoneName then 
			return lowerZoneName
		end
	end
	for k, v in pairs(zonesList) do
		if checkPartialMatch(lowerZoneName, v.name) then 
            Utils.chat(2, "%s expanded to %s", Utils.bold(zoneName), Utils.bold(v.name))
			return string.lower(v.name)
		end
	end
	return lowerZoneName
end

local function GetClosestGuildLookup(lowerZoneName)
    local lookups = GetZonesGuildLookup()
	local expandedZoneName = ExpandZoneName(lowerZoneName)
	return lookups[expandedZoneName]
end

local function GetRandomGuildLookup()
    local lookups = GetZonesGuildLookup()
    local k, v, result
    local maxlen = 0
    -- not really random, the zone with most guildies is selected
    for k, v in pairs(lookups)  do
        if #v > maxlen then
            maxlen = #v
            result = v
        end
    end
	return result
end

local function GetTeleportIterator(zoneName)
    local expandedZoneName
	
	local checkItem = function(item)
		return expandedZoneName == item.zoneName 
	end
	
    local function alwaysTrue(item) return true end
    
	local randomizeTable = {}
    local locTable = {}
    if zoneName then 
        expandedZoneName = ExpandZoneName(zoneName)
        Utils.copy(GetClosestGuildLookup(expandedZoneName), randomizeTable)
        Utils.copy(Utils.where(GetFriendsInfo(), checkItem), randomizeTable)
        Utils.copy(Utils.where(GetGroupInfo(), checkItem), locTable)
    else
        Utils.copy(GetRandomGuildLookup(), randomizeTable)
        Utils.copy(Utils.where(GetFriendsInfo(), alwaysTrue), randomizeTable)
        Utils.copy(Utils.where(GetGroupInfo(), alwaysTrue), locTable)
    end
    Utils.shuffle(randomizeTable, locTable)
	
    if #locTable == 0 then
        Utils.chat(3, "No possible way found for FasterTravel.")
        return nil
    end    

    local cur = 0
    local count = #locTable
    return function()
        while cur < count do
			cur = cur + 1
			local player = locTable[cur]
			if player ~= nil then
				return player
			end
		end
        return nil
    end
end

local ZoneTeleporter = FasterTravel.class()

function ZoneTeleporter:init()

    local _teleportIter
    local _teleportCallback

    local _result
    local _errorTime = 350
    local _successTime = _errorTime * 5

    local function Reset()
        _teleportIter = nil
        _teleportCallback = nil
        _result = nil
    end

    local function TeleportResult(result)
        if result == nil then return end

        local callback = _teleportCallback

        if callback ~= nil then
            callback(result)
        end
    end

    local function TryNextPlayer(reason)
        if _teleportIter ~= nil then

            local player = _teleportIter()

            if player ~= nil then
                local r = { reason = "attempt", player = _player, expiry = GetGameTimeMilliseconds() + _errorTime }
                _result = r
                Utils.chat(3, "Try player %s character %s zone %s",
                    player.tag, zo_strformat("<<1>>", player.name), player.zoneName)
                local success, playerName = TeleportToPlayerByLogin(player.tag)
                if success then
           			Utils.chat(1, "Teleporting to %s", Utils.bold(player.zoneName))
                    return true, player.zoneName
                else
                    return false
                end
            else
                TeleportResult(_result)
                Reset()
            end
        end
        return false
    end

    local _waiting = false

    local function DelayedNext(delay)
        if _waiting == true then return false end

        _waiting = true

        zo_callLater(function()

            _waiting = false

            TryNextPlayer()
        end, delay)

        return true
    end

    local function UpdateResult(result, t, message)
        local r = result
        if t <= r.expiry then
            r.success = false
            r.reason = message
        end
    end

    ZO_Alert = FasterTravel.hook(ZO_Alert, function(base, alert, sound, message, ...)

        local r = _result
        if alert ~= 0 or r == nil then -- try next player and suppress on error or call base

        elseif alert == 0 and r ~= nil then
            local t = GetGameTimeMilliseconds()
            UpdateResult(r, t, message)
            TeleportResult(_result)
            DelayedNext(_errorTime)
        end

        base(alert, sound, message, ...)
    end)

    FasterTravel.addEvent(EVENT_PLAYER_ACTIVATED, function(eventCode)
        Reset()
    end)

    self.TeleportToZone = function(self, zoneName, callback)
        _teleportIter = GetTeleportIterator(zoneName)
        if _teleportIter == nil then
            if zoneName and zoneName ~= "" then
                Utils.chat(3, "No eligible players in zone %s.", zoneName)
                if FasterTravel.settings.jumpHereBehaviour == FasterTravel.Options.JumpHereBehaviour.ASK then
                    ZO_Dialogs_ShowDialog(
                        Utils.UniqueDialogName("RandomJumpConfirmation"),
                        nil,
                        { mainTextParams = { zoneName } }
                    )
                elseif FasterTravel.settings.jumpHereBehaviour == FasterTravel.Options.JumpHereBehaviour.ALWAYS then
                    Utils.chat(1, "Attempting jump to random zone, as per Settings")
                    _teleportIter = GetTeleportIterator()
                end
            else
                Utils.chat(3, "Don't you have any friends in this game?!")
            end
        end
        _teleportCallback = callback
        return TryNextPlayer()
    end
end

local _zoneTeleporter = ZoneTeleporter()
local function TeleportToZone(zoneName)
    return _zoneTeleporter:TeleportToZone(zoneName)
end

Teleport.GetGuildPlayers = GetGuildPlayers
Teleport.GetZonesGuildLookup = GetZonesGuildLookup
Teleport.GetFriendsInfo = GetFriendsInfo
Teleport.GetGroupInfo = GetGroupInfo
Teleport.IsPlayerReallyInGroup = IsPlayerReallyInGroup
Teleport.IsPlayerInGuild = IsPlayerInGuild
Teleport.IsPlayerTeleportable = IsPlayerTeleportable
Teleport.TeleportToPlayerByLogin = TeleportToPlayerByLogin
Teleport.TeleportToPlayer = TeleportToPlayer
Teleport.TeleportToGroup = TeleportToGroup
Teleport.TeleportToZone = TeleportToZone
FasterTravel.Teleport = Teleport
