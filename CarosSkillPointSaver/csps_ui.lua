local GS = GetString
local checkedT = "esoui/art/buttons/checkbox_checked.dds"
local uncheckedT = "esoui/art/buttons/checkbox_unchecked.dds"
local helpSections = {}
local helpOversections = {}
local impExpChoices = {}

CSPS.colTbl = {
	white = {1,1,1},			-- white
	green = {0.1,0.7,0.1},  	-- green
	red = {0.84, 0.12, 0.12}, 	-- red
	orange = {1, 0.24, 0}, 		-- orange
}


local function initCSPSHelp()
	local helpOversectionsCtr = CSPSWindowHelpSection:GetNamedChild("Oversections")
	local ovBefore = 0
	for i=1, 42 do
		local myTitle = GS("CSPS_Help_Head", i)
		if myTitle == "" then break end
		local myText = GS("CSPS_Help_Sect", i)
		local myOversection = GS("CSPS_Help_Oversection", i)
		helpSections[i] = WINDOW_MANAGER:CreateControlFromVirtual("CSPSWindowHelpSectionSection"..i, CSPSWindowHelpSection, "CSPSHelpSectionPres")
		local ctrBefore = helpOversectionsCtr
		if myOversection ~= "" then
			helpOversections[i] = WINDOW_MANAGER:CreateControlFromVirtual("CSPSWindowHelpSectionOversection"..i, CSPSWindowHelpSectionOversections, "CSPSHelpOversectionPres")
			if i == 1 then
				helpOversections[i]:SetAnchor(TOPLEFT, helpOversectionsCtr, TOPLEFT, 0, 0)
				helpOversectionsCtr:SetWidth(100)
			else
				helpOversections[i]:SetAnchor(LEFT, helpOversections[ovBefore], RIGHT, 5, 0)
				helpOversectionsCtr:SetWidth(helpOversectionsCtr:GetWidth()+105)
			end
			helpOversections[i]:SetText(myOversection)
			helpOversections[i].myIndex = i
			ovBefore = i
		end
		if i > 1 and i ~= ovBefore then ctrBefore = helpSections[i-1] end
		helpSections[i]:SetAnchor(TOP, ctrBefore, BOTTOM, 0, 5)
		helpSections[i]:GetNamedChild("Btn"):SetText(myTitle)
		helpSections[i]:GetNamedChild("Btn").myIndex = i
		helpSections[i]:GetNamedChild("Btn"):SetHeight(0)
		helpSections[i]:GetNamedChild("Btn"):SetHidden(true)
		helpSections[i]:GetNamedChild("Lbl").auxText = myText
	end
end

function CSPS.showHelp()
	if #helpSections == 0 then initCSPSHelp() end
	CSPSWindowHelpSection:SetHidden(not CSPSWindowHelpSection:IsHidden())
end

function CSPS:InitLocalText()
	-- Loading localized text data
	CSPS.skillTypeNames = {
		GS(SI_SKILLTYPE1),
		GS(SI_SKILLTYPE2),
		GS(SI_SKILLTYPE3),
		GS(SI_SKILLTYPE4),
		GS(SI_SKILLTYPE5),
		GS(SI_SKILLTYPE6),
		GS(SI_SKILLTYPE7),
		GS(SI_SKILLTYPE8),
	}
	CSPSWindowTitle:SetText(GS(CSPS_MyWindowTitle))
	CSPSWindowIncludeAttrLabel:SetText(GS(SI_STATS_ATTRIBUTES))
	CSPSWindowIncludeCPLabel:SetText(GS(CSPS_TxtCp))
	CSPSWindowIncludeSkLabel:SetText(GS(SI_CHARACTER_MENU_SKILLS))
	CSPSWindowImportExportAllianceLabel:SetText(GS(SI_STAT_GAMEPAD_ALLIANCE_LABEL)..":")
	CSPSWindowImportExportClassLabel:SetText(GS(SI_STAT_GAMEPAD_CLASS_LABEL)..":")
	CSPSWindowImportExportRaceLabel:SetText(GS(SI_STAT_GAMEPAD_RACE_LABEL)..":")
	CSPSWindowImportExportMundusLabel:SetText(GS(SI_CONFIRM_MUNDUS_STONE_TITLE)..":")
	CSPSWindowFooterBarSwapLabel:SetText(GS(CSPS_WaitForBarSwap))
	CSPSWindowCPProfilesCustomAcc:SetText(GS(CSPS_CPP_BtnCustAcc))
	CSPSWindowCPProfilesCustomChar:SetText(GS(CSPS_CPP_BtnCustChar))
	CSPSWindowCPProfilesPresets:SetText(GS(CSPS_CPP_BtnPresets))
	CSPSWindowCPProfilesBarsOnly:SetText(GS(CSPS_CPP_BtnHotBar))
	CSPSWindowCPProfilesImportFromText:SetText(GS(CSPS_CPP_BtnImportText))
	CSPSWindowCPProfilesHeaderPoints:SetText(GS(CSPS_CPP_Points))
	CSPSWindowCPProfilesHeaderName:SetText(GS(CSPS_CPP_Name))
	CSPSWindowCPImportSuccessLbl:SetText(GS(CSPS_CPImp_Success))
	CSPSWindowCPImportOpenLbl:SetText(GS(CSPS_CPImp_Unmapped))
	CSPSWindowCPImportMapApply:SetText(GS(CSPS_CPImp_BtnApply))
	CSPSWindowCPImportMapDiscard:SetText(GS(CSPS_CPImp_BtnDiscard))
	CSPSWindowCPImportMapDiscardAll:SetText(GS(CSPS_CPImp_BtnDiscardAll))
	CSPSWindowOptionsBtnHotbar:SetText(GS(CSPS_ShowHb))
	CSPSWindowOptionsBtnOldCP:SetText(GS(CSPS_ShowOldCP))
	CSPSWindowOptionsBtnCPReminder:SetText(GS(CSPS_CPReminderOn))
	CSPSWindowOptionsBtnManageBars:SetText(GS(CSPS_CPBar_Manage))
	CSPSWindowOptionsBtnCPAutoOpen:SetText(GS(CSPS_CPAutoOpen))
	CSPSWindowCPProfilesLblStrictOrder:SetText(GS(CSPS_StrictOrder))
	CSPSWindowOptionsBtnCPCustomBar:SetText(GS(CSPS_CPCustomBar))
	CSPSWindowOptionsBtnCPCustomIcons:SetText(GS(CSPS_CPCustomIcons))
	
	
	CSPSWindowCPProfilesHeaderRole:SetText(GS(CSPS_CPP_Role))
	CSPSWindowCPProfilesHeaderSource:SetText(GS(CSPS_CPP_Source))
	
	CSPSWindowManageBarsLblAddBind:SetText(GS(CSPS_CPBar_AddBindings))
	CSPSWindowManageBarsBtnLoc:SetText(GS(CSPS_CPBar_Location))
	CSPSWindowManageBarsAddBind:SetText(GS(CSPS_CPBar_AddBind))
	CSPSWindowManageBarsLblBindList:SetText(GS(CSPS_CPBar_BindingsHeader))
	CSPSWindowManageBarsEditProfiles:SetText(GS(CSPS_CPBar_EditProfiles))
	CSPSWindowManageBarsApply:SetText(GS(CSPS_CPBar_Apply))
	
	CSPSWindowImportExportLblReverse:SetText(GS(CSPS_ImpExp_ReverseLabel))
	CSPSWindowImportExportLblCap:SetText(GS(CSPS_ImpEx_CapLabel))
	CSPSWindowImportExportCleanUpText:SetText(GS(CSPS_ImpExp_CleanUp))
	CSPSWindowImportExportTransferCPHkCopyReplace:SetText(GS(CSPS_ImpExp_Transfer_CopyReplace))
	CSPSWindowImportExportTransferCPHkCopyAdd:SetText(GS(CSPS_ImpExp_Transfer_CopyAdd))

	CSPS.skillErrors = {
		GS(CSPS_ErrorNumber1),
		GS(CSPS_ErrorNumber2),
		GS(CSPS_ErrorNumber3),
		GS(CSPS_ErrorNumber4),
	}	
	
	ESO_Dialogs[CSPS.name.."_ConfirmSave"] = {
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_ConfirmSave",
		title = {text = GS(CSPS_MyWindowTitle)},
		mainText = {text = GS(CSPS_MSG_ConfirmSave)},
		buttons = {
			[1] = {
				text = SI_DIALOG_CONFIRM,
				callback = function(dialog) 
					if dialog.data ~= nil then 
						CSPS.cp2ProfileSaveGo(dialog.data.myId, dialog.data.myType) 
					else 
						CSPS.saveBuildGo() 
					end 
				end,
			},
			[2] = {
				text = SI_DIALOG_CANCEL,
				callback = function() end,
			},
		},
		setup = function() end,
	}
	ESO_Dialogs[CSPS.name.."_ConfirmApply"] = {
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_ConfirmApply",
		title = {text = GS(CSPS_MyWindowTitle)},
		mainText = {text = GS(CSPS_MSG_ConfirmApply)},
		buttons = {
			[1] = {
				text = SI_DIALOG_CONFIRM,
				callback = function() CSPS.applyBuildGo() end,
			},
			[2] = {
				text = SI_DIALOG_CANCEL,
				callback = function() end,
			},
		},
		setup = function() end,
	}
	ESO_Dialogs[CSPS.name.."_CPPend"] = {
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_CPPend",
		title = {text = GS(CSPS_MSG_CpPendTitle)},
		mainText = {text = GS(CSPS_MSG_CpPend)},
		buttons = {
			[1] = {
				text = SI_DIALOG_CONFIRM,
				callback = function() end,
			},
		},
		setup = function() end,
	}
	ESO_Dialogs[CSPS.name.."_OkDiag"] = {
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_OkDiag",
		title = {text = GS(CSPS_MyWindowTitle)},
		mainText = {text = "<<1>>"},
		buttons = {
			[1] = {
				text = SI_DIALOG_CONFIRM,
				callback =  function(dialog) dialog.data.returnFunc() end,
			},
		},
		setup = function() end,
	}
	ESO_Dialogs[CSPS.name.."_CPAttr"] = {
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_CPAttr",
		title = {text = GS(CSPS_MSG_ConfirmAttrTitle)},
		mainText = {text = GS(CSPS_MSG_ConfirmAttr)},
		buttons = {
			[1] = {
				text = SI_DIALOG_CONFIRM,
				callback = function() CSPS.attrAnwendenGo() end,
			},
			[2] = {
				text = SI_DIALOG_CANCEL,
				callback = function() end,
			},
		},	
	}
	ESO_Dialogs[CSPS.name.."_CPAttr1"] = {
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_CPAttr1",
		title = {text = GS(CSPS_MSG_ConfirmAttrTitle)},
		mainText = {text = GS(CSPS_MSG_ConfirmAttr1)},
		buttons = {
			[1] = {
				text = SI_DIALOG_CONFIRM,
				callback = function() end,
			},
		},
		setup = function() end,
	}
	ESO_Dialogs[CSPS.name.."_CPAttr2"] = {
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_CPAttr2",
		title = {text = GS(CSPS_MSG_ConfirmAttrTitle)},
		mainText = {text = GS(CSPS_MSG_ConfirmAttr2)},
		buttons = {
			[1] = {
				text = SI_DIALOG_CONFIRM,
				callback = function() end,
			},
		},
		setup = function() end,
	}
	ESO_Dialogs[CSPS.name.."_DiagMigriert"] = {
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_DiagMigriert",
		title = {text = GS(CSPS_MyWindowTitle)},
		mainText = {text = GS(CSPS_MSG_Migrated)},
		buttons = {
			[1] = {
				text = SI_DIALOG_CONFIRM,
				callback = function() end,
			},
		},
		setup = function() end,
	}
	
	ESO_Dialogs[CSPS.name.."_DeleteProfile"] = {
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_DeleteProfile",
		title = {text = GS(CSPS_MyWindowTitle)},
		mainText = {text = GS(CSPS_MSG_DeleteProfile)},
		buttons = {
			[1] = {
				text = SI_DIALOG_CONFIRM,
				callback = function(dialog) 
					if dialog.data ~=nil then
						CSPS.cp2ProfileDelete(dialog.data.myId, dialog.data.myType) 
					else 
						CSPS.deleteProfileGo() 
					end 
				end
			},
			[2] = {
				text = SI_DIALOG_CANCEL,
				callback = function() end,
			},
		},	
	}	
	ESO_Dialogs[CSPS.name.."_YesNoDiag"] = {
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_YesNoDiag",
		title = {text = GS(CSPS_MyWindowTitle)},
		mainText = {text = "<<1>>"},
		buttons = {
			[1] = {
				text = SI_DIALOG_YES,
				callback = function(dialog) dialog.data.yesFunc() end,
			},
			[2] = {
				text = SI_DIALOG_NO,
				callback = function(dialog) dialog.data.noFunc() end,
			},
			},
		setup = function() end,
	}
	ESO_Dialogs[CSPS.name.."_RenameProfile"] = {
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_RenameProfile",
		title = {text = GS(CSPS_MyWindowTitle)},
		mainText = {text = GS(CSPS_MSG_RenameProfile)},
		editBox = {},
		buttons = {
			[1] = {
				text = SI_DIALOG_CONFIRM,
				callback = function(dialog)
					local txt = ZO_Dialogs_GetEditBoxText(dialog)
					if txt ~= "" and dialog.data ~= nil then 
						CSPS.cp2ProfileRenameGo(txt, dialog.data.myId, dialog.data.myType) 
					elseif txt ~= "" then
						CSPS.renameProfileGo(txt) 
					end
					
					
				end,
			},
			[2] = {
				text = SI_DIALOG_CANCEL,
				callback = function() end,
			},
			},
		setup = function() end,
	}
	ESO_Dialogs[CSPS.name.."_ChangeProfile"] = {
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_ChangeProfile",
		title = {text = GS(CSPS_MyWindowTitle)},
		mainText = {text = GS(CSPS_MSG__ChangeProfile)},
		buttons = {
			[1] = {
				text = SI_DIALOG_CONFIRM,
				callback = function()
					CSPS.selectProfile(CSPS.profileToLoad)
					CSPS.loadBuild()
				end,
			},
			[2] = {
				text = SI_DIALOG_CANCEL,
				callback = function() 
					local currentProfile = CSPS.currentProfile or 0
					if currentProfile == 0 then
						CSPSWindowBuildProfiles.comboBox:SetSelectedItem(GS(CSPS_Txt_StandardProfile))
					else
						CSPSWindowBuildProfiles.comboBox:SetSelectedItem(CSPS.profiles[currentProfile].name)
					end
				end,
			},
			},
		setup = function() end,
	}
	ESO_Dialogs[CSPS.name.."_DeleteSkillType"] = { 
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_DeleteSkillType",
		title = {text = GS(CSPS_MyWindowTitle)},
		mainText = {text = GS(CSPS_MSG_DeleteSkillType)},
		buttons = {
			[1] = {
				text = SI_DIALOG_CONFIRM,
				callback = function(dialog) CSPS.removeSkillLine(dialog.data.i, dialog.data.j) end,
			},
			[2] = {
				text = SI_DIALOG_CANCEL,
				callback = function() end,
			},
		},	
	}		
	
	ESO_Dialogs[CSPS.name.."_CpPurch"] = { 
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_CpPurch",
		title = {text = GS(CSPS_MSG_CpPurchTitle)},
		mainText = {text = "<<1>>"},
		buttons = {
			[1] = {
				text = SI_DIALOG_CONFIRM,
				callback = function(dialog) CSPS.cp2ApplyConfirm(dialog.data.respecNeeded) end,
			},
			[2] = {
				text = SI_DIALOG_CANCEL,
				callback = function() end,
			},
		},	
	}	
	ESO_Dialogs[CSPS.name.."_CpPurchConf"] = {
		canQueue = true,
		uniqueIdentifier = CSPS.name.."_CpPurchSuccess",
		title = {text = GS(CSPS_MSG_CpPurchTitle)},
		mainText = {text = "<<1>>"},
		buttons = {
			[1] = {
				text = SI_DIALOG_CONFIRM,
				callback = function() end,
			},
		},
		setup = function() end,
	}
		
	CSPS.fillSrcCombo()
	CSPS.fillProfileCombo()
end


function CSPS.OnWindowMoveStop()
	CSPS.savedVariables.settings.left = CSPSWindow:GetLeft()
	CSPS.savedVariables.settings.top = CSPSWindow:GetTop()
end

function CSPS:RestorePosition()
  local left = CSPS.savedVariables.settings.left
  local top = CSPS.savedVariables.settings.top
  CSPSWindow:ClearAnchors()
  CSPSWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
  if CSPS.savedVariables.settings.hbleft == nil then return end
  local hbleft = CSPS.savedVariables.settings.hbleft
  local hbtop = CSPS.savedVariables.settings.hbtop
  CSPSCpHotbar:ClearAnchors()
  CSPSCpHotbar:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, hbleft, hbtop)
end

function CSPS.showElement(myElement, arg)
	if myElement == "checkCP" then
		if CSPS.unlockedCP == false then
			CSPSWindowIncludeCPCheck:SetHidden(true)
			CSPSWindowIncludeCPCheck1:SetHidden(true)
			CSPSWindowIncludeCPCheck2:SetHidden(true)
			CSPSWindowIncludeCPCheck3:SetHidden(true)
			CSPSWindowIncludeCPLabel:SetHidden(true)
			CSPSWindowBuildCPProfileGreen:SetHidden(true)
			CSPSWindowBuildCPProfileRed:SetHidden(true)
			CSPSWindowBuildCPProfileBlue:SetHidden(true)
		else
			CSPSWindowIncludeCPCheck:SetHidden(true)
			CSPSWindowIncludeCPCheck1:SetHidden(false)
			CSPSWindowIncludeCPCheck2:SetHidden(false)
			CSPSWindowIncludeCPCheck3:SetHidden(false)
			CSPSWindowIncludeCPLabel:SetHidden(false)
			CSPSWindowBuildCPProfileGreen:SetHidden(false)
			CSPSWindowBuildCPProfileRed:SetHidden(false)
			CSPSWindowBuildCPProfileBlue:SetHidden(false)
		end
	elseif myElement == "cp2barlabels" then
		if arg ~= nil then CSPS.cp2BarLabels = arg else CSPS.cp2BarLabels = not CSPS.cp2BarLabels end
		local cp2BL = CSPS.cp2BarLabels
		local myCtrl = CSPSWindowCP2Bar
		if cp2BL == true then
			myCtrl:GetNamedChild("ToggleLabels"):SetNormalTexture("esoui/art/buttons/large_rightarrow_up.dds")
			myCtrl:GetNamedChild("ToggleLabels"):SetMouseOverTexture("esoui/art/buttons/large_rightarrow_over.dds")
			myCtrl:GetNamedChild("ToggleLabels"):SetPressedTexture("esoui/art/buttons/large_rightarrow_down.dds")
			myCtrl:SetWidth(242)
		else 
			myCtrl:GetNamedChild("ToggleLabels"):SetNormalTexture("esoui/art/buttons/large_leftarrow_up.dds")
			myCtrl:GetNamedChild("ToggleLabels"):SetMouseOverTexture("esoui/art/buttons/large_leftarrow_over.dds")
			myCtrl:GetNamedChild("ToggleLabels"):SetPressedTexture("esoui/art/buttons/large_leftarrow_down.dds")
			myCtrl:SetWidth(38)
		end
		for i=1, 3 do
			for j=1,4 do 
				CSPSWindowCP2Bar:GetNamedChild("Label"..i.."_"..j):SetHidden(not cp2BL)
			end
		end
		
		
	elseif myElement == "load" then
		if arg ~= nil then CSPSWindowBuildLaden:SetHidden(not arg) return end
		if not CSPS.currentCharData or not CSPS.currentCharData.werte or not CSPS.currentCharData.werte.prog then
			CSPSWindowBuildLaden:SetHidden(true)
		else
			CSPSWindowBuildLaden:SetHidden(false)
		end
	elseif myElement == "save" then
		if arg ~= nil then CSPSWindowBuildSpeichern:SetHidden(not arg) end
	elseif myElement == "apply" then
		if arg ~= nil then
			CSPS.showApply = arg
			CSPSWindowInclude:SetHidden(not arg)
			if arg == true then
				CSPSWindowInclude:SetHeight(24)
			else
				CSPSWindowInclude:SetHeight(0)
			end
		end
	elseif myElement == "hotbar" then
		if arg == false then
			CSPSWindowFooter:SetHidden(true)
			CSPSWindowFooter:SetHeight(3)
			CSPSWindowOptionsChkHotbar:SetTexture(uncheckedT)
		else
			CSPSWindowFooter:SetHidden(false)
			CSPSWindowFooter:SetHeight(46)
			CSPSWindowOptionsChkHotbar:SetTexture(checkedT)
		end
	elseif myElement == "oldCP" then
		if arg ~= nil then CSPS.showOldCP = arg else CSPS.showOldCP = not CSPS.showOldCP end
		if CSPS.showOldCP == true then
			CSPSWindowOptionsChkOldCP:SetTexture(checkedT)
		else
			CSPSWindowOptionsChkOldCP:SetTexture(uncheckedT)
		end
		CSPS.savedVariables.settings.showOldCP = CSPS.showOldCP
		CSPS.myTree:RefreshVisible()
	elseif myElement == "cpProfiles" then
		local showMe = CSPSWindowCPProfiles:IsHidden()
		if arg ~= nil then showMe = arg end
		CSPSWindowCPProfiles:SetHidden(not showMe)
		if (not CSPSWindowCPImport:IsHidden() and showMe == true) or not CSPSWindowCPProfiles:IsHidden() then
			CSPS.showElement("apply", true)
			CSPS.showElement("save", true)
			CSPS.unsavedChanges = true
		end
		CSPSWindowCPImport:SetHidden(true)
		if showMe then CSPSWindowCPProfiles:SetHeight(320) else CSPSWindowCPProfiles:SetHeight(0) end
	elseif myElement == "cpImport" then
		local showMe = CSPSWindowCPImport:IsHidden()
		if arg ~= nil then showMe = arg end
		if not CSPSWindowCPImport:IsHidden() then
			CSPS.showElement("apply", true)
			CSPS.showElement("save", true)
			CSPS.unsavedChanges = true
			CSPS.inCpRemapMode = false
			cpDisciToMap = nil
			cpSkillToMap = nil
		end
		CSPSWindowCPProfiles:SetHidden(true)
		CSPSWindowCPImport:SetHidden(not showMe)
		if showMe then CSPSWindowCPProfiles:SetHeight(320) else CSPSWindowCPProfiles:SetHeight(0) end
	end
	
end

function CSPS.toggleOptional()
	CSPSWindowOptions:SetHidden(not CSPSWindowOptions:IsHidden())
	if not CSPSWindowOptions:IsHidden() then EVENT_MANAGER:RegisterForEvent(CSPS.name, EVENT_GLOBAL_MOUSE_DOWN, CSPS.hideOptions) end
end

function CSPS.hideOptions()
	local control = WINDOW_MANAGER:GetMouseOverControl()
	if control == CSPSWindowOptions or control:GetParent() == CSPSWindowOptions or control == CSPSWindowOptionalButton then return end
	CSPSWindowOptions:SetHidden(true)
	EVENT_MANAGER:UnregisterForEvent(CSPS.name, EVENT_GLOBAL_MOUSE_DOWN)
end

local function autoShowCSPS(oldState, newState)
	if newState == SCENE_SHOWING then 
		if CSPS.useCustomIcons then CSPS.showCpBar() end
		if CSPS.cpAutoOpen then CSPSWindow:SetHidden(false) end
	elseif newState == SCENE_HIDDEN then
		if CSPS.cpAutoOpen then CSPSWindow:SetHidden(true) CSPS.checkCpOnClose() end
	end
end

function CSPS.toggleCPAutoOpen(arg)
	if arg ~= nil then CSPS.cpAutoOpen = arg else CSPS.cpAutoOpen = not CSPS.cpAutoOpen end
	CSPS.savedVariables.settings.cpAutoOpen = CSPS.cpAutoOpen
	CHAMPION_PERKS_SCENE:RegisterCallback("StateChange", autoShowCSPS)
	if CSPS.cpAutoOpen  then 
		CSPSWindowOptionsChkCPAutoOpen:SetTexture(checkedT)
		--CHAMPION_PERKS_SCENE:RegisterCallback("StateChange", autoShowCSPS)
	else
		CSPSWindowOptionsChkCPAutoOpen:SetTexture(uncheckedT)
		-- CHAMPION_PERKS_SCENE:UnregisterCallback("StateChange", autoShowCSPS)
	end
end 

function CSPS.toggleCPCustomIcons(arg)
	if arg ~= nil then CSPS.useCustomIcons = arg else CSPS.useCustomIcons = not CSPS.useCustomIcons end
	CSPS.savedVariables.settings.useCustomIcons = CSPS.useCustomIcons
	if CSPS.useCustomIcons  then 
		CSPSWindowOptionsChkCPCustomIcons:SetTexture(checkedT)
	else
		CSPSWindowOptionsChkCPCustomIcons:SetTexture(uncheckedT)
	end
	for i=1, 3 do
		CSPS.cp2HbIcons(i)
	end
	if CSPS.cpCustomBar then CSPS.showCpBar() end
end 

function CSPS.toggleCPCustomBar(arg)
	if arg ~= nil then 
		if CSPS.cpCustomBar == arg or arg == false then 
			CSPS.cpCustomBar = false
		elseif arg == true then
			CSPS.cpCustomBar = 1
		else
			CSPS.cpCustomBar = arg 
		end
	else 
		if CSPS.cpCustomBar == false then CSPS.cpCustomBar = 1 else CSPS.cpCustomBar = false end
	end
	CSPS.savedVariables.settings.cpCustomBar = CSPS.cpCustomBar
	if CSPS.cpCustomBar then 
		CSPSWindowOptionsChkCPCustomBar:SetTexture(checkedT)
		for i=1, 3 do
			local myBG = CSPSWindowOptions:GetNamedChild(string.format("OptCPBar%sBG", i))
			if myBG then
				if i == CSPS.cpCustomBar then
					myBG:SetCenterColor(unpack( CSPS.colTbl.green), 0.4)
				else
					myBG:SetCenterColor(0.0314, 0.0314, 0.0314)
				end
			end
		end
		CSPS.HbRearrange()
		if CSPS.cpFragment == nil then CSPS.cpFragment = ZO_SimpleSceneFragment:New( CSPSCpHotbar ) end
		SCENE_MANAGER:GetScene('hud'):AddFragment( CSPS.cpFragment  )
		SCENE_MANAGER:GetScene('hudui'):AddFragment( CSPS.cpFragment  )

	else
		CSPSWindowOptionsChkCPCustomBar:SetTexture(uncheckedT)
		for i=1, 3 do
			local myBG = CSPSWindowOptions:GetNamedChild(string.format("OptCPBar%sBG", i))
			if myBG then myBG:SetCenterColor(0.0314, 0.0314, 0.0314) end
		end
		if CSPS.cpFragment ~= nil then
			SCENE_MANAGER:GetScene('hud'):RemoveFragment( CSPS.cpFragment )
			SCENE_MANAGER:GetScene('hudui'):RemoveFragment( CSPS.cpFragment )	
		end
	end
end 

function CSPS.toggleCPReminder(arg)
	if arg ~= nil then CSPS.cpRemindMe = arg else CSPS.cpRemindMe = not CSPS.cpRemindMe end
	CSPS.savedVariables.settings.cpReminder = CSPS.cpRemindMe
	if CSPS.cpRemindMe  then 
		CSPSWindowOptionsChkCPReminder:SetTexture(checkedT)
	else
		CSPSWindowOptionsChkCPReminder:SetTexture(uncheckedT)
	end
end

function CSPS.toggleHotbar(arg)
	if CSPS.showHotbar == false or arg == true then
		CSPS.showHotbar = true
		CSPS.showElement("hotbar", true)
	else
		CSPS.showHotbar = false
		CSPS.showElement("hotbar", false)
	end
	CSPS.savedVariables.settings.showHotbar = CSPS.showHotbar
end

function CSPS.toggleManageBars(arg)
	if CSPSWindowManageBars:IsHidden() or arg == nil or arg == true then
		CSPS.barManagerRefreshGroup()
		CSPSWindowImportExport:SetHidden(true)
		CSPSWindowOptions:SetHidden(true)
		CSPSWindowMain:SetHidden(true)
		CSPSWindowcpHbHkNumberList:SetHidden(true) 
		CSPSWindowManageBars:SetHidden(false)
		CSPS.updateRole()
		CSPS.updatePrCombo(1)
		CSPS.updatePrCombo(2)
		CSPS.updatePrCombo(3)
	else
		CSPSWindowImportExport:SetHidden(true)
		CSPSWindowOptions:SetHidden(true)
		CSPSWindowManageBars:SetHidden(true)
		CSPSWindowMain:SetHidden(false)
	end
end

function CSPS.toggleImportExport(arg)
	if CSPSWindowImportExport:IsHidden() or arg == nil or arg == true then
		CSPSWindowImportExport:SetHidden(false)
		CSPSWindowOptions:SetHidden(true)
		CSPSWindowManageBars:SetHidden(true)
		CSPSWindowMain:SetHidden(true)
	else
		CSPSWindowImportExport:SetHidden(true)
		CSPSWindowOptions:SetHidden(true)
		CSPSWindowManageBars:SetHidden(true)
		CSPSWindowMain:SetHidden(false)
	end
end

local function toggleCheckbox(buttonName, arg)
	local buttonControl = GetControl(CSPSWindow, buttonName)
	if arg == true then
		buttonControl:SetNormalTexture(checkedT)
		buttonControl:SetPressedTexture(checkedT)
		buttonControl:SetMouseOverTexture(checkedT)
	else
		buttonControl:SetNormalTexture(uncheckedT)
		buttonControl:SetPressedTexture(uncheckedT)
		buttonControl:SetMouseOverTexture(uncheckedT)		
	end
end

function CSPS.impExpAddInfo(myAlliance, myRace, myClass)
	CSPSWindowImportExportAllianceValue:SetColor(CSPS.colTbl.white[1],CSPS.colTbl.white[2],CSPS.colTbl.white[3])
	CSPSWindowImportExportRaceValue:SetColor(CSPS.colTbl.white[1],CSPS.colTbl.white[2],CSPS.colTbl.white[3])
	CSPSWindowImportExportClassValue:SetColor(CSPS.colTbl.white[1],CSPS.colTbl.white[2],CSPS.colTbl.white[3])
	if myAlliance == nil then 
		CSPSWindowImportExportAllianceValue:SetText("-")
	else
		CSPSWindowImportExportAllianceValue:SetText(zo_strformat("<<C:1>>", GetAllianceName(myAlliance)))
		if GetUnitAlliance('player') == myAlliance then
			CSPSWindowImportExportAllianceValue:SetColor(CSPS.colTbl.green[1], CSPS.colTbl.green[2], CSPS.colTbl.green[3])
		else
			CSPSWindowImportExportAllianceValue:SetColor(CSPS.colTbl.orange[1],CSPS.colTbl.orange[2],CSPS.colTbl.orange[3])
		end
	end
	if myRace == nil then 
		CSPSWindowImportExportRaceValue:SetText("-")
	else
		CSPSWindowImportExportRaceValue:SetText(zo_strformat("<<C:1>>", GetRaceName(GetUnitGender('player'), myRace)))
		if GetUnitRaceId('player') == myRace then
			CSPSWindowImportExportRaceValue:SetColor(CSPS.colTbl.green[1], CSPS.colTbl.green[2], CSPS.colTbl.green[3])
		else
			CSPSWindowImportExportRaceValue:SetColor(CSPS.colTbl.red[1],CSPS.colTbl.red[2],CSPS.colTbl.red[3])
		end
	end
	if myClass == nil then 
		CSPSWindowImportExportClassValue:SetText("-")
	else
		CSPSWindowImportExportClassValue:SetText(zo_strformat("<<C:1>>", GetClassName(GetUnitGender('player'), myClass)))
		if GetUnitClassId('player') == myClass then 
			CSPSWindowImportExportClassValue:SetColor(CSPS.colTbl.green[1], CSPS.colTbl.green[2], CSPS.colTbl.green[3])
		else
			CSPSWindowImportExportClassValue:SetColor(CSPS.colTbl.orange[1],CSPS.colTbl.orange[2],CSPS.colTbl.orange[3])
		end
	end
end

function CSPS.helpSectionBtn(control)
	for i, v in pairs(helpSections) do
		local myButton = v:GetNamedChild("Btn")	
		local myLabel = v:GetNamedChild("Lbl")		
		if i == control.myIndex then
			myButton:GetNamedChild("BG"):SetCenterColor(CSPS.colTbl.green[1], CSPS.colTbl.green[2], CSPS.colTbl.green[3], 0.4)
			myLabel:SetText(myLabel.auxText)
		else
			myButton:GetNamedChild("BG"):SetCenterColor(0.0314, 0.0314, 0.0314)
			myLabel:SetText("")
		end
	end
end

function CSPS.helpOversectionBtn(control)
	
	for i, v in pairs(helpOversections) do
		if i == control.myIndex then
			v:GetNamedChild("BG"):SetCenterColor(CSPS.colTbl.green[1], CSPS.colTbl.green[2], CSPS.colTbl.green[3], 0.4)
		else
			v:GetNamedChild("BG"):SetCenterColor(0.0314, 0.0314, 0.0314)
		end
	end
	local isInSection = false
	for i, v in pairs(helpSections) do
		local myButton = v:GetNamedChild("Btn")	
		local myLabel = v:GetNamedChild("Lbl")
		if i == control.myIndex then
			isInSection = true
		elseif isInSection and helpOversections[i] ~= nil then
			isInSection = false
		end
		if isInSection then
			myButton:SetHeight(28)
			myButton:SetHidden(false)
		else
			myButton:SetHeight(0)
			myButton:SetHidden(true)
			myButton:GetNamedChild("BG"):SetCenterColor(0.0314, 0.0314, 0.0314)
			myLabel:SetText("")
		end
	end
	
end



function CSPS.fillProfileCombo()
	-- tooltip 
	CSPSWindowBuildProfiles.data = {tooltipText = GS(CSPS_Tooltiptext_ProfileCombo)}
	CSPSWindowBuildProfiles:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
	CSPSWindowBuildProfiles:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)

	CSPS.UpdateProfileCombo()
end

function CSPS.UpdateProfileCombo()
	CSPSWindowBuildProfiles.comboBox = CSPSWindowBuildProfiles.comboBox or ZO_ComboBox_ObjectFromContainer(CSPSWindowBuildProfiles)
	local myComboBox = CSPSWindowBuildProfiles.comboBox	
	myComboBox:ClearItems()
	myComboBox:SetSortsItems(true)
	local choices = {
		[GS(CSPS_Txt_StandardProfile)] = 0,
	}
	
	for i, v in pairs(CSPS.profiles) do
		choices[v.name] = i
	end
	
	local function OnItemSelect(_, choiceText, _)
		if CSPS.unsavedChanges == false then
			CSPS.selectProfile(choices[choiceText])
			CSPS.loadBuild()
		else 
			CSPS.profileToLoad = choices[choiceText]
			local pro1 = CSPS.profiles[CSPS.currentProfile] or {}
			local name1 = pro1.name or GS(CSPS_Txt_StandardProfile)
			local myWarning = (not CSPSWindowCPProfiles:IsHidden()) and GS(CSPS_MSG_NoCPProfiles) or ""
			ZO_Dialogs_ShowDialog(CSPS.name.."_ChangeProfile", nil, {mainTextParams = {name1, choiceText, myWarning}})
		end
		PlaySound(SOUNDS.POSITIVE_CLICK)
	end
	
	for i,j in pairs(choices) do
		myComboBox:AddItem(myComboBox:CreateItemEntry(i, OnItemSelect))

	end
	if CSPS.currentProfile ~= 0 then 
		myComboBox:SetSelectedItem(CSPS.profiles[CSPS.currentProfile].name)
	else
		myComboBox:SetSelectedItem(GS(CSPS_Txt_StandardProfile))
	end
end

function CSPS.toggleImpExpSource(myChoice, fromList)
	CSPS.formatImpExp = myChoice
	CSPS.savedVariables.settings.formatImpExp = myChoice
	if not fromList then 
		for i,v in pairs(impExpChoices) do
			if v == myChoice then CSPSWindowImportExportSrcList.comboBox:SetSelectedItem(i) end
		end
	end
	if myChoice == "sf" then 
		CSPSWindowImportExportBtnImp1:SetHidden(false)
		CSPSWindowImportExportBtnExp1:SetHidden(false)
		CSPSWindowImportExportBtnImp1:SetText(GS(CSPS_ImpEx_BtnImp1))
		CSPSWindowImportExportTextEdit:SetText(GS(CSPS_ImpEx_Standard))
		CSPSWindowImportExportBtnExp1:SetText(GS(CSPS_ImpEx_BtnExp1))
		CSPSWindowImportExportAddInfo:SetHidden(false)
		CSPSWindowImportExportHandleCP:SetHidden(true)
		CSPSWindowImportExportTransfer:SetHidden(true) 
		CSPSWindowImportExportText:SetHidden(false)
	elseif myChoice == "csvCP" then
		CSPSWindowImportExportBtnImp1:SetHidden(false)
		CSPSWindowImportExportBtnExp1:SetHidden(true)
		CSPSWindowImportExportBtnImp1:SetText(GS(CSPS_ImpEx_BtnImp2))
		CSPSWindowImportExportAddInfo:SetHidden(true)
		CSPSWindowImportExportHandleCP:SetHidden(false)
		CSPSWindowImportExportCleanUpText:SetHidden(true)
		CSPSWindowImportExportLblReverse:SetHidden(true)
		CSPSWindowImportExportChkReverse:SetHidden(true)
		CSPSWindowImportExportTransfer:SetHidden(true) 
		CSPSWindowImportExportText:SetHidden(false)
	elseif string.sub(myChoice, 1, 6) == "txtCP2" then
		CSPSWindowImportExportBtnImp1:SetHidden(false)
		CSPSWindowImportExportBtnExp1:SetHidden(false)
		CSPSWindowImportExportBtnExp1:SetText(GS(CSPS_ImpEx_BtnExp2))
		CSPSWindowImportExportBtnImp1:SetText(GS(CSPS_ImpEx_BtnImp2))
		CSPSWindowImportExportTextEdit:SetText(GS(CSPS_ImpEx_CpAsText))
		CSPSWindowImportExportAddInfo:SetHidden(true)
		CSPSWindowImportExportHandleCP:SetHidden(false)
		CSPSWindowImportExportCleanUpText:SetHidden(false)
		CSPSWindowImportExportLblReverse:SetHidden(false)
		CSPSWindowImportExportChkReverse:SetHidden(false)
		CSPSWindowImportExportTransfer:SetHidden(true) 
		CSPSWindowImportExportText:SetHidden(false)
	elseif myChoice == "transfer" then
		CSPSWindowImportExportBtnImp1:SetHidden(true)
		CSPSWindowImportExportBtnExp1:SetHidden(true)
		CSPSWindowImportExportText:SetHidden(true)
		CSPSWindowImportExportAddInfo:SetHidden(true)
		CSPSWindowImportExportHandleCP:SetHidden(true)
		CSPSWindowImportExportTransfer:SetHidden(false) 
		CSPS.updateTransferCombo(1)
	else
		CSPSWindowImportExportBtnImp1:SetHidden(true)
		CSPSWindowImportExportBtnExp1:SetHidden(false)
		CSPSWindowImportExportBtnExp1:SetText(GS(CSPS_ImpEx_BtnExp2))
		CSPSWindowImportExportAddInfo:SetHidden(true)
		CSPSWindowImportExportHandleCP:SetHidden(true)
		CSPSWindowImportExportTransfer:SetHidden(true) 
		CSPSWindowImportExportTextEdit:SetText("")
		CSPSWindowImportExportText:SetHidden(false)
	end
end

function CSPS.fillSrcCombo()
	CSPSWindowImportExportSrcList.comboBox = CSPSWindowImportExportSrcList.comboBox or ZO_ComboBox_ObjectFromContainer(CSPSWindowImportExportSrcList)
	local myComboBox = CSPSWindowImportExportSrcList.comboBox
	
	-- tooltip 
	CSPSWindowImportExportSrcList.data = {tooltipText = GS(CSPS_Tooltiptext_SrcCombo)}
	CSPSWindowImportExportSrcList:SetHandler("OnMouseEnter", ZO_Options_OnMouseEnter)
	CSPSWindowImportExportSrcList:SetHandler("OnMouseExit", ZO_Options_OnMouseExit)
	
	local choices = {
		["eso-skillfactory.com"] = "sf",
		[GS(CSPS_ImpExp_TextCp1)] = "txtCP1",
		[string.format("%s 1/3", GS(CSPS_ImpExp_TextSk))] = "txtSk1",
		[string.format("%s 2/3", GS(CSPS_ImpExp_TextSk))] = "txtSk2",
		[string.format("%s 3/3", GS(CSPS_ImpExp_TextSk))] = "txtSk3",
		[GS(CSPS_ImpExp_TextOd)] = "txtOd",
		[GS(CSPS_ImpExp_Transfer)] = "transfer",
		[GS(CSPS_ImpEx_CsvCP)] = "csvCP",
		[GS(CSPS_ImpEx_TxtCP2_1)] = "txtCP2_1",
		[GS(CSPS_ImpEx_TxtCP2_2)] = "txtCP2_2",
		[GS(CSPS_ImpEx_TxtCP2_3)] = "txtCP2_3",
	}
	
	impExpChoices = choices

	local function OnItemSelect(_, choiceText, choice)
		CSPS.toggleImpExpSource(choices[choiceText], true)
		PlaySound(SOUNDS.POSITIVE_CLICK)
	end

	myComboBox:SetSortsItems(true)
	
	for i,j in pairs(choices) do
		myComboBox:AddItem(myComboBox:CreateItemEntry(i, OnItemSelect))
		if CSPS.formatImpExp == j then
			myComboBox:SetSelectedItem(i)
		end
	end
end

function CSPS.toggleCP(disciplineIndex, arg)
	if disciplineIndex == 0 or disciplineIndex == nil then
		if arg ~= nil then CSPS.applyCP = arg else CSPS.applyCP = not CSPS.applyCP end
		CSPS.applyCPc = {CSPS.applyCP, CSPS.applyCP, CSPS.applyCP}
	else
		CSPS.applyCP = false
		if arg ~= nil then CSPS.applyCPc[disciplineIndex] = arg else CSPS.applyCPc[disciplineIndex] = not CSPS.applyCPc[disciplineIndex] end
	end
	if CSPS.applyCPc[1] or CSPS.applyCPc[2] or CSPS.applyCPc[3] then CSPS.applyCP = true end
	if CSPS.applyCPc[1] then CSPSWindowIncludeCPCheck1:SetTexture(checkedT) else CSPSWindowIncludeCPCheck1:SetTexture(uncheckedT) end
	if CSPS.applyCPc[2] then CSPSWindowIncludeCPCheck2:SetTexture(checkedT) else CSPSWindowIncludeCPCheck2:SetTexture(uncheckedT) end
	if CSPS.applyCPc[3] then CSPSWindowIncludeCPCheck3:SetTexture(checkedT) else CSPSWindowIncludeCPCheck3:SetTexture(uncheckedT) end
	toggleCheckbox("IncludeCPCheck", CSPS.applyCP)
	CSPS.savedVariables.settings.applyCP = CSPS.applyCP
	CSPS.savedVariables.settings.applyCPc = CSPS.applyCPc
	CSPS.myTree:RefreshVisible()
end

function CSPS.toggleATTR(arg)
	if arg ~= nil then CSPS.applyAttr = arg else CSPS.applyAttr = not CSPS.applyAttr end
	toggleCheckbox("IncludeAttrCheck", CSPS.applyAttr)
	CSPS.savedVariables.settings.applyAttr = CSPS.applyAttr
	CSPS.myTree:RefreshVisible()
end

function CSPS.toggleSk(arg)
	if arg ~= nil then CSPS.applySk = arg else CSPS.applySk = not CSPS.applySk end
	toggleCheckbox("IncludeSkCheck", CSPS.applySk)
	CSPS.savedVariables.settings.applySk = CSPS.applySk
	CSPS.myTree:RefreshVisible()
end

function CSPS.toggleCPCapImport(arg)
	if arg ~= nil then CSPS.cpImportCap = arg else CSPS.cpImportCap = not CSPS.cpImportCap end
	toggleCheckbox("ImportExportChkCap", CSPS.cpImportCap)
	CSPS.savedVariables.settings.cpImportCap = CSPS.cpImportCap
end

function CSPS.toggleStrictOrder(arg)
	if arg ~= nil then CSPS.savedVariables.settings.strictOrder = arg else CSPS.savedVariables.settings.strictOrder = not CSPS.savedVariables.settings.strictOrder end
	toggleCheckbox("CPProfilesChkStrictOrder", CSPS.savedVariables.settings.strictOrder)
end



function CSPS.toggleCPReverseImport(arg)
	if arg ~= nil then CSPS.cpImportReverse = arg else CSPS.cpImportReverse = not CSPS.cpImportReverse end
	toggleCheckbox("ImportExportChkReverse", CSPS.cpImportReverse)
	CSPS.savedVariables.settings.cpImportReverse = CSPS.cpImportReverse
end