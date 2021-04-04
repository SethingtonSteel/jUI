local settings = ZO_InitializingObject:Subclass()
rewardsTrackerSettings = settings

function settings:Initialize(owner)
    self.owner = owner
    self.name = string.format("%sSettings", self.owner.name)
    self.data = LibSimpleSavedVars:NewInstallationWide(string.format("%sData", self.name), 1, {
        notifications = {},
        allianceWarUi = true,
        test = false
    })

    if self.data.test == nil then
        self.data.test = false
    end

    if self.data.allianceWarUi == nil then
        self.data.allianceWarUi = true
    end

    self.panel = LibAddonMenu2

    self:initSettingsPanel()
end

function settings:initSettingsPanel()
    local panelData = {
        type = "panel",
        name = self.owner.addonData.title,
        displayName = self.owner.addonData.title,
        author = self.owner.addonData.author,
        version = tostring(self.owner.addonData.version),
        registerForRefresh = true,
        registerForDefaults = true,
    }

    self.panel:RegisterAddonPanel(panelData.name, panelData)

    local optionsTable = {}

    table.insert(optionsTable, {
        type = "checkbox",
        name = "Alliance War campaign UI",
        getFunc = function()
            return self.data.allianceWarUi
        end,
        setFunc = function(value)
            self.data.allianceWarUi = value
        end,
        width = "full",
    })

    table.insert(optionsTable, {
        type = "header",
        name = ZO_HIGHLIGHT_TEXT:Colorize("Notifications"),
        width = "full",
    })

    for _, _accountReward in ipairs(self.owner.accountRewards) do
        if self.data.notifications[_accountReward:GetId()] == nil then
            self.data.notifications[_accountReward:GetId()] = false
        end
        table.insert(optionsTable, {
            type = "checkbox",
            name = _accountReward:GetFormattedName(),
            getFunc = function()
                return self.data.notifications[_accountReward:GetId()]
            end,
            setFunc = function(value)
                self.data.notifications[_accountReward:GetId()] = value
            end,
            width = "full",
        })
    end

    self.panel:RegisterOptionControls(panelData.name, optionsTable)
end
