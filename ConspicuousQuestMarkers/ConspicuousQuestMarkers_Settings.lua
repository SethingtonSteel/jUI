local LAM = LibAddonMenu2

function cqm:initLAM(icon_themes)
    local panelData = {
        type = "panel",
        version = cqm.version,
        name = "ConspicuousQuestMarkers",
        displayName = ZO_HIGHLIGHT_TEXT:Colorize("ConspicuousQuestMarkers"),
        author = "Jhenox",
        slashCommand = "/cqm",
        registerForRefresh = true,
        registerForDefaults = true
    }

    local optionsTable = {
        [1] = {
            type = "header",
            name = "Options",
            width = "full"
        },
        [2] = {
            type = "checkbox",
            name = "Show on Compass and Map",
            tooltip = "Disable this to only show the floating in-world CQM icons.",
            default = true,
            getFunc = function()
                return cqm.SV.show_on_compass
            end,
            setFunc = function(val)
                cqm.SV.show_on_compass = val
            end,
            width = "full",
            warning = "The game will need to be reloaded for this change to take effect ."
        },
        [3] = {
            type = "slider",
            name = "Marker Size",
            tooltip = "Select the size of the in-world quest markers.",
            min = 32,
            max = 96,
            step = 1,
            getFunc = function()
                return cqm.SV.quest_marker_size
            end,
            setFunc = function(val)
                cqm.SV.quest_marker_size = val
                cqm.OnPlayerActivated()
            end,
            width = "full",
            default = 32
        },
        [4] = {
            type = "iconpicker",
            name = "Icon Theme",
            choices = {},
            getFunc = function()
                for i = 1, #icon_themes do
                    if icon_themes[i]["theme"] == cqm.SV.icon_theme then
                        selected = icon_themes[i]["sample"]
                    end
                end
                return selected
            end,
            setFunc = function(val)
                for i = 1, #icon_themes do
                    if icon_themes[i]["sample"] == val then
                        selected = icon_themes[i]["theme"]
                    end
                end
                cqm.SV.icon_theme = selected
                cqm.OnPlayerActivated()
            end,
            tooltip = "Select a color or theme to use for the icons.",
            choicesTooltips = {},
            maxColumns = 4,
            visibleRows = 4,
            iconSize = 32,
            width = "full",
            beforeShow = function(control, iconPicker)
                return preventShow
            end,
            warning = "The game will need to be reloaded for this change to affect the compass and map icons. In-world icons will take effect immediately.",
            -- requiresReload = false,
            default = icon_themes[1]["sample"]
        }
    }
    for i = 1, #icon_themes do
        table.insert(optionsTable[4]["choices"], icon_themes[i]["sample"])
        table.insert(optionsTable[4]["choicesTooltips"], icon_themes[i]["tooltip"])
    end
    LAM:RegisterAddonPanel("ConspicuousQuestMarkers", panelData)
    LAM:RegisterOptionControls("ConspicuousQuestMarkers", optionsTable)
end
