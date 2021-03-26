local GS = GetString
local cAct = {1, 1, 1}
local cInact = {0.21, 0.21, 0.21}
local cpIcInact = {0.21, 0.33, 0.63}

local errorColors = {
	CSPS.colTbl.white,	
	CSPS.colTbl.green,  
	CSPS.colTbl.red, 
	CSPS.colTbl.red, 
	CSPS.colTbl.orange, 
}
local errorColorsHex = {
	"ffffff", --white
	"19B319", --green
	"D61F1F", --red
	"D61F1F", --red
	"FF3D00", --orange
}
local cpColTex = {
		"esoui/art/champion/champion_points_stamina_icon-hud-32.dds",
		"esoui/art/champion/champion_points_magicka_icon-hud-32.dds",
		"esoui/art/champion/champion_points_health_icon-hud-32.dds",
	}

local cpSlT = {
		"esoui/art/champion/actionbar/champion_bar_world_selection.dds",
		"esoui/art/champion/actionbar/champion_bar_combat_selection.dds",
		"esoui/art/champion/actionbar/champion_bar_conditioning_selection.dds",
}
local getErrorCode = CSPS.getErrorCode


function CSPS.onToggleSektion(buttonControl, button)
	if button == MOUSE_BUTTON_INDEX_LEFT then
		local parentNode = buttonControl:GetParent().node
		if buttonControl.state == parentNode:IsOpen() then ZO_ToggleButton_Toggle(buttonControl) end
		parentNode:SetOpen(not parentNode:IsOpen(), USER_REQUESTED_OPEN)
		local myName = buttonControl:GetParent():GetNamedChild("Name") or parentNode:GetNamedChild("Text")
		if myName:GetText() == GS(CSPS_TxtCpNew) then 
			if parentNode:IsOpen() then 
				CSPSWindowCP2Bar:SetHidden(false)
			else
				CSPSWindowCP2Bar:SetHidden(true)
			end
		end
	end
end

local function showSimpleTT(control, ttInd)
	local myTTs = {
		GS(CSPS_Tooltiptext_PlusSk), 		-- 1
		GS(CSPS_Tooltiptext_MinusSk), 		-- 2
		GS(CSPS_Tooltiptext_MinusSkType), 	-- 3
		GS(CSPS_Tooltiptext_MinusSkLine),	-- 4
		GS(CSPS_Tooltiptext_PlusAttr),		-- 5
		GS(CSPS_Tooltiptext_MinusAttr),		-- 6
		GS(CSPS_Tooltiptext_PlusCP),		-- 7
		GS(CSPS_Tooltiptext_MinusCP),		-- 8
		}
	ZO_Tooltips_ShowTextTooltip(control, RIGHT, myTTs[ttInd])
end

local function showSkTT(control, i,j,k, morph, rank, errorCode)
	local myTooltip = GetAbilityDescription(GetSpecificSkillAbilityInfo(i,j,k, morph, rank))
	if errorCode > 0 then 
		myTooltip = string.format("%s\n\n|c%s%s|r", myTooltip, errorColorsHex[errorCode + 1], CSPS.skillErrors[errorCode])
	end	
	ZO_Tooltips_ShowTextTooltip(control, RIGHT, myTooltip)
end

local function showSkIconTT(control)
	
end

function CSPS.NodeSetup(node, control, data, open, userRequested, enabled)
	local i = data[1]
	local j = data[2]
	local k = data[3]
	local mySkill = CSPS.skillTable[i][j][2][k]
	--Entries: [1]Name [2]Texture [3] Rank [4]Progression [5]Purchased [6]Morph [7] Points [8] Auxlistindex [9] MaxRank/Morph [10] Errorcode
	
	local myCtrIcon = control:GetNamedChild("Icon")
	local myCtrText = control:GetNamedChild("Text")
	local myCtrPoints = control:GetNamedChild("Points")
	local myCtrMorph = control:GetNamedChild("Morph")
	local myCtrBtnPlus = control:GetNamedChild("BtnPlus")
	local myCtrBtnMinus = control:GetNamedChild("BtnMinus")
	
	local morphText = "placeholder"
	if mySkill[6] then
		morphText = zo_strformat(GS(CSPS_MORPH), mySkill[6])
			
		myCtrIcon:SetMouseEnabled(true)
		myCtrIcon:SetHandler("OnMouseUp", function(self, mouseButton, upInside) WINDOW_MANAGER:SetMouseCursor(0) end)
		myCtrIcon:SetHandler("OnDragStart", 
			function(self, button) 
				 WINDOW_MANAGER:SetMouseCursor(15)
				 CSPS.onSkillDrag(i, j, k)
			end)
	else
		morphText = string.format(GS(CSPS_MyRank), mySkill[3])
		myCtrIcon:SetMouseEnabled(false)
		myCtrIcon:SetHandler("OnMouseUp", function()  end)
	end
	if mySkill[7] then -- points invested in this skill
		 myCtrPoints:SetText(string.format("(%s)", mySkill[7]))
	end
	local myErrorCode = getErrorCode(i, j, k, mySkill[6], mySkill[3])
	myCtrBtnMinus:SetHidden(true)
	myCtrBtnPlus:SetHidden(true)
	myCtrPoints:SetHidden(true)
	local colR, colG, colB = 1, 1, 1
	colR, colG, colB = errorColors[myErrorCode + 1][1], errorColors[myErrorCode + 1][2], errorColors[myErrorCode + 1][3]
	
	myCtrText:SetMouseEnabled(true)
	myCtrText:SetHandler("OnMouseEnter", function() showSkTT(myCtrText, i, j, k, mySkill[6], mySkill[3], myErrorCode) end)
	myCtrText:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
	
	if not mySkill[5] then 
		myCtrText:SetColor(cInact[1], cInact[2], cInact[3])
		myCtrIcon:SetDesaturation(1)
		myCtrMorph:SetHidden(true)
		myCtrBtnPlus:SetHidden(false)
		myCtrBtnPlus:SetHandler("OnClicked", function() CSPS.plusClickSkill(i, j, k) end)
		myCtrBtnPlus:SetHandler("OnMouseEnter", function() showSimpleTT(myCtrBtnPlus, 1) end)
		myCtrBtnPlus:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
	else 
		myCtrText:SetColor(colR, colG, colB)
		myCtrIcon:SetDesaturation(0)
		myCtrMorph:SetHidden(false)
		if mySkill[7] > 0 then
			myCtrBtnMinus:SetHidden(false)
			myCtrBtnMinus:SetHandler("OnClicked", function() CSPS.minusClickSkill(i, j, k) end)
			myCtrBtnMinus:SetHandler("OnMouseEnter", function() showSimpleTT(myCtrBtnMinus, 2) end)
			myCtrBtnMinus:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
			myCtrPoints:SetHidden(false)
		end
		if not mySkill[9] then
			myCtrBtnPlus:SetHidden(false)
			myCtrBtnPlus:SetHandler("OnClicked", function() CSPS.plusClickSkill(i, j, k) end)
			myCtrBtnPlus:SetHandler("OnMouseEnter", function() showSimpleTT(myCtrBtnPlus, 1) end)
			myCtrBtnPlus:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
		end
	end	
	myCtrIcon:SetTexture(mySkill[2])
    myCtrText:SetText(mySkill[1])
	myCtrMorph:SetText(morphText)
end

function CSPS.NodeSetupAttr(node, control, data, open, userRequested, enabled)
	--Entries in data: Text, Value, Farbe
  local myText = data.name
  local myCtrText = control:GetNamedChild("Text")
  local myCtrValue = control:GetNamedChild("Value")
  local myCtrBtnPlus = control:GetNamedChild("BtnPlus")
  local myCtrBtnMinus = control:GetNamedChild("BtnMinus")
  myCtrText:SetText(myText)
  myCtrValue:SetText(CSPS.attrPoints[data.i])
  myCtrBtnMinus:SetHidden(CSPS.attrPoints[data.i] == 0)
  myCtrBtnPlus:SetHidden(CSPS.attrPoints[1] + CSPS.attrPoints[2] + CSPS.attrPoints[3] >= CSPS.attrSum())
  myCtrBtnMinus:SetHandler("OnClicked", function(_,_,_,_,shift) CSPS.attrBtnPlusMinus(data.i, -1, shift) end)
  myCtrBtnPlus:SetHandler("OnClicked", function(_,_,_,_,shift) CSPS.attrBtnPlusMinus(data.i, 1, shift) end)
  myCtrBtnPlus:SetHandler("OnMouseEnter", function() showSimpleTT(control:GetNamedChild("BtnPlus"), 5) end)
  myCtrBtnPlus:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
  myCtrBtnMinus:SetHandler("OnMouseEnter", function()showSimpleTT(control:GetNamedChild("BtnMinus"), 6) end)
  myCtrBtnMinus:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
  if CSPS.applyAttr or (not CSPS.showApply) then 
	myCtrText:SetColor(data.farbe[1]/255, data.farbe[2]/255, data.farbe[3]/255)
	myCtrValue:SetColor(data.farbe[1]/255, data.farbe[2]/255, data.farbe[3]/255)
  else	
	myCtrText:SetColor(cInact[1], cInact[2], cInact[3])
	myCtrValue:SetColor(cInact[1], cInact[2], cInact[3])
  end
end

function CSPS.NodeSetupCP(node, control, data, open, userRequested, enabled)
	--Einträge: [1]Name 
	local myText = data.name
    control:GetNamedChild("Text"):SetText(myText)
	control:GetNamedChild("Value"):SetText(CSPS.cpTable[data.i][data.j])
	
  if (CSPS.applyCP and CSPS.unlockedCP) or (not CSPS.showApply)  then 
	control:GetNamedChild("Text"):SetColor(data.farbe[1]/255, data.farbe[2]/255, data.farbe[3]/255)
	control:GetNamedChild("Value"):SetColor(data.farbe[1]/255, data.farbe[2]/255, data.farbe[3]/255)
  else	
	control:GetNamedChild("Text"):SetColor(cInact[1], cInact[2], cInact[3])
	control:GetNamedChild("Value"):SetColor(cInact[1], cInact[2], cInact[3])
  end
end

function CSPS.NodeSectionSetup(node, control, data, open, userRequested, enabled)
    local myText = data.name
	local myCtrText = control:GetNamedChild("Name")
	local myCtrBtnMinus = control:GetNamedChild("BtnMinus")
	if data.variant == 1 then -- Skill type
		myText = string.format("%s (%s)", myText, CSPS.skTypeCountPT[data.i])
		if CSPS.applySk or (not CSPS.showApply) then 
			myCtrText:SetColor(cAct[1], cAct[2], cAct[3])
			if CSPS.kOra[data.i][42] == true then myCtrText:SetColor(CSPS.colTbl.orange[1], CSPS.colTbl.orange[2], CSPS.colTbl.orange[3]) end
			if CSPS.kRed[data.i][42] == true then myCtrText:SetColor(CSPS.colTbl.red[1], CSPS.colTbl.red[2], CSPS.colTbl.red[3]) end
		else
			myCtrText:SetColor(cInact[1], cInact[2], cInact[3])
		end
		if CSPS.skTypeCountPT[data.i] > 0 and node:IsOpen() then 
			myCtrBtnMinus:SetHidden(false)
			myCtrBtnMinus:SetHandler("OnClicked", function() CSPS.minusClickSkillLine(data.i) end)
			myCtrBtnMinus:SetHandler("OnMouseEnter", function() showSimpleTT(myCtrBtnMinus, 3) end)
			myCtrBtnMinus:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
		else
			myCtrBtnMinus:SetHidden(true)
		end
	end
	if data.variant == 2 then -- Skill line
		myText = string.format("%s (%s)", myText, CSPS.skLineCountPT[data.i][data.j])
		if CSPS.applySk or (not CSPS.showApply) then 
			myCtrText:SetColor(cAct[1], cAct[2], cAct[3])
			if CSPS.kOra[data.i][data.j] == true then myCtrText:SetColor(CSPS.colTbl.orange[1], CSPS.colTbl.orange[2], CSPS.colTbl.orange[3]) end
			if CSPS.kRed[data.i][data.j] == true then myCtrText:SetColor(CSPS.colTbl.red[1], CSPS.colTbl.red[2], CSPS.colTbl.red[3]) end
		else
			myCtrText:SetColor(cInact[1], cInact[2], cInact[3])
		end
		if CSPS.skLineCountPT[data.i][data.j] > 0 and node:IsOpen() then 
			myCtrBtnMinus:SetHandler("OnClicked", function()  CSPS.minusClickSkillLine(data.i, data.j) end)
			myCtrBtnMinus:SetHandler("OnMouseEnter", function() showSimpleTT(myCtrBtnMinus, 4) end)
			myCtrBtnMinus:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
			myCtrBtnMinus:SetHidden(false) 
		else	
			myCtrBtnMinus:SetHidden(true) 
		end
	end
	if data.variant == 3 then -- Skill over section
		if CSPS.applySk  or (not CSPS.showApply) then 
			myCtrText:SetColor(cAct[1], cAct[2], cAct[3])
		else
			myCtrText:SetColor(cInact[1], cInact[2], cInact[3])
		end
	end
	if data.variant == 4 then -- cp2 over section
		CSPS.cp2ParentTreeSection = control
		if (CSPS.applyCP and CSPS.unlockedCP)  or (not CSPS.showApply) then 
			myCtrText:SetColor(cAct[1], cAct[2], cAct[3])
		else
			myCtrText:SetColor(cInact[1], cInact[2], cInact[3])
		end
	end
	if data.variant == 5 then -- old cp over section
		if CSPS.showOldCP == true and CSPS.unlockedCP == true then 
			control:SetHidden(false) 
		else 
			control:SetHidden(true) 
			if control.node:IsOpen() then CSPS.onToggleSektion(control:GetNamedChild("Toggle"), MOUSE_BUTTON_INDEX_LEFT) end
		end
		if (CSPS.applyCP and CSPS.unlockedCP)  or (not CSPS.showApply) then 
			myCtrText:SetColor(cAct[1], cAct[2], cAct[3])
		else
			myCtrText:SetColor(cInact[1], cInact[2], cInact[3])
		end
	end
	if data.variant == 6 then -- attributes over section
		if CSPS.applyAttr or (not CSPS.showApply) then 
			myCtrText:SetColor(cAct[1], cAct[2], cAct[3])
		else
			myCtrText:SetColor(cInact[1], cInact[2], cInact[3])
		end
	end
	if data.variant == 7 then -- old CP color section
		myText = string.format("%s (%s)", myText, CSPS.cpColorSum[data.i])
		if (CSPS.applyCP and CSPS.unlockedCP) or (not CSPS.showApply) then 
			myCtrText:SetColor(data.farbe[1]/255, data.farbe[2]/255, data.farbe[3]/255)
		else
			myCtrText:SetColor(cInact[1], cInact[2], cInact[3])
		end
	end
	if data.variant == 8 then -- old cp categories
		myText = string.format("%s (%s)", myText, CSPS.cpStarSum[data.i])
		if (CSPS.applyCP and CSPS.unlockedCP) or (not CSPS.showApply) then 
			myCtrText:SetColor(data.farbe[1]/255, data.farbe[2]/255, data.farbe[3]/255)
		else
			myCtrText:SetColor(cInact[1], cInact[2], cInact[3])	
		end
	end
	myCtrText:SetText(myText)
end

function CSPS.NodeSetupCP2Discipline(node, control, data, open, userRequested, enabled) -- cp section (2.0)
	local myText = data.name
	myText = string.format("%s (%s/%s)", myText, CSPS.cp2ColorSum[data.i], GetNumSpentChampionPoints(GetChampionDisciplineId(data.i)) + GetNumUnspentChampionPoints(GetChampionDisciplineId(data.i))) -- CSPS.cpColorSum[data.i] instead of ""
	if (CSPS.applyCPc[data.i] and CSPS.unlockedCP) or (not CSPS.showApply) then 
		control:GetNamedChild("Name"):SetColor(data.farbe[1]/255, data.farbe[2]/255, data.farbe[3]/255)
	else
		control:GetNamedChild("Name"):SetColor(cInact[1], cInact[2], cInact[3])
	end
	control:GetNamedChild("Name"):SetText(myText)
end

function CSPS.NodeSetupCP2Cluster(node, control, data, open, userRequested, enabled)
	local myId = data.skId
	local mySum =  CSPS.cp2ClusterSum[myId] or 0
	local myText = zo_strformat("<<C:1>> (<<2>>)", CSPS.cp2ClustNames[myId], mySum)
	CSPS.cp2ClusterControls[myId] = control
	control:GetNamedChild("Name"):SetText(myText)
	control:GetNamedChild("Marker"):SetCenterColor(data.farbe[1]/255, data.farbe[2]/255, data.farbe[3]/255, 0.25)
	control:GetNamedChild("Marker"):SetEdgeColor(data.farbe[1]/255, data.farbe[2]/255, data.farbe[3]/255, 0)
	if CSPS.cp2ClustActive[myId] == false then
		control:GetNamedChild("Name"):SetColor(cInact[1], cInact[2], cInact[3])
	else
		control:GetNamedChild("Name"):SetColor(cAct[1], cAct[2], cAct[3])
	end
end

local function markLinkNodes(idList, arg)
	for _, v in pairs(idList) do
		if CSPS.cp2ClustRoots[v] ~= nil then
			local myMark2 = CSPS.cp2ClusterControls[CSPS.cp2ClustRoots[v]]:GetNamedChild("Marker")
			if myMark2 ~= nil then myMark2:SetHidden(not arg) end
		end
		local myMark = CSPS.cp2Controls[v]:GetNamedChild("Marker")
		if myMark ~= nil then myMark:SetHidden(not arg) end
	end
end

function CSPS.NodeSetupCP2Entry(node, control, data, open, userRequested, enabled)
	--data: farbe = , i=discplineIndex, j=j,  skId, skType (and l if clusterentry)	
	local myId = data.skId
	local myValue = CSPS.cp2Table[myId][2]
	local myMax = GetChampionSkillMaxPoints(myId)
	local myValPercent = myValue / myMax
	local isUnlocked = CSPS.cp2Table[myId][1]
	local myCtrText = control:GetNamedChild("Name")
	local myCtrValue = control:GetNamedChild("Value")
	local myCtrMarker = control:GetNamedChild("Marker")
	local myCtrProgress = control:GetNamedChild("Progress")
	local myCtrIcon = control:GetNamedChild("Icon")
	local myCtrCircle = control:GetNamedChild("Circle")
	local myCtrBtnPlus = control:GetNamedChild("BtnPlus")
	local myCtrBtnMinus = control:GetNamedChild("BtnMinus")
	myCtrValue:SetText(myValue)
	if myValPercent <= 1 then myCtrProgress:SetWidth(76 * myValPercent) else myCtrProgress:SetWidth(76) end
	
	if not CSPS.cp2Controls[myId] then	
		local myText = zo_strformat("<<C:1>>", GetChampionSkillName(myId))
		if CSPS.showCpIds then myText = zo_strformat("<<C:1>>(<<2>>)", GetChampionSkillName(myId), myId) end
		myCtrText:SetText(myText)
		myCtrMarker:SetCenterColor(data.farbe[1]/255, data.farbe[2]/255, data.farbe[3]/255, 0.4)
		myCtrMarker:SetEdgeColor(data.farbe[1]/255, data.farbe[2]/255, data.farbe[3]/255, 0)
		myCtrProgress:SetColor(data.farbe[1]/255, data.farbe[2]/255, data.farbe[3]/255, 0.4)
		if DoesChampionSkillHaveJumpPoints(myId) then
			for i, v in pairs({GetChampionSkillJumpPoints(myId)}) do
				local xPos = v/myMax * 76
				local newCtrName = string.format("CSPSWindowElem%sProgLine%s", myId, i)
				local l = 0
				if WINDOW_MANAGER:GetControlByName(newCtrName) ~= nil then 
					l = WINDOW_MANAGER:GetControlByName(newCtrName) 
				else
					l =  WINDOW_MANAGER:CreateControl(newCtrName, control, CT_TEXTURE)
				end
				l:SetAnchor(TOP, myCtrProgress, TOPLEFT, xPos, 1)
				l:SetColor(0.66,0.66,0.66)
				l:SetDimensions(1, 14)
				
			end
		end
		if data.l ~= nil then
			myCtrText:SetWidth(260)
			myCtrMarker:SetWidth(260)
		end
		CSPS.cp2Nodes[myId] = node
		CSPS.cp2Controls[myId] = control
	end
	if DoesChampionSkillHaveJumpPoints(myId) then
		for i, v in pairs({GetChampionSkillJumpPoints(myId)}) do
			local l =  WINDOW_MANAGER:GetControlByName(string.format("CSPSWindowElem%sProgLine%s", myId, i))
			if i > 1 then
				if v > myValue or myValue == 0 then 
					l:SetColor(0.66,0.66,0.66) 
					l:SetWidth(1)
				else 
					l:SetColor(1,0.8,0) 
					l:SetWidth(3)
				end
			end
		end	
	end
	myCtrValue:SetMouseEnabled(true)
	myCtrValue:SetHandler("OnMouseEnter", function() CSPS.showCpTT(myCtrValue, myId, myValue) end)
	myCtrValue:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
	control:GetNamedChild("ProgBg"):SetMouseEnabled(true)
	control:GetNamedChild("ProgBg"):SetHandler("OnMouseEnter", function() CSPS.showCpTT(myCtrValue, myId, myValue) end)
	control:GetNamedChild("ProgBg"):SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
	myCtrText:SetHandler("OnMouseEnter", 
		function() 
			if data.skType ~= 3 then
				markLinkNodes({myId, GetChampionSkillLinkIds(myId)}, true)
			end
			CSPS.showCpTT(myCtrText, myId, myValue)
		end)
	myCtrText:SetHandler("OnMouseExit", 
		function() 
			if data.skType ~= 3 then
				markLinkNodes({myId, GetChampionSkillLinkIds(myId)}, false)
			end
			ZO_Tooltips_HideTextTooltip() 
		end)
	if data.skType ~= 3 then
		myCtrBtnPlus:SetHandler("OnMouseEnter", 
			function() 
				markLinkNodes({myId, GetChampionSkillLinkIds(myId)}, true)  
				showSimpleTT(myCtrBtnPlus, 7)
			end)
		myCtrBtnPlus:SetHandler("OnMouseExit", 
			function() 
				markLinkNodes({myId, GetChampionSkillLinkIds(myId)}, false) 
				ZO_Tooltips_HideTextTooltip()
			end)
	else
		myCtrBtnPlus:SetHandler("OnMouseEnter", function() showSimpleTT(myCtrBtnPlus, 7) end)
		myCtrBtnPlus:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
	end
	myCtrBtnMinus:SetHandler("OnMouseEnter", function() showSimpleTT(myCtrBtnMinus, 8) end)
	myCtrBtnMinus:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
	local inCol = cpIcInact[data.i]
	if data.skType == 1  then
		myCtrIcon:SetTexture(cpColTex[data.i])
		myCtrIcon:SetColor(1,1,1)
	else 
		myCtrIcon:SetTexture("esoui/art/champion/champion_icon_32.dds")
		myCtrIcon:SetTextureCoords(-0.1,1.1,-0.1,1.1)
		myCtrIcon:SetColor(CSPS.cp2ColorsA[data.i][1], CSPS.cp2ColorsA[data.i][2], CSPS.cp2ColorsA[data.i][3])
		myCtrIcon:SetMouseEnabled(true)
		myCtrIcon:SetHandler("OnMouseUp", function(self, mouseButton, upInside) WINDOW_MANAGER:SetMouseCursor(0) if upInside then CSPS.clickCPIcon(myId, mouseButton) end end)
		myCtrIcon:SetHandler("OnDragStart", 
			function(self, button) 
				 WINDOW_MANAGER:SetMouseCursor(15)
				 CSPS.onCpDrag(myId, data.i)
			end)
		inCol = cpIcInact[1]
	end
	if isUnlocked == false then
		myCtrIcon:SetDesaturation(1)
		myCtrIcon:SetColor(inCol, inCol, inCol)		
		myCtrText:SetColor(cInact[1], cInact[2], cInact[3])
		myCtrValue:SetColor(cInact[1], cInact[2], cInact[3])
		myCtrBtnMinus:SetHidden(true)
		myCtrBtnPlus:SetHidden(true)
		myCtrCircle:SetHidden(true)		
	else
		if CSPS.cp2InHb[myId] == true then
			myCtrIcon:SetDesaturation(0)
			myCtrIcon:SetColor(1,1,1)
			myCtrCircle:SetHidden(false)
			myCtrCircle:SetTexture(cpSlT[data.i])
			if data.i == 1 then myCtrCircle:SetColor(0.8235, 0.8235, 0) end	-- re-color the not-so-green circle for the green cp...
		else
			myCtrIcon:SetDesaturation(0)
			myCtrCircle:SetHidden(true)			
		end
		myCtrIcon:SetDesaturation(0)
		myCtrText:SetColor(cAct[1], cAct[2], cAct[3])
		myCtrValue:SetColor(cAct[1], cAct[2], cAct[3])
		if myValue < GetChampionSkillMaxPoints(myId) then 
			myCtrBtnPlus:SetHidden(false)
		else
			myCtrBtnPlus:SetHidden(true)
		end
		if myValue > 0 then 
			myCtrBtnMinus:SetHidden(false)
		else
			myCtrBtnMinus:SetHidden(true)
		end
	end
	myCtrText:SetHandler("OnMouseUp", function(upInside, mouseButton) if upInside then CSPS.cpClicked(myId, mouseButton) end end)
	myCtrBtnPlus:SetHandler("OnClicked", function(_,_,_,_,shift) CSPS.cp2BtnPlusMinus(data.skId, 1, shift) end)
	myCtrBtnMinus:SetHandler("OnClicked", function(_,_,_,_,shift) CSPS.cp2BtnPlusMinus(data.skId, -1, shift) end)
	
end

function CSPS.treeBereit()
	local scrollContainer = CSPSWindow:GetNamedChild("ScrollList")
	CSPS.myTree = ZO_Tree:New(scrollContainer:GetNamedChild("ScrollChild"), 24, 0, 2000)
	CSPS.myTree:AddTemplate("CSPSLE", CSPS.NodeSetup, nil, nil, 24, 0)
	CSPS.myTree:AddTemplate("CSPSLCP", CSPS.NodeSetupCP, nil, nil, 24, 0)
	CSPS.myTree:AddTemplate("CSPSLATTR", CSPS.NodeSetupAttr, nil, nil, 24, 0)
	CSPS.myTree:AddTemplate("CSPSLH", CSPS.NodeSectionSetup, nil, nil, 24, 0)

	CSPS.myTree:AddTemplate("CSPSCP2HB", CSPS.NodeSetupCP2Discipline, nil, nil, 24, 0)
	CSPS.myTree:AddTemplate("CSPSCP2CL", CSPS.NodeSetupCP2Cluster, nil, nil, 24, 0)
	CSPS.myTree:AddTemplate("CSPSCP2L", CSPS.NodeSetupCP2Entry, nil, nil, 24, 0)

	CSPS.myTree:RefreshVisible() 
end

function CSPS.createTable(onlyHalf)
	if CSPS.tabExHalf == true then
		CSPS.myTree:Reset()
	end
	-- Generate tree for skills
	if not onlyHalf then
		local overnode = CSPS.myTree:AddNode("CSPSLH", {name = GS(SI_CHARACTER_MENU_SKILLS), variant=3})
		for i, v in pairs(CSPS.skillTable) do
			local nodeoversection = CSPS.myTree:AddNode("CSPSLH", {name = CSPS.skillTypeNames[i], variant = 1, i=i}, overnode)
			for j, w in pairs(v) do
				if not (i == 6 and j == CSPS.kaiserFranz) then
					local nodesection = CSPS.myTree:AddNode("CSPSLH", {name = w[1], variant = 2, i=i, j=j}, nodeoversection)
					for k, mySkill in pairs(w[2]) do
						local node = CSPS.myTree:AddNode("CSPSLE", {i, j, k}, nodesection)
					end
				end
			end
		end
	

		-- Generate tree for attribute points
		local overnode = CSPS.myTree:AddNode("CSPSLH", {name = GS(SI_STATS_ATTRIBUTES), variant=6})
		local node = CSPS.myTree:AddNode("CSPSLATTR", {name = GS(SI_ATTRIBUTES1), i=1, farbe=CSPS.cpColors[2]}, overnode)
		local node = CSPS.myTree:AddNode("CSPSLATTR", {name = GS(SI_ATTRIBUTES2), i=2, farbe=CSPS.cpColors[1]}, overnode)
		local node = CSPS.myTree:AddNode("CSPSLATTR", {name = GS(SI_ATTRIBUTES3), i=3, farbe=CSPS.cpColors[3]}, overnode)
	
	end
	
		-- Generate tree for new CP 2.0	
	if CSPS.unlockedCP then
		local overnode = CSPS.myTree:AddNode("CSPSLH", {name = GS(CSPS_TxtCpNew), variant=4})
		local cp2Table = CSPS.cp2Table
		local changeOrder = {2,3,1}
		for auxId = 1, 3 do
			local discplineIndex = changeOrder[auxId]
			local myColor = CSPS.cp2Colors[discplineIndex]
			local discplineId = GetChampionDisciplineId(discplineIndex) 
			local nodeoversection = CSPS.myTree:AddNode("CSPSCP2HB", {name = zo_strformat("<<C:1>>", GetChampionDisciplineName(discplineId)), farbe = myColor, i=discplineIndex}, overnode)
			local cpSubList = CSPS.cp2List[discplineIndex]		
			for j, v in pairs(cpSubList) do
				if v[2] == 4 then
					local clusternode = CSPS.myTree:AddNode("CSPSCP2CL", {farbe = myColor, i=discplineIndex,  j=j,  skId=v[1]}, nodeoversection)			
					for l, w in pairs(CSPS.cp2ListCluster[v[1]]) do
						local node = CSPS.myTree:AddNode("CSPSCP2L", {farbe = myColor, i=discplineIndex,  j=j, l=l, skId=w[1], skType=w[2]}, clusternode)			
					end
				else
					local node = CSPS.myTree:AddNode("CSPSCP2L", {farbe = myColor, i=discplineIndex, j=j,  skId=v[1], skType=v[2]}, nodeoversection)			
				end
				
			end
		end
	end
	
	-- Generate tree for (old) CP
	local overnode = CSPS.myTree:AddNode("CSPSLH", {name = GS(CSPS_TxtCpOld), variant=5})
	local cpIndex = 7
	local CP_Kat = {GS(CSPS_CP_BLUE), GS(CSPS_CP_RED), GS(CSPS_CP_GREEN)}
	for i=1, 3 do
		local myColor = CSPS.cpColors[i]
		local nodeoversection = CSPS.myTree:AddNode("CSPSLH", {name = CP_Kat[i], farbe = myColor, variant = 7, i=i}, overnode)
		for j=1, 3 do
			local nodesection = CSPS.myTree:AddNode("CSPSLH", {name = GS("CSPS_oldCPStar", cpIndex), farbe = myColor, variant = 8, i=cpIndex}, nodeoversection)
			for k=1, 4  do
				local node = CSPS.myTree:AddNode("CSPSLCP", {name = GS("CSPS_oldCPSkill", (cpIndex-1)*4+k), farbe = myColor, i=cpIndex, j=k} , nodesection)
			end
			cpIndex = cpIndex - 1
			if cpIndex == 0 then cpIndex = 9 end
		end
	end
	
	if onlyHalf then 
		CSPS.tabExHalf = true
	else
		CSPS.tabEx = true
		CSPS.tabExHalf = false
	end
end