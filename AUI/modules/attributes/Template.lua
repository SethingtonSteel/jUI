local g_themes = {}
local g_tempGroupFames = {}
local g_tempRaidFames = {}	
local g_tempBossFames = {}
local g_activeTheme = nil

local function SetAnchors()
	for type, data in pairs(g_activeTheme.attributeData) do
		local relativeTo = nil
		if data.control then
			if data.control.relativeTo then
				relativeTo = g_activeTheme.attributeData[data.control.relativeTo].control
			end					
			
			local anchorData = AUI.Settings.Attributes[g_activeTheme.internName][data.control.attributeId].anchor_data		
			if anchorData then
				data.control:ClearAnchors()
				if anchorData[0] then	
					data.control:SetAnchor(anchorData[0].point, relativeTo or GuiRoot, anchorData[0].relativePoint, anchorData[0].offsetX, anchorData[0].offsetY)
				end
					
				if anchorData[1] and anchorData[1].point ~= NONE then
					data.control:SetAnchor(anchorData[1].point, relativeTo or GuiRoot, anchorData[1].relativePoint, anchorData[1].offsetX, anchorData[1].offsetY)
				end		
			end	
		end
	end	
end

local function GetDefaultData(_type, _templateData)
	local data = {}
	
	if not _templateData["default_settings"] then
		 _templateData["default_settings"] = {}
	end		
	
	if _templateData.control then
		data.width = _templateData.control.defaultWidth
		data.height = _templateData.control.defaultHeight
	end

	if data.width == 0 then
		data.width = nil
	end	
	
	if data.height == 0 then
		data.height = nil
	end		
	
	if _type == AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#520000"), AUI.Color.ConvertHexToRGBA("#950000")})	
		data.increase_regen_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_reg_inc) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#ab7900"), AUI.Color.ConvertHexToRGBA("#694a00")})
		data.decrease_regen_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_dec_inc) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#742679"), AUI.Color.ConvertHexToRGBA("#431546")})
		data.width = data.width
		data.height = data.height
		data.opacity = _templateData["default_settings"].opacity or 1
		data.show_text = _templateData["default_settings"].show_text ~= false or true
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 14
		data.font_style = _templateData["default_settings"].font_style or "outline"	
		data.show_increase_regen_color = _templateData["default_settings"].show_increase_regen_color ~= false or true
		data.show_decrease_regen_color = _templateData["default_settings"].show_decrease_regen_color ~= false or true	
		data.show_increase_regen_effect = _templateData["default_settings"].show_increase_regen_effect ~= false or true	
		data.show_decrease_regen_effect = _templateData["default_settings"].show_decrease_regen_effect ~= false or true	
		data.show_increase_armor_effect = _templateData["default_settings"].show_increase_armor_effect ~= false or true	
		data.show_decrease_armor_effect = _templateData["default_settings"].show_decrease_armor_effect ~= false or true		
		data.show_increase_power_effect = _templateData["default_settings"].show_increase_power_effect ~= false or true	
		data.show_decrease_power_effect = _templateData["default_settings"].show_decrease_power_effect ~= false or true				
	elseif _type == AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#001f61"), AUI.Color.ConvertHexToRGBA("#003bbb")})
		data.width = data.width
		data.height = data.height
		data.opacity = _templateData["default_settings"].opacity or 1
		data.show_text = _templateData["default_settings"].show_text ~= false or true	
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 14
		data.font_style = _templateData["default_settings"].font_style or "outline"		
	elseif _type == AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#024600"), AUI.Color.ConvertHexToRGBA("#365f00")})	
		data.width = data.width
		data.height = data.height
		data.opacity = _templateData["default_settings"].opacity or 1
		data.show_text = _templateData["default_settings"].show_text ~= false or true
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true		
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 14
		data.font_style = _templateData["default_settings"].font_style or "outline"		
	elseif _type == AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#384800"), AUI.Color.ConvertHexToRGBA("#4d6300")})
		data.width = data.width
		data.height = data.height
		data.opacity = _templateData["default_settings"].opacity or 1
		data.show_text = _templateData["default_settings"].show_text == true or false		
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true		
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 12
		data.font_style = _templateData["default_settings"].font_style or "outline"			
	elseif _type == AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#653300"), AUI.Color.ConvertHexToRGBA("#84461a")})		
		data.width = data.width
		data.height = data.height
		data.opacity = _templateData["default_settings"].opacity or 1
		data.show_text = _templateData["default_settings"].show_text == true or false							
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true	
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 12
		data.font_style = _templateData["default_settings"].font_style or "outline"					
	elseif _type == AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#520000"), AUI.Color.ConvertHexToRGBA("#950000")})	
		data.width = data.width
		data.height = data.height
		data.opacity = _templateData["default_settings"].opacity or 1
		data.show_text = _templateData["default_settings"].show_text == true or false						
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true		
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 15
		data.font_style = _templateData["default_settings"].font_style or "outline"							
	elseif _type == AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#07174e"), AUI.Color.ConvertHexToRGBA("#034a6f")})	
		data.width = data.width
		data.height = data.height
		data.opacity = _templateData["default_settings"].opacity or 1
		data.show_text = _templateData["default_settings"].show_text == true or false			
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true				
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 10
		data.font_style = _templateData["default_settings"].font_style or "outline"					
	elseif _type == AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_HEALTH then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#520000"), AUI.Color.ConvertHexToRGBA("#950000")})		
		data.increase_regen_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_reg_inc) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#ab7900"), AUI.Color.ConvertHexToRGBA("#694a00")})
		data.decrease_regen_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_dec_inc) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#742679"), AUI.Color.ConvertHexToRGBA("#431546")})
		data.bar_friendly_color = AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#123c00"), AUI.Color.ConvertHexToRGBA("#237101")})
		data.bar_allied_npc_color = AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#123c00"), AUI.Color.ConvertHexToRGBA("#237101")})
		data.bar_allied_player_color = AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#002f3a"), AUI.Color.ConvertHexToRGBA("#004961")})
		data.bar_neutral_color = AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#533e02"), AUI.Color.ConvertHexToRGBA("#958403")})	
		data.bar_guard_color = AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#252221"), AUI.Color.ConvertHexToRGBA("#3b3736")})
		data.width = data.width
		data.height = data.height
		data.opacity = _templateData["default_settings"].opacity or 1
		data.show_text = _templateData["default_settings"].show_text ~= false or true			
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].show_percent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true			
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 15
		data.font_style = _templateData["default_settings"].font_style or "outline"
		data.show_account_name = _templateData["default_settings"].show_account_name or true
		data.caption_mode = _templateData["default_settings"].caption_mode or AUI_UNIT_FRAMES_MODE_CHARACTER_NAME_TITLE
		data.show_increase_regen_color = _templateData["default_settings"].show_increase_regen_color ~= false or true	
		data.show_decrease_regen_color = _templateData["default_settings"].show_decrease_regen_color ~= false or true				
		data.show_increase_regen_effect = _templateData["default_settings"].show_increase_regen_effect == true or true
		data.show_decrease_regen_effect = _templateData["default_settings"].show_decrease_regen_effect == true or true
		data.show_increase_armor_effect = _templateData["default_settings"].show_increase_armor_effect == true or false	
		data.show_decrease_armor_effect = _templateData["default_settings"].show_decrease_armor_effect == true or false		
		data.show_increase_power_effect = _templateData["default_settings"].show_increase_power_effect ~= false or true	
		data.show_decrease_power_effect = _templateData["default_settings"].show_decrease_power_effect ~= false or true			
	elseif _type == AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_SHIELD then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#07174e"), AUI.Color.ConvertHexToRGBA("#034a6f")})	
		data.width = data.width
		data.height = data.height
		data.opacity = _templateData["default_settings"].opacity or 1
		data.show_text = _templateData["default_settings"].show_text == true or false	
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true		
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 15
		data.font_style = _templateData["default_settings"].font_style or "outline"		
	elseif _type == AUI_ATTRIBUTE_TYPE_SECUNDARY_TARGET_HEALTH then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#520000"), AUI.Color.ConvertHexToRGBA("#950000")})		
		data.increase_regen_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_reg_inc) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#ab7900"), AUI.Color.ConvertHexToRGBA("#694a00")})
		data.decrease_regen_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_dec_inc) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#742679"), AUI.Color.ConvertHexToRGBA("#431546")})
		data.bar_friendly_color = AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#123c00"), AUI.Color.ConvertHexToRGBA("#237101")})
		data.bar_allied_npc_color = AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#123c00"), AUI.Color.ConvertHexToRGBA("#237101")})
		data.bar_allied_player_color = AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#002f3a"), AUI.Color.ConvertHexToRGBA("#004961")})
		data.bar_neutral_color = AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#533e02"), AUI.Color.ConvertHexToRGBA("#958403")})	
		data.bar_guard_color = AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#252221"), AUI.Color.ConvertHexToRGBA("#3b3736")})
		data.width = data.width
		data.height = data.height
		data.opacity = _templateData["default_settings"].opacity or 1
		data.show_text = _templateData["default_settings"].show_text ~= false or true				
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].show_percent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true		
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 15
		data.font_style = _templateData["default_settings"].font_style or "outline"
		data.show_account_name = _templateData["default_settings"].show_account_name or true
		data.caption_mode = _templateData["default_settings"].caption_mode or AUI_UNIT_FRAMES_MODE_CHARACTER_NAME_TITLE		
		data.show_increase_regen_color = _templateData["default_settings"].show_increase_regen_color ~= false or true	
		data.show_decrease_regen_color = _templateData["default_settings"].show_decrease_regen_color ~= false or true			
		data.show_increase_regen_effect = _templateData["default_settings"].show_increase_regen_effect ~= false or true	
		data.show_decrease_regen_effect = _templateData["default_settings"].show_decrease_regen_effect ~= false or true	
		data.show_increase_armor_effect = _templateData["default_settings"].show_increase_armor_effect == true or false	
		data.show_decrease_armor_effect = _templateData["default_settings"].show_decrease_armor_effect == true or false		
		data.show_increase_power_effect = _templateData["default_settings"].show_increase_power_effect ~= false or true	
		data.show_decrease_power_effect = _templateData["default_settings"].show_decrease_power_effect ~= false or true		
	elseif _type == AUI_ATTRIBUTE_TYPE_SECUNDARY_TARGET_SHIELD then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#07174e"), AUI.Color.ConvertHexToRGBA("#034a6f")})			
		data.width = data.width
		data.height = data.height
		data.opacity = _templateData["default_settings"].opacity or 1
		data.show_text = _templateData["default_settings"].show_text == true or false	
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true	
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 12
		data.font_style = _templateData["default_settings"].font_style or "outline"		
	elseif _type == AUI_ATTRIBUTE_TYPE_GROUP_HEALTH then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#520000"), AUI.Color.ConvertHexToRGBA("#950000")})	
		data.bar_color_tank = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_tank) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#0f4d00"), AUI.Color.ConvertHexToRGBA("#297500")})
		data.bar_color_healer = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_healer) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#c96700"), AUI.Color.ConvertHexToRGBA("#b7742c")})
		data.bar_color_dd = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_dd) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#520000"), AUI.Color.ConvertHexToRGBA("#950000")})			
		data.increase_regen_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_reg_inc) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#ab7900"), AUI.Color.ConvertHexToRGBA("#694a00")})
		data.decrease_regen_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_dec_inc) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#742679"), AUI.Color.ConvertHexToRGBA("#431546")})
		data.width = data.width
		data.height = data.height
		data.opacity = _templateData["default_settings"].opacity or 1
		data.out_of_range_opacity = 0.5		
		data.show_text = _templateData["default_settings"].show_text ~= false or true	
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 12
		data.font_style = _templateData["default_settings"].font_style or "outline"	
		data.show_account_name = _templateData["default_settings"].show_account_name or true
		data.row_distance = _templateData["default_settings"].row_distance or 42
		data.show_increase_regen_color = _templateData["default_settings"].show_increase_regen_color == true or false
		data.show_decrease_regen_color = _templateData["default_settings"].show_decrease_regen_color == true or false			
		data.show_increase_regen_effect = _templateData["default_settings"].show_increase_regen_effect ~= false or true	
		data.show_decrease_regen_effect = _templateData["default_settings"].show_decrease_regen_effect ~= false or true	
		data.show_increase_armor_effect = _templateData["default_settings"].show_increase_armor_effect == true or false	
		data.show_decrease_armor_effect = _templateData["default_settings"].show_decrease_armor_effect == true or false	
		data.show_increase_power_effect = _templateData["default_settings"].show_increase_power_effect == true or false	
		data.show_decrease_power_effect = _templateData["default_settings"].show_decrease_power_effect == true or false			
	elseif _type == AUI_ATTRIBUTE_TYPE_GROUP_SHIELD then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#07174e"), AUI.Color.ConvertHexToRGBA("#013753")})
		data.opacity = _templateData["default_settings"].opacity or 1
		data.out_of_range_opacity = _templateData["default_settings"].out_of_range_opacity or 0.5	
		data.show_text = _templateData["default_settings"].show_text == true or false
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true	
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 10
		data.font_style = _templateData["default_settings"].font_style or "outline"
	elseif _type == AUI_ATTRIBUTE_TYPE_RAID_HEALTH then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#520000"), AUI.Color.ConvertHexToRGBA("#950000")})
		data.bar_color_tank = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_tank) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#0f4d00"), AUI.Color.ConvertHexToRGBA("#297500")})
		data.bar_color_healer = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_healer) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#c96700"), AUI.Color.ConvertHexToRGBA("#b7742c")})
		data.bar_color_dd = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_dd) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#520000"), AUI.Color.ConvertHexToRGBA("#950000")})			
		data.increase_regen_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_reg_inc) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#ab7900"), AUI.Color.ConvertHexToRGBA("#694a00")})
		data.decrease_regen_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_dec_inc) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#742679"), AUI.Color.ConvertHexToRGBA("#431546")})
		data.width = data.width
		data.height = data.height
		data.opacity = _templateData["default_settings"].opacity or 1
		data.out_of_range_opacity = 0.5	
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true	
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 10
		data.font_style = _templateData["default_settings"].font_style or "outline"	
		data.show_account_name = _templateData["default_settings"].show_account_name or true
		data.row_distance = _templateData["default_settings"].row_distance or 12
		data.column_distance = _templateData["default_settings"].column_distance or 12		
		data.row_count = _templateData["default_settings"].row_count or 4
		data.show_increase_regen_color = _templateData["default_settings"].show_increase_regen_color == true or false
		data.show_decrease_regen_color = _templateData["default_settings"].show_decrease_regen_color == true or false			
		data.show_increase_regen_effect = _templateData["default_settings"].show_increase_regen_effect ~= false or true	
		data.show_decrease_regen_effect = _templateData["default_settings"].show_decrease_regen_effect ~= false or true	
		data.show_increase_armor_effect = _templateData["default_settings"].show_increase_armor_effect == true or false	
		data.show_decrease_armor_effect = _templateData["default_settings"].show_decrease_armor_effect == true or false	
		data.show_increase_power_effect = _templateData["default_settings"].show_increase_power_effect == true or false	
		data.show_decrease_power_effect = _templateData["default_settings"].show_decrease_power_effect == true or false					
	elseif _type == AUI_ATTRIBUTE_TYPE_RAID_SHIELD then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#07174e"), AUI.Color.ConvertHexToRGBA("#034a6f")})
		data.opacity = _templateData["default_settings"].opacity or 1
		data.out_of_range_opacity = 0.5	
		data.show_text = _templateData["default_settings"].show_text == true or false
		data.show_max_value = _templateData["default_settings"].show_max_value == true or false
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 10
		data.font_style = _templateData["default_settings"].font_style or "outline"
	elseif _type == AUI_ATTRIBUTE_TYPE_BOSS_HEALTH then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#520000"), AUI.Color.ConvertHexToRGBA("#950000")})
		data.increase_regen_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_reg_inc) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#ab7900"), AUI.Color.ConvertHexToRGBA("#694a00")})
		data.decrease_regen_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color_dec_inc) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#742679"), AUI.Color.ConvertHexToRGBA("#431546")})		
		data.width = data.width
		data.height = data.height
		data.opacity = _templateData["default_settings"].opacity or 1
		data.show_text = _templateData["default_settings"].show_text ~= false or true
		data.show_max_value = _templateData["default_settings"].show_max_value ~= false or true
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 10
		data.font_style = _templateData["default_settings"].font_style or "outline"	
		data.row_distance = _templateData["default_settings"].row_distance or 8
		data.column_distance = _templateData["default_settings"].column_distance or 12		
		data.row_count = _templateData["default_settings"].row_count or 6
		data.show_increase_regen_color = _templateData["default_settings"].show_increase_regen_color == true or false
		data.show_decrease_regen_color = _templateData["default_settings"].show_decrease_regen_color == true or false			
		data.show_increase_regen_effect = _templateData["default_settings"].show_increase_regen_effect ~= false or true	
		data.show_decrease_regen_effect = _templateData["default_settings"].show_decrease_regen_effect ~= false or true	
		data.show_increase_armor_effect = _templateData["default_settings"].show_increase_armor_effect == true or false	
		data.show_decrease_armor_effect = _templateData["default_settings"].show_decrease_armor_effect ~= false or true		
		data.show_increase_power_effect = _templateData["default_settings"].show_increase_power_effect ~= false or true	
		data.show_decrease_power_effect = _templateData["default_settings"].show_decrease_power_effect ~= false or true			
	elseif _type == AUI_ATTRIBUTE_TYPE_BOSS_SHIELD then
		data.bar_alignment = _templateData["default_settings"].bar_alignment or BAR_ALIGNMENT_NORMAL
		data.bar_color = AUI.Color.GetColorDef(_templateData["default_settings"].bar_color) or AUI.Color.GetColorDef({AUI.Color.ConvertHexToRGBA("#07174e"), AUI.Color.ConvertHexToRGBA("#034a6f")})
		data.opacity = _templateData["default_settings"].opacity or 1
		data.show_text = _templateData["default_settings"].show_text == true or false
		data.show_max_value = _templateData["default_settings"].show_max_value ~= false or true
		data.showPercent = _templateData["default_settings"].showPercent ~= false or true
		data.use_thousand_seperator = _templateData["default_settings"].use_decimal ~= false or true
		data.font_art = _templateData["default_settings"].font_art or "AUI/fonts/SansitaOne.ttf"
		data.font_size = _templateData["default_settings"].font_size or 10
		data.font_style = _templateData["default_settings"].font_style or "outline"		
	end

	data.display = true
	
	return data
end

local function SetControlData(_control)
	if _control then
		local controlName = _control:GetName()
	
		AUI.Attributes.ResetControlData(_control)
	
		_control.bar = GetControl(_control, "_Bar")	
		_control.bar2 =  GetControl(_control, "_Bar2")	

		_control.textValueControl = GetControl(_control, "_Text_Value")
		_control.textMaxValueControl = GetControl(_control, "_Text_MaxValue")
		_control.textPercentControl = GetControl(_control, "_Text_Percent")
		_control.leaderIconControl = GetControl(_control, "_LeaderIcon")	
		_control.levelControl = GetControl(_control, "_Text_Level")	
		_control.championIconControl = GetControl(_control, "_ChampionIcon")	
		_control.classIconControl = GetControl(_control, "_ClassIcon")	
		_control.rankIconControl = GetControl(_control, "_RankIcon")	
		_control.titleControl = GetControl(_control, "_Title")	
		_control.unitNameControl = GetControl(_control, "_Text_Name")
		_control.offlineInfoControl = GetControl(_control, "_Text_Offline")
		_control.deadInfoControl = GetControl(_control, "_Text_DeadInfo")
		_control.warnerControl = GetControl(_control, "Warner")	
		
		_control.increasedArmorOverlayControl = GetControl(_control, "IncreasedArmorOverlay")
		_control.decreasedArmorOverlayControl = GetControl(_control, "DecreasedArmorOverlay")
		_control.increasedPowerOverlayControl = GetControl(_control, "IncreasedPowerOverlay")
		_control.decreasedPowerOverlayControl = GetControl(_control, "DecreasedPowerOverlay")

		if _control.warnerControl then
			_control.leftWarnerControl = GetControl(_control.warnerControl, "FrameLeftWarner")	
			_control.rightWarnerControl = GetControl(_control.warnerControl, "FrameRightWarner")	
			_control.centerWarnerControl = GetControl(_control.warnerControl, "FrameCenterWarner")
		end

		if _control.increasedArmorOverlayControl then
			_control.increasedArmorOverlayControl:SetHidden(true)
		end

		if _control.decreasedArmorOverlayControl then
			_control.decreasedArmorOverlayControl:SetHidden(true)		
		end
		
		if _control.increasedPowerOverlayControl and _control.increasedPowerOverlayControl.animation then
			_control.increasedPowerOverlayControl:SetHidden(true)		
		end
		
		if _control.decreasedPowerOverlayControl then
			_control.decreasedPowerOverlayControl:SetColor(AUI.Color.ConvertHexToRGBA("#000000", 1):UnpackRGBA())
			_control.decreasedPowerOverlayControl:SetHidden(true)
		end
	
		if _control.bar then
			_control.bar.barGloss = GetControl(_control.bar, "Gloss")
			_control.bar.increaseRegControl = GetControl(_control.bar, "_IncreaseRegLeft")		
			_control.bar.decreaseRegControl = GetControl(_control.bar, "_DecreaseRegLeft")	

			_control.bar.defaultAnchor = 
			{
				[0] = {},
				[1] = {}
			}
	
			_, _control.bar.defaultAnchor[0].point, _, _control.bar.defaultAnchor[0].relativePoint, _control.bar.defaultAnchor[0].offsetX, _control.bar.defaultAnchor[0].offsetY = _control.bar:GetAnchor(0)		
			_, _control.bar.defaultAnchor[1].point, _, _control.bar.defaultAnchor[1].relativePoint, _control.bar.defaultAnchor[1].offsetX, _control.bar.defaultAnchor[1].offsetY = _control.bar:GetAnchor(1)

			if _control.bar.increaseRegControl then
				_control.bar.increaseRegControl.defaultAnchor = {}	
				_, _control.bar.increaseRegControl.defaultAnchor.point, _, _control.bar.increaseRegControl.defaultAnchor.relativePoint, _control.bar.increaseRegControl.defaultAnchor.offsetX, _control.bar.increaseRegControl.defaultAnchor.offsetY = _control.bar.increaseRegControl:GetAnchor(0)		

				if not _control.bar.increaseRegControl.animation then
					_control.bar.increaseRegControl.animation = ANIMATION_MANAGER:CreateTimelineFromVirtual("AUI_Attribute_ArrowAnimation", _control.bar.increaseRegControl)				
				end	
			end
			
			if _control.bar.decreaseRegControl then
				_control.bar.decreaseRegControl.defaultAnchor = {}	
				_, _control.bar.decreaseRegControl.defaultAnchor.point, _, _control.bar.decreaseRegControl.defaultAnchor.relativePoint, _control.bar.decreaseRegControl.defaultAnchor.offsetX, _control.bar.decreaseRegControl.defaultAnchor.offsetY = _control.bar.decreaseRegControl:GetAnchor(0)				

				if not _control.bar.decreaseRegControl.animation then
					_control.bar.decreaseRegControl.animation = ANIMATION_MANAGER:CreateTimelineFromVirtual("AUI_Attribute_ArrowAnimation", _control.bar.decreaseRegControl)					
				end	
			end
		end

		if _control.bar2 then
			_control.bar2.barGloss = GetControl(_control.bar2, "Gloss")					
			_control.bar2.increaseRegControl = GetControl(_control.bar2, "_IncreaseRegRight")	
			_control.bar2.decreaseRegControl = GetControl(_control.bar2, "_DecreaseRegRight")

			_control.bar2.defaultAnchor = 
			{
				[0] = {},
				[1] = {}
			}
	
			_, _control.bar2.defaultAnchor[0].point, _, _control.bar2.defaultAnchor[0].relativePoint, _control.bar2.defaultAnchor[0].offsetX, _control.bar2.defaultAnchor[0].offsetY = _control.bar2:GetAnchor(0)		
			_, _control.bar2.defaultAnchor[1].point, _, _control.bar2.defaultAnchor[1].relativePoint, _control.bar2.defaultAnchor[1].offsetX, _control.bar2.defaultAnchor[1].offsetY = _control.bar2:GetAnchor(1)	

			if _control.bar2.increaseRegControl then
				_control.bar2.increaseRegControl.defaultAnchor = {}	
				_, _control.bar2.increaseRegControl.defaultAnchor.point, _, _control.bar2.increaseRegControl.defaultAnchor.relativePoint, _control.bar2.increaseRegControl.defaultAnchor.offsetX, _control.bar2.increaseRegControl.defaultAnchor.offsetY = _control.bar2.increaseRegControl:GetAnchor(0)		

				if not _control.bar2.increaseRegControl.animation then
					_control.bar2.increaseRegControl.animation = ANIMATION_MANAGER:CreateTimelineFromVirtual("AUI_Attribute_ArrowAnimation", _control.bar2.increaseRegControl)				
				end	
			end
			
			if _control.bar2.decreaseRegControl then
				_control.bar2.decreaseRegControl.defaultAnchor = {}	
				_, _control.bar2.decreaseRegControl.defaultAnchor.point, _, _control.bar2.decreaseRegControl.defaultAnchor.relativePoint, _control.bar2.decreaseRegControl.defaultAnchor.offsetX, _control.bar2.decreaseRegControl.defaultAnchor.offsetY = _control.bar2.decreaseRegControl:GetAnchor(0)			

				if not _control.bar2.decreaseRegControl.animation then
					_control.bar2.decreaseRegControl.animation = ANIMATION_MANAGER:CreateTimelineFromVirtual("AUI_Attribute_ArrowAnimation", _control.bar2.decreaseRegControl)				
				end	
			end
		end		
	end
end

local function LoadData(templateData, type)
	local data = templateData.attributeData[type]

	if not data then
		return
	end
	
	local unitTag = nil
	local powerType = nil
	local unitAttributeVisual = nil
	local statType = nil
	local attributeType = nil
	local attributeId = nil		
	
	if type == AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH then
		unitTag = AUI_PLAYER_UNIT_TAG
		powerType = POWERTYPE_HEALTH
		attributeType = ATTRIBUTE_HEALTH		
	elseif type == AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA then	
		unitTag = AUI_PLAYER_UNIT_TAG
		powerType = POWERTYPE_MAGICKA
		attributeType = ATTRIBUTE_MAGICKA			
	elseif type == AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA then
		unitTag = AUI_PLAYER_UNIT_TAG
		powerType = POWERTYPE_STAMINA
		attributeType = ATTRIBUTE_STAMINA	
	elseif type == AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT then
		unitTag = AUI_PLAYER_UNIT_TAG
		powerType = POWERTYPE_MOUNT_STAMINA
	elseif type == AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF then
		unitTag = AUI_PLAYER_UNIT_TAG
		powerType = POWERTYPE_WEREWOLF	
	elseif type == AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE then
		unitTag = AUI_CONTROLED_SIEGE_UNIT_TAG
		powerType = POWERTYPE_HEALTH	
	elseif type == AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD then
		unitTag = AUI_PLAYER_UNIT_TAG
		powerType = POWERTYPE_HEALTH
		unitAttributeVisual = ATTRIBUTE_VISUAL_POWER_SHIELDING
		statType = STAT_MITIGATION
		attributeType = ATTRIBUTE_HEALTH			
	elseif type == AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_HEALTH then
		unitTag = AUI_TARGET_UNIT_TAG
		powerType = POWERTYPE_HEALTH	
	elseif type == AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_SHIELD then
		unitTag = AUI_TARGET_UNIT_TAG
		powerType = POWERTYPE_HEALTH
		unitAttributeVisual = ATTRIBUTE_VISUAL_POWER_SHIELDING
		statType = STAT_MITIGATION
		attributeType = ATTRIBUTE_HEALTH		
	elseif type == AUI_ATTRIBUTE_TYPE_SECUNDARY_TARGET_HEALTH then
		unitTag = AUI_TARGET_UNIT_TAG
		powerType = POWERTYPE_HEALTH	
	elseif type == AUI_ATTRIBUTE_TYPE_SECUNDARY_TARGET_SHIELD then
		unitTag = AUI_TARGET_UNIT_TAG
		powerType = POWERTYPE_HEALTH	
		unitAttributeVisual = ATTRIBUTE_VISUAL_POWER_SHIELDING
		statType = STAT_MITIGATION
		attributeType = ATTRIBUTE_HEALTH			
	elseif type == AUI_ATTRIBUTE_TYPE_GROUP_HEALTH then
		unitTag = AUI_GROUP_UNIT_TAG
		powerType = POWERTYPE_HEALTH				
	elseif type == AUI_ATTRIBUTE_TYPE_RAID_HEALTH then
		unitTag = AUI_GROUP_UNIT_TAG
		powerType = POWERTYPE_HEALTH		
	elseif type == AUI_ATTRIBUTE_TYPE_BOSS_HEALTH then
		unitTag = AUI_BOSS_UNIT_TAG
		powerType = POWERTYPE_HEALTH				
	end			
	
	templateData.settings[type] = {}
	local controlName = data.name		
	local isVirtual = data.virtual
	if controlName then			
		if type == AUI_ATTRIBUTE_TYPE_GROUP_HEALTH then	
			data.control = AUI_Attributes_Window_Group
			data.control.frames = {}
					
			for i = 1, 4, 1 do
				local unitTag = "group" .. i
				local frame = CreateControlFromVirtual(controlName, data.control, controlName, i)	

				frame.unitTag = unitTag
				frame.powerType = powerType
				frame.attributeId = type
				frame.unitAttributeVisual = unitAttributeVisual
				frame.statType = statType
				frame.attributeType = attributeType							
				frame:SetHidden(true)
				frame:SetAlpha(1)		
				frame.enabled = false
				frame.display = true
				frame.isGroup = true

				data.control.frames[unitTag] = frame
				g_tempGroupFames[unitTag] = frame	

				SetControlData(frame)		
			end						
		elseif type == AUI_ATTRIBUTE_TYPE_RAID_HEALTH then
			data.control = AUI_Attributes_Window_Raid
			data.control.frames = {}
					
			for i = 1, 24, 1 do
				local unitTag = "group" .. i
				local frame = CreateControlFromVirtual(controlName, data.control, controlName, unitTag)	
				frame.unitTag = unitTag
				frame.powerType = powerType
				frame.attributeId = type
				frame.unitAttributeVisual = unitAttributeVisual
				frame.statType = statType
				frame.attributeType = attributeType					
				frame:SetHidden(true)
				frame:SetAlpha(1)						
				frame.enabled = false
				frame.display = true				

				data.control.frames[unitTag] = frame	
				g_tempRaidFames[unitTag] = frame

				SetControlData(frame)						
			end	
		elseif type == AUI_ATTRIBUTE_TYPE_GROUP_SHIELD then
			data.control = AUI_Attributes_Window_Group_Shield				
			data.control.frames = {}
					
			for i = 1, 4, 1 do
				local unitTag = "group" .. i
				local frame = CreateControlFromVirtual(controlName, g_tempGroupFames[unitTag], controlName, i)	

				frame.unitTag = unitTag
				frame.powerType = POWERTYPE_HEALTH
				frame.unitAttributeVisual = ATTRIBUTE_VISUAL_POWER_SHIELDING
				frame.statType = STAT_MITIGATION
				frame.attributeType = ATTRIBUTE_HEALTH
				frame.attributeId = type
				frame.unitAttributeVisual = unitAttributeVisual
				frame.statType = statType
				frame.attributeType = attributeType							
				frame:SetHidden(true)
				frame:SetAlpha(1)
				frame.enabled = false
				frame.display = true

				if frame.owns then
					frame.mainControl = g_tempGroupFames[unitTag]
					frame.mainControl.subControl = frame
				else
					frame:SetParent(g_tempGroupFames[unitTag])
				end

				data.control.frames[unitTag] = frame

				SetControlData(frame)	
			end					
		elseif type == AUI_ATTRIBUTE_TYPE_RAID_SHIELD then
			data.control = AUI_Attributes_Window_Raid_Shield
			data.control.frames = {}
							
			for i = 1, 24, 1 do
				local unitTag = "group" .. i
				local frame = CreateControlFromVirtual(controlName, g_tempRaidFames[unitTag], controlName, i)	
				frame.unitTag = unitTag
				frame.powerType = POWERTYPE_HEALTH
				frame.unitAttributeVisual = ATTRIBUTE_VISUAL_POWER_SHIELDING
				frame.statType = STAT_MITIGATION
				frame.attributeType = ATTRIBUTE_HEALTH					
				frame.attributeId = type
				frame.unitAttributeVisual = unitAttributeVisual
				frame.statType = statType
				frame.attributeType = attributeType							
				frame:SetHidden(true)
				frame:SetAlpha(1)	
				frame.enabled = false
				frame.display = true

				if frame.owns then
					frame.mainControl = g_tempRaidFames[unitTag]
					frame.mainControl.subControl = frame
					frame:SetParent(frame.mainControl)
				else
					frame:SetParent(g_tempRaidFames[unitTag])
				end	

				data.control.frames[unitTag] = frame
				
				SetControlData(frame)	
			end		
		elseif type == AUI_ATTRIBUTE_TYPE_BOSS_HEALTH then
			data.control = AUI_Attributes_Window_Boss
			data.control.frames = {}
					
			for i = 1, MAX_BOSSES, 1 do
				local unitTag = "boss" .. i
				local frame = CreateControlFromVirtual(controlName, data.control, controlName, i)	

				frame.unitTag = unitTag
				frame.powerType = powerType
				frame.attributeId = type
				frame.unitAttributeVisual = unitAttributeVisual
				frame.statType = statType
				frame.attributeType = attributeType							
				frame:SetHidden(true)
				frame:SetAlpha(1)		
				frame.enabled = false
				frame.display = true

				data.control.frames[unitTag] = frame
				g_tempBossFames[unitTag] = frame	

				SetControlData(frame)						
			end	
		elseif type == AUI_ATTRIBUTE_TYPE_BOSS_SHIELD then
			data.control = AUI_Attributes_Window_Boss_Shield
			data.control.frames = {}
					
			for i = 1, MAX_BOSSES, 1 do
				local unitTag = "boss" .. i
				local frame = CreateControlFromVirtual(controlName, g_tempBossFames[unitTag], controlName, i)	
				frame.unitTag = unitTag
				frame.powerType = POWERTYPE_HEALTH
				frame.unitAttributeVisual = ATTRIBUTE_VISUAL_POWER_SHIELDING
				frame.statType = STAT_MITIGATION
				frame.attributeType = ATTRIBUTE_HEALTH					
				frame.attributeId = type
				frame.unitAttributeVisual = unitAttributeVisual
				frame.statType = statType
				frame.attributeType = attributeType							
				frame:SetHidden(true)
				frame:SetAlpha(1)	
				frame.enabled = false
				frame.display = true

				if frame.owns then
					frame.mainControl = g_tempBossFames[unitTag]
					frame.mainControl.subControl = frame
					frame:SetParent(frame.mainControl)
				else
					frame:SetParent(g_tempBossFames[unitTag])
				end						

				data.control.frames[unitTag] = frame
				
				SetControlData(frame)				
			end					
		else
			if isVirtual then
				data.control = CreateControlFromVirtual(controlName, AUI_Attributes_Window, controlName)	
			else
				data.control = GetControl(controlName)
			end
		end
	
		if data.control then		
			data.control.unitTag = unitTag
			data.control.powerType = powerType	
			data.control.unitAttributeVisual = unitAttributeVisual
			data.control.statType = statType
			data.control.attributeType = attributeType
			data.control.attributeId = type						
			data.control.enabled = false	
		
			if data.control.frames then
				for _, frame in pairs(data.control.frames) do
					data.control.defaultWidth = frame:GetWidth()
					data.control.defaultHeight = frame:GetHeight()				
					break
				end			
			else
				data.control.defaultWidth = data.control:GetWidth()
				data.control.defaultHeight = data.control:GetHeight()	
			end
			
			data.anchor_data = 
			{
					[0] = {},
					[1] = {}			
			}
		
			_, data.anchor_data[0].point, _, data.anchor_data[0].relativePoint, data.anchor_data[0].offsetX, data.anchor_data[0].offsetY = data.control:GetAnchor(0)		
			_, data.anchor_data[1].point, _, data.anchor_data[1].relativePoint, data.anchor_data[1].offsetX, data.anchor_data[1].offsetY = data.control:GetAnchor(1)	


			templateData.settings[type] = GetDefaultData(type, data)
			templateData.settings[type].anchor_data = data.anchor_data					

			SetControlData(data.control)
		end		
	end		
	
	data.attributeId = type
end

function AUI.Attributes.AddTemplate(_name, _internName, _version, _data, _isCompact)
	if not _name or not _internName or not _version or not _data then
		return
	end

	local data = {}
	data.version = _version
	data.name = _name
	data.internName = _internName
	data.isCompact = _isCompact
	data.attributeData = _data
	if not g_themes[_internName] then
		g_themes[_internName] = data
	end
end

function AUI.Attributes.LoadTemplate(_name)
	local templateData = g_themes[_name]
	
	if not templateData then
		_name = "AUI"
		templateData = g_themes[_name]
	end
				
	templateData.settings = {}
	templateData.settings.version = templateData.version		
	templateData.settings.show_player_always = templateData.isCompact or false	

	LoadData(templateData, AUI_ATTRIBUTE_TYPE_PLAYER_HEALTH)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_PLAYER_SHIELD)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_PLAYER_MAGICKA)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_PLAYER_STAMINA)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_PLAYER_MOUNT)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_PLAYER_WEREWOLF)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_PLAYER_SIEGE)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_HEALTH)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_PRIMARY_TARGET_SHIELD)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_SECUNDARY_TARGET_HEALTH)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_SECUNDARY_TARGET_SHIELD)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_GROUP_HEALTH)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_GROUP_SHIELD)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_RAID_HEALTH)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_RAID_SHIELD)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_BOSS_HEALTH)
	LoadData(templateData, AUI_ATTRIBUTE_TYPE_BOSS_SHIELD)
	
	for type, data in pairs(templateData.attributeData) do	
		local controlName = data.name		
		if controlName then
			if data.control  then
				if data.control.mainBar and templateData.attributeData[data.control.mainBar] then
					data.control.mainControl = templateData.attributeData[data.control.mainBar].control
					data.control.mainControl.subControl = data.control
				end		
				
				if data.control.dependent and templateData.attributeData[data.control.dependent] then
					data.control.dependentControl = templateData.attributeData[data.control.dependent].control
				end	
			end
		end		
	end	
	
	g_activeTheme = templateData
	
	local defaultSettings = AUI.Attributes.GetDefaultSettings()	
	defaultSettings[_name] = templateData.settings
	
	AUI.Attributes.LoadSettings()	

	if AUI.Settings.Attributes[_name].version ~= defaultSettings[_name].version then		
		AUI.Settings.Attributes[_name] = defaultSettings[_name]
	end	
	
	for type, data in pairs(templateData.attributeData) do	
		if data.control then
			if  data.control.frames then
				if AUI.Attributes.IsGroup(type) then
					for _, frame in pairs(data.control.frames) do	
						if AUI.Attributes.IsGroup(frame.attributeId) and AUI.Attributes.Group.IsEnabled() then 
							frame.enabled = true
						end
					end
				elseif AUI.Attributes.IsBoss(type) then
					for _, frame in pairs(data.control.frames) do										
						if AUI.Attributes.IsBoss(frame.attributeId) and AUI.Attributes.Bossbar.IsEnabled() then					
							frame.enabled = true
						end
					end				
				end
			end		
		
			if AUI.Attributes.IsPlayer(type) and AUI.Attributes.Player.IsEnabled() then 
				data.control.enabled = true
			elseif AUI.Attributes.IsTarget(type) and AUI.Attributes.Target.IsEnabled() then 
				data.control.enabled = true
			elseif AUI.Attributes.IsGroup(type) and AUI.Attributes.Group.IsEnabled() then 						
				data.control.enabled = true
			elseif AUI.Attributes.IsBoss(type) and AUI.Attributes.Bossbar.IsEnabled() then
				data.control.enabled = true
			end							
		end		
	end		
	
	SetAnchors()

	g_tempGroupFames = nil
	g_tempRaidFames = nil	
	g_tempBossFames = nil	
	
	templateData.g_isInit = true
	
	return templateData
end

function AUI.Attributes.SetToDefaultPosition()
	local templateName = g_activeTheme.internName
	local defaultSettings = AUI.Attributes.GetDefaultSettings()
	
	for type, data in pairs(g_activeTheme.attributeData) do
		local anchorData = AUI.Settings.Attributes[g_activeTheme.internName][data.control.attributeId].anchor_data		
		local defaultAnchorData = defaultSettings[templateName][type]["anchor_data"]
		if anchorData and defaultAnchorData then	
			anchorData[0] = AUI.Table.Copy(defaultAnchorData[0])
			anchorData[1] = AUI.Table.Copy(defaultAnchorData[1])
		end
	end	
	
	SetAnchors()
end

function AUI.Attributes.GetThemeNames()
	local names = {}

	for _internName, data in pairs(g_themes) do	
		table.insert(names, {[_internName] = data.name})
	end

	return names
end

function AUI.Attributes.GetActiveThemeData()
	return g_activeTheme	
end