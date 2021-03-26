PP.craftStationScenes = function()
	local SV_VER				= 0.1
	local DEF = {
		Provisioner_ShowTooltip	= true,
	}
	local SV = ZO_SavedVars:NewAccountWide(PP.ADDON_NAME, SV_VER, "CraftStations", DEF, GetWorldName())

--===============================================================================================--
--==ZO_WritAdvisor==--
	local waTLC = ZO_WritAdvisor_Keyboard_TopLevel
	PP:CreateBackground(waTLC,		--[[#1]] nil, nil, nil, 0, -24, --[[#2]] nil, nil, nil, 0, 17, true)
	PP.Anchor(waTLC:GetNamedChild("HeaderContainerDivider"), --[[#1]] TOPLEFT, waTLC, TOPLEFT, 0, 20, --[[#2]] true, TOPRIGHT, waTLC, TOPRIGHT, -30, 20)

	for i = 1, #WRIT_ADVISOR_KEYBOARD_FRAGMENT_GROUP do
		if WRIT_ADVISOR_KEYBOARD_FRAGMENT_GROUP[i] == MEDIUM_LEFT_PANEL_BG_FRAGMENT then
			WRIT_ADVISOR_KEYBOARD_FRAGMENT_GROUP[i] = nil
		end
	end
--===============================================================================================--
--==SMITHING_SCENE==-- --==SCENE_MANAGER:GetScene('smithing')==--
	local smithingTab = {ZO_SmithingTopLevelRefinementPanel, ZO_SmithingTopLevelDeconstructionPanel, ZO_SmithingTopLevelImprovementPanel}

	SMITHING_SCENE:RemoveFragment(RIGHT_PANEL_BG_FRAGMENT)
	SMITHING_SCENE:AddFragment(FRAME_TARGET_BLUR_STANDARD_RIGHT_PANEL_MEDIUM_LEFT_PANEL_FRAGMENT)

	PP:ForceRemoveFragment(SMITHING_SCENE, THIN_LEFT_PANEL_BG_FRAGMENT)
	PP:ForceRemoveFragment(SMITHING_SCENE, MEDIUM_LEFT_PANEL_BG_FRAGMENT)

	PP:CreateBackground(ZO_SmithingTopLevelRefinementPanel,		--[[#1]] nil, nil, nil, -6, 0, --[[#2]] nil, nil, nil, 0, 6)
	PP:CreateBackground(ZO_SmithingTopLevelDeconstructionPanel,	--[[#1]] nil, nil, nil, -6, 0, --[[#2]] nil, nil, nil, 0, 6)
	PP:CreateBackground(ZO_SmithingTopLevelImprovementPanel,	--[[#1]] nil, nil, nil, -6, 0, --[[#2]] nil, nil, nil, 0, 6)
	PP:CreateBackground(ZO_SmithingTopLevelCreationPanel,		--[[#1]] nil, nil, nil, -6, 0, --[[#2]] nil, nil, nil, 0, 6)
	PP:CreateBackground(ZO_SmithingTopLevelResearchPanel,		--[[#1]] nil, nil, nil, -6, 0, --[[#2]] nil, nil, nil, 0, 6)

	for _, v in ipairs(smithingTab) do
		PP.ScrollBar(v:GetNamedChild("InventoryBackpack"),	--[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, true)
		PP.Anchor(v:GetNamedChild("Inventory"), --[[#1]] TOPLEFT, v, TOPLEFT, 0, 0, --[[#2]] true, BOTTOMRIGHT, v, BOTTOMRIGHT, 0, 0)
		PP.Anchor(v, --[[#1]] TOPRIGHT, ZO_SmithingTopLevel, TOPRIGHT, 0, 100, --[[#2]] true, BOTTOMRIGHT, ZO_SmithingTopLevel, BOTTOMRIGHT, 0, -80)
		PP.Anchor(v:GetNamedChild("InventoryFilterDivider"),	--[[#1]] TOP, v:GetNamedChild("Inventory"), TOP, 0, 60)
	end
	PP.Anchor(ZO_SmithingTopLevelImprovementPanelInventory, --[[#1]] TOPLEFT, ZO_SmithingTopLevelImprovementPanel, TOPLEFT, 0, 0, --[[#2]] true, BOTTOMRIGHT, ZO_SmithingTopLevelImprovementPanel, BOTTOMRIGHT, 0, -145)
	ZO_SmithingTopLevelImprovementPanelBoosterContainerDivider:SetHidden(true)

	PP.Anchor(ZO_SmithingTopLevelCreationPanel, --[[#1]] TOPRIGHT, ZO_SmithingTopLevel, TOPRIGHT, 0, 100, --[[#2]] true, BOTTOMRIGHT, ZO_SmithingTopLevel, BOTTOMRIGHT, 0, -80)
	PP.Anchor(ZO_SmithingTopLevelCreationPanelTabsDivider,	--[[#1]] TOP, ZO_SmithingTopLevelCreationPanel, TOP, 0, 60)

	PP.Anchor(ZO_SmithingTopLevelResearchPanel, --[[#1]] TOPRIGHT, ZO_SmithingTopLevel, TOPRIGHT, 0, 100, --[[#2]] true, BOTTOMRIGHT, ZO_SmithingTopLevel, BOTTOMRIGHT, 0, -80)
	PP.Anchor(ZO_SmithingTopLevelResearchPanelResearchLineList,	--[[#1]] TOP, ZO_SmithingTopLevelResearchPanel, TOP, 0, 60)
	ZO_SmithingTopLevelResearchPanelButtonDivider:SetHidden(true)
	ZO_SmithingTopLevelResearchPanelContainerDivider:SetHidden(true)

	--AdvancedFilters compatibility
	if AdvancedFilters then
		local function delayReanchorForResearchAdvancedFilters(delay)
			zo_callLater(function()
				PP.Anchor(ZO_SmithingTopLevelResearchPanelResearchLineListList, TOP, ZO_SmithingTopLevelResearchPanelResearchLineListSelectedLabel, BOTTOM, 0, 0)
			end, delay)
		end
		ZO_PostHookHandler(SMITHING.researchPanel.control, "OnEffectivelyShown", function() delayReanchorForResearchAdvancedFilters(60) end)
		--ZO_SmithingTopLevelResearchPanelResearchLineListSelectedLabel:SetHandler("OnEffectivelyShown", function() delayReanchorForResearchAdvancedFilters(60) end, "PerfectPixel")
		SecurePostHook(SMITHING.researchPanel, "ChangeTypeFilter", function() delayReanchorForResearchAdvancedFilters(60) end)
	end

	PP.Anchor(ZO_SmithingTopLevelModeMenu, --[[#1]] BOTTOM, ZO_SmithingTopLevelRefinementPanel, TOP, -40, 0)

--===============================================================================================--
--==KEYBOARD_RETRAIT_ROOT_SCENE==-- --==SCENE_MANAGER:GetScene('retrait_keyboard_root')==--ZO_RETRAIT_KEYBOARD
	local retrait_station	= ZO_RETRAIT_STATION_KEYBOARD
	local retrait_panel		= ZO_RETRAIT_KEYBOARD
	local traitContainer	= retrait_panel.traitContainer
	local traitList			= retrait_panel.traitList

	KEYBOARD_RETRAIT_ROOT_SCENE:AddFragment(FRAME_TARGET_BLUR_CENTERED_FRAGMENT)

	PP:ForceRemoveFragment(KEYBOARD_RETRAIT_ROOT_SCENE, THIN_LEFT_PANEL_BG_FRAGMENT)
	PP:ForceRemoveFragment(KEYBOARD_RETRAIT_ROOT_SCENE, RIGHT_PANEL_BG_FRAGMENT)
	PP:ForceRemoveFragment(KEYBOARD_RETRAIT_ROOT_SCENE, RIGHT_BG_FRAGMENT)
	PP:ForceRemoveFragment(KEYBOARD_RETRAIT_ROOT_SCENE, TREE_UNDERLAY_FRAGMENT)
	
	PP:CreateBackground(retrait_panel.control,	--[[#1]] nil, nil, nil, -6, 0, --[[#2]] nil, nil, nil, 0, 6)

	PP.ScrollBar(ZO_RetraitStation_KeyboardTopLevelRetraitPanelInventoryBackpack,	--[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, true)

	PP.Anchor(ZO_RetraitStation_KeyboardTopLevelRetraitPanel, --[[#1]] TOPRIGHT, ZO_RetraitStation_KeyboardTopLevel, TOPRIGHT, 0, 100, --[[#2]] true, BOTTOMRIGHT, ZO_RetraitStation_KeyboardTopLevel, BOTTOMRIGHT, 0, -80)
	PP.Anchor(ZO_RetraitStation_KeyboardTopLevelRetraitPanelInventory, --[[#1]] TOPLEFT, ZO_RetraitStation_KeyboardTopLevelRetraitPanel, TOPLEFT, 0, 0, --[[#2]] true, BOTTOMRIGHT, ZO_RetraitStation_KeyboardTopLevelRetraitPanel, BOTTOMRIGHT, 0, 0)

	function retrait_station:RefreshModeMenuAnchors() end
	retrait_station.modeMenu:SetWidth(550)
	PP.Anchor(retrait_station.modeMenu, --[[#1]] BOTTOM, retrait_panel.control, TOP, -40, 0)

	PP.Anchor(ZO_RetraitStation_KeyboardTopLevelRetraitPanelInventoryFilterDivider,	--[[#1]] TOP, ZO_RetraitStation_KeyboardTopLevelRetraitPanelInventory, TOP, 0, 60)

	--ZO_RetraitStation_KeyboardTopLevelRetraitPanelTraitContainer
	traitList.highlightTemplate = nil
	traitList.selectionTemplate = nil

	PP.Anchor(traitList, --[[#1]] TOPLEFT, traitContainer, TOPLEFT, 0, 0, --[[#2]] true, BOTTOMRIGHT, traitContainer, BOTTOMRIGHT, 0, 0)
	PP.Anchor(ZO_RetraitStation_KeyboardTopLevelRetraitPanelTraitContainerBG, --[[#1]] TOPLEFT, traitList, TOPLEFT, -6, -6, --[[#2]] true, BOTTOMRIGHT, traitList, BOTTOMRIGHT, 0, 6)
	PP.Anchor(ZO_RetraitStation_KeyboardTopLevelRetraitPanelTraitContainerSelectTraitLabel, --[[#1]] BOTTOM, traitContainer, TOP, 0, -6)

	-- PP.ListBackdrop(traitList, -3, -3, -3, 3, --[[tex]] nil, 8, 0, --[[bd]] 5, 5, 5, .6, --[[edge]] 30, 30, 30, .6)
	PP.ScrollBar(traitList,	--[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, true)

	-- traitContainer:SetDrawLayer(0)
	-- traitContainer:SetHeight(400)
	
	PP.Font(ZO_RetraitStation_KeyboardTopLevelRetraitPanelTraitContainerSelectTraitLabel, --[[Font]] PP.f.Expressway, 22, "outline", --[[Alpha]] .9, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
	
	ZO_RetraitStation_KeyboardTopLevelRetraitPanelTraitContainerDivider:SetHidden(true)
	ZO_RetraitStation_KeyboardTopLevelRetraitPanelTraitContainerBGMungeOverlay:SetHidden(true)

	local bg = ZO_RetraitStation_KeyboardTopLevelRetraitPanelTraitContainerBG
	bg:SetCenterTexture(PP.SV.skin_backdrop, PP.SV.skin_backdrop_tile_size, PP.SV.skin_backdrop_tile and 1 or 0)
	bg:SetCenterColor(unpack(PP.SV.skin_backdrop_col))
	bg:SetEdgeTexture(PP.SV.skin_edge, PP.SV.skin_edge_file_width, PP.SV.skin_edge_file_height, PP.SV.skin_edge_thickness, 0)
	bg:SetEdgeColor(unpack(PP.SV.skin_edge_col))
	bg:SetInsets(PP.SV.skin_backdrop_insets, PP.SV.skin_backdrop_insets, -PP.SV.skin_backdrop_insets, -PP.SV.skin_backdrop_insets)
	bg:SetIntegralWrapping(PP.SV.skin_edge_integral_wrapping)

	ZO_PreHook("ZO_RetraitStation_Retrait_Keyboard_OnTraitRowMouseEnter", function(control)
		control.backdrop:SetCenterColor(unpack(PP.SV.list_skin.list_skin_backdrop_hl_col))
	end)
	ZO_PreHook("ZO_RetraitStation_Retrait_Keyboard_OnTraitRowMouseExit", function(control)
		control.backdrop:SetCenterColor(unpack(PP.SV.list_skin.list_skin_backdrop_col))
	end)

	ZO_PreHook("ZO_RetraitStation_Retrait_Keyboard_OnTraitRowMouseUp", function(control, button, upInside)
		if upInside then
			if control.data.knownTrait then
				local lastSelected = traitList.traitSelectedControl

				if lastSelected == control then return end
				control.backdrop:SetEdgeColor(unpack(PP.SV.list_skin.list_skin_edge_sel_col))
				traitList.traitSelectedControl = control

				if not lastSelected then return end
				lastSelected.backdrop:SetEdgeColor(unpack(PP.SV.list_skin.list_skin_edge_col))
			end
		end
	end)

	local orig_RefreshTraitList = ZO_RetraitStation_Retrait_Keyboard.RefreshTraitList
	function ZO_RetraitStation_Retrait_Keyboard.RefreshTraitList(...)
		if traitList.traitSelectedControl then
			traitList.traitSelectedControl.backdrop:SetEdgeColor(unpack(PP.SV.list_skin.list_skin_edge_col))
			traitList.traitSelectedControl = nil
		end

		traitContainer:SetHeight(600)
		orig_RefreshTraitList(...)
		traitContainer:SetHeight(traitList.uniformControlHeight * #traitList.data - (traitList.uniformControlHeight - ZO_ScrollList_GetDataTypeTable(traitList, 1).height))
	end

--===============================================================================================--
--==ENCHANTING_SCENE==-- --==SCENE_MANAGER:GetScene('enchanting')==--
	ENCHANTING_SCENE:RemoveFragment(RIGHT_PANEL_BG_FRAGMENT)
	ENCHANTING_SCENE:AddFragment(FRAME_TARGET_BLUR_STANDARD_RIGHT_PANEL_MEDIUM_LEFT_PANEL_FRAGMENT)

	PP:CreateBackground(ZO_EnchantingTopLevelInventory,	--[[#1]] nil, nil, nil, -6, 0, --[[#2]] nil, nil, nil, 0, 6)

	PP.ScrollBar(ZO_EnchantingTopLevelInventoryBackpack,	--[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, true)

	PP.Anchor(ZO_EnchantingTopLevelInventory,				--[[#1]] TOPRIGHT, ZO_EnchantingTopLevel, TOPRIGHT, 0, 100, --[[#2]] true, BOTTOMRIGHT, ZO_EnchantingTopLevel, BOTTOMRIGHT, 0, -80)
	PP.Anchor(ZO_EnchantingTopLevelModeMenu,				--[[#1]] BOTTOM, ZO_EnchantingTopLevelInventory, TOP, -40, 0)
	PP.Anchor(ZO_EnchantingTopLevelInventoryFilterDivider,	--[[#1]] TOP, ZO_EnchantingTopLevelInventory, TOP, 0, 60)

--===============================================================================================--
--==ALCHEMY_SCENE==--ALCHEMY
	ALCHEMY_SCENE:RemoveFragment(RIGHT_PANEL_BG_FRAGMENT)
	ALCHEMY_SCENE:AddFragment(FRAME_TARGET_BLUR_STANDARD_RIGHT_PANEL_MEDIUM_LEFT_PANEL_FRAGMENT)

	PP:CreateBackground(ZO_AlchemyTopLevelInventory,	--[[#1]] nil, nil, nil, -6, 0, --[[#2]] nil, nil, nil, 0, 6)

	-- PP.ListBackdrop(ZO_EnchantingTopLevelInventoryBackpack, -3, -3, -3, 3, --[[tex]] nil, 8, 0, --[[bd]] 5, 5, 5, .6, --[[edge]] 30, 30, 30, .6)
	-- PP.ScrollBar(ZO_EnchantingTopLevelInventoryBackpack,	--[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, true)

	PP.Anchor(ZO_AlchemyTopLevelInventory,				--[[#1]] TOPRIGHT, ZO_AlchemyTopLevel, TOPRIGHT, 0, 100, --[[#2]] true, BOTTOMRIGHT, ZO_AlchemyTopLevel, BOTTOMRIGHT, 0, -80)
	
	PP.Anchor(ZO_AlchemyTopLevelModeMenu,				--[[#1]] BOTTOM, ZO_AlchemyTopLevelInventory, TOP, -40, 0)
	PP.Anchor(ZO_AlchemyTopLevelInventoryFilterDivider,	--[[#1]] TOP, ZO_AlchemyTopLevelInventory, TOP, 0, 60)

--===============================================================================================--
--==PROVISIONER_SCENE==-- --==SCENE_MANAGER:GetScene('provisioner')==--
	PROVISIONER_SCENE:RemoveFragment(RIGHT_PANEL_BG_FRAGMENT)
	PROVISIONER_SCENE:AddFragment(FRAME_TARGET_BLUR_CENTERED_FRAGMENT)

	local ingredientRowsContainer	= PROVISIONER.ingredientRowsContainer
	local ingredientRows			= PROVISIONER.ingredientRows
	local multiCraftContainer		= PROVISIONER.multiCraftContainer
	local resultTooltip				= PROVISIONER.resultTooltip
	local detailsPane				= PROVISIONER.detailsPane
	local recipeTree				= PROVISIONER.recipeTree

	local provisionerPanel = CreateControl("$(parent)Panel", ZO_ProvisionerTopLevel, CT_CONTROL)
	provisionerPanel:SetWidth(565)
	PP.Anchor(provisionerPanel,				--[[#1]] TOPRIGHT, ZO_ProvisionerTopLevel, TOPRIGHT, 0, 100, --[[#2]] true, BOTTOMRIGHT, ZO_ProvisionerTopLevel, BOTTOMRIGHT, 0, -80)
	PP:CreateBackground(provisionerPanel,	--[[#1]] nil, nil, nil, -6, 0, --[[#2]] nil, nil, nil, 0, 6)

	PP.Anchor(ZO_ProvisionerTopLevelTabs, --[[#1]] TOPRIGHT, provisionerPanel, TOPRIGHT, -33, 14)
	ZO_ProvisionerTopLevelTabs["m_object"]["m_buttonPadding"] = -5
	ZO_ProvisionerTopLevelTabs["m_object"]["m_point"] = 8
	ZO_ProvisionerTopLevelTabs["m_object"]["m_relativePoint"] = 2
	PP.Anchor(ZO_ProvisionerTopLevelTabsLabel,	--[[#1]] RIGHT, ZO_ProvisionerTopLevelTabs, LEFT, -20, 0)
	PP.Anchor(ZO_ProvisionerTopLevelInfoBar, --[[#1]] TOPLEFT,	provisionerPanel, BOTTOMLEFT, 0, 0,	--[[#2]] true, TOPRIGHT, provisionerPanel, BOTTOMRIGHT, 0, 0)

	PP.Anchor(ZO_ProvisionerTopLevelNavigationContainer, --[[#1]] TOPRIGHT,	provisionerPanel, TOPRIGHT, 0, 100,	--[[#2]] true, BOTTOMRIGHT, provisionerPanel, BOTTOMRIGHT, 0, 0)
	ZO_ProvisionerTopLevelNavigationContainer:SetWidth(565)
	PP.ScrollBar(ZO_ProvisionerTopLevelNavigationContainer,	--[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, true)
	ZO_Scroll_SetMaxFadeDistance(ZO_ProvisionerTopLevelNavigationContainer, 10)
	
	ZO_ProvisionerTopLevelDetailsIngredientsLabel:SetHidden(true)
	-- ZO_ProvisionerTopLevelNavigationDivider:SetHidden(true)
	ZO_ProvisionerTopLevelDetailsDivider:SetHidden(true)
	-- ZO_ProvisionerTopLevelMenuBarDivider:SetHidden(true

	PP.Anchor(ZO_ProvisionerTopLevelNavigationDivider,	--[[#1]] nil, nil, nil, 0, 34)
	PP.Anchor(ZO_ProvisionerTopLevelMenuBarDivider,	--[[#1]] TOP, provisionerPanel, TOP, 0, 60)

	PP.Anchor(ZO_ProvisionerTopLevelHaveIngredients,	--[[#1]] BOTTOMLEFT, ZO_ProvisionerTopLevelNavigationContainer, TOPLEFT, 6, -14)
	PP.Anchor(ZO_ProvisionerTopLevelHaveSkills,			--[[#1]] LEFT, ZO_ProvisionerTopLevelHaveIngredientsLabel, RIGHT, 20, 0)

	-- PP.Anchor(ZO_ProvisionerTopLevelTooltip, --[[#1]] BOTTOM, ZO_ProvisionerTopLevel, BOTTOM, 0, -300)
	PP.Anchor(detailsPane, --[[#1]] BOTTOM, ZO_ProvisionerTopLevel, BOTTOM, 0, -160)
	-- detailsPane:SetHidden(true)
	ZO_PreHook(resultTooltip, 'SetHidden', function(self, hidden)
		detailsPane:SetHidden(hidden)
	end)

	ZO_ProvisionerTopLevelDetailsIngredients:SetScale(1)
	ZO_ProvisionerTopLevelDetailsIngredients:SetParent(detailsPane)

	PP.Anchor(ingredientRowsContainer, --[[#1]] BOTTOM, multiCraftContainer, TOP, 0, 20)
	PP.Anchor(resultTooltip, --[[#1]] BOTTOM, ingredientRowsContainer, TOP, 0, 10)

	---PROVISIONER.ingredientRowsContainer
    local ingredientAnchor = ZO_Anchor:New(TOPLEFT, ingredientRowsContainer, TOPLEFT, 0, 0)

	local PROVISIONER_SLOT_ROW_WIDTH = 220
	local PROVISIONER_SLOT_ROW_HEIGHT = 48

	for i = 1, #ingredientRows do
		local slot = ingredientRows[i]
		ZO_Anchor_BoxLayout(ingredientAnchor, slot["control"], i - 1, 3, 3, 3, PROVISIONER_SLOT_ROW_WIDTH, PROVISIONER_SLOT_ROW_HEIGHT, 0, 0)

		slot["control"]:SetDimensions(PROVISIONER_SLOT_ROW_WIDTH, PROVISIONER_SLOT_ROW_HEIGHT)
		slot["control"]:GetNamedChild("Bg"):SetColor(5/255, 5/255, 5/255, .7)
		slot["icon"]:SetDimensions(40, 40)
		PP.Font(slot["nameLabel"], --[[Font]] PP.f.Expressway, 15, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
		slot["countControl"]:SetHeight(PROVISIONER_SLOT_ROW_HEIGHT)
		PP.Font(slot["countFractionDisplay"]["numeratorLabel"], --[[Font]] PP.f.Expressway, 15, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
		PP.Font(slot["countFractionDisplay"]["denominatorLabel"], --[[Font]] PP.f.Expressway, 15, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
	end
--------------------------------------
	ZO_PreHook(ZO_Provisioner, "ConfigureFromSettings", function(self, settings)
	-- function ZO_Provisioner:ConfigureFromSettings(settings)
		if self.settings ~= settings then
			self.settings = settings

			self.skillInfoHeader:SetHidden(not settings.showProvisionerSkillLevel)
			ZO_MenuBar_ClearButtons(self.tabs)
			for _, tab in ipairs(settings.tabs) do
				ZO_MenuBar_AddButton(self.tabs, tab)
			end
			ZO_MenuBar_SelectDescriptor(self.tabs, settings.tabs[1].descriptor)
		end
	end)
--------------------------------------
	-- recipeTree.defaultIndent = 20		--[[def (60)]]
	recipeTree.defaultSpacing = -11		--[[def (-10)]]
	do
		-- TreeHeaderSetup(node, control, data, open, userRequested, enabled)
		local treeHeader = recipeTree["templateInfo"]["ZO_ProvisionerNavigationHeader"]
		local existingSetupCallback = treeHeader.setupFunction
		treeHeader.setupFunction = function(node, control, data, open, userRequested, enabled)
			existingSetupCallback(node, control, data, open, userRequested, enabled)
			control:SetHeight(48)
			control["text"]:SetDimensionConstraints(0, 0, 400, 0)
		end
	end
	do
		-- ["ZO_ProvisionerNavigationEntry"]
		-- TreeEntrySetup(node, control, data, open, userRequested, enabled)
		-- local treeHeader = recipeTree["templateInfo"]["ZO_ProvisionerNavigationEntry"]
		-- local existingSetupCallback = treeHeader.setupFunction
		-- treeHeader.setupFunction = function(node, control, data, open, userRequested, enabled)
			-- existingSetupCallback(node, control, data, open, userRequested, enabled)

			-- local text = control:GetText()
			-- local link = GetRecipeResultItemLink(data["recipeListIndex"], data["recipeIndex"])
			-- local level = GetItemLinkRequiredLevel(link)
			-- local levelcp = GetItemLinkRequiredChampionPoints(link)
			-- if levelcp > 0 then
				-- control:SetText(string.rep(" " , 6 - string.len(levelcp) * 2) .. "|cbababa*" .. levelcp .. "|r   " .. text)
			-- elseif level > 1 then
				-- control:SetText(string.rep(" " , 8 - string.len(level) * 2) .. "|cbababa" .. level .. "|r   " .. text)
			-- else
				-- control:SetText(string.rep(" " , 8) .. "   " .. text)
			-- end
		-- end
	end
	
--------------------------------------
	local buttonT = CreateControlFromVirtual("$(parent)ShowTooltip", ZO_ProvisionerTopLevel, "ZO_CheckButton")
	buttonT:SetAnchor(LEFT, ZO_ProvisionerTopLevelHaveIngredientsLabel, LEFT, 0, -50)
	ZO_CheckButton_SetLabelText(buttonT, GetString(PP_LAM_CRAFT_STATIONS_PROVISIONER_SHOWTOOLTIP))

	local function OnAutoCheckChanged()
		SV.Provisioner_ShowTooltip = ZO_CheckButton_IsChecked(buttonT)
	end

	ZO_CheckButton_SetToggleFunction(buttonT, OnAutoCheckChanged)
	ZO_CheckButton_SetCheckState(buttonT, SV.Provisioner_ShowTooltip)

	PROVISIONER.ingredientTooltipRow = {}
	local _, _, maxWidth = ItemTooltip:GetDimensionConstraints()
	for i = 1, GetMaxRecipeIngredients() do
		local control = CreateControl("$(parent)IngredientTooltipRow" .. i, ingredientRowsContainer, CT_CONTROL)
		control:SetWidth(maxWidth)

		control.name = CreateControl("$(parent)Name", control, CT_LABEL)
		local name = control.name
		name:SetFont(PP.f.Expressway)
		name:SetAnchor(LEFT, control, LEFT, 5, 0)
		name:SetMaxLineCount(1)
		name:SetWrapMode(TEXT_WRAP_MODE_ELLIPSIS)
		name:SetHorizontalAlignment(TEXT_ALIGN_LEFT)

		control.count = CreateControl("$(parent)Count", control, CT_LABEL)
		local count = control.count
		count:SetFont("PP.f.Expressway")
		count:SetAnchor(RIGHT, control, RIGHT, -5, 0)
		count:SetMaxLineCount(1)
		count:SetWrapMode(TEXT_WRAP_MODE_ELLIPSIS)
		count:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)

		name:SetAnchor(RIGHT, count, LEFT, -12, 0)

		table.insert(PROVISIONER.ingredientTooltipRow, control)
	end
--------------------------------------
	ZO_PreHook("ZO_ProvisionerNavigationEntry_OnMouseEnter", function(self)
		if not SV.Provisioner_ShowTooltip then return end
		ZO_SelectableLabel_OnMouseEnter(self)
		InitializeTooltip(ItemTooltip, self, RIGHT, -64, 0)

		local recipeListIndex		= self["data"]["recipeListIndex"]
		local recipeIndex			= self["data"]["recipeIndex"]

		ItemTooltip:SetProvisionerResultItem(recipeListIndex, recipeIndex)

		for ingredientIndex = 1, self["data"]["numIngredients"] do
			local name, icon, requiredQuantity, _, quality = GetRecipeIngredientItemInfo(recipeListIndex, recipeIndex, ingredientIndex)
			local ingredientCount = GetCurrentRecipeIngredientCount(recipeListIndex, recipeIndex, ingredientIndex)
			local ingredientRow = PROVISIONER.ingredientTooltipRow[ingredientIndex]

			ingredientRow.name:SetText(zo_iconFormat(icon, 30, 30) .. "  " .. zo_strformat(SI_TOOLTIP_ITEM_NAME, name))
			ingredientRow.name:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, quality))
			ingredientRow.count:SetText(requiredQuantity .. " " .. zo_iconFormat("/esoui/art/treeicons/housing_indexicon_hearth_up.dds", 30, 30) .. string.rep(" " , 10 - string.len(ingredientCount) * 2) .. ingredientCount .. " " .. zo_iconFormat("EsoUI/Art/Tooltips/icon_craft_bag.dds", 26, 26))

			ItemTooltip:AddControl(ingredientRow)
			ingredientRow:SetAnchor(CENTER)
		end

		if self.enabled and (not self.meetsLevelReq or not self.meetsQualityReq) then
			--loop over tradeskills
			if not self.meetsLevelReq then
				 for tradeskill, levelReq in pairs(self.data.tradeskillsLevelReqs) do
					local level = GetNonCombatBonus(GetNonCombatBonusLevelTypeForTradeskillType(tradeskill))
					if level < levelReq then
						local levelPassiveAbilityId = GetTradeskillLevelPassiveAbilityId(tradeskill)
						local levelPassiveAbilityName = GetAbilityName(levelPassiveAbilityId)
						ItemTooltip:AddLine(zo_strformat(SI_RECIPE_REQUIRES_LEVEL_PASSIVE, levelPassiveAbilityName, levelReq), "", ZO_ERROR_COLOR:UnpackRGBA())
					end
				end
			end
			if not self.meetsQualityReq then
				ItemTooltip:AddLine(zo_strformat(SI_PROVISIONER_REQUIRES_RECIPE_QUALITY, self.data.qualityReq), "", ZO_ERROR_COLOR:UnpackRGBA())
			end
		end
		return true
	end)
	ZO_PreHook("ZO_ProvisionerNavigationEntry_OnMouseExit", function(self)
		if not SV.Provisioner_ShowTooltip then return end
		ZO_SelectableLabel_OnMouseExit(self)
		ClearTooltip(ItemTooltip)
		return true
	end)
--===============================================================================================--
end