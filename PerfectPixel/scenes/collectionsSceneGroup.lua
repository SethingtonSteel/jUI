PP.collectionsSceneGroup = function()
	
	local fragments	= {RIGHT_BG_FRAGMENT, TREE_UNDERLAY_FRAGMENT, TITLE_FRAGMENT, COLLECTIONS_TITLE_FRAGMENT, MEDIUM_LEFT_PANEL_BG_FRAGMENT}
	local scenes	= {
		{COLLECTIONS_BOOK_SCENE,		COLLECTIONS_BOOK,					},
		{DLC_BOOK_SCENE,				DLC_BOOK_KEYBOARD,					},
		{HOUSING_BOOK_SCENE,			HOUSING_BOOK_KEYBOARD,				},
		{ZO_OUTFIT_STYLES_BOOK_SCENE,	ZO_OUTFIT_STYLES_BOOK_KEYBOARD,		},
		{nil,							ZO_OUTFIT_STYLES_PANEL_KEYBOARD,	},
		{ITEM_SETS_BOOK_SCENE,			ITEM_SET_COLLECTIONS_BOOK_KEYBOARD,	},
	}

	for i=1, #scenes do
		local scene			= scenes[i][1]
		local gVar			= scenes[i][2]
		local tlw			= gVar.control
		local list			= gVar.gridListPanelList	and gVar.gridListPanelList.list
		local search		= gVar.contentSearchEditBox	and gVar.contentSearchEditBox:GetParent()
		local categories	= gVar.categories
		local progressBar	= gVar.progressBar or gVar.categoryProgress
		
		if scene then
			for i=1, #fragments do
				local fragment = fragments[i]
				if scene:HasFragment(fragment) then
					scene:RemoveFragment(fragment)
				end
			end
			scene:AddFragment(PP_BACKDROP_FRAGMENT)
			PP.SetBackdrop(1, tlw, scene, -10, -10, 0, 10)

			PP.Anchor(tlw, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 120, --[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -70)
		end
		if categories then
			PP.Anchor(categories, --[[#1]] TOPLEFT, tlw, TOPLEFT, 0, 50, --[[#2]] true, BOTTOMLEFT, tlw, BOTTOMLEFT, 0, 0)
			PP.ScrollBar(categories, --[[sb_c]] 180, 180, 180, .8, --[[bd_c]] 20, 20, 20, .6, false)
			ZO_Scroll_SetMaxFadeDistance(categories, 10)
		end
		if search then
			search:GetNamedChild("Label"):SetHidden(true)
			PP.Anchor(search, --[[#1]] TOPLEFT, tlw, TOPLEFT, 10, 10)
		end
		if list then
			ZO_Scroll_SetMaxFadeDistance(list, 10)
			PP.ScrollBar(list, --[[sb_c]] 180, 180, 180, .8, --[[bd_c]] 20, 20, 20, .6, false)
		end
		if progressBar then
			PP.Bar(progressBar, --[[h]] 14, --[[f]] 15)
		end
	end

--COLLECTIONS_BOOK_SCENE, COLLECTIONS_BOOK

	PP.Anchor(ZO_CollectionsBook_TopLevelList, --[[#1]] TOPLEFT, ZO_CollectionsBook_TopLevelCategories, TOPRIGHT, 0, -10, --[[#2]] true, BOTTOMRIGHT, ZO_CollectionsBook_TopLevel, BOTTOMRIGHT,	0, 0)

	local dataType = ZO_ScrollList_GetDataTypeTable(ZO_CollectionsBook_TopLevelListContainerList, 1)
	local existingSetupCallback = dataType.setupCallback
	dataType["controlHeight"] = 120
	dataType["controlWidth"] = 180
	dataType["spacingX"] = 6
	dataType["spacingY"] = 6
	dataType.setupCallback = function(control, data)
		existingSetupCallback(control, data)
		control:SetDimensions(dataType["controlWidth"], dataType["controlHeight"])
		if control:GetNamedChild("OverlayBorder") then
			local backdrop = control:GetNamedChild("OverlayBorder")
			backdrop:SetCenterColor(10/255, 10/255, 10/255, .7)
			backdrop:SetCenterTexture(nil, 4, 0)
			backdrop:SetEdgeColor(40/255, 40/255, 40/255, .9)
			backdrop:SetEdgeTexture(nil, 1, 1, 1, 0)
			backdrop:SetInsets(1, 1, -1, -1)
			backdrop:SetDrawLayer(0)
			backdrop:SetDrawTier(0)
		end
		if control:GetNamedChild("Highlight") then
			local highlight = control:GetNamedChild("Highlight")
			highlight:SetTextureCoords(.29, .575, .002, .3)
			PP.Anchor(highlight, --[[#1]] TOPLEFT, control, TOPLEFT, 1, 1, --[[#2]] true, BOTTOMRIGHT, control, BOTTOMRIGHT,	-1, -1)
		end
		if control:GetNamedChild("Title") then
			local title = control:GetNamedChild("Title")
			PP.Font(title, --[[Font]] PP.f.u67, 16, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
		end
	end

--ZO_OUTFIT_STYLES_BOOK_SCENE, ZO_OUTFIT_STYLES_BOOK_KEYBOARD, ZO_OUTFIT_STYLES_PANEL_KEYBOARD


	PP.SetBackdrop(2, ZO_RestyleSheetWindowTopLevel_Keyboard,		ZO_RESTYLE_SHEET_WINDOW_FRAGMENT, -20, -30, 10, -32)

	PP.Anchor(ZO_OutfitStylesPanelTopLevel_Keyboard, --[[#1]] TOPRIGHT,	GuiRoot, TOPRIGHT, -2, 122, --[[#2]] true, BOTTOMRIGHT,	GuiRoot, BOTTOMRIGHT,	-8, -70)
	PP.Anchor(ZO_OutfitStylesPanelTopLevel_KeyboardPaneContainer, --[[#1]] TOPLEFT, nil, TOPLEFT,	0, 0, --[[#2]] true, BOTTOMRIGHT, nil, BOTTOMRIGHT,	8, 0)
	
	PP.Anchor(ZO_RestyleSheetWindowTopLevel_KeyboardTitleDividerTexture,					--[[#1]] TOPLEFT, nil, TOPLEFT,	-140, 0, --[[#2]] true, BOTTOMRIGHT, nil, BOTTOMRIGHT, 90, 0)

	PP.Anchor(ZO_RestyleSheetWindowTopLevel_KeyboardEquipmentSheetSecondaryWeaponSwap, --[[#1]] TOPRIGHT, ZO_RestyleSheetWindowTopLevel_KeyboardEquipmentSheetSecondary, BOTTOMRIGHT,	5, -5)
	
	PP.Anchor(ZO_RestyleSheetWindowTopLevel_KeyboardEquipmentSheetPrimaryDividerTexture,	--[[#1]] TOPLEFT, nil, TOPLEFT,	-140, 0, --[[#2]] true, BOTTOMRIGHT, nil, BOTTOMRIGHT, 90, 0)
	ZO_RestyleSheetWindowTopLevel_KeyboardEquipmentSheetSecondaryDivider:SetHidden(true)

	PP.Anchor(ZO_RestyleSheetWindowTopLevel_KeyboardOutfitStylesSheetSecondaryWeaponSwap, --[[#1]] TOPRIGHT, ZO_RestyleSheetWindowTopLevel_KeyboardOutfitStylesSheetSecondary, BOTTOMRIGHT,	5, -5)
	
	PP.Anchor(ZO_RestyleSheetWindowTopLevel_KeyboardOutfitStylesSheetPrimaryDividerTexture, --[[#1]] TOPLEFT, nil, TOPLEFT,	-140, 0, --[[#2]] true, BOTTOMRIGHT, nil, BOTTOMRIGHT, 90, 0)
	ZO_RestyleSheetWindowTopLevel_KeyboardOutfitStylesSheetSecondaryDivider:SetHidden(true)

	PP.Anchor(ZO_RestyleSheetWindowTopLevel_KeyboardCollectibleSheetPrimaryDividerTexture, --[[#1]] TOPLEFT, nil, TOPLEFT,	-140, 0, --[[#2]] true, BOTTOMRIGHT, nil, BOTTOMRIGHT, 90, 0)
	ZO_RestyleSheetWindowTopLevel_KeyboardCollectibleSheetSecondaryDivider:SetHidden(true)

	local dataType = ZO_ScrollList_GetDataTypeTable(ZO_OutfitStylesPanelTopLevel_KeyboardPaneContainerList, 1)
	local existingSetupCallback = dataType.setupCallback
	dataType["controlHeight"] = 68
	dataType["controlWidth"] = 68
	dataType["spacingX"] = 6
	dataType["spacingY"] = 6
	dataType.setupCallback = function(control, data)
		existingSetupCallback(control, data)
		control:SetDimensions(dataType["controlWidth"], dataType["controlHeight"])

		local backdrop = control:GetNamedChild("Backdrop")
		backdrop:SetCenterColor(10/255, 10/255, 10/255, .7)
		backdrop:SetCenterTexture(nil, 4, 0)
		backdrop:SetEdgeColor(40/255, 40/255, 40/255, .9)
		backdrop:SetEdgeTexture(nil, 1, 1, 1, 0)
		backdrop:SetInsets(1, 1, -1, -1)
		---------------------------------
	end

--ITEM_SETS_BOOK_SCENE, ITEM_SET_COLLECTIONS_BOOK_KEYBOARD
	local ISB_TLW			= ZO_ItemSetsBook_Keyboard_TopLevel
	local ISB_List			= ZO_ItemSetsBook_Keyboard_TopLevelCategoryContentListContainerList

	PP.Anchor(ZO_ItemSetsBook_Keyboard_TopLevelFilters,		--[[#1]] TOPLEFT, ISB_TLW, TOPLEFT,	0, 0, --[[#2]] true, TOPRIGHT, ISB_TLW, TOPRIGHT, 0, 0)

	PP.Anchor(ZO_ItemSetsBook_Keyboard_TopLevelCategoryContentCategoryProgress, --[[#1]] TOPLEFT, ZO_ItemSetsBook_Keyboard_TopLevelCategoryContent, TOPLEFT, 0, 0, --[[#2]] true, TOPRIGHT, ZO_ItemSetsBook_Keyboard_TopLevelCategoryContent, TOPRIGHT, -8, 0)

	PP.Anchor(ZO_ItemSetsBook_Keyboard_TopLevelCategoryContent,		--[[#1]] TOPLEFT, ZO_ItemSetsBook_Keyboard_TopLevelCategories, TOPRIGHT,	10, 0, --[[#2]] true, BOTTOMRIGHT, ZO_ItemSetsBook_Keyboard_TopLevel, BOTTOMRIGHT, 0, 0)
	PP.Anchor(ZO_ItemSetsBook_Keyboard_TopLevelCategoryContentList,	--[[#1]] TOPLEFT, ZO_ItemSetsBook_Keyboard_TopLevelCategoryContentCategoryProgress, BOTTOMLEFT,	0, 10, --[[#2]] true, BOTTOMRIGHT, ZO_ItemSetsBook_Keyboard_TopLevelCategoryContent, BOTTOMRIGHT, 0, 0)

	--------------------------
	local dataType_1 = ZO_ScrollList_GetDataTypeTable(ISB_List, 1)
	local existingSetupCallback = dataType_1.setupCallback
	dataType_1["controlHeight"] = 68
	dataType_1["controlWidth"] = 68
	dataType_1["spacingX"] = 6
	dataType_1["spacingY"] = 6
	dataType_1.setupCallback = function(control, data)
		existingSetupCallback(control, data)
		control:SetDimensions(dataType_1["controlWidth"], dataType_1["controlHeight"])

		local backdrop = control:GetNamedChild("OverlayBorder")
		backdrop:SetCenterColor(10/255, 10/255, 10/255, .7)
		backdrop:SetCenterTexture(nil, 4, 0)
		backdrop:SetEdgeColor(40/255, 40/255, 40/255, .9)
		backdrop:SetEdgeTexture(nil, 1, 1, 1, 0)
		backdrop:SetInsets(1, 1, -1, -1)
		backdrop:SetDrawLayer(0)
		backdrop:SetDrawLevel(0)
		backdrop:SetDrawTier(0)
	end
	local dataType_2 = ZO_ScrollList_GetDataTypeTable(ISB_List, 2)
	local existingSetupCallback = dataType_2.setupCallback
	dataType_2.setupCallback = function(control, data)
		existingSetupCallback(control, data)

		local progressBar = control:GetNamedChild("Progress")
		PP.Bar(progressBar, --[[height]] 14, --[[fontSize]] 15)
	end
end