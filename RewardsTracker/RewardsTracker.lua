local addonId = "RewardsTracker"

local accountRewardSingle = ZO_InitializingObject:Subclass()
function accountRewardSingle:Initialize(itemLink, time)
    self.itemLink = itemLink
    self.itemId = GetItemLinkItemId(self.itemLink)
    self.time = time
end

function accountRewardSingle:GetId()
    return self.itemId
end

function accountRewardSingle:GetName()
    if self.itemName == nil then
        self.itemName = GetItemLinkName(self.itemLink)
    end
    return self.itemName
end

function accountRewardSingle:GetFormattedName()
    if self.formattedItemName == nil then
        self.formattedItemName = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, GetItemLinkDisplayQuality(self.itemLink)))
                                            :Colorize(string.format('|t24:24:%s|t %s', GetItemLinkIcon(self.itemLink), self:GetName()))
    end
    return self.formattedItemName
end

function accountRewardSingle:GetTime()
    return self.time
end

function accountRewardSingle:IsRewardItem(itemId)
    return self.itemId == itemId
end

local accountRewardMultiple = ZO_InitializingObject:Subclass()
function accountRewardMultiple:Initialize(itemLinks, time, name)
    self.itemId = 0
    self.itemLinks = {}
    for _, itemLink in ipairs(itemLinks) do
        local itemId = GetItemLinkItemId(itemLink)
        if self.itemId == 0 or itemId < self.itemId then
            self.itemId = itemId
        end
        self.itemLinks[itemId] = itemLink
    end

    self.itemLink = self.itemLinks[self.itemId]
    self.itemName = name

    self.time = time
end

function accountRewardMultiple:GetId()
    return self.itemId
end

function accountRewardMultiple:GetName()
    if self.itemName == nil then
        self.itemName = GetItemLinkName(self.itemLink)
    end
    return self.itemName
end

function accountRewardMultiple:GetFormattedName()
    if self.formattedItemName == nil then
        self.formattedItemName = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, GetItemLinkDisplayQuality(self.itemLink)))
                                            :Colorize(string.format('|t24:24:%s|t %s', GetItemLinkIcon(self.itemLink), self:GetName()))
    end
    return self.formattedItemName
end

function accountRewardMultiple:GetTime()
    return self.time
end

function accountRewardMultiple:IsRewardItem(itemId)
    return self.itemLinks[itemId] ~= nil
end

local weeklyTrialReward = ZO_InitializingObject:Subclass()
function weeklyTrialReward:Initialize(itemIds, abbrName, fullName)
    self.itemIds = itemIds
    self.itemIdsSet = ZO_CreateSetFromArguments(unpack(itemIds))
    self.abbrName = abbrName
    self.fullName = fullName
    self.time = 7 * ZO_ONE_DAY_IN_SECONDS
end

function weeklyTrialReward:GetId()
    return self.abbrName
end

function weeklyTrialReward:GetAbbrName()
    return self.abbrName
end

function weeklyTrialReward:GetFullName()
    return self.fullName
end

function weeklyTrialReward:GetTime()
    return self.time
end

function weeklyTrialReward:IsRewardItem(itemId)
    return self.itemIdsSet[itemId] == true
end

local timerReward = ZO_InitializingObject:Subclass()
function timerReward:Initialize(abbrName, fullName)
    self.abbrName = abbrName
    self.fullName = fullName
    self.time = nil
end

function timerReward:GetId()
    return self.abbrName
end

function timerReward:GetAbbrName()
    return self.abbrName
end

function timerReward:GetFullName()
    return self.fullName
end

function timerReward:GetTime()
    return self.time
end

function timerReward:IsRewardItem(itemId)
    return false
end

local addon = ZO_InitializingObject:Subclass()
function addon:Initialize(name)
    self.name = name
    self.data = {
        characterRewards = LibSimpleSavedVars:NewCharacterWide(string.format("%sCharacterRewardsData", self.name), 1, {}),
        accountRewards = LibSimpleSavedVars:NewAccountWide(string.format("%sAccountRewardsData", self.name), 1, {}),
    }
    self.addonData = self:getAddonData()

    self.characterRewards = {
        weeklyTrialReward:New({ 81187, 81188, 87705, 87706, 139666, 139667 }, "so", GetString(SI_REWARDS_TRACKER_SO)),
        weeklyTrialReward:New({ 87702, 87707, 139664, 139668 }, "aa", GetString(SI_REWARDS_TRACKER_AA)),
        weeklyTrialReward:New({ 87703, 87708, 139665, 139669 }, "hrc", GetString(SI_REWARDS_TRACKER_HRC)),
        weeklyTrialReward:New({ 94089, 94090, 139670, 139671 }, "mol", GetString(SI_REWARDS_TRACKER_MOL)),
        weeklyTrialReward:New({ 126130, 126131, 139672, 139673 }, "hof", GetString(SI_REWARDS_TRACKER_HOF)),
        weeklyTrialReward:New({ 134585, 134586, 139674, 139675 }, "as", GetString(SI_REWARDS_TRACKER_AS)),
        weeklyTrialReward:New({ 138711, 138712, 141738, 141739 }, "cr", GetString(SI_REWARDS_TRACKER_CR)),
        weeklyTrialReward:New({ 151970, 151971 }, "ss", GetString(SI_REWARDS_TRACKER_SS)),
        weeklyTrialReward:New({ 165421, 165422 }, "ka", GetString(SI_REWARDS_TRACKER_KA)),
        weeklyTrialReward:New({ 176054, 176055 }, "rg", GetString(SI_REWARDS_TRACKER_RG)),
        timerReward:New("rd", GetString(SI_REWARDS_TRACKER_RD)),
        timerReward:New("rb", GetString(SI_REWARDS_TRACKER_RB)),
        timerReward:New("shs", GetString(SI_REWARDS_TRACKER_SHS)),
    }

    local shieldOfSenchalMotives = {}
    for i = 156627, 156641 do
        table.insert(shieldOfSenchalMotives, string.format('|H1:item:%d:5:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h', i))
    end
    local newMoonMotives = {}
    for i = 156608, 156622 do
        table.insert(newMoonMotives, string.format('|H1:item:%d:5:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h', i))
    end
    local seaGiantMotives = {}
    for i = 160559, 160573 do
        table.insert(seaGiantMotives, string.format('|H1:item:%d:5:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h', i))
    end
    local nighthollowMotives = {}
    for i = 167943, 167957 do
        table.insert(nighthollowMotives, string.format('|H1:item:%d:5:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h', i))
    end
    local waywardMotives = {}
    for i = 167977, 167991 do
        table.insert(waywardMotives, string.format('|H1:item:%d:5:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h', i))
    end
    local ivoryBrigadeMotives = {}
    for i = 171895, 171909 do
        table.insert(ivoryBrigadeMotives, string.format('|H1:item:%d:5:1:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h', i))
    end

    self.accountRewards = {
        -- geode
        accountRewardSingle:New('|H1:item:134618:124:1:0:0:0:5:10000:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h', 20 * ZO_ONE_HOUR_IN_SECONDS),
        -- 20 Runebox: Reach-Mage Ceremonial Skullcap 500-600k
        -- 20 Random Armor Style Page: Knight of the Circle 100-1100k
        -- 20 Runebox: Arena Gladiator Helm 200-400k
        -- 30 Runebox: Arena Gladiator Emote 500k
        -- 40 Random Weapon Style Page: Knight of the Circle 400-1700k
        -- 40 Runebox: Elinhir Arena Lion 800-1100k
        -- 50 Runebox: Arena Gladiator Costume 1200-1600k
        -- arena gladiators proof
        accountRewardSingle:New('|H1:item:138783:5:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h', 20 * ZO_ONE_HOUR_IN_SECONDS),
        -- 20 Runebox: Siegemaster's Close Helm 200-300k
        -- 50 Runebox: Siegemaster's Uniform 1200-1600k
        -- 50 Runebox: Timbercrow Wanderer Costume 3300-4200k
        -- siege of cyrodiil merit
        accountRewardSingle:New('|H1:item:151939:5:1:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h', 20 * ZO_ONE_HOUR_IN_SECONDS),
        --accountRewardMultiple:New(shieldOfSenchalMotives, 24 * ZO_ONE_HOUR_IN_SECONDS, GetString(SI_REWARDS_TRACKER_CM80)),
        accountRewardMultiple:New(newMoonMotives, 24 * ZO_ONE_HOUR_IN_SECONDS, GetString(SI_REWARDS_TRACKER_CM81)),
        accountRewardMultiple:New(seaGiantMotives, 20 * ZO_ONE_HOUR_IN_SECONDS, GetString(SI_REWARDS_TRACKER_CM86)),
        --accountRewardMultiple:New(nighthollowMotives, 20 * ZO_ONE_HOUR_IN_SECONDS, GetString(SI_REWARDS_TRACKER_CM95)),
        accountRewardMultiple:New(waywardMotives, 20 * ZO_ONE_HOUR_IN_SECONDS, GetString(SI_REWARDS_TRACKER_CM97)),
        accountRewardMultiple:New(ivoryBrigadeMotives, 20 * ZO_ONE_HOUR_IN_SECONDS, GetString(SI_REWARDS_TRACKER_CM101)),
    }

    self.settings = rewardsTrackerSettings:New(self)
    self.campaign = rewardsTrackerCampaign:New(self)
    self.opener = rewardsTrackerOpener:New(self)
    --self.hireling = rewardsTrackerHireling:New(self)

    self.control = RewardsTrackerContainer

    self:updateTimers()

    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_LOOT_RECEIVED, function(eventCode, receivedBy, itemName, quantity, soundCategory, lootType, isMe, isPickpocketLoot, questItemIcon, itemId, isStolen)
        if isMe == false or lootType ~= LOOT_TYPE_ITEM then
            return
        end

        for _, _characterReward in ipairs(self.characterRewards) do
            if _characterReward:IsRewardItem(itemId) then
                self.data.characterRewards[_characterReward:GetId()] = os.time() + _characterReward:GetTime()
            end
        end

        for _, _accountReward in ipairs(self.accountRewards) do
            if _accountReward:IsRewardItem(itemId) then
                self.data.accountRewards[_accountReward:GetId()] = os.time() + _accountReward:GetTime()
            end
        end
    end)

    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_ACTIVITY_FINDER_COOLDOWNS_UPDATE, function(eventCode)
        self:updateTimers()
    end)

    self.characterList = self:createCharacterList(self.control:GetNamedChild("Character"))
    self.accountList = self:createAccountList(self.control:GetNamedChild("Account"))
    self.scene = self:createScene(string.format("%sScene", self.name), self.control)

    zo_callLater(function()
        self:notifications()
    end, 20000)

    SLASH_COMMANDS["/rewards-tracker"] = function(cmd)
        if cmd == "" then
            self:ToggleUi()
        end
    end
end

function addon:getAddonData()
    for index = 1, GetAddOnManager():GetNumAddOns() do
        local name, title, author, description, enabled, state, isOutOfDate, isLibrary = GetAddOnManager():GetAddOnInfo(index)
        if name == self.name then
            return {
                name = name,
                title = title,
                author = author,
                version = GetAddOnManager():GetAddOnVersion(index),
                directoryPath = GetAddOnManager():GetAddOnRootDirectoryPath(index)
            }
        end
    end

    return nil
end

function addon:ToggleUi()
    SCENE_MANAGER:Toggle(self.scene:GetName())
end

function addon:createScene(name, control)
    local scene = ZO_Scene:New(name, SCENE_MANAGER)

    scene:AddFragment(FRAME_EMOTE_FRAGMENT_JOURNAL)
    scene:AddFragment(CODEX_WINDOW_SOUNDS)
    scene:AddFragmentGroup(FRAGMENT_GROUP.MOUSE_DRIVEN_UI_WINDOW)
    scene:AddFragmentGroup(FRAGMENT_GROUP.FRAME_TARGET_STANDARD_RIGHT_PANEL)

    if control then
        scene:AddFragment(ZO_FadeSceneFragment:New(control))
    end

    scene:RegisterCallback("StateChange", function(oldState, newState)
        if newState == SCENE_SHOWING then
            self.characterList:RefreshData()
            self.accountList:RefreshData()

            local characterRows = #ZO_ScrollList_GetDataList(self.characterList.list)
            if characterRows == 0 then
                characterRows = 1
            end
            local characterHeight = 16 * 2 + 32 + 30 * characterRows

            local accountRows = #ZO_ScrollList_GetDataList(self.accountList.list)
            if accountRows == 0 then
                accountRows = 1
            end
            local accountHeight = 16 * 2 + 30 * accountRows

            self.characterList.control:SetHeight(characterHeight)
            self.accountList.control:SetHeight(accountHeight)

            self.control:SetWidth(self.characterList.control:GetWidth())
        end
    end)

    return scene
end

function addon:notifications()
    local function message(title, content)
        local messageParams = CENTER_SCREEN_ANNOUNCE:CreateMessageParams(CSA_CATEGORY_LARGE_TEXT, SOUNDS.CHAMPION_POINTS_COMMITTED)
        messageParams:SetCSAType(CENTER_SCREEN_ANNOUNCE_TYPE_DISPLAY_ANNOUNCEMENT)
        messageParams:SetText(string.format("%s: %s", title, content))
        CENTER_SCREEN_ANNOUNCE:AddMessageWithParams(messageParams)
    end

    local function check()
        local now = os.time()

        for _, _accountReward in ipairs(self.accountRewards) do
            if self.settings.data.notifications[_accountReward:GetId()] == true then
                local time = self.data.accountRewards[_accountReward:GetId()]
                if time == nil or time < now then
                    message(self:getAddonData().title, _accountReward:GetName())
                end
            end
        end
    end

    check()
    EVENT_MANAGER:RegisterForUpdate(self.name .. "Notifications", 1 * ZO_ONE_HOUR_IN_SECONDS * 1000, check)
end

function addon:updateTimers()
    self.data.characterRewards.rd = os.time() + GetLFGCooldownTimeRemainingSeconds(LFG_COOLDOWN_DUNGEON_REWARD_GRANTED)
    self.data.characterRewards.rb = os.time() + GetLFGCooldownTimeRemainingSeconds(LFG_COOLDOWN_BATTLEGROUND_REWARD_GRANTED)
    self.data.characterRewards.shs = os.time() + GetTimeToShadowyConnectionsResetInSeconds()
end

local REWARDS_TRACKER_CHARACTER_DATA_TYPE = 18
local REWARDS_TRACKER_ACCOUNT_DATA_TYPE = 19

function addon:createCharacterList(control)
    local headers = control:GetNamedChild("Headers")
    local nameHeader = headers:GetNamedChild("Name")
    local previousHeader = nameHeader
    local colWidth = 80
    local rewardsCount = 0
    for _, _characterReward in ipairs(self.characterRewards) do
        if headers:GetNamedChild(_characterReward:GetId()) == nil and self.settings.data.timers[_characterReward:GetId()] == true then
            local header = GetWindowManager()
                :CreateControlFromVirtual(string.format("$(parent)%s", _characterReward:GetId()), headers, "RewardsTrackerListHeaderWithBG")
            header:SetDimensions(200, 32)
            header:SetAnchor(TOPLEFT, nameHeader, BOTTOMRIGHT, 30 + colWidth * rewardsCount, -80)

            header:GetNamedChild("Name"):SetText(_characterReward:GetFullName())
            header:GetNamedChild("Name"):SetHorizontalAlignment(TEXT_ALIGN_LEFT)
            --header:GetNamedChild("Name"):SetFont("ZoFontGameLargeBold")

            header:SetTransformRotationZ(math.rad(30))

            previousHeader = header
            rewardsCount = rewardsCount + 1
        end
    end

    control:SetWidth(16 + 300 + colWidth * rewardsCount + 16)

    local list = ZO_SortFilterList:New(control)

    list.owner = self

    ZO_ScrollList_EnableHighlight(list.list, "ZO_ThinListHighlight")

    list:SetAlternateRowBackgrounds(true)
    list:SetEmptyText("No data")

    list.currentSortKey = "name"
    list.currentSortOrder = ZO_SORT_ORDER_UP

    list.sortFunction = function(row1, row2)
        return ZO_TableOrderingFunction(
            row1.data, row2.data,
            list.currentSortKey,
            {
                ["name"] = {},
            }, list.currentSortOrder
        )
    end

    local colorText = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_VALUE))
    ZO_ScrollList_AddDataType(list.list, REWARDS_TRACKER_CHARACTER_DATA_TYPE, "RewardsTrackerListRow", 30, function(row, data)
        list:SetupRow(row, data)

        row:SetWidth(colWidth * rewardsCount + 300)

        local previousCell = row:GetNamedChild("Name")
        for _, _characterReward in ipairs(self.characterRewards) do
            if row:GetNamedChild(_characterReward:GetId()) == nil and list.owner.settings.data.timers[_characterReward:GetId()] == true then
                local cell = GetWindowManager()
                    :CreateControlFromVirtual(string.format("$(parent)%s", _characterReward:GetId()), row, "RewardsTrackerListRowTimer")
                cell:SetDimensions(colWidth, 30)
                cell:SetAnchor(TOPLEFT, previousCell, TOPRIGHT, 0, 0)
                previousCell = cell
            end
        end

        row.data = data

        row.name = row:GetNamedChild("Name")
        row.name:SetText(data.formattedName)

        for _, _characterReward in ipairs(self.characterRewards) do
            if list.owner.settings.data.timers[_characterReward:GetId()] == true then
                row:GetNamedChild(_characterReward:GetId()):SetText(row.data[_characterReward:GetId()])
            end
        end

        for i = 1, row:GetNumChildren() do
            local child = row:GetChild(i)
            if child and child:GetType() == CT_LABEL then
                child.normalColor = colorText
            end
        end
    end)

    list.masterList = {}
    function list:BuildMasterList()
    end

    function list:FilterScrollList()
        local scrollData = ZO_ScrollList_GetDataList(self.list)
        ZO_ClearNumericallyIndexedTable(scrollData)

        for characterId, characterData in pairs(LibSimpleSavedVars:GetAccountData(string.format("%sCharacterRewardsData", self.owner.name))) do
            if LibCharacter:Exists(characterId) then
                local character = LibCharacter:GetCharacter(characterId)
                local rowData = {
                    name = character.name,
                    formattedName = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_ALLIANCE, character.alliance)):Colorize(string.format('|t32:32:%s|t %s', GetClassIcon(character.classId), character.name)),
                }

                for _, _characterReward in ipairs(self.owner.characterRewards) do
                    if self.owner.settings.data.timers[_characterReward:GetId()] == true then
                        rowData[_characterReward:GetId()] = self.owner:formatTime(characterData[_characterReward:GetId()])
                    end
                end

                table.insert(scrollData, ZO_ScrollList_CreateDataEntry(REWARDS_TRACKER_CHARACTER_DATA_TYPE, rowData))
            end
        end
    end

    function list:SortScrollList()
        local scrollData = ZO_ScrollList_GetDataList(self.list)
        table.sort(scrollData, self.sortFunction)
    end

    return list
end

function addon:createAccountList(control)
    local list = ZO_SortFilterList:New(control)

    list.owner = self

    ZO_ScrollList_EnableHighlight(list.list, "ZO_ThinListHighlight")

    list:SetAlternateRowBackgrounds(true)
    list:SetEmptyText("No data")

    list.currentSortKey = "name"
    list.currentSortOrder = ZO_SORT_ORDER_UP

    list.sortFunction = function(row1, row2)
        return ZO_TableOrderingFunction(
            row1.data, row2.data,
            list.currentSortKey,
            {
                ["name"] = {},
            }, list.currentSortOrder
        )
    end

    local colorText = ZO_ColorDef:New(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_VALUE))
    ZO_ScrollList_AddDataType(list.list, REWARDS_TRACKER_ACCOUNT_DATA_TYPE, "RewardsTrackerListRow", 30, function(row, data, listControl)
        list:SetupRow(row, data)

        if row:GetNamedChild("Timer") == nil then
            GetWindowManager()
                :CreateControlFromVirtual("$(parent)Timer", row, "RewardsTrackerListRowTimer")
                :SetAnchor(TOPLEFT, row:GetNamedChild("Name"), TOPRIGHT, 0, 0)
        end

        row.data = data

        row.name = row:GetNamedChild("Name")
        row.timer = row:GetNamedChild("Timer")

        row.name:SetText(data.formattedName)
        row.timer:SetText(data.timer)

        for i = 1, row:GetNumChildren() do
            local child = row:GetChild(i)
            if child and child:GetType() == CT_LABEL then
                child.normalColor = colorText
            end
        end
    end)

    list.masterList = {}
    function list:BuildMasterList()
    end

    function list:FilterScrollList()
        local scrollData = ZO_ScrollList_GetDataList(self.list)
        ZO_ClearNumericallyIndexedTable(scrollData)

        for _, _accountReward in ipairs(self.owner.accountRewards) do
            if self.owner.settings.data.timers[_accountReward:GetId()] == true then
                table.insert(scrollData, ZO_ScrollList_CreateDataEntry(REWARDS_TRACKER_ACCOUNT_DATA_TYPE, {
                    name = _accountReward:GetName(),
                    formattedName = _accountReward:GetFormattedName(),
                    timer = self.owner:formatTime(self.owner.data.accountRewards[_accountReward:GetId()])
                }))
            end
        end
    end

    function list:SortScrollList()
        local scrollData = ZO_ScrollList_GetDataList(self.list)
        table.sort(scrollData, self.sortFunction)
    end

    return list
end

function addon:formatTime(time)
    local now = os.time()

    -- time = os.time() + 2*60*60*24

    if time == nil then
        return "-"
    end

    if time < now then
        return "-"
    end

    local diff = time - now

    return ZO_FormatTime(diff, TIME_FORMAT_STYLE_COLONS, TIME_FORMAT_PRECISION_SECONDS, TIME_FORMAT_DIRECTION_DESCENDING)
end

EVENT_MANAGER:RegisterForEvent(addonId, EVENT_ADD_ON_LOADED, function(event, addonName)
    if addonName ~= addonId then
        return
    end
    assert(not _G[addonId], string.format("'%s' has already been loaded", addonId))
    _G[addonId] = addon:New(addonId)
    EVENT_MANAGER:UnregisterForEvent(addonId, EVENT_ADD_ON_LOADED)
end)
