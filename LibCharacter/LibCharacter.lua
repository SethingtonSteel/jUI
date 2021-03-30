local addonId = "LibCharacter"
local addon = ZO_Object:Subclass()

function addon:New(...)
    local instance = ZO_Object.New(self)
    instance:initialize(...)
    return instance
end

function addon:initialize(name)
    self.name = name
    self.logger = LibDebugLogger(self.name)
    self.data = LibSimpleSavedVars:NewInstallationWide(string.format("%sData", self.name), 1, {
        characters = {},
    })

    self.server = GetWorldName()
    self.account = GetDisplayName()
    self.characterId = GetCurrentCharacterId()

    self.NA = "NA Megaserver"
    self.EU = "EU Megaserver"
    self.PTS = "PTS"

    self.SORT_INDEX = "index"
    self.SORT_ID = "id"
    self.SORT_NAME = "name"

    self.sortKeys = {
        --["field"] = {
        --isId64 = true,
        --isNumeric = true,
        --caseInsensitive = true,
        --tiebreaker = "id",
        --tieBreakerSortOrder = ZO_SORT_ORDER_UP,
        --reverseTiebreakerSortOrder = true,
        --},
        [self.SORT_INDEX] = {
            isNumeric = true,
            tiebreaker = self.SORT_NAME,
        },
        [self.SORT_NAME] = {
            tiebreaker = self.SORT_ID,
        },
        [self.SORT_ID] = {},
    }

    self:scanCharacters()
end

function addon:scanCharacters()
    local oldCharacters = self:GetServerCharacters()
    local oldCharacterIds = {}
    for _, character in ipairs(oldCharacters) do
        oldCharacterIds[character.id] = true
    end

    for index = 1, GetNumCharacters() do
        local character = self:getCharacterData(index)

        self.data.characters[character.id] = character

        oldCharacterIds[character.id] = nil
    end

    for characterId, _ in pairs(oldCharacterIds) do
        self.data.characters[characterId] = nil
    end
end

function addon:GetCharacters(filter, sortKey, sortOrder)
    filter = filter == nil and function(character)
        return true
    end or filter
    sortKey = sortKey == nil and self.SORT_INDEX or sortKey
    sortOrder = sortOrder == nil and ZO_SORT_ORDER_UP or sortOrder

    local characters = {}
    for _, character in pairs(self.data.characters) do
        if filter(character) then
            table.insert(characters, character)
        end
    end

    table.sort(characters, function(a, b)
        return ZO_TableOrderingFunction(a, b, sortKey, self.sortKeys, sortOrder)
    end)

    return characters
end

function addon:GetServerCharacters(server, sortKey, sortOrder)
    server = server == nil and self.server or server

    return self:GetCharacters(function(character)
        return character.server == server
    end, sortKey, sortOrder)
end

function addon:GetCharacter(characterId)
    return self.data.characters[characterId]
end

function addon:Exists(characterId)
    return self.data.characters[characterId] ~= nil
end

function addon:getCharacterData(index)
    local name, gender, level, classId, raceId, alliance, id, locationId = GetCharacterInfo(index)

    local oldCharacterData = self.data.characters[id]

    local avaRank = 0
    if id == self.characterId then
        avaRank = GetUnitAvARank("player")
    else
        if oldCharacterData ~= nil and oldCharacterData.avaRank ~= nil then
            avaRank = oldCharacterData.avaRank
        end
    end

    return {
        id = id,
        name = zo_strformat("<<1>>", name),
        rawName = name,
        gender = gender,
        level = level,
        classId = classId,
        raceId = raceId,
        alliance = alliance,
        server = self.server,
        account = self.account,
        avaRank = avaRank
    }
end

EVENT_MANAGER:RegisterForEvent(addonId, EVENT_ADD_ON_LOADED, function(event, addonName)
    if addonName ~= addonId then
        return
    end
    assert(not _G[addonId], string.format("'%s' has already been loaded", addonId))
    _G[addonId] = addon:New(addonId)
    EVENT_MANAGER:UnregisterForEvent(addonId, EVENT_ADD_ON_LOADED)
end)
