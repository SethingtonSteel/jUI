PP.tradingHouseScene = function()

	TRADING_HOUSE_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	-- TRADING_HOUSE_SCENE:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	TRADING_HOUSE_SCENE:AddFragment(FRAME_TARGET_BLUR_STANDARD_RIGHT_PANEL_FRAGMENT)
	PP:ForceRemoveFragment(TRADING_HOUSE_SCENE, TREE_UNDERLAY_FRAGMENT)

	PP:CreateBackground(ZO_TradingHouse,		--[[#1]] nil, nil, nil, -20, 0, --[[#2]] nil, nil, nil, 0, 20, true)
	PP:HideBackgroundForScene(TRADING_HOUSE_SCENE, ZO_PlayerInventory.PP_BG)
	PP:HideBackgroundForScene(TRADING_HOUSE_SCENE, ZO_CraftBag.PP_BG)

	local tradingHouseLayout = BACKPACK_TRADING_HOUSE_LAYOUT_FRAGMENT
	tradingHouseLayout.layoutData.inventoryTopOffsetY				= 100
	tradingHouseLayout.layoutData.inventoryBottomOffsetY			= -91
	tradingHouseLayout.layoutData.width								= 635
	tradingHouseLayout.layoutData.sortByNameWidth					= 311

--==ZO_TradingHouse==============================================================================--

	local rowHeight, controlHeight = 44, 42
	local function UpdateSetupCallback()
		local list = TRADING_HOUSE.searchResultsList
		list.uniformControlHeight = rowHeight
		ZO_Scroll_SetMaxFadeDistance(list, PP.SV.list_skin.list_fade_distance)
		for i=1, 3 do
			if ZO_ScrollList_GetDataTypeTable(list, i) then
				local dataType = ZO_ScrollList_GetDataTypeTable(list, i)
				local orig_SetupCallback = dataType.setupCallback
				dataType.height = rowHeight
				dataType.setupCallback = function(rowControl, result)
					orig_SetupCallback(rowControl, result)
					rowControl:SetHeight(controlHeight)

					local button			= rowControl:GetNamedChild("Button")
					local stack				= rowControl:GetNamedChild("ButtonStackCount")
					local name				= rowControl:GetNamedChild("Name")
					local sellPrice			= rowControl:GetNamedChild("SellPrice")
					local pricePerUnit		= rowControl:GetNamedChild("SellPricePerUnit")
					local timeRemaining		= rowControl:GetNamedChild("TimeRemaining")
					local trait				= rowControl:GetNamedChild("TraitInfo")
					local bg				= rowControl:GetNamedChild("Bg")
					local hl				= rowControl:GetNamedChild("Highlight")

					--"Button"-------------
					if button then
						button:SetDimensions(36, 36)
						PP.Anchor(button, --[[#1]] LEFT, nil, LEFT, 5, 0)
					end
					--"ButtonStackCount"-------------
					if stack then
						PP.Font(stack, --[[Font]] PP.f.u67, 15, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
						PP.Anchor(stack, --[[#1]] BOTTOMRIGHT, nil, BOTTOMRIGHT, 8, 2)
					end
					--"Name"-------------
					if name then
						PP.Font(name, --[[Font]] PP.f.u67, 15, "shadow", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
						PP.Anchor(name, --[[#1]] TOPLEFT, nil, TOPLEFT, 60, 2)
						name:SetWidth(250)
						name:SetLineSpacing(0)
						name:SetVerticalAlignment(0)
						name:SetMaxLineCount(1)
						name:SetWrapMode(1)
					end
					-- "SellPrice"--------------------
					if sellPrice then
						PP.Font(sellPrice, --[[Font]] PP.f.u67, 15, "shadow", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
						if result["stackCount"] == 1 then
							PP.Anchor(sellPrice, --[[#1]] RIGHT, rowControl, RIGHT, -5, 0)
							pricePerUnit:SetHidden(true)
						else
							PP.Anchor(sellPrice, --[[#1]] TOPRIGHT, rowControl, TOPRIGHT, -5, 2)
							pricePerUnit:SetHidden(false)
						end
					end
					--SellPricePerUnit--------------------
					if pricePerUnit then
						PP.Font(pricePerUnit, --[[Font]] PP.f.u67, 14, "shadow", --[[Alpha]] .9, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
						PP.Anchor(pricePerUnit, --[[#1]] TOPRIGHT, sellPrice, BOTTOMRIGHT, 0, -2)
						if not AwesomeGuildStore then
							pricePerUnit:SetText("@" .. pricePerUnit:GetText():gsub("|t.-:.-:", "|t14:14:"))
						end
					end
					--TimeRemaining--------------------
					if timeRemaining then
						PP.Font(timeRemaining, --[[Font]] PP.f.u67, 15, "shadow", --[[Alpha]] .9, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
						if MasterMerchant then
							PP.Anchor(timeRemaining, --[[#1]] TOPRIGHT, rowControl, TOPRIGHT, -110, 2)
						else
							PP.Anchor(timeRemaining, --[[#1]] RIGHT, rowControl, RIGHT, -110, 0)
						end
					end
					--"Bg"-------------
					if bg then
						bg:SetTexture(PP.t.clear)
					end
					--"Highlight"-------------
					if hl then
						hl:SetHidden(true)
					end
					--New Control--*
					--"SellerName"--------------------
					if rowControl:GetNamedChild("SellerName") and not AwesomeGuildStore then
						rowControl:GetNamedChild("SellerName"):SetText(result.sellerName)
					else
						if not AwesomeGuildStore then
							CreateControl("$(parent)SellerName", rowControl, CT_LABEL)
						end
						local sellerName = rowControl:GetNamedChild("SellerName")
						sellerName:SetText(result.sellerName)
						sellerName:SetAnchor(TOPLEFT, name, BOTTOMLEFT, 0, -4)
						sellerName:SetWidth(130)
						sellerName:SetMaxLineCount(1)
						sellerName:SetWrapMode(1)
						PP.Font(sellerName, --[[Font]] PP.f.u57, 15, "outline", --[[Alpha]] .4, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
					end
					--"Backdrop"-------------
					local backdrop = PP.CreateBackdrop(rowControl)
					backdrop:SetCenterColor(unpack(PP.SV.list_skin.list_skin_backdrop_col))
					backdrop:SetCenterTexture(PP.SV.list_skin.list_skin_backdrop, PP.SV.list_skin.list_skin_backdrop_tile_size, PP.SV.list_skin.list_skin_backdrop_tile and 1 or 0)
					backdrop:SetEdgeColor(unpack(PP.SV.list_skin.list_skin_edge_col))
					backdrop:SetEdgeTexture(PP.SV.list_skin.list_skin_edge, PP.SV.list_skin.list_skin_edge_file_width, PP.SV.list_skin.list_skin_edge_file_height, PP.SV.list_skin.list_skin_edge_thickness, 0)
					backdrop:SetInsets(PP.SV.list_skin.list_skin_backdrop_insets, PP.SV.list_skin.list_skin_backdrop_insets, -PP.SV.list_skin.list_skin_backdrop_insets, -PP.SV.list_skin.list_skin_backdrop_insets)
					backdrop:SetIntegralWrapping(PP.SV.list_skin.list_skin_edge_integral_wrapping)
				end
			end
		end
	end

	PP.Anchor(ZO_TradingHouse,							--[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 100, --[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -80)
	PP.Font(ZO_TradingHouseTitleLabel, --[[Font]] PP.f.u67, 30, "outline", --[[Alpha]] .9, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .8)
	ZO_TradingHouseTitleDivider:SetHidden(true)

	-- PP.ListBackdrop(ZO_TradingHouseBrowseItemsRightPaneSearchResults, -3, -3, -3, 3, --[[tex]] nil, 8, 0, --[[bd]] 5, 5, 5, .6, --[[edge]] 30, 30, 30, .6)
	PP.ScrollBar(ZO_TradingHouseBrowseItemsRightPaneSearchResults, --[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, true)
	PP.Anchor(ZO_TradingHouseBrowseItemsRightPaneSearchResults, --[[#1]] TOPLEFT, ZO_TradingHouseBrowseItemsRightPaneSearchSortBy, BOTTOMLEFT, 0, 0 , --[[#2]] true, BOTTOMRIGHT, ZO_TradingHouseBrowseItemsRightPane, BOTTOMRIGHT, 0, 0)

	PP.Anchor(ZO_TradingHouseBrowseItemsRightPane,		--[[#1]] TOPLEFT, nil, TOPRIGHT, 30, 0, --[[#2]] true, BOTTOMRIGHT, nil, BOTTOMRIGHT, 0, -11)
	PP.Anchor(ZO_TradingHouseSubcategoryTabs,			--[[#1]] BOTTOMRIGHT, nil, TOPRIGHT, -33, -14)
	PP.Anchor(ZO_TradingHouseTitle,						--[[#1]] BOTTOMLEFT, ZO_TradingHouse, TOPLEFT, -50, 6)

	ZO_TradingHouseSearchControlsTopDivider:SetHidden(true)

	PP.Anchor(ZO_TradingHouseItemNameSearch,			--[[#1]] TOPLEFT, ZO_TradingHouse, TOPLEFT, 0, 14)
	ZO_TradingHouseItemNameSearch:SetDimensionConstraints(250, 26, 250, 26)
	PP.Anchor(ZO_TradingHouseItemNameSearchBox,			--[[#1]] TOPLEFT, nil, TOPLEFT, 3, 1, --[[#2]] true, BOTTOMRIGHT, nil, BOTTOMRIGHT, -3, 0)
	ZO_TradingHouseItemNameSearchBoxText:SetVerticalAlignment(1)
	ZO_TradingHouseItemNameSearchLabel:SetAlpha(0)

	-- PP.Anchor(ZO_TradingHouseBrowseItemsRightPaneSearchSortBy, --[[#1]] BOTTOMLEFT, ZO_TradingHouseBrowseItemsRightPaneSearchResults, TOPLEFT, 0, 0, --[[#2]] true, BOTTOMRIGHT, ZO_TradingHouseBrowseItemsRightPaneSearchResults, TOPRIGHT, 0, 0)
	
	local function UpdateSortBy() --SetParent()
		local sortBy = ZO_TradingHouseBrowseItemsRightPaneSearchSortBy
		sortBy:SetHeight(28)
		if not ZO_TradingHouseBrowseItemsRightPaneSearchSortByPriceSeparator then
			CreateControl("$(parent)Separator", sortBy:GetNamedChild("Price"), CT_LABEL)
		end
		local separator = sortBy:GetNamedChild("PriceSeparator")
		separator:SetText("/")

		sortBy:GetNamedChild("PriceName"):SetParent(sortBy)
		PP.Anchor(sortBy:GetNamedChild("PriceName"),			--[[#1]] RIGHT, sortBy, RIGHT, -26, 0)
		sortBy:GetNamedChild("Price"):SetParent(sortBy:GetNamedChild("PriceName"))
		PP.Anchor(sortBy:GetNamedChild("Price"),				--[[#1]] TOPLEFT, sortBy:GetNamedChild("PriceName"), TOPLEFT, 0, 0, --[[#2]] true, BOTTOMRIGHT, sortBy:GetNamedChild("PriceName"), BOTTOMRIGHT, 0, 0)

		separator:SetParent(sortBy)
		PP.Anchor(separator,									--[[#1]] RIGHT, sortBy:GetNamedChild("PriceName"), LEFT, -6, 0)

		sortBy:GetNamedChild("PricePerUnitName"):SetParent(sortBy)
		PP.Anchor(sortBy:GetNamedChild("PricePerUnitName"),		--[[#1]] RIGHT, separator, LEFT, -18, 0)
		sortBy:GetNamedChild("PricePerUnit"):SetParent(sortBy:GetNamedChild("PricePerUnitName"))
		PP.Anchor(sortBy:GetNamedChild("PricePerUnit"),			--[[#1]] TOPLEFT, sortBy:GetNamedChild("PricePerUnitName"), TOPLEFT, 0, 0, --[[#2]] true, BOTTOMRIGHT, sortBy:GetNamedChild("PricePerUnitName"), BOTTOMRIGHT, 0, 0)

		sortBy:GetNamedChild("TimeRemainingName"):SetParent(sortBy)
		PP.Anchor(sortBy:GetNamedChild("TimeRemainingName"),	--[[#1]] RIGHT, sortBy:GetNamedChild("PricePerUnitName"), LEFT, -20, 0)
		sortBy:GetNamedChild("TimeRemaining"):SetParent(sortBy:GetNamedChild("TimeRemainingName"))
		PP.Anchor(sortBy:GetNamedChild("TimeRemaining"),		--[[#1]] TOPLEFT, sortBy:GetNamedChild("TimeRemainingName"), TOPLEFT, 0, 0, --[[#2]] true, BOTTOMRIGHT, sortBy:GetNamedChild("TimeRemainingName"), BOTTOMRIGHT, 0, 0)

		sortBy:GetNamedChild("NameName"):SetParent(sortBy)
		PP.Anchor(sortBy:GetNamedChild("NameName"),	--[[#1]] LEFT, sortBy, LEFT, 60, 0)
		sortBy:GetNamedChild("Name"):SetParent(sortBy:GetNamedChild("NameName"))
		PP.Anchor(sortBy:GetNamedChild("Name"),		--[[#1]] TOPLEFT, sortBy:GetNamedChild("NameName"), TOPLEFT, 0, 0, --[[#2]] true, BOTTOMRIGHT, sortBy:GetNamedChild("NameName"), BOTTOMRIGHT, 0, 0)

		local tabSortBy = {"NameName", "TimeRemainingName", "PriceName", "PricePerUnitName", "PriceSeparator"}
		for _, v in ipairs(tabSortBy) do
			local text = sortBy:GetNamedChild(v)
			PP.Font(text, --[[Font]] PP.f.u67, 16, "outline", --[[Alpha]] nil, --[[Color]] 197, 194, 158, 1, --[[StyleColor]] 0, 0, 0, .5)
			text:SetWidth(text:GetStringWidth())
		end
	end

	local money = ZO_TradingHouseSearchControlsMoney
	PP.Anchor(money,	--[[#1]] TOPRIGHT,	nil, TOPRIGHT, -4, 4)
	-- PP.Font(money,		--[[Font]] PP.f.u67, 18, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .6)
	-- ZO_PreHookHandler(money, 'OnTextChanged', function()
		-- money:SetFont(PP.f.u67 .. "|18|outline")
	-- end)


--==ZO_TradingHouseBrowseItemsLeftPane===========================================================--
	PP.Anchor(ZO_TradingHouseBrowseItemsLeftPaneCategoryListContainer, --[[#1]] TOPLEFT, ZO_TradingHouseBrowseItemsLeftPaneGlobalFeatureArea, BOTTOMLEFT, -15, 10, --[[#2]] true, BOTTOMRIGHT, ZO_TradingHouseBrowseItemsLeftPane, BOTTOMRIGHT, 0, 0)

	PP.Anchor(ZO_TradingHouseBrowseItemsLeftPaneGlobalFeatureArea, --[[#1]] TOPLEFT, ZO_TradingHouseBrowseItemsLeftPane, TOPLEFT, 0, 0, --[[#2]] true, TOPRIGHT, ZO_TradingHouseBrowseItemsLeftPane, TOPRIGHT, 0, 0)

	-- ZO_TradingHouseBrowseItemsLeftPaneGlobalFeatureAreaQuality:SetHeight(28)
	-- local bg = ZO_TradingHouseBrowseItemsLeftPaneGlobalFeatureAreaQualityBG
	-- bg:SetCenterTexture(PP.SV.skin_backdrop, PP.SV.skin_backdrop_tile_size, PP.SV.skin_backdrop_tile and 1 or 0)
	-- bg:SetCenterColor(unpack(PP.SV.skin_backdrop_col))
	-- bg:SetEdgeTexture(PP.SV.skin_edge, PP.SV.skin_edge_file_width, PP.SV.skin_edge_file_height, PP.SV.skin_edge_thickness, 0)
	-- bg:SetEdgeColor(unpack(PP.SV.skin_edge_col))
	-- bg:SetInsets(PP.SV.skin_backdrop_insets, PP.SV.skin_backdrop_insets, -PP.SV.skin_backdrop_insets, -PP.SV.skin_backdrop_insets)
	-- bg:SetIntegralWrapping(PP.SV.skin_edge_integral_wrapping)

	PP.Anchor(ZO_TradingHouseBrowseItemsLeftPaneGlobalFeatureAreaPriceRange, --[[#1]] TOPLEFT, ZO_TradingHouseBrowseItemsLeftPaneGlobalFeatureAreaQuality, BOTTOMLEFT, 0, 10)
	ZO_TradingHouseBrowseItemsLeftPaneGlobalFeatureAreaPriceRange:SetHeight(26)
	ZO_TradingHouseBrowseItemsLeftPaneGlobalFeatureAreaPriceRangeMaxPrice:SetDimensionConstraints(105, 26, 105, 26)
	ZO_TradingHouseBrowseItemsLeftPaneGlobalFeatureAreaPriceRangeMinPrice:SetDimensionConstraints(105, 26, 105, 26)

	local function LeftPaneUpdate()
		PP.Font(ZO_TradingHouseBrowseItemsLeftPaneGlobalFeatureAreaQualitySelectedItemText, --[[Font]] PP.f.u67, 15, "", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
	end

--==ZO_TradingHouseSearchHistoryTopLevel_Keyboard================================================--
	TRADING_HOUSE_SEARCH_HISTORY_KEYBOARD_FRAGMENT.callbackRegistry = nil

	PP:CreateBackground(ZO_TradingHouseSearchHistoryTopLevel_Keyboard,		--[[#1]] nil, nil, nil, 0, 1, --[[#2]] nil, nil, nil, -4, -2)

	PP.ScrollBar(ZO_TradingHouseSearchHistoryTopLevel_KeyboardList, --[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, true)
	PP.Anchor(ZO_TradingHouseSearchHistoryTopLevel_KeyboardList, --[[#1]] TOPLEFT, ZO_TradingHouseSearchHistoryTopLevel_Keyboard, TOPLEFT, 8, 8, --[[#2]] true, BOTTOMRIGHT, ZO_TradingHouseSearchHistoryTopLevel_Keyboard, BOTTOMRIGHT, -4, -8)
	
	ZO_TradingHouseSearchHistoryTopLevel_Keyboard:SetWidth(350)
	PP.Anchor(ZO_TradingHouseSearchHistoryTopLevel_Keyboard, --[[#1]] TOPLEFT, GuiRoot, TOPLEFT, 0, 100, --[[#2]] true, BOTTOMLEFT, GuiRoot, BOTTOMLEFT, 0, -300)

	PP.Anchor(ZO_TradingHouseSearchHistoryTopLevel_KeyboardTitle, --[[#1]] BOTTOMLEFT, ZO_TradingHouseSearchHistoryTopLevel_Keyboard, TOPLEFT, 10, 0)
	PP.Font(ZO_TradingHouseSearchHistoryTopLevel_KeyboardTitle, --[[Font]] PP.f.u67, 24, "outline", --[[Alpha]] .9, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .8)
	ZO_TradingHouseSearchHistoryTopLevel_KeyboardTitleDivider:SetHidden(true)

	local historyRowHeight, historyControlHeight = 44, 42
	local listHistory = ZO_TradingHouseSearchHistoryTopLevel_KeyboardList
	listHistory.highlightTemplate = nil
	listHistory.uniformControlHeight = historyRowHeight
	ZO_Scroll_SetMaxFadeDistance(listHistory, PP.SV.list_skin.list_fade_distance)
	local dataTypeHistory = ZO_ScrollList_GetDataTypeTable(listHistory, 1)
	local orig_SetupCallbackHistory = dataTypeHistory.setupCallback -- SetupHistoryRow(rowControl, rowData)
	dataTypeHistory.height = historyRowHeight
	dataTypeHistory.setupCallback = function(rowControl, rowData)
		orig_SetupCallbackHistory(rowControl, rowData)
		rowControl:SetHeight(historyControlHeight)

		local description		= rowControl:GetNamedChild("Description")

		--"Description"--------------------------
		if description then
			-- local r, g, b = GetInterfaceColor(INTERFACE_COLOR_TYPE_ITEM_QUALITY_COLORS, rowData["searchTable"]["Quality"] -1) --["searchTable"]
			-- if rowData["searchTable"]["Quality"] > 2 then
				-- description:SetColor(r, g, b, .9)
				-- description:SetDesaturation(.3)
			-- end
			PP.Font(description, --[[Font]] PP.f.u67, 15, "shadow", --[[Alpha]] .9, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
			PP.Anchor(description, --[[#1]] TOPLEFT, rowControl, TOPLEFT, 10, 0, --[[#2]] true, BOTTOMRIGHT, rowControl, BOTTOMRIGHT, -10, 0)
			description:SetLineSpacing(0)
			description:SetVerticalAlignment(TEXT_ALIGN_CENTER)
			description:SetMaxLineCount(2)
			description:SetWrapMode(1)
		end
		--"Backdrop"-------------
		local backdrop = PP.CreateBackdrop(rowControl)
		backdrop:SetCenterColor(unpack(PP.SV.list_skin.list_skin_backdrop_col))
		backdrop:SetCenterTexture(PP.SV.list_skin.list_skin_backdrop, PP.SV.list_skin.list_skin_backdrop_tile_size, PP.SV.list_skin.list_skin_backdrop_tile and 1 or 0)
		backdrop:SetEdgeColor(unpack(PP.SV.list_skin.list_skin_edge_col))
		backdrop:SetEdgeTexture(PP.SV.list_skin.list_skin_edge, PP.SV.list_skin.list_skin_edge_file_width, PP.SV.list_skin.list_skin_edge_file_height, PP.SV.list_skin.list_skin_edge_thickness, 0)
		backdrop:SetInsets(PP.SV.list_skin.list_skin_backdrop_insets, PP.SV.list_skin.list_skin_backdrop_insets, -PP.SV.list_skin.list_skin_backdrop_insets, -PP.SV.list_skin.list_skin_backdrop_insets)
		backdrop:SetIntegralWrapping(PP.SV.list_skin.list_skin_edge_integral_wrapping)
	end

	ZO_PreHook("ZO_TradingHouseSearchHistoryRow_Keyboard_OnMouseEnter", function(rowControl)
		rowControl.backdrop:SetCenterColor(unpack(PP.SV.list_skin.list_skin_backdrop_hl_col))
	end)
	ZO_PreHook("ZO_TradingHouseSearchHistoryRow_Keyboard_OnMouseExit", function(rowControl)
		rowControl.backdrop:SetCenterColor(unpack(PP.SV.list_skin.list_skin_backdrop_col))
	end)
--===============================================================================================--
	local function LoadFunc()
		LeftPaneUpdate()
		UpdateSetupCallback()
		UpdateSortBy()
		EVENT_MANAGER:UnregisterForEvent(PP.ADDON_NAME .. "tradingHouseScene", EVENT_OPEN_TRADING_HOUSE, LoadFunc)
	end
	EVENT_MANAGER:RegisterForEvent(PP.ADDON_NAME .. "tradingHouseScene", EVENT_OPEN_TRADING_HOUSE, LoadFunc)
end