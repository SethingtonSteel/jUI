local GS = GetString
local cpSlT = {
		"esoui/art/champion/actionbar/champion_bar_world_selection.dds",
		"esoui/art/champion/actionbar/champion_bar_combat_selection.dds",
		"esoui/art/champion/actionbar/champion_bar_conditioning_selection.dds",
}
local cpColHex = {"A6D852", "5CBDE7", "DE6531" }
local cpProfDis = 1
local cpProfType = 1
local cpColTex = {
		"esoui/art/champion/champion_points_stamina_icon-hud-32.dds",
		"esoui/art/champion/champion_points_magicka_icon-hud-32.dds",
		"esoui/art/champion/champion_points_health_icon-hud-32.dds",
}
local zoneAbbr = {
	[636] = "HRC",
	[638] = "AA",
	[639] = "SO",
	[635] = "DSA",
	[677] = "MA",
	[725] = "MoL",
	[975] = "HoF",
	[1000] = "AS",
	[1051] = "CR",
	[1121] = "SS",
	[1196] = "KA",
	[1082] = "BRP",
	[1227] = "VH",
}

local roleFilter = ""

local roleAbbr = {
	[1] = "DD",
	[2] = "T",
	[3] = "", -- invalid
	[4] = "H",
}

local classAbbr = {
	[1] = "DK",
	[2] = "Sorc",
	[3] = "NB",
	[4] = "Warden",
	[5] = "Necro",
	[6] = "Temp",
}

local changedCP = false

local roles = {"DD", GS(CSPS_CPP_Tank), "", GS(SI_LFGROLE4), "DD(Mag)", "DD(Stam)", GS(SI_GEMIFIABLEFILTERTYPE0)}

local resizingNow = false

CSPS.customCpIcons = {
	[76] = "esoui/art/icons/ability_thievesguild_passive_004.dds",			-- Friends in Low Places
	[77] = "esoui/art/icons/ability_legerdemain_sly.dds",					-- Infamous
	[80] = "esoui/art/icons/ability_darkbrotherhood_passive_001.dds", 		-- Shadowstrike
	[90] = "esoui/art/icons/ability_legerdemain_lightfingers.dds", 			-- Cutpurse's Art
	[84] = "esoui/art/icons/ability_thievesguild_passive_002.dds",				-- Fade Away 
	[78] = "esoui/art/notifications/gamepad/gp_notification_craftbag.dds", 	-- Master Gatherer 
	[79] = "esoui/art/icons/ability_thievesguild_passive_001.dds", 			-- Treasure Hunter
	[85] = "esoui/art/icons/ability_provisioner_002.dds", 					-- Rationer
	[86] = "esoui/art/icons/ability_alchemy_006.dds", 						-- Liquid Efficiency
	[89] = "esoui/art/icons/crafting_fishing_salmon.dds", 					-- Angler's Instincts
	[88] = "esoui/art/icons/achievements_indexicon_fishing_down.dds", 		-- Reel Technique
	[91] = "esoui/art/crafting/provisioner_indexicon_furnishings_down.dds", -- Homemaker
	[81] = "esoui/art/icons/crafting_flower_corn_flower_r1.dds", 			-- Plentiful Harvest 
	[82] = "esoui/art/mounts/ridingskill_stamina.dds", 						-- War Mount 
	[92] = "esoui/art/mounts/tabicon_mounts_down.dds", 						-- Gifted Rider 
	[83] = "esoui/art/tutorial/inventory_trait_intricate_icon.dds", 		-- Meticulous Disassembly
	[66] = "esoui/art/icons/ability_darkbrotherhood_passive_004.dds", 		-- Steed's Blessing 
	[65] = "esoui/art/icons/ability_armor_007.dds", 						-- Sustaining Shadows 
	[1] = "esoui/art/repair/inventory_tabicon_repair_up.dds", 				-- Professional Upkeep 

	[259] = "esoui/art/icons/ability_templar_005.dds",						-- Weapons Expoert
	[264] = "esoui/art/icons/ability_sorcerer_024.dds",						-- Master at arms
	[260] = "esoui/art/icons/ability_templar_017.dds",						-- Salve of Renewal
	[261] = "esoui/art/icons/ability_templar_021.dds",						-- Hope Infusion
	[262] = "esoui/art/icons/ability_templar_032.dds",						-- From the brink
	[263] = "esoui/art/icons/ability_templar_028.dds",						-- Enlivening Overflow
	[12] = "esoui/art/icons/ability_sorcerer_045.dds", 						-- Fighting Finesse 
	[24] = "esoui/art/icons/ability_templar_016.dds", 						-- Soothing tide
	[9] = "esoui/art/icons/ability_templar_011.dds", 						-- Rejuvenator
	[163] = "esoui/art/icons/ability_alchemy_004.dds",	 					-- Foresight
	[29] = "esoui/art/icons/ability_templar_006.dds", 						-- Cleansing Revival 
	[26] = "esoui/art/icons/ability_templar_004.dds", 						-- Focused Mending
	[28] = "esoui/art/icons/ability_templar_008.dds", 						-- Swift Renewal
	[25] = "esoui/art/icons/ability_vampire_007.dds", 						-- Deadly Aim
	[23] = "esoui/art/icons/ability_sorcerer_006.dds",	 					-- Biting Aura 
	[27] = "esoui/art/icons/ability_sorcerer_004.dds", 						-- Thaumaturge
	[30] = "esoui/art/icons/ability_templar_002.dds",						-- Reaving Blows 
	[8] = "esoui/art/icons/ability_weapon_019.dds", 						-- Wrathful Strikes
	[32] = "esoui/art/icons/ability_sorcerer_010.dds",	 					-- Occult Overload 
	[31] = "esoui/art/icons/ability_weapon_023.dds", 						-- Backstabber
	[13] = "esoui/art/icons/ability_weapon_028.dds", 						-- Resilience
	[136] = "esoui/art/icons/ability_weapon_024.dds", 						-- Enduring Resolve 
	[160] = "esoui/art/icons/ability_psijic_010.dds",						-- Reinforced
	[162] = "esoui/art/icons/ability_armor_013.dds", 						-- Riposte
	[159] = "esoui/art/icons/ability_dragonknight_020.dds", 				-- Bulwark
	[161] = "esoui/art/icons/ability_werewolf_008.dds", 					-- Last Stand
	[33] = "esoui/art/icons/ability_dragonknight_031.dds", 					-- Cutting Defense
	[134] = "esoui/art/icons/ability_armor_014.dds", 						-- Duelist's Rebuff 
	[133] = "esoui/art/icons/ability_dragonknight_029.dds", 				-- Unassailable
	[5] = "esoui/art/icons/ability_scrying_05a.dds", 						-- Endless Endurance
	[4] = "esoui/art/icons/ability_scrying_05d.dds",	 					-- Untamed Aggression
	[3] = "esoui/art/icons/ability_scrying_05b.dds", 						-- Arcane Supremacy

	[62] = "esoui/art/icons/ability_armor_009.dds", 						-- Rousing Speed
	[57] = "esoui/art/icons/ability_thievesguild_passive_005.dds",			-- Survival Instincts 
	[46] = "esoui/art/icons/ability_armor_005.dds", 						-- Bastion
	[61] = "esoui/art/icons/ability_armor_008.dds", 						-- Arcane Alacrity
	[56] = "esoui/art/icons/ability_templar_026.dds", 						-- Spirit Mastery
	[49] = "esoui/art/icons/ability_templar_029.dds", 						-- Strategic Reserve
	[63] = "esoui/art/icons/ability_templar_027.dds", 						-- Shield Master 
	[48] = "esoui/art/icons/ability_weapon_021.dds", 						-- Bloody Renewal 
	[47] = "esoui/art/icons/ability_weapon_006.dds", 						-- Siphoning Spells
	[60] = "esoui/art/icons/ability_armor_012.dds", 						-- On Guard 
	[51] = "esoui/art/icons/ability_armor_010.dds", 						-- Expert Evasion 
	[52] = "esoui/art/icons/ability_armor_006.dds", 						--  Slippery
	[64] = "esoui/art/icons/ability_darkbrotherhood_passive_002.dds",		-- Unchained
	[59] = "esoui/art/icons/ability_dragonknight_021.dds", 					-- Juggernaut
	[54] = "esoui/art/icons/ability_armor_015.dds", 						-- Peace of Mind 
	[55] = "esoui/art/icons/ability_darkbrotherhood_passive_003.dds", 		-- Hardened
	[35] = "esoui/art/icons/ability_dragonknight_024.dds", 					-- Rejuvenation
	[34] = "esoui/art/icons/ability_dragonknight_034.dds", 					-- Ironclad
	[2] = "esoui/art/icons/ability_scrying_05c.dds", 						-- Boundless Vitality
}

local newProfileBringToTop = nil
local waitingForCpPurchase = false
local cancelAnimation = false
local numMapSuccessful = 0
local unmappedSkills = {}
local mappingIndex = 1
local cpSkillToMap = nil
local cpDisciToMap = nil
local numRemapped = 0
local mappingUnclear = {}
local numMapUnclear = 0
local numMapCleared = 0
local skillsToImport = {}
local skillsToSlot = {}
local markedToSlot = {}
local slotMarkers = false
local lastZoneName = ""

function CSPS.getTrialArenaList()
	local myTrials = {}
	for i, _ in pairs(zoneAbbr) do
		local myName = zo_strformat("<<C:1>>", GetZoneNameById(i))
		myTrials[myName] = i
	end
	return myTrials
end

local function getLayer(layerLists)
	local newList = {}
	local newLayerX = {}
	for _, aList in pairs(layerLists) do
		for _, v in pairs(aList) do
			if not CSPS.auxListDone[v] == true then
				table.insert(newList, v)
				local newSubList = {GetChampionSkillLinkIds(v)}
				table.insert(newLayerX, newSubList)
				CSPS.auxListDone[v] = true
			end
		end
	end
	return newList, newLayerX
end

function CSPS.cp2createPseudoCluster()
	CSPS.cp2List = {
		[1] = {1, 67, 74, 69, 87, 68, 88},
		[2] = {3, 11, 99, 6, 31, 10, 108, 20},
		[3] = {2, 37, 38, 39, 62, 42, 51, 113, 43},
	}
	CSPS.cp2ListCluster = {
		[1] = {1, 65, 66},
		[87] = {87, 70, 71, 72, 75, 83, 79, 78, 85, 86, 92, 81, 91, 82},
		[68] = {68, 76, 77, 80, 90, 84},
		[88] = {88, 89},
		[3]= {3, 4, 5},
		[108] = {108, 26, 28, 24, 29, 9, 163},
		[31] = {31, 32, 8, 30, 12},
		[20] = {20, 13, 14, 15, 16, 134, 136, 133, 162, 159, 160, 161, 33},
		[10] = {10, 23, 25, 27, 18, 22, 17, 21},
		[2] = {2, 34, 35},
		[51] = {51, 128, 54, 55, 59, 52, 64},
		[43] = {43, 44, 60, 40, 50},
		[113] = {113, 53, 47, 48, 49, 57, 45, 63, 58, 46, 56, 61},
	}
	CSPS.cp2ClustNames = { 
		--Green
		[1] = "Grundwerte",
		[87] = "Offene Welt",
		[68] = "Lug und Trug",
		[88] = "Angeln",
		--Blue
		[3] = "Grundwerte",
		[108] = "Heilung",
		[31] = "Schaden allgemein",
		[20] = "Defensive",
		[10] = "Schadenstypen",
		-- Red
		[2] = "Basestats",
		[51] = "Ausweichen/Freibrechen",
		[43] = "Blocken/Schild",
		[113] = "Ressourcen",
	}

end

function CSPS.cp2createAlphabetical()
	CSPS.cp2List = {[1]={}, [2]={}, [3]={}}
	CSPS.cp2ListCluster = {}
	CSPS.cp2ClustNames = {}
	for disciplineIndex = 1, 3 do
		local myListA = {}
		local myListB = {}
		for skInd=1, GetNumChampionDisciplineSkills(disciplineIndex) do	
			local skId = GetChampionSkillId(disciplineIndex, skInd)
			local myName = GetChampionSkillName(skId)
			myListA[myName] = skId
			table.insert(myListB, myName)
		end
		table.sort(myListB)
		for i, v in ipairs(myListB) do
			table.insert(CSPS.cp2List[disciplineIndex], myListA[v])
		end
	end
end

function CSPS.testCP()
	CSPS.showCpIds = true
	CSPS.cp2createPseudoCluster()
	CSPS.cp2fillTable()
	CSPS.myTree:Reset()
	CSPS.cp2Controls = {}
	CSPS.cp2ClusterControls = {}
	CSPS.createTable(true)
end

function CSPS.testCP2()
	CSPS.showCpIds = true
	CSPS.cp2createAlphabetical()
	CSPS.cp2fillTable()
	CSPS.myTree:Reset()
	CSPS.cp2Controls = {}
	CSPS.cp2ClusterControls = {}
	CSPS.createTable(true)
end

function CSPS.cp2fillTable()
	CSPS.cp2Table = CSPS.cp2Table or {}
	CSPS.auxListDone = {}
	CSPS.cp2ClustRoots = {}
	for disciplineIndex = 1, 3 do
		for i, v in ipairs(CSPS.cp2List[disciplineIndex]) do
			CSPS.auxListDone[v] = true
			local skType = GetChampionSkillType(v) + 1
			CSPS.cp2List[disciplineIndex][i] = {v, skType}
			if CSPS.cp2ListCluster[v] ~= nil then
				CSPS.cp2List[disciplineIndex][i][2] = 4
				for j, w in pairs(CSPS.cp2ListCluster[v]) do
					local skType = GetChampionSkillType(w) + 1
					CSPS.auxListDone[w] = true
					CSPS.cp2ClustRoots[w] = v
					CSPS.cp2ListCluster[v][j] = {w, skType}
				end
			end
		end
		CSPS.cp2RootLists[disciplineIndex] = {}
		for skInd=1, GetNumChampionDisciplineSkills(disciplineIndex) do	
			local skId = GetChampionSkillId(disciplineIndex, skInd)
			local skType = GetChampionSkillType(skId) + 1
			CSPS.cp2Disci[skId] = disciplineIndex
			if not CSPS.auxListDone[skId] then table.insert(CSPS.cp2List[disciplineIndex], {skId, skType}) end
			if IsChampionSkillRootNode(skId) then table.insert(CSPS.cp2RootLists[disciplineIndex], skId) end
		end
	end
end

function CSPS.cp2CreateTable()
	CSPS.cp2Table = CSPS.cp2Table or {}
	CSPS.cp2List = {[1] = {}, [2] = {}, [3] = {}}
	CSPS.cp2ListCluster = {}
	CSPS.cp2Disci = {}
	CSPS.cp2ClustRoots = {}
	CSPS.cp2ClustNames = {}
	CSPS.cp2ClustActive = {}
	for disciplineIndex = 1, 3 do
		local myList = CSPS.cp2List[disciplineIndex]
		local discplineId = GetChampionDisciplineId(disciplineIndex)
		
		local auxListDiscipline = {}
		local auxListBasestats = {}
		local auxListRoot = {}
		local auxListCluster = {}
		CSPS.auxListDone = {}
		
		for skInd=1, GetNumChampionDisciplineSkills(disciplineIndex) do	
			local skId = GetChampionSkillId(disciplineIndex, skInd)
			local skType = GetChampionSkillType(skId) + 1	-- normal, slottable, statpool (also slottable) - in my version also 4: cluster root
			local isUnlocked = false
			if IsChampionSkillRootNode(skId) or skType == 3 then isUnlocked = true end -- root nodes and basestats are always unlocked
			CSPS.cp2Table[skId] = CSPS.cp2Table[skId] or {isUnlocked, 0} -- profile values saved by ID (unlocked as boolean, points invested as number)
			CSPS.cp2Disci[skId] = disciplineIndex
			if IsChampionSkillClusterRoot(skId) then				
				CSPS.cp2ListCluster[skId] = {{skId, skType}}
				CSPS.cp2ClustRoots[skId] = skId
				CSPS.cp2ClustNames[skId] = zo_strformat("<<C:1>>", GetChampionClusterName(skId))
				CSPS.cp2ClustActive[skId] = false
				for i, v in pairs({GetChampionClusterSkillIds(skId)}) do
					table.insert(CSPS.cp2ListCluster[skId], {v, GetChampionSkillType(v) + 1})
					CSPS.cp2ClustRoots[v] = skId
					if v ~= skId then CSPS.auxListDone[v] = true end
				end
			end
			if IsChampionSkillRootNode(skId) and skType ~= 3 then 				
				table.insert(auxListRoot, skId)
				--CSPS.auxListDone[skId] = true
			end
			if skType == 3 then				
				table.insert(auxListBasestats, skId)
				CSPS.auxListDone[skId] = true
			end
		end	
		local auxListLayer = {}
		auxListLayer[1] = {}
		local auxListLayer1, newLayer = getLayer({auxListRoot})
		auxListLayer[1] = auxListLayer1
		local layInd = 1
		while #newLayer > 0 do
			layInd = layInd + 1
			auxListLayer[layInd], newLayer = getLayer(newLayer, CSPS.auxListDone)
		end
		for i, v in pairs(auxListBasestats) do
			table.insert(myList, {v, 3})
		end
		for _, aList in pairs(auxListLayer) do
			for i, v in pairs(aList) do
				local skType =  GetChampionSkillType(v) + 1
				if IsChampionSkillClusterRoot(v) then skType = 4 end
				table.insert(myList, {v, skType})
			end
		end
		CSPS.cp2RootLists[disciplineIndex] = auxListRoot
		CSPS.cp2List[disciplineIndex] = myList
	end

end

local function unlockLinked(myList, auxPunkte)
	for i, v in pairs(myList) do
		if CSPS.cp2ClustRoots[v] then CSPS.cp2ClustActive[CSPS.cp2ClustRoots[v]] = true end
		if CSPS.cp2Table[v][1] == false then
			CSPS.cp2Table[v][1] = true
			CSPS.cp2Table[v][2] = auxPunkte[v]
			if WouldChampionSkillNodeBeUnlocked(v, CSPS.cp2Table[v][2]) then
				unlockLinked({GetChampionSkillLinkIds(v)}, auxPunkte)
			end
		end
	end
end

function CSPS.cp2ReCheckHotbar(disciplineIndex)
	for i=1, 4 do
		local mySk = CSPS.cp2HbTable[disciplineIndex][i]
		if mySk ~= nil then
			if not WouldChampionSkillNodeBeUnlocked(mySk, CSPS.cp2Table[mySk][2]) then
				CSPS.cp2HbTable[disciplineIndex][i] = nil
			end
		end
	end
	CSPS.cp2HbIcons(disciplineIndex)
end

function CSPS.cp2UpdateHbMarks()
	CSPS.cp2InHb = {}
	for i=1, 3 do
		for j=1,4 do
			if CSPS.cp2HbTable[i][j] ~= nil then CSPS.cp2InHb[CSPS.cp2HbTable[i][j]] = true end
		end
	end
end
	
function CSPS.clickCPIcon(myId, mouseButton)
	if mouseButton == 2 then
		if CSPS.cp2InHb[myId] then
			local myDiscipline = CSPS.cp2Disci[myId]
			local mySlot = 0
			for i=1, 4 do
				if CSPS.cp2HbTable[myDiscipline][i] == myId then mySlot = i end
			end
			if mySlot > 0 then CSPS.CpHbSkillRemove(myDiscipline, mySlot) end
		end
	end
end


function CSPS.HbRearrange()
	local mySize = CSPS.savedVariables.settings.hbsize or 28
	local mySpace = mySize * 0.12
	if CSPS.cpCustomBar == 1 then							-- 1x12
		CSPSCpHotbar:SetWidth(12 * mySize + 17 * mySpace) 
		CSPSCpHotbar:SetHeight(mySize + 2 * mySpace)
		CSPSCpHotbar:SetDimensionConstraints(346, 30, 1384, 120) -- minX minY maxX maxY	
	elseif CSPS.cpCustomBar == 2 then						-- 3x4
		CSPSCpHotbar:SetWidth(4 * mySize + 5 * mySpace)
		CSPSCpHotbar:SetHeight(3 * mySize + 4 * mySpace)
		CSPSCpHotbar:SetDimensionConstraints(120, 90, 480, 360) 
	else												-- 1x4
		CSPSCpHotbar:SetWidth(4 * mySize + 5 * mySpace)
		CSPSCpHotbar:SetHeight(mySize + 2 * mySpace)
		CSPSCpHotbar:SetDimensionConstraints(120, 30, 480, 120)
	end
	CSPS.myCPBar = CSPS.myCPBar or {}
	for i=1,3 do
		CSPS.myCPBar[i] = CSPS.myCPBar[i] or {}
		for j=1,4 do
			if (CSPS.cpCustomBar ~= 3 or i == 1) then
				CSPS.myCPBar[i][j] = CSPS.myCPBar[i][j] or nil
				if CSPS.myCPBar[i][j] == nil then
					CSPS.myCPBar[i][j] = WINDOW_MANAGER:CreateControlFromVirtual("CSPSCpHotbarSlot"..i.."_"..j, CSPSCpHotbar, "CSPSHbPres" )
					CSPS.myCPBar[i][j]:GetNamedChild("Circle"):SetTexture(cpSlT[i])
					if i == 1 then CSPS.myCPBar[i][j]:GetNamedChild("Circle"):SetColor(0.8235, 0.8235, 0) end	-- re-color the not-so-green circle for the green cp...
				else
					CSPS.myCPBar[i][j]:ClearAnchors()
				end
				CSPS.myCPBar[i][j]:SetHidden(false)
				if CSPS.cpCustomBar == 1 then
					CSPS.myCPBar[i][j]:SetAnchor(TOPLEFT, CSPS.myCPBar[i][j]:GetParent(), TOPLEFT, mySpace + ((i - 1) * 4  + j - 1) * (mySize + mySpace) + 2 * mySpace * (i - 1), mySpace)
				else
					CSPS.myCPBar[i][j]:SetAnchor(TOPLEFT, CSPS.myCPBar[i][j]:GetParent(), TOPLEFT, mySpace + (j - 1) * (mySize + mySpace), (i-1) * mySize + i * mySpace)
				end
				CSPS.myCPBar[i][j]:SetDimensions(mySize, mySize)
				CSPS.myCPBar[i][j]:GetNamedChild("Circle"):SetDimensions(mySize, mySize)
				CSPS.myCPBar[i][j]:GetNamedChild("Icon"):SetDimensions(mySize * 0.73, mySize * 0.73)
			else
				if CSPS.myCPBar[i][j] ~= nil then CSPS.myCPBar[i][j]:SetHidden(true) end
			end
		end
	end
	if CSPS.cpCustomBar then CSPS.showCpBar() end
end

function CSPS.HbSize(forceResize)
	if not resizingNow and not forceResize then return end
	local barWindow = WINDOW_MANAGER:GetControlByName("CSPSCpHotbar")
	if not CSPS or not CSPS.savedVariables then return end
	
	-- Fitting the icons to the new width
	local mySize  = barWindow:GetWidth() * 0.075
	local mySpace = (barWindow:GetWidth() - 12 * mySize) / 17
	if CSPS.cpCustomBar ~= 1 then
		mySize = barWindow:GetWidth() * 0.23
		mySpace = (barWindow:GetWidth() - 4 * mySize) / 5
	end
	CSPS.savedVariables.settings.hbsize = mySize
	
	-- Adjusting the height of the hotbar
	if CSPS.cpCustomBar == 1 then	-- 1x12
		barWindow:SetHeight(mySize + 2 * mySpace)
	elseif CSPS.cpCustomBar == 2 then	-- 3x4
		barWindow:SetHeight(3*mySize + 4*mySpace)
	else	-- 1x4
		barWindow:SetHeight(mySize + 2 * mySpace)
	end
	
	-- Adjusting the anchors of the icons
	CSPS.myCPBar = CSPS.myCPBar or {}
	for i=1,3 do
		CSPS.myCPBar[i] = CSPS.myCPBar[i] or {}
		for j=1,4 do
			if (CSPS.cpCustomBar ~= 3 or i == 1) then
				if CSPS.cpCustomBar == 1 then 
					CSPS.myCPBar[i][j]:SetAnchor(TOPLEFT, CSPS.myCPBar[i][j]:GetParent(), TOPLEFT, mySpace + ((i - 1) * 4  + j - 1) * (mySize + mySpace) + 2 * mySpace * (i - 1), mySpace)
				else
					CSPS.myCPBar[i][j]:SetAnchor(TOPLEFT, CSPS.myCPBar[i][j]:GetParent(), TOPLEFT, mySpace + (j - 1) * (mySize + mySpace), (i-1) * mySize + i * mySpace)
				end
				CSPS.myCPBar[i][j]:SetDimensions(mySize, mySize)
				CSPS.myCPBar[i][j]:GetNamedChild("Circle"):SetDimensions(mySize, mySize)
				CSPS.myCPBar[i][j]:GetNamedChild("Icon"):SetDimensions(mySize * 0.73, mySize * 0.73)
			end
		end
	end
end

function CSPS.HbResizing(control, isResizingNow)
	resizingNow = isResizingNow 
	control:GetNamedChild("BG"):SetHidden(not isResizingNow)
end


function CSPS.OnHotbarMoveStop() 
	CSPS.savedVariables.settings.hbleft = CSPSCpHotbar:GetLeft()
	CSPS.savedVariables.settings.hbtop = CSPSCpHotbar:GetTop()
end

function CSPS.showCpBar()
	for i=1,3 do
		for j=1,4 do
			local mySlot = (i-1) * 4 + j
			local mySk = GetSlotBoundId(mySlot, HOTBAR_CATEGORY_CHAMPION)
			if (CSPS.cpCustomBar ~= 3 or i == 1) then
				if mySk ~= nil and mySk ~= 0 then
					if CSPS.useCustomIcons and CSPS.customCpIcons[mySk] ~= nil then 
						if CSPS.cpCustomBar then CSPS.myCPBar[i][j]:GetNamedChild("Icon"):SetTexture(CSPS.customCpIcons[mySk]) end
						local myZoIcon = WINDOW_MANAGER:GetControlByName(string.format("ZO_ChampionPerksActionBarSlot%sIcon", mySlot))
						if myZoIcon ~= nil then myZoIcon:SetTexture(CSPS.customCpIcons[mySk]) end
					else
						if CSPS.cpCustomBar then CSPS.myCPBar[i][j]:GetNamedChild("Icon"):SetTexture("esoui/art/champion/champion_icon_32.dds") end
					end
					if CSPS.cpCustomBar then 
						CSPS.myCPBar[i][j]:GetNamedChild("Icon"):SetHidden(false)
						CSPS.myCPBar[i][j]:GetNamedChild("Circle"):SetHandler("OnMouseEnter", function() CSPS.showCpTT(CSPS.myCPBar[i][j], mySk, GetNumPointsSpentOnChampionSkill(mySk), true, false) end)
					end
				else
					if CSPS.cpCustomBar then 
						CSPS.myCPBar[i][j]:GetNamedChild("Icon"):SetHidden(true)
						CSPS.myCPBar[i][j]:GetNamedChild("Circle"):SetHandler("OnMouseEnter", function() end)
					end
				end
			else
				local myZoIcon = WINDOW_MANAGER:GetControlByName(string.format("ZO_ChampionPerksActionBarSlot%sIcon", mySlot))
				if myZoIcon ~= nil and mySk ~= nil and mySk > 0 then myZoIcon:SetTexture(CSPS.customCpIcons[mySk]) end
			end
		end
	end
end

function CSPS.showCpTT(control, myId, myValue, withTitle, hotbarExplain)
	InitializeTooltip(InformationTooltip, control, LEFT)
	local myTooltip = myId and GetChampionSkillDescription(myId)
	local myCurrentBonus = myValue and GetChampionSkillCurrentBonusText(myId, myValue) or ""
	if withTitle or true then
		InformationTooltip:AddLine(zo_strformat("<<C:1>>", GetChampionSkillName(myId)), "ZoFontWinH2")
		if  CSPS.useCustomIcons and CSPS.customCpIcons[myId] ~= nil then InformationTooltip:AddLine(string.format("\n|t48:48:%s|t\n", CSPS.customCpIcons[myId]), "ZoFontGame") end
		ZO_Tooltip_AddDivider(InformationTooltip)
	end
	if myId then InformationTooltip:AddLine(myTooltip, "ZoFontGame") end
	if myCurrentBonus ~= "" then InformationTooltip:AddLine(myCurrentBonus, "ZoFontGameBold", ZO_SUCCEEDED_TEXT:UnpackRGBA() ) end
	if hotbarExplain then 
		InformationTooltip:AddLine(GS(CSPS_Tooltip_CPBar), "ZoFontGame")
	else
		local myActualValue = GetNumPointsSpentOnChampionSkill(myId)
		if myValue and myValue ~= myActualValue then
			ZO_Tooltip_AddDivider(InformationTooltip)
			InformationTooltip:AddLine(zo_strformat(GS(CSPS_CPPCurrentlyApplied), myActualValue), "ZoFontGame")
			if myActualValue ~= 0 then 
				local myActualBonus = GetChampionSkillCurrentBonusText(myId, myActualValue) or ""
				if myActualBonus ~= "" then InformationTooltip:AddLine(myActualBonus, "ZoFontGame", unpack(CSPS.colTbl.orange)) end
			end
		end
	end
end
 
function CSPS.cp2HbIcons(disciplineIndex)
	local myBar = CSPS.cp2HbTable[disciplineIndex]
	local changeOrderRev = {3, 1, 2}
	for i=1, 4 do
		local myCtrl = CSPSWindowCP2Bar:GetNamedChild("Icon"..changeOrderRev[disciplineIndex].."_"..i.."b")
		local myCtrla = CSPSWindowCP2Bar:GetNamedChild("Icon"..changeOrderRev[disciplineIndex].."_"..i)
		local myCtrlLabel = CSPSWindowCP2Bar:GetNamedChild("Label"..changeOrderRev[disciplineIndex].."_"..i)
		if myBar[i] ~= nil then
			myCtrl:SetHidden(false)
			if CSPS.useCustomIcons and CSPS.customCpIcons[myBar[i]] then 
				myCtrl:SetTexture(CSPS.customCpIcons[myBar[i]])
			else
				myCtrl:SetTexture("esoui/art/champion/champion_icon_32.dds")
			end
			
			local myName = zo_strformat("|c<<1>><<C:2>>|r", cpColHex[disciplineIndex], GetChampionSkillName(myBar[i]))
			myCtrlLabel:SetText(myName)

			myCtrla:SetHandler("OnMouseEnter", function()  CSPS.showCpTT(myCtrla, myBar[i], CSPS.cp2Table[myBar[i]][2], true, true) end) 
			myCtrla:SetHandler("OnMouseExit", function () ZO_Tooltips_HideTextTooltip() end)
		else
			myCtrlLabel:SetText("")
			myCtrl:SetHidden(true)
			myCtrla:SetHandler("OnMouseEnter", function() ZO_Tooltips_ShowTextTooltip(myCtrla, RIGHT, GS(CSPS_Tooltip_CPBar)) end)
			myCtrla:SetHandler("OnMouseExit", function () ZO_Tooltips_HideTextTooltip() end)
		end
	end
end

function CSPS.onCpDrag(skId, disciplineIndex)
	CSPS.cpForHB = {skId, disciplineIndex}
end

function CSPS.onCpHbIconDrag(disciplineIndex, icon)
	if CSPS.cp2HbTable[disciplineIndex][icon] ~= nil then
		CSPS.cpForHB = {CSPS.cp2HbTable[disciplineIndex][icon], disciplineIndex}
	end
end

function CSPS.onCpHbIconReceive(disciplineIndex, icon)
	if CSPS.cpForHB == nil then return end 
	if CSPS.cpForHB[2] ~= disciplineIndex then return end 
	if not WouldChampionSkillNodeBeUnlocked(CSPS.cpForHB[1], CSPS.cp2Table[CSPS.cpForHB[1]][2]) then return end
	for i=1, 4 do
		if CSPS.cp2HbTable[disciplineIndex][i] == CSPS.cpForHB[1] then CSPS.cp2HbTable[disciplineIndex][i] = nil end
	end
	CSPS.cp2HbTable[disciplineIndex][icon] = CSPS.cpForHB[1]
	CSPS.cpForHB = nil
	CSPS.cp2HbIcons(disciplineIndex)
	CSPS.cp2UpdateHbMarks()
	CSPS.myTree:RefreshVisible()
	CSPS.unsavedChanges = true
	changedCP = true
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
end

function CSPS.CpHbSkillRemove(disciplineIndex, icon)
	if CSPS.cp2HbTable[disciplineIndex][icon] ~= nil then
		CSPS.cp2HbTable[disciplineIndex][icon] = nil	
		CSPS.cp2HbIcons(disciplineIndex)		
		CSPS.cp2UpdateHbMarks()
		CSPS.unsavedChanges = true
		CSPS.showElement("apply", true)
		CSPS.showElement("save", true)
		changedCP = true
		CSPS.myTree:RefreshVisible()
	end
end


function CSPS.cp2UpdateSum(disciplineIndex)
	local auxSum = 0
	for i=1, GetNumChampionDisciplineSkills(disciplineIndex) do
		auxSum = auxSum + CSPS.cp2Table[GetChampionSkillId(disciplineIndex, i)][2]
	end
	CSPS.cp2ColorSum[disciplineIndex] = auxSum
end

function CSPS.cp2UpdateSumClusters()
	for myId, myList in pairs(CSPS.cp2ListCluster) do
		local auxSum = 0
		for i,v in pairs(myList) do
			auxSum = auxSum + CSPS.cp2Table[v[1]][2]
		end
		CSPS.cp2ClusterSum[myId] = auxSum
	end
end

function CSPS.cp2UpdateUnlock(disciplineIndex)
	local auxPunkte = {}
	for i, v in pairs(CSPS.cp2ClustActive) do
		if CSPS.cp2Disci[i] == disciplineIndex and not IsChampionSkillRootNode(i) then CSPS.cp2ClustActive[i] = false end
	end
	for i, v in pairs(CSPS.cp2Table) do
		if CSPS.cp2Disci[i] == disciplineIndex and not IsChampionSkillRootNode(i) then 
			v[1] = false 
			auxPunkte[i] = v[2]
			v[2] = 0
		end
	end
	for i, v in pairs(CSPS.cp2RootLists[disciplineIndex]) do
		if WouldChampionSkillNodeBeUnlocked(v, CSPS.cp2Table[v][2]) then
			unlockLinked({GetChampionSkillLinkIds(v)}, auxPunkte)
		end
	end
end

function CSPS.cp2BtnPlusMinus(skId, x, shift)
	local oldValue = CSPS.cp2Table[skId][2]
	if shift == true then x = x * 10 end
	local myValue = oldValue + x
	if shift == true and DoesChampionSkillHaveJumpPoints(skId) then
		myValue = 0
		for _, v in pairs({GetChampionSkillJumpPoints(skId)}) do
			if x > 0 then 
				if v > oldValue and myValue == 0 then myValue = v end
			else 
				if v < oldValue then myValue = v end
			end
		end
		
	end	
	if myValue < 0 then myValue = 0 end
	if myValue > GetChampionSkillMaxPoints(skId) then myValue = GetChampionSkillMaxPoints(skId) end
	
	CSPS.cp2Table[skId][2] = myValue
	if WouldChampionSkillNodeBeUnlocked(skId, oldValue) ~= WouldChampionSkillNodeBeUnlocked(skId, myValue) then 
		CSPS.cp2UpdateUnlock(CSPS.cp2Disci[skId]) 
	end
	
	CSPS.cp2UpdateSum(CSPS.cp2Disci[skId])
	CSPS.cp2UpdateSumClusters()
	CSPS.cp2ReCheckHotbar(CSPS.cp2Disci[skId])
	CSPS.cp2UpdateHbMarks()
	CSPS.unsavedChanges = true
	changedCP = true
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	CSPS.myTree:RefreshVisible()
end

function CSPS.cp2ResetTable(disciFilter)
	-- Sets all entries to zero points and locked if not root
	for i, v in pairs(CSPS.cp2ClustActive) do
		if not disciFilter or disciFilter == CSPS.cp2Disci[i] then
			CSPS.cp2ClustActive[i] = false
		end
	end
	for skId, v in pairs(CSPS.cp2Table) do
		if not disciFilter or disciFilter == CSPS.cp2Disci[skId] then
			local skType = GetChampionSkillType(skId) + 1
			local isUnlocked = false
			if IsChampionSkillRootNode(skId) or skType == 3 then 
				isUnlocked = true 
				if CSPS.cp2ClustRoots[skId] then CSPS.cp2ClustActive[CSPS.cp2ClustRoots[skId]] = true end
			end		
			CSPS.cp2Table[skId] = {isUnlocked, 0}
		end
	end
end

function CSPS.cp2ReadCurrent()
	CSPS.cp2ResetTable()
	for skId, v in pairs(CSPS.cp2Table) do
		local myPoints = GetNumPointsSpentOnChampionSkill(skId)
		v[2] = myPoints
		if WouldChampionSkillNodeBeUnlocked(skId, myPoints) then
			if CSPS.cp2ClustRoots[skId] then CSPS.cp2ClustActive[CSPS.cp2ClustRoots[skId]] = true end
			v[1] = true
			for i, v in pairs({GetChampionSkillLinkIds(skId)}) do
				CSPS.cp2Table[v][1] = true
			end
		end
	end
	for i=1, 3 do
		for j=1, 4 do
			local mySk = GetSlotBoundId((i-1) * 4 + j, HOTBAR_CATEGORY_CHAMPION)
			if mySk ~= 0 then 
				CSPS.cp2HbTable[i][j] = mySk
			else
				CSPS.cp2HbTable[i][j] = nil
			end
		end
	end
	for i=1, 3 do
		CSPS.cp2UpdateSum(i)
	end
	CSPS.cp2UpdateSumClusters()
	--if CSPS.tabEx  then
		for i=1,3 do
			CSPS.cp2UpdateUnlock(i) 
			CSPS.cp2HbIcons(i)
		end
	--end
	CSPS.cp2UpdateHbMarks()
	changedCP = false
end

local function cp2SingleBarCompress(myBar)
	local cp2BarComp = {}
	for j=1,4 do
		cp2BarComp[j] = myBar[j] or "-"
	end
	cp2BarComp = table.concat(cp2BarComp, ",")
	return cp2BarComp
end

function CSPS.cp2HbCompress(myTable)
	local cp2HbComp = {}
	for i=1, 3 do
		cp2HbComp[i] = cp2SingleBarCompress(myTable[i])
	end
	cp2HbComp = table.concat(cp2HbComp, ";")
	return cp2HbComp
end

function CSPS.cp2SingleBarExtract(cp2BarComp)

	local barTable = {}
	local auxHb1 = {SplitString(",", cp2BarComp)}
	for j, v in pairs(auxHb1) do
		if v ~= "-" then barTable[j] = tonumber(v) else barTable[j] = nil end		
	end	
	
	return barTable
end

function CSPS.cp2HbExtract(cp2HbComp)
	local cp2HbTable = {{},{},{}}
	cp2HbComp = cp2HbComp or ""
	if cp2HbComp ~= "" then
		local auxHb = {SplitString(";", cp2HbComp)}
		cp2HbTable = {}
		for i=1, 3 do
			cp2HbTable[i] = CSPS.cp2SingleBarExtract(auxHb[i])
		end
	end
	return cp2HbTable
end

function CSPS.cp2Compress(myTable)
	local cp2Comp = {}
	for skId, v in pairs(myTable) do
		if v[2] > 0 then table.insert(cp2Comp, string.format("%s-%s", skId, v[2])) end
	end
	cp2Comp = table.concat(cp2Comp, ";")
	return cp2Comp
end

function CSPS.cp2Extract(cp2Comp, disciFilter)
	CSPS.cp2ResetTable(disciFilter)
	if cp2Comp ~= "" then
		local myTable = {SplitString(";", cp2Comp)}
		for i, v in pairs(myTable) do
			local skId, myValue = SplitString("-", v)
			skId = tonumber(skId)
			myValue = tonumber(myValue)
			if myValue > GetChampionSkillMaxPoints(skId) then myValue = GetChampionSkillMaxPoints(skId) end
			CSPS.cp2Table[skId][2] = myValue
		end
		CSPS.cp2UpdateUnlock(1)
		CSPS.cp2UpdateUnlock(2)
		CSPS.cp2UpdateUnlock(3)		
	end
	for i=1, 3 do
		CSPS.cp2UpdateSum(i)
	end
	CSPS.cp2UpdateSumClusters()
end

local function cp2RespecNeeded()
	-- Check if a respec is needed for the current cp-build
	local respecNeeded = false
	local pointsNeeded = {0,0,0}
	local enoughPoints = {true, true, true}
	for skId, v in pairs(CSPS.cp2Table) do
		local myDisc = CSPS.cp2Disci[skId]
		if CSPS.applyCPc[myDisc] and GetNumPointsSpentOnChampionSkill(skId) < v[2] then pointsNeeded[myDisc] = pointsNeeded[myDisc] + v[2] - GetNumPointsSpentOnChampionSkill(skId) end
	end
	for i=1,3 do
		if pointsNeeded[i] > GetNumUnspentChampionPoints(GetChampionDisciplineId(i)) then respecNeeded = true end
		if pointsNeeded[i] > GetNumSpentChampionPoints(GetChampionDisciplineId(i)) + GetNumUnspentChampionPoints(GetChampionDisciplineId(i)) then enoughPoints[i] = false end
	end
	return respecNeeded, enoughPoints, pointsNeeded
end

function CSPS.cp2ApplyGo()
	if CSPS.cp2Table == nil or CSPS.cp2Table == {} then return end
	-- Do I have enough points, do I need to respec, do I need points at all?
	local respecNeeded, enoughPoints, pointsNeeded = cp2RespecNeeded()
	if enoughPoints[1] == false or enoughPoints[2] == false or enoughPoints[3] == false then 
        ZO_Dialogs_ShowDialog(CSPS.name.."_CpPurchConf", nil, {mainTextParams = {GS(CSPS_MSG_CpPointsMissing)}})   
		return 
	end
	if respecNeeded and GetCurrencyAmount(CURT_MONEY, CURRENCY_LOCATION_CHARACTER) < GetChampionRespecCost() then
		ZO_Dialogs_ShowDialog(CSPS.name.."_CpPurchConf", nil, {mainTextParams = {GS(SI_TRADING_HOUSE_ERROR_NOT_ENOUGH_GOLD)}})   
		return 
	end
	local myDisciplines = {GS(CSPS_MSG_CpPurchChosen)}
	for i=1,3 do
		if CSPS.applyCPc[i] then table.insert(myDisciplines, zo_strformat(" |t24:24:<<1>>|t |c<<2>><<3>>: <<4>>|r", cpColTex[i], cpColHex[i], GetChampionDisciplineName(GetChampionDisciplineId(i)), pointsNeeded[i])) end
	end
	table.insert(myDisciplines, " ")
	local myCost = respecNeeded and GetChampionRespecCost() or 0
	table.insert(myDisciplines, zo_strformat(GS(CSPS_MSG_CpPurchCost), myCost))
	table.insert(myDisciplines, " ")
	table.insert(myDisciplines, GS(CSPS_MSG_CpPurchNow)) 
	myDisciplines = table.concat(myDisciplines, "\n")
	
	ZO_Dialogs_ShowDialog(CSPS.name.."_CpPurch", {respecNeeded = respecNeeded} , {mainTextParams = {myDisciplines}}) 
	
	
end



function CSPS.onCPChange(_, result)
	if result > 0 then return end
	if waitingForCpPurchase then d(string.format("[CSPS] %s", GS(CSPS_CPApplied))) waitingForCpPurchase = false end
	if CSPS.cpCustomBar then CSPS.showCpBar() end
end

function CSPS.cp2ApplyConfirm(respecNeeded, hotbarsOnly)
	-- Did a general check for respeccing before the dialog - hotbarsOnly as an array containing booleans for each hotbar
	PrepareChampionPurchaseRequest(respecNeeded)
	if hotbarsOnly == nil then
		for i,v in pairs(CSPS.cp2Table) do
			if respecNeeded or GetNumPointsSpentOnChampionSkill(i) < v[2] then 
				if CSPS.applyCPc[CSPS.cp2Disci[i]] then AddSkillToChampionPurchaseRequest(i, v[2]) end
			end
		end
	end
	hotbarsOnly = hotbarsOnly or {}	
	local unslottedSkills = {}
	
	for i, v in pairs(CSPS.cp2HbTable) do
		if (CSPS.applyCPc[i] and #hotbarsOnly == 0) or hotbarsOnly[i] == true then
			local skToSlot = {}
			for j=1, 4 do
				local hbSkill = v[j]
				if hbSkill then skToSlot[hbSkill] = true end
			end
			for j=1, 4 do
				local hbSkill = v[j]
				if hbSkill then
					if not WouldChampionSkillNodeBeUnlocked(hbSkill, GetNumPointsSpentOnChampionSkill(hbSkill)) and not WouldChampionSkillNodeBeUnlocked(hbSkill, CSPS.cp2Table[hbSkill][2]) then 
						table.insert(unslottedSkills, hbSkill)
						hbSkill = nil
					end
				else
					local altSkill = GetSlotBoundId((i-1) * 4 + j, HOTBAR_CATEGORY_CHAMPION)
					if not skToSlot[altSkill] then hbSkill = altSkill end
				end	
				AddHotbarSlotToChampionPurchaseRequest((i-1) * 4 + j, hbSkill)
			end
		end
	end
	local result = GetExpectedResultForChampionPurchaseRequest()
    if result ~= CHAMPION_PURCHASE_SUCCESS then
        if #hotbarsOnly == 0 then 
				ZO_Dialogs_ShowDialog(CSPS.name.."_CpPurchConf", nil, {mainTextParams = {GS("SI_CHAMPIONPURCHASERESULT", result)}})
			else
				d(string.format("[CSPS] %s", GS("SI_CHAMPIONPURCHASERESULT", result)))
		end
        return
    end
	
	if CHAMPION_PERKS_SCENE:GetState() == "shown" then 
		CHAMPION_PERKS:PrepareStarConfirmAnimation()
		cancelAnimation = false
	else
		cancelAnimation = true
	end
	ZO_PreHook(CHAMPION_PERKS, "StartStarConfirmAnimation", function()
		--if  CHAMPION_PERKS_SCENE:GetState() == "hidden" then 
		if cancelAnimation then
			cancelAnimation = false
			return true 
		end
	end)
	waitingForCpPurchase = true
	
	SendChampionPurchaseRequest()
	local confirmationSound
    if respecNeeded then
        confirmationSound = SOUNDS.CHAMPION_RESPEC_ACCEPT
    else
        confirmationSound = SOUNDS.CHAMPION_POINTS_COMMITTED
    end
    PlaySound(confirmationSound)
	changedCP = false
	zo_callLater(function() CSPS.myTree:RefreshVisible() end, 1000)
	if #unslottedSkills > 0 then
		d(string.format("[CSPS] %s", GS(CSPS_MSG_Unslotted)))
		for  i,v in pairs(unslottedSkills) do
			d(zo_strformat(" - |c<<1>><<C:2>>|r", cpColHex[CSPS.cp2Disci[v]], GetChampionSkillName(v)))
		end
	end
end


-- Champion point profiles from here 


CSPScppList = ZO_SortFilterList:Subclass()

local CSPScppList = CSPScppList

function CSPScppList:New( control )
	local list = ZO_SortFilterList.New(self, control)
	list.frame = control
	list:Setup()
	return list
end

function CSPS.cp2HotKey(myKey)
	local hotbarsOnly = {false, false, false}
	for i,v in pairs(CSPS.cp2hbpHotkeys[myKey]) do
		local myProfile = CSPS.currentCharData.cpHbProfiles[v]
		local hbComp = myProfile["hbComp"]
		CSPS.cp2HbTable[i] = CSPS.cp2SingleBarExtract(hbComp)
		CSPS.cp2HbIcons(i)		
		hotbarsOnly[i] = true
	end
	CSPS.cp2UpdateHbMarks()
	CSPS.unsavedChanges = true
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	CSPS.myTree:RefreshVisible()
	CSPS.cp2ApplyConfirm(false, hotbarsOnly)
	for i=1, 3 do
		CSPS.cp2ReCheckHotbar(i)
	end
end

function CSPS.cp2KeyLoadAndApply(myId)
	local hotbarsOnly = {false, false, false}
	local myProfile = CSPS.currentCharData.cpHbProfiles[myId]
	local hbComp = myProfile["hbComp"]
	local myDiscipline = myProfile["discipline"]
	hotbarsOnly[myDiscipline] = true
	CSPS.cp2HbTable[myDiscipline] = CSPS.cp2SingleBarExtract(hbComp)
	CSPS.cp2HbIcons(myDiscipline)		
	CSPS.cp2UpdateHbMarks()
	CSPS.unsavedChanges = true
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	CSPS.myTree:RefreshVisible()
	CSPS.cp2ApplyConfirm(false, hotbarsOnly)
	for i=1, 3 do
		CSPS.cp2ReCheckHotbar(i)
	end
end

function CSPS.assignHkGroup(myGroup)
	local myId = CSPSWindowcpHbHkNumberList.idToAssign
	local myDiscipline = CSPSWindowcpHbHkNumberList.disciToAssign
	if CSPS.cp2hbpHotkeys[myGroup][myDiscipline] == myId then 
		CSPS.cp2hbpHotkeys[myGroup][myDiscipline] = nil
	else
		CSPS.cp2hbpHotkeys[myGroup][myDiscipline] = myId
	end	
	CSPS.currentCharData.cp2hbpHotkeys = CSPS.cp2hbpHotkeys
	CSPSWindowcpHbHkNumberList:listDetails(myGroup)
	CSPSWindowcpHbHkNumberList:showHotkeySelector(myId, myDiscipline, nil)
	
end

function CSPS.getHotkeyByGroup(myHotkey)
	local myKeyText = "-"
	local layInd, catInd, actInd = GetActionIndicesFromName("CSPS_CPHK"..myHotkey)
	if layInd and catInd and actInd then 
		local keyCode, mod1, mod2, mod3, mod4 = GetActionBindingInfo(layInd, catInd, actInd, 1)
		if keyCode > 0 then 
			myKeyText = ZO_Keybindings_GetBindingStringFromKeys(keyCode, mod1, mod2, mod3, mod4)
		else
			myKeyText = ZO_Keybindings_GetBindingStringFromKeys(nil, 0, 0, 0, 0)
		end
	end
	return myKeyText
end

function CSPS.getProfileNamesByGroup(myGroupId)
	local myNames = {"-", "-", "-"}
	local cpHbProfiles = CSPS.currentCharData.cpHbProfiles
	local myGroup = CSPS.cp2hbpHotkeys[myGroupId]
	for i=1, 3 do
		if CSPS.cp2hbpHotkeys[myGroupId] ~= nil then
			myNames[i] = myGroup[i] and cpHbProfiles[myGroup[i]] and cpHbProfiles[myGroup[i]].name or "-"
		end
	end
	return myNames
end

function CSPS.initHkNumberList()
	for i=1, 20 do
		CSPSWindowcpHbHkNumberList:GetNamedChild(string.format("Btn%s", i)):SetHandler("OnMouseEnter", function() CSPSWindowcpHbHkNumberList:listDetails(i) end)
		CSPSWindowcpHbHkNumberList:GetNamedChild(string.format("Btn%s", i)):SetHandler("OnMouseExit", function() CSPSWindowcpHbHkNumberList:listDetails(nil) end)
	end
	function CSPSWindowcpHbHkNumberList:listDetails(myGroupId)
		if myGroupId ~= nil then
			self:GetNamedChild("CurKey"):SetText(string.format("Hotkey: %s", CSPS.getHotkeyByGroup(myGroupId)))
			local myColNames = CSPS.getProfileNamesByGroup(myGroupId)
			self:GetNamedChild("Col1"):SetText(myColNames[2])
			self:GetNamedChild("Col2"):SetText(myColNames[3])
			self:GetNamedChild("Col3"):SetText(myColNames[1])
		else
			self:GetNamedChild("CurKey"):SetText("")
			self:GetNamedChild("Col1"):SetText("")
			self:GetNamedChild("Col2"):SetText("")
			self:GetNamedChild("Col3"):SetText("")
			
		end
	end
	function CSPSWindowcpHbHkNumberList:showHotkeySelector(myId, myDiscipline, control)
		self.col = {r = CSPS.cp2Colors[myDiscipline][1]/255, g = CSPS.cp2Colors[myDiscipline][2]/255, b = CSPS.cp2Colors[myDiscipline][3]/255}
		self.idToAssign = myId
		self.disciToAssign = myDiscipline
		for i=1, 20 do
			local myBtn = self:GetNamedChild(string.format("Btn%s", i))
			local myBG = myBtn:GetNamedChild("BG")
			if CSPS.cp2hbpHotkeys[i][myDiscipline] == myId then
				myBG:SetCenterColor(self.col.r, self.col.g, self.col.b, 0.4)
				myBtn:SetEnabled(true)
			elseif CSPS.cp2hbpHotkeys[i][myDiscipline] == nil then
				myBG:SetCenterColor(0.0314, 0.0314, 0.0314)
				myBtn:SetEnabled(true)
			else
				myBG:SetCenterColor(1, 1, 1, 0.4)
				myBtn:SetEnabled(false)
			end
		end
		if control ~= nil then
			self:ClearAnchors()
			self:SetAnchor(TOPLEFT, control, BOTTOM)
			self:SetHidden(false)
			local function hideMe()
				local moCtrl = WINDOW_MANAGER:GetMouseOverControl()
				if string.find(moCtrl:GetName(), self:GetName()) == nil and string.find(moCtrl:GetName(), "Hotkey") == nil then
					self:SetHidden(true)
					EVENT_MANAGER:UnregisterForEvent(CSPS.name, EVENT_GLOBAL_MOUSE_DOWN)
				end
			end
			EVENT_MANAGER:RegisterForEvent(CSPS.name, EVENT_GLOBAL_MOUSE_DOWN, hideMe)
		end	
	end
end

function CSPS.cpFilterCombo()
	CSPSWindowCPProfilesRoleFilter.comboBox = CSPSWindowCPProfilesRoleFilter.comboBox or ZO_ComboBox_ObjectFromContainer(CSPSWindowCPProfilesRoleFilter)
	local myComboBox = CSPSWindowCPProfilesRoleFilter.comboBox	
	myComboBox:ClearItems()
	myComboBox:SetSortsItems(true)
	
	local choices = {
	}
	
	for i, v in pairs(roles) do
		if v ~= "" and v~= roles[1] then choices[v] = i end
	end
	
	local function OnItemSelect(_, choiceText, _)
		roleFilter = choiceText
		
		CSPS.cppList:RefreshData()
		PlaySound(SOUNDS.POSITIVE_CLICK)
	end
	
	for i,j in pairs(choices) do
		myComboBox:AddItem(myComboBox:CreateItemEntry(i, OnItemSelect))

	end
	if roleFilter ~= "" then 
		myComboBox:SetSelectedItem(roleFilter)
	else
		myComboBox:SetSelectedItem(GS(SI_CHAT_OPTIONS_FILTERS))
	end
end

function CSPS.cp2HbHkClick(myId, myDiscipline, control, mouseButton)
	if not CSPSWindowcpHbHkNumberList:IsHidden() then 
		CSPSWindowcpHbHkNumberList:SetHidden(true) 
		return 
	end
	CSPSWindowcpHbHkNumberList:showHotkeySelector(myId, myDiscipline, control)
	ZO_Tooltips_HideTextTooltip()
end

function CSPS.cp2HbPshowTTApply(myId, myDiscipline, control)
	local myTooltip = {GS(CSPS_Tooltiptext_LoadAndApply)}
	local myProfile = CSPS.currentCharData.cpHbProfiles[myId]
	local myHb = {SplitString(",", myProfile["hbComp"])}
	for i, v in pairs(myHb) do
		local myString = zo_strformat("<<C:1>>", GetChampionSkillName(tonumber(v))) or "-"
		local myColor = cpColHex[myDiscipline]
		myString = string.format(" |t24:24:esoui/art/champion/champion_icon_32.dds|t %s) |c%s%s|r", i, myColor, myString)
		table.insert(myTooltip, myString)
	end
	myTooltip = table.concat(myTooltip, "\n")
	ZO_Tooltips_ShowTextTooltip(control, RIGHT, myTooltip)
end

function CSPS.cp2HbPshowTT(myId, myDiscipline, control)
	-- this function should not be needed anymore. will delete it in one of the next updates
	local otherDisc, otherColor = {}, {}
	local myHotkey = 0
	for i, v in ipairs(CSPS.cp2hbpHotkeys) do
		if v[myDiscipline] == myId then 
			myHotkey = i 
			for j=1,3 do
				if j ~= myDiscipline and v[j] ~= nil then
					table.insert(otherDisc, v[j])
					table.insert(otherColor, cpColHex[j])
				end
			end
		end
	end
	local myKeyText = "-"
	if myHotkey and myHotkey > 0 then 
		local layInd, catInd, actInd = GetActionIndicesFromName("CSPS_CPHK"..myHotkey)
		if layInd and catInd and actInd then 
			local keyCode, mod1, mod2, mod3, mod4 = GetActionBindingInfo(layInd, catInd, actInd, 1)
			if keyCode > 0 then 
				myKeyText = ZO_Keybindings_GetBindingStringFromKeys(keyCode, mod1, mod2, mod3, mod4)
			else
				myKeyText = ZO_Keybindings_GetBindingStringFromKeys(nil, 0, 0, 0, 0)
			end
		end
	else
		otherDisc = {"-", "-"}
		otherColor = {"", ""}
	end
	local otherDiscText = {}
	local myHbProfiles = CSPS.currentCharData.cpHbProfiles
	if otherDisc[1] ~= nil then
		if myHbProfiles[otherDisc[1]] ~= nil then otherDisc[1] = myHbProfiles[otherDisc[1]]["name"] end
		otherDiscText[1] = string.format("|c%s%s|r", otherColor[1], otherDisc[1])
		if otherDisc[2] ~= nil then 
			if myHbProfiles[otherDisc[2]] ~= nil then otherDisc[2] = myHbProfiles[otherDisc[2]]["name"] end
			otherDiscText[2] = string.format("|c%s%s|r", otherColor[2], otherDisc[2])
		end
		otherDiscText = table.concat(otherDiscText, "\n")
	else
		otherDiscText = "-"
	end
	local myTooltip = zo_strformat(GS(CSPS_Tooltiptext_CpHbHk), myKeyText, myHotkey, 5, otherDiscText)
	ZO_Tooltips_ShowTextTooltip(control, RIGHT, myTooltip)
end

function CSPScppList:SetupItemRow( control, data )
	control.data = data

	control:GetNamedChild("Name").normalColor = ZO_DEFAULT_TEXT
	control:GetNamedChild("Name"):SetText(data.name)
	
	control:GetNamedChild("Points").normalColor = ZO_DEFAULT_TEXT
	control:GetNamedChild("Points"):SetText(data.points)
	
	if data.type == 1 or data.type == 2 or data.type == 5 then 
		control:GetNamedChild("Rename"):SetHandler("OnClicked", function() CSPS.cp2ProfileRename(data.myId, data.type) end)
		control:GetNamedChild("Save"):SetHandler("OnClicked", function() CSPS.cp2ProfileSave(data.myId, data.type) end)
		control:GetNamedChild("Minus"):SetHandler("OnClicked", function() CSPS.cp2ProfileMinus(data.myId, data.type) end)
		if data.isNew then 
			control:GetNamedChild("Name").normalColor = ZO_GAME_REPRESENTATIVE_TEXT
			control:GetNamedChild("Points").normalColor = ZO_GAME_REPRESENTATIVE_TEXT
		end
	end
	if data.type == 4 then 
		control:GetNamedChild("Name"):SetWidth(200)
		control:GetNamedChild("Role"):SetHidden(false)
		control:GetNamedChild("Source"):SetHidden(false)
		control:GetNamedChild("Role"):SetText(data.role)
		control:GetNamedChild("Source"):SetText(data.source)
		control:GetNamedChild("Role").normalColor = ZO_DEFAULT_TEXT
		control:GetNamedChild("Source").normalColor = ZO_DEFAULT_TEXT
	else
		control:GetNamedChild("Name"):SetWidth(342)
		control:GetNamedChild("Role"):SetHidden(true)
		control:GetNamedChild("Source"):SetHidden(true)
	end
	if data.type == 5 then
		control:GetNamedChild("Points"):SetHidden(true)
		control:GetNamedChild("Hotkey"):SetHidden(false)
		control:GetNamedChild("Apply"):SetHandler("OnClicked", function() CSPS.cp2KeyLoadAndApply(data.myId) end)
		control:GetNamedChild("Apply"):SetHandler("OnMouseEnter", function() CSPS.cp2HbPshowTTApply(data.myId, data.discipline, control:GetNamedChild("Apply")) end)
		control:GetNamedChild("Apply"):SetHidden(false)
		local myHotkey = 0
		for i, v in ipairs(CSPS.cp2hbpHotkeys) do
			if v[data.discipline] == data.myId then myHotkey = i end
		end
		local myKeyText = "-"
		if myHotkey and myHotkey > 0 then 
			local layIdx, catIdx, actIdx = GetActionIndicesFromName("CSPS_CPHK"..myHotkey)
			if layIdx and catIdx and actIdx then 
				local keyCode, mod1, mod2, mod3, mod4 = GetActionBindingInfo(layIdx, catIdx, actIdx, 1)
				if keyCode > 0 then 
					myKeyText = ZO_Keybindings_GetBindingStringFromKeys(keyCode, mod1, mod2, mod3, mod4)
				end
			end
		end
		-- control:GetNamedChild("Hotkey"):SetText(zo_strformat("[<<1>>]<<2[/ (1)/ ($d)]>>", myKeyText, myHotkey)) -- With (hotkey group)
		--control:GetNamedChild("Hotkey"):SetText(zo_strformat("[<<1>>]", myKeyText)) -- Without (hotkey group)
		
		control:GetNamedChild("Hotkey"):SetHandler("OnClicked", function(upInside, mouseButton) if upInside then CSPS.cp2HbHkClick(data.myId, data.discipline, control:GetNamedChild("Hotkey"), mouseButton) end end)
		control:GetNamedChild("Hotkey"):SetHandler("OnMouseEnter", function() ZO_Tooltips_ShowTextTooltip(control:GetNamedChild("Hotkey"), RIGHT, GS(CSPS_Tooltiptext_CpHbHk)) end)
		--control:GetNamedChild("Hotkey"):SetHandler("OnMouseEnter", function() CSPS.cp2HbPshowTT(data.myId, data.discipline, control:GetNamedChild("Hotkey")) end)
	else
		control:GetNamedChild("Points"):SetHidden(false)
		control:GetNamedChild("Hotkey"):SetHidden(true)
		control:GetNamedChild("Apply"):SetHidden(true)
	end
	local myIcon = control:GetNamedChild("Icon")
	if myIcon ~= nil then myIcon:SetTexture(cpColTex[data.discipline]) end

	ZO_SortFilterList.SetupRow(self, control, data)
end

function CSPS.cppSort(newSortKey)
	if CSPS.savedVariables.settings.cppSortKey ~= newSortKey then
		CSPS.savedVariables.settings.cppSortKey = newSortKey
		CSPS.cppList.currentSortKey = newSortKey
	else
		CSPS.savedVariables.settings.cppSortOrder  = CSPS.savedVariables.settings.cppSortOrder  or false -- false = value for sort_order_down
		CSPS.savedVariables.settings.cppSortOrder = not CSPS.savedVariables.settings.cppSortOrder 
		CSPS.cppList.currentSortOrder = CSPS.savedVariables.settings.cppSortOrder
	end
	CSPS.cppList:RefreshData()
end

function CSPScppList:Setup( )
	ZO_ScrollList_AddDataType(self.list, 1, "CSPSCPPLE", 30, function(control, data) self:SetupItemRow(control, data) end)
	ZO_ScrollList_AddDataType(self.list, 2, "CSPSCPPLECUST", 30, function(control, data) self:SetupItemRow(control, data) end)
	ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")
	self:SetAlternateRowBackgrounds(true)
	self.masterList = { }
	
	local sortKeys = {
		["name"]     = { caseInsensitive = true, },
		["points"] = { caseInsensitive = true, tiebreaker = "name" },
		["role"] = { caseInsensitive = true, tiebreaker = "name" },
		["source"] = { caseInsensitive = true, tiebreaker = "role" },
	}
	
	self.currentSortKey = CSPS.savedVariables.settings.cppSortKey or "name"
	self.currentSortOrder = CSPS.savedVariables.settings.cppSortOrder  ~= nil and CSPS.savedVariables.settings.cppSortOrder or ZO_SORT_ORDER_UP
	self.sortFunction = function( listEntry1, listEntry2 )
		return ZO_TableOrderingFunction(listEntry1.data, listEntry2.data, self.currentSortKey, sortKeys, self.currentSortOrder)
	end

	self:RefreshData()
end

function CSPScppList:SortScrollList( )
	if (self.currentSortKey ~= nil and self.currentSortOrder ~= nil) then
		table.sort(ZO_ScrollList_GetDataList(self.list), self.sortFunction)
		self:RefreshVisible()
	end
	if newProfileBringToTop then
		local iToTop = 0
		for i, v in pairs(ZO_ScrollList_GetDataList(self.list)) do
			if v.data.isNew then iToTop = i end
		end
		if iToTop > 0 then
			table.insert(ZO_ScrollList_GetDataList(self.list), 1, table.remove(ZO_ScrollList_GetDataList(self.list), iToTop))
		end
		newProfileBringToTop = false
	end
end

function CSPScppList:BuildMasterList( )
	self.masterList = { }
	local custCharList = CSPS.currentCharData.cpProfiles or {}
	local custAccountList = CSPS.savedVariables.cpProfiles or {}
	local presetList = CSPSCPPresets or {}
	local custBarList = CSPS.currentCharData.cpHbProfiles or {}
	for i,v in pairs(custCharList) do
		table.insert(self.masterList, {type = 2, name = v.name, discipline = v.discipline, myId = i, points = v.points, isNew = v.isNew})
	end
	for i,v in pairs(custAccountList) do
		table.insert(self.masterList, {type = 1, name = v.name, discipline = v.discipline, myId = i, points = v.points, isNew = v.isNew})
	end
	for i,v in pairs(presetList) do
		v.role = v.role or 7
		local myRole = roles[v.role]
		table.insert(self.masterList, {type = 4, name = v.name, discipline = v.discipline,  myId = i, points = v.points, role=myRole, source=v.source, addInfo = v.addInfo, website=v.website, updated=v.updated})
	end
	for i,v in pairs(custBarList) do
		table.insert(self.masterList, {type = 5, name = v.name, discipline = v.discipline, myId = i, points = v.points, isNew = v.isNew})
	end
end

function CSPScppList:FilterScrollList( )
	local scrollData = ZO_ScrollList_GetDataList(self.list)
	ZO_ClearNumericallyIndexedTable(scrollData)

	for _, data in ipairs(self.masterList) do
		local myType = 2 -- My type here refers to the UI element not the data type: 1 being a list entry for presets, 2 also contains the profile buttons
		if data.type > 2 and data.type ~= 5 then myType = 1 end 
		if (cpProfDis == nil or cpProfDis == data.discipline) and (cpProfType == nil or cpProfType == data.type) then
			if data.type ~= 4 or roleFilter == "" or roleFilter == roles[7] or roleFilter == data.role or data.role == roles[7] or (data.role == 1 and (roleFilter == roles[5] or roleFilter == roles[6])) then
				table.insert(scrollData, ZO_ScrollList_CreateDataEntry(myType, data))
			end
		end
	end
end

function CSPS.cpProfile(i)
	if CSPSWindowCPProfiles:IsHidden() == false and cpProfDis == i then
		CSPSWindowCPProfiles:SetHidden(true)
		CSPSWindowCPImport:SetHidden(true)
		CSPSWindowCPProfiles:SetHeight(0)
		return
	end
	if not CSPS.tabEx and not CSPS.tabExHalf then  
		CSPS.cp2ReadCurrent()
		CSPS.createTable(true) -- Create the treeview for CP only if no treeview exists yet
		CSPS.toggleATTR(false) -- unCheck Apply Attributes/Skills
		CSPS.toggleSk(false) 
		CSPS.toggleCP(0, false)
	end
	if CSPS.cp2ParentTreeSection and not CSPS.cp2ParentTreeSection.node:IsOpen() then
		CSPS.onToggleSektion(CSPS.cp2ParentTreeSection:GetNamedChild("Toggle"), MOUSE_BUTTON_INDEX_LEFT) 
	end
	CSPSWindowManageBars:SetHidden(true)
	CSPSWindowOptions:SetHidden(true)
	CSPSWindowMain:SetHidden(false)
	cpProfDis = i or cpProfDis or 2
	CSPS.cpProfileType()
	CSPSWindowCPProfilesHeaderPoints:SetColor(CSPS.cp2Colors[cpProfDis][1]/255, CSPS.cp2Colors[cpProfDis][2]/255, CSPS.cp2Colors[cpProfDis][3]/255)
	CSPSWindowCPProfilesHeaderName:SetColor(CSPS.cp2Colors[cpProfDis][1]/255, CSPS.cp2Colors[cpProfDis][2]/255, CSPS.cp2Colors[cpProfDis][3]/255)
	CSPSWindowCPProfilesHeaderRole:SetColor(CSPS.cp2Colors[cpProfDis][1]/255, CSPS.cp2Colors[cpProfDis][2]/255, CSPS.cp2Colors[cpProfDis][3]/255)
	CSPSWindowCPProfilesHeaderSource:SetColor(CSPS.cp2Colors[cpProfDis][1]/255, CSPS.cp2Colors[cpProfDis][2]/255, CSPS.cp2Colors[cpProfDis][3]/255)
	CSPS.showElement("cpProfiles", true)
end

function CSPS.cp2ProfilePlus(myType, myDisc)
	local myProfile = {}
	local myTable = {}
	local myPoints = 0
	if myType ~= 5 then
		for i, v in pairs (CSPS.cp2Table) do
			if CSPS.cp2Disci[i] == cpProfDis then 
				myTable[i] = v 
				myPoints = myPoints + v[2]
			end
		end
		myTable = CSPS.cp2Compress(myTable)
	end
	local myBar = cp2SingleBarCompress(CSPS.cp2HbTable[cpProfDis])	
	local myName = GS(CSPS_Txt_NewProfile2)
	local myZone = GetUnitWorldPosition("player")
	myName = zoneAbbr[myZone] or myName
	local myRole = GetSelectedLFGRole()
	if myRole ~= 3 then 
		local myMagStam = CSPS.isMagOrStam()
		if myMagStam > 0 and myRole == 1 then
			local magStamAbbr = {"Mag", "Stam"}
			myName = string.format("%s (%s/%s-%s)", myName, classAbbr[GetUnitClassId("player")], magStamAbbr[myMagStam], roleAbbr[myRole]) 
		else
			myName = string.format("%s (%s/%s)", myName, classAbbr[GetUnitClassId("player")], roleAbbr[myRole]) 
		end
	end
	if myType ~= 5 then 
		myProfile = {name = myName, discipline = cpProfDis, points = myPoints, cpComp = myTable, hbComp = myBar, isNew = true}
	else
		myName = GS(CSPS_Txt_NewProfile2)
		myProfile = {name = myName, discipline = cpProfDis, hbComp = myBar, isNew = true}
	end
	
	CSPS.savedVariables.cpProfiles = CSPS.savedVariables.cpProfiles or {}
	CSPS.currentCharData.cpProfiles = CSPS.currentCharData.cpProfiles or {}
	CSPS.currentCharData.cpHbProfiles = CSPS.currentCharData.cpHbProfiles or {}
	
	if myType == 1 then
		table.insert(CSPS.savedVariables.cpProfiles, myProfile)
	elseif myType == 2 then
		table.insert(CSPS.currentCharData.cpProfiles, myProfile)
	elseif myType == 5 then
		table.insert(CSPS.currentCharData.cpHbProfiles, myProfile)
	end
	newProfileBringToTop = true
	CSPS.cppList:RefreshData()	
	
	for i, v in pairs(CSPS.savedVariables.cpProfiles) do
		v.isNew = nil
	end
	for i, v in pairs(CSPS.currentCharData.cpProfiles) do
		v.isNew = nil
	end
	for i, v in pairs(CSPS.currentCharData.cpHbProfiles) do
		v.isNew = nil
	end

end

function CSPS.cp2ProfileMinus(myId, myType)
	local myName = ""
	if myType == 1 then 
		myName = CSPS.savedVariables.cpProfiles[myId].name
	elseif myType == 2 then
		myName = CSPS.currentCharData.cpProfiles[myId].name
	elseif myType == 5 then
		myName = CSPS.currentCharData.cpHbProfiles[myId].name
	else
		return
	end
	ZO_Dialogs_ShowDialog(CSPS.name.."_DeleteProfile", {myId = myId, myType = myType}, {mainTextParams = {myName, "", ""}})	
end

function CSPS.cp2ProfileDelete(myId, myType)
	if myType == 1 then
		CSPS.savedVariables.cpProfiles[myId] = nil
	elseif myType == 2 then
		CSPS.currentCharData.cpProfiles[myId] = nil
	elseif myType == 5 then
		local myDiscipline = CSPS.currentCharData.cpHbProfiles[myId]["discipline"]
		for i, v in ipairs(CSPS.cp2hbpHotkeys) do
			if v[myDiscipline] == myId then v[myDiscipline] = nil end
		end		
		CSPS.currentCharData.cpHbProfiles[myId] = nil
	end
	CSPS.cppList:RefreshData()
end

function CSPS.cp2ProfileRename(myId, myType)
	local myName = ""
	if myType == 1 then 
		myName = CSPS.savedVariables.cpProfiles[myId].name
	elseif myType == 2 then
		myName = CSPS.currentCharData.cpProfiles[myId].name
	elseif myType == 5 then
		myName = CSPS.currentCharData.cpHbProfiles[myId].name
	else
		return
	end
	ZO_Dialogs_ShowDialog(CSPS.name.."_RenameProfile", {myId = myId, myType = myType}, {mainTextParams = {myName, ""}, initialEditText = myName})
end

function CSPS.cp2ProfileRenameGo(newName, myId, myType)
	if newName == "" then return end
	if myType == 1 then 
		CSPS.savedVariables.cpProfiles[myId].name = newName
	elseif myType == 2 then
		CSPS.currentCharData.cpProfiles[myId].name = newName
	elseif myType == 5 then
		CSPS.currentCharData.cpHbProfiles[myId].name = newName
	else
		return
	end
	CSPS.cppList:RefreshData()
end

function CSPS.cp2ProfileSave(myId, myType)
	local myName = ""
	if myType == 1 then 
		myName = CSPS.savedVariables.cpProfiles[myId].name
	elseif myType == 2 then
		myName = CSPS.currentCharData.cpProfiles[myId].name
	elseif myType == 5 then
		myName = CSPS.currentCharData.cpHbProfiles[myId].name
	else
		return
	end
	ZO_Dialogs_ShowDialog(CSPS.name.."_ConfirmSave", {myId = myId, myType = myType},  {mainTextParams = {myName, ""}} )
end

function CSPS.cp2ProfileSaveGo(myId, myType)
	local myTable = {}
	local myPoints = 0
	if myType ~= 5 then
		for i, v in pairs (CSPS.cp2Table) do
			if CSPS.cp2Disci[i] == cpProfDis then 
				myTable[i] = v 
				myPoints = myPoints + v[2]
			end
		end
		myTable = CSPS.cp2Compress(myTable)
	end
	local myBar = cp2SingleBarCompress(CSPS.cp2HbTable[cpProfDis])
	if myType == 1 then
		CSPS.savedVariables.cpProfiles[myId].points = myPoints
		CSPS.savedVariables.cpProfiles[myId].cpComp = myTable
		CSPS.savedVariables.cpProfiles[myId].hbComp = myBar
		
	elseif myType == 2 then
		CSPS.currentCharData.cpProfiles[myId].points = myPoints
		CSPS.currentCharData.cpProfiles[myId].cpComp = myTable
		CSPS.currentCharData.cpProfiles[myId].hbComp = myBar
	elseif myType == 5 then
		CSPS.currentCharData.cpHbProfiles[myId].hbComp = myBar
	end
	CSPS.cppList:RefreshData()
end

function CSPS.cpProfileType(myType)
	if myType == cpProfType then return end
	if myType ~= nil then 
		if myType == 3 then
			if CSPS.formatImpExp ~= string.format("txtCP2_%d", cpProfDis) then
				CSPSWindowImportExportSrcList.comboBox:SetSelectedItem(GetString("CSPS_ImpEx_TxtCP2_", cpProfDis))
				CSPS.toggleImpExpSource(string.format("txtCP2_%d", cpProfDis))
			end
			CSPS.toggleImportExport(true)
			CSPS.showElement("cpProfiles", false)
			return
		end
		cpProfType = myType
	end
	if cpProfType == 1 or cpProfType == 2 or cpProfType == 5 then CSPSWindowCPProfilesCPProfilePlus:SetHidden(false) else CSPSWindowCPProfilesCPProfilePlus:SetHidden(true) end
	if cpProfType == 5 then	
		CSPSWindowCPProfilesHeaderPoints:SetText(GS(CSPS_CPP_Hotkey))
		CSPSWindowCPProfilesHeaderPoints:SetHorizontalAlignment(0)
		CSPSWindowCPProfilesHeaderHotkey:SetHidden(false)
		CSPSWindowCPProfilesHeaderPoints:SetWidth(59)
		CSPSWindowCPProfilesHeaderHotkey:SetWidth(25)
	else
		CSPSWindowCPProfilesHeaderPoints:SetText(GS(CSPS_CPP_Points))
		CSPSWindowCPProfilesHeaderPoints:SetHorizontalAlignment(1)
		CSPSWindowCPProfilesHeaderHotkey:SetHidden(true)
		CSPSWindowCPProfilesHeaderPoints:SetWidth(84)
		CSPSWindowCPProfilesHeaderHotkey:SetWidth(0)
	end
	if cpProfType == 4 then
		CSPSWindowCPProfilesHeaderName:SetWidth(200)
		CSPSWindowCPProfilesHeaderRole:SetHidden(false)
		CSPSWindowCPProfilesHeaderSource:SetHidden(false)
		CSPSWindowCPProfilesRoleFilter:SetHidden(false)
		CSPSWindowCPProfilesLblStrictOrder:SetHidden(false)
		CSPSWindowCPProfilesChkStrictOrder:SetHidden(false)
		if not CSPSWindowCPProfilesRoleFilter.comboBox then CSPS.cpFilterCombo() end
	else
		CSPSWindowCPProfilesHeaderName:SetWidth(342)
		CSPSWindowCPProfilesHeaderRole:SetHidden(true)
		CSPSWindowCPProfilesHeaderSource:SetHidden(true)
		CSPSWindowCPProfilesRoleFilter:SetHidden(true)
		CSPSWindowCPProfilesLblStrictOrder:SetHidden(true)
		CSPSWindowCPProfilesChkStrictOrder:SetHidden(true)
	end
	local cppTypes = {"CustomAcc", "CustomChar", "ImportFromText", "Presets", "BarsOnly"}
	for i, v in pairs(cppTypes) do
		local myBG = CSPSWindowCPProfiles:GetNamedChild(v):GetNamedChild("BG")
		if i == cpProfType then myBG:SetCenterColor(CSPS.cp2Colors[cpProfDis][1]/255, CSPS.cp2Colors[cpProfDis][2]/255, CSPS.cp2Colors[cpProfDis][3]/255, 0.4) else myBG:SetCenterColor(0.0314, 0.0314, 0.0314) end
	end
	CSPSWindowCPProfilesCPProfilePlus:SetHandler("OnClicked", function() CSPS.cp2ProfilePlus(cpProfType) end)
	if not CSPS.cppList then
		CSPS.cppList = CSPScppList:New(CSPSWindowCPProfiles)
	else
		CSPS.cppList:RefreshData()
	end
	CSPS.cppList:FilterScrollList()
	CSPS.cppList:SortScrollList( )
end

function CSPS.CPListRowMouseExit( control )
	CSPS.cppList:Row_OnMouseExit(control)
	if control.data and control.data.type == 4 then ZO_Tooltips_HideTextTooltip() end
end

function CSPS.CPListRowMouseEnter(control)
	CSPS.cppList:Row_OnMouseEnter(control)
	if control.data and control.data.type == 4 then
		InitializeTooltip(InformationTooltip, control, LEFT)	
		InformationTooltip:AddLine(control.data.name, "ZoFontWinH2")
		ZO_Tooltip_AddDivider(InformationTooltip)
		if control.data.addInfo then
			InformationTooltip:AddLine(control.data.addInfo, "ZoFontGame") 
			ZO_Tooltip_AddDivider(InformationTooltip)
		end
		InformationTooltip:AddLine(zo_strformat(GS(CSPS_Tooltip_CPPUpdate), control.data.updated[1], control.data.updated[2], control.data.updated[3]), "ZoFontGame")
		if control.data.website then InformationTooltip:AddLine(zo_strformat(GS(CSPS_Tooltip_CPPWebsite), control.data.website), "ZoFontGame") end
	end
end

local function loadCPProfile(myType, myId, discipline)
	local myProfile = {}
	if myType == 1 then
		myProfile = CSPS.savedVariables.cpProfiles[myId]
	elseif myType == 2 then
		myProfile = CSPS.currentCharData.cpProfiles[myId]
	elseif myType == 5 then
		myProfile = CSPS.currentCharData.cpHbProfiles[myId]
	end
	local cp2Comp = myProfile.cpComp or "" 
	local hbComp = myProfile.hbComp or "" 
	if myType ~= 5 then
		CSPS.cp2Extract(cp2Comp, discipline) 
	end
	CSPS.cp2HbTable[discipline] = CSPS.cp2SingleBarExtract(hbComp)
	CSPS.cp2UpdateUnlock(discipline)
	CSPS.cp2ReCheckHotbar(discipline)
	CSPS.cp2HbIcons(discipline)
	CSPS.cp2UpdateHbMarks()
	CSPS.toggleCP(discipline, true)
	CSPS.unsavedChanges = true
	changedCP = true
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	CSPS.myTree:RefreshVisible()
	CSPS.showElement("cpProfiles", false)
end

local function loadDynamicCP(myList, mySlotted, myBase, discipline)
	if myList == nil then return end
	local i = 1
	local remainingPoints = GetNumSpentChampionPoints(GetChampionDisciplineId(discipline)) + GetNumUnspentChampionPoints(GetChampionDisciplineId(discipline))
	local slottableSkills = {}
	local strictOrder = CSPS.savedVariables.settings.strictOrder
	if mySlotted ~= nil then
		for _, v in pairs(mySlotted) do
			slottableSkills[v] = true
		end
	end
	CSPS.cp2ResetTable(discipline)
	while i <= #myList and remainingPoints > 0 do
		if CSPS.cp2Table[myList[i][1]][1] then
			if remainingPoints >= myList[i][2] - CSPS.cp2Table[myList[i][1]][2] then
				remainingPoints = remainingPoints + CSPS.cp2Table[myList[i][1]][2]
				CSPS.cp2Table[myList[i][1]][2] = myList[i][2] 
				if CSPS.cp2Table[myList[i][1]][2] > GetChampionSkillMaxPoints(myList[i][1]) then CSPS.cp2Table[myList[i][1]][2] = GetChampionSkillMaxPoints(myList[i][1]) end
				CSPS.cp2UpdateUnlock(discipline)
				remainingPoints = remainingPoints -  CSPS.cp2Table[myList[i][1]][2]
			else
				if DoesChampionSkillHaveJumpPoints(myList[i][1]) then
					local myJumpPoint = 0
					for j, w in ipairs({GetChampionSkillJumpPoints(myList[i][1])}) do
						if w <= remainingPoints + CSPS.cp2Table[myList[i][1]][2] then myJumpPoint = w else break end
					end
					if myJumpPoint > CSPS.cp2Table[myList[i][1]][2] then
						remainingPoints = remainingPoints + CSPS.cp2Table[myList[i][1]][2]
						CSPS.cp2Table[myList[i][1]][2] = myJumpPoint
						CSPS.cp2UpdateUnlock(discipline)
						remainingPoints = remainingPoints - myJumpPoint
					end
				else
					CSPS.cp2Table[myList[i][1]][2] = CSPS.cp2Table[myList[i][1]][2] + remainingPoints
					remainingPoints = 0
					if CSPS.cp2Table[myList[i][1]][2] > GetChampionSkillMaxPoints(myList[i][1]) then
						remainingPoints = CSPS.cp2Table[myList[i][1]][2] - GetChampionSkillMaxPoints(myList[i][1])
						CSPS.cp2Table[myList[i][1]][2] = GetChampionSkillMaxPoints(myList[i][1])
					end
				end
				if strictOrder then break end
			end
		end
		i = i +1
	end
	if remainingPoints > 0 then
		for i, v in pairs(myBase) do
			if GetChampionSkillMaxPoints(v) >= CSPS.cp2Table[v][2] then
				CSPS.cp2Table[v][2] = CSPS.cp2Table[v][2] + remainingPoints
				if CSPS.cp2Table[v][2] > GetChampionSkillMaxPoints(v) then
					remainingPoints = CSPS.cp2Table[v][2] - GetChampionSkillMaxPoints(v)
					 CSPS.cp2Table[v][2] = GetChampionSkillMaxPoints(v)
				else
					remainingPoints = 0
				end
			end
		end
	end
	CSPS.cp2HbTable[discipline] = {}
	for i, v in pairs(mySlotted) do
		table.insert(CSPS.cp2HbTable[discipline], v)
	end
	CSPS.cp2ReCheckHotbar(discipline)
	CSPS.cp2HbIcons(discipline)		
	CSPS.cp2UpdateHbMarks()
	CSPS.unsavedChanges = true
	changedCP = true
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
	CSPS.toggleCP(discipline, true)
	CSPS.cp2UpdateSum(discipline)
	CSPS.cp2UpdateSumClusters()
	CSPS.myTree:RefreshVisible()
	CSPS.showElement("cpProfiles", false)
end

local function loadCPPreset(myType, myId, discipline)
	local myPreset = {}
	if myType == 4 then 
		myPreset = CSPSCPPresets[myId]
	else
		return
	end
	if myPreset.points == "(dynamic)" then loadDynamicCP(myPreset.preset, myPreset.slotted, myPreset.basestatsToFill, myPreset.discipline) end
	local myMessage = ""
	if myPreset.switch then
		myMessage = zo_strformat(GS(CSPS_MSG_SwitchCP), cpColHex[myPreset.discipline], GetChampionSkillName(myPreset.switch))
	end
	if myPreset.situational and #myPreset.situational > 0 then
		local mySituationals = {}
		for i, v in pairs (myPreset.situational) do
			table.insert(mySituationals, zo_strformat("'<<C:1>>'", GetChampionSkillName(v)))
		end
		mySituationals = table.concat(mySituationals, "\n")
		if myMessage ~= "" then
			myMessage = string.format("%s\n\n%s\n|c%s%s|r", myMessage, GS(CSPS_MSG_SituationalCP), cpColHex[myPreset.discipline], mySituationals)
		else
			myMessage = string.format("%s\n|c%s%s|r", GS(CSPS_MSG_SituationalCP), cpColHex[myPreset.discipline], mySituationals)
		end	
	end
	if myMessage ~= "" then
		ZO_Dialogs_ShowDialog(CSPS.name.."_OkDiag", {returnFunc = function() end},  {mainTextParams = {myMessage}})
	end
end

function CSPS.showPresetProfileContent(control, myType, myId, discipline)
	if not myId or not myType or not discipline then return end
	if myType ~= 4 then return end -- while I didn't implement this feature for custom profiles
	
	--[[ Will add this option for custom profiles at a later point
		local myProfile = {}
		if myType == 5 then return end
		if myType == 1 then
			myProfile = CSPS.savedVariables.cpProfiles[myId]
		elseif myType == 2 then
			myProfile = CSPS.currentCharData.cpProfiles[myId]
		end
		local cp2Comp = myProfile.cpComp or "" 
		CSPS.cp2Extract(cp2Comp, discipline) 
	]]--
	
	InitializeTooltip(InformationTooltip, control, LEFT)

	local myPreset = CSPSCPPresets[myId]
	InformationTooltip:AddLine(myPreset.name , "ZoFontWinH2")
	ZO_Tooltip_AddDivider(InformationTooltip)
	local myTooltip = {}
	for i, v in pairs(myPreset.preset) do
		table.insert(myTooltip, zo_strformat("|c<<1>><<C:2>>|r|cffffff(<<3>>)|r", cpColHex[discipline], GetChampionSkillName(v[1]), v[2]))
	end
	myTooltip = table.concat(myTooltip, ", ")
	InformationTooltip:AddLine(myTooltip)
end

function CSPS.CPListRowMouseUp( control, button, upInside )
	if upInside then
		if button == 1 then
			if control.data.type == 1 or control.data.type == 2 or control.data.type == 5 then
				loadCPProfile(control.data.type, control.data.myId, control.data.discipline)
			else
				loadCPPreset(control.data.type, control.data.myId, control.data.discipline)
			end
		else
			CSPS.showPresetProfileContent(control, control.data.type, control.data.myId, control.data.discipline)
		end
	end
end

function CSPS.importListCP()
	local derLink = CSPSWindowImportExportTextEdit:GetText()
	if derLink == nil or derLink == "" then return end
	local lnkParameter = {SplitString(";", derLink)}
	if lnkParameter == nil then return end
	local lnkSkills = lnkParameter[1]
	local lnkHb = ""
	local importedDisciplines = {}
	local importedAnything = false
	if #lnkParameter > 1 then 
		lnkHb = lnkParameter[2]
	end
	lnkSkills = {SplitString(",", lnkSkills)}
	local discLists = {{}, {}, {}}
	for i, v in pairs(lnkSkills) do
		local skId, skValue = SplitString(":", v)
		skId = tonumber(skId)
		skValue = tonumber(skValue)
		if skValue > GetChampionSkillMaxPoints(skId) then skValue = GetChampionSkillMaxPoints(skId) end
		local myDisc = CSPS.cp2Disci[skId]
		if myDisc ~= nil then 
			if discLists[myDisc] ~= nil then
				table.insert(discLists[myDisc], {skId, skValue})
			end
		end
	end
	for disciplineIndex, myList in pairs(discLists) do
		importedDisciplines[disciplineIndex] = false
		local remainingPoints = 42000
		if CSPS.cpImportCap then
			remainingPoints = GetNumSpentChampionPoints(GetChampionDisciplineId(disciplineIndex)) + GetNumUnspentChampionPoints(GetChampionDisciplineId(disciplineIndex))
		end
		if #myList > 0 then
			CSPS.cp2ResetTable(disciplineIndex)
			for i, v in pairs(myList) do
				if v[2] and v[2] - CSPS.cp2Table[v[1]][2] <= remainingPoints then 
					remainingPoints = remainingPoints -  v[2] + CSPS.cp2Table[v[1]][2]
					CSPS.cp2Table[v[1]][2] = v[2]
				end
			end
			CSPS.cp2UpdateUnlock(disciplineIndex)
			CSPS.cp2UpdateSum(disciplineIndex)
			importedDisciplines[disciplineIndex] = true
			importedAnything = true
		end
	end
	CSPS.cp2UpdateSumClusters()
	lnkHb = {SplitString(",", lnkHb)}
	local hbTables = {{},{}, {}}
	for i,v in pairs(lnkHb) do
		local skId = tonumber(v)
		local myDisc = CSPS.cp2Disci[skId]
		if myDisc ~= nil then 
			if hbTables[myDisc] ~= nil then
				table.insert(hbTables[myDisc], skId)
			end
		end
	end
	
	for i, v in pairs(hbTables) do
		if #v > 0 then
			importedAnything = true
			CSPS.cp2HbTable[i] = {}
			for j, w in pairs(v) do
				table.insert(CSPS.cp2HbTable[i], w)
			end
		end
	end
	if not importedAnything then return end
	for i=1, 3 do
		CSPS.cp2ReCheckHotbar(i)
	end

	CSPS.cp2UpdateHbMarks()
	if not CSPS.tabEx and not CSPS.tabExHalf then 
		CSPS.createTable(true) -- Create the treeview for CP only if no treeview exists yet
		CSPS.toggleATTR(false) -- unCheck Apply Attributes/Skills
		CSPS.toggleSk(false)
		CSPS.toggleCP(0, false)
	end
	for i, v in pairs( importedDisciplines) do
		CSPS.toggleCP(i, v)
	end	
	CSPS.myTree:RefreshVisible()
	
	CSPS.toggleImportExport(false)
	changedCP = true
	CSPS.showElement("apply", true)
	CSPS.showElement("save", true)
end

local function tryToSlot(myDiscipline)
	local unslottedSkills = {}
	if #skillsToSlot > 0 then
		if #skillsToSlot < 5 then
			CSPS.cp2HbTable[myDiscipline] = skillsToSlot
		else
			CSPS.cp2HbTable[myDiscipline] = {}
			for i,v in pairs(skillsToSlot) do
				if DoesChampionSkillHaveJumpPoints(v) then
					local _, myMinJumpPoint = GetChampionSkillJumpPoints(v)
					if CSPS.cp2Table[v][2] < myMinJumpPoint then 
						table.insert(unslottedSkills, v)
					else
						if #CSPS.cp2HbTable[myDiscipline] < 4 then 
							table.insert(CSPS.cp2HbTable[myDiscipline], v)
						else	
							table.insert(unslottedSkills, v)
						end
					end
				else 
					if #CSPS.cp2HbTable[myDiscipline] < 4 then 
						table.insert(CSPS.cp2HbTable[myDiscipline], v) 
					else
						table.insert(unslottedSkills, v)
					end
				end
			end
		end
	end
	if #unslottedSkills > 0 then
		d(string.format("[CSPS] %s", GS(CSPS_MSG_Unslotted)))
		for  i,v in pairs(unslottedSkills) do
			d(zo_strformat(" - |c<<1>><<C:2>>|r", cpColHex[CSPS.cp2Disci[v]], GetChampionSkillName(v)))
		end
	end	
end

local function applyCPMapping()
		tryToSlot(cpDisciToMap)
		CSPS.cp2UpdateUnlock(cpDisciToMap)
		CSPS.cp2UpdateSum(cpDisciToMap)
		CSPS.cp2UpdateSumClusters()
		CSPS.cp2ReCheckHotbar(cpDisciToMap)
		CSPS.cp2UpdateHbMarks()		
		CSPS.toggleCP(cpDisciToMap, true)
		CSPS.myTree:RefreshVisible()
		CSPS.showElement("apply", true)
		CSPS.showElement("save", true)
		changedCP = true
		CSPS.showElement("cpImport", true)
end

local function updateCPMapProg()
	CSPSWindowCPImportSuccessNum:SetText(numMapSuccessful + numRemapped + numMapCleared)
	CSPSWindowCPImportOpenNum:SetText(#unmappedSkills + #mappingUnclear + 1 - mappingIndex) 
	if mappingIndex <= #unmappedSkills + #mappingUnclear then 
		local mapMe = nil
		if mappingIndex <= #mappingUnclear then 
			cpSkillToMap = cpSkillToMap or mappingUnclear[mappingIndex][1] 
			mapMe = mappingUnclear[mappingIndex][2] 
			CSPSWindowCPImportMapText:SetText(mappingUnclear[mappingIndex][3])
		else
			CSPSWindowCPImportMapText:SetText(unmappedSkills[mappingIndex - #mappingUnclear][1])
			mapMe = unmappedSkills[mappingIndex - #mappingUnclear][2]
			
		end
		CSPSWindowCPProfiles:SetHeight(277)
		CSPSWindowCPImportMap:SetHidden(false)
		CSPSWindowCPImportMapApply:SetEnabled(cpSkillToMap ~= nil)
		CSPSWindowCPImportClose:SetHidden(true)
		CSPSWindowCPImportMapNote:SetText(GS(CSPS_CPImp_Note))
		CSPS.inCpRemapMode = true
		if cpSkillToMap ~= nil then
			CSPSWindowCPImportMapNew:SetText(zo_strformat(GS(CSPS_CPImp_New), cpColHex[cpDisciToMap], mappingIndex, #unmappedSkills + #mappingUnclear, mapMe, GetChampionSkillName(cpSkillToMap)))
		else
			CSPSWindowCPImportMapNew:SetText(zo_strformat(GS(CSPS_CPImp_New), cpColHex[cpDisciToMap],mappingIndex, #unmappedSkills + #mappingUnclear,  mapMe, "?"))
		end		
	else
		CSPS.inCpRemapMode = false
		CSPSWindowCPImportClose:SetHidden(false)
		CSPSWindowCPImportMap:SetHidden(true)
		applyCPMapping()
		CSPSWindowCPProfiles:SetHeight(77)
	end
end

function CSPS.cp2DiscardMap()
	mappingIndex = mappingIndex + 1
	cpSkillToMap = nil
	updateCPMapProg()
end

function CSPS.cp2DiscardAll()
	mappingIndex = #unmappedSkills + #mappingUnclear + 1
	cpSkillToMap = nil
	updateCPMapProg()
end

function CSPS.cp2DoMap()
	if cpSkillToMap == nil then return end
	local mapMe = nil
	if mappingIndex <= #mappingUnclear then
		mapMe = mappingUnclear[mappingIndex][2]
		if GetChampionSkillMaxPoints(cpSkillToMap) < mapMe then d(string.format("[CSPS] %s", 'Value is higher than the maximum for this skill.')) return end
		numMapCleared = numMapCleared + 1
		numMapUnclear = numMapUnclear - 1
	else
		mapMe = unmappedSkills[mappingIndex - #mappingUnclear][2]
		if GetChampionSkillMaxPoints(cpSkillToMap) < mapMe then d(string.format("[CSPS] %s", 'Value is higher than the maximum for this skill.')) return end
		numRemapped = numRemapped + 1
	end
	CSPS.cp2Table[cpSkillToMap][2] = mapMe
	
	if CanChampionSkillTypeBeSlotted(GetChampionSkillType(cpSkillToMap)) and (markedToSlot[cpSkillToMap] or not slotMarkers) then
		table.insert(skillsToSlot, cpSkillToMap)
	end
	CSPS.myTree:RefreshVisible()
	mappingIndex = mappingIndex + 1
	updateCPMapProg()
end

function CSPS.cpClicked(myId, mouseButton)
	if CSPS.inCpRemapMode and mouseButton == 1 then 
		if CSPSWindowCPImport:IsHidden() then CSPS.inCpRemapMode = false return end
		if cpDisciToMap ~= CSPS.cp2Disci[myId] then return end
		cpSkillToMap = myId
		updateCPMapProg()
	end
	if mouseButton == 2 then
		if CSPS.cp2Table[myId][1] == true then return end
		local myPaths = CSPS.showFastestCPWays(myId)
		
	 	--ZO_Dialogs_ShowDialog(CSPS.name.."_OkDiag", {returnFunc = function() end},  {mainTextParams = {zo_strformat(GS(CSPS_MSG_CPPaths), GetChampionSkillName(myId), myPaths)}} )
		ZO_Tooltips_ShowTextTooltip(CSPS.cp2Controls[myId]:GetNamedChild("Name"), RIGHT, zo_strformat(GS(CSPS_MSG_CPPaths), GetChampionSkillName(myId), myPaths))
	end
end

function CSPS.cleanUpText()
	local myText = CSPSWindowImportExportTextEdit:GetText()
	myText = string.gsub(myText, "(%d+%-%d+)", "") 
	myText = string.gsub(myText, "[^a-z0-9A-Z%s]", "") 
	CSPSWindowImportExportTextEdit:SetText(myText)
end

function CSPS.checkTextExportCP(myDiscipline)
	if string.lower(GetCVar("Language.2")) == "en" then CSPS.exportTextCP(myDiscipline, true) return end
	ZO_Dialogs_ShowDialog(CSPS.name.."_YesNoDiag", 
		{yesFunc = function() CSPS.exportTextCP(myDiscipline, false) end,
		noFunc = function() CSPS.exportTextCP(myDiscipline, true) end,
		}, 
		{mainTextParams = {GS(CSPS_MSG_ExpTextLang)}}
	) 
end

function CSPS.exportTextCP(myDiscipline, myLang)
	local exportSlotted = {}
	for i, v in pairs(CSPS.cp2HbTable[myDiscipline]) do
		exportSlotted[v] = true
	end
	local CSPScpNameKeysRev = {}
	if not myLang then
		for i, v in pairs(CSPScpNameKeys[myDiscipline]) do
			CSPScpNameKeysRev[v] = i
		end
	end
	local exportList = {}
	local function insertInExportList(myId)
		if myId ~= -1 and CSPS.cp2Table[myId][1] == true and CSPS.cp2Table[myId][2] > 0 then
				local mySkillName = myLang and zo_strformat("<<C:1>>", GetChampionSkillName(myId)) or CSPScpNameKeysRev[myId]
				local myValue = CSPS.cp2Table[myId][2]
				local mySlotText = exportSlotted[myId] and " (slot)" or ""
				table.insert(exportList, string.format("%s %s%s", myValue, mySkillName, mySlotText))
		end
	end
	for i, v in pairs(CSPS.cp2List[myDiscipline]) do	-- Go through the auxlists for an order of skills that makes more sense then their ids
		local myId = -1
		if v[2] == 4 then
			for l, w in pairs(CSPS.cp2ListCluster[v[1]]) do
				myId = w[1]
				insertInExportList(myId)
				myId = -1
			end
		else
				myId = v[1]
				insertInExportList(myId)
		end
	end
	CSPSWindowImportExportTextEdit:SetText(table.concat(exportList, "\n"))
end

function CSPS.importTextCP(myDiscipline, convertMe, sumUp)
	local myText = CSPSWindowImportExportTextEdit:GetText()
	local myStartPos = 1
	local myImportTable = {}
	markedToSlot = {}
	markedAsBase = {}
	slotMarkers = false
	-- myText = string.gsub(myText, "%b()", "")
	myText = string.format("%s\n", myText)
	while true do
		local i, j = string.find(myText, "%d+", myStartPos)
		if i == nil then break end
		local k = string.find(myText, "%d+", j + 1)
		local nextLine = string.find(myText, "\n", j + 1)
		local myValue = tonumber(string.sub(myText, i, j))
		local myEndPos = -1
		if k ~= nil or nextLine ~= nil then 
			if k == nil or nextLine == nil then myEndPos = k or nextLine else myEndPos = math.min(k, nextLine) end
			myEndPos = myEndPos - 1
		end
		local mySubString = string.sub(myText, j + 1, myEndPos)
		if CSPS.cpImportReverse then 
			mySubString = string.sub(myText, myStartPos, i)
			k = j + 1
		end
		local mySubStringOneLine = string.gsub(mySubString, "\n", " ")
		local mySubstringSimple = string.gsub(string.lower(mySubString), "[^a-z]", "")
        if string.len(mySubStringOneLine) > 84 then mySubStringOneLine = string.sub(mySubStringOneLine, 1, 84) end
		table.insert(myImportTable, {mySubstringSimple, myValue, mySubStringOneLine})
		if k == nil then break end
		myStartPos = k
	end
	skillsToImport = {}
	unmappedSkills = {}
	numMapSuccessful = 0
	numRemapped = 0
	mappingIndex = 1
	mappingUnclear = {}
	numMapUnclear = 0
	numMapCleared = 0
	local namesChecked = {}
	-- Trying to map the normalized skill names directly to keys
	for i, v in pairs(myImportTable) do
		local myKey = CSPScpNameKeys[myDiscipline][v[1]]
		local mustSlot = string.find(v[1], "slot")
		local isBasestat = string.find(v[1], "basestat")
		if myKey ~= nil then
			if v[2] > GetChampionSkillMaxPoints(myKey) or GetChampionAbilityId(myKey) == 0 then 
				local cpSkName = GetChampionSkillName(myKey)
				cpSkName = cpSkName ~= "" and cpSkName or v[1]
				table.insert(mappingUnclear , {myKey, v[2], cpSkName})
				namesChecked[myKey] = true
				numMapUnclear = numMapUnclear + 1	
				if mustSlot then 
					markedToSlot[myKey] = true 
					slotMarkers = true
				end
				if isBasestat then markedAsBase[myKey] = true end
			else
				table.insert(skillsToImport, {myKey, v[2]})
				namesChecked[myKey] = true
				if mustSlot then 
					markedToSlot[myKey] = true 
					slotMarkers = true
				end
				if isBasestat then markedAsBase[myKey] = true end
				numMapSuccessful = numMapSuccessful + 1
			end
		else
			-- Go through all keys and check if they at least fit partwise
			local myMinStart = string.len(v[1])
			local myMinStartB = 42
			if myMinStart > 4 and v[2] <= 100 then
				local keyInString = nil
				local stringInKey = nil
				for j,w in pairs(CSPScpNameKeys[myDiscipline]) do
					if (not namesChecked[j]) or convertMe then
						-- Check if the normalized skill name is part of the namekey
						local startA = string.find(v[1], j)
						-- Check if the namekey is part of the normalized skill name
						local startB = string.find(j, v[1])
						if startA ~= nil then
							if startA < myMinStart then 
								myMinStart = startA 
								keyInString = j 
							end
						end
						if startB ~= nil then
							if startB < myMinStartB then
								myMinStartB = startB
								stringInKey = j
							end
						end
					end
				end
				if keyInString ~= nil then
					myKey = CSPScpNameKeys[myDiscipline][keyInString]
					table.insert(skillsToImport, {myKey, v[2]})
					namesChecked[myKey] = true
					if mustSlot then 
						markedToSlot[myKey] = true 
						slotMarkers = true
					end
					if isBasestat then markedAsBase[myKey] = true end
					numMapSuccessful = numMapSuccessful + 1
				elseif stringInKey then
					if string.len(v[1]) > string.len(stringInKey) / 2 then
						myKey = CSPScpNameKeys[myDiscipline][stringInKey]
						table.insert(skillsToImport, {myKey, v[2]})
						numMapSuccessful = numMapSuccessful + 1
						if mustSlot then 
							markedToSlot[myKey] = true 
							slotMarkers = true
						end
						if isBasestat then markedAsBase[myKey] = true end
					else
						myKey = CSPScpNameKeys[myDiscipline][stringInKey]
						table.insert(mappingUnclear , {myKey, v[2], v[3]})
						numMapUnclear = numMapUnclear + 1
						if mustSlot then 
							markedToSlot[myKey] = true 
							slotMarkers = true
						end
						if isBasestat then markedAsBase[myKey] = true end
					end
					namesChecked[myKey] = true
				end
			end
		end
		if myKey == nil then
			table.insert(unmappedSkills, {v[3], v[2]})
		end
	end
		
	if convertMe then
		local myRole =  GetSelectedLFGRole()
		if myRole == 1 and  CSPS.isMagOrStam() > 0 then myRole = 4 + CSPS.isMagOrStam() end
		if myRole == 3 then myRole = 7 end
		local convPreset = {
			"[x] = {",
			"\tname = \"Put name here\",",
			"\twebsite = \"Put source URL here (as short as possible)\",",
			os.date("\tupdated = {%m, %d, %Y},"),
			"\tpoints = \"(dynamic)\",",
			string.format("\tsource = \"%s\",", GetDisplayName()),
			string.format("\trole = %s,", myRole),
			string.format("\tdiscipline = %s,", myDiscipline),
			"\tpreset = {",
		}
		local setValue = {}
		for i, v in pairs(skillsToImport) do
			if setValue[v[1]] ~= v[2] or sumUp then
				local thisValue = v[2]
				if sumUp and setValue[v[1]] ~= 0 and setValue[v[1]] ~= nil then
					thisValue = thisValue + setValue[v[1]]
				end
				setValue[v[1]] = thisValue
				table.insert(convPreset, string.format("\t\t{%s, %s},", v[1], thisValue))
			end
		end
		table.insert(convPreset, "\t},")
		
		local mySlottables = {}
		local maxFour = 1
		for i, v in pairs(markedToSlot) do
			table.insert(mySlottables, i)
			maxFour = maxFour + 1
			if maxFour == 5 then break end
		end
		local myBasestats = {}
		maxFour = 1 -- ok actually max three now
		for i,v in pairs( markedAsBase) do
			table.insert(myBasestats, i)
			maxFour = maxFour + 1
			if maxFour == 4 then break end
		end
		mySlottables = table.concat(mySlottables, ", ")
		myBasestats = table.concat(myBasestats, ", ")
		mySlottables = mySlottables or ""
		myBasestats = myBasestats or ""
		table.insert(convPreset, string.format("\tbasestatsToFill = {%s},", myBasestats))
		table.insert(convPreset, string.format("\tslotted = {%s},", mySlottables))
		table.insert(convPreset, "}")
		local myConvertedText = table.concat(convPreset, "\n")
		CSPSWindowImportExportTextEdit:SetText(myConvertedText)
		return
	end
	local remainingPoints = 42000
	if CSPS.cpImportCap then
		remainingPoints = GetNumSpentChampionPoints(GetChampionDisciplineId(disciplineIndex)) + GetNumUnspentChampionPoints(GetChampionDisciplineId(disciplineIndex))
	end
	if #skillsToImport + #unmappedSkills + numMapUnclear > 0 then
		CSPS.cp2ResetTable(myDiscipline)
		skillsToSlot = {}
		local skillsToSlotRev = {}
		for i, v in pairs( skillsToImport) do
			if CSPS.cp2Table[v[1]] ~= nil then 
				if v[2] > GetChampionSkillMaxPoints(v[1]) then v[2] = GetChampionSkillMaxPoints(v[1]) end
				if v[2] <= remainingPoints + CSPS.cp2Table[v[1]][2] then
					remainingPoints = remainingPoints - v[2] + CSPS.cp2Table[v[1]][2]
					CSPS.cp2Table[v[1]][2] = v[2] 
					if CanChampionSkillTypeBeSlotted(GetChampionSkillType(v[1])) and not skillsToSlotRev[v[1]] and  (markedToSlot[v[1]] or not slotMarkers) then
						table.insert(skillsToSlot, v[1])
						skillsToSlotRev[v[1]] = true
					end
				end
			end
		end
		CSPS.cp2UpdateSum(myDiscipline)
		CSPS.cp2UpdateSumClusters()
		if not CSPS.tabEx and not CSPS.tabExHalf then 
			CSPS.createTable(true) -- Create the treeview for CP only if no treeview exists yet
			CSPS.toggleATTR(false) -- unCheck Apply Attributes/Skills
			CSPS.toggleSk(false)
			CSPS.toggleCP(0, false)
		end
		if CSPS.cp2ParentTreeSection and not CSPS.cp2ParentTreeSection.node:IsOpen() then
			CSPS.onToggleSektion(CSPS.cp2ParentTreeSection:GetNamedChild("Toggle"), MOUSE_BUTTON_INDEX_LEFT) 
		end
		CSPS.toggleCP(myDiscipline, true)
		CSPS.myTree:RefreshVisible()
		CSPS.toggleImportExport(false)
		CSPS.showElement("apply", false)
		CSPS.showElement("save", false)
		CSPS.showElement("cpImport", true)
		cpDisciToMap = myDiscipline
		updateCPMapProg()
	else
		d(string.format("[CSPS] %s", GS(CSPS_CPImp_NoMatch)))
	end
end

local function cpFastestWays(myCpId)
	local passedCPs = {}
	local fastestWay = 42000
	local myPaths = {}
	local function checkPathPoint(myPoint, myPath)
		if not DoesChampionSkillHaveJumpPoints(myPoint) then return end
		local _, unlockPoints = GetChampionSkillJumpPoints(myPoint)
		myPath.points = myPath.points + unlockPoints
		myPath.checked[myPoint] = true
		table.insert(myPath.steps, myPoint)
		if IsChampionSkillRootNode(myPoint) or CSPS.cp2Table[myPoint][1] then
			fastestWay = math.min(fastestWay, myPath.points)
			table.insert(myPaths, myPath)
		else
			for i, v in pairs({GetChampionSkillLinkIds(myPoint)}) do
				if myPath.checked[v] == nil then
					local newPath = {
						points = myPath.points,
						checked = {},
						steps = {},
					}
					for j, w in pairs(myPath.checked) do
						newPath.checked[j] = w
					end
					for j, w in ipairs(myPath.steps) do
						newPath.steps[j] = w
					end
					checkPathPoint(v, newPath)
				end
			end
		end
	end
	local myPath = {
		points = 0,
		checked = {},
		steps = {},
	}
	checkPathPoint(myCpId, myPath)
	local sortedPaths = {}
	for i, v in pairs(myPaths) do
		if #sortedPaths == 0 then
			sortedPaths[1] = v
		else
			for j, w in ipairs(sortedPaths) do
				if w.points >= v.points then table.insert(sortedPaths, j, v) break end
			end
		end
	end
	return sortedPaths
end

function CSPS.showFastestCPWays(myCpId)
	local sortedPaths = cpFastestWays(myCpId)
	local allPaths = {}
	for i=1, 4 do
		if sortedPaths[i] == nil then break end
		local v = sortedPaths[i]
		table.insert(allPaths, zo_strformat(GS(CSPS_MSG_CPPathOpt), cpColHex[CSPS.cp2Disci[myCpId]], i, v.points))
		local myPathNames = {}
		for j=1, #v.steps do
			table.insert(myPathNames, zo_strformat("<<C:1>>", GetChampionSkillName(v.steps[#v.steps + 1 - j])))
		end
		table.insert(allPaths, table.concat(myPathNames, " → "))
	end
	return table.concat(allPaths, "\n")
end

function CSPS.checkCpOnClose()
	if not changedCP then return end
	d(string.format("[CSPS] %s", GS(CSPS_MSG_ApplyClosing)))
	
end

-- CP reminder for raids and trials

function CSPS.cpReminder() 
	local zoneId = GetUnitWorldPosition("player")
	if zoneId == CSPS.lastZoneID then return end
	CSPS.lastZoneID = zoneId
	if CSPS.locationBinding(zoneId) or not CSPS.cpRemindMe then return end
	if not zoneAbbr[zoneId] then return end
	if GetCurrentZoneDungeonDifficulty() < 2 then return end
	d(string.format("[CSPS] %s", GS(CSPS_MSG_TrialEntered)))
end