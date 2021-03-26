local CSPSAG = nil 
local CSPSDR = nil 
local currentGroup = 1
local groupSlots = {}
local GS = GetString
local bindingMode = 0
local bindingGroup = 0
local bindingSet = 0
local drRoles = false
local myGroupRole = 1
local bindingsDR = {}
local bindingsDRbyRole = {}
local bindingsAG = {}
local bindingsLOC = {}
local bindingNames = {}

local isTrial = {
	[636] = true, -- HRC,
	[638] = true, -- AA,
	[639] = true, -- SO,
	[725] = true, -- MoL,
	[975] = true, -- HoF,
	[1000] = true, -- AS,
	[1051] = true, -- CR,
	[1121] = true, -- SS,
	[1196] = true, -- KA,
}

local is1Arena = {
	[677] = true, -- MA,
	[1227] = true, -- VH,
}

local is4Arena = {
	[635] = true, -- DSA,
	[1082] = true, -- BRP,
}

function CSPS.groupSlotInit(control)
	local myDiscipline = tonumber(string.sub(control:GetParent():GetName(), -1, -1))
	if not myDiscipline then return end
	local myNumber = tonumber(string.sub(control:GetName(), -1, -1))
	groupSlots[myDiscipline] = groupSlots[myDiscipline] or {}
	groupSlots[myDiscipline][myNumber] = control
	local cpSlT = {
		"esoui/art/champion/actionbar/champion_bar_world_selection.dds",
		"esoui/art/champion/actionbar/champion_bar_combat_selection.dds",
		"esoui/art/champion/actionbar/champion_bar_conditioning_selection.dds",
	}
	local myCircle = control:GetNamedChild("Circle")
	myCircle:SetTexture(cpSlT[myDiscipline])
	if myDiscipline == 1 then myCircle:SetColor(0.8235, 0.8235, 0) end	-- re-color the not-so-green circle for the green cp...
end

local function selectProfile(myDiscipline, myProfile)
	if not myDiscipline then return end
	if myProfile == -1 then myProfile = nil end
	CSPS.cp2hbpHotkeys[currentGroup][myDiscipline] = myProfile
	CSPS.currentCharData.cp2hbpHotkeys = CSPS.cp2hbpHotkeys
	CSPS.barManagerRefreshGroup()
end

function CSPS.updatePrCombo(myDiscipline)
	if not myDiscipline then return end
	local myControl = WINDOW_MANAGER:GetControlByName(string.format("CSPSWindowManageBarsDisc%sProfiles", myDiscipline))

	myControl.comboBox = myControl.comboBox or ZO_ComboBox_ObjectFromContainer(myControl)
	local myComboBox = myControl.comboBox
	myComboBox:ClearItems()
	local choices = {["0) - "] = -1}
	
	for i, v in pairs(CSPS.currentCharData.cpHbProfiles) do
		local myName = string.format("%s) %s", i, v.name)
		if v.discipline == myDiscipline then choices[myName] = i end
	end
	
	local function OnItemSelect(ab, choiceText, choice)
		local myProfile = choices[choiceText] or nil
		selectProfile(myDiscipline, myProfile)
		PlaySound(SOUNDS.POSITIVE_CLICK)
	end

	myComboBox:SetSortsItems(true)
	local currentProfile = CSPS.cp2hbpHotkeys[currentGroup][myDiscipline]
	for i,j in pairs(choices) do
		myComboBox:AddItem(myComboBox:CreateItemEntry(i, OnItemSelect))
		if currentProfile == j then
			myComboBox:SetSelectedItem(i)
		end
	end
end

local function fillPrCombo(myDiscipline)
	if not myDiscipline then return end
	local myControl = WINDOW_MANAGER:GetControlByName(string.format("CSPSWindowManageBarsDisc%sProfiles", myDiscipline))
	-- tooltip 
	myControl.data = {tooltipText = "Select a bar profile"}
	myControl:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
	myControl:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)
	
	CSPS.updatePrCombo(myDiscipline)
end

function CSPS.barManagerRefreshGroup()
	CSPS.cpKbList:RefreshData()	
	CSPSWindowManageBarsGroup:SetText(string.format(GS(CSPS_CPBar_GroupHeading), currentGroup, 20))
	local layIdx, catIdx, actIdx = GetActionIndicesFromName("CSPS_CPHK"..currentGroup)
	local myKeyText = "-"
	if layIdx and catIdx and actIdx then 
		local keyCode, mod1, mod2, mod3, mod4 = GetActionBindingInfo(layIdx, catIdx, actIdx, 1)
		if keyCode > 0 then 
			myKeyText = ZO_Keybindings_GetBindingStringFromKeys(keyCode, mod1, mod2, mod3, mod4)
		end
	end
	CSPSWindowManageBarsKeybind:SetText(string.format(GS(CSPS_CPBar_GroupKeybind), myKeyText))
	local myGroup = CSPS.cp2hbpHotkeys[currentGroup]
	for i=1, 3 do
		local discGroup = myGroup[i] or {}
		local myProfile = CSPS.currentCharData.cpHbProfiles[discGroup]
		if myProfile ~= nil then
			groupSlots[i][1]:GetParent():GetNamedChild("Profiles").comboBox:SetSelectedItem(myProfile.name)
			local myHb = {SplitString(",", myProfile["hbComp"])}
			for j=1,4 do
				if myHb[j] ~= "-" then	
					groupSlots[i][j]:GetNamedChild("Icon"):SetHidden(false)
					groupSlots[i][j]:GetNamedChild("Label"):SetText(zo_strformat("<<C:1>>", GetChampionSkillName(tonumber(myHb[j]))))
				else
					groupSlots[i][j]:GetNamedChild("Icon"):SetHidden(true)
					groupSlots[i][j]:GetNamedChild("Label"):SetText("-")
				end
			end
		else
			groupSlots[i][1]:GetParent():GetNamedChild("Profiles").comboBox:SetSelectedItem("")
			for j=1,4 do
				groupSlots[i][j]:GetNamedChild("Icon"):SetHidden(true)
				groupSlots[i][j]:GetNamedChild("Label"):SetText("-")
			end
		end	
	end
end

function CSPS.prevGroup()
	currentGroup = currentGroup - 1
	currentGroup = currentGroup > 0 and currentGroup or 20
	CSPS.barManagerRefreshGroup()
end

function CSPS.nextGroup()
	currentGroup = currentGroup + 1
	currentGroup = currentGroup < 21 and currentGroup or 1
	CSPS.barManagerRefreshGroup()
end

function CSPS.groupApply(myGroupId)
	local myGroupId = myGroupId or currentGroup
	local hotbarsOnly = {false, false, false}
	local myGroup = CSPS.cp2hbpHotkeys[myGroupId]
	local anyChanges = false
	local needToApply = false
	local currentHotbar = {}
	for i=1, 12 do		
		local mySk = GetSlotBoundId(i, HOTBAR_CATEGORY_CHAMPION)
		if mySk ~= nil then currentHotbar[mySk] = true end
	end
	for i=1, 3 do
		if myGroup[i] ~= nil then
			local myProfile = CSPS.currentCharData.cpHbProfiles[myGroup[i]]
			hotbarsOnly[i] = true
			anyChanges = true
			local hbComp = myProfile["hbComp"]
			CSPS.cp2HbTable[i] = CSPS.cp2SingleBarExtract(hbComp)
			for j, w in pairs(CSPS.cp2HbTable[i]) do
				if not currentHotbar[w] then needToApply = true end
			end
			CSPS.cp2HbIcons(i)
		end
	end
	if not anyChanges then return end
	CSPS.cp2UpdateHbMarks()
	CSPS.unsavedChanges = true
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	CSPS.myTree:RefreshVisible()
	if needToApply then CSPS.cp2ApplyConfirm(false, hotbarsOnly) end
	for i=1, 3 do
		CSPS.cp2ReCheckHotbar(i)
	end
end

local function selectBindingGroup(myGroup, myName)
	if bindingMode == 0 or myGroup == nil or myGroup == 0 then return end
	bindingGroup = myGroup
	bindingNames[2] = myName
	CSPSWindowManageBarsAddBind:SetHidden(true)
	CSPS.updateBindingGroupCombo(2)
end

local function selectBindingSet(mySet, myName)
	bindingSet = mySet
	bindingNames[3] = myName
	CSPSWindowManageBarsAddBind:SetHidden(false)
	CSPSWindowManageBarsAddBind:SetHandler("OnMouseEnter", function() ZO_Tooltips_ShowTextTooltip(CSPSWindowManageBarsAddBind, RIGHT, GS("CSPS_Tooltip_AddBind", bindingMode)) end)
	CSPSWindowManageBarsAddBind:SetHandler("OnMouseExit", function () ZO_Tooltips_HideTextTooltip() end)
	
end

function CSPS.updateBindingGroupCombo(myLevel)
	if bindingMode == 0 or myLevel == nil then return end
	local ctrNames = {"CSPSWindowManageBarsSubProfiles", "CSPSWindowManageBarsSubSets"}
	local modeNames = {"Dressing Room", "Alpha Gear", GS(CSPS_CPBar_Location)}
	bindingNames[1] = modeNames[bindingMode]
	local myPromptNames = {"CSPS_CPBar_SelectGroup", "CSPS_CPBar_SelectSet"}
	local selectPrompt = GS(myPromptNames[myLevel], bindingMode)
	local myControl = WINDOW_MANAGER:GetControlByName(ctrNames[myLevel])
		-- tooltip 
	myControl.data = {tooltipText = selectPrompt}
	myControl:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
	myControl:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)

	myControl.comboBox = myControl.comboBox or ZO_ComboBox_ObjectFromContainer(myControl)
	local myComboBox = myControl.comboBox
	myComboBox:ClearItems()
	local choices = {}
	if bindingMode == 1 then
		if not (CSPSDR and CSPSDR.ram and CSPSDR.ram.page and CSPSDR.ram.page.pages) then return end
		if myLevel == 1 then
			local pageInd = 1
			for i, _ in pairs(CSPSDR.ram.page.pages) do
				if CSPSDR.ram.page.name[i] ~= nil then
					local myName = string.format("%s) %s", pageInd, CSPSDR.ram.page.name[i])
					pageInd = pageInd + 1
					choices[myName] = i
				end
			end
		elseif myLevel == 2 then
			local currentPage = CSPSDR.ram.page.pages[bindingGroup]
			for i = 1, CSPSDR:numSets() do
				local myName = currentPage.customSetName[i]
				myName = myName or (currentPage.gearSet[i] and currentPage.gearSet[i].name)
				myName = myName or string.format("Set %s", i)
				myName = string.format("%s) %s", i, myName)
				choices[myName] = i
			end
		end
	elseif bindingMode == 2 then
		if not (CSPSAG and CSPSAG.setdata and CSPSAG.setdata.profiles) then return end
		if myLevel == 1 then
			for i, v in pairs(CSPSAG.setdata.profiles) do
				local myName = string.format("%s) %s", i, v.name)
				if v.setdata ~= nil then
					choices[myName] = i
				end
			end
		elseif myLevel == 2 then
			local currentPage = CSPSAG.setdata.profiles[bindingGroup]
			for i, v in pairs(currentPage.setdata) do
				if type(i) == "number" then
					local myName = v.Set.text[1]
					if myName == 0 then 
						myName = string.format("%s) Build %s", i, i) 
					else
						myName =  string.format("%s) %s", i, myName)
					end
					choices[myName] = i
				end
			end
		end
	elseif bindingMode == 3 then
		if myLevel == 1 then
			choices[GS(CSPS_CPBar_LocTrial)] = 1
			choices[GS(CSPS_CPBar_LocCurr)] = 2
			choices[GS(CSPS_CPBar_LocType)] = 3
		elseif myLevel == 2 then
			if bindingGroup == 1 then
				choices = CSPS.getTrialArenaList()
			elseif bindingGroup == 2 then
				local zoneId = GetUnitWorldPosition("player")
				local myZoneName = zo_strformat("<<C:1>>", GetZoneNameById(zoneId))
				choices[myZoneName] = zoneId
				if GetParentZoneId(zoneId) ~= zoneId then
					local parentZoneId = GetParentZoneId(zoneId)
					local parentZoneName = zo_strformat("<<C:1>>", GetZoneNameById(parentZoneId))
					choices[parentZoneName] = parentZoneId
				end
			elseif bindingGroup == 3 then
				choices[zo_strformat("<<C:1>>", GS(SI_INSTANCETYPE3))] = "trial"
				-- choices[GS()] = "arena1"
				-- choices[GS()] = "arena4"
				choices[zo_strformat("<<C:1>>", GS(SI_INSTANCETYPE2))] = "dungeon"
				choices[zo_strformat("<<C:1>>", GS(SI_INSTANCEDISPLAYTYPE8))] = "housing"
				choices[zo_strformat("<<C:1>>", GS(SI_INSTANCEDISPLAYTYPE9))] = "bg"
			end
		end
	end
	myControl:SetHidden(false)	
	local function OnItemSelect(ab, choiceText, choice)
		local myGroup = choices[choiceText] or nil
		if myLevel == 1 then
			selectBindingGroup(myGroup, choiceText)
		elseif myLevel == 2 then
			selectBindingSet(myGroup, choiceText)
		end
		PlaySound(SOUNDS.POSITIVE_CLICK)
	end

	myComboBox:SetSortsItems(true)
	
	for i,j in pairs(choices) do
		myComboBox:AddItem(myComboBox:CreateItemEntry(i, OnItemSelect))
	end
	myComboBox:SetSelectedItem(selectPrompt)
end

function CSPS.addBinding()
	if bindingMode == 0 or bindingMode == nil then return end
	
	CSPS.bindings[currentGroup] = CSPS.bindings[currentGroup] or {}
	local myName = table.concat(bindingNames, " ")
	
	if bindingMode == 1 then
		if drRoles then
			bindingsDRbyRole[bindingGroup] = bindingsDRbyRole[bindingGroup] or {}
			bindingsDRbyRole[bindingGroup][bindingSet] = bindingsDRbyRole[bindingGroup][bindingSet] or {}
			local oldEntry = bindingsDRbyRole[bindingGroup][bindingSet][myGroupRole]
			if oldEntry == currentGroup then return end
			if oldEntry ~= nil then
				for i, v in pairs(CSPS.bindings[oldEntry]) do
					if v[2] == bindingMode and v[3] == bindingGroup and v[4] == bindingSet and v[5] == myGroupRole then CSPS.bindings[oldEntry][i] = nil end
				end
			end
			bindingsDRbyRole[bindingGroup][bindingSet][myGroupRole] = currentGroup
		else
			bindingsDR[bindingGroup] = bindingsDR[bindingGroup] or {}
			local oldEntry = bindingsDR[bindingGroup][bindingSet]
			if oldEntry == currentGroup then return end
			if oldEntry ~= nil then
				for i, v in pairs(CSPS.bindings[oldEntry]) do
					if v[2] == bindingMode and v[3] == bindingGroup and v[4] == bindingSet and v[5] == nil then CSPS.bindings[oldEntry][i] = nil end
				end
			end
			bindingsDR[bindingGroup][bindingSet] = currentGroup
		end
	elseif bindingMode == 2 then
		bindingsAG[bindingGroup] = bindingsAG[bindingGroup] or {}
		local oldEntry = bindingsAG[bindingGroup][bindingSet]
		if oldEntry == currentGroup then return end
		if oldEntry ~= nil then
			for i, v in pairs(CSPS.bindings[oldEntry]) do
				if v[2] == bindingMode and v[3] == bindingGroup and v[4] == bindingSet then CSPS.bindings[oldEntry][i] = nil end
			end
		end
		bindingsAG[bindingGroup][bindingSet] = currentGroup
	elseif bindingMode == 3 then
		myName = string.format("%s: %s", bindingNames[1], bindingNames[3])
		bindingsLOC = bindingsLOC or {}
		local oldEntry = bindingsLOC[bindingSet]
		if oldEntry == currentGroup then return end
		if oldEntry ~= nil then
			for i, v in pairs(CSPS.bindings[oldEntry]) do
				if v[2] == bindingMode and v[3] == bindingGroup and v[4] == bindingSet then CSPS.bindings[oldEntry][i] = nil end
			end		
		end
		bindingsLOC[bindingSet] = currentGroup
	else
		return
	end
	local myRole = drRoles and bindingMode == 1 and myGroupRole or nil
	table.insert(CSPS.bindings[currentGroup], {myName, bindingMode, bindingGroup, bindingSet, myRole})
	
	CSPS.currentCharData.bindings = CSPS.bindings
	CSPS.cpKbList:RefreshData()	
end

function CSPS.updateRole()
	if drRoles and bindingMode == 1 then CSPS.bindingsDR() end
end

function CSPS.bindingsDR()
	CSPSDR = DressingRoom or nil
	if not (CSPSDR and CSPSDR.ram and CSPSDR.ram.page) then 
		d(zo_strformat(GS(CSPS_CPBar_NoDR), "Dressing Room"))
		return 
	end
	drRoles = CSPSDR ~= nil and CSPSDR.roleSpecificPresets 
	
	if drRoles then
		local roleNames = {"dps", "tank", "healer"}
		local groupRole = CSPSDR.currentGroupRole or CSPSDR:GetGroupRoleFromLFGTool()
		myGroupRole = groupRole
		CSPSWindowManageBarsRoleIcon:SetHidden(false)
		local myTexture = roleNames[groupRole] and string.format("ESOUI/art/lfg/lfg_icon_%s.dds", roleNames[groupRole]) or "ESOUI/art/icons/icon_missing.dds" 
		CSPSWindowManageBarsRoleIcon:SetTexture(myTexture)
	else
		CSPSWindowManageBarsRoleIcon:SetHidden(true)
	end
	CSPSWindowManageBarsSubSets:SetHidden(true)
	CSPSWindowManageBarsAddBind:SetHidden(true)
	CSPSWindowManageBarsBtnDRBG:SetCenterColor(CSPS.colTbl.orange[1], CSPS.colTbl.orange[2], CSPS.colTbl.orange[3], 0.4)
	CSPSWindowManageBarsBtnAGBG:SetCenterColor(0.0314, 0.0314, 0.0314)
	CSPSWindowManageBarsBtnLocBG:SetCenterColor(0.0314, 0.0314, 0.0314)
	bindingMode = 1
	CSPS.updateBindingGroupCombo(1)
	
	CSPS.cpKbList:RefreshData()	
end

function CSPS.bindingsAG()
	CSPSAG = AG and AG.name == "AlphaGear" and AG or nil
	if CSPSAG == nil then 
		d(zo_strformat(GS(CSPS_CPBar_NoDR), "Alpha Gear"))
		return 
	end
	CSPSWindowManageBarsRoleIcon:SetHidden(true)
	CSPSWindowManageBarsSubSets:SetHidden(true)
	CSPSWindowManageBarsAddBind:SetHidden(true)
	CSPSWindowManageBarsBtnAGBG:SetCenterColor(CSPS.colTbl.orange[1], CSPS.colTbl.orange[2], CSPS.colTbl.orange[3], 0.4)
	CSPSWindowManageBarsBtnDRBG:SetCenterColor(0.0314, 0.0314, 0.0314)
	CSPSWindowManageBarsBtnLocBG:SetCenterColor(0.0314, 0.0314, 0.0314)
	bindingMode = 2
	CSPS.updateBindingGroupCombo(1)
	
	CSPS.cpKbList:RefreshData()	
end

function CSPS.bindingsLOC()
	CSPSWindowManageBarsSubSets:SetHidden(true)
	CSPSWindowManageBarsAddBind:SetHidden(true)
	CSPSWindowManageBarsRoleIcon:SetHidden(true)
	CSPSWindowManageBarsBtnLocBG:SetCenterColor(CSPS.colTbl.orange[1], CSPS.colTbl.orange[2], CSPS.colTbl.orange[3], 0.4)
	CSPSWindowManageBarsBtnAGBG:SetCenterColor(0.0314, 0.0314, 0.0314)
	CSPSWindowManageBarsBtnDRBG:SetCenterColor(0.0314, 0.0314, 0.0314)
	bindingMode = 3
	CSPS.updateBindingGroupCombo(1)
	
	CSPS.cpKbList:RefreshData()	
end

-- Bindinglist 

CSPSbindingsList = ZO_SortFilterList:Subclass()

local CSPSbindingsList = CSPSbindingsList

function CSPSbindingsList:New( control )
	local list = ZO_SortFilterList.New(self, control)
	list.frame = control
	list:Setup()
	return list
end

function CSPSbindingsList:SetupItemRow( control, data )
	control.data = data
	control:GetNamedChild("Name").normalColor = ZO_DEFAULT_TEXT
	local myName = data.name

	if data.role ~= nil then	
		local roleNames = {"dps", "tank", "healer"}
		local myTexture = string.format("|t28:28:esoui/art/lfg/lfg_icon_%s.dds|t", roleNames[data.role])
		myName = string.format("%s %s", myTexture, myName)
	end
	control:GetNamedChild("Name"):SetText(myName)
	control:GetNamedChild("Minus"):SetHandler("OnClicked", function() CSPS.kbRemove(data.myIndex) end)

	ZO_SortFilterList.SetupRow(self, control, data)
end

function CSPSbindingsList:Setup( )
	ZO_ScrollList_AddDataType(self.list, 1, "CSPSCPKBLE", 30, function(control, data) self:SetupItemRow(control, data) end)
	ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
	self:SetAlternateRowBackgrounds(true)
	self.masterList = { }
	
	local sortKeys = {
		["name"]     = { caseInsensitive = true },
	}
	self.currentSortKey = "name"
	self.currentSortOrder = ZO_SORT_ORDER_UP
	self.sortFunction = function( listEntry1, listEntry2 )
		return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, sortKeys, self.currentSortOrder)
	end
	
	self:RefreshData()
end

function CSPSbindingsList:BuildMasterList( )
	self.masterList = { }
	
	local myBindingList = CSPS.bindings[currentGroup] or {}
	for i,v in pairs(myBindingList) do
		table.insert(self.masterList, {name = v[1], myIndex = i, bindingMode = v[2], bindingGroup = v[3], bindingSet = v[4], role = v[5] or nil })
	end
end

function CSPSbindingsList:FilterScrollList( )
	local scrollData = ZO_ScrollList_GetDataList(self.list)
	ZO_ClearNumericallyIndexedTable(scrollData)
	for _, data in ipairs(self.masterList) do
		table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
	end
end

local function HookDR(mySetId)
	
	if not (CSPSDR and CSPSDR.ram and CSPSDR.ram.page) then return end
	local myGroupId = CSPSDR.sv and CSPSDR.sv.page and CSPSDR.sv.page.current
	if not myGroupId then return end
	local myKBGroup = false
	drRoles = CSPSDR.roleSpecificPresets 
	if drRoles then
		local myGroupRole = CSPSDR.currentGroupRole
		if not bindingsDRbyRole[myGroupId] then return end
		if not bindingsDRbyRole[myGroupId][mySetId] then return end
		myKBGroup = bindingsDRbyRole[myGroupId][mySetId][myGroupRole] or nil
	else
		if not bindingsDR[myGroupId] then return end
		myKBGroup = bindingsDR[myGroupId][mySetId] or nil
	end
	if not myKBGroup then return end
	d("[CSPS] Loading Group.."..myKBGroup)
	 CSPS.groupApply(myKBGroup)
end

local function HookAG(mySetId)
	local myGroupId = CSPSAG.setdata and CSPSAG.setdata.currentProfileId
	if not myGroupId then return end
	if not bindingsAG[myGroupId] then return end
		local myKBGroup = bindingsAG[myGroupId][mySetId]
	if not myKBGroup then return end
	d("[CSPS] Loading Group.."..myKBGroup)
	 CSPS.groupApply(myKBGroup)
end

function CSPS.initConnect()
	CSPSAG = AG and AG.name == "AlphaGear" and AG or nil
	CSPSDR = DressingRoom and DressingRoom.ram and DressingRoom.ram.page and DressingRoom or nil
	fillPrCombo(1)
	fillPrCombo(2)
	fillPrCombo(3)
	drRoles = CSPSDR ~= nil and CSPSDR.roleSpecificPresets 
	bindingsAG = {}
	bindingsDR = {}
	bindingsDRbyRole = {}
	bindingsLOC = {}
	for i, v in pairs(CSPS.bindings) do
		for j, w in pairs(v) do
			if w[2] == 1 then 
				if w[5] then
					bindingsDRbyRole[w[3]] = bindingsDRbyRole[w[3]] or {}
					bindingsDRbyRole[w[3]][w[4]] = bindingsDRbyRole[w[3]][w[4]] or {}
					bindingsDRbyRole[w[3]][w[4]][w[5]] = i
				else
					bindingsDR[w[3]] = bindingsDR[w[3]] or {}
					bindingsDR[w[3]][w[4]] = i
				end
			elseif w[2] == 2 then
				bindingsAG[w[3]] = bindingsAG[w[3]] or {}
				bindingsAG[w[3]][w[4]] = i
			elseif w[2] == 3 then
				bindingsLOC[w[4]] = i
			end
		end
	end
	if CSPSAG ~= nil then
		 ZO_PostHook(AG, "LoadSet", function(x1) HookAG(x1) end)
	end
	if CSPSDR ~= nil then
		ZO_PostHook(DressingRoom, "LoadSet", function(_, x2) HookDR(x2) end)
	end
	CSPS.cpKbList = CSPSbindingsList:New(CSPSWindowManageBars)
	CSPS.cpKbList:FilterScrollList()
	CSPS.cpKbList:SortScrollList( )
end

function CSPS.kbRemove(myIndex)
	local oldEntry = CSPS.bindings[currentGroup][myIndex]
	-- {myName, bindingMode, bindingGroup, bindingSet }
	if oldEntry[2] == 1 then
		if oldEntry[5] ~= nil then
			bindingsDRbyRole[oldEntry[3]][oldEntry[4]][oldEntry[5]] = nil
		else
			bindingsDR[oldEntry[3]][oldEntry[4]] = nil
		end
	elseif oldEntry[2] == 2 then
		bindingsAG[oldEntry[3]][oldEntry[4]] = nil
	end
	CSPS.bindings[currentGroup][myIndex] = nil
	CSPS.currentCharData.bindings = CSPS.bindings
	CSPS.cpKbList:RefreshData()	
end

function CSPS.KBListRowMouseUp(self, button, upInside)

end

function CSPS.KBListRowMouseExit( control )
	CSPS.cpKbList:Row_OnMouseExit(control)
	if control.data and control.data.type == 4 then ZO_Tooltips_HideTextTooltip() end
end

function CSPS.KBListRowMouseEnter(control)
	CSPS.cpKbList:Row_OnMouseEnter(control)
end

function CSPS.locationBinding(zoneId)
	if bindingsLOC[zoneId] then
		zo_callLater(function() CSPS.groupApply(bindingsLOC[zoneId]) end, 500) 
		return true
	else
		local zoneCat = ""
		if IsUnitInDungeon("player")  then
			if GetCurrentZoneDungeonDifficulty() ~= 0 then
				if isTrial[zoneId] ~= nil then 
					zoneCat = "trial"
				elseif is1Arena[zoneId] ~= nil then 
					zoneCat = "arena1"
				elseif is4Arena[zoneId] ~= nil then
					zoneCat = "arena4"
				else
					zoneCat = "dungeon"
				end
			end
		elseif GetCurrentZoneHouseId() ~= 0 then
			zoneCat = "housing"
		elseif GetCurrentBattlegroundId() ~= 0 then
			zoneCat = "bg"
		end
		if zoneCat ~= "" then
			if bindingsLOC[zoneCat] then
				zo_callLater(function() CSPS.groupApply(bindingsLOC[zoneCat]) end, 500) 
				return true
			end
		end
		return false
	end
end