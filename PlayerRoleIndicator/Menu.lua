PlayerRoleIndicator = PlayerRoleIndicator or {}
local LAM2 = LibAddonMenu2
local noteVisable = false

function PlayerRoleIndicator.createSubmenu(role, roleSV, roleDefault)
	local submenu = {
		[1] = {
			type = "checkbox",
			name = string.format("Show icon above %s", role),
			getFunc = function() return roleSV.show end,
			setFunc = function(newValue) 
				roleSV.show = newValue
				PlayerRoleIndicator.UpdateRoleSwitch()
				PlayerRoleIndicator.UpdateAllIconVisuals()
				end,
			default = roleDefault.show,
		},
		[2] = {
			type = "checkbox",
			name = string.format("Show icon above alive %s", role),
			getFunc = function() return roleSV.showOnAlive end,
			setFunc = function(newValue) 
				roleSV.showOnAlive = newValue
				PlayerRoleIndicator.UpdateRoleSwitch()
				PlayerRoleIndicator.UpdateAllIconVisuals()
				end,
			disabled = function() return not roleSV.show end,
			default = roleDefault.showOnAlive,
		},
		[3] = {
			type = "colorpicker",
			name = string.format("Colour of alive %s icons", role),
			getFunc = function() return roleSV.colourAlive.r, roleSV.colourAlive.g, roleSV.colourAlive.b, roleSV.colourAlive.a end,
			setFunc = function(r,g,b,a) 
				roleSV.colourAlive.r = r
				roleSV.colourAlive.g = g
				roleSV.colourAlive.b = b
				roleSV.colourAlive.a = a
				PlayerRoleIndicator.UpdateRoleSwitch()
				PlayerRoleIndicator.UpdateAllIconVisuals()
				end,
			disabled = function() return not (roleSV.show and roleSV.showOnAlive) end,
			default = {r = roleDefault.colourAlive.r, g = roleDefault.colourAlive.g, b = roleDefault.colourAlive.b, a = roleDefault.colourAlive.a},
		},
		[4] = {
			type = "colorpicker",
			name = string.format("Colour of dead %s icons", role),
			getFunc = function() return roleSV.colourDead.r, roleSV.colourDead.g, roleSV.colourDead.b, roleSV.colourDead.a end,
			setFunc = function(r,g,b,a) 
				roleSV.colourDead.r = r
				roleSV.colourDead.g = g
				roleSV.colourDead.b = b
				roleSV.colourDead.a = a
				PlayerRoleIndicator.UpdateRoleSwitch()
				PlayerRoleIndicator.UpdateAllIconVisuals()
				end,
			disabled = function() return not roleSV.show end,
			default = {r = roleDefault.colourDead.r, g = roleDefault.colourDead.g, b = roleDefault.colourDead.b, a = roleDefault.colourDead.a},
		},
		[5] = {
			type = "iconpicker",
			name = string.format("Icon to use for %s", role),
			choices = {
				"/esoui/art/tutorial/gamepad/gp_lfg_tank.dds",
				"/esoui/art/tutorial/gamepad/gp_lfg_healer.dds",
				"/esoui/art/tutorial/gamepad/gp_lfg_dps.dds",
				"/esoui/art/tutorial/gamepad/gp_lfg_ava.dds",
				"/esoui/art/tutorial/gamepad/gp_lfg_normaldungeon.dds",
				"/esoui/art/tutorial/gamepad/gp_lfg_trial.dds",
				"/esoui/art/tutorial/gamepad/gp_lfg_veteranldungeon.dds",
				"/esoui/art/tutorial/gamepad/gp_lfg_world.dds",
				"/esoui/art/tutorial/gamepad/gp_crowns.dds",
				"/esoui/art/tutorial/gamepad/gp_bonusicon_emperor.dds",
				"/esoui/art/compass/groupleader.dds",
				"/esoui/art/compass/groupmember.dds",
			},
			maxColumns = 3,
			visibleRows = 4,
			iconSize = 32,
			getFunc = function() return roleSV.texturePath end,
			setFunc = function(newValue)
				roleSV.texturePath = newValue
				PlayerRoleIndicator.UpdateRoleSwitch()
				PlayerRoleIndicator.UpdateAllIconVisuals()
				end,
			disabled = function() return not roleSV.show end,
			default = roleDefault.texturePath,
		},
	}
	return submenu
end

function PlayerRoleIndicator.createCustomRoles()
	local submenu = {
				[1] = {
					type = "checkbox",
					name = "Use custom roles",
					getFunc = function() return PlayerRoleIndicator.savedVariables.useCustom end,
					setFunc = function(newValue) PlayerRoleIndicator.savedVariables.useCustom = newValue end,
					default = PlayerRoleIndicator.default.useCustom,
				},
				[2] = {
					type = "slider",
					name = "Number of custom roles",
					getFunc = function() return PlayerRoleIndicator.savedVariables.customNum end,
					setFunc = function(newValue)
						if newValue > PlayerRoleIndicator.savedVariables.customNum then
							for i = (PlayerRoleIndicator.savedVariables.customNum + 1), newValue, 1 do
								PlayerRoleIndicator.savedVariables.customRole[i] = PlayerRoleIndicator.default.customDefault
							end
						elseif newValue < PlayerRoleIndicator.savedVariables.customNum then
							for i = PlayerRoleIndicator.savedVariables.customNum, (newValue + 1), -1 do
								table.remove(PlayerRoleIndicator.savedVariables.customRole, i)
							end
						end
						PlayerRoleIndicator.savedVariables.customNum = newValue
						end,
					min = 0,
					max = 10,
					disabled = function() return not PlayerRoleIndicator.savedVariables.useCustom end,
					requiresReload = true,
					default = PlayerRoleIndicator.default.customNum,
				},
			}
	local controlBuffer = {}
	for _,value in ipairs(PlayerRoleIndicator.savedVariables.customRole) do
		local control = PlayerRoleIndicator.createSubmenu(value.name, value, PlayerRoleIndicator.default.customDefault)
		
		local nameCEditBox = {
			type = "editbox",
			name = "Name of custom role",
			getFunc = function() return value.name end,
			setFunc = function(newValue) value.name = newValue end,
			isMultiline = false,
			requiresReload = true,
			default = PlayerRoleIndicator.default.customDefault.name,
		}
		table.insert(control, 1, nameCEditBox)
		
		local resetButton = {
			type = "button",
			name = "Clear players",
			func = function() value.players = {} end,
			tooltip = "Will remove all players from this role.",
		}
		table.insert(control, resetButton)
		
		controlBuffer = {
			type = "submenu",
			name = value.name,
			icon = value.texturePath,
			controls = control,
			disabled = function() return not PlayerRoleIndicator.savedVariables.useCustom end,
		}
		table.insert(submenu, controlBuffer)
	end
	return submenu
end

function PlayerRoleIndicator.CreateSettingsWindow()
	local panelData = {
	type = "panel",
	name = "Player role indicator",
	displayName = "Player role indicator",
	author = "|c18fff9Parietic|r",
	version = PlayerRoleIndicator.version,
	website = "https://www.esoui.com/downloads/info2703-PlayerRoleIndicator.html",
	feedback = "https://www.esoui.com/downloads/info2703-PlayerRoleIndicator.html#comments",
	slashCommand = "/pri",
	registerForRefresh = true,
	registerForDefaults = true,
	}
	local cntrlOptionsPanel = LAM2:RegisterAddonPanel("Player_role_indicator", panelData)
	
	local optionsData = {
		[1] = {
			type = "slider",
			name = "Icon size",
			getFunc = function() return PlayerRoleIndicator.savedVariables.iconSize end,
			setFunc = function(newValue)
				PlayerRoleIndicator.savedVariables.iconSize = newValue 
				PlayerRoleIndicator.UpdateRoleSwitch()
				PlayerRoleIndicator.UpdateAllIconVisuals()
				end,
			min = 1,
			max = 128,
			default = PlayerRoleIndicator.default.iconSize,
		},
		[2] = {
			type = "slider",
			name = "Dead player icon offset",
			getFunc = function() return PlayerRoleIndicator.savedVariables.yOffsetDead end,
			setFunc = function(newValue) PlayerRoleIndicator.savedVariables.yOffsetDead = newValue end,
			min = 0,
			max = 500,
			tooltip = "The vertical offset for the icon displayed over dead players.",
			default = PlayerRoleIndicator.default.yOffsetDead,
		},
		[3] = {
			type = "slider",
			name = "Alive player icon offset",
			getFunc = function() return PlayerRoleIndicator.savedVariables.yOffsetAlive end,
			setFunc = function(newValue) PlayerRoleIndicator.savedVariables.yOffsetAlive = newValue end,
			min = 0,
			max = 500,
			tooltip = "The vertical offset for the icon displayed over alive players.",
			default = PlayerRoleIndicator.default.yOffsetAlive,
		},
		[4] = {
			type = "checkbox",
			name = "Use different colours for players resurrection status",
			getFunc = function() return PlayerRoleIndicator.savedVariables.useRezColour end,
			setFunc = function(newValue)
				PlayerRoleIndicator.savedVariables.useRezColour = newValue
				PlayerRoleIndicator.UpdateAllIconVisuals()
				end,
			default = PlayerRoleIndicator.default.useRezColour,
		},
		[5] = {
			type = "colorpicker",
			name = "Colour of players with resurrection pending",
			getFunc = function()  
				local colour = PlayerRoleIndicator.savedVariables.rezPendingColour
				return colour.r, colour.g, colour.b, colour.a 
				end,
			setFunc = function(r,g,b,a)
				local colour = PlayerRoleIndicator.savedVariables.rezPendingColour
				colour.r = r
				colour.g = g
				colour.b = b
				colour.a = a
				PlayerRoleIndicator.UpdateAllIconVisuals()
				end,
			disabled = function() return not PlayerRoleIndicator.savedVariables.useRezColour end, 
			default = {
				r = PlayerRoleIndicator.default.rezPendingColour.r,
				g = PlayerRoleIndicator.default.rezPendingColour.g,
				b = PlayerRoleIndicator.default.rezPendingColour.b,
				a = PlayerRoleIndicator.default.rezPendingColour.a
				},
		},
		[6] = {
			type = "colorpicker",
			name = "Colour of players being resurrected",
			getFunc = function()  
				local colour = PlayerRoleIndicator.savedVariables.rezingColour
				return colour.r, colour.g, colour.b, colour.a 
				end,
			setFunc = function(r,g,b,a)
				local colour = PlayerRoleIndicator.savedVariables.rezingColour
				colour.r = r
				colour.g = g
				colour.b = b
				colour.a = a
				PlayerRoleIndicator.UpdateAllIconVisuals()
				end,
			disabled = function() return not PlayerRoleIndicator.savedVariables.useRezColour end, 
			default = {
				r = PlayerRoleIndicator.default.rezingColour.r,
				g = PlayerRoleIndicator.default.rezingColour.g,
				b = PlayerRoleIndicator.default.rezingColour.b,
				a = PlayerRoleIndicator.default.rezingColour.a
				},
		},
		[7] = {
			type = "submenu",
			name = "Notifications",
			icon = "/esoui/art/tutorial/gamepad/achievement_categoryicon_quests.dds",
			controls = {
				[1] = {
					type = "description",
					text = "Gives a notification on screen when a group member dies or is resurrected." ..
					"\n\nIcon, colour and if it should be showed for X role is taken from the respected role settings."
					},
				[2] = {
					type = "checkbox",
					name = "Use notifications",
					getFunc = function() return PlayerRoleIndicator.savedVariables.useNote end,
					setFunc = function(newValue) PlayerRoleIndicator.savedVariables.useNote = newValue end,
					default = PlayerRoleIndicator.default.useNote,
				},
				[3] = {
					type = "checkbox",
					name = "Unlock and show notification panel",
					getFunc = function() return noteVisable end,
					setFunc = function(newValue)
						local c = PlayerRoleIndicatorWindowNotePanel
						c:SetMouseEnabled(newValue)
						c:SetMovable(newValue)
						
						for i = 1, PlayerRoleIndicator.noteNum, 1 do
							local label = c:GetNamedChild(string.format("Note%u", i))
							local labelIcon = label:GetNamedChild("Icon")
							label:SetHidden(not newValue)
							labelIcon:SetHidden(not newValue)
						end
						
						if not newValue then
							PlayerRoleIndicator.savedVariables.notePos.x = c:GetLeft()
							PlayerRoleIndicator.savedVariables.notePos.y = c:GetTop()
							PlayerRoleIndicator.UpdateAllNoteSize()
						end
						
						noteVisable = newValue
						end,
					disabled = function() return not PlayerRoleIndicator.savedVariables.useNote end,
					default = false,
				},
				[4] = {
					type = "slider",
					name = "Notification scale",
					getFunc = function() return PlayerRoleIndicator.savedVariables.noteSize end,
					setFunc = function(newValue) 
						PlayerRoleIndicator.savedVariables.noteSize = newValue
						PlayerRoleIndicator.UpdateAllNoteSize()
						end,
					min = 0.1,
					max = 4,
					step = 0.1,
					decimals = 1,
					disabled = function() return not PlayerRoleIndicator.savedVariables.useNote end,
					default = PlayerRoleIndicator.default.noteSize,
				},
				[5] = {
					type = "slider",
					name = "Notification duration",
					getFunc = function() return PlayerRoleIndicator.savedVariables.noteDuration end,
					setFunc = function(newValue) PlayerRoleIndicator.savedVariables.noteDuration = newValue end,
					min = 1,
					max = 10,
					disabled = function() return not PlayerRoleIndicator.savedVariables.useNote end,
					default = PlayerRoleIndicator.default.noteDuration,
				},
				[6] = {
					type = "checkbox",
					name = "Use account name",
					getFunc = function() return PlayerRoleIndicator.savedVariables.noteUseAccountName end,
					setFunc = function(newValue) PlayerRoleIndicator.savedVariables.noteUseAccountName = newValue end,
					disabled = function() return not PlayerRoleIndicator.savedVariables.useNote end,
					default = PlayerRoleIndicator.default.noteUseAccountName,
				},
				[7] = {
					type = "checkbox",
					name = "Use role icon in notification",
					getFunc = function() return PlayerRoleIndicator.savedVariables.noteUseIcon end,
					setFunc = function(newValue) PlayerRoleIndicator.savedVariables.noteUseIcon = newValue end,
					disabled = function() return not PlayerRoleIndicator.savedVariables.useNote end,
					default = PlayerRoleIndicator.default.noteUseIcon,
				},
			},
		},
		[8] = {
			type = "submenu",
			name = "leader",
			icon = "/esoui/art/compass/groupleader.dds",
			controls = PlayerRoleIndicator.createSubmenu("leader", PlayerRoleIndicator.savedVariables.leader, PlayerRoleIndicator.default.leader),
		},
		[9] = {
			type = "submenu",
			name = "tanks",
			icon = "/esoui/art/tutorial/gamepad/gp_lfg_tank.dds",
			controls = PlayerRoleIndicator.createSubmenu("tanks", PlayerRoleIndicator.savedVariables.tank, PlayerRoleIndicator.default.tank),
		},
		[10] = {
			type = "submenu",
			name = "healers",
			icon = "/esoui/art/tutorial/gamepad/gp_lfg_healer.dds",
			controls = PlayerRoleIndicator.createSubmenu("healers", PlayerRoleIndicator.savedVariables.healer, PlayerRoleIndicator.default.healer),
		},
		[11] = {
			type = "submenu",
			name = "damage dealers",
			icon = "/esoui/art/tutorial/gamepad/gp_lfg_dps.dds",
			controls = PlayerRoleIndicator.createSubmenu("damage dealers", PlayerRoleIndicator.savedVariables.dps, PlayerRoleIndicator.default.dps),
		},
		[12] = {
			type = "submenu",
			name = "Custom roles",
			icon = "/esoui/art/tutorial/gamepad/gp_lfg_world.dds",
			controls = PlayerRoleIndicator.createCustomRoles(),
		},
		[13] = {
			type = "submenu",
			name = "Shadow of the Fallen",
			icon = GetAbilityIcon(102271), --Icon for "Shadow of the Fallen" buff
			tooltip = "Settings for the veteran Cloudrest shade on death mechanic.",
			controls = {
				[1] = {
					type = "description",
					text = "When a player dies while fighting Z'Maja in veteran Cloudrest a shade will spawn. " ..
					"This shade must be killed before you can resurrect the fallen player." ..
					"\n\nThese are the settings relating to this mechanic, if a player is down and their shade is alive the icon above them will reflect this via a colour change when enabled.",
				},
				[2] = {
					type = "checkbox",
					name = "Enable colour indicator for Shadow of the Fallen",
					getFunc = function() return PlayerRoleIndicator.savedVariables.showShade end,
					setFunc = function(newValue)
						PlayerRoleIndicator.savedVariables.showShade = newValue
						PlayerRoleIndicator.UpdateRoleSwitch()
						PlayerRoleIndicator.UpdateAllIconVisuals()
						end,
					default = PlayerRoleIndicator.default.showShade,
				},
				[3] = {
					type = "colorpicker",
					name = "Colour of icon while shade is alive",
					getFunc = function() return 
						PlayerRoleIndicator.savedVariables.shadeColour.r,
						PlayerRoleIndicator.savedVariables.shadeColour.g,
						PlayerRoleIndicator.savedVariables.shadeColour.b,
						PlayerRoleIndicator.savedVariables.shadeColour.a
						end,
					setFunc = function(r,g,b,a)
						PlayerRoleIndicator.savedVariables.shadeColour.r = r
						PlayerRoleIndicator.savedVariables.shadeColour.g = g
						PlayerRoleIndicator.savedVariables.shadeColour.b = b
						PlayerRoleIndicator.savedVariables.shadeColour.a = a
						end,
					default = {
						r = PlayerRoleIndicator.default.shadeColour.r, 
						g = PlayerRoleIndicator.default.shadeColour.g,
						b = PlayerRoleIndicator.default.shadeColour.b,
						a = PlayerRoleIndicator.default.shadeColour.a
						},
				},
			},
		},
	}
	LAM2:RegisterOptionControls("Player_role_indicator", optionsData)
end