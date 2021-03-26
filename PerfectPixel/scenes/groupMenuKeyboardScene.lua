PP.groupMenuKeyboardScene = function()

	KEYBOARD_GROUP_MENU_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	KEYBOARD_GROUP_MENU_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	KEYBOARD_GROUP_MENU_SCENE:RemoveFragment(TREE_UNDERLAY_FRAGMENT)
	KEYBOARD_GROUP_MENU_SCENE:RemoveFragment(TITLE_FRAGMENT)
	KEYBOARD_GROUP_MENU_SCENE:RemoveFragment(GROUP_TITLE_FRAGMENT)
	KEYBOARD_GROUP_MENU_SCENE:RemoveFragment(FRAME_EMOTE_FRAGMENT_SOCIAL)
	KEYBOARD_GROUP_MENU_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_GroupMenu_Keyboard, KEYBOARD_GROUP_MENU_SCENE, -10, -10, 0, 10)

	KEYBOARD_GROUP_MENU_SCENE:RegisterCallback("StateChange", function(oldState, newState)
		if newState == SCENE_SHOWING then
			PP.Anchor(ZO_DisplayName, --[[#1]] TOPLEFT, ZO_GroupMenu_Keyboard, TOPLEFT, -6, -6)
		elseif newState == SCENE_HIDDEN then
			PP.Anchor(ZO_DisplayName, --[[#1]] TOPLEFT, ZO_KeyboardFriendsList, TOPLEFT, 0, 0)
		end
	end)

	PP.Anchor(ZO_GroupMenu_Keyboard, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 90,	--[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -70)
	PP.Anchor(ZO_DungeonFinder_KeyboardListSection, --[[#1]] TOPLEFT, ZO_DungeonFinder_Keyboard, TOPLEFT, 0, 0,	--[[#2]] true, BOTTOMRIGHT, ZO_DungeonFinder_Keyboard, BOTTOMRIGHT, 20, 0)

	PP.Anchor(ZO_DungeonFinder_KeyboardQueueButton,			--[[#1]] BOTTOM, ZO_SearchingForGroup, BOTTOM, 0, -4)
	PP.Anchor(ZO_DungeonFinder_KeyboardLockReason,			--[[#1]] BOTTOM, ZO_DungeonFinder_Keyboard, BOTTOM, 0, 0)

	-- PP.Anchor(ZO_AllianceWarFinder_KeyboardQueueButton,		--[[#1]] BOTTOM, ZO_SearchingForGroup, BOTTOM, 0, -4)
	-- PP.Anchor(ZO_AllianceWarFinder_KeyboardLockReason,		--[[#1]] BOTTOM, ZO_AllianceWarFinder_Keyboard, BOTTOM, 0, 0)

	PP.Anchor(ZO_BattlegroundFinder_KeyboardQueueButton,	--[[#1]] BOTTOM, ZO_SearchingForGroup, BOTTOM, 0, -4)
	PP.Anchor(ZO_BattlegroundFinder_KeyboardLockReason,		--[[#1]] BOTTOM, ZO_BattlegroundFinder_Keyboard, BOTTOM, 0, 0)
	
	PP.Anchor(ZO_SearchingForGroupLeaveQueueButton,			--[[#1]] BOTTOM, ZO_SearchingForGroup, BOTTOM, 0, -40)

	-- PP.ListBackdrop(ZO_DungeonFinder_KeyboardListSection, -8, -3, -3, 3, --[[tex]] nil, 8, 0, --[[bd]] 5, 5, 5, .6, --[[edge]] 30, 30, 30, .6)
	PP.ScrollBar(ZO_DungeonFinder_KeyboardListSection,	--[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, false)

	ZO_Scroll_SetMaxFadeDistance(ZO_DungeonFinder_KeyboardListSection, 10)
end
