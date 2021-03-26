PP.gameMenuInGameScene = function()
--===============================================================================================--
	local SV_VER		= 0.1
	local DEF = {
		addons_toggle	= true,
		addonsListBG	= false,
	}
	local SV = ZO_SavedVars:NewAccountWide(PP.ADDON_NAME, SV_VER, "GameMenuScene", DEF, GetWorldName())
	---------------------------------------------
	table.insert(PP.optionsData,
	{	type				= "submenu",
		name				= GetString(PP_LAM_SCENE_GAME_MENU),
		controls = {
			{	type				= "header",
				name				= GetString(PP_LAM_SCENE_GAME_MENU_ADDONS),
			},
			{	type				= "checkbox",
				name				= GetString(PP_LAM_ACTIVATE),
				getFunc				= function() return SV.addons_toggle end,
				setFunc				= function(value) SV.addons_toggle = value end,
				default				= DEF.addons_toggle,
				requiresReload		= true,
			},
			{	type				= "checkbox",
				name				= GetString(PP_LAM_LIST_BG),
				getFunc				= function() return SV.addonsListBG end,
				setFunc				= function(value) SV.addonsListBG = value end,
				default				= DEF.addonsListBG,
				disabled			= function() return not SV.addons_toggle end,
				requiresReload		= true,
			},
		},
	})
--===============================================================================================--

	local gameMenuInGameScene = SCENE_MANAGER:GetScene('gameMenuInGame')
	gameMenuInGameScene:AddFragment(PP_BACKDROP_FRAGMENT)

--ADD-ONS------------------------------------------------------------------------------------------
	if SV.addons_toggle then
		PP.SetBackdrop(1, ZO_AddOns, ADDONS_FRAGMENT, 2, -4, 4, -2)

		ZO_AddOnsBGLeft:SetHidden(true)
		ZO_AddOnsDivider:SetHidden(true)

		PP.ScrollBar(ZO_AddOnsList,	--[[sb_c]] 180, 180, 180, .7, --[[bd_c]] 20, 20, 20, .7, false)
		if SV.addonsListBG then
			PP.ListBackdrop(ZO_AddOnsList, -3, -3, -3, 3, --[[tex]] nil, 8, 0, --[[bd]] 5, 5, 5, .5, --[[edge]] 30, 30, 30, .6)
		end

		PP.Anchor(ZO_AddOnsTitle,					--[[#1]] TOPLEFT, nil, TOPLEFT, 10, 5)
		PP.Anchor(ZO_AddOnsList,					--[[#1]] TOPLEFT, ZO_AddOnsTitle, BOTTOMLEFT, 0, 5,		--[[#2]] true, BOTTOMRIGHT, ZO_AddOns, BOTTOMRIGHT, 0, -10)
		PP.Anchor(ZO_AddOnsLoadOutOfDateAddOnsText,	--[[#1]] TOPRIGHT, ZO_AddOns, TOPRIGHT, -10, 10)
		PP.Anchor(ZO_AddOnsLoadOutOfDateAddOns,		--[[#1]] RIGHT, ZO_AddOnsLoadOutOfDateAddOnsText, LEFT, -6, -1)
		PP.Anchor(ZO_AddOnsCharacterSelectDropdown,	--[[#1]] LEFT, ZO_AddOnsTitle, RIGHT, 50, 1)

		PP.Font(ZO_AddOnsMultiButtonKeyLabel,		--[[Font]] PP.f.Expressway, 16, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
		PP.Font(ZO_AddOnsMultiButtonNameLabel,		--[[Font]] PP.f.Expressway, 18, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
		PP.Font(ZO_AddOnsTitle,						--[[Font]] PP.f.Expressway, 22, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)

		ZO_Scroll_SetMaxFadeDistance(ZO_AddOnsList, 10)

		local function SceneStateChange(oldState, newState)
			if newState == SCENE_SHOWING then
				PP.Anchor(ZO_AddOns, --[[#1]] TOPLEFT, GuiRoot, TOPLEFT, 250, 50, --[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMLEFT, 1200, -70)
				-- gameMenuInGameScene:UnregisterCallback("StateChange",  SceneStateChange)
			end
		end
		ADDONS_FRAGMENT:RegisterCallback("StateChange",  SceneStateChange)

		ZO_PreHookHandler(ZO_AddOns, 'OnEffectivelyShown', function()
			SetFullscreenEffect(FULLSCREEN_EFFECT_CHARACTER_FRAMING_BLUR, .75, .75)
		end)
		ZO_PreHookHandler(ZO_AddOns, 'OnEffectivelyHidden', function()
			SetFullscreenEffect(FULLSCREEN_EFFECT_NONE)
		end)

	end
--CONTROLS-----------------------------------------------------------------------------------------
	-- ZO_KeybindingsLeft:SetHidden(true)
	-- ZO_KeybindingsRight:SetHidden(true)

	-- PP.Anchor(ZO_KeybindingsList,			--[[#1]] TOPLEFT, ZO_AddOnsTitle, TOPLEFT, 20, 40,		--[[#2]] true, BOTTOMRIGHT, ZO_AddOns, BOTTOMRIGHT, -10, -40)
	
	
end