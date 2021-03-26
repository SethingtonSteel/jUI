PP.compatibility = function()
	local function Compatibility()
		--==CraftBagExtended==--
			if CraftBagExtended then
				CraftBagExtendedVendorMenu:SetParent(ZO_StoreWindowMenu)
				PP.Anchor(CraftBagExtendedVendorMenu,		--[[#1]] TOPLEFT, ZO_StoreWindowMenu,	TOPLEFT, 80, 0)

				CraftBagExtendedHouseBankMenu:SetParent(ZO_HouseBankMenu)
				PP.Anchor(CraftBagExtendedHouseBankMenu,	--[[#1]] TOPLEFT, ZO_HouseBankMenu,		TOPLEFT, 80, 0)

				CraftBagExtendedBankMenu:SetParent(ZO_PlayerBankMenu)
				PP.Anchor(CraftBagExtendedBankMenu,			--[[#1]] TOPLEFT, ZO_PlayerBankMenu,	TOPLEFT, 80, 0)

				CraftBagExtendedGuildBankMenu:SetParent(ZO_GuildBankMenu)
				PP.Anchor(CraftBagExtendedGuildBankMenu,	--[[#1]] TOPLEFT, ZO_GuildBankMenu,		TOPLEFT, 80, 0)

				CraftBagExtendedMailMenu:SetParent(ZO_MailSend)
				PP.Anchor(CraftBagExtendedMailMenu,			--[[#1]] TOPLEFT, ZO_MailSend,			TOPLEFT, 420, -55)

				-- CraftBagExtendedTradeMenu:SetParent(parent)
				-- PP.Anchor(CraftBagExtendedTradeMenu,		--[[#1]] TOPLEFT, parent,		TOPLEFT, 80, 0)
			end
		--===============================================================================================--

		--==AddonSelector==--
			if AddonSelector then
				PP.Anchor(ZO_AddOnsList,					--[[#1]] TOPLEFT, AddonSelector, BOTTOMLEFT, 0, 5, --[[#2]] true, BOTTOMRIGHT, ZO_AddOns, BOTTOMRIGHT, 0, -10)
				PP.Anchor(AddonSelectorBottomDivider,		--[[#1]] BOTTOM, AddonSelector, BOTTOM, 40, 0)
				PP.Anchor(AddonSelectorSearchBox,			--[[#1]] TOPRIGHT, ZO_AddOns, TOPRIGHT, -6, 6)
				PP.Anchor(ZO_AddOnsLoadOutOfDateAddOns,		--[[#1]] LEFT, AddonSelector, RIGHT, 60, -12)
				PP.Anchor(ZO_AddOnsLoadOutOfDateAddOnsText,	--[[#1]] LEFT, ZO_AddOnsLoadOutOfDateAddOns, RIGHT, 5, 1)
				PP.Font(AddonSelectorDeselectAddonsButtonKeyLabel,	--[[Font]] PP.f.u57, 16, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
				PP.Font(AddonSelectorDeselectAddonsButtonNameLabel,	--[[Font]] PP.f.u67, 18, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
				PP.Font(AddonSelectorSelectAddonsButtonKeyLabel,	--[[Font]] PP.f.u57, 16, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
				PP.Font(AddonSelectorSelectAddonsButtonNameLabel,	--[[Font]] PP.f.u67, 18, "outline", --[[Alpha]] nil, --[[Color]] nil, nil, nil, nil, --[[StyleColor]] 0, 0, 0, .5)
			end
		--===============================================================================================--

		--==CraftStore==--
			if CS then
				local function hidePPEnchantingBackground(doHideBackground)
					doHideBackground = doHideBackground or false
					if doHideBackground then
						ENCHANTING_SCENE:RemoveFragment(PP_BACKDROP_FRAGMENT)
					else
						ENCHANTING_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)
					end
				end
				local function applyPPEnchantingSceneAndFragments(doUsePP, enchantingMode)
					doUsePP = doUsePP or false
					if doUsePP == true then
						ZO_MenuBar_SelectDescriptor(ENCHANTING.modeBar, ENCHANTING_MODE_CREATION)
						hidePPEnchantingBackground(true)
						ENCHANTING_SCENE:RemoveFragment(KEYBIND_STRIP_FADE_FRAGMENT)
						ENCHANTING_SCENE:RemoveFragment(KEYBIND_STRIP_MUNGE_BACKDROP_FRAGMENT)
					else
						hidePPEnchantingBackground(false)
						ENCHANTING_SCENE:AddFragment(KEYBIND_STRIP_FADE_FRAGMENT)
						ENCHANTING_SCENE:AddFragment(KEYBIND_STRIP_MUNGE_BACKDROP_FRAGMENT)
					end
					if enchantingMode ~= ENCHANTING_MODE_RECIPES then
						ZO_EnchantingTopLevelInventory:SetHidden(doUsePP)
						ZO_EnchantingTopLevelModeMenu:SetHidden(doUsePP)
						if enchantingMode == ENCHANTING_MODE_CREATION then
							ZO_EnchantingTopLevelRuneSlotContainer:SetHidden(doUsePP)
						end
					end
				end

				-- ==ENCHANTING_SCENE==-- --==SCENE_MANAGER:GetScene('enchanting')==--
				ENCHANTING_SCENE:RegisterCallback("StateChange", function(oldState, newState)
					local csAccountSettings = CS.Account.options
					--Get the active enchanting panel
					local enchantingMode = ENCHANTING.enchantingMode
					local enchantingModeToCSRuneSetting = {
						[ENCHANTING_MODE_CREATION] 		= csAccountSettings.userunecreation,
						[ENCHANTING_MODE_EXTRACTION] 	= csAccountSettings.useruneextraction,
						[ENCHANTING_MODE_RECIPES] 		= csAccountSettings.userunerecipe,
					}
					local csRuneSettingState = enchantingModeToCSRuneSetting[enchantingMode] or false
					local useCSRune = (csAccountSettings.userune and csRuneSettingState) or false
					if newState == SCENE_SHOWN then
						applyPPEnchantingSceneAndFragments(useCSRune, enchantingMode)
					elseif newState == SCENE_HIDDEN then
						applyPPEnchantingSceneAndFragments(false, enchantingMode)
					end
				end)
				--[[
				--Securely PostHook the enchanting's mode change function to check if:
				--CraftStore rune uses the creation and/or extraction mode, and show/hide ESO vanilla UI elements (changed by PP)
				local function HookEnchantingOnModeUpdated(enchantingCtrl, enchantingMode)
					local csAccountSettings = CS.Account.options
					if csAccountSettings.userune then
						if     enchantingMode == ENCHANTING_MODE_CREATION then
							if csAccountSettings.userunecreation == true then
								hidePPEnchantingBackground(true)
							else
								applyPPEnchantingSceneAndFragments(false)
							end
						elseif enchantingMode == ENCHANTING_MODE_EXTRACTION then
							if csAccountSettings.useruneextraction == true then
								hidePPEnchantingBackground(true)
							else
								applyPPEnchantingSceneAndFragments(false)
							end
						elseif enchantingMode == ENCHANTING_MODE_RECIPES then
							if csAccountSettings.userunerecipe == true then
								hidePPEnchantingBackground(true)
							end
						end
					else
						applyPPEnchantingSceneAndFragments(true)
					end
				end
				--Posthook enchanting mode change
				SecurePostHook(ZO_Enchanting, "OnModeUpdated", function(self) HookEnchantingOnModeUpdated(self, self.enchantingMode) end)
				]]
				--PostHook enchanting button press of CrafStoreFixedAndImproved
				if  CS.RuneShowMode then
					local function HookCSRuneShowMode(atStationOnly)
						if (atStationOnly and not CS.Extern) or not atStationOnly then
							local csAccountSettings = CS.Account.options
							if not csAccountSettings.userune then return end
							--Creation
							if CS.Character.runemode == 'craft' then
								hidePPEnchantingBackground(csAccountSettings.userunecreation)

								--elseif CS.Character.runemode == 'search' then
								--Extraction
							elseif CS.Character.runemode == 'refine' then
								hidePPEnchantingBackground(csAccountSettings.useruneextraction)

								--elseif CS.Character.runemode == 'selection' then
								--elseif CS.Character.runemode == 'favorites' then
								--elseif CS.Character.runemode == 'furniturefavorites' then
								--elseif CS.Character.runemode == 'writ' then
								--Recipes
							elseif CS.Character.runemode == 'furniture' then
								hidePPEnchantingBackground(csAccountSettings.userunerecipe)
							end
						end
					end
					SecurePostHook(CS, "RuneShowMode", function(atStationOnly) HookCSRuneShowMode(atStationOnly) end)
				end

				-- ==PROVISIONER_SCENE==-- --==SCENE_MANAGER:GetScene('provisioner')==--
				PROVISIONER_SCENE:RegisterCallback("StateChange", function(oldState, newState)
					if newState == SCENE_SHOWN and CS.Account.options.usecook then
						PROVISIONER_SCENE:RemoveFragment(PP_BACKDROP_FRAGMENT)
						PROVISIONER_SCENE:RemoveFragment(KEYBIND_STRIP_FADE_FRAGMENT)
						PROVISIONER_SCENE:RemoveFragment(KEYBIND_STRIP_MUNGE_BACKDROP_FRAGMENT)
						ZO_ProvisionerTopLevelNavigationContainer:SetHidden(true)
					elseif newState == SCENE_HIDDEN then
						PROVISIONER_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)
						PROVISIONER_SCENE:AddFragment(KEYBIND_STRIP_FADE_FRAGMENT)
						PROVISIONER_SCENE:AddFragment(KEYBIND_STRIP_MUNGE_BACKDROP_FRAGMENT)
						ZO_ProvisionerTopLevelNavigationContainer:SetHidden(false)
					end
				end)
			end
		--===============================================================================================--

		--==MailLooter==--
			if MailLooter then
				MAIL_LOOTER_SCENE:RemoveFragment(TITLE_FRAGMENT)
				MAIL_LOOTER_SCENE:RemoveFragment(MAIL_TITLE_FRAGMENT)
				MAIL_LOOTER_SCENE:RemoveFragment(FRAME_PLAYER_FRAGMENT)
				PP.Anchor(MailLooterLootList, --[[#1]] TOP, MailLooterLootHeaders, BOTTOM, 0, 0, --[[#2]] true, BOTTOMRIGHT, ZO_MailInbox, BOTTOMRIGHT,	0, -100)
			end
		--===============================================================================================--

		--==ShissuRoster==--
			if ShissuRoster then
				local function SceneStateChange(oldState, newState)
					if newState == SCENE_SHOWING then
						PP.Anchor(ZO_GuildRoster, --[[#1]] TOPRIGHT, GuiRoot, TOPRIGHT, 0, 120, --[[#2]] true, BOTTOMRIGHT, GuiRoot, BOTTOMRIGHT,	0, -110)
						PP.Anchor(PP_TopLevelWindow_Backdrop_1, --[[#1]] TOPLEFT, ZO_GuildRoster, TOPLEFT, -10, -10, --[[#2]] true, BOTTOMRIGHT, ZO_GuildRoster, BOTTOMRIGHT,	0, 50)
						PP.Anchor(ZO_GuildRosterList, --[[#1]] TOPLEFT, ZO_GuildRosterHeaders, BOTTOMLEFT, 0, 3, --[[#2]] true, BOTTOMRIGHT, ZO_GuildRoster, BOTTOMRIGHT,	0, -40)
						PP.Anchor(ZO_GuildRosterHeaders, --[[#1]] TOPLEFT, nil, TOPLEFT, 0, 74, --[[#2]] true, TOPRIGHT, nil, TOPRIGHT,	0, 74)
						PP.Anchor(ZO_GuildRosterSearch, --[[#1]] TOPRIGHT, ZO_GuildRoster, TOPRIGHT, -320, 26)
						PP.Anchor(SGT_Roster_RankLabel, --[[#1]] LEFT, ZO_GuildRoster, BOTTOMLEFT, 70, -5)
						ZO_ScrollList_Commit(ZO_GuildRosterList)

						GUILD_ROSTER_SCENE:UnregisterCallback("StateChange",  SceneStateChange)
					end
				end
				GUILD_ROSTER_SCENE:RegisterCallback("StateChange",  SceneStateChange)
			end
		--===============================================================================================--

		--==ESO Master Recipe List==--
			if ESOMRL then
				local resultTooltip	= PROVISIONER.resultTooltip
				local detailsPane	= PROVISIONER.detailsPane
				ZO_PreHook(resultTooltip, "ClearAnchors", function()
					return true
				end)
				ZO_PreHook(resultTooltip, "SetAnchor", function()
					return true
				end)
			end
		--===============================================================================================--

		--UnregisterForEvent--
		EVENT_MANAGER:UnregisterForEvent(PP.ADDON_NAME .. "Compatibility", EVENT_PLAYER_ACTIVATED)
	end
	
	EVENT_MANAGER:RegisterForEvent(PP.ADDON_NAME .. "Compatibility", EVENT_PLAYER_ACTIVATED, Compatibility)

end