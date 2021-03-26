local MINIMETER_SCENE_FRAGMENT = nil
local ICON_SIZE = 32

local mIsLoaded = false
local mMiniMeterControl = nil
local mIsMouseDown = false

local MINIMETER_MOUSE_OVER_COLOR = "#ff6464"
local MINIMETER_DEFAULT_BG_TEXTURE = "/EsoUi/art/chatwindow/chat_bg_edge.dds"

local function SaveCurrentRecord()
	local error, _  = AUI.Combat.CheckError()

	if error then
		d("AUI-CS: v." .. AUI_COMBAT_VERSION .. " " .. AUI.L10n.GetString("save_record_has_no_data"))
		return
	end

	local currentCombatData = AUI.Combat.GetLastData()
	if currentCombatData and currentCombatData.dateString and not currentCombatData.isSaved then
		AUI.Settings.Combat.Fights.records[currentCombatData.dateString] = currentCombatData
		currentCombatData.isSaved = true
		d("AUI-CS: v." .. AUI_COMBAT_VERSION .. " " .. AUI.L10n.GetString("save_record_successful"))
	end
end

function AUI.ResetMiniMeter()
	if not mIsLoaded then
		return
	end

	AUI_Minimeter_Label_DPS_Out:SetText("-")
	AUI_Minimeter_Label_Total_Damage_Out:SetText("-")	
	
	AUI_Minimeter_Label_HPS_Out:SetText("-")
	AUI_Minimeter_Label_Total_Heal_Out:SetText("-")	
	
	AUI_Minimeter_Label_DPS_In:SetText("-")
	AUI_Minimeter_Label_Total_Damage_In:SetText("-")	
	
	AUI_Minimeter_Label_HPS_In:SetText("-")
	AUI_Minimeter_Label_Total_Heal_In:SetText("-")		
	
	AUI_Minimeter_Label_Time:SetText("-")
end

local function OnMouseEnter()
	if not AUI.Settings.Combat.minimeter_show_background then
		AUI_Minimeter_BG:SetHidden(false)
	end

	AUI_Minimeter_BG:SetCenterColor(AUI.Color.ConvertHexToRGBA(MINIMETER_MOUSE_OVER_COLOR, 0.2):UnpackRGBA())
end

local function OnMouseExit()
	if not AUI.Settings.Combat.minimeter_show_background then
		AUI_Minimeter_BG:SetHidden(true)
	end

	if mIsMouseDown == false then
		AUI_Minimeter_BG:SetCenterColor(1, 1, 1, 0) 
	end
end

local function OnMouseDown(_eventCode, _button, _ctrl, _alt, _shift)
	mIsMouseDown = true;

	if _button == 1 and not AUI.Settings.Combat.lock_windows then
		AUI_Minimeter:SetMovable(true)
		AUI_Minimeter:StartMoving()
	end
end

local function OnMouseUp(_eventCode, _button, _ctrl, _alt, _shift)
	mIsMouseDown = false;

	AUI_Minimeter:SetMovable(false)
	
	if _button == 1 then
		AUI.HideMouseMenu()

		local anchor = {AUI_Minimeter:GetAnchor()}

		if AUI.Settings.Combat.minimeter_position.offsetX == anchor[5] then
			OnMouseExit()
			AUI.Combat.Statistics.Show()
		end

		if not AUI.Settings.Combat.lock_windows then
			_, AUI.Settings.Combat.minimeter_position.point, _, AUI.Settings.Combat.minimeter_position.relativePoint, AUI.Settings.Combat.minimeter_position.offsetX, AUI.Settings.Combat.minimeter_position.offsetY = AUI_Minimeter:GetAnchor()
		end
	elseif _button == 2 then
		if not IsUnitInCombat(AUI_PLAYER_UNIT_TAG) then
			AUI.ShowMouseMenu()	
			AUI.AddMouseMenuButton("AUI_MINIMETER_POST_ALL", AUI.L10n.GetString("post_all"), function() AUI.Combat.PostPlayerCombatStatistics() end)			
			AUI.AddMouseMenuButton("AUI_MINIMETER_POST_HIGHEST_TARGET", AUI.L10n.GetString("post_highest_target"), function() AUI.Combat.PostHighestTargetCombatStatistics() end)
			AUI.AddMouseMenuButton("AUI_MINIMETER_RESET", AUI.L10n.GetString("reset"), AUI.ResetMiniMeter)
			AUI.AddMouseMenuButton("AUI_MINIMETER_SAVE", AUI.L10n.GetString("save_record"), SaveCurrentRecord)
		end
	end
end

local function UpdateLabels(_labelControl1, _labelControl2, _damageType)
	local playerData = AUI.Combat.GetPlayerData()
	local petData = AUI.Combat.GetPlayerPetData()	
	local playerTotal = 0
	local petTotal = 0
	local total = 0
	local avarage = 0			
	local anonymousTotal = 0	
	local playerEndTimeMS =  0
	local petEndTimeMS = 0	
	local playerHitCount = 0
	local petHitCount = 0

	if playerData and playerData[_damageType] and playerData[_damageType].total then	
		playerTotal = playerData[_damageType].total
		playerEndTimeMS = playerData[_damageType].endTimeMS			
		playerHitCount = playerData[_damageType].hitCount			
	end
	
	if petData and petData[_damageType] and petData[_damageType].total then
		petTotal = petData[_damageType].total
		petEndTimeMS = petData[_damageType].endTimeMS 
		petHitCount = petData[_damageType].hitCount	
	end	

	total = playerTotal + petTotal

	if total == 0 then
		return		
	end

	if playerEndTimeMS >= petEndTimeMS then			
		avarage = AUI.Combat.CalculateDPS(total, playerEndTimeMS)		
	else
		avarage = AUI.Combat.CalculateDPS(total, petEndTimeMS)		
	end

	if avarage == 0 then
		avarage = total
	end

	if _damageType == AUI_COMBAT_DATA_TYPE_DAMAGE_OUT and AUI.Settings.Combat.minimeter_show_group_damage_out or _damageType == AUI_COMBAT_DATA_TYPE_HEAL_OUT and AUI.Settings.Combat.minimeter_show_group_heal_out then
		local anonymousData = AUI.Combat.GetAnonymousData()
		if anonymousData and anonymousData[_damageType] then
			anonymousTotal = anonymousData[_damageType].total				
		end
		
		if anonymousTotal and anonymousTotal > 0 then
			_labelControl2:SetText(AUI.String.ToFormatedNumber(avarage) .. " (" .. AUI.String.GetPercentString(anonymousTotal + total, total) .. ")")
		else
			_labelControl2:SetText(AUI.String.ToFormatedNumber(avarage) .. " (100%)")
		end
	else
		_labelControl2:SetText(AUI.String.ToFormatedNumber(avarage))
	end	

	_labelControl1:SetText(AUI.String.ToFormatedNumber(total))
end

local function UpdateCombatTime()
	local combatTime = AUI.Combat.GetCombatTime()

	if combatTime > 0 then
		local _timeString = 0

		if combatTime >= 1 then
			_timeString = AUI.Time.GetFormatedString(combatTime, 1)
		elseif combatTime >= 0.1 then
			_timeString = AUI.Time.GetFormatedString(combatTime, 2)	
		else
			_timeString = AUI.Time.GetFormatedString(combatTime, 3)
		end
		
		AUI_Minimeter_Label_Time:SetText(_timeString)
	end
end

function AUI.Combat.Minimeter.Update()
	if not mIsLoaded then
		return
	end

	if AUI.Settings.Combat.minimeter_show_total_damage_out then
		UpdateLabels(AUI_Minimeter_Label_Total_Damage_Out, AUI_Minimeter_Label_DPS_Out, AUI_COMBAT_DATA_TYPE_DAMAGE_OUT)
	end
	
	if AUI.Settings.Combat.minimeter_show_total_heal_out then
		UpdateLabels(AUI_Minimeter_Label_Total_Heal_Out, AUI_Minimeter_Label_HPS_Out, AUI_COMBAT_DATA_TYPE_HEAL_OUT)
	end
	
	if AUI.Settings.Combat.minimeter_show_total_damage_in then
		UpdateLabels(AUI_Minimeter_Label_Total_Damage_In, AUI_Minimeter_Label_DPS_In, AUI_COMBAT_DATA_TYPE_DAMAGE_IN)
	end
	
	if AUI.Settings.Combat.minimeter_show_total_heal_in then
		UpdateLabels(AUI_Minimeter_Label_Total_Heal_In, AUI_Minimeter_Label_HPS_In, AUI_COMBAT_DATA_TYPE_HEAL_IN)
	end		
	
	if AUI.Settings.Combat.minimeter_show_combat_time then
		UpdateCombatTime()
	end
end

function AUI.Combat.Minimeter.IsShow()
	return not AUI_Minimeter:IsHidden()
end

function AUI.Combat.Minimeter.Show()
	if not mIsLoaded then
		return
	end

	AUI_Minimeter:SetHidden(false)
end

function AUI.Combat.Minimeter.Hide()
	if not mIsLoaded then
		return
	end

	AUI_Minimeter:SetHidden(true)
end

function AUI.Combat.Minimeter.ShowPreview()
	if not mIsLoaded then
		return
	end

	MINIMETER_SCENE_FRAGMENT.hiddenReasons:SetHiddenForReason("ShouldntShow", true)
	AUI.Combat.Minimeter.Show()
end

function AUI.Combat.Minimeter.HidePreview()
	if not mIsLoaded then
		return
	end

	MINIMETER_SCENE_FRAGMENT.hiddenReasons:SetHiddenForReason("ShouldntShow", false)
	AUI.Combat.Minimeter.Hide()
end

function AUI.Combat.Minimeter.UpdateUI()
	if not mIsLoaded then
		return
	end

	local iconTop = 8
	local labelTop = 14 - (AUI.Settings.Combat.minimeter_font_size / 2)
	local left = 10
	local offsetDistance = 0
	local distance = 70
	
	if AUI.Settings.Combat.minimeter_font_size > 16 then
		distance = distance + (AUI.Settings.Combat.minimeter_font_size - 16) * 8
	elseif AUI.Settings.Combat.minimeter_font_size < 16 then
		distance = distance - (AUI.Settings.Combat.minimeter_font_size / 8)
	end

	local minWidth = 200
	
	if AUI.Settings.Combat.minimeter_show_background then
		AUI_Minimeter_BG:SetHidden(false)			
	else
		AUI_Minimeter_BG:SetHidden(true)
	end
	
	AUI_Minimeter_Label_DPS_Out:SetFont(AUI.Settings.Combat.minimeter_font_art .. "|" .. AUI.Settings.Combat.minimeter_font_size .. "|" .. AUI.Settings.Combat.minimeter_font_style)
	AUI_Minimeter_Label_Total_Damage_Out:SetFont(AUI.Settings.Combat.minimeter_font_art .. "|" .. AUI.Settings.Combat.minimeter_font_size .. "|" .. AUI.Settings.Combat.minimeter_font_style)
	AUI_Minimeter_Label_HPS_Out:SetFont(AUI.Settings.Combat.minimeter_font_art .. "|" .. AUI.Settings.Combat.minimeter_font_size .. "|" .. AUI.Settings.Combat.minimeter_font_style)
	AUI_Minimeter_Label_Total_Heal_Out:SetFont(AUI.Settings.Combat.minimeter_font_art .. "|" .. AUI.Settings.Combat.minimeter_font_size .. "|" .. AUI.Settings.Combat.minimeter_font_style)			
	AUI_Minimeter_Label_DPS_In:SetFont(AUI.Settings.Combat.minimeter_font_art .. "|" .. AUI.Settings.Combat.minimeter_font_size .. "|" .. AUI.Settings.Combat.minimeter_font_style)		
	AUI_Minimeter_Label_Total_Damage_In:SetFont(AUI.Settings.Combat.minimeter_font_art .. "|" .. AUI.Settings.Combat.minimeter_font_size .. "|" .. AUI.Settings.Combat.minimeter_font_style)	
	AUI_Minimeter_Label_HPS_In:SetFont(AUI.Settings.Combat.minimeter_font_art .. "|" .. AUI.Settings.Combat.minimeter_font_size .. "|" .. AUI.Settings.Combat.minimeter_font_style)
	AUI_Minimeter_Label_Total_Heal_In:SetFont(AUI.Settings.Combat.minimeter_font_art .. "|" .. AUI.Settings.Combat.minimeter_font_size .. "|" .. AUI.Settings.Combat.minimeter_font_style)	
	AUI_Minimeter_Label_Time:SetFont(AUI.Settings.Combat.minimeter_font_art .. "|" .. AUI.Settings.Combat.minimeter_font_size .. "|" .. AUI.Settings.Combat.minimeter_font_style)	

	if AUI.Settings.Combat.minimeter_show_dps_out then
		AUI_Minimeter_Icon_DPS_Out:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, iconTop - 1)
	
		left = left + ICON_SIZE
	
		AUI_Minimeter_Label_DPS_Out:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, labelTop + 4)
		
		if AUI.Settings.Combat.minimeter_show_group_damage_out then
			left = left + distance + 40
		else
			left = left + distance
		end
		
		AUI_Minimeter_Icon_DPS_Out:SetHidden(false)
		AUI_Minimeter_Label_DPS_Out:SetHidden(false)
	else
		AUI_Minimeter_Icon_DPS_Out:SetHidden(true)
		AUI_Minimeter_Label_DPS_Out:SetHidden(true)
	end		
		
	if AUI.Settings.Combat.minimeter_show_total_damage_out then
		AUI_Minimeter_Icon_Total_Damage_Out:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, iconTop - 1)
	
		left = left + ICON_SIZE
	
		AUI_Minimeter_Label_Total_Damage_Out:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, labelTop + 4)
	
		left = left + distance
	
		AUI_Minimeter_Icon_Total_Damage_Out:SetHidden(false)
		AUI_Minimeter_Label_Total_Damage_Out:SetHidden(false)
	else
		AUI_Minimeter_Icon_Total_Damage_Out:SetHidden(true)
		AUI_Minimeter_Label_Total_Damage_Out:SetHidden(true)
	end
	
	if AUI.Settings.Combat.minimeter_show_hps_out then
		AUI_Minimeter_Icon_HPS_Out:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, iconTop - 1)
	
		left = left + ICON_SIZE
	
		AUI_Minimeter_Label_HPS_Out:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left + 2, labelTop + 4)	
				
		if AUI.Settings.Combat.minimeter_show_group_heal_out then
			left = left + distance + 40
		else
			left = left + distance
		end
				
		AUI_Minimeter_Icon_HPS_Out:SetHidden(false)
		AUI_Minimeter_Label_HPS_Out:SetHidden(false)
	else
		AUI_Minimeter_Icon_HPS_Out:SetHidden(true)
		AUI_Minimeter_Label_HPS_Out:SetHidden(true)
	end
	
	if AUI.Settings.Combat.minimeter_show_total_heal_out then
		AUI_Minimeter_Icon_Total_Heal_Out:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, iconTop + 2)
	
		left = left + ICON_SIZE
		
		AUI_Minimeter_Label_Total_Heal_Out:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left + 1, labelTop + 4)
		
		left = left + distance
	
		AUI_Minimeter_Icon_Total_Heal_Out:SetHidden(false)
		AUI_Minimeter_Label_Total_Heal_Out:SetHidden(false)
	else
		AUI_Minimeter_Icon_Total_Heal_Out:SetHidden(true)
		AUI_Minimeter_Label_Total_Heal_Out:SetHidden(true)
	end
	
	if AUI.Settings.Combat.minimeter_show_dps_in then
		AUI_Minimeter_Icon_DPS_In:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, iconTop - 1)
	
		left = left + ICON_SIZE
	
		AUI_Minimeter_Label_DPS_In:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, labelTop + 4)	
				
		left = left + distance	
				
		AUI_Minimeter_Icon_DPS_In:SetHidden(false)
		AUI_Minimeter_Label_DPS_In:SetHidden(false)
	else
		AUI_Minimeter_Icon_DPS_In:SetHidden(true)
		AUI_Minimeter_Label_DPS_In:SetHidden(true)
	end	
	
	if AUI.Settings.Combat.minimeter_show_total_damage_in then
		AUI_Minimeter_Icon_Total_Damage_In:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, iconTop - 1)
	
		left = left + ICON_SIZE
	
		AUI_Minimeter_Label_Total_Damage_In:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, labelTop + 4)	
				
		left = left + distance	
				
		AUI_Minimeter_Icon_Total_Damage_In:SetHidden(false)
		AUI_Minimeter_Label_Total_Damage_In:SetHidden(false)
	else
		AUI_Minimeter_Icon_Total_Damage_In:SetHidden(true)
		AUI_Minimeter_Label_Total_Damage_In:SetHidden(true)
	end	
	
	if AUI.Settings.Combat.minimeter_show_hps_in then
		AUI_Minimeter_Icon_HPS_In:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, iconTop - 1)
	
		left = left + ICON_SIZE
	
		AUI_Minimeter_Label_HPS_In:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, labelTop + 4)	
				
		left = left + distance	
				
		AUI_Minimeter_Icon_HPS_In:SetHidden(false)
		AUI_Minimeter_Label_HPS_In:SetHidden(false)
	else
		AUI_Minimeter_Icon_HPS_In:SetHidden(true)
		AUI_Minimeter_Label_HPS_In:SetHidden(true)
	end	
	
	if AUI.Settings.Combat.minimeter_show_total_heal_in then
		AUI_Minimeter_Icon_Total_Heal_In:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, iconTop)
	
		left = left + ICON_SIZE
	
		AUI_Minimeter_Label_Total_Heal_In:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, labelTop + 4)	
				
		left = left + distance	
				
		AUI_Minimeter_Icon_Total_Heal_In:SetHidden(false)
		AUI_Minimeter_Label_Total_Heal_In:SetHidden(false)
	else
		AUI_Minimeter_Icon_Total_Heal_In:SetHidden(true)
		AUI_Minimeter_Label_Total_Heal_In:SetHidden(true)
	end	
	
	if AUI.Settings.Combat.minimeter_show_combat_time then
		AUI_Minimeter_Icon_Time:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, iconTop + 2)
	
		left = left + ICON_SIZE
	
		AUI_Minimeter_Label_Time:SetAnchor(TOPLEFT, mMiniMeterControl, TOPLEFT, left, labelTop + 4)
	
		left = left + distance
		
		AUI_Minimeter_Icon_Time:SetHidden(false)
		AUI_Minimeter_Label_Time:SetHidden(false)
	else
		AUI_Minimeter_Icon_Time:SetHidden(true)
		AUI_Minimeter_Label_Time:SetHidden(true)
	end				
		
	if minWidth > left then
		left = minWidth
	end
		
	AUI_Minimeter:ClearAnchors()	
	AUI_Minimeter:SetAnchor(AUI.Settings.Combat.minimeter_position.point, GuiRoot, AUI.Settings.Combat.minimeter_position.relativePoint, AUI.Settings.Combat.minimeter_position.offsetX, AUI.Settings.Combat.minimeter_position.offsetY)		
		
	AUI_Minimeter:SetDimensions(left, 44)	
end

function AUI.Combat.Minimeter.SetToDefaultPosition(defaultSettings)
	if not mIsLoaded then
		return
	end

	AUI_Minimeter:ClearAnchors()	
	AUI_Minimeter:SetAnchor(defaultSettings.minimeter_position.point, GuiRoot, defaultSettings.minimeter_position.relativePoint, defaultSettings.minimeter_position.offsetX, defaultSettings.minimeter_position.offsetY)
	_, AUI.Settings.Combat.minimeter_position.point, _, AUI.Settings.Combat.minimeter_position.relativePoint, AUI.Settings.Combat.minimeter_position.offsetX, AUI.Settings.Combat.minimeter_position.offsetY = AUI_Minimeter:GetAnchor()
end

local function SetTooltip(_control, _str)
	_control:SetHandler("OnMouseDown", OnFrameMouseDown)
	_control:SetHandler("OnMouseUp", OnFrameMouseUp)	
	_control:SetHandler("OnMouseEnter", 
		function() 
			AUI.ShowTooltip(_str)
		end)
	_control:SetHandler("OnMouseExit", 
		function()  
			AUI.HideTooltip() 
		end)	
end

local function CreateUI()
	AUI_Minimeter:SetHandler("OnMouseDown", OnMouseDown)
	AUI_Minimeter:SetHandler("OnMouseUp", OnMouseUp)	
	AUI_Minimeter:SetHandler("OnMouseEnter", OnMouseEnter)
	AUI_Minimeter:SetHandler("OnMouseExit", OnMouseExit)		
	
	AUI_Minimeter_BG:SetEdgeTexture(MINIMETER_DEFAULT_BG_TEXTURE, 256, 128, 22)
	AUI_Minimeter_BG:SetCenterColor(1, 1, 1, 0)

	AUI_Minimeter_Icon_DPS_Out:SetDimensions(ICON_SIZE, ICON_SIZE)
	SetTooltip(AUI_Minimeter_Icon_DPS_Out, AUI.L10n.GetString("damage_per_second") .. " (" .. AUI.L10n.GetString("outgoing") .. ")")
	SetTooltip(AUI_Minimeter_Label_DPS_Out, AUI.L10n.GetString("damage_per_second") .. " (" .. AUI.L10n.GetString("outgoing") .. ")")
	
	AUI_Minimeter_Icon_Total_Damage_Out:SetDimensions(ICON_SIZE, ICON_SIZE)
	SetTooltip(AUI_Minimeter_Icon_Total_Damage_Out, AUI.L10n.GetString("total_damage") .. " (" .. AUI.L10n.GetString("outgoing") .. ")")
	SetTooltip(AUI_Minimeter_Label_Total_Damage_Out, AUI.L10n.GetString("total_damage") .. " (" .. AUI.L10n.GetString("outgoing") .. ")")
	
	AUI_Minimeter_Icon_HPS_Out:SetDimensions(ICON_SIZE, ICON_SIZE)
	SetTooltip(AUI_Minimeter_Icon_HPS_Out, AUI.L10n.GetString("healing_per_second") .. " (" .. AUI.L10n.GetString("outgoing") .. ")")
	SetTooltip(AUI_Minimeter_Label_HPS_Out, AUI.L10n.GetString("healing_per_second") .. " (" .. AUI.L10n.GetString("outgoing") .. ")")	
	
	AUI_Minimeter_Icon_Total_Heal_Out:SetDimensions(ICON_SIZE - 6, ICON_SIZE - 6)
	SetTooltip(AUI_Minimeter_Icon_Total_Heal_Out, AUI.L10n.GetString("total_healing") .. " (" .. AUI.L10n.GetString("outgoing") .. ")")
	SetTooltip(AUI_Minimeter_Label_Total_Heal_Out, AUI.L10n.GetString("total_healing") .. " (" .. AUI.L10n.GetString("outgoing") .. ")")	
		
	AUI_Minimeter_Icon_DPS_In:SetDimensions(ICON_SIZE, ICON_SIZE)
	SetTooltip(AUI_Minimeter_Icon_DPS_In, AUI.L10n.GetString("damage_per_second") .. " (" .. AUI.L10n.GetString("incoming") .. ")")
	SetTooltip(AUI_Minimeter_Label_DPS_In, AUI.L10n.GetString("damage_per_second") .. " (" .. AUI.L10n.GetString("incoming") .. ")")
	
	AUI_Minimeter_Icon_Total_Damage_In:SetDimensions(ICON_SIZE, ICON_SIZE)
	SetTooltip(AUI_Minimeter_Icon_Total_Damage_In, AUI.L10n.GetString("total_damage") .. " (" .. AUI.L10n.GetString("incoming") .. ")")
	SetTooltip(AUI_Minimeter_Label_Total_Damage_In, AUI.L10n.GetString("total_damage") .. " (" .. AUI.L10n.GetString("incoming") .. ")")		
	
	AUI_Minimeter_Icon_HPS_In:SetDimensions(ICON_SIZE, ICON_SIZE)
	SetTooltip(AUI_Minimeter_Icon_HPS_In, AUI.L10n.GetString("healing_per_second") .. " (" .. AUI.L10n.GetString("incoming") .. ")")
	SetTooltip(AUI_Minimeter_Label_HPS_In, AUI.L10n.GetString("healing_per_second") .. " (" .. AUI.L10n.GetString("incoming") .. ")")		
	
	AUI_Minimeter_Icon_Total_Heal_In:SetDimensions(ICON_SIZE, ICON_SIZE)
	SetTooltip(AUI_Minimeter_Icon_Total_Heal_In, AUI.L10n.GetString("total_healing") .. " (" .. AUI.L10n.GetString("incoming") .. ")")
	SetTooltip(AUI_Minimeter_Label_Total_Heal_In, AUI.L10n.GetString("total_healing") .. " (" .. AUI.L10n.GetString("incoming") .. ")")	
	
	AUI_Minimeter_Icon_Time:SetDimensions(ICON_SIZE - 6, ICON_SIZE - 6)
	SetTooltip(AUI_Minimeter_Icon_Time, AUI.L10n.GetString("combat_time"))
	SetTooltip(AUI_Minimeter_Label_Time, AUI.L10n.GetString("combat_time"))		
end

function AUI.Combat.Minimeter.Load()
	if mIsLoaded then
		return
	end

	mIsLoaded = true	
	
	CreateUI()
	
	MINIMETER_SCENE_FRAGMENT = ZO_SimpleSceneFragment:New(AUI_Minimeter)	
	MINIMETER_SCENE_FRAGMENT.hiddenReasons = ZO_HiddenReasons:New()		
    MINIMETER_SCENE_FRAGMENT:SetConditional(function()
        return not MINIMETER_SCENE_FRAGMENT.hiddenReasons:IsHidden()
    end)		

	HUD_SCENE:AddFragment(MINIMETER_SCENE_FRAGMENT)
	HUD_UI_SCENE:AddFragment(MINIMETER_SCENE_FRAGMENT)
	
	SIEGE_BAR_SCENE:AddFragment(MINIMETER_SCENE_FRAGMENT)
	if SIEGE_BAR_UI_SCENE then
		SIEGE_BAR_UI_SCENE:AddFragment(MINIMETER_SCENE_FRAGMENT)
	end		
	
	AUI.ResetMiniMeter()
	AUI.Combat.Minimeter.UpdateUI()
end