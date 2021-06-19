local mundusLocs = { -- mundus locations for tooltip
	[13984] = { 108,	20, 117}, 	-- shadow
	[13985] = {383, 19, 57}, 		-- tower
	[13940] = {58, 104, 101}, 		-- warrior
	[13974] = {108,	20, 117,}, 		-- serpent
	[13943] = {383, 19, 57 ,}, 		-- mage
	[13976] = {381 ,3, 41 ,}, 		-- lord
	[13977] = {382, 92, 103,}, 		-- steed
	[13978] = {383, 19, 57,}, 		-- lady
	[13979] = {382 ,92, 103,}, 		-- apprentice
	[13980] = {58, 104 ,101,} ,		-- ritual
	[13981] = {381, 3, 41,}, 		-- lover
	[13982] = {108, 20, 117,},		-- atronarch
	[13975] = {58, 104, 101,}, 		-- thief
}


local cpColTex = {
		"esoui/art/champion/champion_points_stamina_icon-hud-32.dds",
		"esoui/art/champion/champion_points_magicka_icon-hud-32.dds",
		"esoui/art/champion/champion_points_health_icon-hud-32.dds",
}

local skMap = CSPSSkillFactoryDBExport.skMap
local cpMap = CSPSSkillFactoryDBExport.cpMap
local muMap = CSPSSkillFactoryDBExport.mundusMap
local raMap = CSPSSkillFactoryDBExport.raceMap
local clMap = CSPSSkillFactoryDBExport.classMap
local alMap = CSPSSkillFactoryDBExport.allianceMap
local basisUrl = ""
local GS = GetString

CSPS.derLink = ""


function CSPS.zeigeLink()
	CSPSWindowImportExportTextEdit:SetText(CSPS.derLink)
	CSPSWindowImportExportTextEdit:SelectAll()
	CSPSWindowImportExportTextEdit:TakeFocus()
end

local function table_invert(t)
   local s={}
   for k,v in pairs(t) do
     s[v]=k
   end
   return s
end

local function getMundus()
	local numBuffs = GetNumBuffs("player")
    for i = 1, numBuffs do
        local _, _, _, _, _, _, _, _, _, _, id = GetUnitBuffInfo("player", i)
		local myId = muMap[id]
		if myId ~= nil then
			return myId, id
		end
	end
	if myId == nil then return "" end
end

local function zeigeMundus(myMundusId)
	local myMundus = "-"
	if myMundusId ~= nil then myMundus = zo_strformat("<<C:1>>", GetAbilityName(myMundusId)) else myMundus = "-" end
	myMundus = {SplitString(":", myMundus)}
	myMundus = myMundus[#myMundus]
	CSPSWindowImportExportMundusValue:SetText(myMundus)
	local _, meineId = getMundus()
	if myMundus ~= "-" and (meineId == nil or meineId ~= myMundusId) then
		CSPSWindowImportExportMundusValue:SetMouseEnabled(true)
		CSPSWindowImportExportMundusValue:SetColor(CSPS.colTbl.orange[1], CSPS.colTbl.orange[2], CSPS.colTbl.orange[3])
		local mLL = mundusLocs[myMundusId]
		local mundusLocText = zo_strformat("<<1>> - <<2>>", GetZoneNameById(mLL[1]), GetZoneNameById(mLL[2]))
		if mLL[3] ~= nil then mundusLocText = zo_strformat("<<1>> - <<2>>", mundusLocText, GetZoneNameById(mLL[3])) end
		CSPSWindowImportExportMundusValue:SetHandler("OnMouseEnter", function() ZO_Tooltips_ShowTextTooltip(CSPSWindowImportExportMundusValue, RIGHT, mundusLocText) end)
		CSPSWindowImportExportMundusValue:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
	elseif meineId == myMundusId then
		CSPSWindowImportExportMundusValue:SetColor(CSPS.colTbl.green[1], CSPS.colTbl.green[2], CSPS.colTbl.green[3])
		CSPSWindowImportExportMundusValue:SetHandler("OnMouseEnter", function() end)
	else
		CSPSWindowImportExportMundusValue:SetColor(CSPS.colTbl.white[1], CSPS.colTbl.white[2], CSPS.colTbl.white[3])
		CSPSWindowImportExportMundusValue:SetHandler("OnMouseEnter", function() end)
	end
end


function CSPS.generateLink()
	if not CSPS.tabEx and not CSPS.tabExHalf then CSPSWindowImportExportTextEdit:SetText(GetString(CSPS_ImpEx_NoData)) return end
	if CSPS.formatImpExp == "txtCP2_1" then
		CSPS.checkTextExportCP(1)
		return
	elseif CSPS.formatImpExp == "txtCP2_2" then
		CSPS.checkTextExportCP(2)
		return
	elseif CSPS.formatImpExp == "txtCP2_3" then
		CSPS.checkTextExportCP(3)
		return
	end
	if not CSPS.tabEx then CSPSWindowImportExportTextEdit:SetText(GetString(CSPS_ImpEx_NoData)) return end
	if CSPS.formatImpExp == "sf" then 
		CSPS.generateLinkSF()
		CSPS.zeigeLink()
	elseif CSPS.formatImpExp == "txtCP1" then
		CSPS.generateTextCP1()
	elseif CSPS.formatImpExp == "txtSk1" then
		CSPS.generateTextSkills(1)
	elseif CSPS.formatImpExp == "txtSk2" then
		CSPS.generateTextSkills(2)
	elseif CSPS.formatImpExp == "txtSk3" then
		CSPS.generateTextSkills(3)
	elseif CSPS.formatImpExp == "txtOd" then
		CSPS.generateTextOther()
	end
end

function CSPS.importLink(ctrl, shift, alt)
	if CSPS.formatImpExp == "sf" then 
		CSPS.importLinkSF()
	elseif CSPS.formatImpExp == "csvCP" then
		CSPS.importListCP()
	elseif CSPS.formatImpExp == "txtCP2_1" then
		CSPS.importTextCP(1, ctrl and shift, alt)
	elseif CSPS.formatImpExp == "txtCP2_2" then
		CSPS.importTextCP(2, ctrl and shift, alt)
	elseif CSPS.formatImpExp == "txtCP2_3" then
		CSPS.importTextCP(3, ctrl and shift, alt)
		
	end
end

function CSPS.generateTextCP1()
	local cpIndex = 7
	local CP_Kat = {GS(CSPS_CP_BLUE), GS(CSPS_CP_RED), GS(CSPS_CP_GREEN)}
	local myText = {}
	for i=1, 3 do
		table.insert(myText, CP_Kat[i])
		for j=1, 3 do
			table.insert(myText, string.format(" - %s", GS("CSPS_oldCPStar", cpIndex)))
			for k=1, 4  do
				table.insert(myText, string.format("   - %s: %s", GS("CSPS_oldCPSkill", (cpIndex-1)*4+k), CSPS.cpTable[cpIndex][k]))
			end
			cpIndex = cpIndex - 1
			if cpIndex == 0 then cpIndex = 9 end
		end
	end
	myText = table.concat(myText, "\n")
	CSPSWindowImportExportTextEdit:SetText(myText)
end

function CSPS.generateTextSkills(txtIndex)
	local myText = {}
	local myStart = {1, 4, 8}
	myStart = myStart[txtIndex]
	local myEnd = {3, 7, 8}
	myEnd = myEnd[txtIndex]
	for i, v in pairs(CSPS.skillTable) do
		if i >= myStart and i <= myEnd then
			local typeTable = {string.format(CSPS.skillTypeNames[i])}
			local typeHasEntries = false
			for j, w in pairs(v) do
				local lineTable = {}
				local lineHasEntries = false
				for k, z in pairs(w[2]) do
					if z[5] then
						typeHasEntries = true
						lineHasEntries = true
						local myName = string.format("    - %s", z[1])
						if IsSkillAbilityPassive(i,j,k) then myName = string.format("    - %s (%s)", z[1], z[3]) end
						table.insert(lineTable, myName)
					end
				end
				if lineHasEntries then 
					table.insert(typeTable, string.format(" - %s", CSPS.skillTable[i][j][1]))
					table.insert(typeTable, table.concat(lineTable, "\n"))
				end
			end
			if typeHasEntries then
				table.insert(myText, table.concat(typeTable, "\n"))
			end
		end	
	end
	myText = table.concat(myText, "\n")
	CSPSWindowImportExportTextEdit:SetText(myText)
end

function CSPS.generateTextOther()
	local myTable = {zo_strformat("<<C:1>>", GetUnitName("player"))}

	table.insert(myTable, zo_strformat("<<C:1>>", GetRaceName(GetUnitGender('player'), GetUnitRaceId('player'))))
	table.insert(myTable, zo_strformat("<<C:1>>", GetAllianceName(GetUnitAlliance('player'))))
	table.insert(myTable, zo_strformat("<<C:1>>", GetClassName(GetUnitGender('player'), GetUnitClassId('player'))))
	local myAttributes = {GS(SI_STATS_ATTRIBUTES)}
	table.insert(myAttributes, string.format(" - %s: %s", GS(SI_ATTRIBUTES1), CSPS.attrPoints[1]))
	table.insert(myAttributes, string.format(" - %s: %s", GS(SI_ATTRIBUTES2), CSPS.attrPoints[2]))
	table.insert(myAttributes, string.format(" - %s: %s", GS(SI_ATTRIBUTES3), CSPS.attrPoints[3]))
	myAttributes = table.concat(myAttributes, "\n")
	table.insert(myTable, myAttributes)
	local _, myMundus = getMundus()
	if myMundus ~= nil then myMundus = zo_strformat("<<C:1>>", GetAbilityName(myMundus)) else myMundus = "-" end
	table.insert(myTable, myMundus)
	for i=1, 2 do
		table.insert(myTable, string.format("%s %s:", GS(CSPS_ImpEx_HbTxt), i))
		for j=1, 6 do
			local mySkill = CSPS.hbTables[i][j]
			if mySkill ~= nil then 
				mySkill = string.format("   %s) %s", j, CSPS.skillTable[mySkill[1]][mySkill[2]][2][mySkill[3]][1])
			else
				mySkill = string.format("   %s) -", j)
			end
		table.insert(myTable, mySkill)
		end
	end
	myTable = table.concat(myTable, "\n")
	CSPSWindowImportExportTextEdit:SetText(myTable)
end

function CSPS.generateLinkSF()	
	local lang = string.lower(GetCVar("Language.2"))
	if lang ~= "en" and lang ~= "de" and lang ~= "fr" then lang = "en" end -- use only available languae-domains
	basisUrlTab = {
		["en"] = "https://www.eso-skillfactory.com/en/build-planer/#",
		["de"] = "https://www.eso-skillfactory.com/de/skillplaner/#",
		["fr"] = "https://www.eso-skillfactory.com/fr/planificateur-de-talents/#",
	}
	basisUrl = basisUrlTab[lang]

	-- Alliance, Race, Class, Attributes
	local lnkRahmen = string.format("f%s,r%s,c%s", alMap[GetUnitAlliance("player")] or 0, raMap[GetUnitRaceId("player")] or 0, clMap[GetUnitClassId("player")] or 0)
	-- Skills
	local lnkSkTab = {lnkRahmen}
	for i, skTyp in pairs(CSPS.skillTable) do
		for j, skLin in pairs(skTyp) do
			for k, skId in pairs(skLin[2]) do
				if skId[5] == true then
					local myRank = skId[3]
					if myRank == nil then myRank = 0 end
					local myId = GetSpecificSkillAbilityInfo(i,j,k,skId[6],1)
					myId = skMap[myId]
					if myId ~= nil then
						table.insert(lnkSkTab, string.format("%s:%s", myId,myRank))
					else
						d(string.format("[CSPS] %s", zo_strformat(GetString(CSPS_ImpEx_ErrSk), skId[1])))
					end
				end
			end
		end
	end
	local hbTab = {}
	if CSPS.hbTables ~= nil and CSPS.hbTables ~= {} then
		for ind1= 1, 2 do
			hbTab[ind1] = {}
			for ind2=1,6 do
				local ijk = CSPS.hbTables[ind1][ind2]
				if ijk ~= nil then
					local myId = GetSpecificSkillAbilityInfo(ijk[1],ijk[2],ijk[3],CSPS.skillTable[ijk[1]][ijk[2]][2][ijk[3]][6],1)
					myId = skMap[myId]
					if myId ~= nil then
						table.insert(hbTab[ind1], myId)
					else
						table.insert(hbTab[ind1], 0)
					end
				else 
					table.insert(hbTab[ind1], 0)
				end
				
			end
		end
	else
		hbTab = {{"", "", "", "", "", ""}, {"","","","","",""}}
	end
	-- Read CP
	local cpTable = {}
	for i, cpLin in pairs (CSPS.cpTable) do
		for j, cpSkill in pairs (cpLin) do
			local myId = GetChampionAbilityId(i, j)
			myId = cpMap[myId]
			if myId ~= nil then
				table.insert(cpTable, string.format("%s:%s", myId, cpSkill))
			end
		end
	end
	-- Generate the whole link 
	local linkTable = { } 
	linkTable[1] = table.concat(lnkSkTab, ",") -- includes alliance/race/class because they are separated by , not ;
	linkTable[2] = table.concat(hbTab[1], ":") -- Hotbar 1
	linkTable[3] = table.concat(hbTab[2], ":")  -- Hotbar 2
	
	linkTable[4] = getMundus()
	linkTable[5] = string.format("%s,%s,%s", CSPS.attrPoints[2], CSPS.attrPoints[1], CSPS.attrPoints[3])
	linkTable[6] = "0,0,0" -- armorpieces light medium heavy
	linkTable[7] = table.concat(cpTable, ",") -- cp as id:number
	linkTable[8] = string.format("%s,%s,%s", CSPS.cpColorSum[3], CSPS.cpColorSum[1], CSPS.cpColorSum[2])-- cp-sums green blue red
	linkTable[9] = "0,0" -- weapons
	linkTable[10] = "" -- placeholder to close with a ;
	local linkParam = table.concat(linkTable, ";")
	CSPS.derLink = string.format("%s%s", basisUrl, linkParam)
	--CSPSWindowImportExportTextEdit:SetText(CSPS.derLink)
end

function importSkills(auxTable)
	if auxTable == {} then return end
	CSPS.skillMorphs = {}
	local anzMorphs = 0
	CSPS.skillUpgrades = {}
	local anzUpgrades = 0
	CSPS.populateTable(true)
	for i, skTyp in pairs(auxTable) do
		for j, skLin in pairs(skTyp) do
			for k, skId in pairs(skLin) do
				local name, texture = "", ""
				local myPoints = 0
				local maxRaMo = false
				local zlIndex = 0
				if not IsSkillAbilityPassive(i,j,k) then -- has morph
					anzMorphs = anzMorphs + 1
					zlIndex = anzMorphs
					CSPS.skillMorphs[anzMorphs] = {i, j, k, skId[1]}
					name = GetAbilityName(GetSpecificSkillAbilityInfo(i,j,k,skId[1],1))
					texture = GetAbilityIcon(GetSpecificSkillAbilityInfo(i,j,k,skId[1],1))
					if skId[1] == 2 then maxRaMo = true end
					myPoints = myPoints + 1 - CSPS.getSpecialPassives(i, j, k) 
					if skId[1] > 0 then myPoints = myPoints + 1	end
				else
					local _, maxRank = GetSkillAbilityUpgradeInfo(i,j,k)
					if maxRank == nil then 
						maxRank = 0 
						skId[2] = 0
					end
					if skId[2] >= maxRank then maxRaMo = true end
					skId[1] = nil -- Otherwise all passives would be treated as morphable
					anzUpgrades = anzUpgrades + 1
					zlIndex = anzUpgrades
					CSPS.skillUpgrades[anzUpgrades] = {i, j, k, skId[2]}
					name, texture = GetSkillAbilityInfo(i, j, k)
					myPoints = myPoints + 1 - CSPS.getSpecialPassives(i, j, k) 
					myPoints = myPoints + skId[2] - 1
					
				end
				name = zo_strformat("<<C:1>>", name)
				CSPS.skTypeCountPT[i] = CSPS.skTypeCountPT[i] or 0
				CSPS.skTypeCountPT[i] = CSPS.skTypeCountPT[i] + myPoints 
				CSPS.skLineCountPT[i][j] = CSPS.skLineCountPT[i][j] or 0
				CSPS.skLineCountPT[i][j] = CSPS.skLineCountPT[i][j] + myPoints
				local skEntry = CSPS.skillTable[i][j][2][k]
				skEntry[1] = name
				skEntry[2] = texture
				skEntry[3] = skId[2] -- Rang
				-- 4: progressionid
				skEntry[5] = true
				skEntry[6] = skId[1]
				skEntry[7] = myPoints
				skEntry[8] = zlIndex
				skEntry[9] = maxRaMo	
				CSPS.skillTable[i][j][2][k] = skEntry
			end
		end
	end
	CSPS.setSumMP(anzMorphs, anzUpgrades)
	CSPS.unsavedChanges = true
	CSPS.buildCheck()	
end

function CSPS.importLinkSF()
	local derLink = CSPSWindowImportExportTextEdit:GetText()
	if derLink == nil or derLink == "" then return end
	local lnkParameter = {SplitString("#", derLink)}
	if lnkParameter == nil or #lnkParameter < 2 then return end
	lnkParameter = lnkParameter[2]
	lnkParameter = string.gsub(lnkParameter, ';;', ';-;')
	lnkParameter = {SplitString(";", lnkParameter)}
	CSPS.lnkParameter = lnkParameter
	local muMapBw = table_invert(muMap) -- invert the mapping-tables
	local skMapBw = table_invert(skMap)
	local alMapBw = table_invert(alMap)
	local cpMapBw = table_invert(cpMap)
	local raMapBw = table_invert(raMap)
	local clMapBw = table_invert(clMap)
	if lnkParameter[1] == nil or lnkParameter[1] == "-" then d('[CSPS] No Parameter 1') return end
	local lnkSkTab = {SplitString(",", lnkParameter[1])}
	if #lnkSkTab < 3 then d('[CSPS] Missing parameters') return end
	local lnkRahmen = {}
	for i=1, 3 do
		local rahmenVar = SplitString("flrc", lnkSkTab[i])
		lnkRahmen[i] = tonumber(rahmenVar) or 0
	end
	local myAlliance = alMapBw[lnkRahmen[1]]
	local myRace = raMapBw[lnkRahmen[2]]
	local myClass = clMapBw[lnkRahmen[3]]
	CSPS.impExpAddInfo(myAlliance, myRace, myClass)
	local raceCorrect = true
	if GetUnitRaceId('player') ~= myRace then raceCorrect = false end
	local classCorrect = true
	if GetUnitClassId('player') ~= myClass then classCorrect = false end
	local auxTable = {}
	if #lnkSkTab > 4 then
		for i=4, #lnkSkTab do
			local abilityId, myRank = SplitString(":", lnkSkTab[i])
			abilityId = skMapBw[tonumber(abilityId)]
			if abilityId ~= nil then
				local skTyp, skLin, skId, morph, rank = GetSpecificSkillAbilityKeysByAbilityId(abilityId)	
				if not ((skTyp==1 and classCorrect == false) or (skTyp==7 and raceCorrect == false)) then
					if auxTable[skTyp] == nil then auxTable[skTyp] = {} end
					if auxTable[skTyp][skLin] == nil then auxTable[skTyp][skLin] = {} end
					if CSPS.costsNoRank(skTyp, skLin, skId) then myRank = 0 end -- guild-passives without a rank
					auxTable[skTyp][skLin][skId] = {morph, tonumber(myRank)}
				end
			end
		end
	end
	importSkills(auxTable)
	if lnkParameter[2] ~= nil and  lnkParameter[3] ~= nil and lnkParameter[2] ~= "-" and  lnkParameter[3] ~= "-"   then
		-- Hotbar
		for ind1= 1, 2 do
			CSPS.hbEmpty(ind1-1)
			local lnkHbTab = {SplitString(":", lnkParameter[ind1+1])}
			if #lnkHbTab == 6 then
				CSPS.hbTables[ind1] = {}
				for ind2=1,6 do
					local myId = skMapBw[tonumber(lnkHbTab[ind2])]
					if myId ~= nil then
						local i, j, k, morph, rank = GetSpecificSkillAbilityKeysByAbilityId(myId)
						if i == 1 and j > 3 then
							CSPS.hbTables[ind1][ind2] = nil
						else
							CSPS.hbTables[ind1][ind2] = {i, j, k}
							CSPS.skillTable[i][j][2][k][10][ind1] = ind2
						end
					else
						CSPS.hbTables[ind1][ind2] = nil
					end
				end
			else
				d(string.format("[CSPS] %s", zo_strformat(GetString(CSPS_ImpEx_ErrHb), ind1)))
			end
		end
		CSPS.hbPopulate()
	end
	local myMundus = tonumber(lnkParameter[4])
	myMundus = muMapBw[myMundus]
	zeigeMundus(myMundus)
	--5 Attribute
	local myAttributes = {SplitString(",", lnkParameter[5])}
	CSPS.attrPoints[2] = tonumber(myAttributes[1]) or 0
	CSPS.attrPoints[1] = tonumber(myAttributes[2]) or 0
	CSPS.attrPoints[3] = tonumber(myAttributes[3]) or 0
	--6 Armorpieces
	--7 CP,8 Cp sums
	-- Summen deleted since no longer needed
	
	--9 Weapons
	if not CSPS.tabEx then CSPS.createTable()	end		
	CSPS.myTree:RefreshVisible() 
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
end

local transferLevels = {}

function CSPS.transferProfile(cpPSub)
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	local myTable
	if not cpPSub then 
		if transferLevels[4] == 0 then
			myTable = CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"][transferLevels[3]]
		else
			myTable = CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"][transferLevels[3]]["profiles"][transferLevels[4]]
		end
		
		if myTable == nil then return end
		
		if myTable.werte == nil then d(string.format("[CSPS] %s", GS(CSPS_NoSavedData))) return end
	elseif cpPSub == 1 then
		myTable = CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"][transferLevels[3]]["cpProfiles"][transferLevels[4]]
	elseif cpPSub == 2 then
		myTable = CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"][transferLevels[3]]["cpHbProfiles"][transferLevels[4]]
	end
	if not cpPSub then
		local skillTableClean = myTable.werte
		local attrComp = myTable.attribute
		local hbComp = myTable.hbwerte
		CSPS.tableExtract(skillTableClean.prog, skillTableClean.pass)
		CSPS.hbTables = CSPS.hbExtract(hbComp)
		CSPS.hbLinkToSkills(CSPS.hbTables)
		CSPS.hbPopulate()
		CSPS.attrExtract(attrComp)
		CSPS.buildCheck()
	end
	
	if cpPSub ~= 2 then
		local cp2Comp = ""
		if not cpPSub then cp2Comp = myTable.cp2werte or "" else cp2Comp = myTable.cpComp or "" end
		CSPS.cp2Extract(cp2Comp)
	end
	local cp2HbComp = ""
	if not cpPSub then cp2HbComp = myTable.cp2hbwerte or "" else cp2HbComp = myTable.hbComp or "" end
	CSPS.cp2HbTable = CSPS.cp2HbExtract(cp2HbComp)
	
	if not CSPS.tabEx then 
		if cpPSub ~= nil then
			if not CSPS.tabExHalf then CSPS.createTable(true) end
		else
			CSPS.createTable() 
		end
	end
	for i=1,3 do
		CSPS.cp2HbIcons(i)
	end
	CSPS.cp2UpdateHbMarks()
	
	CSPS.myTree:RefreshVisible() 
	CSPS.unsavedChanges = false
	CSPS.toggleImportExport(false)
end


function CSPS.transferCPProfile()
	CSPS.transferProfile(1)
end

function CSPS.transferCPHbProfile()
	CSPS.transferProfile(2)
end

function CSPS.transferBindingsDiag(keepThem)
	local sourceName = CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"][transferLevels[3]]["$lastCharacterName"]
	local destName = CSPS.currentCharData["$lastCharacterName"]
	ZO_Dialogs_ShowDialog(CSPS.name.."_YesNoDiag", 
				{yesFunc = function() CSPS.transferBindings(keepThem) end,
				noFunc = function() end,
				}, 
				{mainTextParams = {zo_strformat(GS(CSPS_ImpExp_TransConfirm), sourceName, destName)}}
				) 
end

function CSPS.transferBindings(keepThem)
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	local myTableBd = CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"][transferLevels[3]]["bindings"]
	local myTableHk = CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"][transferLevels[3]]["cp2hbpHotkeys"]
	local myTableHb = CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"][transferLevels[3]]["cpHbProfiles"]
	local myMappings = {}
	local takenInd = 0
	if not keepThem then CSPS.currentCharData.cpHbProfiles = {} end
	for i, _ in pairs(CSPS.currentCharData.cpHbProfiles) do
		if i > takenInd then takenInd = i end
	end
	for i, v in pairs(myTableHb) do
		local newIndex = i + takenInd
		CSPS.currentCharData.cpHbProfiles[newIndex] = v
	end
	for i=1, 20 do
		CSPS.cp2hbpHotkeys[i] = {}
	end
	for i, v in pairs(myTableHk) do
		for j, w in pairs(v) do
			CSPS.cp2hbpHotkeys[i][j] = w + takenInd
		end
	end
	ZO_DeepTableCopy(myTableBd,  CSPS.bindings)
	CSPS.currentCharData.cp2hbpHotkeys = CSPS.cp2hbpHotkeys 
	CSPS.currentCharData.bindings = CSPS.bindings
	CSPS.initConnect()
end


function CSPS.updateTransferCombo(myLevel)
	if myLevel == nil then return end
	
	local ctrNames = {"Server", "Account", "Char", "Profiles", "CPProfiles", "CPHbProfiles"}
	local myControl = CSPSWindowImportExportTransfer:GetNamedChild(ctrNames[myLevel])
	local myButton = CSPSWindowImportExportTransfer:GetNamedChild(ctrNames[myLevel].."Btn")
	local myPromptNames = {
		GS(CSPS_ImpExp_Transfer_Server).."...", 
		GS(SI_CURRENCYLOCATION3).."...", 		-- Account
		GS(SI_CURRENCYLOCATION0).."...", 		-- Character
		GS(CSPS_ImpExp_Transfer_Profiles),
		GS(CSPS_ImpExp_Transfer_CPP),
		GS(CSPS_ImpExp_Transfer_CPHb)
		}
		
	local selectPrompt = myPromptNames[myLevel]
		-- tooltip 
	myControl.data = {tooltipText = selectPrompt}
	myControl:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
	myControl:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)
	myControl.comboBox = myControl.comboBox or ZO_ComboBox_ObjectFromContainer(myControl)
	local myComboBox = myControl.comboBox
	myComboBox:ClearItems()
	local choices = {}
	if CSPSSavedVariables == nil then return end
	for i=4, 6 do
		CSPSWindowImportExportTransfer:GetNamedChild(ctrNames[i].."Btn"):SetHidden(true)
	end
	if myLevel < 4 then
		for i=4, 6 do
			CSPSWindowImportExportTransfer:GetNamedChild(ctrNames[i]):SetHidden(true)
			CSPSWindowImportExportTransfer:GetNamedChild(ctrNames[i].."Btn"):SetHidden(true)
		end
		CSPSWindowImportExportTransfer:GetNamedChild("CPHkCopyReplace"):SetHidden(true)
		CSPSWindowImportExportTransfer:GetNamedChild("CPHkCopyAdd"):SetHidden(true)
	end
	if myLevel < 3 then	CSPSWindowImportExportTransfer:GetNamedChild(ctrNames[3]):SetHidden(true) end
	if myLevel < 2 then	CSPSWindowImportExportTransfer:GetNamedChild(ctrNames[2]):SetHidden(true) end
	-- CSPSSavedVariables["EU Megaserver"]["@Irniben"]["$AccountWide"]["charData"]
	
	-- Nothing is selected, filling the server list
	if myLevel == 1 then	
		for i, _ in pairs(CSPSSavedVariables) do
			choices[i] = i
		end
	-- Server selected, fill account list
	elseif myLevel == 2 then
		for i, _ in pairs(CSPSSavedVariables[transferLevels[1]]) do
			choices[i] = i
		end

	-- Account selected, fill char list
	elseif myLevel == 3 then
		for i, v in pairs(CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"]) do
			local myName = v["$lastCharacterName"]
		    if myName ~= nil then choices[myName] = i end
		end
	
	-- Char selected, fill and show the profile lists etc.
	elseif myLevel == 4 then
		choices["Standard"] = 0
		if CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"][transferLevels[3]]["profiles"] ~= nil then
			for i, v in pairs(CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"][transferLevels[3]]["profiles"]) do
				local myName = v["name"]
				if myName ~= nil then choices[myName] = i end
			end	
		end
		
		CSPSWindowImportExportTransfer:GetNamedChild("CPHkCopyReplace"):SetHidden(false)
		CSPSWindowImportExportTransfer:GetNamedChild("CPHkCopyAdd"):SetHidden(false)
	elseif myLevel == 5 then
		if CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"][transferLevels[3]]["cpProfiles"] ~= nil then
			for i, v in pairs(CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"][transferLevels[3]]["cpProfiles"]) do
				local myName = v["name"]
				if myName ~= nil then 
					myName = string.format("|t25:25:%s|t %s", cpColTex[v["discipline"]], myName)
					choices[myName] = i 
				end
			end	
		end
	elseif myLevel == 6 then
		if CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"][transferLevels[3]]["cpHbProfiles"] ~= nil then
			for i, v in pairs(CSPSSavedVariables[transferLevels[1]][transferLevels[2]]["$AccountWide"]["charData"][transferLevels[3]]["cpHbProfiles"]) do
				local myName = v["name"]
				if myName ~= nil then 
					myName = string.format("|t25:25:%s|t %s", cpColTex[v["discipline"]], myName)
					choices[myName] = i 
				end
			end	
		end
	end
	myControl:SetHidden(false)	
	local function OnItemSelect(_, choiceText, _)
		local myGroup = choices[choiceText] or nil
		transferLevels[myLevel] = myGroup
		if myLevel < 4 then CSPS.updateTransferCombo(myLevel + 1) end
		if myLevel == 3 then
			CSPS.updateTransferCombo(5) 
			CSPS.updateTransferCombo(6) 
		end
		if myLevel > 3 then 
			myButton:SetHidden(false)
			myButton:SetText(GS(CSPS_ImpExp_TransferLoad))
		end
		PlaySound(SOUNDS.POSITIVE_CLICK)
	end

	myComboBox:SetSortsItems(true)
	
	for i,j in pairs(choices) do
		myComboBox:AddItem(myComboBox:CreateItemEntry(i, OnItemSelect))
	end
	myComboBox:SetSelectedItem(selectPrompt)
end
