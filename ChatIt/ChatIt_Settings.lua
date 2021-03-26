
local LAM2 = LibStub("LibAddonMenu-2.0")

local colorYellow 		= "|cFFFF00" 	-- yellow 
local colorRed 			= "|cFF0000" 	-- Red


local function UpdateReloadControls(isReloadAllOn)
	if not isReloadAllOn then return end
	
	RELOAD_WHISPER_CONTROL:UpdateValue(false, false)
	RELOAD_PARTY_CONTROL:UpdateValue(false, false)
	RELOAD_OFFICER_CONTROL:UpdateValue(false, false)
	RELOAD_GUILD_CONTROL:UpdateValue(false, false)
end

-------------------------------------------------------------------------------------------------
--  Settings Menu --
-------------------------------------------------------------------------------------------------
function ChatIt.CreateSettingsMenu()
	local panelData = {
		type = "panel",
		name = "ChatIt",
		displayName = "|cFF0000 Circonians |c00FFFF ChatIt",
		author = "Circonian",
		version = ChatIt.RealVersion,
		slashCommand = "/chatit",
		registerForRefresh = true,
		registerForDefaults = true,
	}
	local cntrlOptionsPanel = LAM2:RegisterAddonPanel("Circonians_ChatIt_Options", panelData)
	
	local optionsData = {
		[1] = {
			type = "description",
			text = colorYellow.."If you wish to submit a bug report or feature request please do so on my PORTAL page. Go to the addons web page & clock on Portal, Bugs, or Feature (under the download button)."
		},
		[2] = {
			type = "checkbox",
			name = "Show Default Background",
			tooltip = "Turn ON/OFF the default chat background.",
			default = true,
			getFunc = function() return not ChatIt.SavedVariables["HIDE_DEFAULT_BG"] end,
			setFunc = function(bValue) ChatIt.SavedVariables["HIDE_DEFAULT_BG"] = not bValue 
				ChatIt.UpdateDefaultBgVisibilityStates() end,
		},
		[3] = {
			type = "checkbox",
			name = "Show Extra Background",
			tooltip = "Shows a secondary background on the chat window to darken it up.",
			default = true,
			getFunc = function() return not ChatIt.SavedVariables["HIDE_EXTRA_BG"] end,
			setFunc = function(bValue) ChatIt.SavedVariables["HIDE_EXTRA_BG"] = not bValue 
				ChatIt.UpdateVisibilityStates() end,
		},
		[4] = {
			type = "slider",
			name = "Extra Background Alpha",
			tooltip = "Adjust the alpha of the secondary background.",
			min = 0,
			max = 100,
			step = 1,
			default = 100,
			getFunc = function() return ChatIt.SavedVariables["EXTRA_BG_ALPHA"] end,
			setFunc = function(iValue) ChatIt.SavedVariables["EXTRA_BG_ALPHA"] = iValue 
				ChatIt.UpdateBgAlpha() end,
		},
		[5] = {
			type = "checkbox",
			name = "Background Fade",
			tooltip = "Turn background fading ON or OFF.",
			default = false,
			getFunc = function() return ChatIt.SavedVariables["BACKGROUND_FADE"] end,
			setFunc = function(bValue) ChatIt.SavedVariables["BACKGROUND_FADE"] = bValue 
				ChatIt.UpdateBgFade() end,
		},
		[6] = {
			type = "description",
			text = colorYellow.."The values for the settings below are time in seconds.",
		},
		[7] = {
			type = "slider",
			name = "Text Fade Delay",
			tooltip = "Time before the chat text begins to fade. A value of 0 prevents it from fading.",
			min = 0,
			max = 100,
			step = 1,
			default = 0,
			getFunc = function() return ChatIt.SavedVariables["LINE_FADE_DELAY"] end,
			setFunc = function(iValue) ChatIt.SavedVariables["LINE_FADE_DELAY"] = iValue
				ChatIt.UpdateTextFade() end,
		},
		[8] = {
			type = "slider",
			name = "Text Fade Duration",
			tooltip = "Adjust the amount of time it takes for the chat text to disappear once it starts to fade.",
			min = 0,
			max = 100,
			step = 1,
			default = 3,
			getFunc = function() return ChatIt.SavedVariables["LINE_FADE_DURATION"] end,
			setFunc = function(iValue) ChatIt.SavedVariables["LINE_FADE_DURATION"] = iValue
				ChatIt.UpdateTextFade() end,
		},
		
		[9] = {
			type = "submenu",
			name = "Chat Buffer",
			tooltip = "Allows you to reload past messages.",
			controls = {
				[1] = {
					type = "header",
					name = "Slash Commands"
				},
				[2] = {
					type = "description",
					text = colorYellow.."The following slash commands will reload all chat (of the given type) that is currently in the buffer: "..colorRed.."\/reloadchat, \/reloadparty, \/reloadwhisper, \/reloadguild, \/reloadofficer."
				},
				[3] = {
					type = "description",
					text = colorYellow.."You can add an optional time, in minutes, after the command like: "..colorRed.."\/reloadwhipser 20|r"..colorYellow.." and it will reload all whispers in the buffer that were recorded in the last 20 minutes."
				},
				[4] = {
					type = "header",
					name = "Settings"
				},
				[5] = {
					type = "checkbox",
					name = "Clear Text On Reload",
					tooltip = "When ON all text currently in the chat window will be cleared whenever you reload chat with a slash command.",
					default = true,
					getFunc = function() return ChatIt.SavedVariables["RELOAD_CLEAR"] end,
					setFunc = function(bValue) ChatIt.SavedVariables["RELOAD_CLEAR"] = bValue end,
				},
				[6] = {
					type = "checkbox",
					name = "Print Chat Reload Divider Messages",
					tooltip = "Prints a chat message divider:\n"..colorRed.."\"****** Reloading Chat xxx ****\"|r\nSo you can easily find the reloaded text.\n "..colorRed.."\"*** Chat Reloaded ***\"|r",
					default = true,
					getFunc = function() return ChatIt.SavedVariables["RELOAD_DIVIDER_MSGS"] end,
					setFunc = function(bValue) ChatIt.SavedVariables["RELOAD_DIVIDER_MSGS"] = bValue end,
				},
				[7] = {
					type = "checkbox",
					name = "TimeStamp Buffered Text",
					tooltip = "When ON all buffered text will be time stamped. This only applies to the buffered text that gets reloaded.",
					default = true,
					getFunc = function() return ChatIt.SavedVariables["RELOAD_TIMESTAMP"] end,
					setFunc = function(bValue) ChatIt.SavedVariables["RELOAD_TIMESTAMP"] = bValue end,
				},
				[8] = {
					type = "description",
					text = colorYellow.."Automatic Reload Buffer Time Interval ONLY applies to the AUTOMATIC chat reloading features below. It does not effect slash commands. One of the automatic chat reload features below must be turned on, or this does nothing."
				},
				[9] = {
					type = "slider",
					name = "Automatic Reload Buffer Time Interval",
					tooltip = "Automatic chat reloading will only display messages that are less than this many minutes old.",
					min = 1,
					max = 10,
					step = 1,
					default = 60,
					getFunc = function() return ChatIt.SavedVariables["RELOAD_TIME"] end,
					setFunc = function(iValue) ChatIt.SavedVariables["RELOAD_TIME"] = iValue  end,
				},
				[10] = {
					type = "description",
					text = colorYellow.."Turn these options ON to automatically reload chat whenever you login or reload the ui."
				},
				[11] = {
					type = "checkbox",
					name = "Automatically Reload All Chat",
					tooltip = "Automatically reloads all buffered chat when you login or reload the ui.",
					default = true,
					getFunc = function() return ChatIt.SavedVariables["RELOAD_ALL"] end,
					setFunc = function(bValue) ChatIt.SavedVariables["RELOAD_ALL"] = bValue
						UpdateReloadControls(bValue)
					end,
				},
				[12] = {
					type = "checkbox",
					name = "Automatically Reload Chat Whispers",
					tooltip = "Automatically reloads all buffered chat whispers when you login or reload the ui.\n"..colorYellow.."Reload All Chat must be off to use this setting.",
					default = false,
					disabled = function() return ChatIt.SavedVariables["RELOAD_ALL"] end,
					getFunc = function() return ChatIt.SavedVariables["RELOAD_WHISPER"] end,
					setFunc = function(bValue) ChatIt.SavedVariables["RELOAD_WHISPER"] = bValue  end,
					reference = "RELOAD_WHISPER_CONTROL",
				},
				[13] = {
					type = "checkbox",
					name = "Automatically Reload Party Chat",
					tooltip = "Automatically reloads all buffered party chat when you login or reload the ui.\n"..colorYellow.."Reload All Chat must be off to use this setting.",
					default = false,
					disabled = function() return ChatIt.SavedVariables["RELOAD_ALL"] end,
					getFunc = function() return ChatIt.SavedVariables["RELOAD_PARTY"] end,
					setFunc = function(bValue) ChatIt.SavedVariables["RELOAD_PARTY"] = bValue  end,
					reference = "RELOAD_PARTY_CONTROL",
				},
				[14] = {
					type = "checkbox",
					name = "Automatically Reload Guild Chat",
					tooltip = "Automatically reloads all buffered guild chat when you login or reload the ui.\n"..colorYellow.."Reload All Chat must be off to use this setting.",
					default = false,
					disabled = function() return ChatIt.SavedVariables["RELOAD_ALL"] end,
					getFunc = function() return ChatIt.SavedVariables["RELOAD_GUILD"] end,
					setFunc = function(bValue) ChatIt.SavedVariables["RELOAD_GUILD"] = bValue  end,
					reference = "RELOAD_GUILD_CONTROL",
				},
				[15] = {
					type = "checkbox",
					name = "Automatically Reload Officer Chat",
					tooltip = "Automatically reloads all buffered officer chat when you login or reload the ui.\n"..colorYellow.."Reload All Chat must be off to use this setting.",
					default = false,
					disabled = function() return ChatIt.SavedVariables["RELOAD_ALL"] end,
					getFunc = function() return ChatIt.SavedVariables["RELOAD_OFFICER"] end,
					setFunc = function(bValue) ChatIt.SavedVariables["RELOAD_OFFICER"] = bValue end,
					reference = "RELOAD_OFFICER_CONTROL",
				},
			},
		},
		[10] = {
			type = "submenu",
			name = "Chat TimeStamps & TimePlayed",
			tooltip = "Settings to display time & time played.",
			controls = {	
				[1] = {
					type = "description",
					text = colorRed.."If you are using pChat with this addon the clock in this addon WILL BE DISABLED, turning it on will do nothing. This is to provide compatibility with pChat. You can use the timestamp function built into pChat.",
				},
				[2] = {
					type = "header",
					name = "Time Settings",
					width = "full",
				},
				[3] = {
					type = "dropdown",
					name = "Show Time",
					tooltip = "Shows the time (type of your choice) in front of chat messages.",
					choices = {"Off", "Clock", "Time Played"},
					default = "Off",
					getFunc = function() return ChatIt.SavedVariables["SHOW_TIME"] end,
					setFunc = function(sValue) ChatIt.SavedVariables["SHOW_TIME"] = sValue end,
				},
				[4] = {
					type = "description",
					text = colorRed.."Not all styles/precisions work together.",
				},
				[5] = {
					type = "dropdown",
					name = "Time Style",
					choices = {"Clock", "Colons", "Descriptive", "Descriptive Short", "Largest Unit", "Largest Unit Descriptive"},
					default = "Clock",
					disabled = function() return (ChatIt.SavedVariables["SHOW_TIME"] == "Off") end,
					getFunc = function() return ChatIt.SavedVariables["TIME_STYLE"] end,
					setFunc = function(sValue) ChatIt.SavedVariables["TIME_STYLE"] = sValue end,
				},
				[6] = {
					type = "dropdown",
					name = "Time Precision",
					tooltip = "The Time Precision setting is used for the message time stamps & the time stamps on reloaded text. For saved/reloaded text changes to the precision will ONLY apply to messages you receive after changing this setting.",
					choices = {"12 hr", "24 hr"},
					default = "12 hr",
					disabled = function() return (ChatIt.SavedVariables[SHOW_TIME] == "Off") end,
					getFunc = function() return ChatIt.SavedVariables["TIME_PRECISION"] end,
					setFunc = function(sValue) ChatIt.SavedVariables["TIME_PRECISION"] = sValue end,
				},
			},
		},
		[11] = {
			type = "submenu",
			name = "Multiple Chat Windows",
			--tooltip = "Extreme Beta :)",
			controls = {	
				[1] = {
					type = "checkbox",
					name = "Allow Multiple Chat Windows",
					tooltip = "Turn ON/OFF multiple windows.",
					default = false,
					getFunc = function() return ChatIt.SavedVariables["MULTIPLE_WINDOWS"] end,
					setFunc = function(bValue) ChatIt.SavedVariables["MULTIPLE_WINDOWS"] = bValue 
						ChatIt.SetMultipleWindows(bValue) end,
				},
				[2] = {
					type = "description",
					name = " ",
				},
				--[[
				[3] = {
					type = "description",
					text = colorYellow.."The games built in code for allowing multiple chat windows is buggy. I've done my best to prevent all of those problems. This button is only a precautionary measure in case you have problems and need to destroy all of the chat windows for some reason.",
				},
				[4] = {
					type = "description",
					text = colorRed.."Since this addons release on 8-4-2014 I have not had a single person ever say they needed to use this. ",
				},
				[5] = {
					type = "description",
					text = colorYellow.."Try reloading your ui with \/reloadui or relogging first. This will destroy all of your extra chat windows & you will have to remake them."
				},
				[6] = {
					type = "button",
					name = "Destroy Chat Windows",
					tooltip = "Used to destroy all extra chat window, in case you run into any problems.",
					warning = "This will destroy all of your extra chat windows.",
					default = false,
					disabled = function() return not ChatIt.SavedVariables["MULTIPLE_WINDOWS"] end,
					func = function() return ChatIt.DestroyExtraContainers() end,
				},
				[7] = {
					type = "description",
					text = colorYellow.." "
				},
				--]]
			},
		},
	}
	LAM2:RegisterOptionControls("Circonians_ChatIt_Options", optionsData)
end