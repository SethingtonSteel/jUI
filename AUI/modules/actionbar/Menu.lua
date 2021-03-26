AUI.Settings.Actionbar = {}

local g_LAM = LibAddonMenu2
local g_isInit = false
local g_isPreviewShowing = false
local g_quickslotsMin = 0
local g_quickslotsMax = 8

local g_defaultSettings =
{		
	keyboard_quickslot_count = 5,
	gamepad_quickslot_count = 0,
	allow_over_100_percent = false,
	show_text = true,
	show_background = true,
}

function GetOptions()
	local optionsData = 
	{	
		{
			type = "header",
			name = AUI_TXT_COLOR_HEADER:Colorize(AUI.L10n.GetString("general"))
		},	
		{
			type = "checkbox",
			name = AUI.L10n.GetString("acount_wide"),
			tooltip = AUI.L10n.GetString("acount_wide_tooltip"),
			getFunc = function() return AUI.MainSettings.modul_actionBar_account_wide end,
			setFunc = function(value)
				if value ~= nil then
					if value ~= AUI.MainSettings.modul_actionBar_account_wide then
						AUI.MainSettings.modul_actionBar_account_wide = value
						ReloadUI()
					else
						AUI.MainSettings.modul_actionBar_account_wide = value
					end
				end
			end,
			default = true,
			width = "full",
			warning = AUI.L10n.GetString("reloadui_warning_tooltip"),
		},		
		{
			type = "checkbox",
			name = AUI.L10n.GetString("preview"),
			tooltip = AUI.L10n.GetString("preview_tooltip"),
			getFunc = function() return g_isPreviewShowing end,
			setFunc = function(value)
				if value ~= nil then
					if value then
						AUI.Actionbar.Lock()
					else
						AUI.Actionbar.Unlock()
					end
					
					g_isPreviewShowing = value
				end
			end,
			default = g_isPreviewShowing,
			width = "full",
			warning = AUI.L10n.GetString("preview_warning"),			
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_background"),
			tooltip = AUI.L10n.GetString("show_background_tooltip"),
			getFunc = function() return AUI.Settings.Actionbar.show_background end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Actionbar.show_background = value
					AUI.Actionbar.UpdateUI()
				end
			end,
			default = g_defaultSettings.show_background,
			width = "full",
		},		
		{		
			type = "submenu",
			name = AUI_TXT_COLOR_SUBMENU:Colorize(AUI.L10n.GetString("quick_slots")),
			controls = 
			{			
				{
					type = "slider",
					name = AUI.L10n.GetString("slot_count") .. " (" .. AUI.L10n.GetString("keyboard") .. ")",
					tooltip = AUI.L10n.GetString("slot_count_tooltip"),
					min = g_quickslotsMin,
					max = g_quickslotsMax,
					step = 1,
					getFunc = function() return AUI.Settings.Actionbar.keyboard_quickslot_count end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Actionbar.keyboard_quickslot_count = value
							AUI.Actionbar.UpdateUI()
						end
					end,
					default = g_defaultSettings.keyboard_quickslot_count,
					width = "full",
				},
				{
					type = "slider",
					name = AUI.L10n.GetString("slot_count") .. " (" .. AUI.L10n.GetString("gamepad") .. ")",
					tooltip = AUI.L10n.GetString("slot_count_tooltip"),
					min = g_quickslotsMin,
					max = g_quickslotsMax,
					step = 1,
					getFunc = function() return AUI.Settings.Actionbar.gamepad_quickslot_count end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Actionbar.gamepad_quickslot_count = value
							AUI.Actionbar.UpdateUI()
						end
					end,
					default = g_defaultSettings.gamepad_quickslot_count,
					width = "full",
				},				
			}
		},		
		{		
			type = "submenu",
			name = AUI_TXT_COLOR_SUBMENU:Colorize(AUI.L10n.GetString("ultimate")),
			controls = 
			{					
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_text"),
					tooltip = AUI.L10n.GetString("show_text_tooltip"),
					getFunc = function() return AUI.Settings.Actionbar.show_text end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Actionbar.show_text = value
							
							if value then
								AUI.Actionbar.DisableDefaultUltiTextSetting()
							end

							AUI.Actionbar.UpdateUI()
						end
					end,
					default = g_defaultSettings.show_text,
					width = "full",
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("allow_more_than_100%"),
					tooltip = AUI.L10n.GetString("allow_more_than_100%_tooltip"),
					getFunc = function() return AUI.Settings.Actionbar.allow_over_100_percent end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Actionbar.allow_over_100_percent = value
							AUI.Actionbar.UpdateUI()
						end
					end,
					default = g_defaultSettings.allow_over_100_percent,
					width = "full",
				},
			}
		},
	}
	
	return optionsData
end

function AUI.Actionbar.LoadSettings()
	if g_isInit then
		return
	end
		
	g_isInit = true	

	if AUI.MainSettings.modul_actionBar_account_wide then
		AUI.Settings.Actionbar = ZO_SavedVars:NewAccountWide("AUI_Skillbar", 10, nil, g_defaultSettings)
	else
		AUI.Settings.Actionbar = ZO_SavedVars:New("AUI_Skillbar", 10, nil, g_defaultSettings)
	end	

	g_LAM:RegisterOptionControls("AUI_Menu_Skillbar", GetOptions())
	
	local panelData = 
	{
		type = "panel",
		name = AUI_MAIN_NAME .. " (" .. AUI.L10n.GetString("actionbar_module_name") .. ")",
		displayName = "|cFFFFB0" .. AUI_MAIN_NAME .. " (" .. AUI.L10n.GetString("actionbar_module_name") .. ")",
		author = AUI_TXT_COLOR_AUTHOR:Colorize(AUI_ACTIONBAR_AUTHOR),
		version = AUI_TXT_COLOR_VERSION:Colorize(AUI_ACTIONBAR_VERSION),
		slashCommand = "/auitarget",
		registerForRefresh = false,
		registerForDefaults = true,
	}
	
	g_LAM:RegisterAddonPanel("AUI_Menu_Skillbar", panelData)
end
