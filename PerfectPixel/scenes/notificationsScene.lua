PP.notificationsScene = function()

--ZO_Notifications--notifications--NOTIFICATIONS_SCENE---------------------------------------------
	-- NOTIFICATIONS_SCENE:RemoveFragment(END_IN_WORLD_INTERACTIONS_FRAGMENT)
	NOTIFICATIONS_SCENE:RemoveFragment(FRAME_TARGET_STANDARD_RIGHT_PANEL_FRAGMENT)
	NOTIFICATIONS_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	NOTIFICATIONS_SCENE:RemoveFragment(TITLE_FRAGMENT)
	NOTIFICATIONS_SCENE:RemoveFragment(NOTIFICATIONS_TITLE_FRAGMENT)
	NOTIFICATIONS_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	-- NOTIFICATIONS_SCENE:RemoveFragment(FRAME_EMOTE_FRAGMENT_SOCIAL)
	NOTIFICATIONS_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_Notifications, NOTIFICATIONS_SCENE, -10, -10, 0, 10)

	PP.Anchor(ZO_Notifications, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 90,	--[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT, 0, -70)

	ZO_ScrollList_Commit(ZO_NotificationsList)
---------------------------------------------------------------------------------------------------
end