
local colorRed 			= "|cFF0000" 	-- Red

local function TimeError(reloadTime) 
	d(colorRed.."ChatIt Slash Command Error: Time argument "..tostring(reloadTime).." must be a number")
end

local function TryClearChatWindowBuffers()
	if ChatIt.SavedVariables["RELOAD_CLEAR"] then
		-- Loop through all containers, then each window (tab) in each container
		for k,container in pairs(CHAT_SYSTEM.containers) do
			for k, windowTemplate in pairs(container.windows) do
				windowTemplate.buffer:Clear()
			end
		end
	end
end

-- Note chatTables are "string" categories like "GUILD" for my custom tables
-- we MUST use messageInfo.channel to get the correct category !!!!
-- This ensures we get the correct colors for the chat categories.
local function ReloadChannel(chatTable, passedInTime)
	if ChatIt.SavedVariables["RELOAD_DIVIDER_MSGS"] then
		d(colorRed.."****** ChatIt Reloading: "..chatTable.." Chat ******")
	end
	local reloadTime = tonumber(passedInTime)
	-- something was passed in & it was not a number
	if passedInTime and passedInTime ~= "" and not reloadTime then
		TimeError(reloadTime)
		return
	end
	local timeStamp 	=  GetTimeStamp()
	
	for k, messageInfo in ipairs(ChatIt.SavedVariables["CHAT_BUFFER"][chatTable]) do
		local category = GetChannelCategoryFromChannel(messageInfo.channel)
		local r, g, b = GetChatCategoryColor(category)
		local timeDiff 	= GetDiffBetweenTimeStamps(timeStamp, messageInfo.timeStamp)
		if not reloadTime or timeDiff <= (reloadTime*60) then
			local event = messageInfo.event
			local messageType = messageInfo.messageType
			local fromName = messageInfo.fromName
			local message	= messageInfo.message
			local isCustomerService	= messageInfo.isCustomerService
			CHAT_SYSTEM:OnChatEvent(event, messageType, fromName, message, isCustomerService) 
		end
	end
	if ChatIt.SavedVariables["RELOAD_DIVIDER_MSGS"] then
		d(colorRed.."****** ChatIt Done Reloading: "..chatTable.." Chat ******")
	end
	-- This is not needed anymore, but left as a reminder, when using buffer:AddMessage
	-- For some reason the scrollBar does not update itself and has a
	-- minMax of 0,1....Force it to sync
	--CHAT_SYSTEM.primaryContainer.currentBuffer:AddMessage(messageInfo.message, r, g, b, category)
	--CHAT_SYSTEM.primaryContainer:SyncScrollToBuffer()
end

local function ReloadAllChat(reloadTimeInterval)
	TryClearChatWindowBuffers()
	ReloadChannel("ALL", reloadTimeInterval)
end
local function ReloadWhisper(reloadTimeInterval)
	TryClearChatWindowBuffers()
	ReloadChannel("WHISPER", reloadTimeInterval)
end
local function ReloadParty(reloadTimeInterval)
	TryClearChatWindowBuffers()
	ReloadChannel("PARTY", reloadTimeInterval)
end
local function ReloadGuild(reloadTimeInterval)
	TryClearChatWindowBuffers()
	ReloadChannel("GUILD", reloadTimeInterval)
end
local function ReloadOfficer(reloadTimeInterval)
	TryClearChatWindowBuffers()
	ReloadChannel("OFFICER", reloadTimeInterval)
end

-- Only used for automatic chat reloading during login & /reloadUI
function ChatIt.ReloadChat()
	local reloadTimeInterval = ChatIt.SavedVariables["RELOAD_TIME"]
	TryClearChatWindowBuffers()
	
	if ChatIt.SavedVariables["RELOAD_ALL"] then
		ReloadChannel("ALL", reloadTimeInterval)
	end
	if ChatIt.SavedVariables["RELOAD_WHISPER"] then
		ReloadChannel("WHISPER", reloadTimeInterval)
	end
	if ChatIt.SavedVariables["RELOAD_PARTY"] then
		ReloadChannel("PARTY", reloadTimeInterval)
	end
	if ChatIt.SavedVariables["RELOAD_GUILD"] then
		ReloadChannel("GUILD", reloadTimeInterval)
	end
	if ChatIt.SavedVariables["RELOAD_OFFICER"] then
		ReloadChannel("OFFICER", reloadTimeInterval)
	end
	d(colorRed.."ChatIt: Chat Reloaded|r")
end
local function ReloadClearBuffers()
	ChatIt.SavedVariables["CHAT_BUFFER"] = ChatIt.GetDefaultChatBuffers()
	d(colorRed.."ChatIt: Buffers Cleared|r")
end
SLASH_COMMANDS["/reloadchat"] 		= ReloadAllChat
SLASH_COMMANDS["/reloadwhisper"] 	= ReloadWhisper
SLASH_COMMANDS["/reloadparty"] 		= ReloadParty
SLASH_COMMANDS["/reloadguild"] 		= ReloadGuild
SLASH_COMMANDS["/reloadofficer"] 	= ReloadOfficer
SLASH_COMMANDS["/reloadclear"] 		= ReloadClearBuffers