PP.chatWindow = function()
--ZO_ChatWindow KEYBOARD_CHAT_SYSTEM

	-- ZO_ChatWindowTextEntryEdit:SetPixelRoundingEnabled(false)

	local tlc	= KEYBOARD_CHAT_SYSTEM.control
	local bg	= tlc:GetNamedChild("Bg")

	bg:ClearAnchors()
	bg:SetAnchor(TOPLEFT,		tlc,	TOPLEFT,		0, 0)
	bg:SetAnchor(BOTTOMRIGHT,	tlc,	BOTTOMRIGHT,	0, 0)

	bg:SetDrawLayer(0)
	bg:SetDrawLevel(0)
	bg:SetDrawTier(0)

	bg:SetCenterTexture(PP.SV.skin_backdrop, PP.SV.skin_backdrop_tile_size, PP.SV.skin_backdrop_tile and 1 or 0)
	bg:SetCenterColor(unpack(PP.SV.skin_backdrop_col))
	bg:SetInsets(PP.SV.skin_backdrop_insets, PP.SV.skin_backdrop_insets, -PP.SV.skin_backdrop_insets, -PP.SV.skin_backdrop_insets)
	bg:SetEdgeTexture(PP.SV.skin_edge, PP.SV.skin_edge_file_width, PP.SV.skin_edge_file_height, PP.SV.skin_edge_thickness, 0)
	bg:SetEdgeColor(unpack(PP.SV.skin_edge_col))
	bg:SetIntegralWrapping(PP.SV.skin_edge_integral_wrapping)





	local container	= ZO_ChatWindowWindowContainer --KEYBOARD_CHAT_SYSTEM.containers[1].windowContainer
	local tex = PP.t.w8x8

	local sb	= ZO_ChatWindowScrollbar
	local up	= ZO_ChatWindowScrollbarScrollUp
	local down	= ZO_ChatWindowScrollbarScrollDown
	-- local scrollEnd	= ZO_ChatWindowScrollbarScrollEnd
	local thumb	= sb:GetThumbTextureControl()

	up:SetHidden(true)
	down:SetHidden(true)
	up:ClearAnchors()
	down:ClearAnchors()

	sb:SetBackgroundMiddleTexture(tex)
	sb:SetBackgroundTopTexture(nil)
	sb:SetBackgroundBottomTexture(nil)
	sb:SetColor(50/255, 50/255, 50/255, .6)
	sb:SetHitInsets(-3, 0, 3, 0)
	sb:SetWidth(4)
	sb:SetDrawLayer(0)
	sb.thumb = thumb

	thumb:SetWidth(4)
	thumb:SetTexture(nil)
	thumb:SetColor(120/255, 120/255, 120/255, .6)
	thumb:SetHitInsets(-3, 0, 3, 0)

	sb:ClearAnchors()
	sb:SetAnchor(TOPLEFT,		container, TOPRIGHT,		6, 0)
	sb:SetAnchor(BOTTOMLEFT,	container, BOTTOMRIGHT,		6, 0)

	container:ClearAnchors()
	container:SetAnchor(TOPLEFT, ZO_ChatWindowDivider, BOTTOMLEFT, 0, 3)
	container:SetAnchor(BOTTOMRIGHT, ZO_ChatWindowTextEntry, TOPRIGHT, -10, -3)

	ZO_ChatWindowDivider:SetTexture(tex)
	ZO_ChatWindowDivider:SetHeight(2)
	ZO_ChatWindowDivider:SetColor(50/255, 50/255, 50/255, 1)
	
	
	
	ZO_ChatWindowTextEntry:ClearAnchors()
	ZO_ChatWindowTextEntry:SetAnchor(BOTTOMLEFT,	tlc,	BOTTOMLEFT,		26, 0)
	ZO_ChatWindowTextEntry:SetAnchor(BOTTOMRIGHT,	tlc,	BOTTOMRIGHT,	-10, -10)
end