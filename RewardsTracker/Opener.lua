local addon = ZO_InitializingObject:Subclass()
rewardsTrackerOpener = addon

local geodQuantity = {
    -- strict
    [134583] = 1,
    [134588] = 5,
    [134590] = 10,
    [134591] = 50,
    [134595] = 50,
    [171531] = 3,
    -- none strict
    [134618] = 25,
    [134622] = 3,
    [134623] = 10,
}

function addon:Initialize(owner)
    self.owner = owner
    self.name = string.format("%sOpener", self.owner.name)

    if self.owner.settings.data.test == false then
        return
    end

    self.geodes = {}
    self.slots = {}
    self.cooldown = 300

    SLASH_COMMANDS["/open-geodes"] = function(cmd)
        if cmd == "" then
            self:openGeodes()
        end
    end
    SLASH_COMMANDS["/open-anniversary-boxes"] = function(cmd)
        if cmd == "" then
            self:openAnniversaryBoxes()
        end
    end
end

function addon:openGeodes()
    self.geodes = {}
    for itemId, quantity in pairs(geodQuantity) do
        table.insert(self.geodes, {
            id = itemId,
            quantity = quantity,
            slots = {}
        })
    end

    table.sort(self.geodes, function(a, b)
        return a.quantity < b.quantity
    end)

    -- ZO_SharedInventoryManager:CreateOrUpdateSlotData
    SHARED_INVENTORY:GenerateFullSlotData(function(itemData)
        itemData.itemId = GetItemId(itemData.bagId, itemData.slotIndex)
        itemData.itemLink = GetItemLink(itemData.bagId, itemData.slotIndex)

        if geodQuantity[itemData.itemId] ~= nil then
            for _, geod in ipairs(self.geodes) do
                if geod.id == itemData.itemId then
                    table.insert(geod.slots, itemData)
                end
            end
        end

        return false
    end, BAG_BACKPACK)

    self:handleGeods()
end

function addon:handleGeods()
    for _, geod in ipairs(self.geodes) do
        for _, slot in ipairs(geod.slots) do
            local remain, duration = GetItemCooldownInfo(slot.bagId, slot.slotIndex)

            zo_callLater(function()
                self:openGeode(geod, slot)
            end, remain)

            return
        end
    end

    self.geodes = {}
end

function addon:openGeode(geod, slot)
    if IsProtectedFunction("UseItem") then
        CallSecureProtected("UseItem", slot.bagId, slot.slotIndex)
    else
        UseItem(slot.bagId, slot.slotIndex)
    end

    zo_callLater(function()
        self:lootGeode(geod, slot)
    end, self.cooldown)
end

function addon:lootGeode(geod, slot)
    local transmuteCrystalsOnAccount = GetCurrencyAmount(CURT_CHAOTIC_CREATIA, CURRENCY_LOCATION_ACCOUNT)
    local transmuteCrystalsOnAccountMax = GetMaxPossibleCurrency(CURT_CHAOTIC_CREATIA, CURRENCY_LOCATION_ACCOUNT)
    local transmuteCrystalsInLoot, _ = GetLootCurrency(CURT_CHAOTIC_CREATIA)

    if (transmuteCrystalsOnAccount + transmuteCrystalsInLoot) < (transmuteCrystalsOnAccountMax - 50) then
        zo_callLater(function()
            LootCurrency(CURT_CHAOTIC_CREATIA)
            -- EndLooting()
            table.remove(geod.slots, 1)
            -- zo_callLater(function()
            self:handleGeods()
            -- end, self.cooldown)
        end, self.cooldown)
    else
        zo_callLater(function()
            EndLooting()
        end, self.cooldown)
        CHAT_ROUTER:AddSystemMessage("too much")

        self.geodes = {}
    end
end

local function GetNumLootCurrencies()
    local num = 0
    for currencyType = CURT_ITERATION_BEGIN, CURT_ITERATION_END do
        if IsCurrencyValid(currencyType) then
            if GetLootCurrency(currencyType) > 0 then
                num = num + 1
            end
        end
    end

    return num
end

function addon:lootHandler(name, actionName, isOwned)
    local numLootItems = GetNumLootItems()
    local numLootCurrencies = GetNumLootCurrencies()

    local transmuteCrystalsOnAccount = GetCurrencyAmount(CURT_CHAOTIC_CREATIA, CURRENCY_LOCATION_ACCOUNT)
    local transmuteCrystalsOnAccountMax = GetMaxPossibleCurrency(CURT_CHAOTIC_CREATIA, CURRENCY_LOCATION_ACCOUNT)
    local transmuteCrystalsInLoot = GetLootCurrency(CURT_CHAOTIC_CREATIA)

    if (transmuteCrystalsOnAccount + transmuteCrystalsInLoot) < (transmuteCrystalsOnAccountMax - 50) then
        LootCurrency(CURT_CHAOTIC_CREATIA)
    end

    if (numLootItems + numLootCurrencies) == 0 then
        d(SCENE_MANAGER:GetScene("loot"):GetState())
        zo_callLater(function()
            --SYSTEMS:GetObject("loot"):Hide()
        end, 1000)
        return true
    end

    for lootIndex = 1, GetNumLootItems() do
        local lootId, itemName, icon, count, quality, value, isQuest, stolen, lootType = GetLootItemInfo(lootIndex)

        --d(string.format("[%d] %s - count: %d - value: %d - lootType: %d", lootId, itemName, count, value, lootType))

        --LootItemById(lootId)
    end

    return false
end

function addon:openAnniversaryBoxes()
    self.slots = {}

    -- ZO_SharedInventoryManager:CreateOrUpdateSlotData
    SHARED_INVENTORY:GenerateFullSlotData(function(itemData)
        itemData.itemId = GetItemId(itemData.bagId, itemData.slotIndex)
        itemData.itemLink = GetItemLink(itemData.bagId, itemData.slotIndex)

        if itemData.itemId == 171779 then
            table.insert(self.slots, itemData)
        end

        return false
    end, BAG_BACKPACK)

    self:handleSlots()
end

function addon:handleSlots()
    for _, slot in ipairs(self.slots) do
        local remain, duration = GetItemCooldownInfo(slot.bagId, slot.slotIndex)

        zo_callLater(function()
            self:openSlot(slot)
        end, remain)

        return
    end

    self.slots = {}
end

function addon:openSlot(slot)
    if IsProtectedFunction("UseItem") then
        CallSecureProtected("UseItem", slot.bagId, slot.slotIndex)
    else
        UseItem(slot.bagId, slot.slotIndex)
    end

    zo_callLater(function()
        self:lootSlot(slot)
    end, self.cooldown)
end

function addon:lootSlot(slot)
    zo_callLater(function()
        LootAll(false)
        table.remove(self.slots, 1)

        self:handleSlots()
    end, self.cooldown)
end
