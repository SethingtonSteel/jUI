PP.guildSceneGroup = function()

	PP.Anchor(ZO_GuildSelector, --[[#1]] BOTTOMLEFT, ZO_GuildHome, TOPLEFT, -70, -5)
	PP.Font(ZO_GuildSelectorComboBoxSelectedItemText, --[[Font]] PP.f.u67, 30, "outline", --[[Alpha]] .9, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .8)
	ZO_GuildSelectorDivider:SetHidden(true)

--guildHome--ZO_GuildHome--------------------------------------------------------------------
	-- local guildHomeScene = SCENE_MANAGER:GetScene('guildHome')
	GUILD_HOME_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	GUILD_HOME_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	GUILD_HOME_SCENE:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	GUILD_HOME_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_GuildHome,		GUILD_HOME_SCENE, -10, -10, 0, 10)

	ZO_Scroll_SetMaxFadeDistance(ZO_GuildHomePane, 10)
	PP.Anchor(ZO_GuildHomePane, --[[#1]] TOPLEFT, nil, TOPLEFT, 240, 70, --[[#2]] true, BOTTOMRIGHT, nil, BOTTOMRIGHT,	0, 0)
	PP.ScrollBar(ZO_GuildHomePane,	--[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, false)
	ZO_Scroll_SetMaxFadeDistance(ZO_GuildHomeInfoMotDPane, 10)
	-- PP.ListBackdrop(ZO_GuildHomePane, -3, -3, -3, 3, --[[tex]] nil, 8, 0, --[[bd]] 5, 5, 5, .6, --[[edge]] 30, 30, 30, .6)
	PP.ScrollBar(ZO_GuildHomeInfoMotDPane,	--[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, false)
	ZO_GuildHomeInfoMotD:SetDimensions(620, 450)
	ZO_GuildHomeInfoUpdatesDivider:SetHidden(true)

	PP.Anchor(ZO_GuildHome, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 120, --[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT,	0, -70)

--guildRoster--ZO_GuildRoster--------------------------------------------------------------------
	-- local guildRosterScene = SCENE_MANAGER:GetScene('guildRoster')
	GUILD_ROSTER_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	GUILD_ROSTER_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	GUILD_ROSTER_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_GuildRoster,		GUILD_ROSTER_SCENE, -10, -10, 0, 10)

	ZO_ScrollList_Commit(ZO_GuildRosterList)
	ZO_Scroll_SetMaxFadeDistance(ZO_GuildRosterList, 10)
	-- PP.ListBackdrop(ZO_GuildRosterList, -3, -3, -3, 3, --[[tex]] nil, 8, 0, --[[bd]] 5, 5, 5, .6, --[[edge]] 30, 30, 30, .6)
	PP.ScrollBar(ZO_GuildRosterList,	--[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, false)

	PP.Anchor(ZO_GuildRosterList, --[[#1]] TOPLEFT, ZO_GuildRosterHeaders, BOTTOMLEFT, 0, 3, --[[#2]] true, BOTTOMRIGHT, ZO_GuildRoster, BOTTOMRIGHT,	0, 0)
	PP.Anchor(ZO_GuildRosterHeaders, --[[#1]] TOPLEFT, nil, TOPLEFT, 0, 67, --[[#2]] true, TOPRIGHT, nil, TOPRIGHT,	0, 67)
	PP.Anchor(ZO_GuildRosterHideOffline, --[[#1]] LEFT, ZO_GuildSharedInfoTradingHouse, RIGHT, 30, 0)

    local function SceneStateChange(oldState, newState) --compatibility
        if newState == SCENE_SHOWING then
			PP.Anchor(ZO_GuildRoster, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 120, --[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT,	0, -70)
			GUILD_ROSTER_SCENE:UnregisterCallback("StateChange",  SceneStateChange)
        end
    end
    GUILD_ROSTER_SCENE:RegisterCallback("StateChange",  SceneStateChange)

--guildRanks--ZO_GuildRanks----------------------------------------------------------------------
	-- local guildRanksScene = SCENE_MANAGER:GetScene('guildRanks')
	GUILD_RANKS_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	GUILD_RANKS_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	GUILD_RANKS_SCENE:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	GUILD_RANKS_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_GuildRanks,		GUILD_RANKS_SCENE, -10, -10, 0, 10)

	PP.Anchor(ZO_GuildRanks, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT,	0, 120, --[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -70)
	PP.Anchor(ZO_GuildRanksListHeader, --[[#1]] TOPLEFT, ZO_GuildRanks, TOPLEFT,	0, 75)
	
--guildRecruitmentKeyboard-------------------------------------------------------------------------
	KEYBOARD_GUILD_RECRUITMENT_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	KEYBOARD_GUILD_RECRUITMENT_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	KEYBOARD_GUILD_RECRUITMENT_SCENE:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	KEYBOARD_GUILD_RECRUITMENT_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_GuildRecruitment_Keyboard_TopLevel,		KEYBOARD_GUILD_RECRUITMENT_SCENE, -10, -10, 0, 10)

	PP.Anchor(ZO_GuildRecruitment_Keyboard_TopLevel, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT,	0, 120, --[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -70)
	PP.Anchor(ZO_GuildRecruitment_Keyboard_TopLevelList, --[[#1]] TOPLEFT, ZO_GuildRecruitment_Keyboard_TopLevel, TOPLEFT,	0, 75)

--guildHistory--ZO_GuildHistory--------------------------------------------------------------------
	-- local guildHistoryScene = SCENE_MANAGER:GetScene('guildHistory')
	GUILD_HISTORY_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	GUILD_HISTORY_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	GUILD_HISTORY_SCENE:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	GUILD_HISTORY_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_GuildHistory,		GUILD_HISTORY_SCENE, -10, -10, 0, 10)

	ZO_ScrollList_Commit(ZO_GuildHistoryList)
	ZO_Scroll_SetMaxFadeDistance(ZO_GuildHistoryList, 10)
	-- PP.ListBackdrop(ZO_GuildHistoryList, -10, -3, -3, 3, --[[tex]] nil, 8, 0, --[[bd]] 5, 5, 5, .6, --[[edge]] 30, 30, 30, .6)
	PP.ScrollBar(ZO_GuildHistoryList,	--[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, false)
	-- PP.Anchor(ZO_GuildHistoryListScrollBar, --[[#1]] TOPLEFT, nil, TOPRIGHT, 0, 3, --[[#2]] true, BOTTOMLEFT, nil, BOTTOMRIGHT,	-6, -3)

	PP.Anchor(ZO_GuildHistoryList, --[[#1]] TOPLEFT, ZO_GuildHistoryActivityLogHeader, BOTTOMLEFT, 0, 0, --[[#2]] true, BOTTOMRIGHT, ZO_GuildHistory, BOTTOMRIGHT,	0, 0)

	PP.Anchor(ZO_GuildHistory, --[[#1]] TOPRIGHT,	GuiRoot, TOPRIGHT,	0, 120,	--[[#2]] true, BOTTOMRIGHT,	GuiRoot, BOTTOMRIGHT,	0, -70)
	PP.Anchor(ZO_GuildHistoryCategoriesHeader, --[[#1]] TOPLEFT, ZO_GuildHistory, TOPLEFT,	0, 75)

--guildCreate--ZO_GuildCreate----------------------------------------------------------------------
	-- local guildCreateScene = SCENE_MANAGER:GetScene('guildCreate')
	GUILD_CREATE_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	GUILD_CREATE_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	GUILD_CREATE_SCENE:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	GUILD_CREATE_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_GuildCreate,		GUILD_CREATE_SCENE, -10, -10, 0, 10)

	PP.Anchor(ZO_GuildCreate, --[[#1]] TOPRIGHT,	GuiRoot, TOPRIGHT,	0, 120,	--[[#2]] true, BOTTOMRIGHT,	GuiRoot, BOTTOMRIGHT,	0, -70)

--guildHeraldry--ZO_GuildHeraldry------------------------------------------------------------------
	-- local guildHeraldryScene = SCENE_MANAGER:GetScene('guildHeraldry')
	GUILD_HERALDRY_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	GUILD_HERALDRY_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	GUILD_HERALDRY_SCENE:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	GUILD_HERALDRY_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_GuildHeraldry,		GUILD_HERALDRY_SCENE, -10, -10, 0, 10)

	PP.Anchor(ZO_GuildHeraldry, --[[#1]] TOPRIGHT,	GuiRoot, TOPRIGHT,	0, 120,	--[[#2]] true, BOTTOMRIGHT,	GuiRoot, BOTTOMRIGHT,	0, -70)

--ZO_GuildBrowser_Keyboard_TopLevel--KEYBOARD_GUILD_BROWSER_SCENE----------------------------------
	KEYBOARD_GUILD_BROWSER_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	KEYBOARD_GUILD_BROWSER_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	KEYBOARD_GUILD_BROWSER_SCENE:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	KEYBOARD_GUILD_BROWSER_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_GuildBrowser_Keyboard_TopLevel, KEYBOARD_GUILD_BROWSER_SCENE, -10, -10, 0, 10)

	PP.Anchor(ZO_GuildBrowser_Keyboard_TopLevel, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT,	0, 120, --[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -70)
	PP.Anchor(ZO_GuildBrowser_GuildList_Keyboard_TopLevel, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT,	0, 120, --[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -70)

--KEYBOARD_LINK_GUILD_INFO_SCENE
end



