AUI.Settings.Attributes = {}

local g_LAM = LibAddonMenu2
local g_isInit = false
local g_changedEnabled = false
local g_isPreviewShowing = false

local g_player_attributes_enabled = false
local g_target_attributes_enabled = false
local g_group_attributes_enabled = false
local g_boss_attributes_enabled = false

local defaultSettings =
{
	--general
	lock_windows = false,

	--group
	group_attributes_enabled = true,		
		
	--player
	player_attributes_enabled = true,	
		
	--target			
	target_attributes_enabled = true,	
		
	--boss
	boss_attributes_enabled = true,
	boss_show_text = true,
	boss_font_size = 16,
	boss_font_art = "AUI/fonts/SansitaOne.ttf",
	boss_use_thousand_seperator = true,
}

local function GetCurrentTemplateName()
	local templateData = AUI.Attributes.GetActiveThemeData()
	return templateData.internName
end

local function IsSettingDisabled(_type, _setting)
	local currentTemplateData = AUI.Attributes.GetActiveThemeData()
	if currentTemplateData then
		for type, data in pairs(currentTemplateData.attributeData) do	
			if _type == type then
				if data.disabled_settings and data.disabled_settings[_setting] then
					return true				
				end		
			end		
		end
	end
	
	return false
end

local function DoesAttributeIdExists(_type)
	local currentTemplateData = AUI.Attributes.GetActiveThemeData()
	if currentTemplateData then
		for type, _ in pairs(currentTemplateData.attributeData) do	
			if _type == type then
				return true					
			end		
		end
	end
	
	return false
end

local function AcceptSettings()
	AUI.Settings.Attributes.player_attributes_enabled = g_player_attributes_enabled
	AUI.Settings.Attributes.target_attributes_enabled = g_target_attributes_enabled
	AUI.Settings.Attributes.group_attributes_enabled = g_group_attributes_enabled
	AUI.Settings.Attributes.boss_attributes_enabled = g_boss_attributes_enabled
	
	ReloadUI()
end

local function RemoveAllVisuals(_unitTag)
	AUI.Attributes.RemoveAttributeVisual(_unitTag, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, nil, nil, false)
	AUI.Attributes.RemoveAttributeVisual(_unitTag, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, nil, nil, false)
	AUI.Attributes.RemoveAttributeVisual(_unitTag, ATTRIBUTE_VISUAL_DECREASED_STAT, STAT_ARMOR_RATING, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, nil, nil, false)
	AUI.Attributes.RemoveAttributeVisual(_unitTag, ATTRIBUTE_VISUAL_INCREASED_STAT, STAT_ARMOR_RATING, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, nil, nil, false)
	AUI.Attributes.RemoveAttributeVisual(_unitTag, ATTRIBUTE_VISUAL_DECREASED_STAT, STAT_POWER, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, nil, nil, false)
	AUI.Attributes.RemoveAttributeVisual(_unitTag, ATTRIBUTE_VISUAL_INCREASED_STAT, STAT_POWER, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, nil, nil, false)
end

local function GetPlayerColorSettingsTable()
	local optionTable = {	
		{
			type = "header",
			name = AUI.L10n.GetString("player")
		},			
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("health"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].bar_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a)
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].bar_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)					
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].bar_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].bar_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].bar_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)					
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].bar_color[2],
			width = "half",
		},				
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("magicka"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].bar_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].bar_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}					
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)							
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].bar_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].bar_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].bar_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}					
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)							
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].bar_color[2],
			width = "half",
		},				
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("stamina"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].bar_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].bar_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)						
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].bar_color[1],
			width = "half",
		},	
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].bar_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].bar_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)						
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].bar_color[2],
			width = "half",
		},					
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("stamina_mount"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].bar_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].bar_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)					
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].bar_color[1],
			width = "half",
		},	
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].bar_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].bar_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)					
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].bar_color[2],
			width = "half",
		},				
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("werewolf"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].bar_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].bar_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)					
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].bar_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].bar_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].bar_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)					
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].bar_color[2],
			width = "half",
		},			
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("siege")  .. " (" .. AUI.L10n.GetString("health") .. ")",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].bar_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].bar_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)											
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].bar_color[1],
			width = "half",
		},	
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].bar_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].bar_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)											
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].bar_color[2],
			width = "half",
		},				
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("shield"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].bar_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].bar_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)						
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].bar_color[1],
			width = "half",
		},	
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].bar_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].bar_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)					
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].bar_color[2],
			width = "half",
		},					
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("regeneration") .. " (" .. AUI.L10n.GetString("health") ..")",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].increase_regen_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a)				
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].increase_regen_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)
				
				if not g_isPreviewShowing then
					return
				end				
				
				RemoveAllVisuals(AUI_PLAYER_UNIT_TAG)
				AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].increase_regen_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].increase_regen_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].increase_regen_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}

				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)

				if not g_isPreviewShowing then
					return
				end		

				RemoveAllVisuals(AUI_PLAYER_UNIT_TAG)				
				AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)						
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].increase_regen_color[2],
			width = "half",
		},				
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("degeneration") .. " (" .. AUI.L10n.GetString("health") ..")",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].decrease_regen_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].decrease_regen_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				
				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)

				if not g_isPreviewShowing then
					return
				end		
				
				RemoveAllVisuals(AUI_PLAYER_UNIT_TAG)				
				AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)							
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].decrease_regen_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].decrease_regen_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].decrease_regen_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}

				AUI.Attributes.UpdateUI(AUI_PLAYER_UNIT_TAG)

				if not g_isPreviewShowing then
					return
				end	
				
				RemoveAllVisuals(AUI_PLAYER_UNIT_TAG)				
				AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)								
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].decrease_regen_color[2],
			width = "half",
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_regeneration_color"),
			tooltip = AUI.L10n.GetString("show_regeneration_color_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_increase_regen_color end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_increase_regen_color = value
	
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end	
				
					RemoveAllVisuals(AUI_PLAYER_UNIT_TAG)
	
					if value then
						AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)	
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_increase_regen_color,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "show_increase_regen_color") end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_degeneration_color"),
			tooltip = AUI.L10n.GetString("show_degeneration_color_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_decrease_regen_color end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_decrease_regen_color = value

					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end	
				
					RemoveAllVisuals(AUI_PLAYER_UNIT_TAG)

					if value then
						AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_decrease_regen_color,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "show_decrease_regen_color") end,	
		},			
	}

	return optionTable
end

local function GetTargetColorSettingsTable(_attributeId, submenuName)
local shieldType = AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_SHIELD

if _attributeId == AUI_ATTRIBUTE_TYPE_SECUNDARY_TARGET_HEALTH then
	shieldType = AUI_ATTRIBUTE_TYPE_SECUNDARY_TARGET_SHIELD	
end

local optionTable = 
	{	
		{
			type = "header",
			name = submenuName
		},	
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("health"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)												
			  end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].bar_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)												
			  end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].bar_color[2],
			width = "half",
		},	
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("shield"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][shieldType].bar_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][shieldType].bar_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)					
			end,
			default = defaultSettings[GetCurrentTemplateName()][shieldType].bar_color[1],
			width = "half",
		},	
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][shieldType].bar_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][shieldType].bar_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)					
			end,
			default = defaultSettings[GetCurrentTemplateName()][shieldType].bar_color[2],
			width = "half",
		},									
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("friendly"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_friendly_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_friendly_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				if preview then
					AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)
					AUI.Attributes.UpdateSingleBar(AUI_TARGET_UNIT_TAG, POWERTYPE_HEALTH, false, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, 
					{					
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_friendly_color[1]), 
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_friendly_color[2])
					})
				end													
			  end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].bar_friendly_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_friendly_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_friendly_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				if preview then
					AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)
					AUI.Attributes.UpdateSingleBar(AUI_TARGET_UNIT_TAG, POWERTYPE_HEALTH, false, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, 
					{					
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_friendly_color[1]), 
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_friendly_color[2])
					})						
				end												
			  end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].bar_friendly_color[2],
			width = "half",
		},				
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("allied") .. " (" .. AUI.L10n.GetString("npc") .. ")",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_npc_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_npc_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				if preview then
					AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)
					AUI.Attributes.UpdateSingleBar(AUI_TARGET_UNIT_TAG, POWERTYPE_HEALTH, false, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, 
					{					
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_npc_color[1]), 
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_npc_color[2])
					})							
				end
			  end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].bar_allied_npc_color[1],
			width = "half",
		},	
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_npc_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_npc_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				if preview then
					AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)
					AUI.Attributes.UpdateSingleBar(AUI_TARGET_UNIT_TAG, POWERTYPE_HEALTH, false, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, 
					{					
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_npc_color[1]), 
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_npc_color[2])
					})	
				end
			  end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].bar_allied_npc_color[2],
			width = "half",
		},	
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("allied") .. " (" .. AUI.L10n.GetString("player") .. ")",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_player_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a)
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_player_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				if preview then
					AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)
					AUI.Attributes.UpdateSingleBar(AUI_TARGET_UNIT_TAG, POWERTYPE_HEALTH, false, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, 
					{					
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_player_color[1]), 
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_player_color[2])
					})	
				end	
			  end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].bar_allied_player_color[1],
			width = "half",
		},	
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_player_color[2]):UnpackRGBA() end,
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_player_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a)
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_player_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				if preview then
					AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)
					AUI.Attributes.UpdateSingleBar(AUI_TARGET_UNIT_TAG, POWERTYPE_HEALTH, false, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, 
					{					
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_player_color[1]), 
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_allied_player_color[2])
					})	
				end		
			  end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].bar_allied_player_color[2],
			width = "half",
		},				
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("neutral"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_neutral_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_neutral_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				if preview then
					AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)
					AUI.Attributes.UpdateSingleBar(AUI_TARGET_UNIT_TAG, POWERTYPE_HEALTH, false, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, 
					{					
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_neutral_color[1]), 
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_neutral_color[2])
					})	
				end
			  end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].bar_neutral_color[1],
			width = "half",
		},	
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_neutral_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_neutral_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				if preview then
					AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)
					AUI.Attributes.UpdateSingleBar(AUI_TARGET_UNIT_TAG, POWERTYPE_HEALTH, false, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, 
					{					
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_neutral_color[1]), 
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_neutral_color[2])
					})	
				end
			  end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].bar_neutral_color[2],
			width = "half",
		},					
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("guard"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_guard_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a)
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_guard_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				if preview then
					AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)
					AUI.Attributes.UpdateSingleBar(AUI_TARGET_UNIT_TAG, POWERTYPE_HEALTH, false, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, 
					{					
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_guard_color[1]), 
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_guard_color[2])
					})
				end	
			  end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].bar_guard_color[1],
			width = "half",
		},	
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_guard_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a)
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_guard_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				if preview then
					AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)
					AUI.Attributes.UpdateSingleBar(AUI_TARGET_UNIT_TAG, POWERTYPE_HEALTH, false, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, 
					{					
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_guard_color[1]), 
						AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_guard_color[2])
					})
				end		
			  end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].bar_guard_color[2],
			width = "half",
		},	
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("regeneration"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].increase_regen_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].increase_regen_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}

				AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)

				if not g_isPreviewShowing then
					return
				end	
				
				RemoveAllVisuals(AUI_TARGET_UNIT_TAG)			
				AUI.Attributes.AddAttributeVisual(AUI_TARGET_UNIT_TAG, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)				
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].increase_regen_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].increase_regen_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].increase_regen_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}

				AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)
				
				if not g_isPreviewShowing then
					return
				end	
				
				RemoveAllVisuals(AUI_TARGET_UNIT_TAG)				
				AUI.Attributes.AddAttributeVisual(AUI_TARGET_UNIT_TAG, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)							
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].increase_regen_color[2],
			width = "half",
		},				
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("degeneration"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].decrease_regen_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].decrease_regen_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}

				AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)
				
				if not g_isPreviewShowing then
					return
				end					
				
				RemoveAllVisuals(AUI_TARGET_UNIT_TAG)				
				AUI.Attributes.AddAttributeVisual(AUI_TARGET_UNIT_TAG, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)							
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].decrease_regen_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].decrease_regen_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].decrease_regen_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}

				AUI.Attributes.UpdateUI(AUI_TARGET_UNIT_TAG)

				if not g_isPreviewShowing then
					return
				end	
				
				RemoveAllVisuals(AUI_TARGET_UNIT_TAG)				
				AUI.Attributes.AddAttributeVisual(AUI_TARGET_UNIT_TAG, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)						
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].decrease_regen_color[2],
			width = "half",
		},	
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_regeneration_color"),
			tooltip = AUI.L10n.GetString("show_regeneration_color_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_increase_regen_color end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_increase_regen_color = value

					AUI.Attributes.UpdateUI()		

					if not g_isPreviewShowing then
						return
					end	
				
					RemoveAllVisuals(AUI_TARGET_UNIT_TAG)
		
					if value then
						AUI.Attributes.AddAttributeVisual(AUI_TARGET_UNIT_TAG, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)	
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].show_increase_regen_color,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "show_increase_regen_color") end,
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_degeneration_color"),
			tooltip = AUI.L10n.GetString("show_degeneration_color_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_decrease_regen_color end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_decrease_regen_color = value

					AUI.Attributes.UpdateUI()	

					if not g_isPreviewShowing then
						return
					end	
				
					RemoveAllVisuals(AUI_TARGET_UNIT_TAG)

					if value then
						AUI.Attributes.AddAttributeVisual(AUI_TARGET_UNIT_TAG, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].show_decrease_regen_color,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "show_decrease_regen_color") end,
		},		
	}
	
	return optionTable
end

local function GetGroupColorSettingsTable()
	local optionTable = 
	{	
		{
			type = "header",
			name = AUI.L10n.GetString("group")
		},			
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("health") .. " (Tank)",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_tank[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_tank[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(4)
				AUI.Attributes.UpdateUI()	
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_tank[1],
			width = "half",
		},		
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_tank[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_tank[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(4)
				AUI.Attributes.UpdateUI()
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_tank[2],
			width = "half",
		},	
		
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("health") .. " (Healer)",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_healer[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_healer[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(4)
				AUI.Attributes.UpdateUI()	
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_healer[1],
			width = "half",
		},		
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_healer[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_healer[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(4)
				AUI.Attributes.UpdateUI()
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_healer[2],
			width = "half",
		},		
		
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("health") .. " (Damage)",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_dd[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_dd[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(4)
				AUI.Attributes.UpdateUI()	
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_dd[1],
			width = "half",
		},		
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_dd[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_dd[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(4)
				AUI.Attributes.UpdateUI()
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_color_dd[2],
			width = "half",
		},				
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("shield"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].bar_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].bar_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(4)
				AUI.Attributes.UpdateUI()				
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].bar_color[1],
			width = "half",
		},		
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].bar_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].bar_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(4)
				AUI.Attributes.UpdateUI()					
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].bar_color[2],
			width = "half",
		},
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("regeneration"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].increase_regen_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].increase_regen_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI()				
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].increase_regen_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].increase_regen_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].increase_regen_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI()						
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].increase_regen_color[2],
			width = "half",
		},				
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("degeneration"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].decrease_regen_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].decrease_regen_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}

				AUI.Attributes.Group.SetPreviewGroupSize(4)
				AUI.Attributes.UpdateUI()						
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].decrease_regen_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].decrease_regen_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].decrease_regen_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}

				AUI.Attributes.Group.SetPreviewGroupSize(4)
				AUI.Attributes.UpdateUI()						
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].decrease_regen_color[2],
			width = "half",
		},			
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_regeneration_color"),
			tooltip = AUI.L10n.GetString("show_regeneration_color_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_increase_regen_color end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_increase_regen_color = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end						
					
					for i = 1, 4, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						
						if value then
							AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
						end
					end					
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_increase_regen_color,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "show_increase_regen_color") end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_degeneration_color"),
			tooltip = AUI.L10n.GetString("show_degeneration_color_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_decrease_regen_color end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_decrease_regen_color = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end						
					
					for i = 1, 4, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						
						if value then
							AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
						end
					end	
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_decrease_regen_color,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "show_decrease_regen_color") end,	
		},		
	}
	return optionTable			
end

local function GetRaidColorSettingsTable()
	local optionTable = 
	{	
		{
			type = "header",
			name = AUI.L10n.GetString("raid")
		},			
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("health") .. " (Tank)",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_tank[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_tank[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(24)
				AUI.Attributes.UpdateUI()	
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_tank[1],
			width = "half",
		},		
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_tank[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_tank[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(24)
				AUI.Attributes.UpdateUI()
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_tank[2],
			width = "half",
		},			
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("health") .. " (Healer)",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_healer[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_healer[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(24)
				AUI.Attributes.UpdateUI()	
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_healer[1],
			width = "half",
		},		
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_healer[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_healer[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(24)
				AUI.Attributes.UpdateUI()
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_healer[2],
			width = "half",
		},			
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("health") .. " (Damage)",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_dd[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_dd[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(24)
				AUI.Attributes.UpdateUI()	
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_dd[1],
			width = "half",
		},		
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_dd[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_dd[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(4)
				AUI.Attributes.UpdateUI()
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_color_dd[2],
			width = "half",
		},				
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("shield"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].bar_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].bar_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(24)
				AUI.Attributes.UpdateUI()						
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].bar_color[1],
			width = "half",
		},		
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].bar_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].bar_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.Group.SetPreviewGroupSize(24)
				AUI.Attributes.UpdateUI()							
			  end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].bar_color[2],
			width = "half",
		},
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("regeneration"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].increase_regen_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].increase_regen_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI()				
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].increase_regen_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].increase_regen_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].increase_regen_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI()						
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].increase_regen_color[2],
			width = "half",
		},				
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("degeneration"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].decrease_regen_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].decrease_regen_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}

				AUI.Attributes.Group.SetPreviewGroupSize(24)
				AUI.Attributes.UpdateUI()
				
				if not g_isPreviewShowing then
					return
				end						
				
				for i = 1, 24, 1 do	
					unitTag = "group" .. i	
					RemoveAllVisuals(unitTag)
					
					if value then
						AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
					end
				end							
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].decrease_regen_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].decrease_regen_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].decrease_regen_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}

				AUI.Attributes.Group.SetPreviewGroupSize(24)
				AUI.Attributes.UpdateUI()						
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].decrease_regen_color[2],
			width = "half",
		},			
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_regeneration_color"),
			tooltip = AUI.L10n.GetString("show_regeneration_color_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_increase_regen_color end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_increase_regen_color = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end						
					
					for i = 1, 24, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						
						if value then
							AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
						end
					end					
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_increase_regen_color,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "show_increase_regen_color") end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_degeneration_color"),
			tooltip = AUI.L10n.GetString("show_degeneration_color_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_decrease_regen_color end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_decrease_regen_color = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end						
					
					for i = 1, 24, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						
						if value then
							AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
						end
					end	
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_decrease_regen_color,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "show_decrease_regen_color") end,	
		},			
	}
	return optionTable			
end

local function GetBossColorSettingsTable()
	local optionTable = 
	{	
		{
			type = "header",
			name = AUI.L10n.GetString("boss")
		},			
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("health"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].bar_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].bar_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)					
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].bar_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].bar_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].bar_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)					
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].bar_color[2],
			width = "half",
		},								
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("shield"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].bar_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].bar_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)						
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].bar_color[1],
			width = "half",
		},	
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].bar_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].bar_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)					
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].bar_color[2],
			width = "half",
		},					
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("regeneration"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].increase_regen_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].increase_regen_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)
							
				if not g_isPreviewShowing then
					return
				end								
							
				for i = 1, MAX_BOSSES, 1 do	
					unitTag = "boss" .. i	

					RemoveAllVisuals(unitTag)
					AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)								
				end					
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].increase_regen_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].increase_regen_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].increase_regen_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)
					
				if not g_isPreviewShowing then
					return
				end	
					
				for i = 1, MAX_BOSSES, 1 do	
					unitTag = "boss" .. i	

					RemoveAllVisuals(unitTag)
					AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)							
				end							
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].increase_regen_color[2],
			width = "half",
		},								
		{
			type = "colorpicker",
			name = AUI.L10n.GetString("color") .. ": " .. AUI.L10n.GetString("degeneration"),
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].decrease_regen_color[1]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].decrease_regen_color[1] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)
				
				if not g_isPreviewShowing then
					return
				end				
				
				for i = 1, MAX_BOSSES, 1 do	
					unitTag = "boss" .. i	

					RemoveAllVisuals(unitTag)
					AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)								
				end						
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].decrease_regen_color[1],
			width = "half",
		},
		{
			type = "colorpicker",
			getFunc = function() return AUI.Color.GetColorDefFromNamedRGBA(AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].decrease_regen_color[2]):UnpackRGBA() end,
			setFunc = function(r,g,b,a) 
				AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].decrease_regen_color[2] = {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a}
				AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)
				
				if not g_isPreviewShowing then
					return
				end					
				
				for i = 1, MAX_BOSSES, 1 do	
					unitTag = "boss" .. i	

					RemoveAllVisuals(unitTag)
					AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)															
				end							
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].decrease_regen_color[2],
			width = "half",
		},	
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_regeneration_color"),
			tooltip = AUI.L10n.GetString("show_regeneration_color_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_regen_color end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_regen_color = value
					AUI.Attributes.UpdateUI()
					
				if not g_isPreviewShowing then
					return
				end						
					
					for i = 1, MAX_BOSSES, 1 do	
						unitTag = "boss" .. i	

						RemoveAllVisuals(unitTag)					
						AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)	
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_regen_color,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "show_increase_regen_color") end,
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_degeneration_color"),
			tooltip = AUI.L10n.GetString("show_degeneration_color_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_regen_color end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_regen_color = value
					AUI.Attributes.UpdateUI()
				
				if not g_isPreviewShowing then
					return
				end					
				
					for i = 1, MAX_BOSSES, 1 do	
						unitTag = "boss" .. i	

						RemoveAllVisuals(unitTag)
						AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_regen_color,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "show_decrease_regen_color") end,
		},			
	}
	
	return optionTable
end

local function GetPlayerSettingsTable()
	local optionTable = 
	{	
		{
			type = "submenu",
			name = AUI_TXT_COLOR_SUBMENU:Colorize(AUI.L10n.GetString("player")),
			controls = 
			{
				{
					type = "checkbox",
					name = AUI.L10n.GetString("always_show"),
					tooltip = AUI.L10n.GetString("always_show_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()].show_player_always end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()].show_player_always = value	
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()].show_player_always,
					width = "full",
					disabled = function() 
						return false
					end,
				},															
				{
					type = "header",
					name = AUI.L10n.GetString("health"),
				},
				{
					type = "slider",
					name = AUI.L10n.GetString("width"),
					tooltip = AUI.L10n.GetString("width_tooltip"),
					min = 225,
					max = 450,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].width end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].width = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].width,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "width") end,
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("height"),
					tooltip = AUI.L10n.GetString("height_tooltip"),
					min = 16,
					max = 80,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].height end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].height = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].height,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "height") end,
				},					
				{
					type = "slider",
					name = AUI.L10n.GetString("opacity"),
					tooltip = AUI.L10n.GetString("opacity_tooltip"),
					min = 0.25,
					max = 1,
					step = 0.0625,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].opacity end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].opacity = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].opacity,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "opacity") end,
				},		
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_text"),
					tooltip = AUI.L10n.GetString("show_text_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_text end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_text = value					
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_text,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "show_text") end,
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_max_value"),
					tooltip = AUI.L10n.GetString("show_max_value_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_max_value end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_max_value = value	
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_max_value,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "show_max_value") end,
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_thousand_seperator"),
					tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].use_thousand_seperator end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].use_thousand_seperator = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].use_thousand_seperator,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "use_thousand_seperator") end,
				},
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_art"),
					tooltip = AUI.L10n.GetString("font_art_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].font_art) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].font_art = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].font_art),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "font_art") end,					
				},	
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_style"),
					tooltip = AUI.L10n.GetString("font_style_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontStyleList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].font_style) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontStyleList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].font_style = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].font_style),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "font_style") end,					
				},				
				{
					type = "slider",
					name = AUI.L10n.GetString("font_size"),
					tooltip = AUI.L10n.GetString("font_size_tooltip"),
					min = 4,
					max = 22,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].font_size end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].font_size = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].font_size,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "font_size") end,
				},				
				{
					type = "dropdown",
					name = AUI.L10n.GetString("alignment"),
					tooltip = AUI.L10n.GetString("alignment_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].bar_alignment) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].bar_alignment = value							
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].bar_alignment),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "bar_alignment") end,					
				},				
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_regeneration_effect"),
					tooltip = AUI.L10n.GetString("show_regeneration_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_increase_regen_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_increase_regen_effect = value
				
							AUI.Attributes.UpdateUI()
							
							if not g_isPreviewShowing then
								return
							end	
				
							RemoveAllVisuals(AUI_PLAYER_UNIT_TAG)
				
							if value then
								AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)	
							end
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_increase_regen_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "show_increase_regen_effect") end,	
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_degeneration_effect"),
					tooltip = AUI.L10n.GetString("show_degeneration_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_decrease_regen_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_decrease_regen_effect = value

							AUI.Attributes.UpdateUI()
							
							if not g_isPreviewShowing then
								return
							end	
							
							RemoveAllVisuals(AUI_PLAYER_UNIT_TAG)

							if value then
								AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
							end
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_decrease_regen_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "show_decrease_regen_effect") end,	
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_increase_armor_effect"),
					tooltip = AUI.L10n.GetString("show_increase_armor_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_increase_armor_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_increase_armor_effect = value
				
							AUI.Attributes.UpdateUI()
							
							if not g_isPreviewShowing then
								return
							end								
							
							RemoveAllVisuals(AUI_PLAYER_UNIT_TAG)
				
							if value then
								AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_INCREASED_STAT, STAT_ARMOR_RATING, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)	
							end
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_increase_armor_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "show_increase_armor_effect") end,	
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_decrease_armor_effect"),
					tooltip = AUI.L10n.GetString("show_decrease_armor_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_decrease_armor_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_decrease_armor_effect = value

							AUI.Attributes.UpdateUI()
							
							if not g_isPreviewShowing then
								return
							end							
							
							RemoveAllVisuals(AUI_PLAYER_UNIT_TAG)

							if value then
								AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_DECREASED_STAT, STAT_ARMOR_RATING, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
							end
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_decrease_armor_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "show_decrease_armor_effect") end,	
				},	
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_increase_power_effect"),
					tooltip = AUI.L10n.GetString("show_increase_power_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_increase_power_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_increase_power_effect = value
				
							AUI.Attributes.UpdateUI()
							
							if not g_isPreviewShowing then
								return
							end								
							
							RemoveAllVisuals(AUI_PLAYER_UNIT_TAG)
				
							if value then
								AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_INCREASED_STAT, STAT_POWER, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)	
							end
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_increase_power_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "show_increase_power_effect") end,	
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_decrease_power_effect"),
					tooltip = AUI.L10n.GetString("show_decrease_power_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_decrease_power_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_decrease_power_effect = value

							AUI.Attributes.UpdateUI()
							
							if not g_isPreviewShowing then
								return
							end								
							
							RemoveAllVisuals(AUI_PLAYER_UNIT_TAG)

							if value then
								AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_DECREASED_STAT, STAT_POWER, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
							end
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH].show_decrease_power_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "show_decrease_power_effect") end,	
				},				
				{
					type = "header",
					name = AUI.L10n.GetString("magicka"),
				},
				{
					type = "slider",
					name = AUI.L10n.GetString("width"),
					tooltip = AUI.L10n.GetString("width_tooltip"),
					min = 225,
					max = 450,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].width end,
					setFunc = function(value) 
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].width = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].width,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "width") end,
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("height"),
					tooltip = AUI.L10n.GetString("height_tooltip"),
					min = 16,
					max = 80,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].height end,
					setFunc = function(value) 
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].height = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].height,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "height") end,
				},				
				{
					type = "slider",
					name = AUI.L10n.GetString("opacity"),
					tooltip = AUI.L10n.GetString("opacity_tooltip"),
					min = 0.25,
					max = 1,
					step = 0.0625,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].opacity end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].opacity = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].opacity,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "opacity") end,
				},			
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_text"),
					tooltip = AUI.L10n.GetString("show_text_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].show_text end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].show_text = value					
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].show_text,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "show_text") end,
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_max_value"),
					tooltip = AUI.L10n.GetString("show_max_value_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].show_max_value end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].show_max_value = value					
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].show_max_value,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "show_max_value") end,
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_thousand_seperator"),
					tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].use_thousand_seperator end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].use_thousand_seperator = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].use_thousand_seperator,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "use_thousand_seperator") end,
				},
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_art"),
					tooltip = AUI.L10n.GetString("font_art_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].font_art) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].font_art = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].font_art),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA, "font_art") end,					
				},	
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_style"),
					tooltip = AUI.L10n.GetString("font_style_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontStyleList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].font_style) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontStyleList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].font_style = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].font_style),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA, "font_style") end,					
				},					
				{
					type = "slider",
					name = AUI.L10n.GetString("font_size"),
					tooltip = AUI.L10n.GetString("font_size_tooltip"),
					min = 4,
					max = 22,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].font_size end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].font_size = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].font_size,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "font_size") end,
				},	
				{
					type = "dropdown",
					name = AUI.L10n.GetString("alignment"),
					tooltip = AUI.L10n.GetString("alignment_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].bar_alignment) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].bar_alignment = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA].bar_alignment),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA, "bar_alignment") end,					
				},					
				{
					type = "header",
					name = AUI.L10n.GetString("stamina"),
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("width"),
					tooltip = AUI.L10n.GetString("width_tooltip"),
					min = 225,
					max = 450,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].width end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].width = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].width,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "width") end,	
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("height"),
					tooltip = AUI.L10n.GetString("height_tooltip"),
					min = 16,
					max = 80,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].height end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].height = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].height,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "height") end,
				},				
				{
					type = "slider",
					name = AUI.L10n.GetString("opacity"),
					tooltip = AUI.L10n.GetString("opacity_tooltip"),
					min = 0.25,
					max = 1,
					step = 0.0625,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].opacity end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].opacity = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].opacity,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "opacity") end,
				},		
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_text"),
					tooltip = AUI.L10n.GetString("show_text_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].show_text end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].show_text = value					
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].show_text,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "show_text") end,
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_max_value"),
					tooltip = AUI.L10n.GetString("show_max_value_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].show_max_value end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].show_max_value = value					
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].show_max_value,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "show_max_value") end,
				},	
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_thousand_seperator"),
					tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].use_thousand_seperator end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].use_thousand_seperator = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].use_thousand_seperator,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "use_thousand_seperator") end,
				},
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_art"),
					tooltip = AUI.L10n.GetString("font_art_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].font_art) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].font_art = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].font_art),					
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA, "font_art") end,					
				},	
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_style"),
					tooltip = AUI.L10n.GetString("font_style_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontStyleList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].font_style) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontStyleList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].font_style = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].font_style),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA, "font_style") end,					
				},					
				{
					type = "slider",
					name = AUI.L10n.GetString("font_size"),
					tooltip = AUI.L10n.GetString("font_size_tooltip"),
					min = 4,
					max = 22,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].font_size end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].font_size = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].font_size,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH, "font_size") end,
				},	
				{
					type = "dropdown",
					name = AUI.L10n.GetString("alignment"),
					tooltip = AUI.L10n.GetString("alignment_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].bar_alignment) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].bar_alignment = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA].bar_alignment),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA, "bar_alignment") end,					
				},					
				{
					type = "header",
					name = AUI.L10n.GetString("shield"),
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("width"),
					tooltip = AUI.L10n.GetString("width_tooltip"),
					min = 225,
					max = 450,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].width end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].width = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].width,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD, "width") end,
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("height"),
					tooltip = AUI.L10n.GetString("height_tooltip"),
					min = 16,
					max = 80,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].height end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].height = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].height,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD, "height") end,
				},					
				{
					type = "slider",
					name = AUI.L10n.GetString("opacity"),
					tooltip = AUI.L10n.GetString("opacity_tooltip"),
					min = 0.25,
					max = 1,
					step = 0.0625,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].opacity end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].opacity = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].opacity,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD, "opacity") end,
				},			
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_text"),
					tooltip = AUI.L10n.GetString("show_text_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].show_text end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].show_text = value					
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].show_text,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD, "show_text") end,
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_max_value"),
					tooltip = AUI.L10n.GetString("show_max_value_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].show_max_value end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].show_max_value = value					
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].show_max_value,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD, "show_max_value") end,
				},	
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_thousand_seperator"),
					tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].use_thousand_seperator end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].use_thousand_seperator = value
							AUI.Attributes.UpdateUI()
							
							if not g_isPreviewShowing then
								return
							end	
							
							AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_POWER_SHIELDING, STAT_MITIGATION, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH,  DEFAULT_PREVIEW_HP / 3, DEFAULT_PREVIEW_HP, false)
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].use_thousand_seperator,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD, "use_thousand_seperator") end,
				},	
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_art"),
					tooltip = AUI.L10n.GetString("font_art_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].font_art) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].font_art = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].font_art),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD, "font_art") end,					
				},
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_style"),
					tooltip = AUI.L10n.GetString("font_style_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontStyleList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].font_style) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontStyleList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].font_style = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].font_style),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD, "font_style") end,					
				},					
				{
					type = "slider",
					name = AUI.L10n.GetString("font_size"),
					tooltip = AUI.L10n.GetString("font_size_tooltip"),
					min = 4,
					max = 22,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].font_size end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].font_size = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].font_size,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD, "font_size") end,
				},	
				{
					type = "dropdown",
					name = AUI.L10n.GetString("alignment"),
					tooltip = AUI.L10n.GetString("alignment_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].bar_alignment) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].bar_alignment = value							
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD].bar_alignment),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD, "bar_alignment") end,					
				},					
				{
					type = "header",
					name = AUI.L10n.GetString("siege") .. " (" .. AUI.L10n.GetString("health") .. ")"
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("width"),
					tooltip = AUI.L10n.GetString("width_tooltip"),
					min = 225,
					max = 450,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].width end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].width = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].width,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE, "width") end,
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("height"),
					tooltip = AUI.L10n.GetString("height_tooltip"),
					min = 16,
					max = 80,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].height end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].height = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].height,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE, "height") end,
				},					
				{
					type = "slider",
					name = AUI.L10n.GetString("opacity"),
					tooltip = AUI.L10n.GetString("opacity_tooltip"),
					min = 0.25,
					max = 1,
					step = 0.0625,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].opacity end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].opacity = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].opacity,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE, "opacity") end,
				},			
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_text"),
					tooltip = AUI.L10n.GetString("show_text_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].show_text end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].show_text = value					
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].show_text,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE, "show_text") end,
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_max_value"),
					tooltip = AUI.L10n.GetString("show_max_value_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].show_max_value end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].show_max_value = value					
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].show_max_value,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE, "show_max_value") end,
				},	
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_thousand_seperator"),
					tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].use_thousand_seperator end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].use_thousand_seperator = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].use_thousand_seperator,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE, "use_thousand_seperator") end,
				},	
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_art"),
					tooltip = AUI.L10n.GetString("font_art_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].font_art) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].font_art = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].font_art),		
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE, "font_art") end,					
				},	
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_style"),
					tooltip = AUI.L10n.GetString("font_style_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontStyleList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].font_style) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontStyleList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].font_style = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].font_style),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE, "font_style") end,					
				},					
				{
					type = "slider",
					name = AUI.L10n.GetString("font_size"),
					tooltip = AUI.L10n.GetString("font_size_tooltip"),
					min = 4,
					max = 22,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].font_size end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].font_size = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].font_size,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE, "font_size") end,
				},	
				{
					type = "dropdown",
					name = AUI.L10n.GetString("alignment"),
					tooltip = AUI.L10n.GetString("alignment_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].bar_alignment) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].bar_alignment = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE].bar_alignment),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE, "bar_alignment") end,					
				},				
				{
					type = "header",
					name = AUI.L10n.GetString("stamina") .. " (" .. AUI.L10n.GetString("mount") .. ")",
				},	
					{
					type = "slider",
					name = AUI.L10n.GetString("width"),
					tooltip = AUI.L10n.GetString("width_tooltip"),
					min = 225,
					max = 450,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].width end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].width = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].width,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT, "width") end,
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("height"),
					tooltip = AUI.L10n.GetString("height_tooltip"),
					min = 16,
					max = 80,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].height end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].height = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].height,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT, "height") end,
				},				
				{
					type = "slider",
					name = AUI.L10n.GetString("opacity"),
					tooltip = AUI.L10n.GetString("opacity_tooltip"),
					min = 0.25,
					max = 1,
					step = 0.0625,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].opacity end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].opacity = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].opacity,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT, "opacity") end,
				},		
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_text"),
					tooltip = AUI.L10n.GetString("show_text_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].show_text end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].show_text = value					
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].show_text,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT, "show_text") end,
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_max_value"),
					tooltip = AUI.L10n.GetString("show_max_value_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].show_max_value end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].show_max_value = value					
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].show_max_value,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT, "show_max_value") end,
				},	
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_thousand_seperator"),
					tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].use_thousand_seperator end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].use_thousand_seperator = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].use_thousand_seperator,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT, "use_thousand_seperator") end,
				},
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_art"),
					tooltip = AUI.L10n.GetString("font_art_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].font_art) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].font_art = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].font_art),	
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT, "font_art") end,					
				},
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_style"),
					tooltip = AUI.L10n.GetString("font_style_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontStyleList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].font_style) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontStyleList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].font_style = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].font_style),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT, "font_style") end,					
				},					
				{
					type = "slider",
					name = AUI.L10n.GetString("font_size"),
					tooltip = AUI.L10n.GetString("font_size_tooltip"),
					min = 4,
					max = 22,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].font_size end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].font_size = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].font_size,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT, "font_size") end,
				},	
				{
					type = "dropdown",
					name = AUI.L10n.GetString("alignment"),
					tooltip = AUI.L10n.GetString("alignment_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].bar_alignment) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].bar_alignment = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT].bar_alignment),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT, "bar_alignment") end,					
				},					
				{
					type = "header",
					name = AUI.L10n.GetString("werewolf"),
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("width"),
					tooltip = AUI.L10n.GetString("width_tooltip"),
					min = 225,
					max = 450,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].width end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].width = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].width,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF, "width") end,
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("height"),
					tooltip = AUI.L10n.GetString("height_tooltip"),
					min = 16,
					max = 80,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].height end,
					setFunc = function(value) 
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].height = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].height,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF, "height") end,
				},				
				{
					type = "slider",
					name = AUI.L10n.GetString("opacity"),
					tooltip = AUI.L10n.GetString("opacity_tooltip"),
					min = 0.25,
					max = 1,
					step = 0.0625,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].opacity end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].opacity = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].opacity,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF, "opacity") end,
				},		
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_text"),
					tooltip = AUI.L10n.GetString("show_text_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].show_text end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].show_text = value					
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].show_text,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF, "show_text") end,
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_max_value"),
					tooltip = AUI.L10n.GetString("show_max_value_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].show_max_value end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].show_max_value = value					
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].show_max_value,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF, "show_max_value") end,
				},	
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_thousand_seperator"),
					tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].use_thousand_seperator end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].use_thousand_seperator = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].use_thousand_seperator,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF, "use_thousand_seperator") end,
				},
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_art"),
					tooltip = AUI.L10n.GetString("font_art_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].font_art) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].font_art = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].font_art),						
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF, "font_art") end,					
				},
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_style"),
					tooltip = AUI.L10n.GetString("font_style_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontStyleList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].font_style) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontStyleList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].font_style = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].font_style),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF, "font_style") end,					
				},					
				{
					type = "slider",
					name = AUI.L10n.GetString("font_size"),
					tooltip = AUI.L10n.GetString("font_size_tooltip"),
					min = 4,
					max = 22,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].font_size end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].font_size = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].font_size,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF, "font_size") end,
				},
				{
					type = "dropdown",
					name = AUI.L10n.GetString("alignment"),
					tooltip = AUI.L10n.GetString("alignment_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].bar_alignment) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].bar_alignment = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF].bar_alignment),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF, "bar_alignment") end,					
				},				
			}
		},
	}
	
	return optionTable
end

local function GetGroupSubmenuTable()
	local optionTable = 
	{
		type = "submenu",
		name = AUI_TXT_COLOR_SUBMENU:Colorize(AUI.L10n.GetString("group")),
		controls = {}
	}
	
	return optionTable
end

local function GetGroupSettingsTable()
	local optionTable = 
	{																
		{
			type = "header",
			name = AUI.L10n.GetString("health")
		},			
		{
			type = "slider",
			name = AUI.L10n.GetString("width"),
			tooltip = AUI.L10n.GetString("width_tooltip"),
			min = 160,
			max = 350,
			step = 2,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].width end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].width = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].width,
			width = "half",		
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "width") end,
		},	
		{
			type = "slider",
			name = AUI.L10n.GetString("height"),
			tooltip = AUI.L10n.GetString("height_tooltip"),
			min = 16,
			max = 48,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].height end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].height = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].height,
			width = "half",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "height") end,
		},					
		{
			type = "slider",
			name = AUI.L10n.GetString("distance"),
			tooltip = AUI.L10n.GetString("row_distance_tooltip"),
			min = 32,
			max = 60,
			step = 2,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].row_distance end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].row_distance = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].row_distance,
			width = "full",	
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "row_distance") end,					
		},		
		{
			type = "dropdown",
			name = AUI.L10n.GetString("font_art"),
			tooltip = AUI.L10n.GetString("font_art_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].font_art) end,
			setFunc = function(value) 
				value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].font_art = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
				end							
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].font_art),					
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "font_art") end,					
		},
		{
			type = "dropdown",
			name = AUI.L10n.GetString("font_style"),
			tooltip = AUI.L10n.GetString("font_style_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontStyleList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].font_style) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetFontStyleList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].font_style = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].font_style),
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "font_style") end,					
		},					
		{
			type = "slider",
			name = AUI.L10n.GetString("font_size"),
			tooltip = AUI.L10n.GetString("font_size_tooltip"),
			min = 4,
			max = 22,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].font_size end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].font_size = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].font_size,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "font_size") end,
		},		
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_account_name"),
			tooltip = AUI.L10n.GetString("show_account_name_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_account_name end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_account_name = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)	
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_account_name,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "show_account_name") end,
		},					
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_thousand_seperator"),
			tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].use_thousand_seperator end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].use_thousand_seperator = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)	
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].use_thousand_seperator,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "use_thousand_seperator") end,
		},	
		{
			type = "slider",
			name = AUI.L10n.GetString("opacity"),
			tooltip = AUI.L10n.GetString("opacity_tooltip"),
			min = 0.25,
			max = 1,
			step = 0.0625,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].opacity end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].opacity = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].opacity,
			width = "half",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "opacity") end,					
		},				
		{
			type = "slider",
			name = AUI.L10n.GetString("unit_out_of_range_opacity"),
			tooltip = AUI.L10n.GetString("unit_out_of_range_opacity_tooltip"),
			min = 0.25,
			max = 1,
			step = 0.0625,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].out_of_range_opacity end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].out_of_range_opacity = value
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].out_of_range_opacity = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)	
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].out_of_range_opacity,
			width = "half",	
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "out_of_range_opacity") end,					
		},
		{
			type = "dropdown",
			name = AUI.L10n.GetString("alignment"),
			tooltip = AUI.L10n.GetString("alignment_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_alignment) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_alignment = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)	
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].bar_alignment),
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "bar_alignment") end,					
		},				
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_regeneration_effect"),
			tooltip = AUI.L10n.GetString("show_regeneration_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_increase_regen_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_increase_regen_effect = value
		
					AUI.Attributes.Group.SetPreviewGroupSize(4)	
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end								
					
					for i = 1, 4, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						
						if value then
							AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
						end
					end	
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_increase_regen_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "show_increase_regen_effect") end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_degeneration_effect"),
			tooltip = AUI.L10n.GetString("show_degeneration_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_decrease_regen_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_decrease_regen_effect = value

					AUI.Attributes.Group.SetPreviewGroupSize(4)	
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end								
					
					for i = 1, 4, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						
						if value then
							AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
						end
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_decrease_regen_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "show_decrease_regen_effect") end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_increase_armor_effect"),
			tooltip = AUI.L10n.GetString("show_increase_armor_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_increase_armor_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_increase_armor_effect = value
		
					AUI.Attributes.Group.SetPreviewGroupSize(4)	
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end								
					
					for i = 1, 4, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						
						if value then
							AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_STAT, STAT_ARMOR_RATING, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)	
						end
					end
				end
			end,
			default = false,
			width = "full",
			disabled = function() return true end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_decrease_armor_effect"),
			tooltip = AUI.L10n.GetString("show_decrease_armor_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_decrease_armor_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_decrease_armor_effect = value

					AUI.Attributes.Group.SetPreviewGroupSize(4)	
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end								
					
					for i = 1, 4, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						
						if value then
							AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_STAT, STAT_ARMOR_RATING, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
						end
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_decrease_armor_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "show_decrease_armor_effect") end,	
		},	
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_increase_power_effect"),
			tooltip = AUI.L10n.GetString("show_increase_power_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_increase_power_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_increase_power_effect = value
		
					AUI.Attributes.Group.SetPreviewGroupSize(4)	
					AUI.Attributes.UpdateUI()
						
					if not g_isPreviewShowing then
						return
					end									
						
					for i = 1, 4, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						
						if value then
							AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_STAT, STAT_POWER, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
						end
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_increase_power_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "show_increase_power_effect") end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_decrease_power_effect"),
			tooltip = AUI.L10n.GetString("show_decrease_power_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_decrease_power_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_decrease_power_effect = value
					
					AUI.Attributes.Group.SetPreviewGroupSize(4)	
					AUI.Attributes.UpdateUI()
								
					if not g_isPreviewShowing then
						return
					end	
								
					for i = 1, 4, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_STAT, STAT_POWER, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
					end
				end							
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_HEALTH].show_decrease_power_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_HEALTH, "show_decrease_power_effect") end,	
		},										
	}

	return optionTable
end

local function GetGroupShieldSettingsTable()
	local optionTable = 
	{	
		{
			type = "header",
			name = AUI.L10n.GetString("shield"),
		},	
		{
			type = "slider",
			name = AUI.L10n.GetString("width"),
			tooltip = AUI.L10n.GetString("width_tooltip"),
			min = 225,
			max = 450,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].width end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].width = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].width,
			width = "half",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_SHIELD, "width") end,
		},	
		{
			type = "slider",
			name = AUI.L10n.GetString("height"),
			tooltip = AUI.L10n.GetString("height_tooltip"),
			min = 16,
			max = 80,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].height end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].height = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].height,
			width = "half",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_SHIELD, "height") end,
		},					
		{
			type = "slider",
			name = AUI.L10n.GetString("opacity"),
			tooltip = AUI.L10n.GetString("opacity_tooltip"),
			min = 0.25,
			max = 1,
			step = 0.0625,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].opacity end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].opacity = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].opacity,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_SHIELD, "opacity") end,
		},			
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_text"),
			tooltip = AUI.L10n.GetString("show_text_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].show_text end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].show_text = value	
					AUI.Attributes.Group.SetPreviewGroupSize(4)					
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].show_text,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_SHIELD, "show_text") end,
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_max_value"),
			tooltip = AUI.L10n.GetString("show_max_value_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].show_max_value end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].show_max_value = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)					
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].show_max_value,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_SHIELD, "show_max_value") end,
		},	
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_thousand_seperator"),
			tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].use_thousand_seperator end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].use_thousand_seperator = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end	
					
					AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_POWER_SHIELDING, STAT_MITIGATION, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH,  DEFAULT_PREVIEW_HP / 3, DEFAULT_PREVIEW_HP, false)
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].use_thousand_seperator,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_SHIELD, "use_thousand_seperator") end,
		},	
		{
			type = "dropdown",
			name = AUI.L10n.GetString("font_art"),
			tooltip = AUI.L10n.GetString("font_art_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].font_art) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].font_art = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].font_art),
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_SHIELD, "font_art") end,					
		},
		{
			type = "dropdown",
			name = AUI.L10n.GetString("font_style"),
			tooltip = AUI.L10n.GetString("font_style_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontStyleList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].font_style) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetFontStyleList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].font_style = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].font_style),
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_SHIELD, "font_style") end,					
		},					
		{
			type = "slider",
			name = AUI.L10n.GetString("font_size"),
			tooltip = AUI.L10n.GetString("font_size_tooltip"),
			min = 4,
			max = 22,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].font_size end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].font_size = value
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].font_size,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_SHIELD, "font_size") end,
		},	
		{
			type = "dropdown",
			name = AUI.L10n.GetString("alignment"),
			tooltip = AUI.L10n.GetString("alignment_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].bar_alignment) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].bar_alignment = value	
					AUI.Attributes.Group.SetPreviewGroupSize(4)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_GROUP_SHIELD].bar_alignment),
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_GROUP_SHIELD, "bar_alignment") end,					
		}
	}

	return optionTable
end

local function GetRaidSubmenuTable()
	local optionTable = 
	{
		type = "submenu",
		name = AUI_TXT_COLOR_SUBMENU:Colorize(AUI.L10n.GetString("raid")),
		controls = {}
	}
	
	return optionTable
end

local function GetRaidSettingsTable()
	local optionTable = 
	{																							
		{
			type = "header",
			name = AUI.L10n.GetString("health")
		},					
		{
			type = "slider",
			name = AUI.L10n.GetString("width"),
			tooltip = AUI.L10n.GetString("width_tooltip"),
			min = 100,
			max = 350,
			step = 2,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].width end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].width = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].width,
			width = "half",	
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "width") end,					
		},	
		{
			type = "slider",
			name = AUI.L10n.GetString("height"),
			tooltip = AUI.L10n.GetString("height_tooltip"),
			min = 32,
			max = 48,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].height end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].height = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].height,
			width = "half",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "height") end,
		},						
		{
			type = "slider",
			name = AUI.L10n.GetString("column_distance"),
			tooltip = AUI.L10n.GetString("column_distance_tooltip"),
			min = 2,
			max = 24,
			step = 2,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].column_distance end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].column_distance = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].column_distance,
			width = "half",	
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "column_distance") end,					
		},	
		{
			type = "slider",
			name = AUI.L10n.GetString("row_distance"),
			tooltip = AUI.L10n.GetString("row_distance_tooltip"),
			min = 2,
			max = 24,
			step = 2,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].row_distance end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].row_distance = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].row_distance,
			width = "half",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "row_distance") end,					
		},
		{
			type = "slider",
			name = AUI.L10n.GetString("row_count"),
			tooltip = AUI.L10n.GetString("row_count_tooltip"),
			min = 4,
			max = 12,
			step = 2,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].row_count end,
			setFunc = function(value) 
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].row_count = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].row_count,
			width = "half",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "row_count") end,	
		},	
		{
			type = "dropdown",
			name = AUI.L10n.GetString("font_art"),
			tooltip = AUI.L10n.GetString("font_art_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].font_art) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].font_art = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].font_art),					
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "font_art") end,					
		},
		{
			type = "dropdown",
			name = AUI.L10n.GetString("font_style"),
			tooltip = AUI.L10n.GetString("font_style_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontStyleList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].font_style) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetFontStyleList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].font_style = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].font_style),
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "font_style") end,					
		},				
		{
			type = "slider",
			name = AUI.L10n.GetString("font_size"),
			tooltip = AUI.L10n.GetString("font_size_tooltip"),
			min = 4,
			max = 22,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].font_size end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].font_size = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].font_size,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "font_size") end,
		},		
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_account_name"),
			tooltip = AUI.L10n.GetString("show_account_name_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_account_name end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_account_name = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_account_name,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "show_account_name") end,	
		},				
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_thousand_seperator"),
			tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].use_thousand_seperator end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].use_thousand_seperator = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].use_thousand_seperator,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "use_thousand_seperator") end,	
		},
		{
			type = "slider",
			name = AUI.L10n.GetString("opacity"),
			tooltip = AUI.L10n.GetString("opacity_tooltip"),
			min = 0.25,
			max = 1,
			step = 0.0625,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].opacity end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].opacity = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].opacity,
			width = "half",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "opacity") end,					
		},				
		{
			type = "slider",
			name = AUI.L10n.GetString("unit_out_of_range_opacity"),
			tooltip = AUI.L10n.GetString("unit_out_of_range_opacity_tooltip"),
			min = 0.25,
			max = 1,
			step = 0.0625,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].out_of_range_opacity end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].out_of_range_opacity = value
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].out_of_range_opacity = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)	
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].out_of_range_opacity,
			width = "half",	
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "out_of_range_opacity") end,							
		},
		{
			type = "dropdown",
			name = AUI.L10n.GetString("alignment"),
			tooltip = AUI.L10n.GetString("alignment_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_alignment) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_alignment = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)	
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].bar_alignment),
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "bar_alignment") end,					
		},					
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_regeneration_effect"),
			tooltip = AUI.L10n.GetString("show_regeneration_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_increase_regen_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_increase_regen_effect = value
		
					AUI.Attributes.Group.SetPreviewGroupSize(24)	
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end								
					
					for i = 1, 24, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						
						if value then
							AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
						end
					end	
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_increase_regen_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "show_increase_regen_effect") end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_degeneration_effect"),
			tooltip = AUI.L10n.GetString("show_degeneration_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_decrease_regen_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_decrease_regen_effect = value

					AUI.Attributes.Group.SetPreviewGroupSize(24)	
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end								
					
					for i = 1, 24, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						
						if value then
							AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
						end
					end	
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_decrease_regen_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "show_decrease_regen_effect") end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_increase_armor_effect"),
			tooltip = AUI.L10n.GetString("show_increase_armor_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_increase_armor_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_increase_armor_effect = value
		
					AUI.Attributes.Group.SetPreviewGroupSize(24)	
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end								
					
					for i = 1, 24, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						
						if value then
							AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_STAT, STAT_ARMOR_RATING, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)	
						end
					end
				end
			end,
			default = false,
			width = "full",
			disabled = function() return true end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_decrease_armor_effect"),
			tooltip = AUI.L10n.GetString("show_decrease_armor_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_decrease_armor_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_decrease_armor_effect = value

					AUI.Attributes.Group.SetPreviewGroupSize(24)	
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end								
					
					for i = 1, 24, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						
						if value then
							AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_STAT, STAT_ARMOR_RATING, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
						end
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_decrease_armor_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "show_decrease_armor_effect") end,	
		},	
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_increase_power_effect"),
			tooltip = AUI.L10n.GetString("show_increase_power_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_increase_power_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_increase_power_effect = value
		
					AUI.Attributes.Group.SetPreviewGroupSize(24)	
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end								
					
					for i = 1, 24, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						
						if value then
							AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_STAT, STAT_POWER, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
						end
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_increase_power_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "show_increase_power_effect") end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_decrease_power_effect"),
			tooltip = AUI.L10n.GetString("show_decrease_power_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_decrease_power_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_decrease_power_effect = value

					AUI.Attributes.Group.SetPreviewGroupSize(24)	
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end								
					
					for i = 1, 24, 1 do	
						unitTag = "group" .. i	
						RemoveAllVisuals(unitTag)
						AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_STAT, STAT_POWER, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_HEALTH].show_decrease_power_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_HEALTH, "show_decrease_power_effect") end,	
		}			
	}

	return optionTable
end

local function GetRaidShieldSettingsTable()
	local optionTable = 
	{	
		{
			type = "header",
			name = AUI.L10n.GetString("shield"),
		},	
		{
			type = "slider",
			name = AUI.L10n.GetString("width"),
			tooltip = AUI.L10n.GetString("width_tooltip"),
			min = 225,
			max = 450,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].width end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].width = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].width,
			width = "half",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_SHIELD, "width") end,
		},	
		{
			type = "slider",
			name = AUI.L10n.GetString("height"),
			tooltip = AUI.L10n.GetString("height_tooltip"),
			min = 16,
			max = 80,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].height end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].height = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].height,
			width = "half",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_SHIELD, "height") end,
		},					
		{
			type = "slider",
			name = AUI.L10n.GetString("opacity"),
			tooltip = AUI.L10n.GetString("opacity_tooltip"),
			min = 0.25,
			max = 1,
			step = 0.0625,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].opacity end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].opacity = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].opacity,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_SHIELD, "opacity") end,
		},			
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_text"),
			tooltip = AUI.L10n.GetString("show_text_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].show_text end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].show_text = value	
					AUI.Attributes.Group.SetPreviewGroupSize(24)					
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].show_text,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_SHIELD, "show_text") end,
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_max_value"),
			tooltip = AUI.L10n.GetString("show_max_value_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].show_max_value end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].show_max_value = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)					
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].show_max_value,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_SHIELD, "show_max_value") end,
		},	
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_thousand_seperator"),
			tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].use_thousand_seperator end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].use_thousand_seperator = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end	
					
					AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_POWER_SHIELDING, STAT_MITIGATION, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH,  DEFAULT_PREVIEW_HP / 3, DEFAULT_PREVIEW_HP, false)
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].use_thousand_seperator,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_SHIELD, "use_thousand_seperator") end,
		},	
		{
			type = "dropdown",
			name = AUI.L10n.GetString("font_art"),
			tooltip = AUI.L10n.GetString("font_art_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].font_art) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].font_art = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].font_art),
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_SHIELD, "font_art") end,					
		},
		{
			type = "dropdown",
			name = AUI.L10n.GetString("font_style"),
			tooltip = AUI.L10n.GetString("font_style_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontStyleList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].font_style) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetFontStyleList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].font_style = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].font_style),
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_SHIELD, "font_style") end,					
		},					
		{
			type = "slider",
			name = AUI.L10n.GetString("font_size"),
			tooltip = AUI.L10n.GetString("font_size_tooltip"),
			min = 4,
			max = 22,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].font_size end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].font_size = value
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].font_size,
			width = "full",
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_SHIELD, "font_size") end,
		},	
		{
			type = "dropdown",
			name = AUI.L10n.GetString("alignment"),
			tooltip = AUI.L10n.GetString("alignment_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].bar_alignment) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].bar_alignment = value	
					AUI.Attributes.Group.SetPreviewGroupSize(24)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_RAID_SHIELD].bar_alignment),
			disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_RAID_SHIELD, "bar_alignment") end,					
		}
	}

	return optionTable
end

local function GetBossAUISettingsTable()
	local optionTable = 
	{	
		{
			type = "submenu",
			name = AUI_TXT_COLOR_SUBMENU:Colorize(AUI.L10n.GetString("boss") .. " (AUI)"),
			controls = 
			{		
				{
					type = "header",
					name = AUI.L10n.GetString("health")
				},				
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show"),
					tooltip = AUI.L10n.GetString("show_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].display end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].display = value
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].display = value
							AUI.Attributes.UpdateUI()

							if value then
								AUI.Attributes.ShowFrame(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH)
								AUI.Attributes.ShowFrame(AUI_ATTRIBUTE_TYPE_BOSS_SHIELD)
							else
								AUI.Attributes.HideFrame(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH)
								AUI.Attributes.HideFrame(AUI_ATTRIBUTE_TYPE_BOSS_SHIELD)							
							end
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].display,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "display") end,
				},			
				{
					type = "slider",
					name = AUI.L10n.GetString("width"),
					tooltip = AUI.L10n.GetString("width_tooltip"),
					min = 160,
					max = 350,
					step = 2,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].width end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].width = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].width,
					width = "half",		
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "width") end,
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("height"),
					tooltip = AUI.L10n.GetString("height_tooltip"),
					min = 16,
					max = 48,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].height end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].height = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].height,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "height") end,
				},					
				{
					type = "slider",
					name = AUI.L10n.GetString("column_distance"),
					tooltip = AUI.L10n.GetString("column_distance_tooltip"),
					min = 2,
					max = 24,
					step = 2,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].column_distance end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].column_distance = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].column_distance,
					width = "half",	
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "column_distance") end,					
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("row_distance"),
					tooltip = AUI.L10n.GetString("row_distance_tooltip"),
					min = 2,
					max = 24,
					step = 2,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].row_distance end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].row_distance = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].row_distance,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "row_distance") end,					
				},
				{
					type = "slider",
					name = AUI.L10n.GetString("row_count"),
					tooltip = AUI.L10n.GetString("row_count_tooltip"),
					min = 2,
					max = 6,
					step = 2,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].row_count end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].row_count = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].row_count,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "row_count") end,	
				},	
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_art"),
					tooltip = AUI.L10n.GetString("font_art_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].font_art) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].font_art = value
							AUI.Attributes.UpdateUI()
						end							
					end,	
					default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].font_art),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "font_art") end,					
				},
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_style"),
					tooltip = AUI.L10n.GetString("font_style_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontStyleList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].font_style) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontStyleList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].font_style = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].font_style),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "font_style") end,					
				},					
				{
					type = "slider",
					name = AUI.L10n.GetString("font_size"),
					tooltip = AUI.L10n.GetString("font_size_tooltip"),
					min = 4,
					max = 22,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].font_size end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].font_size = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].font_size,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "font_size") end,
				},									
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_thousand_seperator"),
					tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].use_thousand_seperator end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].use_thousand_seperator = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].use_thousand_seperator,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "use_thousand_seperator") end,
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("opacity"),
					tooltip = AUI.L10n.GetString("opacity_tooltip"),
					min = 0.25,
					max = 1,
					step = 0.0625,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].opacity end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].opacity = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].opacity,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "opacity") end,					
				},
				{
					type = "dropdown",
					name = AUI.L10n.GetString("alignment"),
					tooltip = AUI.L10n.GetString("alignment_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].bar_alignment) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].bar_alignment = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].bar_alignment),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "bar_alignment") end,					
				},										
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_regeneration_effect"),
					tooltip = AUI.L10n.GetString("show_regeneration_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_regen_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_regen_effect = value
				
							AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)			
				
							if not g_isPreviewShowing then
								return
							end					
				
							for i = 1, MAX_BOSSES, 1 do	
								unitTag = "boss" .. i	

								RemoveAllVisuals(unitTag)
								AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)							
							end	
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_regen_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "show_increase_regen_effect") end,	
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_degeneration_effect"),
					tooltip = AUI.L10n.GetString("show_degeneration_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_regen_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_regen_effect = value

							AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)

							if not g_isPreviewShowing then
								return
							end	

							for i = 1, MAX_BOSSES, 1 do	
								unitTag = "boss" .. i	

								RemoveAllVisuals(unitTag)
								AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)							
							end
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_regen_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "show_decrease_regen_effect") end,	
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_increase_armor_effect"),
					tooltip = AUI.L10n.GetString("show_increase_armor_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_armor_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_armor_effect = value
				
							AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)			
				
							if not g_isPreviewShowing then
								return
							end					
				
							for i = 1, MAX_BOSSES, 1 do	
								unitTag = "boss" .. i	

								RemoveAllVisuals(unitTag)
								AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_STAT, STAT_ARMOR_RATING, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)							
							end
						end
					end,
					default = false,
					width = "full",
					disabled = function() return true end,	
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_decrease_armor_effect"),
					tooltip = AUI.L10n.GetString("show_decrease_armor_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_armor_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_armor_effect = value

							AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)

							if not g_isPreviewShowing then
								return
							end	

							for i = 1, MAX_BOSSES, 1 do	
								unitTag = "boss" .. i	

								RemoveAllVisuals(unitTag)
								AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_STAT, STAT_ARMOR_RATING, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)						
							end
						end							
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_armor_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "show_decrease_armor_effect") end,	
				},	
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_increase_power_effect"),
					tooltip = AUI.L10n.GetString("show_increase_power_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_power_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_power_effect = value
				
							if not g_isPreviewShowing then
								return
							end					
				
							AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)
				
							for i = 1, MAX_BOSSES, 1 do	
								unitTag = "boss" .. i	

								RemoveAllVisuals(unitTag)
								AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_STAT, STAT_POWER, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)							
							end
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_power_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "show_increase_power_effect") end,	
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_decrease_power_effect"),
					tooltip = AUI.L10n.GetString("show_decrease_power_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_power_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_power_effect = value

							AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)

							if not g_isPreviewShowing then
								return
							end	

							for i = 1, MAX_BOSSES, 1 do	
								unitTag = "boss" .. i	

								RemoveAllVisuals(unitTag)
								AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_STAT, STAT_POWER, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)					
							end
						end							
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_power_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "show_decrease_power_effect") end,	
				},
				{
					type = "header",
					name = AUI.L10n.GetString("shield"),
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("width"),
					tooltip = AUI.L10n.GetString("width_tooltip"),
					min = 225,
					max = 450,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].width end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].width = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].width,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_SHIELD, "width") end,
				},	
				{
					type = "slider",
					name = AUI.L10n.GetString("height"),
					tooltip = AUI.L10n.GetString("height_tooltip"),
					min = 16,
					max = 80,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].height end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].height = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].height,
					width = "half",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_SHIELD, "height") end,
				},					
				{
					type = "slider",
					name = AUI.L10n.GetString("opacity"),
					tooltip = AUI.L10n.GetString("opacity_tooltip"),
					min = 0.25,
					max = 1,
					step = 0.0625,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].opacity end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].opacity = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].opacity,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_SHIELD, "opacity") end,
				},			
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_text"),
					tooltip = AUI.L10n.GetString("show_text_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].show_text end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].show_text = value					
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].show_text,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_SHIELD, "show_text") end,
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_max_value"),
					tooltip = AUI.L10n.GetString("show_max_value_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].show_max_value end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].show_max_value = value				
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].show_max_value,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_SHIELD, "show_max_value") end,
				},	
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_thousand_seperator"),
					tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].use_thousand_seperator end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].use_thousand_seperator = value
							AUI.Attributes.UpdateUI()
							
							if not g_isPreviewShowing then
								return
							end	
							
							AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_POWER_SHIELDING, STAT_MITIGATION, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH,  DEFAULT_PREVIEW_HP / 3, DEFAULT_PREVIEW_HP, false)
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].use_thousand_seperator,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_SHIELD, "use_thousand_seperator") end,
				},	
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_art"),
					tooltip = AUI.L10n.GetString("font_art_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].font_art) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].font_art = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].font_art),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_SHIELD, "font_art") end,					
				},
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_style"),
					tooltip = AUI.L10n.GetString("font_style_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontStyleList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].font_style) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontStyleList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].font_style = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].font_style),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_SHIELD, "font_style") end,					
				},					
				{
					type = "slider",
					name = AUI.L10n.GetString("font_size"),
					tooltip = AUI.L10n.GetString("font_size_tooltip"),
					min = 4,
					max = 22,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].font_size end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].font_size = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].font_size,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_SHIELD, "font_size") end,
				},	
				{
					type = "dropdown",
					name = AUI.L10n.GetString("alignment"),
					tooltip = AUI.L10n.GetString("alignment_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].bar_alignment) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].bar_alignment = value	
							AUI.Attributes.UpdateUI()
						end
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_SHIELD].bar_alignment),
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_SHIELD, "bar_alignment") end,					
				}			
			}			
		}
	}

	return optionTable
end

local function GetBossDefaultSettingsTable()
	local optionTable = 
	{	
		{
			type = "submenu",
			name = AUI_TXT_COLOR_SUBMENU:Colorize(AUI.L10n.GetString("boss") ..  " (" .. AUI.L10n.GetString("default") .. ")"),
			controls = 
			{		
				{
					type = "header",
					name = AUI.L10n.GetString("health"),
				},			
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_text"),
					tooltip = AUI.L10n.GetString("show_text_tooltip"),
					getFunc = function() return AUI.Settings.Attributes.boss_show_text end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes.boss_show_text = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings.boss_show_text,
					width = "full",
				},	
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_thousand_seperator"),
					tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
					getFunc = function() return AUI.Settings.Attributes.boss_use_thousand_seperator end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes.boss_use_thousand_seperator = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings.boss_use_thousand_seperator,
					width = "full",
				},					
				{
					type = "slider",
					name = AUI.L10n.GetString("font_size"),
					tooltip = AUI.L10n.GetString("font_size_tooltip"),
					min = 4 ,
					max = 22 ,
					step = 1,
					getFunc = function() return AUI.Settings.Attributes.boss_font_size end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes.boss_font_size = value
							AUI.Attributes.UpdateUI()
						end
					end,
					default = defaultSettings.boss_font_size,
					width = "full",
				},
				{
					type = "dropdown",
					name = AUI.L10n.GetString("font_art"),
					tooltip = AUI.L10n.GetString("font_art_tooltip"),
					choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
					getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes.boss_font_art) end,
					setFunc = function(value)
						value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
						if value ~= nil then
							AUI.Settings.Attributes.boss_font_art = value
							AUI.Attributes.UpdateUI()
						end							
					end,
					default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings.boss_font_art),		
				},							
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_regeneration_effect"),
					tooltip = AUI.L10n.GetString("show_regeneration_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_regen_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_regen_effect = value
				
							AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)			
				
							if not g_isPreviewShowing then
								return
							end					
				
							for i = 1, MAX_BOSSES, 1 do	
								unitTag = "boss" .. i	

								RemoveAllVisuals(unitTag)
								AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)							
							end	
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_regen_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "show_increase_regen_effect") end,	
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_degeneration_effect"),
					tooltip = AUI.L10n.GetString("show_degeneration_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_regen_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_regen_effect = value

							AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)

							if not g_isPreviewShowing then
								return
							end	

							for i = 1, MAX_BOSSES, 1 do	
								unitTag = "boss" .. i	

								RemoveAllVisuals(unitTag)
								AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)							
							end
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_regen_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "show_decrease_regen_effect") end,	
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_increase_armor_effect"),
					tooltip = AUI.L10n.GetString("show_increase_armor_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_armor_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_armor_effect = value
				
							AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)			
				
							if not g_isPreviewShowing then
								return
							end					
				
							for i = 1, MAX_BOSSES, 1 do	
								unitTag = "boss" .. i	

								RemoveAllVisuals(unitTag)
								AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_STAT, STAT_ARMOR_RATING, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)							
							end
						end
					end,
					default = false,
					width = "full",
					disabled = function() return true end,	
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_decrease_armor_effect"),
					tooltip = AUI.L10n.GetString("show_decrease_armor_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_armor_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_armor_effect = value

							AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)

							if not g_isPreviewShowing then
								return
							end	

							for i = 1, MAX_BOSSES, 1 do	
								unitTag = "boss" .. i	

								RemoveAllVisuals(unitTag)
								AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_STAT, STAT_ARMOR_RATING, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)						
							end
						end							
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_armor_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "show_decrease_armor_effect") end,	
				},	
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_increase_power_effect"),
					tooltip = AUI.L10n.GetString("show_increase_power_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_power_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_power_effect = value
				
							if not g_isPreviewShowing then
								return
							end					
				
							AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)
				
							for i = 1, MAX_BOSSES, 1 do	
								unitTag = "boss" .. i	

								RemoveAllVisuals(unitTag)
								AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_INCREASED_STAT, STAT_POWER, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)							
							end
						end
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_increase_power_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "show_increase_power_effect") end,	
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("show_decrease_power_effect"),
					tooltip = AUI.L10n.GetString("show_decrease_power_effect_tooltip"),
					getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_power_effect end,
					setFunc = function(value)
						if value ~= nil then
							AUI.Settings.Attributes[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_power_effect = value

							AUI.Attributes.UpdateUI(AUI_BOSS_UNIT_TAG)

							if not g_isPreviewShowing then
								return
							end	

							for i = 1, MAX_BOSSES, 1 do	
								unitTag = "boss" .. i	

								RemoveAllVisuals(unitTag)
								AUI.Attributes.AddAttributeVisual(unitTag, ATTRIBUTE_VISUAL_DECREASED_STAT, STAT_POWER, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)					
							end
						end							
					end,
					default = defaultSettings[GetCurrentTemplateName()][AUI_ATTRIBUTE_TYPE_BOSS_HEALTH].show_decrease_power_effect,
					width = "full",
					disabled = function() return IsSettingDisabled(AUI_ATTRIBUTE_TYPE_BOSS_HEALTH, "show_decrease_power_effect") end,	
				}	
			}			
		}
	}

	return optionTable
end

local function GetTargetSubmenuTable(_subMenuName)
	local optionTable = 
	{	
		type = "submenu",
		name = AUI_TXT_COLOR_SUBMENU:Colorize(_subMenuName),
		controls = {}
	}
	
	return optionTable
end

local function GetTargetSettingTable(_attributeId)
	local optionTable = 
	{	
		{
			type = "header",
			name = AUI.L10n.GetString("health")
		},	
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show"),
			tooltip = AUI.L10n.GetString("show_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].display end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].display = value
					AUI.Attributes.HideFrame(_attributeId)
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].display,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "display") end,			
		},	
		{
			type = "slider",
			name = AUI.L10n.GetString("width"),
			tooltip = AUI.L10n.GetString("width_tooltip"),
			min = 225,
			max = 400,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].width end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].width = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].width,
			width = "half",
			disabled = function() return IsSettingDisabled(_attributeId, "width") end,
		},	
		{
			type = "slider",
			name = AUI.L10n.GetString("height"),
			tooltip = AUI.L10n.GetString("height_tooltip"),
			min = 16,
			max = 80,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].height end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].height = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].height,
			width = "half",
			disabled = function() return IsSettingDisabled(_attributeId, "height") end,
		},					
		{
			type = "slider",
			name = AUI.L10n.GetString("opacity"),
			tooltip = AUI.L10n.GetString("opacity_tooltip"),
			min = 0.25,
			max = 1,
			step = 0.0625,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].opacity end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].opacity = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].opacity,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "opacity") end,
		},				
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_account_name"),
			tooltip = AUI.L10n.GetString("show_account_name_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_account_name end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_account_name = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].show_account_name,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "show_account_name") end,
		},
		{
			type = "dropdown",
			name = AUI.L10n.GetString("caption"),
			tooltip = AUI.L10n.GetString("caption_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetCaptionTypeList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetCaptionTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].caption_mode) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetCaptionTypeList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].caption_mode = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetCaptionTypeList(), defaultSettings[GetCurrentTemplateName()][_attributeId].caption_mode),
			disabled = function() return IsSettingDisabled(_attributeId, "caption_mode") end,					
		},		
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_text"),
			tooltip = AUI.L10n.GetString("show_text_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_text end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_text = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].show_text,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "show_text") end,
		},	
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_max_value"),
			tooltip = AUI.L10n.GetString("show_max_value_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_max_value end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_max_value = value					
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].show_max_value,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "show_max_value") end,
		},					
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_thousand_seperator"),
			tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].use_thousand_seperator end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].use_thousand_seperator = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].use_thousand_seperator,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "use_thousand_seperator") end,
		},							
		{
			type = "slider",
			name = AUI.L10n.GetString("font_size"),
			tooltip = AUI.L10n.GetString("font_size_tooltip"),
			min = 4 ,
			max = 22 ,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].font_size end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].font_size = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].font_size,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "font_size") end,
		},
		{
			type = "dropdown",
			name = AUI.L10n.GetString("font_art"),
			tooltip = AUI.L10n.GetString("font_art_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].font_art) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].font_art = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][_attributeId].font_art),
			disabled = function() return IsSettingDisabled(_attributeId, "font_art") end,					
		},
		{
			type = "dropdown",
			name = AUI.L10n.GetString("alignment"),
			tooltip = AUI.L10n.GetString("alignment_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_alignment) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_alignment = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][_attributeId].bar_alignment),
			disabled = function() return IsSettingDisabled(_attributeId, "bar_alignment") end,					
		},					
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_regeneration_effect"),
			tooltip = AUI.L10n.GetString("show_regeneration_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_increase_regen_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_increase_regen_effect = value
		
					if not g_isPreviewShowing then
						return
					end					
		
					RemoveAllVisuals(AUI_TARGET_UNIT_TAG)
		
					if value then
						AUI.Attributes.AddAttributeVisual(AUI_TARGET_UNIT_TAG, ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)	
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].show_increase_regen_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "show_increase_regen_effect") end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_degeneration_effect"),
			tooltip = AUI.L10n.GetString("show_degeneration_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_decrease_regen_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_decrease_regen_effect = value

					if not g_isPreviewShowing then
						return
					end	

					RemoveAllVisuals(AUI_TARGET_UNIT_TAG)

					if value then
						AUI.Attributes.AddAttributeVisual(AUI_TARGET_UNIT_TAG, ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER, STAT_HEALTH_REGEN_COMBAT, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].show_decrease_regen_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "show_decrease_regen_effect") end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_increase_armor_effect"),
			tooltip = AUI.L10n.GetString("show_increase_armor_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_increase_armor_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_increase_armor_effect = value
		
					if not g_isPreviewShowing then
						return
					end					
		
					RemoveAllVisuals(AUI_TARGET_UNIT_TAG)
		
					if value then
						AUI.Attributes.AddAttributeVisual(AUI_TARGET_UNIT_TAG, ATTRIBUTE_VISUAL_INCREASED_STAT, STAT_ARMOR_RATING, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)	
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].show_increase_armor_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "show_increase_armor_effect") end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_decrease_armor_effect"),
			tooltip = AUI.L10n.GetString("show_decrease_armor_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_decrease_armor_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_decrease_armor_effect = value

					if not g_isPreviewShowing then
						return
					end	

					RemoveAllVisuals(AUI_TARGET_UNIT_TAG)

					if value then
						AUI.Attributes.AddAttributeVisual(AUI_TARGET_UNIT_TAG, ATTRIBUTE_VISUAL_DECREASED_STAT, STAT_ARMOR_RATING, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].show_decrease_armor_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "show_decrease_armor_effect") end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_increase_power_effect"),
			tooltip = AUI.L10n.GetString("show_increase_power_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_increase_power_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_increase_power_effect = value
		
					if not g_isPreviewShowing then
						return
					end					
		
					RemoveAllVisuals(AUI_TARGET_UNIT_TAG)
		
					if value then
						AUI.Attributes.AddAttributeVisual(AUI_TARGET_UNIT_TAG, ATTRIBUTE_VISUAL_INCREASED_STAT, STAT_POWER, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, 100, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)	
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].show_increase_power_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "show_increase_power_effect") end,	
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_decrease_power_effect"),
			tooltip = AUI.L10n.GetString("show_decrease_power_effect_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_decrease_power_effect end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_decrease_power_effect = value

					if not g_isPreviewShowing then
						return
					end	

					RemoveAllVisuals(AUI_TARGET_UNIT_TAG)

					if value then
						AUI.Attributes.AddAttributeVisual(AUI_TARGET_UNIT_TAG, ATTRIBUTE_VISUAL_DECREASED_STAT, STAT_POWER, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH, -150, DEFAULT_PREVIEW_HP, DEFAULT_PREVIEW_HP, false)
					end
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].show_decrease_power_effect,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "show_decrease_power_effect") end,	
		}				
	}
	
	return optionTable
end

local function GetTargetShieldSettingTable(_attributeId)
	local optionTable = 
	{	
		{
			type = "header",
			name = AUI.L10n.GetString("shield"),
		},	
		{
			type = "slider",
			name = AUI.L10n.GetString("width"),
			tooltip = AUI.L10n.GetString("width_tooltip"),
			min = 225,
			max = 450,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].width end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].width = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].width,
			width = "half",
			disabled = function() return IsSettingDisabled(_attributeId, "width") end,
		},	
		{
			type = "slider",
			name = AUI.L10n.GetString("height"),
			tooltip = AUI.L10n.GetString("height_tooltip"),
			min = 16,
			max = 80,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].height end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].height = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].height,
			width = "half",
			disabled = function() return IsSettingDisabled(_attributeId, "height") end,
		},					
		{
			type = "slider",
			name = AUI.L10n.GetString("opacity"),
			tooltip = AUI.L10n.GetString("opacity_tooltip"),
			min = 0.25,
			max = 1,
			step = 0.0625,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].opacity end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].opacity = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].opacity,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "opacity") end,
		},			
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_text"),
			tooltip = AUI.L10n.GetString("show_text_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_text end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_text = value					
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].show_text,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "show_text") end,
		},
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_max_value"),
			tooltip = AUI.L10n.GetString("show_max_value_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_max_value end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].show_max_value = value					
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].show_max_value,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "show_max_value") end,
		},	
		{
			type = "checkbox",
			name = AUI.L10n.GetString("show_thousand_seperator"),
			tooltip = AUI.L10n.GetString("show_thousand_seperator_tooltip"),
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].use_thousand_seperator end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].use_thousand_seperator = value
					AUI.Attributes.UpdateUI()
					
					if not g_isPreviewShowing then
						return
					end	
					
					AUI.Attributes.AddAttributeVisual(AUI_PLAYER_UNIT_TAG, ATTRIBUTE_VISUAL_POWER_SHIELDING, STAT_MITIGATION, ATTRIBUTE_HEALTH, POWERTYPE_HEALTH,  DEFAULT_PREVIEW_HP / 3, DEFAULT_PREVIEW_HP, false)
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].use_thousand_seperator,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "use_thousand_seperator") end,
		},	
		{
			type = "dropdown",
			name = AUI.L10n.GetString("font_art"),
			tooltip = AUI.L10n.GetString("font_art_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontTypeList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].font_art) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetFontTypeList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].font_art = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetFontTypeList(), defaultSettings[GetCurrentTemplateName()][_attributeId].font_art),
			disabled = function() return IsSettingDisabled(_attributeId, "font_art") end,					
		},
		{
			type = "dropdown",
			name = AUI.L10n.GetString("font_style"),
			tooltip = AUI.L10n.GetString("font_style_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetFontStyleList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].font_style) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetFontStyleList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].font_style = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetFontStyleList(), defaultSettings[GetCurrentTemplateName()][_attributeId].font_style),
			disabled = function() return IsSettingDisabled(_attributeId, "font_style") end,					
		},					
		{
			type = "slider",
			name = AUI.L10n.GetString("font_size"),
			tooltip = AUI.L10n.GetString("font_size_tooltip"),
			min = 4,
			max = 22,
			step = 1,
			getFunc = function() return AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].font_size end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].font_size = value
					AUI.Attributes.UpdateUI()
				end
			end,
			default = defaultSettings[GetCurrentTemplateName()][_attributeId].font_size,
			width = "full",
			disabled = function() return IsSettingDisabled(_attributeId, "font_size") end,
		},	
		{
			type = "dropdown",
			name = AUI.L10n.GetString("alignment"),
			tooltip = AUI.L10n.GetString("alignment_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Menu.GetAtrributesBarAlignmentList(), "value"),
			getFunc = function() return AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_alignment) end,
			setFunc = function(value)
				value = AUI.Table.GetKey(AUI.Menu.GetAtrributesBarAlignmentList(), value)
				if value ~= nil then
					AUI.Settings.Attributes[GetCurrentTemplateName()][_attributeId].bar_alignment = value							
					AUI.Attributes.UpdateUI()
				end
			end,
			default = AUI.Table.GetValue(AUI.Menu.GetAtrributesBarAlignmentList(), defaultSettings[GetCurrentTemplateName()][_attributeId].bar_alignment),
			disabled = function() return IsSettingDisabled(_attributeId, "bar_alignment") end,					
		},				
	}
	
	return optionTable
end

local function CreateOptions()
	local options = 
	{	
		{
			type = "header",
			name = AUI_TXT_COLOR_HEADER:Colorize(AUI.L10n.GetString("general"))
		},	
		{
			type = "checkbox",
			name = AUI.L10n.GetString("acount_wide"),
			tooltip = AUI.L10n.GetString("acount_wide_tooltip"),
			getFunc = function() return AUI.MainSettings.modul_attributes_account_wide end,
			setFunc = function(value)
				if value ~= nil then
					if value ~= AUI.MainSettings.modul_attributes_account_wide then
						AUI.MainSettings.modul_attributes_account_wide = value
						ReloadUI()
					else
						AUI.MainSettings.modul_attributes_account_wide = value
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
					if value == true then	
						AUI.Attributes.ShowPreview()	
					else
						AUI.Attributes.HidePreview()
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
			name = AUI.L10n.GetString("lock_window"),
			tooltip = AUI.L10n.GetString("lock_window_tooltip"),
			getFunc = function() return AUI.Settings.Attributes.lock_windows end,
			setFunc = function(value)
				if value ~= nil then
					AUI.Settings.Attributes.lock_windows = value
				end
			end,
			default = defaultSettings.lock_windows,
			width = "full",
		},	
		{
			type = "dropdown",
			name = AUI.L10n.GetString("template"),
			tooltip = AUI.L10n.GetString("template_tooltip"),
			choices = AUI.Table.GetChoiceList(AUI.Attributes.GetThemeNames(), "value"),
			getFunc = function() 					
				return AUI.Table.GetValue(AUI.Attributes.GetThemeNames(), GetCurrentTemplateName())						
			end,
			setFunc = function(value) 
				value = AUI.Table.GetKey(AUI.Attributes.GetThemeNames(), value)
				if value ~= nil then
					if GetCurrentTemplateName() ~= value then
						if value ~= AUI.Settings.Template.Attributes then
							AUI.Settings.Template.Attributes = value
							ReloadUI()
						else
							AUI.Settings.Template.Attributes = value
						end
					end
				end
			end,
			warning = AUI.L10n.GetString("reloadui_warning_tooltip"),
		},		
		{		
			type = "submenu",
			name = AUI_TXT_COLOR_SUBMENU:Colorize(AUI.L10n.GetString("display_elements")),
			controls = 
			{					
				{
					type = "checkbox",
					name = AUI.L10n.GetString("activate_player_attributes"),
					getFunc = function() return g_player_attributes_enabled end,
					setFunc = function(value)
						if value ~= nil then
							g_player_attributes_enabled = value
							g_changedEnabled = true
						end
					end,
					default = defaultSettings.player_attributes_enabled,
					width = "full",
					warning = AUI.L10n.GetString("reloadui_manual_warning_tooltip"),
				},		
				{
					type = "checkbox",
					name = AUI.L10n.GetString("activate_target_attributes"),
					getFunc = function() return g_target_attributes_enabled end,
					setFunc = function(value)
						if value ~= nil then
							g_target_attributes_enabled = value
							g_changedEnabled = true
						end
					end,
					default = defaultSettings.target_attributes_enabled,
					width = "full",
					warning = AUI.L10n.GetString("reloadui_manual_warning_tooltip"),
				},
				{
					type = "checkbox",
					name = AUI.L10n.GetString("activate_group_attributes"),
					getFunc = function() return g_group_attributes_enabled end,
					setFunc = function(value)
						if value ~= nil then
							g_group_attributes_enabled = value
							g_changedEnabled = true
						end
					end,
					default = defaultSettings.group_attributes_enabled,
					width = "full",
					warning = AUI.L10n.GetString("reloadui_manual_warning_tooltip"),
				},	
				{
					type = "checkbox",
					name = AUI.L10n.GetString("activate_boss_attributes"),
					getFunc = function() return g_boss_attributes_enabled end,
					setFunc = function(value)
						if value ~= nil then
							g_boss_attributes_enabled = value
							g_changedEnabled = true
						end
					end,
					default = defaultSettings.boss_attributes_enabled,
					width = "full",
					warning = AUI.L10n.GetString("reloadui_manual_warning_tooltip"),
				},				
				{
					type = "button",
					name = AUI.L10n.GetString("accept_settings"),
					tooltip = AUI.L10n.GetString("accept_settings_tooltip"),
					func = function() AcceptSettings() end,
					disabled = function() return not g_changedEnabled end,
				},		
			}
		},			
	}
	
	local optionsCount = 0
	for i = 1, #options do 
		optionsCount = optionsCount + 1
	end				
	
	if optionsCount > 0 then	
		local optionsColorTable = 
		{			
			type = "submenu",
			name = AUI_TXT_COLOR_SUBMENU:Colorize(AUI.L10n.GetString("colors")),
			controls = {}
		}
	
		if g_player_attributes_enabled then
			local playerColorOptionTable = GetPlayerColorSettingsTable()
			for i = 1, #playerColorOptionTable do 
				table.insert(optionsColorTable.controls, playerColorOptionTable[i]) 
			end		
		end	
		
		if g_target_attributes_enabled and DoesAttributeIdExists(AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_HEALTH) then
			local submenuName = AUI.L10n.GetString("target")
			if DoesAttributeIdExists(AUI_ATTRIBUTE_TYPE_SECUNDARY_TARGET_HEALTH) then
				submenuName = submenuName .. " (" .. AUI.L10n.GetString("primary") .. ")"
			end	
		
			local targetColorOptionTable = GetTargetColorSettingsTable(AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_HEALTH, submenuName)
			for i = 1, #targetColorOptionTable do 
				table.insert(optionsColorTable.controls, targetColorOptionTable[i]) 
			end		
		end	
		
		if g_target_attributes_enabled and DoesAttributeIdExists(AUI_ATTRIBUTE_TYPE_SECUNDARY_TARGET_HEALTH) then
			local submenuName = AUI.L10n.GetString("target")
			if DoesAttributeIdExists(AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_HEALTH) then
				submenuName = submenuName .. " (" .. AUI.L10n.GetString("secundary") .. ")"
			end	
		
			local targetColorOptionTable = GetTargetColorSettingsTable(AUI_ATTRIBUTE_TYPE_SECUNDARY_TARGET_HEALTH, AUI.L10n.GetString("target") .. " " .. AUI.L10n.GetString("secundary") .. ")")
			for i = 1, #targetColorOptionTable do 
				table.insert(optionsColorTable.controls, targetColorOptionTable[i] ) 
			end	
		end	

		if g_group_attributes_enabled then
			local groupColorOptionTable = GetGroupColorSettingsTable()
			for i = 1, #groupColorOptionTable do 
				table.insert(optionsColorTable.controls, groupColorOptionTable[i]) 
			end		
		end	
		
		if g_group_attributes_enabled then
			local raidColorOptionTable = GetRaidColorSettingsTable()
			for i = 1, #raidColorOptionTable do 
				table.insert(optionsColorTable.controls, raidColorOptionTable[i]) 
			end		
		end

		if g_boss_attributes_enabled then
			local bossColorOptionTable = GetBossColorSettingsTable()
			for i = 1, #bossColorOptionTable do 
				table.insert(optionsColorTable.controls, bossColorOptionTable[i]) 
			end		
		end		
		
		table.insert(options, optionsColorTable) 	
	end

	if g_player_attributes_enabled then
		local playerOptionTable = GetPlayerSettingsTable()
		for i = 1, #playerOptionTable do 
			table.insert(options, playerOptionTable[i]) 
		end		
	end
	
	if g_target_attributes_enabled and DoesAttributeIdExists(AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_HEALTH) then
		local submenuName = AUI.L10n.GetString("target") .. " (" .. AUI.L10n.GetString("primary") .. ")"	
		local targetPrimarySubmenu = GetTargetSubmenuTable(submenuName)	
		local targetPrimaryOptions = GetTargetSettingTable(AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_HEALTH)
		local targetPrimaryShieldOptions = GetTargetShieldSettingTable(AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_SHIELD)

		for i = 1, #targetPrimaryOptions do		
			table.insert(targetPrimarySubmenu.controls, targetPrimaryOptions[i]) 
		end	
		
		for i = 1, #targetPrimaryShieldOptions do		
			table.insert(targetPrimarySubmenu.controls, targetPrimaryShieldOptions[i]) 
		end				

		table.insert(options, targetPrimarySubmenu) 
	end
	
	if g_target_attributes_enabled and DoesAttributeIdExists(AUI_ATTRIBUTE_TYPE_SECUNDARY_TARGET_HEALTH) then
		local submenuName = AUI.L10n.GetString("target") .. " (" .. AUI.L10n.GetString("secundary") .. ")"	
		local targetSecondarySubmenu = GetTargetSubmenuTable(submenuName)	
		local targetSecondaryOptions = GetTargetSettingTable(AUI_ATTRIBUTE_TYPE_SECUNDARY_TARGET_HEALTH)
		local targetSecondaryShieldOptions = GetTargetShieldSettingTable(AUI_ATTRIBUTE_TYPE_SECUNDARY_TARGET_SHIELD)

		for i = 1, #targetSecondaryOptions do		
			table.insert(targetSecondarySubmenu.controls, targetSecondaryOptions[i]) 
		end	
		
		for i = 1, #targetSecondaryShieldOptions do		
			table.insert(targetSecondarySubmenu.controls, targetSecondaryShieldOptions[i]) 
		end		

		table.insert(options, targetSecondarySubmenu) 
	end	
	
	if g_group_attributes_enabled then
		local groupSubmenu = GetGroupSubmenuTable(submenuName)		
		local groupOptions = GetGroupSettingsTable()
		local groupShieldOptions = GetGroupShieldSettingsTable()
	
		for i = 1, #groupOptions do		
			table.insert(groupSubmenu.controls, groupOptions[i]) 
		end		

		for i = 1, #groupShieldOptions do 
			table.insert(groupSubmenu.controls, groupShieldOptions[i]) 
		end		
	
		table.insert(options, groupSubmenu) 
	
		local raidSubmenu = GetRaidSubmenuTable(submenuName)		
		local raidOptions = GetRaidSettingsTable()
		local raidShieldOptions = GetRaidShieldSettingsTable()
	
		for i = 1, #raidOptions do		
			table.insert(raidSubmenu.controls, raidOptions[i]) 
		end		

		for i = 1, #raidShieldOptions do 
			table.insert(raidSubmenu.controls, raidShieldOptions[i]) 
		end		
	
		table.insert(options, raidSubmenu) 
	end
	
	if g_boss_attributes_enabled then
		local bossAUIOptions = GetBossAUISettingsTable()
		for i = 1, #bossAUIOptions do 
			table.insert(options, bossAUIOptions[i]) 
		end			
	
		local bossDefaultOptions = GetBossDefaultSettingsTable()
		for i = 1, #bossDefaultOptions do 
			table.insert(options, bossDefaultOptions[i]) 
		end		
	end
	
	local footerOptions = 
	{
		{
			type = "header",
		},		
		{
			type = "button",
			name = AUI.L10n.GetString("reset_to_default_position"),
			tooltip = AUI.L10n.GetString("reset_to_default_position_tooltip"),
			func = function() AUI.Attributes.SetToDefaultPosition() end,
		},		
	}	
	
	for i = 1, #footerOptions do 
		table.insert(options , footerOptions[i] ) 
	end		
	
	return options
end

function AUI.Attributes.GetDefaultSettings()
	return defaultSettings
end

function AUI.Attributes.LoadSettings()
	if g_isInit then
		return
	end

	local panelData = 
	{
		type = "panel",
		name = AUI_MAIN_NAME .. " (" .. AUI.L10n.GetString("attributes_module_name") .. ")",
		displayName = "|cFFFFB0" .. AUI_MAIN_NAME .. " (" .. AUI.L10n.GetString("attributes_module_name") .. ")",
		author = AUI_TXT_COLOR_AUTHOR:Colorize(AUI_ATTRIBUTE_AUTHOR),
		version = AUI_TXT_COLOR_VERSION:Colorize(AUI_ATTRIBUTE_VERSION),
		slashCommand = "/auiattributes",
		registerForRefresh = true,
		registerForDefaults = true,
	}
	
	if AUI.MainSettings.modul_attributes_account_wide then
		AUI.Settings.Attributes = ZO_SavedVars:NewAccountWide("AUI_Attributes", 10, nil, defaultSettings)
	else
		AUI.Settings.Attributes = ZO_SavedVars:New("AUI_Attributes", 10, nil, defaultSettings)
	end		
	
	g_player_attributes_enabled = AUI.Settings.Attributes.player_attributes_enabled
	g_target_attributes_enabled = AUI.Settings.Attributes.target_attributes_enabled
	g_group_attributes_enabled = AUI.Settings.Attributes.group_attributes_enabled	
	g_boss_attributes_enabled = AUI.Settings.Attributes.boss_attributes_enabled

	g_LAM:RegisterOptionControls("AUI_Menu_Attributes", CreateOptions())
	g_LAM:RegisterAddonPanel("AUI_Menu_Attributes", panelData)
	
	g_isInit = true
end
