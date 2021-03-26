if NoFade then return end
NoFade = {
    ["name"] = "NoFade",
    ["version"] = 1.0,
    
    -- for debugging, keep track of the buffers we've touched
    ["touched"] = {},
}
local NoFade = NoFade

local tinsert = table.insert

function NoFade.DisableFading()
    local numWindows = ZO_ChatWindowWindowContainer:GetNumChildren()
    for i=1,numWindows do
        local window = ZO_ChatWindowWindowContainer:GetChild(i)
        local buffer = window["buffer"]
        buffer:SetLineFade(604800, 1) -- 604800 = 60*60*24*7, number of seconds in a week
        NoFade.touched[i] = buffer
    end
end

function NoFade.OnChatMessageChannel(messageType, fromName, text)
    NoFade.DisableFading()
    EVENT_MANAGER:UnregisterForEvent(NoFade.name, EVENT_CHAT_MESSAGE_CHANNEL, NoFade.OnChatMessageChannel)
end

EVENT_MANAGER:RegisterForEvent(NoFade.name, EVENT_CHAT_MESSAGE_CHANNEL, NoFade.OnChatMessageChannel)