PP.restyleStationKeyboardSceneGroup = function()

--restyle_station_keyboard--ZO_RESTYLE_SCENE--ZO_RestyleStationTopLevel_Keyboard-------------------
	local restyleStationScene = SCENE_MANAGER:GetScene('restyle_station_keyboard')

	restyleStationScene:RemoveFragment(RIGHT_BG_FRAGMENT)
	restyleStationScene:RemoveFragment(MEDIUM_LEFT_PANEL_BG_FRAGMENT)
	restyleStationScene:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	restyleStationScene:RemoveFragment(TITLE_FRAGMENT)
	restyleStationScene:RemoveFragment(RESTYLE_TITLE_FRAGMENT)
	restyleStationScene:AddFragment(PP_BACKDROP_FRAGMENT)
	restyleStationScene:AddFragment(FRAME_TARGET_BLUR_STANDARD_RIGHT_PANEL_MEDIUM_LEFT_PANEL_FRAGMENT)

	PP.SetBackdrop(1, ZO_RestyleStationTopLevel_Keyboard, 'restyle_station_keyboard', -10, -10, 0, 10)
	PP.SetBackdrop(2, ZO_RestyleSheetWindowTopLevel_Keyboard, 'restyle_station_keyboard', -20, -30, 10, -32)

	PP.Anchor(ZO_RestyleStationTopLevel_Keyboard,			--[[#1]] TOPRIGHT, nil, TOPRIGHT, 0, 120,	--[[#2]] true, BOTTOMRIGHT, nil, BOTTOMRIGHT,	0, -70)
	PP.Anchor(ZO_RestyleStationTopLevel_KeyboardCategories,	--[[#1]] TOPLEFT, nil, TOPLEFT,	0, 77,		--[[#2]] true, BOTTOMRIGHT, ZO_DyeingTopLevel_Keyboard, BOTTOMLEFT, 0, 0)
	PP.Anchor(ZO_RestyleStationTopLevel_KeyboardTabs,		--[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, -30, 64)
	PP.Anchor(ZO_RestyleStationTopLevel_KeyboardInfoBar,	--[[#1]] TOPRIGHT, ZO_RestyleStationTopLevel_Keyboard, BOTTOMRIGHT,	0, 5)

	ZO_RestyleStationTopLevel_KeyboardTabsLabel:SetHidden(false)
	ZO_DyeingTopLevel_KeyboardPaneDivider:SetHidden(true)

	PP.Anchor(ZO_DyeingTopLevel_Keyboard, --[[#1]] TOPRIGHT,	GuiRoot, TOPRIGHT, -2, 94, --[[#2]] true, BOTTOMRIGHT,	GuiRoot, BOTTOMRIGHT, -8, -70)
	PP.Anchor(ZO_DyeingTopLevel_KeyboardPane, --[[#1]] TOPLEFT, ZO_DyeingTopLevel_KeyboardPaneDivider, BOTTOMLEFT, 0, -10, --[[#2]] true, BOTTOMRIGHT, nil, BOTTOMRIGHT, 9, 0)

	-- PP.ListBackdrop(ZO_DyeingTopLevel_KeyboardPane, -10, -3, -3, 3, --[[tex]] nil, 8, 0, --[[bd]] 5, 5, 5, .6, --[[edge]] 30, 30, 30, .6)
	PP.ScrollBar(ZO_DyeingTopLevel_KeyboardPane, --[[sb_c]] 180, 180, 180, .8, --[[bd_c]] 20, 20, 20, .6, false)
	ZO_Scroll_SetMaxFadeDistance(ZO_DyeingTopLevel_KeyboardPane, 10)
	
	PP.Font(ZO_RestyleSheetWindowTopLevel_KeyboardOutfitStylesSheetCost, --[[Font]] PP.f.u67, 18, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .6)
	PP.Anchor(ZO_RestyleSheetWindowTopLevel_KeyboardOutfitStylesSheetCost, --[[#1]] TOPLEFT, ZO_RestyleSheetWindowTopLevel_KeyboardOutfitStylesSheetSecondary, BOTTOMLEFT, -10, -5)

end



