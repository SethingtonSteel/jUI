--[[
	Addon: PriceTooltip
	Author: Mladen90 (@Mladen90 EU), Infixo (CoAuthor)
	Created by Mladen90 (@Mladen90 EU)
]]--


PriceTooltip = {}
PriceTooltip_MENU = {}


local PriceTooltip_ATT_Sales = nil
local PriceTooltip_LastDivider = nil
local PriceTooltip_LastDividerPool = nil


PriceTooltip_ValidPrice = function(price) return (price or 0) > 0 end


PriceTooltip_Round = function (num, numDecimalPlaces)
	if not num then return num end

	local decimalPlaces = numDecimalPlaces or 0

	if PriceTooltip.SavedVariables.RoundPrice then decimalPlaces = 0 end

	local mult = 10 ^ decimalPlaces
	return math.floor(num * mult + 0.5) / mult
end


PriceTooltip_NumberFormat = function(amount)
	local formatted = amount
	local separator = PriceTooltip.SavedVariables.Separator

	if separator == PRICE_TOOLTIP_SPACE then separator = " " end

	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1" .. separator .. "%2")
		if (k==0) then break end
	end

	return formatted
end


PriceTooltip_GetPrices = function(itemLink)
	local prices =
	{
		vendorPrice = nil,
		profitPrice = nil,
		originalTTCPrice = nil,
		originalTTCPriceIsAvg = false,
		scaledTTCPrice = nil,
		infoTTC1 = nil,
		infoTTC2 = nil,
		infoTTC3 = nil,
		originalMMPrice = nil,
		scaledMMPrice = nil,
		infoMM = nil,
		originalATTPrice = nil,
		scaledATTPrice = nil,
		originalAveragePrice = nil,
		scaledAveragePrice = nil,
		bestPrice = nil,
		bestPriceText = nil
	}

	if not itemLink then return nil end
	
	local icon, meetsUsageRequirement

	icon, prices.vendorPrice, meetsUsageRequirement = GetItemLinkInfo(itemLink)

	if not PriceTooltip_ValidPrice(prices.vendorPrice) then prices.vendorPrice = 0 end
	
	if PriceTooltip.SavedVariables.UseProfitPrice then
		prices.profitPrice = prices.vendorPrice * (1 + PriceTooltip.SavedVariables.ScaleProfitPrice / 100)
		if not PriceTooltip_ValidPrice(prices.profitPrice) then prices.profitPrice = 1 end
	end

	if PriceTooltip.SavedVariables.UseTTCPrice then
		if TamrielTradeCentrePrice then
			local priceInfo = TamrielTradeCentrePrice:GetPriceInfo(itemLink)

			if priceInfo then
				prices.originalTTCPrice = priceInfo.SuggestedPrice

				if priceInfo.SuggestedPrice then
					prices.infoTTC1 = string.format("TTC " .. GetString(TTC_PRICE_SUGGESTEDXTOY), TamrielTradeCentre:FormatNumber(priceInfo.SuggestedPrice, 0), TamrielTradeCentre:FormatNumber(priceInfo.SuggestedPrice * 1.25, 0))
				end

				prices.infoTTC2 = string.format(GetString(TTC_PRICE_AGGREGATEPRICESXYZ), TamrielTradeCentre:FormatNumber(priceInfo.Avg), TamrielTradeCentre:FormatNumber(priceInfo.Min), TamrielTradeCentre:FormatNumber(priceInfo.Max));

				if (PriceTooltip.SavedVariables.IncludeAvgTTCPrice and not PriceTooltip_ValidPrice(prices.originalTTCPrice)) then
					prices.originalTTCPrice = priceInfo.Avg
					prices.originalTTCPriceIsAvg = true
				end

				if (PriceTooltip.SavedVariables.DisplayTTCPriceInfo) then
					if priceInfo.EntryCount ~= priceInfo.AmountCount then
						prices.infoTTC3 = string.format(GetString(TTC_PRICE_XLISTINGSYITEMS), TamrielTradeCentre:FormatNumber(priceInfo.EntryCount), TamrielTradeCentre:FormatNumber(priceInfo.AmountCount))
					else
						prices.infoTTC3 = string.format(GetString(TTC_PRICE_XLISTINGS), TamrielTradeCentre:FormatNumber(priceInfo.EntryCount))
					end
				end
			end
			
			if PriceTooltip_ValidPrice(prices.originalTTCPrice) then
				if (prices.originalTTCPriceIsAvg) then prices.scaledTTCPrice = prices.originalTTCPrice * (1 + PriceTooltip.SavedVariables.ScaleAvgTTCPrice / 100)
				else prices.scaledTTCPrice = prices.originalTTCPrice * (1 + PriceTooltip.SavedVariables.ScaleTTCPrice / 100) end
			end
		end
	end

	if PriceTooltip.SavedVariables.UseMMPrice then
		if MasterMerchant then
			prices.originalMMPrice = MasterMerchant.GetItemLinePrice(itemLink)

			if (PriceTooltip.SavedVariables.DisplayMMPriceInfo) then
				local tipLine, avgPrice, graphInfo = MasterMerchant:itemPriceTip(itemLink, false, clickable)
				if tipLine then prices.infoMM = zo_strformat("<<1>> ", tipLine) end
			end
			
			if PriceTooltip_ValidPrice(prices.originalMMPrice) then
				prices.scaledMMPrice = prices.originalMMPrice * (1 + PriceTooltip.SavedVariables.ScaleMMPrice / 100)
			end
		end
	end

	if PriceTooltip.SavedVariables.UseATTPrice then
		if PriceTooltip_ATT_Sales then
			local fromTimeStamp = GetTimeStamp() - PriceTooltip.SavedVariables.ATTDays * 60 * 60 * 24
			prices.originalATTPrice = PriceTooltip_ATT_Sales:GetAveragePricePerItem(itemLink, fromTimeStamp)
			
			if PriceTooltip_ValidPrice(prices.originalATTPrice) then
				prices.scaledATTPrice = prices.originalATTPrice * (1 + PriceTooltip.SavedVariables.ScaleATTPrice / 100)
			end
		end
	end

	if PriceTooltip.SavedVariables.UseAveragePrice then
		prices.scaledAveragePrice = 0
		prices.originalAveragePrice = 0
		local count = 0

		if PriceTooltip_ValidPrice(prices.scaledTTCPrice) and PriceTooltip.SavedVariables.IncludeTTCInAP then
			if (prices.originalTTCPriceIsAvg) then
				if (PriceTooltip.SavedVariables.IncludeTTCAvgInAP) then
					prices.scaledAveragePrice = prices.scaledAveragePrice + prices.scaledTTCPrice
					prices.originalAveragePrice = prices.originalAveragePrice + prices.originalTTCPrice
					count = count + 1
				end
			else
				prices.scaledAveragePrice = prices.scaledAveragePrice + prices.scaledTTCPrice
				prices.originalAveragePrice = prices.originalAveragePrice + prices.originalTTCPrice
				count = count + 1
			end
		end

		if PriceTooltip.SavedVariables.IncludeMMInAP and PriceTooltip_ValidPrice(prices.scaledMMPrice) then
			prices.scaledAveragePrice = prices.scaledAveragePrice + prices.scaledMMPrice
			prices.originalAveragePrice = prices.originalAveragePrice + prices.originalMMPrice
			count = count + 1
		end
		if PriceTooltip.SavedVariables.IncludeATTInAP and PriceTooltip_ValidPrice(prices.scaledATTPrice) then
			prices.scaledAveragePrice = prices.scaledAveragePrice + prices.scaledATTPrice
			prices.originalAveragePrice = prices.originalAveragePrice + prices.originalATTPrice
			count = count + 1
		end

		if count > 0 then
			prices.originalAveragePrice = prices.originalAveragePrice / count
			prices.scaledAveragePrice = prices.scaledAveragePrice / count
		end
	end
	
	if PriceTooltip.SavedVariables.UseBestPrice then
		prices.bestPrice = 0

		if PriceTooltip.SavedVariables.UseTTCPrice and PriceTooltip_ValidPrice(prices.scaledTTCPrice) and prices.scaledTTCPrice > prices.bestPrice then
			if (PriceTooltip.SavedVariables.IncludeTTCAvgInBP or (not prices.originalTTCPriceIsAvg)) then
				prices.bestPrice = prices.scaledTTCPrice
				prices.bestPriceText = PRICE_TOOLTIP_TTC_PRICE
			end
		end

		if PriceTooltip.SavedVariables.UseMMPrice and PriceTooltip_ValidPrice(prices.scaledMMPrice) and prices.scaledMMPrice > prices.bestPrice then
			prices.bestPrice = prices.scaledMMPrice
			prices.bestPriceText = PRICE_TOOLTIP_MM_PRICE
		end

		if PriceTooltip.SavedVariables.UseATTPrice and PriceTooltip_ValidPrice(prices.scaledATTPrice) and prices.scaledATTPrice > prices.bestPrice then
			prices.bestPrice = prices.scaledATTPrice
			prices.bestPriceText = PRICE_TOOLTIP_ATT_PRICE
		end

		if PriceTooltip.SavedVariables.IncludePPInBP and PriceTooltip.SavedVariables.UseProfitPrice and PriceTooltip_ValidPrice(prices.profitPrice) and prices.profitPrice > prices.bestPrice then
			prices.bestPrice = prices.profitPrice
			prices.bestPriceText = PRICE_TOOLTIP_PROFIT_PRICE
		end

		if not PriceTooltip_ValidPrice(prices.bestPrice) then
			prices.bestPrice = nil
			prices.bestPriceText = nil
		end
	end

	prices.profitPrice = PriceTooltip_Round(prices.profitPrice, 2)
	prices.originalTTCPrice = PriceTooltip_Round(prices.originalTTCPrice, 2)
	prices.scaledTTCPrice = PriceTooltip_Round(prices.scaledTTCPrice, 2)
	prices.originalMMPrice = PriceTooltip_Round(prices.originalMMPrice, 2)
	prices.scaledMMPrice = PriceTooltip_Round(prices.scaledMMPrice, 2)
	prices.originalATTPrice = PriceTooltip_Round(prices.originalATTPrice, 2)
	prices.scaledATTPrice = PriceTooltip_Round(prices.scaledATTPrice, 2)
	prices.originalAveragePrice = PriceTooltip_Round(prices.originalAveragePrice, 2)
	prices.scaledAveragePrice = PriceTooltip_Round(prices.scaledAveragePrice, 2)
	prices.bestPrice = PriceTooltip_Round(prices.bestPrice, 2)

	return prices
end


PriceTooltip_AddDivider = function(tooltipControl) 
    if not tooltipControl.dividerPool then 
        tooltipControl.dividerPool = ZO_ControlPool:New("ZO_BaseTooltipDivider", tooltipControl, "Divider")
		PriceTooltip_LastDividerPool = tooltipControl.dividerPool
    end
	
	return tooltipControl.dividerPool:AcquireObject() 
end


--NOTE If original price is valid, scaled price is also valid.
--NOTE ProfitPrice is scaled price of VendorPrice
PriceTooltip_NoDisplayPrices = function(prices)
	return prices == nil or (not (PriceTooltip_ValidPrice(prices.vendorPrice) and PriceTooltip.SavedVariables.DisplayVendorPrice) and
							 not (PriceTooltip_ValidPrice(prices.profitPrice) and PriceTooltip.SavedVariables.DisplayProfitPrice) and
							 not (PriceTooltip_ValidPrice(prices.originalTTCPrice) and PriceTooltip.SavedVariables.DisplayTTCPrice) and
							 not ((prices.infoTTC1 or prices.infoTTC2 or prices.infoTTC3) and PriceTooltip.SavedVariables.DisplayTTCPriceInfo) and
							 not (PriceTooltip_ValidPrice(prices.originalMMPrice) and PriceTooltip.SavedVariables.DisplayMMPrice) and
							 not (prices.infoMM and PriceTooltip.SavedVariables.DisplayMMPriceInfo) and
							 not (PriceTooltip_ValidPrice(prices.originalATTPrice) and PriceTooltip.SavedVariables.DisplayATTPrice) and
							 not (PriceTooltip_ValidPrice(prices.originalAveragePrice) and PriceTooltip.SavedVariables.DisplayAveragePrice) and
							 not (PriceTooltip_ValidPrice(prices.bestPrice) and PriceTooltip.SavedVariables.DisplayBestPrice) and
							 (prices.bestPriceText == nil and not PriceTooltip.SavedVariables.DisplayBestPrice)) --NOTE why did I check this?
end


PriceTooltip_Print = function(prices)
	d("Start print prices:")
	PriceTooltip_PrintPriceInternal("vendorPrice", prices.vendorPrice)
	PriceTooltip_PrintPriceInternal("profitPrice", prices.profitPrice)
	PriceTooltip_PrintPriceInternal("originalTTCPrice", prices.originalTTCPrice)
	PriceTooltip_PrintPriceInternal("scaledTTCPrice", prices.scaledTTCPrice)
	PriceTooltip_PrintPriceInternal("originalMMPrice", prices.originalMMPrice)
	PriceTooltip_PrintPriceInternal("scaledMMPrice", prices.scaledMMPrice)
	PriceTooltip_PrintPriceInternal("originalATTPrice", prices.originalATTPrice)
	PriceTooltip_PrintPriceInternal("scaledATTPrice", prices.scaledATTPrice)
	PriceTooltip_PrintPriceInternal("originalAveragePrice", prices.originalAveragePrice)
	PriceTooltip_PrintPriceInternal("scaledAveragePrice", prices.scaledAveragePrice)
	PriceTooltip_PrintPriceInternal("bestPrice", prices.bestPrice)
	PriceTooltip_PrintPriceInternal("bestPriceText", prices.bestPriceText)
end


PriceTooltip_PrintPriceInternal = function(text, price)
	if text and PriceTooltip_ValidPrice(price) then
		d(priceText .. " -> " .. price)
	end
end


PriceTooltip_PrintTextInternal = function(text1, text2)
	if text1 and text2 then
		d(text1 .. " -> " .. text2)
	end
end


PriceTooltip_AddTooltip = function(control, itemLink, gamepad)
	if (not control) then return end
	
	local addedLine = 0

	local prices = PriceTooltip_GetPrices(itemLink)
	
	if PriceTooltip_NoDisplayPrices(prices) then return end

	local stringPTIColor = PriceTooltip_GetStringColorFromColor(PriceTooltip.SavedVariables.TooltipPriceInfoColor)
	local stringErrorColor = PriceTooltip_GetStringColor(1, 0, 0)
	
	if PriceTooltip.SavedVariables.DisplayVendorPrice and PriceTooltip_ValidPrice(prices.vendorPrice) then
		if gamepad then
			control:AddLine(PriceTooltip_GetStringColorFromColor(PriceTooltip.SavedVariables.TooltipColor) .. "Vendor price " .. PriceTooltip_NumberFormat(prices.vendorPrice) .. PRICE_TOOLTIP_GOLD_TEXT_ICON)
		else
		    local itemType = GetItemLinkItemType(itemLink)
		
			if (PriceTooltip_ItemTypes[itemType]) then
				-- Add spacing to match original spacing
				if (not (itemType == ITEMTYPE_ENCHANTING_RUNE_ESSENCE )) then control:AddLine() end
				
				control:AddLine()

				control:AddLine(PriceTooltip_NumberFormat(prices.vendorPrice) .. PRICE_TOOLTIP_GOLD_TEXT_ICON, "ZoFontWinH4")
			end
		end
	end

	local divider = nil

	if not gamepad then
		divider = PriceTooltip_AddDivider(control)

		if (divider) then
			if (PriceTooltip.SavedVariables.FixDoubleTooltip) then
				if (PriceTooltip_LastDivider and PriceTooltip_LastDivider.PriceTooltipLink == itemLink and PriceTooltip_LastDivider:GetName() ~= divider:GetName()) then
					divider:SetHidden(true)
					return
				else
					if (PriceTooltip_LastDivider) then PriceTooltip_LastDivider.PriceTooltipLink = nil end

					divider.PriceTooltipLink = itemLink
					PriceTooltip_LastDivider = divider
				end
			else
				if (PriceTooltip_LastDivider) then PriceTooltip_LastDivider.PriceTooltipLink = nil end

				divider.PriceTooltipLink = nil
				PriceTooltip_LastDivider = nil
			end

			control:AddControl(divider)
			divider:SetAnchor(CENTER)
			divider:SetHidden(false)
		end
	end

	if PriceTooltip.SavedVariables.DisplayProfitPrice then addedLine = addedLine + PriceTooltip_AddPTLine(control, PRICE_TOOLTIP_PROFIT_PRICE, prices.profitPrice, prices.vendorPrice, prices.profitPrice, nil, gamepad) end

	--TTC
	if PriceTooltip.SavedVariables.DisplayTTCPrice then
		if (prices.originalTTCPriceIsAvg) then addedLine = addedLine + PriceTooltip_AddPTLine(control, PRICE_TOOLTIP_TTC_PRICE, prices.scaledTTCPrice, prices.vendorPrice, prices.profitPrice, nil, gamepad, PriceTooltip.SavedVariables.AvgTTCPriceColor)
		else addedLine = addedLine + PriceTooltip_AddPTLine(control, PRICE_TOOLTIP_TTC_PRICE, prices.scaledTTCPrice, prices.vendorPrice, prices.profitPrice, nil, gamepad) end
	end
	
	if PriceTooltip.SavedVariables.DisplayTTCPriceInfo then
		if prices.infoTTC1 then addedLine = addedLine + PriceTooltip_AddTooltipLine(control, stringPTIColor .. prices.infoTTC1, gamepad, true) end
		if prices.infoTTC2 then addedLine = addedLine + PriceTooltip_AddTooltipLine(control, stringPTIColor .. prices.infoTTC2, gamepad, true) end
		if (prices.infoTTC2 and prices.infoTTC3 ~= prices.infoTTC2) or prices.infoTTC3 then addedLine = addedLine + PriceTooltip_AddTooltipLine(control, stringPTIColor .. prices.infoTTC3, gamepad, true) end
	end

	--MM
	if PriceTooltip.SavedVariables.DisplayMMPrice then addedLine = addedLine + PriceTooltip_AddPTLine(control, PRICE_TOOLTIP_MM_PRICE, prices.scaledMMPrice, prices.vendorPrice, prices.profitPrice, nil, gamepad) end
	if PriceTooltip.SavedVariables.DisplayMMPriceInfo and prices.infoMM then addedLine = addedLine + PriceTooltip_AddTooltipLine(control, stringPTIColor .. prices.infoMM, gamepad, true) end

	if PriceTooltip.SavedVariables.DisplayATTPrice then addedLine = addedLine + PriceTooltip_AddPTLine(control, PRICE_TOOLTIP_ATT_PRICE, prices.scaledATTPrice, prices.vendorPrice, prices.profitPrice, nil, gamepad) end

	if PriceTooltip.SavedVariables.DisplayAveragePrice then
		if (prices.originalTTCPriceIsAvg) then addedLine = addedLine + PriceTooltip_AddPTLine(control, PRICE_TOOLTIP_TRADE_PRICE, prices.scaledAveragePrice, prices.vendorPrice, prices.profitPrice, nil, gamepad, PriceTooltip.SavedVariables.AvgTTCPriceColor)
		else addedLine = addedLine + PriceTooltip_AddPTLine(control, PRICE_TOOLTIP_TRADE_PRICE, prices.scaledAveragePrice, prices.vendorPrice, prices.profitPrice, nil, gamepad) end
	end

	if PriceTooltip.SavedVariables.DisplayBestPrice then
		if (prices.originalTTCPriceIsAvg) then addedLine = addedLine + PriceTooltip_AddPTLine(control, PRICE_TOOLTIP_BEST_PRICE, prices.bestPrice, prices.vendorPrice, prices.profitPrice, prices.bestPriceText, gamepad, PriceTooltip.SavedVariables.AvgTTCPriceColor)
		else addedLine = addedLine + PriceTooltip_AddPTLine(control, PRICE_TOOLTIP_BEST_PRICE, prices.bestPrice, prices.vendorPrice, prices.profitPrice, prices.bestPriceText, gamepad) end
	end
	
	local note = PriceTooltipNote_GetData(itemLink)
	
	if note then
		local noteColorText = PriceTooltip_GetStringColorFromColor(PriceTooltip.SavedVariables.TooltipColor)
		addedLine = addedLine + PriceTooltip_AddTooltipLine(control, noteColorText .. "NOTE: " .. note, gamepad)
	end
	
	--ERROR
	if PriceTooltip.SavedVariables.UseTTCPrice and not TamrielTradeCentrePrice then addedLine = addedLine + PriceTooltip_AddTooltipLine(control, stringErrorColor .. "TTC not available!", gamepad) end
	if PriceTooltip.SavedVariables.UseMMPrice and not MasterMerchant then addedLine = addedLine + PriceTooltip_AddTooltipLine(control, stringErrorColor .. "MM not available!", gamepad) end
	if PriceTooltip.SavedVariables.UseATTPrice and not PriceTooltip_ATT_Sales then addedLine = addedLine + PriceTooltip_AddTooltipLine(control, stringErrorColor .. "ATT not available!", gamepad) end

	if divider then divider:SetHidden(addedLine < 1) end

	--Empty line instead of divider for gamepad
	if gamepad then control:AddLine(" ") end
end


PriceTooltip_GetLowPriceIndicator = function(price, vendorPrice, profitPrice)
	local lowPriceIndikator = ""

	if PriceTooltip_ValidPrice(price) then
		if price <= vendorPrice then lowPriceIndikator = PriceTooltip_GetStringColorFromColor(PriceTooltip.SavedVariables.VendorPriceLowPriceIndicatorColor) .. "*"
		elseif PriceTooltip.SavedVariables.UseProfitPrice and price < profitPrice then lowPriceIndikator = PriceTooltip_GetStringColorFromColor(PriceTooltip.SavedVariables.ProfitPriceLowPriceIndicatorColor) .. "*" end
	end

	return lowPriceIndikator
end


PriceTooltip_AddPTLine = function(control, text, price, vendorPrice, profitPrice, info, gamepad, priceColor)
	if PriceTooltip_ValidPrice(price) then
		if info then info = " (" .. info .. ")" end

		local lowPriceIndicator = ""
		if PriceTooltip.SavedVariables.LowPriceIndicatorTooltip then lowPriceIndicator = PriceTooltip_GetLowPriceIndicator(price, vendorPrice, profitPrice) end

		local stringColorText = PriceTooltip_GetStringColorFromColor(PriceTooltip.SavedVariables.TooltipColor)
		local stringColorPrice = stringColorText

		if priceColor then stringColorPrice = PriceTooltip_GetStringColorFromColor(priceColor) end
		
		PriceTooltip_AddTooltipLine(control, stringColorText .. text .. " " .. lowPriceIndicator .. stringColorPrice .. PriceTooltip_NumberFormat(price) .. PRICE_TOOLTIP_GOLD_TEXT_ICON .. stringColorText .. (info or ""), gamepad)

		return 1
	end

	return 0
end


PriceTooltip_AddTooltipLine = function(control, text, gamepad, isPTI)
	if gamepad then control:AddLine(text)
	else
		control:AddVerticalPadding(PriceTooltip.SavedVariables.TooltipLineSpacing)

		if isPTI then
			control:AddLine(text, PriceTooltip.SavedVariables.PriceInfoFont, 1, 1, 1, CENTER, MODIFY_TEXT_TYPE_UPPERCASE, LEFT, false)
		else
			control:AddLine(text, PriceTooltip.SavedVariables.Font, 1, 1, 1, CENTER, MODIFY_TEXT_TYPE_UPPERCASE, LEFT, false)
		end
	end

	return 1
end


PriceTooltip_GamePadToolTipExtension = function(toolTipControl, functionName)
  local base = toolTipControl[functionName]
  toolTipControl[functionName] = function(control, bagId, slotIndex, ...) 
	local itemLink = GetItemLink(bagId, slotIndex)

	if itemLink and control then
		PriceTooltip_AddTooltip(control, itemLink, true)
	end

    base(control, bagId, slotIndex, ...)
  end
end


PriceTooltip_GamePadToolTipExtension2 = function(toolTipControl, functionName) 
  local base = toolTipControl[functionName]
  toolTipControl[functionName] = function(selectedData, ...) 
    base(selectedData, ...)  
	if toolTipControl.selectedEquipSlot then
		GAMEPAD_TOOLTIPS:LayoutBagItem(GAMEPAD_LEFT_TOOLTIP, BAG_WORN, toolTipControl.selectedEquipSlot)
	end
  end
end


PriceTooltip_ToolTipExtension = function(toolTipControl, functionName, getItemLinkFunction)
	local base = toolTipControl[functionName]
	
	toolTipControl[functionName] = function(control, ...)
		base(control, ...)
		
		if not getItemLinkFunction then return end
		
		local itemLink = getItemLinkFunction(...)
		
		if itemLink and control then
			PriceTooltip_AddTooltip(control, itemLink, false)
		end
	end
end


PriceTooltip_GetWornItemLink = function(equipSlot) return GetItemLink(BAG_WORN, equipSlot) end
PriceTooltip_GetItemLinkFirstParam = function(itemLink) return itemLink end


PriceTooltip_GetStringColor = function(red, green, blue)
	local color = ZO_ColorDef:New(red, green, blue, 1)
	return "|c" .. color:ToHex()
end


PriceTooltip_GetStringColorFromColor = function(color)
	return PriceTooltip_GetStringColor(color.Red, color.Green, color.Blue)
end


PriceTooltip_ChangeGridPrice = function(control, slot)
	if not PriceTooltip.SavedVariables.UseGridItemPriceOverride then return end

	local data = nil
	
	if control and control.dataEntry and control.dataEntry.data and control.dataEntry.data.bagId and control.dataEntry.data.slotIndex and control.dataEntry.data.stackCount then
		mainControl = control
	elseif slot and slot.dataEntry and slot.dataEntry.data and slot.dataEntry.data.bagId and slot.dataEntry.data.slotIndex and slot.dataEntry.data.stackCount then
		mainControl = slot
	end
	
	if mainControl then
		local bagId = mainControl.dataEntry.data.bagId
		local slotIndex = mainControl.dataEntry.data.slotIndex
		local stackCount = mainControl.dataEntry.data.stackCount
		local itemLink = bagId and GetItemLink(bagId, slotIndex) or GetItemLink(slotIndex)

		if not itemLink then return end
		
		local prices = PriceTooltip_GetPrices(itemLink)

		if not prices then return end
				
		local sellPriceControl = mainControl:GetNamedChild("SellPrice")

		if not sellPriceControl then return end

		local ptControl = sellPriceControl.PTControl

		if (not ptControl) then
			ptControl = WINDOW_MANAGER:CreateControl(nil, sellPriceControl, CT_LABEL)
			ptControl:SetColor(1, 1, 1)
			ptControl:SetFont("ZoFontGameShadow")
			ptControl:SetDrawLayer(0)
			-- ptControl:SetAnchor(TOPRIGHT, nil, BOTTOMRIGHT, 0, 0)
			ptControl:SetAnchor(RIGHT, nil, LEFT, 15, 0)
			ptControl:SetAlpha(0)
			ptControl:SetScale(0.7)
			sellPriceControl.PTControl = ptControl
		end

		local priceType = PriceTooltip.SavedVariables.GridItemPriceOverrideBehaviour
		local price = PriceTooltip_GetPriceByType(prices, priceType)
		local gridPriceColor = PriceTooltip.SavedVariables.GridPriceColor

		if (prices.originalTTCPriceIsAvg) then
			if (priceType == PRICE_TOOLTIP_TTC_PRICE and PriceTooltip.SavedVariables.IncludeAvgTTCPrice) then
				gridPriceColor = PriceTooltip.SavedVariables.AvgTTCPriceColor
			elseif (priceType == PRICE_TOOLTIP_AVERAGE_PRICE and PriceTooltip.SavedVariables.IncludeTTCAvgInAP) then
				gridPriceColor = PriceTooltip.SavedVariables.AvgTTCPriceColor
			elseif (priceType == PRICE_TOOLTIP_BEST_PRICE) then
				gridPriceColor = PriceTooltip.SavedVariables.AvgTTCPriceColor
			end
		end

		local lowPriceIndikator = ""

		if priceType ~= PRICE_TOOLTIP_DEFAULT_PRICE and
		   priceType ~= PRICE_TOOLTIP_PROFIT_PRICE and
		   PriceTooltip.SavedVariables.LowPriceIndicatorGrid then
			lowPriceIndikator = PriceTooltip_GetLowPriceIndicator(price, prices.vendorPrice, prices.profitPrice)
		end

		--TODO check why it is set here and not earlier
		if not PriceTooltip_ValidPrice(price) then price = prices.vendorPrice end

		local displayPrice = PriceTooltip_Round(price)
		local otherPrice = PriceTooltip_Round(price)

		if PriceTooltip.SavedVariables.ShowSingleItemPriceInGrid then otherPrice = PriceTooltip_Round(price * stackCount)
		else displayPrice = PriceTooltip_Round(price * stackCount) end

		if PriceTooltip.SavedVariables.UseMinItemGridPrice then
			if price < PriceTooltip.SavedVariables.MinItemGridPrice then PriceTooltip_SetGridPrice(sellPriceControl, lowPriceIndikator, 1, 1, 1, displayPrice, otherPrice)
			else PriceTooltip_SetGridPrice(sellPriceControl, lowPriceIndikator, gridPriceColor.Red, gridPriceColor.Green, gridPriceColor.Blue, displayPrice, otherPrice) end
		else
			if price == prices.vendorPrice then PriceTooltip_SetGridPrice(sellPriceControl, lowPriceIndikator, 1, 1, 1, displayPrice, otherPrice)
			else PriceTooltip_SetGridPrice(sellPriceControl, lowPriceIndikator, gridPriceColor.Red, gridPriceColor.Green, gridPriceColor.Blue, displayPrice, otherPrice) end
		end
	end
end


PriceTooltip_GetPriceByType = function(prices, priceType)
	local price = nil

	if prices then
		if priceType == PRICE_TOOLTIP_DEFAULT_PRICE then price = prices.vendorPrice
		elseif priceType == PRICE_TOOLTIP_AVERAGE_PRICE then price = prices.scaledAveragePrice
		elseif priceType == PRICE_TOOLTIP_MM_PRICE then price = prices.scaledMMPrice
		elseif priceType == PRICE_TOOLTIP_TTC_PRICE then price = prices.scaledTTCPrice
		elseif priceType == PRICE_TOOLTIP_ATT_PRICE then price = prices.scaledATTPrice
		elseif priceType == PRICE_TOOLTIP_BEST_PRICE then price = prices.bestPrice
		elseif priceType == PRICE_TOOLTIP_PROFIT_PRICE then price = prices.profitPrice
		end
	end

	return price
end


PriceTooltip_SetGridPrice = function(sellPriceControl, lowPriceIndikator, r, g, b, displayPrice, otherPrice)
	local stringColor = PriceTooltip_GetStringColor(r, g, b)
	sellPriceControl:SetText(lowPriceIndikator .. stringColor .. PriceTooltip_NumberFormat(displayPrice) .. PRICE_TOOLTIP_GOLD_TEXT_ICON)

	if (otherPrice <= displayPrice) then sellPriceControl.PTControl:SetText(stringColor .. "" .. PriceTooltip_NumberFormat(otherPrice) .. PRICE_TOOLTIP_GOLD_TEXT_ICON)
	else sellPriceControl.PTControl:SetText(stringColor .. "=" .. PriceTooltip_NumberFormat(otherPrice) .. PRICE_TOOLTIP_GOLD_TEXT_ICON) end
end


PriceTooltip_GridPriceExtension = function()
	if MasterMerchant then
		local base = MasterMerchant["SwitchPrice"]
		
		MasterMerchant["SwitchPrice"] = function(control, slot)
			base(control, slot)
			PriceTooltip_ChangeGridPrice(control, slot)
		end
	else
		for _,i in pairs(PLAYER_INVENTORY.inventories) do
			local listView = i.listView
			if listView and listView.dataTypes and listView.dataTypes[1] then
				local originalCall = listView.dataTypes[1].setupCallback				
				listView.dataTypes[1].setupCallback = function(control, slot)						
					originalCall(control, slot)
					PriceTooltip_ChangeGridPrice(control, slot)
				end
			end
		end

		local originalCall = ZO_SmithingTopLevelDeconstructionPanelInventoryBackpack.dataTypes[1].setupCallback
		ZO_SmithingTopLevelDeconstructionPanelInventoryBackpack.dataTypes[1].setupCallback = function(control, slot)
			originalCall(control, slot)
			PriceTooltip_ChangeGridPrice(control, slot)
		end
	end
end


PriceTooltip_PriceToChat = function(link, priceText, price)
	if CHAT_SYSTEM and CHAT_SYSTEM.textEntry and CHAT_SYSTEM.textEntry.editControl then
		local chat = CHAT_SYSTEM.textEntry.editControl
		if not chat:HasFocus() then StartChatInput() end

		if (priceText and price) then
			chat:InsertText("PT: " .. priceText .. " -> ".. PriceTooltip_NumberFormat(price)  .. " gold for " .. string.gsub(link, '|H0', '|H1'))
		else
			chat:InsertText("PT: No data for " .. string.gsub(link, '|H0', '|H1'))
		end
	end
end


PriceTooltip_AddCustomMenuItems = function(link, button)
	if not (PriceTooltip.SavedVariables.UsePriceToChat and link and button == MOUSE_BUTTON_INDEX_RIGHT) then return end

	local linkType = GetLinkType(link)

	if linkType == LINK_TYPE_ACHIEVEMENT then return end

	local stringColor = PriceTooltip_GetStringColorFromColor(PriceTooltip.SavedVariables.PriceToChatColor)

	local count = 1
	local entries = {}

	if PriceTooltip.SavedVariables.UsePriceToChat then
		local prices = PriceTooltip_GetPrices(link)

		if PriceTooltip_ValidPrice(prices.originalTTCPrice) then
			entries[count] = 
			{
				label = PRICE_TOOLTIP_TTC_PRICE .. " to chat -> " .. PriceTooltip_NumberFormat(prices.originalTTCPrice) .. PRICE_TOOLTIP_GOLD_TEXT_ICON,
				callback = function(...) PriceTooltip_PriceToChat(link, PRICE_TOOLTIP_TTC_PRICE, prices.originalTTCPrice) end,
				itemType = MENU_ADD_OPTION_LABEL,
			}
			count = count + 1
		end
		if PriceTooltip_ValidPrice(prices.originalMMPrice) then
			entries[count] = 
			{
				label = PRICE_TOOLTIP_MM_PRICE .. " to chat -> " .. PriceTooltip_NumberFormat(prices.originalMMPrice) .. PRICE_TOOLTIP_GOLD_TEXT_ICON,
				callback = function(...) PriceTooltip_PriceToChat(link, PRICE_TOOLTIP_MM_PRICE, prices.originalMMPrice) end,
				itemType = MENU_ADD_OPTION_LABEL,
			}
			count = count + 1
		end
		if PriceTooltip_ValidPrice(prices.originalATTPrice) then
			entries[count] = 
			{
				label = PRICE_TOOLTIP_ATT_PRICE .. " to chat -> " .. PriceTooltip_NumberFormat(prices.originalATTPrice) .. PRICE_TOOLTIP_GOLD_TEXT_ICON,
				callback = function(...) PriceTooltip_PriceToChat(link, PRICE_TOOLTIP_ATT_PRICE, prices.originalATTPrice) end,
				itemType = MENU_ADD_OPTION_LABEL,
			}
			count = count + 1
		end
		if PriceTooltip_ValidPrice(prices.originalAveragePrice) then
			entries[count] = 
			{
				label = "AVG price to chat -> " .. PriceTooltip_NumberFormat(prices.originalAveragePrice) .. PRICE_TOOLTIP_GOLD_TEXT_ICON,
				callback = function(...) PriceTooltip_PriceToChat(link, "AVG price", prices.originalAveragePrice) end,
				itemType = MENU_ADD_OPTION_LABEL,
			}
			count = count + 1
		end

		if (count == 1) then
			entries[count] = 
			{
				label = "Price to chat -> No data",
				callback = function(...) PriceTooltip_PriceToChat(link, nil, nil) end,
				itemType = MENU_ADD_OPTION_LABEL,
			}
			count = count + 1
		end

		if count > 1 then
			AddCustomSubMenuItem(stringColor .. "PT MENU", entries)
		end
	end

	--PriceTooltipNote

	count = 1
	entries = {}

	entries[count] = 
	{
		label = "Edit NOTE",
		callback = function(...) PriceTooltipNote_NoteToChat_Edit(link) end,
		itemType = MENU_ADD_OPTION_LABEL,
	}
	count = count + 1

	entries[count] = 
	{
		label = "Delete NOTE",
		callback = function(...) PriceTooltipNote_NoteToChat_Delete(link) end,
		itemType = MENU_ADD_OPTION_LABEL,
	}
	count = count + 1

	AddCustomSubMenuItem(stringColor .. "PTN MENU", entries)

	ShowMenu()
end


PriceTooltip_LinkHandlerExtension = function()
	local base = ZO_LinkHandler_OnLinkMouseUp
	ZO_LinkHandler_OnLinkMouseUp = function(link, button, control)
		base(link, button, control)
		PriceTooltip_AddCustomMenuItems(link, button)
	end
end


PriceTooltip_ShowContextMenuExtension = function(inventorySlot)
	local bagId, slotIndex = ZO_Inventory_GetBagAndIndex(inventorySlot)
	if not (bagId and slotIndex) then return end
	local itemLink = GetItemLink(bagId, slotIndex)
	if not itemLink then return end
	PriceTooltip_AddCustomMenuItems(itemLink, MOUSE_BUTTON_INDEX_RIGHT)
end


PriceTooltip_Load = function(eventCode, addonName)
    if addonName ~= PriceTooltip.AddOnName then return end

    EVENT_MANAGER:UnregisterForEvent(addonName, eventCode)
	
	PriceTooltip.SavedVariables = ZO_SavedVars:NewAccountWide(PriceTooltip.SavedVariablesFileName, PriceTooltip.Version, nil, PriceTooltip.Default)

	if ArkadiusTradeTools and ArkadiusTradeTools.Modules and ArkadiusTradeTools.Modules.Sales then
		PriceTooltip_ATT_Sales = ArkadiusTradeTools.Modules.Sales
	end

	if PriceTooltip.SavedVariables.FirstTime == false then
		PriceTooltip.SavedVariables.Init.FirstTime_1 = false
	end

	if PriceTooltip.SavedVariables.Init.FirstTime_1 then
		if TamrielTradeCentrePrice then PriceTooltip.SavedVariables.UseTTCPrice = true end
		if MasterMerchant then PriceTooltip.SavedVariables.UseMMPrice = true end
		if PriceTooltip_ATT_Sales then PriceTooltip.SavedVariables.UseATTPrice = true end
		PriceTooltip.SavedVariables.Init.FirstTime_1 = false
	end

	if PriceTooltip.SavedVariables.Init.FirstTime_2 then
		if PriceTooltip.SavedVariables.Color then
			PriceTooltip.SavedVariables.TooltipColor.Red = PriceTooltip.SavedVariables.Color.Red
			PriceTooltip.SavedVariables.TooltipColor.Green = PriceTooltip.SavedVariables.Color.Green
			PriceTooltip.SavedVariables.TooltipColor.Blue = PriceTooltip.SavedVariables.Color.Blue
			PriceTooltip.SavedVariables.GridPriceColor.Red = PriceTooltip.SavedVariables.Color.Red
			PriceTooltip.SavedVariables.GridPriceColor.Green = PriceTooltip.SavedVariables.Color.Green
			PriceTooltip.SavedVariables.GridPriceColor.Blue = PriceTooltip.SavedVariables.Color.Blue
		end

		if PriceTooltip.SavedVariables.UseVendorPrice ~= nil then PriceTooltip.SavedVariables.DisplayVendorPrice = PriceTooltip.SavedVariables.UseVendorPrice end
		if PriceTooltip.SavedVariables.ShowBestPriceOnly ~= nil then PriceTooltip.SavedVariables.DisplayBestPrice = PriceTooltip.SavedVariables.ShowBestPriceOnly end

		PriceTooltip.SavedVariables.DisplayProfitPrice = PriceTooltip.SavedVariables.UseProfitPrice
		PriceTooltip.SavedVariables.DisplayTTCPrice = PriceTooltip.SavedVariables.UseTTCPrice
		PriceTooltip.SavedVariables.DisplayMMPrice = PriceTooltip.SavedVariables.UseMMPrice
		PriceTooltip.SavedVariables.DisplayATTPrice = PriceTooltip.SavedVariables.UseATTPrice
		PriceTooltip.SavedVariables.DisplayAveragePrice = PriceTooltip.SavedVariables.UseAveragePrice

		PriceTooltip.SavedVariables.Init.FirstTime_2 = false
	end
	
	if PriceTooltip.SavedVariables.Init.FirstTime_3 then
		PriceTooltip.SavedVariables.PriceToChatColor.Red = PriceTooltip.SavedVariables.TooltipColor.Red
		PriceTooltip.SavedVariables.PriceToChatColor.Green = PriceTooltip.SavedVariables.TooltipColor.Green
		PriceTooltip.SavedVariables.PriceToChatColor.Blue = PriceTooltip.SavedVariables.TooltipColor.Blue
		PriceTooltip.SavedVariables.Init.FirstTime_3 = false
	end
	
	if PriceTooltip.SavedVariables.Init.FirstTime_4 then
		PriceTooltip.SavedVariables.OverrideBehaviour = PriceTooltip.SavedVariables.OverrideBehaviour or PRICE_TOOLTIP_AVERAGE_PRICE
		PriceTooltip.SavedVariables.UseProfitPrice = true
		PriceTooltip.SavedVariables.Init.FirstTime_4 = false
	end

	if PriceTooltip.SavedVariables.Init.FirstTime_5 then
		if PriceTooltip.SavedVariables.Init.OverrideItemPrice ~= nil then PriceTooltip.SavedVariables.Init.UseGridItemPriceOverride = PriceTooltip.SavedVariables.Init.OverrideItemPrice end
		if PriceTooltip.SavedVariables.Init.OverrideBehaviour ~= nil then PriceTooltip.SavedVariables.Init.GridItemPriceOverrideBehaviour = PriceTooltip.SavedVariables.Init.OverrideBehaviour end
		PriceTooltip.SavedVariables.Init.FirstTime_5 = false
	end

	if PriceTooltip.SavedVariables.Init.FirstTime_6 then
		PriceTooltip.SavedVariables.IncludePPInBP = PriceTooltip.SavedVariables.IncludeProfitPriceToBestPrice
		PriceTooltip.SavedVariables.Init.FirstTime_6 = false
	end
	
	PriceTooltip_MENU.Init()
	PriceTooltip_Extensions()

	if PriceTooltip.SavedVariables.UseGridSort then
		local sortKeys = ZO_Inventory_GetDefaultHeaderSortKeys()
		sortKeys["ptValue"] = { isNumeric = true, tiebreaker = "name" }

		PriceTooltip_SortByValueHeader(INVENTORY_BACKPACK, ZO_PlayerInventorySortBy, ZO_PlayerInventorySortByPriceName)
		PriceTooltip_SortByValueHeader(INVENTORY_CRAFT_BAG, ZO_CraftBagSortBy, ZO_CraftBagSortByPriceName)
		PriceTooltip_SortByValueHeader(INVENTORY_BANK, ZO_PlayerBankSortBy, ZO_PlayerBankSortByPriceName)
		PriceTooltip_SortByValueHeader(INVENTORY_GUILD_BANK, ZO_GuildBankSortBy, ZO_GuildBankSortByPriceName)
		PriceTooltip_SortByValueHeader(INVENTORY_HOUSE_BANK, ZO_HouseBankSortBy, ZO_HouseBankSortByPriceName)

		ZO_PreHook(PLAYER_INVENTORY, "ApplySort", PriceTooltip_LoadSortData)
	end
end


PriceTooltip_LoadSortData = function(inventoryManager, inventoryType)
	if
	(
		inventoryType and
		inventoryManager and
		inventoryManager.inventories and
		inventoryManager.inventories[inventoryType] and
		inventoryManager.inventories[inventoryType].slots
	) then
		local priceType = PriceTooltip.SavedVariables.GridSortBehaviour

		for slotsId, slots in pairs(inventoryManager.inventories[inventoryType].slots) do
			for slotId, slot in pairs(slots) do
				if slot.lnk then
					if (not PriceTooltip.SavedVariables.UseGridCacheModus) or slot.ptType ~= priceType or slot.ptLink ~= slot.lnk then
						local price = 0
						
						local prices = PriceTooltip_GetPrices(slot.lnk)

						if prices then
							price = PriceTooltip_GetPriceByType(prices, priceType)
							price = PriceTooltip_Round(price)

							if not PriceTooltip_ValidPrice(price) then price = prices.vendorPrice end
						end
						
						slot.ptItemValue = price
						slot.ptType = priceType
						slot.ptLink = slot.lnk
					end

					if PriceTooltip.SavedVariables.SortGridByStackValue then slot.ptValue = slot.ptItemValue * slot.stackCount
					else slot.ptValue = slot.ptItemValue end
				end
			end
		end
	end
end


PriceTooltip_SortByValueHeader = function(inventoryType, sortControl, priceNameControl)
	-- Moving Original Price sort to left for more space
	local parent = priceNameControl:GetParent()
	priceNameControl:ClearAnchors();
	priceNameControl:SetAnchor(LEFT, parent, LEFT, 0, 0)

	local sortHeader = CreateControlFromVirtual("$(parent)PTV", sortControl, "ZO_SortHeaderIcon")
	sortHeader:SetAnchor(LEFT, priceNameControl, RIGHT, 20, 0)
	sortHeader:SetDimensions(15, 30)

    ZO_SortHeader_InitializeArrowHeader(sortHeader, "ptValue", ZO_SORT_ORDER_DOWN)
    ZO_SortHeader_SetTooltip(sortHeader, "PT Value", BOTTOMLEFT, 0, 00)

    local inventory = PLAYER_INVENTORY.inventories[inventoryType]
	inventory.sortHeaders:AddHeader(sortHeader)
end


PriceTooltip_Extensions = function()
	PriceTooltip_InitTooltips()
	PriceTooltip_GridPriceExtension()
	PriceTooltip_LinkHandlerExtension()
	ZO_PreHook("ZO_InventorySlot_ShowContextMenu", function(inventorySlot) zo_callLater(function() PriceTooltip_ShowContextMenuExtension(inventorySlot) end, 50) end)
end


PriceTooltip_InitTooltips = function ()
	PriceTooltip_InitGamepadTooltips()

	PriceTooltip_ToolTipExtension(ItemTooltip, "SetAttachedMailItem", GetAttachedItemLink)
	PriceTooltip_ToolTipExtension(ItemTooltip, "SetBagItem", GetItemLink)
	PriceTooltip_ToolTipExtension(ItemTooltip, "SetBuybackItem", GetBuybackItemLink)
	PriceTooltip_ToolTipExtension(ItemTooltip, "SetLootItem", GetLootItemLink)
	PriceTooltip_ToolTipExtension(ItemTooltip, "SetTradeItem", GetTradeItemLink)
	PriceTooltip_ToolTipExtension(ItemTooltip, "SetStoreItem", GetStoreItemLink)
	PriceTooltip_ToolTipExtension(ItemTooltip, "SetTradingHouseItem", GetTradingHouseSearchResultItemLink)
	PriceTooltip_ToolTipExtension(ItemTooltip, "SetTradingHouseListing", GetTradingHouseListingItemLink)
	PriceTooltip_ToolTipExtension(ItemTooltip, "SetWornItem", PriceTooltip_GetWornItemLink)
	PriceTooltip_ToolTipExtension(ItemTooltip, "SetQuestReward", GetQuestRewardItemLink)
	PriceTooltip_ToolTipExtension(ItemTooltip, "SetLink", PriceTooltip_GetItemLinkFirstParam)
	PriceTooltip_ToolTipExtension(PopupTooltip, "SetLink", PriceTooltip_GetItemLinkFirstParam)
end


PriceTooltip_InitGamepadTooltips = function()
	PriceTooltip_GamePadToolTipExtension(GAMEPAD_TOOLTIPS:GetTooltip(GAMEPAD_LEFT_TOOLTIP), "LayoutBagItem")
	PriceTooltip_GamePadToolTipExtension2(GAMEPAD_INVENTORY, "UpdateCategoryLeftTooltip")
    PriceTooltip_GamePadToolTipExtension(GAMEPAD_TOOLTIPS:GetTooltip(GAMEPAD_RIGHT_TOOLTIP), "LayoutBagItem")
    PriceTooltip_GamePadToolTipExtension(GAMEPAD_TOOLTIPS:GetTooltip(GAMEPAD_MOVABLE_TOOLTIP), "LayoutBagItem")
	
	PriceTooltip_PostHook(ZO_MailInbox_Gamepad, 'InitializeKeybindDescriptors',
	function(self)
		self.mainKeybindDescriptor[3]["callback"] = function() self:Delete() end
	end)
end


-- From Better UI
PriceTooltip_PostHook = function(control, method, fn)
	if control then
		local originalMethod = control[method]
		control[method] = function(self, ...)
			originalMethod(self, ...)
			fn(self, ...)
		end
	end
end


EVENT_MANAGER:RegisterForEvent("PriceTooltip_Load", EVENT_ADD_ON_LOADED, PriceTooltip_Load)