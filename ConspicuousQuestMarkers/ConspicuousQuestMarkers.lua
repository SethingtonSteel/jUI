cqm = {}
cqm.appName = "ConspicuousQuestMarkers"

----------------------------------------
-- Declarations
----------------------------------------
local ADDON_VERSION = "1.17"
local eso_root = "esoui/art/"
local ui_root = "ConspicuousQuestMarkers/"
cqm.version = ADDON_VERSION

local cqm_textures = {
    {"darkbrotherhood_target.dds"},
    {"quest_available_icon.dds"},
    {"quest_icon.dds"},
    {"quest_icon_assisted.dds"},
    {"quest_icon_door.dds"},
    {"quest_icon_door_assisted.dds"},
    {"repeatablequest_available_icon.dds"},
    {"repeatablequest_icon.dds"},
    {"repeatablequest_icon_assisted.dds"},
    {"repeatablequest_icon_door.dds"},
    {"repeatablequest_icon_door_assisted.dds"},
    {"timely_escape_npc.dds"},
}

local cqm_compass_textures = {
    {"quest_areapin.dds"},
    {"quest_assistedareapin.dds"},
    {"repeatablequest_areapin.dds"},
    {"repeatablequest_assistedareapin.dds"},
    {"zonestoryquest_areapin.dds"},
    {"zonestoryquest_assistedareapin.dds"},
    {"zonestoryquest_available_icon_areapin.dds"},
    {"zonestoryquest_areapin.dds"},
    {"zonestoryquest_assistedareapin.dds"},
    {"zonestoryquest_available_icon.dds"},
    {"zonestoryquest_available_icon_areapin.dds"},
    {"zonestoryquest_available_icon_door.dds"},
    {"zonestoryquest_icon.dds"},
    {"zonestoryquest_icon_assisted.dds"},
    {"zonestoryquest_icon_door.dds"},
    {"zonestoryquest_icon_door_assisted.dds"},
}

local defaults = {
    quest_marker_size = 32,
    icon_theme = "fuchsia",
    show_on_compass = true,
}

local icon_themes = {
       [1]  = {theme = "vanilla", sample = 'ConspicuousQuestMarkers/cqm_textures/vanilla/quest_icon_assisted.dds', tooltip = "Vanilla"},
       [2]  = {theme = "aqua", sample = 'ConspicuousQuestMarkers/cqm_textures/aqua/quest_icon_assisted.dds', tooltip = "Aqua"},
       [3]  = {theme = "blue", sample = 'ConspicuousQuestMarkers/cqm_textures/blue/quest_icon_assisted.dds', tooltip = "Blue"},
       [4]  = {theme = "fuchsia", sample = 'ConspicuousQuestMarkers/cqm_textures/fuchsia/quest_icon_assisted.dds', tooltip = "Fuchsia"},
       [5]  = {theme = "green", sample = 'ConspicuousQuestMarkers/cqm_textures/green/quest_icon_assisted.dds', tooltip = "Green"},
       [6]  = {theme = "lime", sample = 'ConspicuousQuestMarkers/cqm_textures/lime/quest_icon_assisted.dds', tooltip = "Lime"},
       [7]  = {theme = "maroon", sample = 'ConspicuousQuestMarkers/cqm_textures/maroon/quest_icon_assisted.dds', tooltip = "Maroon"},
       [8]  = {theme = "navy", sample = 'ConspicuousQuestMarkers/cqm_textures/navy/quest_icon_assisted.dds', tooltip = "Navy"},
       [9]  = {theme = "olive", sample = 'ConspicuousQuestMarkers/cqm_textures/olive/quest_icon_assisted.dds', tooltip = "Olive"},
       [10]  = {theme = "purple", sample = 'ConspicuousQuestMarkers/cqm_textures/purple/quest_icon_assisted.dds', tooltip = "Purple"},
       [11] = {theme = "red", sample = 'ConspicuousQuestMarkers/cqm_textures/red/quest_icon_assisted.dds', tooltip = "Red"},
       [12] = {theme = "teal", sample = 'ConspicuousQuestMarkers/cqm_textures/teal/quest_icon_assisted.dds', tooltip = "Teal"},
       [13] = {theme = "yellow", sample = 'ConspicuousQuestMarkers/cqm_textures/yellow/quest_icon_assisted.dds', tooltip = "Yellow"},
       [14] = {theme = "old_school", sample = 'ConspicuousQuestMarkers/cqm_textures/old_school/quest_icon_assisted.dds', tooltip = "Old School"},
}

----------------------------------------
-- Functions
----------------------------------------
function cqm.OnAddOnLoaded(eventCode, addOnName)
	local function RedirectTextures(eso_folder, cqm_folder, textures_table)
	    local eso_textures_folder = eso_root .. eso_folder
	    local cqm_textures_folder = ui_root .. cqm_folder
	    for i = 1, #textures_table do
	        RedirectTexture(eso_textures_folder .. textures_table[i][1], cqm_textures_folder .. textures_table[i][1])
	    end
	end
    if addOnName ~= cqm.appName then
        return
    end
    cqm.SV = ZO_SavedVars:NewAccountWide("ConspicuousQuestMarkers_SavedVariables", ADDON_VERSION, defaults, nil)
    cqm:initLAM(icon_themes)
    if cqm.SV.show_on_compass then
        RedirectTextures("floatingmarkers/", "cqm_textures/" .. cqm.SV.icon_theme .. "/", cqm_textures)
    	RedirectTextures("compass/", "cqm_textures/" .. cqm.SV.icon_theme .. "/", cqm_textures)
        RedirectTextures("compass/", "cqm_textures/" .. cqm.SV.icon_theme .. "/", cqm_compass_textures)
    end
end

function cqm.OnPlayerActivated()
    SetFloatingMarkerInfo(MAP_PIN_TYPE_ASSISTED_QUEST_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon_assisted.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon_door_assisted.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_ASSISTED_QUEST_OPTIONAL_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon_assisted.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon_door_assisted.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_ASSISTED_QUEST_ENDING, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon_assisted.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon_door_assisted.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_ASSISTED_QUEST_REPEATABLE_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon_assisted.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon_door_assisted.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_ASSISTED_QUEST_REPEATABLE_OPTIONAL_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon_assisted.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon_door_assisted.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_ASSISTED_QUEST_REPEATABLE_ENDING, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon_assisted.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon_door_assisted.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_ASSISTED_QUEST_ZONE_STORY_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon_assisted.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon_door_assisted.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_ASSISTED_QUEST_ZONE_STORY_OPTIONAL_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon_assisted.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon_door_assisted.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_ASSISTED_QUEST_ZONE_STORY_ENDING, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon_assisted.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon_door_assisted.dds")

    SetFloatingMarkerInfo(MAP_PIN_TYPE_TRACKED_QUEST_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_TRACKED_QUEST_OPTIONAL_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_TRACKED_QUEST_ENDING, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_TRACKED_QUEST_REPEATABLE_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_TRACKED_QUEST_REPEATABLE_OPTIONAL_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_TRACKED_QUEST_REPEATABLE_ENDING, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_TRACKED_QUEST_ZONE_STORY_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_TRACKED_QUEST_ZONE_STORY_OPTIONAL_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_TRACKED_QUEST_ZONE_STORY_ENDING, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon_door.dds")

    SetFloatingMarkerInfo(MAP_PIN_TYPE_QUEST_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_QUEST_OPTIONAL_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_QUEST_ENDING, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_QUEST_REPEATABLE_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_QUEST_REPEATABLE_OPTIONAL_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_QUEST_REPEATABLE_ENDING, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_QUEST_ZONE_STORY_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_QUEST_ZONE_STORY_OPTIONAL_CONDITION, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon_door.dds")
    SetFloatingMarkerInfo(MAP_PIN_TYPE_QUEST_ZONE_STORY_ENDING, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_icon_door.dds")

    SetFloatingMarkerInfo(MAP_PIN_TYPE_TRACKED_QUEST_OFFER_ZONE_STORY, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_available_icon.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_available_icon_door.dds", PULSES)

    -- SetFloatingMarkerInfo(MAP_PIN_TYPE_TIMELY_ESCAPE_NPC, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/timely_escape_npc.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/timely_escape_npc.dds")
    -- SetFloatingMarkerInfo(MAP_PIN_TYPE_DARK_BROTHERHOOD_TARGET, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/darkbrotherhood_target.dds", ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/darkbrotherhood_target.dds")

    local PULSES = true
    SetFloatingMarkerInfo(MAP_PIN_TYPE_QUEST_OFFER, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/quest_available_icon.dds", "", PULSES)
    SetFloatingMarkerInfo(MAP_PIN_TYPE_QUEST_OFFER_REPEATABLE, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/repeatableQuest_available_icon.dds", "", PULSES)
    SetFloatingMarkerInfo(MAP_PIN_TYPE_QUEST_OFFER_ZONE_STORY, cqm.SV.quest_marker_size, ui_root .. "cqm_textures/" .. cqm.SV.icon_theme .. "/zoneStoryQuest_available_icon.dds", "", PULSES)
end

----------------------------------------
-- Main
----------------------------------------
EVENT_MANAGER:RegisterForEvent(cqm.appName, EVENT_ADD_ON_LOADED, cqm.OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent(cqm.appName, EVENT_PLAYER_ACTIVATED, cqm.OnPlayerActivated)