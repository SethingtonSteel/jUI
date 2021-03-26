PP.helpSceneGroup = function()

--ZO_Help  helpTutorials---------------------------------------------------------------------------
	local helpTutorialsScene = SCENE_MANAGER:GetScene('helpTutorials')
	-- helpTutorialsScene:RemoveFragment(END_IN_WORLD_INTERACTIONS_FRAGMENT)
	helpTutorialsScene:RemoveFragment(FRAME_TARGET_STANDARD_RIGHT_PANEL_FRAGMENT)
	helpTutorialsScene:RemoveFragment(RIGHT_BG_FRAGMENT)
	helpTutorialsScene:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	helpTutorialsScene:RemoveFragment(TITLE_FRAGMENT)
	helpTutorialsScene:RemoveFragment(HELP_TITLE_FRAGMENT)
	helpTutorialsScene:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	helpTutorialsScene:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_Help, 'helpTutorials', -10, -10, 0, 10)

	PP.Anchor(ZO_Help, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 120,	--[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -70)

--ZO_HelpCustomerService_Keyboard  helpCustomerSupport  HELP_CUSTOMER_SUPPORT_SCENE----------------
	HELP_CUSTOMER_SUPPORT_SCENE:RemoveFragment(END_IN_WORLD_INTERACTIONS_FRAGMENT)
	HELP_CUSTOMER_SUPPORT_SCENE:RemoveFragment(FRAME_TARGET_STANDARD_RIGHT_PANEL_FRAGMENT)
	HELP_CUSTOMER_SUPPORT_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	HELP_CUSTOMER_SUPPORT_SCENE:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	HELP_CUSTOMER_SUPPORT_SCENE:RemoveFragment(TITLE_FRAGMENT)
	HELP_CUSTOMER_SUPPORT_SCENE:RemoveFragment(HELP_TITLE_FRAGMENT)
	HELP_CUSTOMER_SUPPORT_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	HELP_CUSTOMER_SUPPORT_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_HelpCustomerService_Keyboard, HELP_CUSTOMER_SUPPORT_SCENE, -10, -10, 0, 10)

	PP.Anchor(ZO_HelpCustomerService_Keyboard, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 120,	--[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -70)

--ZO_PlayerEmote_Keyboard  helpEmotes  HELP_EMOTES_SCENE-------------------------------------------
	HELP_EMOTES_SCENE:RemoveFragment(END_IN_WORLD_INTERACTIONS_FRAGMENT)
	HELP_EMOTES_SCENE:RemoveFragment(FRAME_TARGET_STANDARD_RIGHT_PANEL_FRAGMENT)
	HELP_EMOTES_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	HELP_EMOTES_SCENE:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	HELP_EMOTES_SCENE:RemoveFragment(TITLE_FRAGMENT)
	HELP_EMOTES_SCENE:RemoveFragment(HELP_TITLE_FRAGMENT)
	HELP_EMOTES_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	HELP_EMOTES_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_PlayerEmote_Keyboard, HELP_EMOTES_SCENE, -10, -10, 0, 10)

	PP.Anchor(ZO_PlayerEmote_Keyboard, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 120,	--[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -70)

---------------------------------------------------------------------------------------------------
end

