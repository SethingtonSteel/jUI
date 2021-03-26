AUI.Actionbar = {}

local MAX_QUICK_SLOTS = 8
local ULTIMATE_SLOT_INDEX = ACTION_BAR_ULTIMATE_SLOT_INDEX + 1
local UTILITY_SLOT_INDEX = ACTION_BAR_FIRST_UTILITY_BAR_SLOT + 1

local gQuickSlotAssignList =
{
	[1] = 12,
	[2] = 11,
	[3] = 10,
	[4] = 9,
	[5] = 16,
	[6] = 15,
	[7] = 14,
	[8] = 13,
}

local gIsLoaded = false
local gAbilityProcEffects = {}
local gQuickSlotList = {}
local gAbilitySlotList ={}
local gOverlayUltimatePercent = nil
local gUltimateLabel = nil
local gKeybindBGControl = nil

local gZO_acionBarControl = ZO_ActionBar1
local gZO_actionBargKeybindBGControl = ZO_ActionBar1:GetNamedChild("KeybindBG")
local gZO_weaponSwapControl = ZO_ActionBar1:GetNamedChild("WeaponSwap")
local gZO_quickSlot = ZO_ActionBar_GetButton(UTILITY_SLOT_INDEX)
local gZO_actionBarUltimateButton = ZO_ActionBar_GetButton(ULTIMATE_SLOT_INDEX)

local function GetUltimateString(_powerValue)
	if _powerValue == 0 then
		return ""
	end

	return _powerValue
end

local function GetUltimatePercentString(_powerValue)
	local ultimateSlot = GetSlotAbilityCost(8)

	if ultimateSlot > 0 then 
		local unitPercent = AUI.Math.Round((_powerValue / ultimateSlot) * 100)

		if not AUI.Settings.Actionbar.allow_over_100_percent and unitPercent > 100 then
			unitPercent = 100
		end
		
		return unitPercent .. "%"
	end
	
	return ""
end

local function UpdateUltimateText(_powerValue, _maxValue)
	if not _powerValue or not _maxValue then
		_powerValue, _maxValue = GetUnitPower(AUI_PLAYER_UNIT_TAG, POWERTYPE_ULTIMATE)
	end

	local percent = GetUltimatePercentString(_powerValue)
	gOverlayUltimatePercent:SetText(percent)
	gUltimateLabel:SetText(GetUltimateString(_powerValue, _powerMax))		
end

local function GetQuickslot(_slotId)
	return gQuickSlotList[_slotId]
end

function AUI.Actionbar.SelectQuickSlotButton(_slotId)
	if not gIsLoaded or QUICKSLOT_FRAGMENT:IsShowing() then
		return
	end

	local item = GetQuickslot(_slotId)
	if item and not QUICKSLOT_FRAGMENT:IsShowing() then
		SetCurrentQuickslot(item.button.slotNum)
	end
	
	AUI.Actionbar.SelectCurrentQuickSlot()
end

local function GetSlotData(_slotId)
	for slotId, slot in pairs(gQuickSlotList) do
		local itemSlotId = slot:GetSlot()
		if itemSlotId == _slotId then
			return slotId, slot
		end
	end
end

local function GetSlotIdFromAbilityId(_abilityId)
	local abilityId = AUI.Ability.GetProcAssignment(_abilityId)

	local abilityName = GetAbilityName(abilityId)

	for slotId, actionButton in pairs(gAbilitySlotList) do
		local slotName = GetSlotName(slotId)

		if slotName == abilityName then
			return slotId, true	
		end	
	end
	
	return -1, false
end

local function AddProcEffect(_abilityId)
	local slotId = GetSlotIdFromAbilityId(_abilityId)
	if slotId then
		local actionButton = ZO_ActionBar_GetButton(slotId)
		if actionButton then
			actionButton.procBurstTimeline:PlayFromStart()
			actionButton.procLoopTimeline:PlayFromStart()
			actionButton.procBurstTexture:SetHidden(false)
			actionButton.procLoopTexture:SetHidden(false)
		end
		
		gAbilityProcEffects[slotId] = _abilityId
	end
end

local function RemoveProcEffect(_abilityId)
	for slotId, abilityId in pairs(gAbilityProcEffects) do
		if abilityId == _abilityId then
			local actionButton = ZO_ActionBar_GetButton(slotId)
			if actionButton then
				actionButton.procBurstTimeline:Stop()
				actionButton.procLoopTimeline:Stop()
				actionButton.procBurstTexture:SetHidden(true)
				actionButton.procLoopTexture:SetHidden(true)
			end				
				
			gAbilityProcEffects[slotId] = nil			
		end
	end	
end

local function UpdateProcAbilitys()
	for slotId, actionButton in pairs(gAbilitySlotList) do
		actionButton.procBurstTimeline:Stop()
		actionButton.procLoopTimeline:Stop()
		actionButton.procBurstTexture:SetHidden(true)
		actionButton.procLoopTexture:SetHidden(true)
	end

	for _, abilityId in pairs(gAbilityProcEffects) do
		local slotId = GetSlotIdFromAbilityId(abilityId)
		if slotId then
			local actionButton = ZO_ActionBar_GetButton(slotId)
			if actionButton then
				actionButton.procBurstTimeline:PlayFromStart()
				actionButton.procLoopTimeline:PlayFromStart()
				actionButton.procBurstTexture:SetHidden(false)
				actionButton.procLoopTexture:SetHidden(false)
			end
		end
	end	
end

local function IsQuickSlotActive(_slotId)
	if gQuickSlotList[_slotId] then
		local slotCount = 0

		if IsInGamepadPreferredMode() then
			slotCount = AUI.Settings.Actionbar.gamepad_quickslot_count
		else
			slotCount = AUI.Settings.Actionbar.keyboard_quickslot_count
		end

		if _slotId and _slotId <= slotCount then
			return true
		end
	end
	
	return false
end

function AUI.Actionbar.SelectCurrentQuickSlot()
	if not gIsLoaded or QUICKSLOT_FRAGMENT:IsShowing() then
		return
	end

	for _, button in pairs(gQuickSlotList) do
		button:Unselect()
	end	
				
	if not QUICKSLOT_FRAGMENT:IsShowing() then
		local currentQuickSlotId = GetCurrentQuickslot()
		local slotId, quickSlotControl = GetSlotData(currentQuickSlotId)
			
		if IsQuickSlotActive(slotId) then	
			quickSlotControl:Select()
		end
	end
end

function AUI.Actionbar.SelectNextQuickSlotButton()
	if not gIsLoaded or QUICKSLOT_FRAGMENT:IsShowing() then
		return
	end

	local currentQuickSlotId = GetCurrentQuickslot()
	local slotId, quickSlotControl = GetSlotData(currentQuickSlotId)	
	
	slotId = slotId + 1
	
	if not IsQuickSlotActive(slotId) then
		slotId = 1
	end
	
	AUI.Actionbar.SelectQuickSlotButton(slotId)
end

function AUI.Actionbar.SelectPreviosQuickSlotButton()
	if not gIsLoaded or QUICKSLOT_FRAGMENT:IsShowing() then
		return
	end

	local currentQuickSlotId = GetCurrentQuickslot()
	local slotId, quickSlotControl = GetSlotData(currentQuickSlotId)	
	slotId = slotId - 1
	
	if not IsQuickSlotActive(slotId) then
		local slotCount = AUI.Settings.Actionbar.keyboard_quickslot_count
		if IsInGamepadPreferredMode() then
			slotCount = AUI.Settings.Actionbar.gamepad_quickslot_count
		end	
	
		slotId = slotCount
	end	
	
	AUI.Actionbar.SelectQuickSlotButton(slotId)
end

function AUI.Actionbar.DoesShow()
	return not gZO_acionBarControl:IsHidden()
end

function AUI.Actionbar.Lock()
	if not gIsLoaded then
		return
	end

	ACTION_BAR_FRAGMENT:SetHiddenForReason("ShouldntShow", true)
	gZO_acionBarControl:SetHidden(false)
end

function AUI.Actionbar.Unlock()
	if not gIsLoaded then
		return
	end

	ACTION_BAR_FRAGMENT:SetHiddenForReason("ShouldntShow", false)
	gZO_acionBarControl:SetHidden(true)
end

local function CreateQuickSlotButton(physicalSlot, buttonObject)
    return buttonObject:New(physicalSlot, ACTION_BUTTON_TYPE_VISIBLE, gZO_acionBarControl, "ZO_ActionButton")
end	
	
function AUI.Actionbar.UpdateUI()
	if not gIsLoaded then
		return
	end

	if AUI.Settings.Actionbar.show_text then
		gUltimateLabel:SetHidden(false)
		gOverlayUltimatePercent:SetHidden(false)	
	else
		gUltimateLabel:SetHidden(true)
		gOverlayUltimatePercent:SetHidden(true)	
	end		
		
	gUltimateLabel:SetFont("$(MEDIUM_FONT)|" .. 14 .. "|" .. "thick-outline")
	gOverlayUltimatePercent:SetFont("$(MEDIUM_FONT)|" .. 12 .. "|" .. "thick-outline")	

	gUltimateLabel:ClearAnchors()
	gUltimateLabel:SetAnchor(BOTTOM, nil, TOP, -1, 0)

	local lastSlot = nil
	local activeQuickSlotCount = 1
	
	for slotId = 1, MAX_QUICK_SLOTS do
		local buttonControl = gQuickSlotList[slotId]
	
		if not buttonControl then
			local itemSlotId = gQuickSlotAssignList[slotId]
			
			gQuickSlotList[slotId] = CreateQuickSlotButton(itemSlotId, AUI_QuickSlotButton)
			buttonControl = gQuickSlotList[slotId]
		end
		
		local anchorTarget = lastSlot and lastSlot.slot
		local anchorOffsetX = 2
		
		if not lastSlot then
			anchorTarget = gZO_quickSlot.slot
			anchorOffsetX = 30
		end	
		
		buttonControl:SetupBounceAnimation()
		buttonControl:ApplyStyle(ZO_GetPlatformTemplate("ZO_ActionButton"))
		buttonControl.countText:SetFont("$(MEDIUM_FONT)|" .. 12 .. "|" .. "soft-shadow-thin")
		buttonControl:ApplyAnchor(anchorTarget, anchorOffsetX)
		buttonControl:SetupBounceAnimation()

		if IsQuickSlotActive(slotId) then
			activeQuickSlotCount = activeQuickSlotCount + 1
			buttonControl:HandleSlotChanged()
			buttonControl.slot:SetHidden(false)		
		else
			buttonControl.slot:SetHidden(true)
		end			
		
		lastSlot = buttonControl
	end
		
	if not IsInGamepadPreferredMode() then	
		local ultimateOffsetX = 40
	
		if QUICKSLOT_FRAGMENT:IsShowing() then		
			gZO_weaponSwapControl:SetHidden(true)
			
			gZO_actionBarUltimateButton.slot:SetHidden(true)
			
			for _, _actionButton in pairs(gAbilitySlotList) do			
				if _actionButton and _actionButton.slot then		
					_actionButton.slot:SetHidden(true)
				end
			end	
		else
			gZO_actionBarUltimateButton.slot:SetHidden(false)
			gZO_weaponSwapControl:SetHidden(gZO_weaponSwapControl:SetHidden(gZO_weaponSwapControl.permanentlyHidden))

			for _, _actionButton in pairs(gAbilitySlotList) do			
				if _actionButton and _actionButton.slot then		
					_actionButton.slot:SetHidden(false)
				end
			end	
		end

		gZO_weaponSwapControl:ClearAnchors()
		if activeQuickSlotCount > 1 then
			gZO_weaponSwapControl:SetAnchor(LEFT, gQuickSlotList[activeQuickSlotCount - 1].slot, RIGHT, 5)
		else
			gZO_weaponSwapControl:SetAnchor(LEFT, gZO_quickSlot.slot, RIGHT, 5)
		end
		
		gZO_actionBarUltimateButton:ApplyAnchor(gAbilitySlotList[ACTION_BAR_FIRST_NORMAL_SLOT_INDEX + ACTION_BAR_SLOTS_PER_PAGE - 1].slot, ultimateOffsetX)

		gKeybindBGControl:ClearAnchors()
		gKeybindBGControl:SetAnchor(BOTTOMLEFT, gZO_quickSlot.slot, BOTTOMRIGHT, -50, 0)	
		gKeybindBGControl:SetAnchor(BOTTOMRIGHT, gZO_actionBarUltimateButton.slot, BOTTOM, 24, 34)		

		--ZO_HUDEquipmentStatusWeaponIndicator:SetAnchor(BOTTOM, gZO_actionBarUltimateButton.slot, RIGHT, 0, 0)	

		gZO_acionBarControl:SetWidth(gKeybindBGControl:GetWidth())	
		
		if AUI.Settings.Actionbar.show_background then
			gKeybindBGControl:SetHidden(false)
		else
			gKeybindBGControl:SetHidden(true)
		end
	else
	
		gZO_weaponSwapControl:ClearAnchors()
		if activeQuickSlotCount > 1 then
			gZO_weaponSwapControl:SetAnchor(LEFT, gQuickSlotList[activeQuickSlotCount - 1].slot, RIGHT, -18)
		else
			gZO_weaponSwapControl:SetAnchor(LEFT, gZO_quickSlot.slot, RIGHT, 0)
		end
					
		gKeybindBGControl:ClearAnchors()
		gKeybindBGControl:SetAnchor(BOTTOMLEFT, gZO_quickSlot.slot, BOTTOM, -40, 0)	
		gKeybindBGControl:SetAnchor(BOTTOMRIGHT, gZO_actionBarUltimateButton.slot, BOTTOM, 0, 0)		
		
		gZO_acionBarControl:SetWidth(gKeybindBGControl:GetWidth() + 10)	

		gKeybindBGControl:SetHidden(true)		
	end
		
	UpdateProcAbilitys()
	UpdateUltimateText()
	AUI.Actionbar.SelectCurrentQuickSlot()	
end

function AUI.Actionbar.OnPowerUpdate(_unitTag, _powerIndex, _powerType, _powerValue, _powerMax, _powerEffectiveMax)
	if not gIsLoaded or _unitTag ~= AUI_PLAYER_UNIT_TAG then
		return
	end

	if _powerType == POWERTYPE_ULTIMATE then
		UpdateProcAbilitys()
		UpdateUltimateText(_powerValue, _powerMax)
	end
end

function AUI.Actionbar.UpdateCooldowns()
	if not gIsLoaded or QUICKSLOT_FRAGMENT:IsShowing() then
		return
	end
	
	for slotId, buttonControl in pairs(gQuickSlotList) do
		if IsQuickSlotActive(slotId) then	
			buttonControl:UpdateCooldown()
		end
	end 	
end

function AUI.Actionbar.UpdateSlots(_slotId)
	if not gIsLoaded then
		return
	end

	if _slotId then
		if _slotId == ULTIMATE_SLOT_INDEX then
			UpdateUltimateText()
		else
			local button = gQuickSlotList[_slotId]
			if button and IsQuickSlotActive(slotId) then
				button:HandleSlotChanged()	
			end	
		end
	else
		UpdateUltimateText()
	
		for slotId, buttonControl in pairs(gQuickSlotList) do
			if IsQuickSlotActive(slotId) then
				buttonControl:HandleSlotChanged()	
			end
		end
	end
end

function AUI.Actionbar.UpdateProcEffects()
	if not gIsLoaded or QUICKSLOT_FRAGMENT:IsShowing() then
		return
	end
	
	UpdateProcAbilitys()
end

function AUI.Actionbar.OnEffectChanged(_changeType, _effectSlot, _effectName, _unitTag, _beginTime, _endTime, _stackCount, _iconName, _buffType, _effectType, _abilityType, _statusEffectType, _unitName, _unitId, _abilityId)
	if not gIsLoaded or _unitTag ~= AUI_PLAYER_UNIT_TAG then
		return
	end
	
	if AUI.Ability.IsProc(_abilityId) then
		if _changeType == 1 then
			AddProcEffect(_abilityId)
		elseif _changeType == 2 then
			RemoveProcEffect(_abilityId)					
		end
	end
end

function AUI.Actionbar.OnGamepadPreferredModeChanged(_gamepadPreferred)
	AUI.Actionbar.UpdateUI()	
end

local function CreateActionButtons()
	for i = ACTION_BAR_FIRST_NORMAL_SLOT_INDEX + 1, ACTION_BAR_FIRST_NORMAL_SLOT_INDEX + ACTION_BAR_SLOTS_PER_PAGE - 1 do
		gAbilitySlotList[i] = ZO_ActionBar_GetButton(i)
		
		if not gAbilitySlotList[i].procBurstTexture then
			gAbilitySlotList[i].procBurstTexture = WINDOW_MANAGER:CreateControl("$(parent)Burst", gAbilitySlotList[i].slot, CT_TEXTURE)
			gAbilitySlotList[i].procBurstTexture:SetAnchor(TOPLEFT)
			gAbilitySlotList[i].procBurstTexture:SetAnchor(BOTTOMRIGHT)			
			gAbilitySlotList[i].procBurstTexture:SetTexture("EsoUI/Art/ActionBar/coolDown_completeEFX.dds")
			gAbilitySlotList[i].procBurstTexture:SetDrawTier(DT_HIGH)
		end
		
		if not gAbilitySlotList[i].procLoopTexture then
			gAbilitySlotList[i].procLoopTexture = WINDOW_MANAGER:CreateControl("$(parent)Loop", gAbilitySlotList[i].slot, CT_TEXTURE)
			gAbilitySlotList[i].procLoopTexture:SetAnchor(TOPLEFT)
			gAbilitySlotList[i].procLoopTexture:SetAnchor(BOTTOMRIGHT)
			gAbilitySlotList[i].procLoopTexture:SetTexture("EsoUI/Art/ActionBar/abilityHighlight_mage_med.dds") 
			gAbilitySlotList[i].procLoopTexture:SetDrawTier(DT_HIGH)		
		end
		
		if not gAbilitySlotList[i].procBurstTimeline then	
			gAbilitySlotList[i].procBurstTimeline = ANIMATION_MANAGER:CreateTimelineFromVirtual("AbilityProcReadyBurst", gAbilitySlotList[i].procBurstTexture)	
		end
		
		if not gAbilitySlotList[i].procLoopTimeline then	
			gAbilitySlotList[i].procLoopTimeline = ANIMATION_MANAGER:CreateTimelineFromVirtual("AbilityProcReadyLoop", gAbilitySlotList[i].procLoopTexture)				
		end
		
		gAbilitySlotList[i].procBurstTexture:SetHidden(true)
		gAbilitySlotList[i].procLoopTexture:SetHidden(true)		
	end
end

function AUI.Actionbar.OnActionSlotUpdated(_slotId)
	if not gIsLoaded then
		return
	end
	
	if QUICKSLOT_FRAGMENT:IsShowing() then
		AUI.Actionbar.UpdateUI()
	else
		AUI.Actionbar.UpdateSlots(_slotId)
	end
end

function AUI.Actionbar.OnActionSlotsFullUpdate(_isHotbarSwap)
	if not gIsLoaded or QUICKSLOT_FRAGMENT:IsShowing() then
		if QUICKSLOT_FRAGMENT:IsShowing() then
			AUI.Actionbar.UpdateUI()
		end		
	
		return
	end	
	
	if not _isHotbarSwap then
		AUI.Actionbar.UpdateSlots()
	else
		UpdateUltimateText()
		AUI.Actionbar.UpdateProcEffects()
	end
end

function AUI.Actionbar.OnInventorySingleSlotUpdate(_bagId, _slotId, _isNewItem, _itemSoundCategory, _inventoryUpdateReason)
	if not gIsLoaded then
		return
	end

	AUI.Actionbar.UpdateSlots()
end

function AUI.Actionbar.DisableDefaultUltiTextSetting()
	SetSetting(SETTING_TYPE_UI, UI_SETTING_ULTIMATE_NUMBER, "false")
end

function AUI.Actionbar.Load()
	if gIsLoaded then
		return
	end
	
	gIsLoaded = true	

	AUI.Actionbar.LoadSettings()

	gUltimateLabel = WINDOW_MANAGER:CreateControl(nil, gZO_actionBarUltimateButton.slot, CT_LABEL)
	gUltimateLabel:SetResizeToFitDescendents(true)
	gUltimateLabel:SetInheritScale(false)
	gUltimateLabel:SetHorizontalAlignment(_hAlign or TEXT_ALIGN_CENTER)
	gUltimateLabel:SetVerticalAlignment(_vAlign or TEXT_ALIGN_CENTER)		
	
	gOverlayUltimatePercent = WINDOW_MANAGER:CreateControl(nil, gZO_actionBarUltimateButton.slot, CT_LABEL)
	gOverlayUltimatePercent:SetResizeToFitDescendents(true)
	gOverlayUltimatePercent:SetInheritScale(false)
	gOverlayUltimatePercent:SetHorizontalAlignment(_hAlign or TEXT_ALIGN_CENTER)
	gOverlayUltimatePercent:SetVerticalAlignment(_vAlign or TEXT_ALIGN_CENTER)	
	gOverlayUltimatePercent:SetAnchor(BOTTOM, gZO_actionBarUltimateButton.slot, BOTTOM, 0, 0)	
	
	gKeybindBGControl = CreateControlFromVirtual(gZO_acionBarControl:GetName() .. "_AUI_Keybind_bg", gZO_acionBarControl, "AUI_Actionbar_KeybindBG")
	gKeybindBGControl:SetHeight(44)
	gKeybindBGControl:SetEdgeTexture("/EsoUi/art/chatwindow/chat_bg_edge.dds", 256, 128, 22)
	gKeybindBGControl:SetCenterColor(1, 1, 1, 0)	
	
	gZO_actionBargKeybindBGControl:SetHidden(true)
	
	if not AUI.FrameMover.IsEnabled() then	
		ZO_HUDEquipmentStatus:ClearAnchors()
		ZO_HUDEquipmentStatus:SetAnchor(LEFT, ZO_ActionBar1, RIGHT)
	end	
		
	CreateActionButtons()		

	if AUI.Settings.Actionbar.show_text then
		SetSetting(SETTING_TYPE_UI, UI_SETTING_ULTIMATE_NUMBER, "false")

		EVENT_MANAGER:RegisterForEvent("AUI_DEFAULT_ULTI_SETTING_CHANGED", EVENT_INTERFACE_SETTING_CHANGED, function(_, settingType, settingId)
			if settingType == SETTING_TYPE_UI and settingId == UI_SETTING_ULTIMATE_NUMBER and AUI.Settings.Actionbar.show_text then
				if GetSetting_Bool(SETTING_TYPE_UI, UI_SETTING_ULTIMATE_NUMBER) then
					AUI.Actionbar.DisableDefaultUltiTextSetting()
				end
			end
		end)	
	end

	QUICKSLOT_FRAGMENT:RegisterCallback("StateChange", 
	function(oldState, newState)
		if gIsLoaded then
			if newState == SCENE_SHOWING then	
				ACTION_BAR_FRAGMENT:Show()			
				AUI.Actionbar.UpdateUI()				
			elseif newState == SCENE_HIDING then
				AUI.Actionbar.UpdateUI()
			end
		end													
	end)			
end