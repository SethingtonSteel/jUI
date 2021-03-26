local HarvensImprovedSkillsWindow = {}

function HarvensImprovedSkillsWindow.UpgradeAbilityOnMouseEnter(control)
	InitializeTooltip(SkillTooltip, control, TOPLEFT, 5, -5, TOPRIGHT)
	local ability = control:GetParent()
	local skillType, skillLineIndex, skillIndex = ability.slot.skillProgressionData:GetIndices()
    SkillTooltip:SetSkillUpgradeAbility(skillType, skillLineIndex, skillIndex)
end

function HarvensImprovedSkillsWindow.AbilityOnMouseEnter(control)
	local ability = control:GetParent()
	local skillType, skillLineIndex, skillIndex = ability.slot.skillProgressionData:GetIndices()
	if ability.progressionIndex then
		_, morph, rank = GetAbilityProgressionInfo(ability.progressionIndex)
		if morph > 0 and rank >= 4 then return end
		InitializeTooltip(HarvensSkillTooltipMorph1, control, TOPLEFT, 5, 5, BOTTOMRIGHT)
    	HarvensSkillTooltipMorph1:SetProgressionAbility(ability.progressionIndex, morph, rank+1)
		InitializeTooltip(SkillTooltip, HarvensSkillTooltipMorph1, TOPRIGHT, -5, 0, TOPLEFT)
		SkillTooltip:SetSkillAbility(skillType, skillLineIndex, skillIndex)
	else
		InitializeTooltip(SkillTooltip, control, TOPLEFT, 5, 5, BOTTOMRIGHT)
		SkillTooltip:SetSkillAbility(skillType, skillLineIndex, skillIndex)
	end
end

function HarvensImprovedSkillsWindow.AbilityOnMouseExit(control)
	ClearTooltip(SkillTooltip)
	ClearTooltip(HarvensSkillTooltipMorph1)
end

local function FindLineMaxRank(skillType, skillIndex)
	if skillType == SKILL_TYPE_ARMOR or skillType == SKILL_TYPE_CLASS or skillType == SKILL_TYPE_RACIAL or skillType == SKILL_TYPE_TRADESKILL or skillType == SKILL_TYPE_WEAPON then
		return 50, GetSkillLineRankXPExtents(skillType, skillIndex, 49)
	else
		local maxRanks = {20, 12, 10, 6}
		for i=1,#maxRanks do
			local startXP, nextStartXP = GetSkillLineRankXPExtents(skillType, skillIndex, maxRanks[i]-1)
			if startXP ~= nil and nextStartXP ~= nil then
				return maxRanks[i], startXP, nextStartXP
			end
		end
	end
	return 0
end

function HarvensImprovedSkillsWindow.Initialize(eventCode, addonName)
	if addonName ~= "HarvensImprovedSkillsWindow" then return end
	
	local defaults = { showDetails = true, showTotal = false }
	HarvensImprovedSkillsWindow.sv = ZO_SavedVars:New("HarvensImprovedSkillsWindow_SavedVariables", 1, nil, defaults)
	
	local checkbox = WINDOW_MANAGER:CreateControlFromVirtual(SKILLS_WINDOW.control:GetName().."HarvensShowDetails", SKILLS_WINDOW.control, "HarvensImprovedSkillsWindowShowDetails")
	checkbox:SetAnchor(BOTTOMRIGHT, SKILLS_WINDOW.control, TOPRIGHT, -8, -8)
	ZO_CheckButton_SetLabelText(checkbox, "Show detailed skills progression")
	checkbox:GetNamedChild("Label"):ClearAnchors()
	checkbox:GetNamedChild("Label"):SetAnchor(RIGHT, checkbox, LEFT, -4)
	ZO_CheckButton_SetCheckState(checkbox, HarvensImprovedSkillsWindow.sv.showDetails)
	ZO_CheckButton_SetToggleFunction(checkbox, function()
		HarvensImprovedSkillsWindow.sv.showDetails = ZO_CheckButton_IsChecked(checkbox)
		SKILLS_WINDOW:RefreshSkillLineInfo()
		SKILLS_WINDOW:RebuildSkillList()
	end)
	
	local checkboxTotal = WINDOW_MANAGER:CreateControlFromVirtual(SKILLS_WINDOW.control:GetName().."HarvensShowTotal", SKILLS_WINDOW.control, "HarvensImprovedSkillsWindowShowDetails")
	checkboxTotal:SetAnchor(BOTTOMRIGHT, checkbox, TOPRIGHT, 0, -8)
	ZO_CheckButton_SetLabelText(checkboxTotal, "Show total skill line progression")
	checkboxTotal:GetNamedChild("Label"):ClearAnchors()
	checkboxTotal:GetNamedChild("Label"):SetAnchor(RIGHT, checkboxTotal, LEFT, -4)
	ZO_CheckButton_SetCheckState(checkboxTotal, HarvensImprovedSkillsWindow.sv.showTotal)
	ZO_CheckButton_SetToggleFunction(checkboxTotal, function()
		HarvensImprovedSkillsWindow.sv.showTotal = ZO_CheckButton_IsChecked(checkboxTotal)
		SKILLS_WINDOW:RefreshSkillLineInfo()
		SKILLS_WINDOW:RebuildSkillList()
	end)
	
	local AbilitySlotOnMouseEnterOrg = ZO_Skills_AbilitySlot_OnMouseEnter
	ZO_Skills_AbilitySlot_OnMouseEnter = function(control)
		AbilitySlotOnMouseEnterOrg(control)
		local skillType, skillLineIndex, skillIndex = control.skillProgressionData:GetIndices()
    	local ability = control:GetParent()
    	local curLvl, maxLvl = GetSkillAbilityUpgradeInfo(skillType, skillLineIndex, skillIndex)
		local skillPointAllocator = control.skillProgressionData:GetSkillData():GetPointAllocator()
    	if ability.progressionIndex then
    		_, morph, rank = GetAbilityProgressionInfo(ability.progressionIndex)
    		if morph == 0 then rank = 0 end
			if morph > 0 and rank >= 4 then
				InitializeTooltip(HarvensSkillTooltipMorph1, control, TOPRIGHT, -5, -5, TOPLEFT)
				morph = (morph == 2 and 1 or 2)
				HarvensSkillTooltipMorph1:SetProgressionAbility(ability.progressionIndex, morph, rank)
				return
			end
    		InitializeTooltip(HarvensSkillTooltipMorph2, control, TOPRIGHT, -5, -5, TOPLEFT)
    		HarvensSkillTooltipMorph2:SetProgressionAbility(ability.progressionIndex, 2, rank+1)
			InitializeTooltip(HarvensSkillTooltipMorph1, HarvensSkillTooltipMorph2, TOPRIGHT, -5, 0, TOPLEFT)
    		HarvensSkillTooltipMorph1:SetProgressionAbility(ability.progressionIndex, 1, rank+1)
    		return
    	elseif curLvl and maxLvl and curLvl < maxLvl and skillPointAllocator:IsPurchased() then
    		InitializeTooltip(HarvensSkillTooltipMorph1, control, TOPRIGHT, -5, -5, TOPLEFT)
    		HarvensSkillTooltipMorph1:SetSkillUpgradeAbility(skillType, skillLineIndex, skillIndex)
    	end
	end
	
	local AbilitySlotOnMouseExitOrg = ZO_Skills_AbilitySlot_OnMouseExit
	ZO_Skills_AbilitySlot_OnMouseExit = function()
		ClearTooltip(SkillTooltip)
		ClearTooltip(HarvensSkillTooltipMorph1)
		ClearTooltip(HarvensSkillTooltipMorph2)
	end
	
	local SetupAbilityEntryOrg = SKILLS_WINDOW.SetupAbilityEntry
	SKILLS_WINDOW.SetupAbilityEntry = function(manager, control, data)
		SetupAbilityEntryOrg(manager, control, data)
		local ctrl = control.xpBar:GetControl()
		if not ctrl.label then
			ctrl:SetHeight(ctrl:GetHeight()+5)
			ctrl.label = WINDOW_MANAGER:CreateControlFromVirtual(ctrl:GetName().."HarvensLabel", ctrl, "HarvensImprovedSkillsWindowLabel")
			ctrl.label:SetAnchor(CENTER, ctrl, CENTER)
		end
		if not control.morphLabel then
			control.morphLabel = WINDOW_MANAGER:CreateControlFromVirtual(ctrl:GetName().."HarvensMorphLabel", ctrl, "HarvensImprovedSkillsWindowMorphLabel")
			control.morphLabel:SetAnchor(LEFT, control.nameLabel, RIGHT)
		end
		
		local skillData = data.skillData
		local skillPointAllocator = skillData:GetPointAllocator()
        local skillProgressionData = skillPointAllocator:GetProgressionData()
		
		if not skillData:IsPassive() then
			local hasprog, progId, lastXP, nextXP, currentXP, atMorph = GetAbilityProgressionXPInfoFromAbilityId(skillProgressionData:GetAbilityId())
			local name, morph = GetAbilityProgressionInfo(progId)
			if hasprog then
				control.progressionIndex = progId
			else
				control.progressionIndex = nil
			end
			
			if hasprog and morph > 0 then
				local orgText = control.nameLabel:GetText()
				control.morphLabel:SetHidden(false)
				control.morphLabel:SetText(" ("..zo_strformat("<<1>>", name)..")")
			else
				control.morphLabel:SetHidden(true)
			end
			
			if nextXP > 0 then
				local percent = string.format("%.2f", (currentXP-lastXP)/(nextXP-lastXP)*100 )
				local text = ""
				if HarvensImprovedSkillsWindow.sv.showDetails then
					text = currentXP-lastXP.."/"..nextXP-lastXP.." ("
				end
				text = text..percent.."%"
				if HarvensImprovedSkillsWindow.sv.showDetails then
					text = text..")"
				end
				ctrl.label:SetText(text)
				ctrl.label:SetHidden(false)
				ctrl:SetHandler("OnMouseEnter", HarvensImprovedSkillsWindow.AbilityOnMouseEnter)
				ctrl:SetHandler("OnMouseExit", HarvensImprovedSkillsWindow.AbilityOnMouseExit)
			else
				ctrl.label:SetHidden(true)
				ctrl:SetHandler("OnMouseEnter", nil)
				ctrl:SetHandler("OnMouseExit", nil)
			end
		else
			control.progressionIndex = nil
			ctrl.label:SetHidden(true)
			ctrl:SetHandler("OnMouseEnter", nil)
			ctrl:SetHandler("OnMouseExit", nil)
		end
	
		local a = control.increaseButton
		if skillPointAllocator:CanIncreaseRank() then
			a:SetHandler("OnMouseEnter", HarvensImprovedSkillsWindow.UpgradeAbilityOnMouseEnter)
			a:SetHandler("OnMouseExit", HarvensImprovedSkillsWindow.AbilityOnMouseExit)
		elseif not skillPointAllocator:CanMorph() then
			a:SetHandler("OnMouseEnter", HarvensImprovedSkillsWindow.AbilityOnMouseEnter)
			a:SetHandler("OnMouseExit", HarvensImprovedSkillsWindow.AbilityOnMouseExit)
		else
			a:SetHandler("OnMouseEnter", nil)
			a:SetHandler("OnMouseExit", nil)
		end
	end
	
	local RefreshSkillInfoOrg = SKILLS_WINDOW.RefreshSkillLineInfo
	SKILLS_WINDOW.RefreshSkillLineInfo = function(self, ...)
		local ctrl = self.skillInfo.xpBar:GetControl()
		if not ctrl.label then
			ctrl:SetHeight(ctrl:GetHeight()+3)
			ctrl.label = WINDOW_MANAGER:CreateControlFromVirtual(ctrl:GetName().."HarvensLabel", ctrl, "HarvensImprovedSkillsWindowLabel")
			ctrl.label:SetAnchor(CENTER, ctrl, CENTER)
		end
		
		local skillLineData = self:GetSelectedSkillLineData()
	    local skillType = skillLineData:GetSkillTypeData():GetSkillType()
	    local skillIndex = skillLineData:GetSkillLineIndex()
	    local lastXP, nextXP, currentXP = GetSkillLineXPInfo(skillType, skillIndex)
		local maxRank, startXP, nextStartXP = FindLineMaxRank(skillType, skillIndex)
		local _, lineRank = GetSkillLineInfo(skillType, skillIndex)
		if nextXP > 0 and nextXP > currentXP then
			local percent = 0
			if HarvensImprovedSkillsWindow.sv.showTotal and maxRank > 0 then
				percent = string.format("%.2f", (currentXP)/(nextStartXP)*100 )
			else
				percent = string.format("%.2f", (currentXP-lastXP)/(nextXP-lastXP)*100 )
			end
			local text = ""
			
			if HarvensImprovedSkillsWindow.sv.showDetails then
				if HarvensImprovedSkillsWindow.sv.showTotal and maxRank > 0 then
					text = currentXP.."/"..nextStartXP.." ("
				else
					text = currentXP-lastXP.."/"..nextXP-lastXP.." ("
				end
			end
			text = text..percent.."%"
			if HarvensImprovedSkillsWindow.sv.showDetails then
				text = text..")"
			end
			ctrl.label:SetText(text)
			ctrl.label:SetHidden(false)
		else
			ctrl.label:SetHidden(true)
		end
		RefreshSkillInfoOrg(self, ...)
		if nextXP and HarvensImprovedSkillsWindow.sv.showTotal and maxRank > 0 then
			ZO_SkillInfoXPBar_SetValue(self.skillInfo.xpBar, lineRank, 0, nextStartXP, currentXP, false)
			ZO_SkillInfoXPBar_OnLevelChanged(self.skillInfo.xpBar, lineRank.."/"..maxRank)
		else
			ZO_SkillInfoXPBar_OnLevelChanged(self.skillInfo.xpBar, lineRank)
		end
	end	
end

EVENT_MANAGER:RegisterForEvent("HarvensImprovedSkillsWindowInitialize", EVENT_ADD_ON_LOADED, HarvensImprovedSkillsWindow.Initialize)