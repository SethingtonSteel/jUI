PP.dialogsMenu = function()
-- ZO_Dialogs menu
	for _, v in ipairs(PP.DialogsMenu) do
		if not v then return end

		local bg				= v:GetNamedChild("BG")
		local bgMungeOverlay	= v:GetNamedChild("BGMungeOverlay")
		local modalUnderlay		= v:GetNamedChild("ModalUnderlay")
		local button1KeyLabel	= v:GetNamedChild("Button1KeyLabel")	or v:GetNamedChild("ConfirmKeyLabel")	or v:GetNamedChild("AcceptKeyLabel")
		local button1NameLabel	= v:GetNamedChild("Button1NameLabel")	or v:GetNamedChild("ConfirmNameLabel")	or v:GetNamedChild("AcceptNameLabel")
		local button2KeyLabel	= v:GetNamedChild("Button2KeyLabel")	or v:GetNamedChild("CancelKeyLabel")	or v:GetNamedChild("ExitKeyLabel")
		local button2NameLabel	= v:GetNamedChild("Button2NameLabel")	or v:GetNamedChild("CancelNameLabel")	or v:GetNamedChild("ExitNameLabel")
		local list				= v:GetNamedChild("List")
		local pane				= v:GetNamedChild("Pane")
		local listBgLeft		= v:GetNamedChild("ListBgLeft")
		local listBgRight		= v:GetNamedChild("ListBgRight")
		local title				= v:GetNamedChild("Title")

		ZO_PreHookHandler(v, "OnShow", function()
			if v.animation then
				-- v.animation:GetAnimation():SetDuration(1)
				-- v.animation:GetAnimation():SetStartAlpha(1)
				-- v.animation:GetFirstAnimation():SetDuration(1)
				-- v.animation:GetFirstAnimation():SetStartAlpha(1)
				v.animation:GetLastAnimation():SetDuration(1)
				-- v.animation:GetLastAnimation():SetStartScale(1)
			end
			return false
		end)

		if bg:GetType() == CT_BACKDROP then
			bg:SetCenterTexture(PP.t.bg1, 4, 1)
			bg:SetCenterColor(10/255, 10/255, 10/255, .9)
			bg:SetEdgeTexture(nil, 1, 1, 1, 0)
			bg:SetEdgeColor(60/255, 60/255, 60/255, 1)
			bg:SetInsets(-1, -1, 1, 1)
		end
		if bgMungeOverlay then
			bgMungeOverlay:SetHidden(true)
		end
		if modalUnderlay then
			modalUnderlay:SetAlpha(0.4)
			modalUnderlay:SetDrawTier(0)
		end
		if button1KeyLabel then
			button1KeyLabel:SetFont(PP.f.u57 .. "|16")
			button1NameLabel:SetFont(PP.f.u67 .. "|18|outline")
		end
		if button2KeyLabel then
			button2KeyLabel:SetFont(PP.f.u57 .. "|16")
			button2NameLabel:SetFont(PP.f.u67 .. "|18|outline")
		end
		if title then
			PP.Font(title,	--[[Font]] PP.f.u67, 22, "outline", --[[Alpha]] .9, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
		end
		if list then
			-- PP.ListBackdrop(list, -3, -3, -3, 3, --[[tex]] nil, 8, 0, --[[bd]] 5, 5, 5, .6, --[[edge]] 30, 30, 30, .6)
			-- list:GetNamedChild("Backdrop"):SetDrawTier(1)
			list:SetWidth(v:GetWidth() - 30)
			PP.Anchor(list, --[[#1]] nil, nil, nil, 2, nil)
			
			PP.ScrollBar(list, --[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, true)
			-- list:GetNamedChild("ScrollBar_BG"):SetDrawTier(1)

			if listBgLeft and listBgRight then
				listBgLeft:SetHidden(true)
				listBgRight:SetHidden(true)
			end
		end
		if pane then
			pane:SetWidth(v:GetWidth() - 30)
			PP.Anchor(pane, --[[#1]] nil, nil, nil, 2, nil)
			PP.ScrollBar(pane, --[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, true)
			-- pane:GetNamedChild("ScrollBar_BG"):SetDrawTier(1)
		end
	end
end