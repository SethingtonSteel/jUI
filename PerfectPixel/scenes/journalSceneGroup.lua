PP.journalSceneGroup = function()
--===============================================================================================--
	local SV_VER		= 0.4
	local DEF = {
		largeQuestList	= true,
	}
	local SV = ZO_SavedVars:NewAccountWide(PP.ADDON_NAME, SV_VER, "JournalScene", DEF, GetWorldName())
	---------------------------------------------
	table.insert(PP.optionsData,
	{	type				= "submenu",
		name				= GetString(PP_LAM_SCENE_JOURNAL),
		controls = {
			{	type				= "checkbox",
				name				= GetString(PP_LAM_SCENE_JOURNAL_QUEST_LARGE_LIST),
				getFunc				= function() return SV.largeQuestList end,
				setFunc				= function(value) SV.largeQuestList = value end,
				default				= DEF.largeQuestList,
				requiresReload		= true,
			},
		},
	})
--===============================================================================================--
	local scenes = {
		{ scene = QUEST_JOURNAL_SCENE,							gVar = QUEST_JOURNAL_KEYBOARD,		},
		{ scene = ANTIQUITY_JOURNAL_KEYBOARD_SCENE,				gVar = ANTIQUITY_JOURNAL_KEYBOARD,	},
		{ scene = SCENE_MANAGER:GetScene('cadwellsAlmanac'),	gVar = CADWELLS_ALMANAC,			},
		{ scene = LORE_LIBRARY_SCENE,							gVar = LORE_LIBRARY,				},
		{ scene = SCENE_MANAGER:GetScene('achievements'),		gVar = ACHIEVEMENTS,				},
		{ scene = LEADERBOARDS_SCENE,							gVar = LEADERBOARDS,				},
	}
	local fragments	= { FRAME_PLAYER_FRAGMENT, RIGHT_BG_FRAGMENT, TREE_UNDERLAY_FRAGMENT, TITLE_FRAGMENT, JOURNAL_TITLE_FRAGMENT, }

	for i=1, #scenes do
		local scene			= scenes[i].scene
		local gVar			= scenes[i].gVar
		
		for i=1, #fragments do
			scene:RemoveFragment(fragments[i])
		end

		local tlc	= gVar.control
		-- local list	= gVar.list

		PP:CreateBackground(tlc, --[[#1]] nil, nil, nil, -10, -10, --[[#2]] nil, nil, nil, 0, 10, true)
		PP.Anchor(tlc, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 120, --[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -70)

		-- PP.Anchor(list, --[[#1]] nil, nil, nil, 0, 3, --[[#2]] true, nil, nil, nil, 0, 0)
		-- PP.ScrollBar(list,	--[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, false)
		-- ZO_ScrollList_Commit(list)
	end

--questJournal--ZO_QuestJournal--------------------------------------------------------------------
	PP.ScrollBar(ZO_QuestJournalNavigationContainer, --[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, false)
	PP.Anchor(ZO_QuestJournalQuestCount, --[[#1]] TOPLEFT, nil, TOPLEFT, 0, -6)
	PP.Anchor(ZO_QuestJournalNavigationContainerScroll, --[[#1]] TOPLEFT, nil, TOPLEFT, 5, 0, --[[#2]] true, BOTTOMRIGHT, nil, BOTTOMRIGHT, 0, 0)
	PP.Font(ZO_QuestJournalQuestCount, --[[Font]] PP.f.Expressway, 24, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
	ZO_Scroll_SetMaxFadeDistance(ZO_QuestJournalNavigationContainer, 10)

	if SV.largeQuestList then
		local tree = QUEST_JOURNAL_KEYBOARD["navigationTree"]
		tree.defaultIndent = 30		--[[def (40)]]
		tree.defaultSpacing = 0		--[[def (-10)]]
		tree.width = 340			--[[def (300)]]
		-- tree:SetExclusive(false) >> breaks the game
		tree.exclusiveCloseNodeFunction = function(treeNode)
			treeNode:SetOpen(true, false)
		end

		PP.Anchor(ZO_QuestJournalNavigationContainerScroll, --[[#1]] TOPLEFT, nil, TOPLEFT, 0, 0, --[[#2]] true, BOTTOMRIGHT, nil, BOTTOMRIGHT, 0, 0)

		--TreeHeaderSetup(node, control, name, open)
		local treeHeader = tree["templateInfo"]["ZO_SimpleArrowIconHeader"]
		treeHeader.setupFunction = function(node, control, name, open)
			control:SetDimensionConstraints(320, 23, 320, 23)
			control:SetMouseEnabled(false)
			control["icon"]:SetHidden(true)
			control["iconHighlight"]:SetHidden(true)

			--text--
			local text = control["text"]
			text:SetModifyTextType(MODIFY_TEXT_TYPE_UPPERCASE)
			text:SetText(name)
			text:SetSelected(true)
			text:SetVerticalAlignment(TEXT_ALIGN_CENTER)
			PP.Font(text, --[[Font]] PP.f.Expressway, 15, "outline", --[[Alpha]] nil, --[[Color]] 197, 194, 158, 1, --[[StyleColor]] 0, 0, 0, .8)
			PP.Anchor(text, --[[#1]] TOPLEFT, control, TOPLEFT, 10, 0, --[[#2]] true, BOTTOMRIGHT, control, BOTTOMRIGHT, 0, 0)
			text:SetMouseEnabled(false)

			if control:GetNamedChild("Backdrop") then return end
			PP.ListBackdrop(control, -12, 0, 0, 0, --[[tex]] PP.t.gR, 16, 0, --[[bd]] 197*.3, 194*.3, 158*.3, 1, --[[edge]] 0, 0, 0, 0)
		end

		--TreeEntrySetup(node, control, data, open)
		local treeEntry = tree["templateInfo"]["ZO_QuestJournalNavigationEntry"]
		local existingSetupCallback = treeEntry.setupFunction
		treeEntry.setupFunction = function(node, control, data, open)
			existingSetupCallback(node, control, data, open)
			PP.Font(control, --[[Font]] PP.f.Expressway, 15, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
			control:SetDimensions(290, 21)
			control:SetVerticalAlignment(TEXT_ALIGN_CENTER)
			--icon--
			local icon = control:GetNamedChild("Icon")
			PP.Anchor(icon, --[[#1]] nil, nil, nil, -2, 0)
			icon:SetDimensions(21, 21)
		end

		local pool = treeEntry.objectPool

		local function treeEntrySetHandler(control)
			ZO_PreHookHandler(control, 'OnMouseEnter', function(self)
				if self:IsSelected() then return end
				self:SetColor(230/255, 230/255, 150/255, 1)
			end)
			ZO_PreHookHandler(control, 'OnMouseExit', function(self)
				if self:IsSelected() then return end
				self:SetColor(220/255, 216/255, 34/255, 1)	-- def_color = 220, 216, 34, 1.00
			end)
		end
		local exCustomFactoryBehavior = pool.customFactoryBehavior
		pool.customFactoryBehavior = function(control, ...)
			if exCustomFactoryBehavior then
				exCustomFactoryBehavior(control, ...)
			end
			treeEntrySetHandler(control)
		end
		for _, control in pairs(pool.m_Free) do
			treeEntrySetHandler(control)
		end
		for _, control in pairs(pool.m_Active) do
			treeEntrySetHandler(control)
		end

		QUEST_JOURNAL_KEYBOARD.listDirty = true
	end

--Antiquities--ZO_Cadwell--------------------------------------------------------------------
--cadwellsAlmanac--ZO_Cadwell--------------------------------------------------------------------
--loreLibrary--ZO_LoreLibrary----------------------------------------------------------------------
--achievements--ZO_Achievements--------------------------------------------------------------------
--leaderboards--ZO_Leaderboards--------------------------------------------------------------------
end