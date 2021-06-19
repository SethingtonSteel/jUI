local class = ZO_InitializingObject:Subclass()
rewardsTrackerHireling = class

function class:Initialize(owner)
    self.owner = owner
    self.name = string.format("%sHireling", self.owner.name)
    --self.data = LibSimpleSavedVars:NewInstallationWide(string.format("%sData", self.name), 1, {
    --    characters = {},
    --})

    self.hudScene = SCENE_MANAGER:GetScene("hud")
    self.mailInboxScene = SCENE_MANAGER:GetScene("mailInbox")

    EVENT_MANAGER:RegisterForEvent(self.name, EVENT_MAIL_INBOX_UPDATE, function(eventCode)
        d("EVENT_MAIL_INBOX_UPDATE")

        for mailId in ZO_GetNextMailIdIter do
            local mailData = {}
            ZO_MailInboxShared_PopulateMailData(mailData, mailId)
            d(string.format("[%s] %s %s - %s", Id64ToString(mailData.mailId),     mailData.senderDisplayName, mailData.senderCharacterName, mailData.subject))
        end
    end)

    local function hudSceneCallback(oldState, newState)
        if newState == SCENE_SHOWN then
            self.hudScene:UnregisterCallback("StateChange", hudSceneCallback)
            SCENE_MANAGER:Show(self.mailInboxScene:GetName())
            zo_callLater(function()
                d("ttttt")
            end, 20000)
        end
    end

    local function mailInboxSceneCallback(oldState, newState)
        if newState == SCENE_SHOWN then
            self.mailInboxScene:UnregisterCallback("StateChange", mailInboxSceneCallback)
            SCENE_MANAGER:Hide(self.mailInboxScene:GetName())
        end
    end

    self.hudScene:RegisterCallback("StateChange", hudSceneCallback)
    self.mailInboxScene:RegisterCallback("StateChange", mailInboxSceneCallback)
end




