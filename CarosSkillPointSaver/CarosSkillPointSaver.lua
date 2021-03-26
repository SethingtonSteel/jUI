CSPS = {
  name = "CarosSkillPointSaver",
  tabEx = false,
  skillTable = {},
  skillMorphs = {},
  skillUpgrades = {},
  skillTypes = {
		SKILL_TYPE_CLASS, 
		SKILL_TYPE_WEAPON,
		SKILL_TYPE_ARMOR,
		SKILL_TYPE_WORLD,
		SKILL_TYPE_GUILD,
		SKILL_TYPE_AVA,
		SKILL_TYPE_RACIAL,
		SKILL_TYPE_TRADESKILL	
	},
	skillTypeNames = {"", "", "", "", "", "", "", ""},
	skTypeCountPT = {},
	skLineCountPT = {},
	skCountPT = 0,
	ptCount = 0,
	kRed = {{},{},{},{},{},{},{},{},},
	kOra = {{},{},{},{},{},{},{},{},},
	needMapping = false,
	applyCP = false,
	applyCPc = {false, false, false},
	applySk = true,
	showApply = false,
	cpTable = {{0, 0, 0, 0},{0, 0, 0, 0},{0, 0, 0, 0},{0, 0, 0, 0},{0, 0, 0, 0},{0, 0, 0, 0},{0, 0, 0, 0},{0, 0, 0, 0},{0, 0, 0, 0}},
	cp2Table = {},
	cp2HbTable = {{}, {}, {}},
	cp2Comp = "",
	cp2HbComp = "",
	cp2InHb = {},
	cp2ClusterSum = {},
	cp2hbpHotkeys = {{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},{},},
	--cp2HotbarControls = {},
	cp2Controls = {},
	cp2Nodes = {},
	cp2ClusterControls = {},
	cp2RootLists = {},
	cp2List = {[1] = {}, [2] = {}, [3] = {}},
	cp2ListCluster = {},
	cp2Disci = {},
	cp2ClustRoots = {},
	cp2ClustNames = {},
	cp2ClustActive = {},
	cp2BarLabels = false,
	cp2ColorSum = {0,0,0},
	cpComp = "", 
	cpProfiles = {},
	cpColorSum = {0,0,0},
	cpStarSum = {0,0,0,0,0,0,0,0,0},
	cpColors = { {94, 189, 231}, {222, 101, 49}, {166, 216, 82}}, -- Blue, Red, Green
	cp2Colors = { {166, 216, 82}, {94, 189, 231}, {222, 101, 49}}, -- Green, Blue, Red
	cp2ColorsA = {{70/255,107/255,7/255}, {23/255,101/255,135/255}, {166/255,58/255,11/255}},
	cpForHB = {0, 0},
	cpRemindMe = false,
	cpAutoOpen = false,
	cpImportCap = false,
	cpImportReverse = false,
	cpCustomBar,
	useCustomIcons,
	hbTables = {{},{}},
	attrPoints = {0, 0, 0},
	applyAttr = false,
	unlockedCP = true,
	kaiserFranz = 1,
	showHotbar = true,
	skillForHB = nil,
	updNeedMapping = false,
	formatImpExp = "sf",
	bindings = {},
	profiles = {
	},
	currentProfile = 0,
	profileToLoad = 0,
	unsavedChanges = false,
	showOldCP = true,
}


local GS = GetString
local skillTable = CSPS.skillTable
local skillMorphs = CSPS.skillMorphs
local skillUpgrades = CSPS.skillUpgrades
local sumMorphs = 0
local sumUpgrades = 0

-- Drag and drop functions for hotbars ---

function CSPS.onSkillDrag(i, j, k)
	CSPS.skillForHB = {i,j,k,IsSkillAbilityUltimate(i,j,k)}
end

function CSPS.onHbIconDrag(myBar, icon)
	if CSPS.hbTables[myBar][icon] ~= nil then
		local i = CSPS.hbTables[myBar][icon][1]
		local j = CSPS.hbTables[myBar][icon][2]
		local k = CSPS.hbTables[myBar][icon][3]
		CSPS.skillForHB = {i,j,k,IsSkillAbilityUltimate(i,j,k)}
	end
end

function CSPS.isMagOrStam()
	local magStam = 0
	if CSPS.attrPoints[2] == 0 and CSPS.attrPoints[3] == 0 then
		if GetAttributeSpentPoints(2) > GetAttributeSpentPoints(3) then
			magStam = 1
		elseif GetAttributeSpentPoints(3) > GetAttributeSpentPoints(2) then
			magStam = 2
		end
	else
		if CSPS.attrPoints[2] > CSPS.attrPoints[3] then
			magStam = 1
		elseif CSPS.attrPoints[2] < CSPS.attrPoints[3] then
			magStam = 2
		end
	end
	return magStam
end

function CSPS.onHbIconReceive(myBar, icon)
	if CSPS.skillForHB == nil then return end 
	if icon == 6 and CSPS.skillForHB[4] == false then return end
	if icon < 6 and CSPS.skillForHB[4] == true then return end
	local i = CSPS.skillForHB[1]
	local j = CSPS.skillForHB[2]
	local k = CSPS.skillForHB[3]
	CSPS.hbSkillRemove(myBar, icon)
	local indOld = CSPS.skillTable[i][j][2][k][10][myBar]
	if 	indOld ~= nil then
			CSPS.hbTables[myBar][indOld] = nil
	end
	CSPS.hbTables[myBar][icon] = {i, j, k}
	CSPS.skillTable[i][j][2][k][10][myBar] = icon
	CSPS.skillForHB = nil
	CSPS.hbPopulate()
	CSPS.unsavedChanges = true
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
end

function CSPS.hbSkillRemove(myBar, icon)
	if CSPS.hbTables[myBar][icon] ~= nil then
		local i = CSPS.hbTables[myBar][icon][1] 
		local j = CSPS.hbTables[myBar][icon][2] 
		local k = CSPS.hbTables[myBar][icon][3]
		CSPS.skillTable[i][j][2][k][10][myBar] = nil
		CSPS.hbTables[myBar][icon] = nil
	end
	CSPS.hbPopulate()
	CSPS.unsavedChanges = true
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
end

-- plus and minus functions for skills from the list

function CSPS.minusClickSkill(i, j, k)
	--Entries: [1]Name [2]Texture [3] Rank [4]Progression [5]Purchased [6]Morph [7] SkillPoints [8] Index [9] MaxRang/Morph [10] Hotbarindex 1-6 7-12
	local auxPoint = 1
	local theSkill = CSPS.skillTable[i][j][2][k]
	local auxListIndex = theSkill[8]
	if theSkill[6] then		-- progression skill?
		if theSkill[6] == 0 then -- delete if not morphed
			theSkill[5] = false
			if theSkill[10][1] ~= nil then 
					CSPS.hbSkillRemove(1, theSkill[10][1])
			end
			if theSkill[10][2] ~= nil then 
					CSPS.hbSkillRemove(2, theSkill[10][2])
			end
			CSPS.skillMorphs[auxListIndex] = nil
		else
			theSkill[6] = theSkill[6] - 1 -- if morphed remove morph
			CSPS.skillMorphs[auxListIndex][4] = CSPS.skillMorphs[auxListIndex][4] - 1
			local name = GetAbilityName(GetSpecificSkillAbilityInfo(i,j,k,theSkill[6],1))
			name = zo_strformat("<<C:1>>", name)
			theSkill[1] = name
			theSkill[2] = GetAbilityIcon(GetSpecificSkillAbilityInfo(i,j,k,theSkill[6],1))
			if theSkill[6] > 0 then auxPoint = 0 end
		end
	else		-- Passive
		if theSkill[3] > 1 then -- if rank > 1 substract 1
			theSkill[3] = theSkill[3] - 1
			CSPS.skillUpgrades[auxListIndex][4] = CSPS.skillUpgrades[auxListIndex][4] - 1
		else
			theSkill[5] = false -- otherwise delete
			CSPS.skillUpgrades[auxListIndex] = nil
		end
	end
	CSPS.skTypeCountPT[i] = CSPS.skTypeCountPT[i] - auxPoint
	CSPS.skLineCountPT[i][j] = CSPS.skLineCountPT[i][j] - auxPoint
	if theSkill[7]  then
		theSkill[7] = theSkill[7] - auxPoint
	end
	theSkill[9] = false 
	CSPS.skillTable[i][j][2][k] = theSkill
	CSPS.buildCheck()
	CSPS.hbPopulate()
	CSPS.myTree:RefreshVisible()
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	CSPS.unsavedChanges = true
end

function CSPS.attrBtnPlusMinus(i, x, shift)
	if shift then x = x * 10 end
	CSPS.attrPoints[i] = CSPS.attrPoints[i] + x
	if CSPS.attrPoints[i] < 0 then CSPS.attrPoints[i] = 0 end
	local diff = CSPS.attrPoints[1] + CSPS.attrPoints[2] + CSPS.attrPoints[3] - CSPS.attrSum()
	if diff > 0 then CSPS.attrPoints[i] = CSPS.attrPoints[i] - diff end
	CSPS.myTree:RefreshVisible()
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	CSPS.unsavedChanges = true
end

function CSPS.minusClickSkillLine(skTyp, skLin)
	local name = CSPS.skillTypeNames[skTyp]
	if skLin ~= nil then name = CSPS.skillTable[skTyp][skLin][1] end
	ZO_Dialogs_ShowDialog(CSPS.name.."_DeleteSkillType", {i = skTyp, j = skLin}, {mainTextParams = {name}})
end

function CSPS.removeSkillLine(skTyp, skLin)
	for ind, v in pairs(CSPS.skillUpgrades) do
		local i,j,k = v[1], v[2], v[3]
		if i == skTyp and (skLin == nil or j == skLin) then
			CSPS.skillTable[i][j][2][k][5] = false
			if CSPS.skillTable[i][j][2][k][7]  then	CSPS.skillTable[i][j][2][k][7] = 0 end
			CSPS.skillTable[i][j][2][k][9] = false
			CSPS.skillUpgrades[ind] = nil
		end
	end
	for ind, v in pairs(CSPS.skillMorphs) do
		local i,j,k = v[1], v[2], v[3]
		if i == skTyp and (skLin == nil or j == skLin) then
			CSPS.skillTable[i][j][2][k][5] = false
			if CSPS.skillTable[i][j][2][k][7]  then	CSPS.skillTable[i][j][2][k][7] = 0 end
			CSPS.skillTable[i][j][2][k][9] = false
			CSPS.skillMorphs[ind] = nil
		end
	end	
	if skLin == nil then 
		CSPS.skTypeCountPT[skTyp] = 0
		for i, v in pairs(CSPS.skLineCountPT[skTyp]) do
			CSPS.skLineCountPT[skTyp][i] = 0
		end
	else
		CSPS.skTypeCountPT[skTyp] =  CSPS.skTypeCountPT[skTyp] - CSPS.skLineCountPT[skTyp][skLin] 
		CSPS.skLineCountPT[skTyp][skLin] = 0
	end
	CSPS.buildCheck()
	CSPS.myTree:RefreshVisible()
end

function CSPS.plusClickSkill(i, j, k)
	--entries CSPS.skillTable: [1]Name [2]Texture [3] Rank [4]Progression [5]Purchased [6]Morph [7] Skill points [8] aux list index [9] MaxRank/Morph [10] Hotbar index
	--entries skillMorphs: type, line, skill, morph
	--entries skillUpgrades: type, line, skill, rank
	local auxPoint = 1
	local theSkill = CSPS.skillTable[i][j][2][k]
	local auxListIndex = theSkill[8] or 0
	local isMorphable = (GetProgressionSkillProgressionId(i,j,k) > 0)
	local couldBeAdded = false
	if theSkill[5] == false then	-- Skill is not purchased?
			theSkill[5] = true
			couldBeAdded = true
			if isMorphable then
				if auxListIndex == nil or auxListIndex == 0 then 
					sumMorphs = sumMorphs + 1
					auxListIndex = sumMorphs
					theSkill[8] = auxListIndex
				end
				CSPS.skillMorphs[auxListIndex] = {i, j, k, 0}
				theSkill[6] = 0
			else
				if auxListIndex == nil or auxListIndex == 0 then
					sumUpgrades = sumUpgrades + 1
					auxListIndex = sumUpgrades
					theSkill[8] = auxListIndex
				end
				if CSPS.noRank(i, j, k) == true then 
					CSPS.skillUpgrades[auxListIndex] = {i, j, k, 0}
					theSkill[3] = 0
					theSkill[9] = true 
				else
					CSPS.skillUpgrades[auxListIndex] = {i, j, k, 1}
					theSkill[3] = 1
				end
			end
			if IsSkillAbilityAutoGrant(i,j,k) then
				auxPoint = 0
				if CSPS.freeNoRank(i,j,k) and IsSkillAbilityPassive(i,j,k) then theSkill[9] = true  end
			end
	else
		if isMorphable then
			if theSkill[6] < 2 then 
				theSkill[6] = theSkill[6] + 1
				CSPS.skillMorphs[auxListIndex][4] = CSPS.skillMorphs[auxListIndex][4] + 1
				if theSkill[6] == 2 then 
					auxPoint = 0 
					theSkill[9] = true 
				end
				couldBeAdded = true
			end
		else
			local _, maxRank = GetSkillAbilityUpgradeInfo(i,j,k)
			if theSkill[3] < maxRank then 
				theSkill[3] = theSkill[3] + 1
				CSPS.skillUpgrades[auxListIndex][4] = CSPS.skillUpgrades[auxListIndex][4] + 1
				couldBeAdded = true
				if theSkill[3] == maxRank or maxRank == nil then theSkill[9] = true end
			end
		end
	end
	if couldBeAdded then
		CSPS.skTypeCountPT[i] = CSPS.skTypeCountPT[i] + auxPoint
		CSPS.skLineCountPT[i][j] = CSPS.skLineCountPT[i][j] + auxPoint
		if theSkill[7] then
			theSkill[7] = theSkill[7] + auxPoint
		else
			theSkill[7] = auxPoint
		end
		if isMorphable then
				theSkill[1] = zo_strformat("<<C:1>>", GetAbilityName(GetSpecificSkillAbilityInfo(i,j,k,theSkill[6],1)))
				theSkill[2] = GetAbilityIcon(GetSpecificSkillAbilityInfo(i,j,k,theSkill[6],1))
		end
	end
	CSPS.skillTable[i][j][2][k] = theSkill
	CSPS.buildCheck()
	CSPS.myTree:RefreshVisible()
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	CSPS.unsavedChanges = true
end

-- migration for version compability

local function migrateSV()
	d("CSPS: Migrating data after v.0.9.3")
	if not CSPS.savedVariables or CSPS.savedVariables.wasMigrated == true then return end
	local changedCount = 0
	local accountName = GetDisplayName()
	local worldName = CSPS.worldName or GetWorldName()
    --Get all of the characters/toons, then migrate their Variables if they have any
    for i = 1, GetNumCharacters() do
		--Get name and unique id		
		local charName, _, _, _, _, _, characterId, _ = GetCharacterInfo(i)
		--Format the name
		charName = ZO_CachedStrFormat(SI_UNIT_NAME, charName)
		--Check old Character saved (ZO_SavedVars:New()) SV data and migrate it to the new characterIds.
		--Also migrate them to server dependent SVs	
		local copyFrom = CSPSSavedVariables["Default"] and CSPSSavedVariables["Default"][accountName] and CSPSSavedVariables["Default"][accountName][charName]
		if copyFrom ~= nil then
			d( string.format(">Migrating Data for %s --> ID %s, server %s", charName, characterId, worldName) )
			--Create new subtable for the characterId
			CSPS.savedVariables.charData = CSPS.savedVariables.charData or {}
			CSPS.savedVariables.charData[characterId] = {}
			ZO_ShallowTableCopy(copyFrom, CSPS.savedVariables.charData[characterId])
			CSPS.savedVariables.charData[characterId]["$lastCharacterName"] = charName
			CSPSSavedVariables["Default"][accountName][charName] = nil
			changedCount = changedCount +1
		end
	end
	CSPS.savedVariables.settings = CSPS.savedVariables.settings or {}
	local copyFrom2 = CSPSSavedVariables["Default"] and CSPSSavedVariables["Default"][accountName] and CSPSSavedVariables["Default"][accountName]["$AccountWide"]
	if copyFrom2 ~= nil then ZO_ShallowTableCopy(copyFrom2, CSPS.savedVariables.settings) end
	CSPSSavedVariables["Default"] = nil
	CSPS.savedVariables.wasMigrated = true -- important to avoid reload-loop
	d("Done migrating.")
	-- ReloadUI now to save the data.
	CSPS.changedCount = changedCount -- wieder rauswerfen nach der Testphase
	if changedCount > 0 then
		CSPS.freshlyMigrated = true
		ReloadUI(nil)
	end
end

-- Initializing the addon on load

function CSPS:Initialize()
	local svName= "CSPSSavedVariables"
	local svVersion = 1
	local svNamesSpace = nil
	local currentCharId = GetCurrentCharacterId()
	CSPS.currentCharId = currentCharId
	local svDefaults = {
		wasMigrated = false,
		settings = {
			applyAttr = false,
			applyCP = false,
			applySk = true,
			showHotbar = false,
			cpReminder = false,
		},
		charData = {
			[currentCharId] = {},
		},
	} 
	local svProfile = GetWorldName()
	CSPS.worldName = svProfile
	local svDisplayName = nil 
	
	CSPS.savedVariables = ZO_SavedVars:NewAccountWide(svName, svVersion, svNamesSpace, svDefaults, svProfile, svDisplayName) -- savedvars account wide, server dependent
	if not CSPS.savedVariables.wasMigrated then migrateSV() end
		
	-- CSPS.kaiserFranz: id for the emperor skill line (named after emperor Franz, the 52nd of his name)
	if string.lower(GetCVar("Language.2")) ~= "de" then
		_, CSPS.kaiserFranz, _ = GetSkillLineIndicesFromSkillLineId(71)
	end
	
	CSPS.currentCharData = CSPS.savedVariables.charData[currentCharId]
		
	-- if no skills have been saved yet for this char, save everything once
	if CSPS.currentCharData.werte == nil then
		CSPS.populateTable()
		CSPS.saveBuildGo()
	end
	-- if not attributes have been saved yet for this char, save the current attributes
	if CSPS.currentCharData.attribute == nil then	
		CSPS.populateAttributes()
		local attrComp = CSPS.attrCompress(CSPS.attrPoints)
		CSPS.currentCharData.attribute = attrComp
	end
	
	-- if no hotbars have been saved yet for this char, save the current attributes
	if CSPS.currentCharData.hbwerte == nil then
		CSPS.populateTable(true)
		CSPS.hbRead()
	    local hbComp = CSPS.hbCompress(CSPS.hbTables)
		CSPS.currentCharData.hbwerte = hbComp
	end
	
	-- Hide CP-Option if no Character has reached level 50 yet.
	if GetPlayerChampionPointsEarned() == 0 then 
		CSPS.unlockedCP = false
		CSPS.applyCP = false
	end
				
	CSPS.profiles = CSPS.currentCharData.profiles or {}
	CSPS.bindings = CSPS.currentCharData.bindings or {}
	CSPS.currentCharData.cpHbProfiles = CSPS.currentCharData.cpHbProfiles  or {}
	
	CSPSWindowImportExportTextEdit:SetMaxInputChars(3000)
	local formatImpExp = CSPS.savedVariables.settings.formatImpExp or "sf"
	CSPS.toggleImpExpSource(formatImpExp, true)
	
	CSPS.cpImportCap =  CSPS.savedVariables.settings.cpImportCap or false
	CSPS.cpImportReverse = CSPS.savedVariables.settings.cpImportReverse or false
	
	CSPS.toggleCPCapImport(CSPS.cpImportCap)
	CSPS.toggleCPReverseImport(CSPS.cpImportReverse)
	
	CSPS.InitLocalText()
	
	local oldApi = CSPS.currentCharData.svApi or 0
	if oldApi < 100034 then CSPS.updNeedMapping = true else CSPS.updNeedMapping = false end
	local myKeys = CSPS.compareKeys()	
	if CSPS.needMapping or CSPS.updNeedMapping then CSPS.mapSkills(myKeys) end
	
	CSPS:RestorePosition()
	CSPS.treeBereit()
	CSPS.initConnect()
	
	CSPS.showElement("checkCP")
	CSPS.showElement("apply", false)
	
	CSPS.cp2CreateTable()
		
	CSPS.cp2hbpHotkeys = CSPS.currentCharData.cp2hbpHotkeys or CSPS.cp2hbpHotkeys
	if #CSPS.cp2hbpHotkeys < 20 then
		for i=1, 20 do
			table.insert(CSPS.cp2hbpHotkeys, {})
			if #CSPS.cp2hbpHotkeys == 20 then break end
		end
	end
	local cpRemindMe = CSPS.savedVariables.settings.cpReminder or false
	CSPS.toggleCPReminder(cpRemindMe)
	local cpAutoOpen = CSPS.savedVariables.settings.cpAutoOpen or false
	CSPS.toggleCPAutoOpen(cpAutoOpen)
	CSPS.toggleCP(0, CSPS.savedVariables.settings.applyCP and CSPS.unlockedCP)
	CSPS.toggleSk(CSPS.savedVariables.settings.applySk)
	CSPS.toggleATTR(CSPS.savedVariables.settings.applyAttr)
	CSPS.toggleHotbar(CSPS.savedVariables.settings.showHotbar)	
	local cpCustomBar = CSPS.savedVariables.settings.cpCustomBar or false
	CSPS.toggleCPCustomBar(cpCustomBar)
	local useCustomIcons = CSPS.savedVariables.settings.useCustomIcons or false
	CSPS.toggleCPCustomIcons(useCustomIcons)
	
	local showOldCP = CSPS.savedVariables.settings.showOldCP
	if showOldCP == nil then showOldCP = true end
	CSPS.showElement("oldCP", showOldCP)
	
	EVENT_MANAGER:RegisterForEvent(CSPS.name, EVENT_CHAMPION_PURCHASE_RESULT, CSPS.onCPChange)
	EVENT_MANAGER:RegisterForEvent(CSPS.name, EVENT_PLAYER_ACTIVATED, function() CSPS.cpReminder() end)
	EVENT_MANAGER:UnregisterForEvent(CSPS.name, EVENT_ADD_ON_LOADED)
end

function CSPS.OnAddOnLoaded(event, addonName)
	if addonName == CSPS.name then
		EVENT_MANAGER:UnregisterForEvent(CSPS.name, EVENT_ADD_ON_LOADED)
		CSPS:Initialize()
	end
end

-- display the current skills

function CSPS.showBuild()
	CSPS.showElement("apply", false)
	CSPS.showElement("save", true)
	CSPS.kRed = {{},{},{},{},{},{},{},{},}
	CSPS.kOra = {{},{},{},{},{},{},{},{},}
	CSPS.populateTable()
	CSPS.cp2ReadCurrent()
	CSPS.hbRead()
	CSPS.hbPopulate()
	if not CSPS.tabEx then CSPS.createTable() end
	
	for i=1,3 do
		CSPS.cp2HbIcons(i)
	end
	CSPS.cp2UpdateHbMarks()
	
	CSPS.myTree:RefreshVisible() 
	CSPS.unsavedChanges = true
end

function CSPS.saveBuild()
	local myName = GS(CSPS_Txt_StandardProfile)
	if CSPS.currentProfile ~= 0 then myName = CSPS.profiles[CSPS.currentProfile].name end
	local myWarning = (not CSPSWindowCPProfiles:IsHidden()) and GS(CSPS_MSG_NoCPProfiles) or ""
	ZO_Dialogs_ShowDialog(CSPS.name.."_ConfirmSave", nil,  {mainTextParams = {myName, myWarning}} )
end

-- Compare keys to see if data has been saved in a different language

-- Generate subkeys

local function hkErzeugen(i)
	local hilfsKey = string.format("%s-%s", 1, GetSkillLineId(i, 1))
	for j=2, GetNumSkillLines(i) do
		hilfsKey = string.format("%s,%s-%s", hilfsKey, j, GetSkillLineId(i, j))
	end
	return hilfsKey
end

-- Generate keys to compare

local function generateKeys()
	local einSchluessel = {hkErzeugen(4), hkErzeugen(5), hkErzeugen(6), hkErzeugen(8)}
	return table.concat(einSchluessel, ";")
end

-- Compare keys

function CSPS.compareKeys()
	CSPS.needMapping = false
	if CSPS.currentCharData.myKeys == nil then return end
	local myKeys = generateKeys()
	if CSPS.currentCharData.myKeys == myKeys then return myKeys end
	local alleSchluessel = {SplitString(";", CSPS.currentCharData.myKeys)}
	local myKeyMap = {4, 5, 6, 8} -- skill types that are ordered alphabetically
	CSPS.skLocMappings = {}
	CSPS.skLocMappings = {{}, {}, {}, {}, {}, {}, {}, {}, {}}
	for i,k in pairs(myKeyMap) do --generating table with mappings for all skill lines
		for j=1, GetNumSkillLines(k) do
			CSPS.skLocMappings[i][j] = j
		end
	end	
	for keyInd1, einSchluessel in pairs(alleSchluessel) do
		local hilfsKey = {SplitString(",", einSchluessel)}
		for keyInd2, v in pairs(hilfsKey) do
			local sklNum, sklInd = SplitString("-", v)
			local _, meineLinie = GetSkillLineIndicesFromSkillLineId(tonumber(sklInd)) 
			CSPS.skLocMappings[myKeyMap[keyInd1]][tonumber(sklNum)] = meineLinie
		end
	end
	CSPS.needMapping = true
	return myKeys
end

function CSPS.mapSkills(myKeys)
	local morphs, upgrades = CSPS.skTableExtract(CSPS.currentCharData.werte.prog, CSPS.currentCharData.werte.pass)
	local auxTable = CSPS.compressLists(morphs, upgrades)
	CSPS.currentCharData.werte = auxTable
	if CSPS.needMapping then
		local auxHbTable = CSPS.hbExtract(CSPS.currentCharData.hbwerte)
		CSPS.currentCharData.hbwerte = CSPS.hbCompress(auxHbTable)
	end
	for i, v in pairs(CSPS.profiles) do
		if v.werte ~= nil then
			local morphs, upgrades = CSPS.skTableExtract(v.werte.prog, v.werte.pass)
			local auxTable = CSPS.compressLists(morphs, upgrades)
			v.werte = auxTable
			if CSPS.needMapping then
				local auxHbTable = CSPS.hbExtract(v.hbwerte)
				local auxHbTable = CSPS.hbCompress(auxHbTable)
				v.hbwerte = auxHbTable
			end
		end
	end
	
	if CSPS.needMapping then 
		d(GS(CSPS_TxtLangDiff)) 
		CSPS.habeGemappt1 = true 
	end
	if CSPS.updNeedMapping then CSPS.habeGemappt2 = true end
	CSPS.needMapping = false
	CSPS.currentCharData.myKeys = myKeys
	CSPS.currentCharData.svApi = GetAPIVersion()	
	CSPS.currentCharData.profiles = CSPS.profiles
	CSPS.updNeedMapping = false

	
end

function CSPS.saveBuildGo()
	local skillTableClean = CSPS.compressLists(CSPS.skillMorphs, CSPS.skillUpgrades)
	local hbComp = CSPS.hbCompress(CSPS.hbTables)
	local attrComp = CSPS.attrCompress(CSPS.attrPoints)
	local cp2Comp = ""
	local cp2HbComp = ""
	cp2Comp = CSPS.cp2Compress(CSPS.cp2Table) 
	cp2HbComp = CSPS.cp2HbCompress(CSPS.cp2HbTable)

	
	local myKeys = generateKeys()
	if CSPS.currentProfile == 0 then
		if not CSPS.tabExHalf then
			CSPS.currentCharData.werte = skillTableClean
		end
		CSPS.currentCharData.cp2werte = cp2Comp
		CSPS.currentCharData.cp2hbwerte = cp2HbComp

		if not CSPS.tabExHalf then
			CSPS.currentCharData.hbwerte = hbComp
			CSPS.currentCharData.attribute = attrComp
		end
	else
		if not CSPS.tabExHalf then
			CSPS.profiles[CSPS.currentProfile].werte = skillTableClean
			CSPS.profiles[CSPS.currentProfile].hbwerte = hbComp
			CSPS.profiles[CSPS.currentProfile].attribute = attrComp
		end
		CSPS.profiles[CSPS.currentProfile].cp2werte = cp2Comp
		CSPS.profiles[CSPS.currentProfile].cp2hbwerte = cp2HbComp

		CSPS.currentCharData.profiles = CSPS.profiles
	end
	CSPS.currentCharData.svApi = GetAPIVersion()
	CSPS.currentCharData.myKeys = myKeys
	CSPS.currentCharData["$lastCharacterName"] = ZO_CachedStrFormat(SI_UNIT_NAME, GetRawUnitName('player'))
	CSPS.showElement("load")
	CSPS.unsavedChanges = false
end

function CSPS.populateAttributes()
	-- Read current attribute points
	for i=1, 3 do
		CSPS.attrPoints[i] = GetAttributeSpentPoints(i) 
	end
end


function CSPS.setSumMP(morphA, passA)
	if morphA ~= nil then sumMorphs = morphA end
	if passA ~= nil then sumUpgrades = passA end
end

function CSPS.populateTable(doNotFill)
	CSPS.populateAttributes()
	CSPS.cp2ResetTable()
	if CSPS.myTree then CSPS.myTree:RefreshVisible() end
	--- Read Current Skills
	local skillTableH = {}
	CSPS.skillMorphs = {}
	sumMorphs = 0
	CSPS.skillUpgrades = {}
	sumUpgrades = 0
	for i=1, #CSPS.skillTypes do
		local nochSkillLinien = true
		local j = 1
		skillTableH[i] = {}
		CSPS.skTypeCountPT[i] = 0
		CSPS.skLineCountPT[i] = {}
		while nochSkillLinien do
			local mySkillLine = GetSkillLineName(i, j)
			mySkillLine = zo_strformat("<<C:1>>", mySkillLine)
			skillTableH[i][j] = {mySkillLine, {}}
			CSPS.skLineCountPT[i][j] = 0
			local anySkillsLeft = true
			local k = 1
			while anySkillsLeft do
				local name, texture, earnedRank, _, _, purchased, progressionIndex, rank = GetSkillAbilityInfo(i, j, k)
				if name == nil or name == "" then 
					anySkillsLeft = false
				else 
					name = zo_strformat("<<C:1>>", name)
					local morph = nil
					if GetProgressionSkillProgressionId(i,j,k) > 0 then morph = 0 end
					local myPoints = 0
					local auxListIndex = 0
					local maxRaMo = false
					if purchased and not doNotFill then 
							myPoints = 1 - CSPS.getSpecialPassives(i, j, k) 
						
							if progressionIndex then 
								_, morph = GetAbilityProgressionInfo( progressionIndex)
								sumMorphs = sumMorphs + 1
								auxListIndex = sumMorphs
								CSPS.skillMorphs[auxListIndex] = {i, j, k, morph}
								if morph > 0 then 
									myPoints = myPoints + 1
									if morph == 2 then maxRaMo = true end
								end
							else
								sumUpgrades = sumUpgrades + 1
								auxListIndex = sumUpgrades
								CSPS.skillUpgrades[auxListIndex] = {i, j, k, rank}
								if rank == nil then rank = 0 end
								local _, maxRank = GetSkillAbilityUpgradeInfo(i,j,k)
								if maxRank == nil then maxRank = 0 end
								if rank >= maxRank then maxRaMo = true end
								myPoints = myPoints + rank - 1
							end
					else
						purchased = false
					end
					skillTableH[i][j][2][k] = {name, texture, rank, progressionIndex, purchased, morph, myPoints, auxListIndex, maxRaMo, {}}
					k = k + 1
					
					CSPS.skTypeCountPT[i] = CSPS.skTypeCountPT[i] + myPoints
					CSPS.skLineCountPT[i][j] = CSPS.skLineCountPT[i][j] + myPoints
				end
				if GetSkillAbilityInfo(i, j, k) == {} then anySkillsLeft = false end
				if k > 21 then anySkillsLeft = false end
				
			end
			j = j + 1
			if GetSkillLineName(i, j) == "" then nochSkillLinien = false end
			if i==1 and j==4 then nochSkillLinien = false end
			if i==7 and j==2 then nochSkillLinien = false end
		end
	end
	CSPS.skillTable = skillTableH
end

function CSPS.attrCompress(attrPoints)
	local attrComp = table.concat(attrPoints, ";")
	return attrComp
end

function CSPS.hbCompress(hbTables)
	local hbComp = ""
	local auxHb = {}
	for i=1,2 do
		local auxHb1 = {}
		for j=1,6 do
			if hbTables[i][j] ~= nil then 
				auxHb1[j] = table.concat(hbTables[i][j], "-")
			else
				auxHb1[j] = "-"
			end
		end
		auxHb[i] = table.concat(auxHb1, ",")
	end
	hbComp = table.concat(auxHb, ";")
	return hbComp
end


function CSPS.compressLists(morphs, upgrades)
	local progTab = {}
	local passTab = {}
	for i, m in pairs(morphs) do
		progTab[#progTab+1] = string.format("%s-%s-%s-%s", m[1], m[2], m[3], m[4])
	end
	for i, m in pairs(upgrades) do
		passTab[#passTab+1] = string.format("%s-%s-%s-%s", m[1], m[2], m[3], m[4])
	end
	return {prog = progTab, pass = passTab}
end

function CSPS.skTableExtract(progTab, passTab)
	if progTab == nil then progTab = {} end
	if passTab == nil then passTab = {} end
	local morphs, upgrades = {}, {}
	for progInd, skMorph in pairs(progTab) do --extract all the skills with progressionIndices (morphable skills)
		local i, j, k, l = SplitString("-", skMorph)
		i = tonumber(i) -- Skill type
		j = tonumber(j) -- Skill line
		if CSPS.needMapping and (i == 4 or i == 5 or i == 6 or i == 8) then -- language mapping for skill types with alphabetical order
			j = CSPS.skLocMappings[i][j]
		end
		k = tonumber(k) -- Skill number
		l = tonumber(l) -- Morph
		if IsSkillAbilityPassive(i,j,k) then 
			l = 0
			upgrades[#upgrades+1] = {i, j, k, l}
			local myName = GetSkillAbilityInfo(i,j,k)
			d(zo_strformat(GS(CSPS_LoadingError), myName))
		else 
			morphs[#morphs + 1] = {i, j, k, l}
		end
	end
			  	
	for passInd, skPass in pairs(passTab) do --extract all the skills without progressionIndices (passives)
		local i, j, k, l = SplitString("-", skPass)
		i = tonumber(i) -- SkillType
		j = tonumber(j) -- SkillLine		
		if CSPS.needMapping and (i == 4 or i == 5 or i == 6 or i == 8) then -- Remap SkillType 4,5,6,8, if the data comes from a different language 
			j = CSPS.skLocMappings[i][j]
		end
		k = tonumber(k) -- SkillNumber
		if CSPS.updNeedMapping and i == 3 then
			if (j == 1 or j == 3) and k > 1 then k = k + 2 end
			if j == 2 and k > 1 then k = k +1 end
		elseif CSPS.updNeedMapping then
			local myLineId = GetSkillLineId(i,j)
			if myLineId == 76 or myLineId == 78 then
				if k < 3 then
					local _, maxRank = GetSkillAbilityUpgradeInfo(i, j, 1)
					if maxRank == 10 or maxRank == 6 then
						k = k == 1 and 2 or 1
					end
				end
			elseif myLineId == 72 then
				if k == 3 or k == 4 then	-- Switch 3rd and 4th skill of soul magic (only if the abilityIds fit
					local myAbId3 = GetSpecificSkillAbilityInfo(i,j,3, 0, 2)
					local myAbId4 = GetSpecificSkillAbilityInfo(i,j,4, 0, 2)
					
					if myAbId3 == 45590 and myAbId4 == 45583 then
						k = k == 3 and 4 or 3
					end
				end
			end
		end
		l = tonumber(l) -- Rank
		if IsSkillAbilityPassive(i,j,k) then
			local _, maxRank = GetSkillAbilityUpgradeInfo(i, j, k)
			if maxRank then
				if l > maxRank then
					if i == 8 then
						local myLineId = GetSkillLineId(i,j)
						if (myLineId == 76 or myLineId == 78) and k == 2 then
							if upgrades[#upgrades][1] == i and upgrades[#upgrades][2] == j and upgrades[#upgrades][3] == 1 then
								local auxL = l
								_, maxRank2 = GetSkillAbilityUpgradeInfo(i, j, 1)
								if auxL > maxRank2 then auxL = maxRank2 end
								l = upgrades[#upgrades][4]
								upgrades[#upgrades][4] = auxL
							else
								k = 1
								_, maxRank = GetSkillAbilityUpgradeInfo(i, j, k)
							end
						end
					end
					l = maxRank
					local myName = GetSkillAbilityInfo(i,j,k)
					d(zo_strformat(GS(CSPS_LoadingError), myName))
				end
			end
			upgrades[#upgrades + 1] = {i, j, k, l}
		else
			l = 0 
			local myName = GetSkillAbilityInfo(i,j,k)
			d(zo_strformat(GS(CSPS_LoadingError), myName))
			morphs[#morphs+1] = {i, j, k, l}
		end
	end
	return morphs, upgrades
end

function CSPS.tableExtract(progTab, passTab)
	CSPS.skillMorphs = {}
	CSPS.skillUpgrades = {}
	local morphs, upgrades = CSPS.skTableExtract(progTab, passTab)
	CSPS.populateSkills(morphs, upgrades)
end

function CSPS.populateSkills(morphs, upgrades)
	CSPS.populateTable(true) -- true-placeholder: don't change the lists for morphs/upgrades yet
	sumMorphs = #morphs
	sumUpgrades = #upgrades
	CSPS.skillMorphs = morphs
	CSPS.skillUpgrades = upgrades
	for progInd, mV in pairs(morphs) do
		local myPoints = 0
		local i, j, k, l = mV[1], mV[2], mV[3], mV[4]
		local name, texture, _, _, _, _, prog, rank = GetSkillAbilityInfo(i, j, k)
		if prog ~= nil then
			name, texture = GetAbilityProgressionAbilityInfo(prog, l, 1)
		else
			name = GetAbilityName(GetSpecificSkillAbilityInfo(i,j,k,l,1))
			texture = GetAbilityIcon(GetSpecificSkillAbilityInfo(i,j,k,l,1))
		end
		name = zo_strformat("<<C:1>>", name)
		local maxRaMo = false
		if l == 2 then maxRaMo = true end
		-- Fill in the table entry
		CSPS.skillTable[i][j][2][k] = {name, texture, rank, prog, true, l, 0, progInd, maxRaMo, {}}
		-- Add the skill points
		myPoints = myPoints + 1 - CSPS.getSpecialPassives(i, j, k) 
		if l > 0 then
			myPoints = myPoints + 1
		end
		CSPS.skTypeCountPT[i] = CSPS.skTypeCountPT[i] + myPoints 
		CSPS.skLineCountPT[i][j] = CSPS.skLineCountPT[i][j] + myPoints
		CSPS.skillTable[i][j][2][k][7] = myPoints
	end
	for passInd, mV in pairs(upgrades) do
		local myPoints = 0
		local i, j, k, l = mV[1], mV[2], mV[3], mV[4]
		-- Check for max rank
		local maxRaMo = false
		local _, maxRank = GetSkillAbilityUpgradeInfo(i,j,k)
		if maxRank == nil then maxRank = 0 end
		if l >= maxRank then maxRaMo = true end
		-- Get Name/Texture
		local name, texture = GetSkillAbilityInfo(i, j, k)
		name = zo_strformat("<<C:1>>", name)
		-- Fill in the table entry
		CSPS.skillTable[i][j][2][k] = {name, texture, l, nil, true, nil, 0, passInd, maxRaMo, {}}
		-- Add skill points
		myPoints = l - CSPS.getSpecialPassives(i, j, k) 
		CSPS.skTypeCountPT[i] = CSPS.skTypeCountPT[i] + myPoints
		CSPS.skLineCountPT[i][j] = CSPS.skLineCountPT[i][j] + myPoints
		CSPS.skillTable[i][j][2][k][7] = myPoints
	end
end

function CSPS.attrExtract(attrComp)
	if attrComp ~= "" then
		CSPS.attrPoints = {SplitString(";", attrComp)}
	end
end

function CSPS.hbExtract(hbComp)
	local hbTables = {{},{}}
	hbComp = hbComp or ""
	if hbComp ~= "" then
		local auxHb = {SplitString(";", hbComp)}
		hbTables = {}
		for i=1, 2 do
			hbTables[i] = {}
			local auxHb1 = {SplitString(",", auxHb[i])}
			for j, einSkill in pairs(auxHb1) do
				if einSkill == "" or einSkill == "-" then 
					hbTables[i][j] = nil
				else
					local ijk = {SplitString("-", einSkill)}
					local skTyp = tonumber(ijk[1])
					local skLin = tonumber(ijk[2])
					if CSPS.needMapping and (skTyp == 4 or skTyp == 5 or skTyp == 6 or skTyp == 8) then -- language mapping for skill types with alphabetical order
						skLin = CSPS.skLocMappings[skTyp][skLin]
					end
					hbTables[i][j] = {skTyp, skLin, tonumber(ijk[3])}
				end
			end
		end
	end
	return hbTables
end

function CSPS.hbLinkToSkills(hbTables)
	for i, v in pairs(hbTables) do
		for j, w in pairs(v) do
			CSPS.skillTable[w[1]][w[2]][2][w[3]][10][i] = j
		end
	end
end

function CSPS.cpExtract()
	if CSPS.cpComp == "" then CSPS.cpComp = "0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0" end
	CSPS.cpColorSum = {0,0,0}
	CSPS.cpStarSum = {0,0,0,0,0,0,0,0,0}
	local k = {3, 2, 2, 2, 1, 1, 1, 3, 3}
	local hilfsCPExtr = {SplitString(";", CSPS.cpComp)}
	for i=1, 9 do
		local hilfsCPExtrB = {SplitString(",", hilfsCPExtr[i])}
		for j=1, 4 do
			local thePoints = hilfsCPExtrB[j]
			CSPS.cpTable[i][j] = thePoints
			CSPS.cpStarSum[i] = CSPS.cpStarSum[i] + thePoints
			CSPS.cpColorSum[k[i]] = CSPS.cpColorSum[k[i]] + thePoints
		end
	end
end
	
function CSPS.loadBuild()
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	if CSPS.currentCharData.werte == nil and CSPS.profiles == {} then d(CSPS.msgNoSavedData) return end
	local skillTableClean, attrComp, hbComp, cp2Comp, cp2HbComp = {}, "", "", "", ""
	if CSPS.currentProfile == 0 then
		skillTableClean = CSPS.currentCharData.werte
		CSPS.cpComp = CSPS.currentCharData.cpwerte
		cp2Comp = CSPS.currentCharData.cp2werte or ""
		cp2HbComp = CSPS.currentCharData.cp2hbwerte or ""
		attrComp = CSPS.currentCharData.attribute
		hbComp = CSPS.currentCharData.hbwerte
		CSPS.tableExtract(skillTableClean.prog, skillTableClean.pass)
	else
		skillTableClean = CSPS.profiles[CSPS.currentProfile].werte or {}
		CSPS.cpComp =  CSPS.profiles[CSPS.currentProfile].cpwerte or ""
		cp2Comp = CSPS.profiles[CSPS.currentProfile].cp2werte or ""
		cp2HbComp =  CSPS.profiles[CSPS.currentProfile].cp2hbwerte or ""
		attrComp =  CSPS.profiles[CSPS.currentProfile].attribute or ""
		hbComp =  CSPS.profiles[CSPS.currentProfile].hbwerte or ""
		CSPS.tableExtract(skillTableClean.prog, skillTableClean.pass)
	end
	CSPS.cpExtract()
	CSPS.cp2Extract(cp2Comp)
	CSPS.cp2HbTable = CSPS.cp2HbExtract(cp2HbComp)
	CSPS.hbTables = CSPS.hbExtract(hbComp)
	CSPS.hbLinkToSkills(CSPS.hbTables)
	CSPS.hbPopulate()
	CSPS.attrExtract(attrComp)
	if not CSPS.tabEx then CSPS.createTable()	end
	CSPS.buildCheck()
	for i=1,3 do
		CSPS.cp2HbIcons(i)
	end
	CSPS.cp2UpdateHbMarks()

	CSPS.myTree:RefreshVisible() 
	CSPS.unsavedChanges = false
end

function CSPS.applyBuild()
	CSPS.ptCount = 0
	for i=1, #CSPS.skTypeCountPT do
		CSPS.ptCount = CSPS.ptCount + CSPS.skTypeCountPT[i]
	end
	if CSPS.applySk and CSPS.tabEx then 
		CSPS.buildCheck()
		local meineParameter =	{
			GetAvailableSkillPoints(), 
			CSPS.toBuyPt, 
			CSPS.morphWrong + CSPS.skLocked + CSPS.morphLocked + CSPS.rankLocked, 
			CSPS.skLocked, 
			CSPS.morphWrong,
			CSPS.morphLocked + CSPS.rankLocked, 
		}
		local assaultType, assaultLine = GetSkillLineIndicesFromSkillLineId(48)
		if CSPS.skillTable[assaultType][assaultLine][2][3][5] and not CSPS.skillTable[assaultType][assaultLine][2][6][5] then
			
			local nameOldRidingSkill = GetSkillAbilityInfo(assaultType, assaultLine, 3)
			local nameNewRidingSkill = GetSkillAbilityInfo(assaultType, assaultLine, 6)
			local ridingIcons = "|t42:42:esoui/art/icons/ability_ava_002_a.dds|t |t42:42:esoui/art/buttons/large_rightarrow_up.dds|t  |t42:42:esoui/art/icons/ability_weapon_028.dds|t"
			local myQuestion = zo_strformat(GS(CSPS_MSG_AskToSwitchRidingSkills), GetAbilityName(63569), nameOldRidingSkill, nameNewRidingSkill, ridingIcons)
			
			local function askUserToSwitchRidingSkills()
				local function switchRidingSkills()
					CSPS.skillTable[assaultType][assaultLine][2][3][5] = false
					CSPS.skillTable[assaultType][assaultLine][2][3][7] = 0
					CSPS.skillTable[assaultType][assaultLine][2][6][5] = true 
					CSPS.skillTable[assaultType][assaultLine][2][6][3] = 1
					CSPS.skillTable[assaultType][assaultLine][2][6][7] = 1
					local auxListIndex = CSPS.skillTable[assaultType][assaultLine][2][3][8]
	
					if CSPS.skillTable[assaultType][assaultLine][2][3][10][1] ~= nil then 
						CSPS.hbSkillRemove(1, CSPS.skillTable[assaultType][assaultLine][2][3][10][1])
					end
					if CSPS.skillTable[assaultType][assaultLine][2][3][10][2] ~= nil then 
						CSPS.hbSkillRemove(2, CSPS.skillTable[assaultType][assaultLine][2][3][10][2])
					end
					if auxListIndex then CSPS.skillMorphs[auxListIndex] = nil end
					table.insert(CSPS.skillUpgrades, {assaultType, assaultLine, 6, 1})
					CSPS.myTree:RefreshVisible()
				end
				
				ZO_Dialogs_ShowDialog(CSPS.name.."_YesNoDiag", 
				{yesFunc = function() switchRidingSkills() end,
				noFunc = function() end,
				}, 
				{mainTextParams = {zo_strformat(GS(CSPS_MSG_AutoSwitchRidingSkills), nameOldRidingSkill, nameNewRidingSkill, ridingIcons)}}
				) 
			end
			
			ZO_Dialogs_ShowDialog(CSPS.name.."_YesNoDiag", 
				{yesFunc = function() end,
				noFunc = function() ZO_Dialogs_ReleaseAllDialogsOfName(CSPS.name.."_ConfirmApply") askUserToSwitchRidingSkills() end,
				}, 
				{mainTextParams = {myQuestion}}
			) 
		end 
		ZO_Dialogs_ShowDialog(CSPS.name.."_ConfirmApply", nil, {mainTextParams = meineParameter}) 
	end
	
	if CSPS.applyAttr and CSPS.tabEx then CSPS.attrAnwenden() end
	if CSPS.applyCP then CSPS.cpApplyGo() end
end

function CSPS.applyBuildGo()
	for _, myMorph in pairs(CSPS.skillMorphs) do
		local _, _, _, _, _, _, skProg = GetSkillAbilityInfo(myMorph[1], myMorph[2], myMorph[3])
		local _, _, active = GetSkillLineDynamicInfo(myMorph[1], myMorph[2])
		if active then 
			ZO_Skills_PurchaseAbility(myMorph[1], myMorph[2], myMorph[3]) 
			if skProg ~= nil then ZO_Skills_MorphAbility(skProg, myMorph[4]) end
		end
	end
	for _, myUpgrade in pairs(CSPS.skillUpgrades) do
		local skTyp = myUpgrade[1]
		local skLin = myUpgrade[2]
		local skId = myUpgrade[3]
		local skRa = myUpgrade[4]
		local _, _, active = GetSkillLineDynamicInfo(skTyp, skLin)
		if active then
			ZO_Skills_PurchaseAbility(skTyp, skLin, skId) 
			local j = 1
			if skRa == nil then skRa = 0 end
			while j < skRa do
				ZO_Skills_UpgradeAbility(skTyp, skLin, skId) 
				j = j + 1
			end
		end
	end
	
	zo_callLater(function() CSPS.buildCheck() CSPS.myTree:RefreshVisible() end, 500)	
end

function CSPS.cpApplyGo()
		CSPS.cp2ApplyGo()
end

function CSPS.attrSum()
	return GetAttributeSpentPoints(1) + GetAttributeSpentPoints(2) + GetAttributeSpentPoints(3) + GetAttributeUnspentPoints()
end

function CSPS.attrAnwenden()
	local i = CSPS.attrPoints[1] -  GetAttributeSpentPoints(1)
	local j = CSPS.attrPoints[2] -  GetAttributeSpentPoints(2)
	local k = CSPS.attrPoints[3] -  GetAttributeSpentPoints(3)
	if i == 0 and j == 0 and k == 0 then return end
	if i + j + k > GetAttributeUnspentPoints() then	ZO_Dialogs_ShowDialog(CSPS.name.."_CPAttr1") return end --- Are there enough points to spend?
	if i < 0 or j < 0 or k < 0 then ZO_Dialogs_ShowDialog(CSPS.name.."_CPAttr2") return end
	ZO_Dialogs_ShowDialog(CSPS.name.."_CPAttr", nil, {mainTextParams = {i+j+k, GetAttributeUnspentPoints()}}) 
end

function CSPS.attrAnwendenGo()
	PurchaseAttributes(CSPS.attrPoints[1] -  GetAttributeSpentPoints(1), CSPS.attrPoints[2] -  GetAttributeSpentPoints(2)  , CSPS.attrPoints[3] -  GetAttributeSpentPoints(3))
end

function CSPS.hbEmpty(myBar)
	for j=1, 6 do
		if CSPS.hbTables[myBar + 1][j] ~= nil then
			local skTyp = CSPS.hbTables[myBar + 1][j][1]
			local skLin = CSPS.hbTables[myBar + 1][j][2]
			local skId = CSPS.hbTables[myBar + 1][j][2]
			if not skTyp == 0 and skLin == 0 and skId == 0 then
				CSPS.skillTable[skTyp][skLin][2][skId][10] = {}
			end
		end
	end
    CSPS.hbTables[myBar+1] = {}
end


function CSPS.hbRead()
	local hotBarCats = {
		HOTBAR_CATEGORY_PRIMARY,
		HOTBAR_CATEGORY_BACKUP,
		-- HOTBAR_CATEGORY_WEREWOLF,
	}
    for _, myBar in pairs(hotBarCats) do
		CSPS.hbEmpty(myBar)

        for i = 1, 6 do
            local abilityId = GetSlotBoundId(ACTION_BAR_FIRST_NORMAL_SLOT_INDEX + i, myBar)
            if abilityId ~= nil then
				local hasProg, progressionIndex = GetAbilityProgressionXPInfoFromAbilityId(abilityId)
				if hasProg then
					local skTyp, skLin, skId = GetSkillAbilityIndicesFromProgressionIndex(progressionIndex)
					if not (skTyp > 0) then  
						for skTyp = 1, GetNumSkillTypes() do
							for skLin = 1, GetNumSkillLines(skTyp) do
								for skId = 1, GetNumSkillAbilities(skTyp, skLin) do
									local progId = select(7, GetSkillAbilityInfo(skTyp, skLin, skId))
									if progId == progressionIndex then return skTyp, skLin, skId end
								end
							end
						end
					end
					if skTyp > 0 then  
						CSPS.hbTables[myBar+1][i] = {skTyp, skLin, skId} 
						CSPS.skillTable[skTyp][skLin][2][skId][10][myBar+1] =  i
					end
				end
			end
		end
			
    end
end

function CSPS.abortBarSwap()
	CSPSWindowFooterBarSwap:SetHidden(true)
	EVENT_MANAGER:UnregisterForEvent(CSPS.name, EVENT_ACTIVE_WEAPON_PAIR_CHANGED)
end

function CSPS.hbApply()
	local myBarId = GetActiveHotbarCategory() + 1
	if myBarId < 3 then 
		CSPS.applyBar(myBarId, true)
		if myBarId == 1 then myBarId = 2 else myBarId = 1 end
		CSPSWindowFooterBarSwap:SetHidden(false)
		EVENT_MANAGER:RegisterForEvent(CSPS.name, EVENT_ACTIVE_WEAPON_PAIR_CHANGED, function() CSPS.applyBar(myBarId) end)
	end
end

function CSPS.applyBar(myBarId, arg)
	if GetActiveHotbarCategory() == myBarId - 1 or arg == true then
		for i = 1, 6 do
			if CSPS.hbTables[myBarId][i] then
				SlotSkillAbilityInSlot(CSPS.hbTables[myBarId][i][1], CSPS.hbTables[myBarId][i][2], CSPS.hbTables[myBarId][i][3], i+2)
			end
		end
		CSPSWindowFooterBarSwap:SetHidden(true)
		EVENT_MANAGER:UnregisterForEvent(CSPS.name, EVENT_ACTIVE_WEAPON_PAIR_CHANGED)
	end
end

function CSPS.hbPopulate()
	for ind1= 1, 2 do
		local ctrBar = CSPSWindowFooter:GetNamedChild(string.format("Bar%s", ind1))
		for ind2=1,5 do
			local ctrSkill = ctrBar:GetNamedChild(string.format("Icon%s", ind2))
			local ijk = CSPS.hbTables[ind1][ind2]
			if ijk ~= nil then
				ctrSkill:SetTexture(CSPS.skillTable[ijk[1]][ijk[2]][2][ijk[3]][2])
				ctrSkill:SetColor(1,1,1)
			else 
				ctrSkill:SetTexture(nil)
				ctrSkill:SetColor(0.141,0.141,0.141)
			end
		end
		local ctrSkill = ctrBar:GetNamedChild("Icon6")
		local ijk = CSPS.hbTables[ind1][6]
		if ijk ~= nil then	
			ctrSkill:SetTexture(CSPS.skillTable[ijk[1]][ijk[2]][2][ijk[3]][2])
			ctrSkill:SetColor(1,1,1)
		else
			ctrSkill:SetTexture(nil)
			ctrSkill:SetColor(0.141,0.141,0.141)
			
		end
	end
end

function CSPS.carotest42(args)
	d('Congratulations, you found my internal function for testing purposes. Have a good day and remember to always bring a towel! (Irniben)')
	--EVENT_MANAGER:RegisterForEvent("CSPS_LUA_ERROR_CP", EVENT_LUA_ERROR, CSPS.test42b)	
	--blobb = table.concat(blobb)
	--d(blobb)
	--[[
	local arg1, arg2 = SplitString("-", args)
	d(arg1, arg2)
	local disciplineIndex = tonumber(arg1)
	local myStart = tonumber(arg2) or 1
	local aText = {}
	for skInd=myStart, GetNumChampionDisciplineSkills(disciplineIndex) do	
		local skId = GetChampionSkillId(disciplineIndex, skInd)
		local skName = zo_strformat("<<C:1>>", GetChampionSkillName(skId))
		local skLinks = table.concat({GetChampionSkillLinkIds(skId)}, ",")
		local skDesc = zo_strformat(" - <<C:1>> (<<2>>)", GetChampionSkillDescription(skId), table.concat({GetChampionSkillJumpPoints(skId)}, ","))
		skDesc = string.gsub(skDesc, "|cffffff", "")
		skDesc = string.gsub(skDesc, "|r", "")
		table.insert(aText, string.format("%s:%s(%s)", skId, skName, skLinks))
		table.insert(aText, skDesc)
	end
	aText = table.concat(aText, "\n")
	CSPSWindowImportExportTextEdit:SetText(aText)
	
	
	local disciplineIndex = tonumber(args)
	local aText = {}
	for skInd=1, GetNumChampionDisciplineSkills(disciplineIndex) do	
		local skId = GetChampionSkillId(disciplineIndex, skInd)
		local skName = zo_strformat("<<C:1>>", GetChampionSkillName(skId))
		table.insert(aText, string.format("[\"%s\"] = %s,", string.gsub(string.lower(skName), "(%A)", ""), skId))
	end
	aText = table.concat(aText, "\n")
	CSPSWindowImportExportTextEdit:SetText(aText)]]--
end

function CSPS.isShown()
	CSPS.showElement("load") -- Show, if theres data to load
	CSPSWindow:SetHidden(not CSPSWindow:IsHidden())
	if CSPS.freshlyMigrated then 
		CSPS.freshlyMigrated = false
		ZO_Dialogs_ShowDialog(CSPS.name.."_DiagMigriert")
	end
end

 SLASH_COMMANDS["/carotest42"] = CSPS.carotest42
 SLASH_COMMANDS["/csps"] = CSPS.isShown
 EVENT_MANAGER:RegisterForEvent(CSPS.name, EVENT_ADD_ON_LOADED, CSPS.OnAddOnLoaded)