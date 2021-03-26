local addonName = "AUI"
	
local function GetTemplateData()	
	local templateData = 
	{
		[AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH] = 
		{
			["name"] = "AUI_PlayerFrame_Health",		
			["virtual"] = true,	
			["default_settings"] = 
			{
				["bar_alignment"] = BAR_ALIGNMENT_CENTER,				
			},				
			["disabled_settings"] = 
			{
				["height"] = true,
				["bar_alignment"] = true,	
			}
		},
		[AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD] = 
		{
			["name"] = "AUI_PlayerFrame_Shield",
			["virtual"] = true,	
			["default_settings"] = 
			{
				["bar_alignment"] = BAR_ALIGNMENT_CENTER,
				["show_text"] = true,				
			},				
			["disabled_settings"] = 
			{
				["width"] = true,
				["height"] = true,
				["opacity"] = true,
				["bar_alignment"] = true,
			}		
		},		
		[AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA] = 
		{
			["name"] = "AUI_PlayerFrame_Magicka",	
			["virtual"] = true,	
			["default_settings"] = 
			{
				["bar_alignment"] = BAR_ALIGNMENT_REVERSE,				
			},				
			["disabled_settings"] = 
			{
				["height"] = true,
				["bar_alignment"] = true,
			}			
		},		
		[AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF] = 
		{
			["name"] = "AUI_PlayerFrame_Werewolf",	
			["virtual"] = true,	
			["default_settings"] = 
			{
				["bar_alignment"] = BAR_ALIGNMENT_REVERSE,				
			},				
			["disabled_settings"] = 
			{
				["height"] = true,
				["bar_alignment"] = true,
			}			
		},		
		[AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA] = 
		{
			["name"] = "AUI_PlayerFrame_Stamina",
			["virtual"] = true,	
			["disabled_settings"] = 
			{
				["height"] = true,
				["bar_alignment"] = true,
			}			
		},
		[AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT] = 
		{	
			["name"] = "AUI_PlayerFrame_StaminaMount",	
			["virtual"] = true,	
			["disabled_settings"] = 
			{
				["height"] = true,
				["bar_alignment"] = true,
			}			
		},	
		[AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE] = 
		{
			["name"] = "AUI_PlayerFrame_SiegeHealth",	
			["virtual"] = true,	
			["default_settings"] = 
			{
				["bar_alignment"] = BAR_ALIGNMENT_CENTER,				
			},			
			["disabled_settings"] = 
			{
				["height"] = true,
				["bar_alignment"] = true,
			}			
		},
		[AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_HEALTH] = 
		{
			["name"] = "AUI_TargetFrame_Health",	
			["virtual"] = true,
			["default_settings"] = 
			{
				["bar_alignment"] = BAR_ALIGNMENT_CENTER,				
			},			
			["disabled_settings"] = 
			{
				["display"] = true,
				["height"] = true,
				["bar_alignment"] = true,				
			}			
		},	
		[AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_SHIELD] = 
		{
			["name"] = "AUI_TargetFrame_Shield",	
			["virtual"] = true,	
			["default_settings"] = 
			{
				["bar_alignment"] = BAR_ALIGNMENT_CENTER,				
			},			
			["disabled_settings"] = 
			{
				["width"] = true,
				["height"] = true,
				["opacity"] = true,
				["show_text"] = true,
				["use_thousand_seperator"] = true,
				["font_art"] = true,
				["font_style"] = true,
				["font_size"] = true,
				["bar_alignment"] = true,
				["show_max_value"] = true,
			}	
		},		
		[AUI_ATTRIBUTE_TYPE_GROUP_HEALTH] = 
		{
			["name"] = "AUI_GroupFrame",	
			["virtual"] = true,				
		},	
		[AUI_ATTRIBUTE_TYPE_GROUP_SHIELD] = 
		{
			["name"] = "AUI_GroupFrame_Shield",		
			["virtual"] = true,
			["disabled_settings"] = 
			{
				["width"] = true,
				["height"] = true,
				["opacity"] = true,
				["show_text"] = true,
				["use_thousand_seperator"] = true,
				["font_art"] = true,
				["font_style"] = true,
				["font_size"] = true,
				["bar_alignment"] = true,
				["show_max_value"] = true,
			}			
		},				
		[AUI_ATTRIBUTE_TYPE_RAID_HEALTH] = 
		{
			["name"] = "AUI_RaidFrame",
			["virtual"] = true,					
		},
		[AUI_ATTRIBUTE_TYPE_RAID_SHIELD] = 
		{
			["name"] = "AUI_RaidFrame_Shield",
			["virtual"] = true,
			["disabled_settings"] = 
			{
				["width"] = true,
				["height"] = true,
				["opacity"] = true,
				["show_text"] = true,
				["use_thousand_seperator"] = true,
				["font_art"] = true,
				["font_style"] = true,
				["font_size"] = true,
				["bar_alignment"] = true,
				["show_max_value"] = true,
			}			
		},
		[AUI_ATTRIBUTE_TYPE_BOSS_HEALTH] = 
		{
			["name"] = "AUI_BossFrame",
			["virtual"] = true,			
		},
		[AUI_ATTRIBUTE_TYPE_BOSS_SHIELD] = 
		{
			["name"] = "AUI_BossFrame_Shield",
			["virtual"] = true,
			["disabled_settings"] = 
			{
				["width"] = true,
				["height"] = true,
				["opacity"] = true,
				["show_text"] = true,
				["use_thousand_seperator"] = true,
				["font_art"] = true,
				["font_style"] = true,
				["font_size"] = true,
				["bar_alignment"] = true,
				["show_max_value"] = true,
			}			
		}
	}
	
	return templateData
end

local function OnLoad(p_eventCode, p_addOnName)
	if p_addOnName ~= addonName then
        return
    end	
	
	if AUI then
		AUI.Attributes.AddTemplate("AUI", "AUI", 1, GetTemplateData())
	end	

	EVENT_MANAGER:UnregisterForEvent(addonName .. "_AUI_ATTRIBUTES_DEFAULT_DESIGN", EVENT_ADD_ON_LOADED)	
end

EVENT_MANAGER:RegisterForEvent(addonName .. "_AUI_ATTRIBUTES_DEFAULT_DESIGN", EVENT_ADD_ON_LOADED, OnLoad)
