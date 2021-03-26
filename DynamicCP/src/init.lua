DynamicCP = DynamicCP or {}
DynamicCP.name = "DynamicCP"
DynamicCP.version = "0.6.4"

local defaultOptions = {
    firstTime = true,
    cp = {
        Red = {},
        Green = {},
        Blue = {},
    },
    pulldownExpanded = true,

-- user options
    hideBackground = false,
    showLabels = true,
    dockWithSpace = true,
    scale = 1.0,
    debug = false,
    showLeaveWarning = true,
    showCooldownWarning = true,
    slotStars = true,
    slotHigherStars = true,
    doubleClick = true,
    showPresetsWithCP = true,
    showPulldownPoints = false,
    showPointGainedMessage = true,
    presetsBackdropAlpha = 0.5,
    passiveLabelColor = {1, 1, 0.5},
    passiveLabelSize = 24,
    slottableLabelColor = {1, 1, 1},
    slottableLabelSize = 18,
    clusterLabelColor = {1, 0.7, 1},
    clusterLabelSize = 13,
    showTotalsLabel = true,
    quickstarsX = GuiRoot:GetWidth() / 4,
    quickstarsY = GuiRoot:GetHeight() / 4,
    selectedQuickstarTab = "Green",
    showQuickstars = true,
    lockQuickstars = false,
    quickstarsWidth = 200,
    quickstarsAlpha = 0.5,
    quickstarsScale = 1.0,
    quickstarsVertical = true,
    quickstarsMirrored = false,
    quickstarsDropdownHideSlotted = false,
    quickstarsShowOnHud = true,
    quickstarsShowOnCpScreen = false,
    quickstarsShowCooldown = true,
    quickstarsCooldownColor = {0.7, 0.7, 0.7},
}

local initialOpened = false

---------------------------------------------------------------------
-- Collect messages for displaying later when addon is not fully loaded
DynamicCP.messages = {}
function DynamicCP.dbg(msg)
    if (not msg) then return end
    if (not DynamicCP.savedOptions.debug) then return end
    if (CHAT_SYSTEM.primaryContainer) then
        d("|c6666FF[DCP]|r " .. tostring(msg))
    else
        DynamicCP.messages[#DynamicCP.messages + 1] = msg
    end
end


---------------------------------------------------------------------
-- Post Load (player loaded)
local function OnPlayerActivated(_, initial)
    -- Soft dependency on pChat because its chat restore will overwrite
    for i = 1, #DynamicCP.messages do
        if (DynamicCP.savedOptions.debug) then
            d("|c6666FF[DCPdelay]|r " .. DynamicCP.messages[i])
        end
    end
    DynamicCP.messages = {}

    -- Post load init
    DynamicCP.InitPoints()
    DynamicCP.InitQuickstars()

    if (DynamicCP.savedOptions.hideBackground) then
        local backgroundOverride = function(line) return "/esoui/art/scrying/backdrop_stars.dds" end 
        GetChampionDisciplineBackgroundTexture = backgroundOverride
        GetChampionDisciplineBackgroundGlowTexture = backgroundOverride
        GetChampionDisciplineBackgroundSelectedTexture = backgroundOverride
        GetChampionClusterBackgroundTexture = backgroundOverride
    end

    -- Hide the pulldown because it's expanded by default
    if (not DynamicCP.savedOptions.pulldownExpanded) then
        DynamicCPPulldownTabArrowExpanded:SetHidden(true)
        DynamicCPPulldownTabArrowHidden:SetHidden(false)
        DynamicCPPulldown:SetHidden(true)
        DynamicCPPulldownTab:SetAnchor(TOP, ZO_ChampionPerksActionBar, BOTTOM)
    end

    DynamicCPInfoLabel:SetHidden(not DynamicCP.savedOptions.showTotalsLabel)

    EVENT_MANAGER:UnregisterForEvent(DynamicCP.name .. "Activated", EVENT_PLAYER_ACTIVATED)
end


---------------------------------------------------------------------
-- Register events
local function RegisterEvents()
    EVENT_MANAGER:RegisterForEvent(DynamicCP.name .. "Activated", EVENT_PLAYER_ACTIVATED, OnPlayerActivated)

    EVENT_MANAGER:RegisterForEvent(DynamicCP.name .. "Purchase", EVENT_CHAMPION_PURCHASE_RESULT,
        function(eventCode, result)
            DynamicCP.OnPurchased(eventCode, result)
            DynamicCP.ClearCommittedCP() -- Invalidate the cache
            DynamicCP.ClearCommittedSlottables() -- Invalidate the cache
            DynamicCP.OnSlotsChanged()
            DynamicCP.SelectQuickstarsTab("REFRESH") -- Refresh quickstar dropdowns
            DynamicCP.QuickstarsOnPurchased(result)
        end)

    EVENT_MANAGER:RegisterForEvent(DynamicCP.name .. "Gained", EVENT_CHAMPION_POINT_GAINED,
        function(_, championPointsDelta)
            -- Show CP gained message
            if (DynamicCP.savedOptions.showPointGainedMessage) then
                CHAT_SYSTEM:AddMessage("|cAAAAAAGained "
                    .. ZO_CenterScreenAnnounce_GetEventHandler(EVENT_CHAMPION_POINT_GAINED)(1).secondaryText .. "|r")
            end

            -- Update totals label
            DynamicCPInfoLabel:SetText(string.format(
                "|cc4c19eTotal:|r |t32:32:esoui/art/champion/champion_icon_32.dds|t %d"
                .. " |t32:32:esoui/art/champion/champion_points_stamina_icon-hud-32.dds|t %d"
                .. " |t32:32:esoui/art/champion/champion_points_magicka_icon-hud-32.dds|t %d"
                .. " |t32:32:esoui/art/champion/champion_points_health_icon-hud-32.dds|t %d",
                GetPlayerChampionPointsEarned(),
                GetNumSpentChampionPoints(3) + GetNumUnspentChampionPoints(3),
                GetNumSpentChampionPoints(1) + GetNumUnspentChampionPoints(1),
                GetNumSpentChampionPoints(2) + GetNumUnspentChampionPoints(2)))
        end)

    -- I guess I have to fix it myself. This prevents the bug with star animation not being initialized
    ZO_PreHook(CHAMPION_PERKS, "OnUpdate", function()
        CHAMPION_PERKS.firstStarConfirm = false
        return false
    end)
end


---------------------------------------------------------------------
-- Initialize
local function Initialize()
    DynamicCP.savedOptions = ZO_SavedVars:NewAccountWide("DynamicCPSavedVariables", 1, "Options", defaultOptions)
    DynamicCP.dbg("Initializing...")

    -- Populate defaults only on first time, otherwise the keys will be remade even if user deletes
    if (DynamicCP.savedOptions.firstTime) then
        DynamicCP.savedOptions.cp = DynamicCP.defaultPresets
        DynamicCP.savedOptions.firstTime = false
    end

    DynamicCP:CreateSettingsMenu()
    ZO_CreateStringId("SI_BINDING_NAME_DCP_TOGGLE_MENU", "Toggle CP Preset Window")
    ZO_CreateStringId("SI_BINDING_NAME_DCP_TOGGLE_QUICKSTARS", "Toggle Quickstars Panel")
    ZO_CreateStringId("SI_BINDING_NAME_DCP_CYCLE_QUICKSTARS", "Cycle Quickstars Tab")

    RegisterEvents()

    CHAMPION_PERKS_CONSTELLATIONS_FRAGMENT:RegisterCallback("StateChange", function(oldState, newState)
        if (newState == SCENE_HIDDEN) then
            DynamicCP.OnExitedCPScreen()
            return
        end

        if (newState ~= SCENE_SHOWN) then return end
        DynamicCPPresets:SetHidden(not DynamicCP.savedOptions.showPresetsWithCP)
        DynamicCP:InitializeDropdowns() -- Call it every time in case LFG role is changed

        -- First time opened calls
        if (not initialOpened) then
            initialOpened = true
            DynamicCP.InitLabels()
            DynamicCP.InitSlottables()
            DynamicCPPresets:SetScale(DynamicCP.savedOptions.scale)
            if (DynamicCP.savedOptions.showLabels) then
                DynamicCP.RefreshLabels(true)
            end
        end
    end)

    SLASH_COMMANDS["/dcp"] = function(arg)
        if (arg == "quickstar" or arg == "quickstars" or arg == "q" or arg == "qs") then
            DynamicCP.ToggleQuickstars()
        else
            DynamicCP.TogglePresetsWindow()
        end
    end
end

---------------------------------------------------------------------
-- On load
local function OnAddOnLoaded(_, addonName)
    if (addonName == DynamicCP.name) then
        EVENT_MANAGER:UnregisterForEvent(DynamicCP.name, EVENT_ADD_ON_LOADED)
        Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(DynamicCP.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
