FasterTravel = FasterTravel or {}

local addon = {
    name = "FasterTravel",
    displayName = zo_strformat("|c40FF40Faster|r Travel"),
    author = "XanDDemoX, upyachka, Valandil, SimonIllyan",
    version = "2.5.2",
    website = "https://www.esoui.com/downloads/info1089-FasterTravelWayshrinesmenuTeleporter.html",
}
FasterTravel.addon = addon
FasterTravel.prefix = string.format("[%s]: ", addon.name)

local CALLBACK_ID_ON_WORLDMAP_CHANGED = "OnWorldMapChanged"
local CALLBACK_ID_ON_QUEST_TRACKER_TRACKING_STATE_CHANGED = "QuestTrackerTrackingStateChanged"
local _events = {}
local GROUP_ALIAS = "group"

local function GetUniqueEventId(id)
    local count = _events[id] or 0
    count = count + 1
    _events[id] = count
    return count
end

local function GetEventName(id)
    return table.concat({ addon.name, tostring(id), tostring(GetUniqueEventId(id)) }, "_")
end

local function addEvent(id, func)
    local name = GetEventName(id)
    EVENT_MANAGER:RegisterForEvent(name, id, func)
end

local function addEvents(func, ...)
    local count = select('#', ...)
    local id
    for i = 1, count do
		id = select(i, ...)
		if not id then
			df('%s element %d is nil.  Please report.', FasterTravel.prefix, i)
		else
			addEvent(id, func)
		end
    end
end

local function addCallback(id, func)
    CALLBACK_MANAGER:RegisterCallback(id, func)
end

local function removeCallback(id, func)
    CALLBACK_MANAGER:UnregisterCallback(id, func)
end

local function hook(baseFunc, newFunc)
    return function(...)
	return newFunc(baseFunc, ...)
    end
end

FasterTravel.CALLBACK_ID_ON_WORLDMAP_CHANGED = CALLBACK_ID_ON_WORLDMAP_CHANGED
FasterTravel.hook = hook
FasterTravel.addEvent = addEvent
FasterTravel.addEvents = addEvents
FasterTravel.addCallback = addCallback
FasterTravel.removeCallback = removeCallback

local function Setup()

    local Location = FasterTravel.Location
    local DropDown = FasterTravel.DropDown
    local Teleport = FasterTravel.Teleport
    local Options = FasterTravel.Options
    local Utils = FasterTravel.Utils

    local _locations, _locationsLookup
	local recentTable, favouritesTable, recentList, favouritesList 

	-- these come from xml files
    local wayshrineControl = FasterTravel_WorldMapWayshrines
    local playersControl = FasterTravel_WorldMapPlayers

    local wayshrinesTab
    local playersTab
    local questTracker
    local currentWayshrineArgs
    local currentFaction
    local locationsDirty = true

	local function getNameAndNodeIndex(v)
		return { name = v.name, nodeIndex = v.nodeIndex }
	end

    local function GetZoneLocation(...)
		return Location.Data.GetZoneLocation(_locationsLookup, ...)
    end

    local function UpdateSavedVarTable(tbl, list, func)
		local i = 0
		for v in list:items() do
			i = i + 1
			tbl[i] = func(v)
		end
    end

    local function UpdateFavouritesSavedVar()
		local favourites = {}
		UpdateSavedVarTable(favourites, favouritesList, function(v) return { nodeIndex = v.nodeIndex } end)
		FasterTravel.settings.favourites = favourites
    end

    local function UpdateRecentSavedVar()
		local recent = {}
		UpdateSavedVarTable(recent, recentList, function(v) return { nodeIndex = v.nodeIndex } end)
		FasterTravel.settings.recent = recent
    end

    local function PushRecent(nodeIndex)
		recentList:push("nodeIndex", { nodeIndex = nodeIndex })
		UpdateRecentSavedVar()
    end

    local function SetLocationsDirty()
		locationsDirty = true
    end

    local function RefreshLocationsIfRequired()
		if wayshrinesTab ~= nil and locationsDirty and wayshrinesTab:IsDirty() then
			Location.Data.UpdateLocationOrder(_locations, FasterTravel.settings.locationOrder, currentFaction)
			locationsDirty = false
		end
    end

    local function SetWayshrinesDirty()
		if wayshrinesTab == nil then return end
		wayshrinesTab:SetDirty()
    end

    local function RefreshWayshrinesIfRequired(...)
		if wayshrinesTab == nil then return end
		if wayshrinesTab:IsDirty() then
			FasterTravel.Campaign.RefreshIfRequired()
		end
		RefreshLocationsIfRequired()
		local count = select('#', ...)
		if count == 0 and currentWayshrineArgs ~= nil then
			wayshrinesTab:RefreshIfRequired(unpack(currentWayshrineArgs))
		else
			if count > 0 then
				currentWayshrineArgs = { ... }
			end
			wayshrinesTab:RefreshIfRequired(...)
		end
    end

    local function SetPlayersDirty()
		if playersTab == nil then return end
		playersTab:SetDirty()
    end

    local function RefreshPlayersIfRequired()
		if playersTab == nil then return end
		playersTab:RefreshIfRequired()
    end

    local function SetQuestsDirty()
		if questTracker == nil then return end
		questTracker:SetDirty()
    end

    local function RefreshQuestsIfRequired()
		if questTracker == nil then return end
		questTracker:RefreshIfRequired()
    end

    local function SetCurrentFaction(loc)

		local oldfaction = currentFaction

		if currentFaction == nil then
			currentFaction = GetUnitAlliance("player")
		end

		local faction = Location.Data.GetZoneFaction(loc)

		if Location.Data.IsFactionWorldOrShared(faction) == false then
			currentFaction = faction
		end

		if oldfaction ~= currentFaction then
			SetLocationsDirty()
		end
    end

    local function SetCurrentZoneMapIndexes(zoneIndex)
		if wayshrinesTab == nil then return end
		local loc = GetZoneLocation(zoneIndex)
		SetCurrentFaction(loc)
		wayshrinesTab:SetCurrentZoneMapIndexes(loc.zoneIndex, loc.mapIndex)
    end

    local function IsWorldMapHidden()
		return ZO_WorldMap:IsHidden()
    end

    local function SetLocationOrder(order)
		if FasterTravel.settings.locationOrder ~= order then
			FasterTravel.settings.locationOrder = order
			return true
		end
		return false
    end

    local function SetAllWSOrder(order)
		if FasterTravel.settings.ws_order ~= order then
			FasterTravel.settings.ws_order = order
			wayshrinesTab:SetAllWSOrder(order)
			return true
		end
		return false
    end

    local function SetLocationOrdering(func, ...)
		if func(...) == true then
			SetLocationsDirty()
			SetWayshrinesDirty()
			SetQuestsDirty()
			RefreshWayshrinesIfRequired()
			RefreshQuestsIfRequired()
			wayshrinesTab:HideAllZoneCategories()
		end
    end

    local function RefreshOrderDropDown(order)
		local sortOrderDropDown = wayshrineControl.sortOrderDropDown
		local sortOrders = FasterTravel.Options._sortOrders
		DropDown.Refresh(sortOrderDropDown, sortOrders,
			function(control, text, data)
				if data and data.item and data.item.id then
					SetLocationOrdering(SetLocationOrder, data.item.id)
				end
			end,
			function(lookup)
				return lookup[order]
			end)
    end

    local function RefreshAllWSDropDown(ws_order)
		local sortAllOrderDropDown = wayshrineControl.sortAllOrderDropDown
		local sortOrders = FasterTravel.Options._sortAllWSOrders
		DropDown.Refresh(sortAllOrderDropDown, sortOrders,
			function(control, text, data)
				if data and data.item and data.item.id then
					SetLocationOrdering(SetAllWSOrder, data.item.id)
				end
			end,
			function(lookup)
				return lookup[ws_order]
			end)
    end

    local function RefreshWayshrineDropDowns(args)
		args = args or {}
		local order = args.order or FasterTravel.settings.locationOrder
		local ws_order = args.ws_order or FasterTravel.settings.ws_order
		RefreshOrderDropDown(order)
		RefreshAllWSDropDown(ws_order)
    end

	local function RefreshAfterSettingsChange()
		SetWayshrinesDirty()
		SetLocationsDirty()
		RefreshWayshrineDropDowns()
		wayshrinesTab:SetAllWSOrder(FasterTravel.settings.ws_order)		
		wayshrinesTab:Refresh()
		wayshrinesTab:HideAllZoneCategories()
	end

	Options.Initialize(addon, RefreshAfterSettingsChange)

	recentTable = Utils.map(FasterTravel.settings.recent, getNameAndNodeIndex )
    favouritesTable = Utils.map(FasterTravel.settings.favourites, getNameAndNodeIndex )
    recentList = FasterTravel.List(recentTable, "nodeIndex", FasterTravel.settings.listlen)
    favouritesList = FasterTravel.List(favouritesTable, "nodeIndex", 100)

	-- register the "Jump Elsewhere?" dialog
	local dialogName1 = Utils.UniqueDialogName("RandomJumpConfirmation")
	ZO_Dialogs_RegisterCustomDialog(dialogName1, {
        canQueue = true,
        uniqueIdentifier = dialogName1,
        title = {
            text = GetString(FASTER_TRAVEL_DIALOG_JUMPRANDOM_TITLE),
			align = TEXT_ALIGN_CENTER
        },
        mainText = {
            text = GetString(FASTER_TRAVEL_DIALOG_JUMPRANDOM_TEXT),
			align = TEXT_ALIGN_CENTER
        },
        warning = {
            text = GetString(FASTER_TRAVEL_DIALOG_JUMPRANDOM_WARNING),
			align = TEXT_ALIGN_CENTER
        },
        buttons = {
            [1] = {
                text = SI_DIALOG_CONFIRM,
                callback = 	function ()	-- callbackYes
								Utils.chat(3, "Will try to jump to random destination")
								Teleport.TeleportToZone()
							end,
            },
            [2] = {
                text = SI_DIALOG_CANCEL,
                callback = 	function ()	-- callbackNo
								Utils.chat(3, "Random jump not confirmed")
							end,
            }
        },
        setup = function(dialog, data) end,
    })
 
    local function AddFavourite(nodeIndex)
		favouritesList:add("nodeIndex", { nodeIndex = nodeIndex })
		SetQuestsDirty()
		SetWayshrinesDirty()
		UpdateFavouritesSavedVar()
		RefreshWayshrinesIfRequired()
		RefreshQuestsIfRequired()
    end

    local function RemoveFavourite(nodeIndex)
		favouritesList:remove("nodeIndex", { nodeIndex = nodeIndex })
		SetQuestsDirty()
		SetWayshrinesDirty()
		UpdateFavouritesSavedVar()
		RefreshWayshrinesIfRequired()
		RefreshQuestsIfRequired()
    end

    -- refresh to init campaigns
    FasterTravel.Campaign.RefreshIfRequired()

    addEvent(EVENT_PLAYER_ACTIVATED, function(eventCode)
		local func = 	function()
							SetCurrentZoneMapIndexes(GetCurrentMapZoneIndex())
							currentWayshrineArgs = nil
							SetWayshrinesDirty()
							SetQuestsDirty()
						end

		local idx = GetCurrentMapIndex()

		-- handle the map changing from Tamriel
		if idx == nil or idx == 1 then
			local onChange
			onChange = function()
				func()
				removeCallback(CALLBACK_ID_ON_WORLDMAP_CHANGED, onChange)
			end
			addCallback(CALLBACK_ID_ON_WORLDMAP_CHANGED, onChange)
		else
			func()
		end
    end)

    local function StartFastTravelInteract(...)
		SetWayshrinesDirty()
		SetQuestsDirty()

		RefreshWayshrinesIfRequired(...)
		RefreshQuestsIfRequired()
		WORLD_MAP_INFO:SelectTab(FASTER_TRAVEL_MODE_WAYSHRINES)
	end

    addEvent(EVENT_START_FAST_TRAVEL_INTERACTION, function(eventCode, nodeIndex)
		StartFastTravelInteract(nodeIndex, false)
    end)

    addEvent(EVENT_START_FAST_TRAVEL_KEEP_INTERACTION, function(eventCode, nodeIndex)
		StartFastTravelInteract(nodeIndex, true)
    end)

    addEvent(EVENT_GROUP_INVITE_RESPONSE, function(eventCode, inviterName, response)
		if response == GROUP_INVITE_RESPONSE_ACCEPTED then
			SetPlayersDirty()
		end
    end)

    addEvent(EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED, function(eventCode, guildId, DisplayName, oldStatus, newStatus)
		if newStatus == PLAYER_STATUS_OFFLINE or (oldStatus == PLAYER_STATUS_OFFLINE and newStatus == PLAYER_STATUS_ONLINE) then
			SetPlayersDirty()
		end
    end)

    addEvents(function()
		currentWayshrineArgs = nil
		SetWayshrinesDirty()
		SetQuestsDirty()
		WORLD_MAP_INFO:SelectTab(FASTER_TRAVEL_MODE_PLAYERS)
    end,
	EVENT_END_FAST_TRAVEL_INTERACTION,
	EVENT_END_FAST_TRAVEL_KEEP_INTERACTION)

    addEvents(function()
		SetWayshrinesDirty()
		SetQuestsDirty()
    end,
		EVENT_FAST_TRAVEL_NETWORK_UPDATED,
		EVENT_FAST_TRAVEL_KEEP_NETWORK_UPDATED,
		EVENT_FAST_TRAVEL_KEEP_NETWORK_LINK_CHANGED,
		EVENT_CAMPAIGN_STATE_INITIALIZED,
		EVENT_CAMPAIGN_SELECTION_DATA_CHANGED,
		EVENT_CURRENT_CAMPAIGN_CHANGED,
		EVENT_ASSIGNED_CAMPAIGN_CHANGED,
--[[
	-- causes error
		EVENT_PREFERRED_CAMPAIGN_CHANGED,
]]
		EVENT_KEEPS_INITIALIZED,
		EVENT_KEEP_ALLIANCE_OWNER_CHANGED,
		EVENT_KEEP_UNDER_ATTACK_CHANGED
	)

    addEvents(function() SetPlayersDirty() end,
	EVENT_GROUP_MEMBER_JOINED, EVENT_GROUP_MEMBER_LEFT, EVENT_GROUP_MEMBER_CONNECTED_STATUS,
	EVENT_GUILD_SELF_JOINED_GUILD, EVENT_GUILD_SELF_LEFT_GUILD, EVENT_GUILD_MEMBER_ADDED, EVENT_GUILD_MEMBER_REMOVED,
	EVENT_GUILD_MEMBER_CHARACTER_ZONE_CHANGED, EVENT_FRIEND_CHARACTER_ZONE_CHANGED,
	EVENT_FRIEND_ADDED, EVENT_FRIEND_REMOVED)


	addEvents(function() SetQuestsDirty() end,
	EVENT_QUEST_ADDED, EVENT_QUEST_ADVANCED, EVENT_QUEST_REMOVED,
	EVENT_QUEST_OPTIONAL_STEP_ADVANCED, EVENT_QUEST_COMPLETE,
	EVENT_OBJECTIVES_UPDATED, EVENT_OBJECTIVE_COMPLETED, EVENT_KEEP_RESOURCE_UPDATE, EVENT_CAMPAIGN_HISTORY_WINDOW_CHANGED)

    local function RefreshQuestsIfMapVisible()
		SetQuestsDirty()
		if IsWorldMapHidden() == false then
			RefreshQuestsIfRequired()
		end
    end

    addEvents(function() RefreshQuestsIfMapVisible() end, EVENT_CAMPAIGN_QUEUE_JOINED, EVENT_CAMPAIGN_QUEUE_LEFT, EVENT_CAMPAIGN_QUEUE_POSITION_CHANGED, EVENT_KEEP_UNDER_ATTACK_CHANGED)

    addEvent(EVENT_CAMPAIGN_QUEUE_STATE_CHANGED, function(eventCode, campaignId, isGroup, state)
		if state == CAMPAIGN_QUEUE_REQUEST_STATE_CONFIRMING then
			RefreshQuestsIfMapVisible()
		else
			SetQuestsDirty()
		end
    end)

    addCallback(CALLBACK_ID_ON_WORLDMAP_CHANGED, RefreshQuestsIfMapVisible)

    -- hack for detecting tracked quest change
    FOCUSED_QUEST_TRACKER.FireCallbacks = hook(FOCUSED_QUEST_TRACKER.FireCallbacks, function(base, self, id, control, assisted, trackType, arg1, arg2)
		if base then base(self, id, control, assisted, trackType, ar1, arg2) end
		if id ~= CALLBACK_ID_ON_QUEST_TRACKER_TRACKING_STATE_CHANGED then return end
		RefreshQuestsIfMapVisible()
    end)

	-- hack for updating Recents on clicking a wayshrine ON THE MAP

	local travelDialogs = {
		FAST_TRAVEL_CONFIRM = {},
		TRAVEL_TO_HOUSE_CONFIRM = {},
		RECALL_CONFIRM = {}
	}
	-- replacement callbacks factory
	local function MyCallbackFactory(name)
		return function(dialog)
			Utils.chat(4, "Callback %s", name)
			local node = dialog.data
			if node.nodeIndex then -- is nil when travelling to house since U29
				PushRecent(node.nodeIndex)
			end
			if travelDialogs[name].saved_callback then -- call the original callback if not nil
				travelDialogs[name].saved_callback(dialog)
			end
		end
	end
	-- find the original dialogs for RECALL_CONFIRM and FAST_TRAVEL_CONFIRM
	for name, data in pairs(travelDialogs) do
		-- extract "Confirm" callbacks if any and save them
		if 	ESO_Dialogs[name] and 
			ESO_Dialogs[name].buttons and
			ESO_Dialogs[name].buttons[1] then 
				data.saved_callback = ESO_Dialogs[name].buttons[1].callback -- may be nil
		end
		-- create new callbacks
		data.my_callback = MyCallbackFactory(name)
	end
	-- PreHook function
	FasterTravel.__Hook_Checker = function(name, node, params, ...)
		Utils.chat(4, "HookChecker: %s", name)
		if travelDialogs[name] then
			Utils.chat(4, "Hook checkpoint TRAVEL")
			-- replace callbacks
			for name, data in pairs(travelDialogs) do
				if 	ESO_Dialogs[name] and 
					ESO_Dialogs[name].buttons and
					ESO_Dialogs[name].buttons[1] then 
						if ESO_Dialogs[name].buttons[1].callback ~= data.my_callback then
							if ESO_Dialogs[name].buttons[1].callback == data.saved_callback then
								ESO_Dialogs[name].buttons[1].callback = data.my_callback
							else
								Utils.chat(0,
									"Something nasty going on - who else modifies %s dialog?!",
									name
								)
							end
						end
				else --[[
					Bandits UI has an option to turn off fast travel confirmations
					which sets ESO_Dialogs[name].buttons to nil 
					but if it is in use, all travels are autoconfirmed!
					so we can add the wayshrine to Recents without further consideration
					]]--
					if node.nodeIndex then 
						PushRecent(node.nodeIndex)
					end
				end
			end
		else
			Utils.chat(4, "Hook checkpoint NON-TRAVEL")
			-- restore original callbacks
			for name, data in pairs(travelDialogs) do
				if 	ESO_Dialogs[name] and 
					ESO_Dialogs[name].buttons and
					ESO_Dialogs[name].buttons[1] then 
						if ESO_Dialogs[name].buttons[1].callback ~= data.saved_callback then
							if ESO_Dialogs[name].buttons[1].callback == data.my_callback then
								ESO_Dialogs[name].buttons[1].callback = data.saved_callback
							else
								Utils.chat(0,
									"Something nasty going on - who else modifies %s dialog?!",
									name
								)
							end
						end
				end
			end
		end
		return false -- true == I've done everything, don't call ZO_Dialogs_ShowPlatformDialog
	end

	local function EnableRecents(enabled)
		if enabled then
			ZO_PreHook("ZO_Dialogs_ShowPlatformDialog", FasterTravel.__Hook_Checker)
		else
			ZO_PreHook("ZO_Dialogs_ShowPlatformDialog", nil)
		end
	end

	EnableRecents(FasterTravel.settings.recentsEnabled)

    ZO_WorldMap.SetHidden = hook(ZO_WorldMap.SetHidden, function(base, self, value)
		base(self, value)
		if value == false then
			RefreshWayshrinesIfRequired()
			RefreshQuestsIfRequired()
			RefreshPlayersIfRequired()
		elseif value == true and wayshrinesTab ~= nil then
			wayshrinesTab:HideAllZoneCategories()
			questTracker:HideToolTip()
			ClearMenu()
		end
    end)

    local function GetPaths(path, ...)
		return unpack(Utils.map({ ... }, function(p)
			return path .. p
		end))
    end

    local function AddWorldMapFragment(strId, fragment, normal, highlight, pressed)
		WORLD_MAP_INFO.modeBar:Add(strId, { fragment }, { pressed = pressed, highlight = highlight, normal = normal })
    end

    _locationsLookup = Location.Data.GetLookup()

    _locations = {}

    wayshrinesTab = FasterTravel.MapTabWayshrines(wayshrineControl, _locations, _locationsLookup, recentList, { list = favouritesList, add = AddFavourite, remove = RemoveFavourite })
    playersTab = FasterTravel.MapTabPlayers(playersControl)
    questTracker = FasterTravel.QuestTracker(_locations, _locationsLookup, wayshrinesTab)

	wayshrinesTab:SetAllWSOrder(FasterTravel.settings.ws_order)
    RefreshWayshrineDropDowns()

	-- add the "Jump to this zone" keybind strip button…
	local ButtonGroup = {
		{
			name = GetString(SI_BINDING_NAME_FASTER_TRAVEL_REJUMP),
			keybind = "FASTER_TRAVEL_REJUMP",
			order = 10,
			visible = 	function()
							local maptype = GetMapType()
							return maptype == MAPTYPE_ZONE or maptype == MAPTYPE_SUBZONE
						end,
			callback = function() FasterTravel.slashGoto("zone") end,
		},
		alignment = KEYBIND_STRIP_ALIGN_LEFT,
	}
	-- …visible only in worldMap scene
	SCENE_MANAGER:GetScene('worldMap'):RegisterCallback("StateChange",
		function(oldState, newState)
			if newState == SCENE_SHOWING then
				KEYBIND_STRIP:AddKeybindButtonGroup(ButtonGroup)
			elseif newState == SCENE_HIDDEN then
				KEYBIND_STRIP:RemoveKeybindButtonGroup(ButtonGroup)
			end
		end)
--[[
	FasterTravel.UpdateButtonGroup = function()
		KEYBIND_STRIP:UpdateKeybindButtonGroup(ButtonGroup)
	end
]]--

    -- finally add the controls
    local normal, highlight, pressed = GetPaths("/esoui/art/treeicons/achievements_indexicon_alliancewar_", "up.dds", "over.dds", "down.dds")

    AddWorldMapFragment(FASTER_TRAVEL_MODE_WAYSHRINES, wayshrineControl.fragment, normal, highlight, pressed)

    normal, highlight, pressed = GetPaths("/esoui/art/mainmenu/menubar_group_", "up.dds", "over.dds", "down.dds")

    AddWorldMapFragment(FASTER_TRAVEL_MODE_PLAYERS, playersControl.fragment, normal, highlight, pressed)

    SetCurrentZoneMapIndexes(GetCurrentMapZoneIndex())

    -- scenes which don't hide themselves on EndInteration.
    local _interactionScenes = { "smithing" }
    local function EndCurrentInteraction()

		local interaction = GetInteractionType()

		if interaction == nil then return end

		local provisionSceneName = ZO_Provisioner_GetVisibleSceneName()

		if provisionScene ~= nil then
			SCENE_MANAGER:Hide(provisionScene)
		else
			for i, sceneName in ipairs(_interactionScenes) do
				if SCENE_MANAGER:IsShowing(sceneName) then
					SCENE_MANAGER:Hide(sceneName)
				end
			end
		end

		EndInteraction(interaction)
    end

    --- Parses alias arguments for goto slash command. ""
    local function parseAlias(args)
		if not args or args == "" then return end
		args = Utils.stringTrim(args)
		-- Check pattern "SimpleAlphaNumericAlias ValueWithSpacesOrOtherCharacters"
		local key = string.match(args, "^[%d%a]+")
		local value = Utils.stringTrim(args:gsub(key, "", 1))
		return key, value
    end

    --- Tries to teleport to specified destination.
    local function processTeleport(destination)
		-- fix for teleport bug during interactions
		EndCurrentInteraction()

		local result, name
		if destination == GROUP_ALIAS then
			result, name = Teleport.TeleportToGroup()
		else
			result, name = Teleport.TeleportToPlayer(destination)
			if not result then
				result, name = Teleport.TeleportToZone(destination)
			end
		end

		if result then
			if name ~= destination then
				Utils.chat(2, "%s replaced with %s", Utils.bold(destination), Utils.bold(name))
			end
		elseif name ~= nil then
			Utils.chat(0, "Invalid teleport target %s", Utils.bold(name))
		end
    end

	local function slashGoto(args)
		args = Utils.stringTrim(args)
		if Utils.stringIsEmpty(args) then return end
		local aliasValue = FasterTravel.settings.aliases[args]
		if aliasValue then
			Utils.chat(2, "Alias %s for %s used.", Utils.bold(args), Utils.bold(aliasValue))
			args = aliasValue
		end
		if args == "zone" then
			-- the zone being displayed on the map or the current zone if no map shown
			args = GetZoneNameByIndex(GetCurrentMapZoneIndex())
		end
		processTeleport(args)
    end

	FasterTravel.slashGoto = slashGoto

	SLASH_COMMANDS["/goto"] = slashGoto

    SLASH_COMMANDS["/ft"] = function(args)
		if Utils.stringIsEmpty(args) then
			Utils.chat(0, "Possible subcommands: verbosity, recents, listlen, alias")
		else
			-- find subcommand
			local subcommands = {"alias", "verbosity", "listlen", "recents"}
			local n, command, arg
			for _, word in ipairs(subcommands) do
				arg, n = string.gsub(args, "^" .. word, "", 1)
				if n == 1 then
					command = word
					break
				end
			end
			if n == 0 then
			    -- not a subcommand
				-- Utils.chat(1, "Invalid subcommand %s", command or "nil")
				slashGoto(args)
			elseif command == "verbosity" then
				if Utils.stringIsEmpty(arg) then
					Utils.chat(0, "verbosity is %s", FasterTravel.settings.verbosity)
				else
					local v = tonumber(arg)
					if v == nil or v < 0 then
						Utils.chat(1, "Wrong argument %s", arg)
					else
						FasterTravel.settings.verbosity = v
						Utils.chat(0, "verbosity set to %s", v)
					end
				end
			elseif command == "alias" then
				local key, value = parseAlias(arg)
				if Utils.stringIsEmpty(key) then
					Utils.chat(0, Utils.bold("Aliases:"))
					for key, value in Utils.pairsByKeys(FasterTravel.settings.aliases) do
						Utils.chat(0, "%s -> %s", Utils.bold(key), Utils.bold(value))
					end
				elseif Utils.stringIsEmpty(value) then
					if FasterTravel.settings.aliases[key] then
						Utils.chat(0, "GOTO alias %s for %s deleted", Utils.bold(FasterTravel.settings.aliases[key]), Utils.bold(key))
						FasterTravel.settings.aliases[key] = nil
					end
				else
					FasterTravel.settings.aliases[key] = value
					Utils.chat(0, "GOTO alias saved: %s -> %s", Utils.bold(key), Utils.bold(value))
				end
			elseif command == "listlen" then
				if Utils.stringIsEmpty(arg) then
					Utils.chat(0, "listlen is %s", FasterTravel.settings.listlen)
				else
					local v = tonumber(arg)
					if v == nil or v <= 0 or v>=100 then
						Utils.chat(1, "Wrong argument %s", arg)
					else
						FasterTravel.settings.listlen = v
						Utils.chat(0, "listlen set to %s", v)
					end
				end
			elseif command == "recents" then
				if Utils.stringIsEmpty(arg) then
					Utils.chat(0, "recent list is %s",
						Utils.bold(FasterTravel.settings.recentsEnabled and "enabled" or "disabled"))
				else
					arg = Utils.stringTrim(arg)
					if arg == "on" then
						FasterTravel.settings.recentsEnabled = true
					elseif arg == "off" then
						FasterTravel.settings.recentsEnabled = false
					else
						Utils.chat(0, "Sorry, I understand only %s or %s", Utils.bold("on"), Utils.bold("off"))
						return
					end
					EnableRecents(FasterTravel.settings.recentsEnabled)
					Utils.chat(1, "Recents %s; reloading UI",
						Utils.bold(FasterTravel.settings.recentsEnabled and "enabled" or "disabled"))
					ReloadUI("ingame")
				end
			else
				Utils.chat(3, "WTF?! %s", command)
			end
		end
	end

	FasterTravel.SurveyTheWorld.OnAddOnLoaded()
	Utils.chat(1, "%s %s initialized.",	addon.name, addon.version )

end -- Setup

local function init(func, ...)
    local arg = { ... }
	addEvent(EVENT_ADD_ON_LOADED,
		function(eventCode, addOnName)
			if (addOnName == addon.name) then func(unpack(arg)) else return end
		end)
end

-- entry point
init(Setup)
