PP.friendsListGroup = function()

--friendsList--ZO_KeyboardFriendsList--------------------------------------------------------------------
	-- local friendsListScene = SCENE_MANAGER:GetScene('friendsList')
	FRIENDS_LIST_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	FRIENDS_LIST_SCENE:RemoveFragment(FRAME_EMOTE_FRAGMENT_SOCIAL)
	FRIENDS_LIST_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	FRIENDS_LIST_SCENE:RemoveFragment(TITLE_FRAGMENT)
	FRIENDS_LIST_SCENE:RemoveFragment(CONTACTS_TITLE_FRAGMENT)
	FRIENDS_LIST_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_KeyboardFriendsList,		FRIENDS_LIST_SCENE, -10, -10, 0, 10)

	ZO_ScrollList_Commit(ZO_KeyboardFriendsListList)
	PP.Anchor(ZO_KeyboardFriendsList, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 120, --[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT,	0, -70)

--ignoreList--ZO_KeyboardIgnoreList--------------------------------------------------------------------
	-- local ignoreListScene = SCENE_MANAGER:GetScene('ignoreList')
	IGNORE_LIST_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
	IGNORE_LIST_SCENE:RemoveFragment(FRAME_EMOTE_FRAGMENT_SOCIAL)
	IGNORE_LIST_SCENE:RemoveFragment(RIGHT_BG_FRAGMENT)
	IGNORE_LIST_SCENE:RemoveFragment(TITLE_FRAGMENT)
	IGNORE_LIST_SCENE:RemoveFragment(CONTACTS_TITLE_FRAGMENT)
	IGNORE_LIST_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

	PP.SetBackdrop(1, ZO_KeyboardIgnoreList,		IGNORE_LIST_SCENE, -10, -10, 0, 10)

	ZO_ScrollList_Commit(ZO_KeyboardIgnoreListList)
	PP.Anchor(ZO_KeyboardIgnoreList, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 120, --[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT,	0, -70)

end



