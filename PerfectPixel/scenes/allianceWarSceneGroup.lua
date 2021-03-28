PP.allianceWarSceneGroup = function()

--ZO_CampaignOverview------------------------------------------------------------------------------------------------------------------------------
	CAMPAIGN_OVERVIEW_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	CAMPAIGN_OVERVIEW_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	CAMPAIGN_OVERVIEW_SCENE:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	CAMPAIGN_OVERVIEW_SCENE:RemoveFragment(TITLE_FRAGMENT)
	CAMPAIGN_OVERVIEW_SCENE:RemoveFragment(ALLIANCE_WAR_TITLE_FRAGMENT)
	-- CAMPAIGN_OVERVIEW_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	-- PP.SetBackdrop(1, ZO_CampaignOverview,		CAMPAIGN_OVERVIEW_SCENE, -10, -10, 0, 10)
	PP:CreateBackground(ZO_CampaignOverview, --[[#1]] nil, nil, nil, -10, -10, --[[#2]] nil, nil, nil, 0, 10)

	PP.Anchor(ZO_CampaignOverview, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 120,	--[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -70)
	PP.Anchor(ZO_CampaignOverviewCategories, --[[#1]] TOPLEFT, ZO_CampaignOverview, TOPLEFT, 0, 68)
	PP.Anchor(ZO_CampaignSelector, --[[#1]] BOTTOMRIGHT, ZO_CampaignOverviewTopDivider, TOPRIGHT, -165, 25)

--ZO_CampaignBrowser
	CAMPAIGN_BROWSER_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	CAMPAIGN_BROWSER_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	CAMPAIGN_BROWSER_SCENE:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	CAMPAIGN_BROWSER_SCENE:RemoveFragment(TITLE_FRAGMENT)
	CAMPAIGN_BROWSER_SCENE:RemoveFragment(ALLIANCE_WAR_TITLE_FRAGMENT)
	-- CAMPAIGN_BROWSER_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	-- PP.SetBackdrop(1, ZO_CampaignBrowser,		CAMPAIGN_BROWSER_SCENE, -10, -10, 0, 10)
	PP:CreateBackground(ZO_CampaignBrowser, --[[#1]] nil, nil, nil, -10, -10, --[[#2]] nil, nil, nil, 0, 10)

	PP.Anchor(ZO_CampaignBrowser, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 120, 	--[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -70)
---------------------------------------------------------------------------------------------------
end