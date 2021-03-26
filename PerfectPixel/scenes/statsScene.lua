PP.statsScene = function()

	-- local statsScene = SCENE_MANAGER:GetScene('stats')
	--STATS_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	STATS_SCENE:RemoveFragment(FRAME_EMOTE_FRAGMENT_SKILLS)
	STATS_SCENE:RemoveFragment(STATS_BG_FRAGMENT)
	STATS_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_StatsPanel,							STATS_SCENE, -15, -10, 0, 10)
	PP.SetBackdrop(2, ZO_UpcomingLevelUpRewards_Keyboard,		ZO_KEYBOARD_UPCOMING_LEVEL_UP_REWARDS_FRAGMENT, -1, 0, -10, 10)
	PP.SetBackdrop(3, ZO_ClaimLevelUpRewardsScreen_Keyboard,	ZO_KEYBOARD_CLAIM_LEVEL_UP_REWARDS_FRAGMENT, -1, 0, -10, 10)

	PP.Anchor(ZO_StatsPanel, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 90,	--[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -70)
	PP.Anchor(ZO_StatsPanelPane, --[[#1]] TOPLEFT, ZO_StatsPanelTitleSection, BOTTOMLEFT, 0, 0,	--[[#2]] true, BOTTOMRIGHT, ZO_StatsPanel, BOTTOMRIGHT, 0, -3)

	PP.ScrollBar(ZO_StatsPanelPane, --[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, true)

	--ZO_ClaimLevelUpRewardsScreen_Keyboard
	PP.Anchor(ZO_ClaimLevelUpRewardsScreen_Keyboard, --[[#1]] TOPLEFT, nil, TOPLEFT, 0, 90,	--[[#2]] true, BOTTOMLEFT, nil, BOTTOMLEFT, 0, -250)
	PP.Anchor(ZO_ClaimLevelUpRewardsScreen_KeyboardList, --[[#1]] TOPLEFT, ZO_ClaimLevelUpRewardsScreen_KeyboardTitleDivider, BOTTOMLEFT, 16, 0,	--[[#2]] true, BOTTOM, ZO_ClaimLevelUpRewardsScreen_KeyboardClaimButton, CENTER, 0, -40)

	ZO_ClaimLevelUpRewardsScreen_KeyboardBG:SetHidden(true)
	ZO_ClaimLevelUpRewardsScreen_KeyboardTitleDivider:SetHidden(true)
	ZO_Scroll_SetMaxFadeDistance(ZO_ClaimLevelUpRewardsScreen_KeyboardList, 10)

	-- PP.ListBackdrop(ZO_ClaimLevelUpRewardsScreen_KeyboardList, -11, -3, -3, 3, --[[tex]] nil, 8, 0, --[[bd]] 10, 10, 10, .6, --[[edge]] 30, 30, 30, .6)
	PP.ScrollBar(ZO_ClaimLevelUpRewardsScreen_KeyboardList, --[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, true)
	--ZO_UpcomingLevelUpRewards_Keyboard
	PP.Anchor(ZO_UpcomingLevelUpRewards_Keyboard, --[[#1]] TOPLEFT, nil, TOPLEFT, 0, 90,	--[[#2]] true, BOTTOMLEFT, nil, BOTTOMLEFT, 0, -250)
	PP.Anchor(ZO_UpcomingLevelUpRewards_KeyboardScrollContainer, --[[#1]] TOPLEFT, ZO_UpcomingLevelUpRewards_KeyboardTitleDivider, BOTTOMLEFT, 16, 0,	--[[#2]] true, BOTTOMLEFT, ZO_UpcomingLevelUpRewards_Keyboard, BOTTOMLEFT, 16, 0)

	ZO_UpcomingLevelUpRewards_KeyboardBG:SetHidden(true)
	ZO_UpcomingLevelUpRewards_KeyboardTitleDivider:SetHidden(true)
	ZO_Scroll_SetMaxFadeDistance(ZO_UpcomingLevelUpRewards_KeyboardScrollContainer, 10)

	-- PP.ListBackdrop(ZO_UpcomingLevelUpRewards_KeyboardScrollContainer, -11, -3, -3, 3, --[[tex]] nil, 8, 0, --[[bd]] 10, 10, 10, .6, --[[edge]] 30, 30, 30, .6)
	PP.ScrollBar(ZO_UpcomingLevelUpRewards_KeyboardScrollContainer, --[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, true)
end