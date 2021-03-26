
ChatIt = {}
local LAM2 = LibStub("LibAddonMenu-2.0")

-------------------------------------------------------------------------------------------------
--  Initialize Variables --
-------------------------------------------------------------------------------------------------
ChatIt.name 		= "ChatIt"
ChatIt.RealVersion	= 4.2
ChatIt.pChatLoaded 	= false

local MAX_BUFFER	= 100
local BG_CHILD_NAME	= "ChatItBg"

----------------------------------------------------------------
--  Default Saved Variable Settings  --
----------------------------------------------------------------
function ChatIt.GetDefaultChatBuffers()
	return {
		["ALL"] = {},
		["WHISPER"] = {},
		["PARTY"] = {},
		["GUILD"] = {},
		["OFFICER"] = {},
	}
end
local ChatItPlayerDefault = {
	["LINE_FADE_DELAY"] 	= 0,	-- In seconds
	["LINE_FADE_DURATION"] 	= 3,	-- In seconds
	["BACKGROUND_FADE"] 	= false,
	["HIDE_EXTRA_BG"] 		= false,
	["HIDE_DEFAULT_BG"]		= true,
	["EXTRA_BG_ALPHA"] 		= 100,
	["SHOW_TIME"] 			= "Off",
	["TIME_STYLE"] 			= "Clock",
	["TIME_PRECISION"] 		= "12 hr",
	
	["RELOAD_CLEAR"] 		= false,
	["RELOAD_ALL"] 			= true,
	["RELOAD_WHISPER"] 		= false,
	["RELOAD_PARTY"] 		= false,
	["RELOAD_GUILD"] 		= false,
	["RELOAD_OFFICER"] 		= false,
	["RELOAD_TIME"]			= 5,
	["RELOAD_TIMESTAMP"] 	= true,
	["RELOAD_DIVIDER_MSGS"] = true,
	
	["CHAT_BUFFER"]			= ChatIt.GetDefaultChatBuffers(),
	
	["MULTIPLE_WINDOWS"]	= false,
}

local chatChannelToTableKey = {
	[CHAT_CHANNEL_WHISPER] 		= "WHISPER",
	[CHAT_CHANNEL_WHISPER_SENT]	= "WHISPER",
	[CHAT_CHANNEL_PARTY] 		= "PARTY",
	[CHAT_CHANNEL_GUILD_1] 		= "GUILD",
	[CHAT_CHANNEL_GUILD_2]		= "GUILD",
	[CHAT_CHANNEL_GUILD_3] 		= "GUILD",
	[CHAT_CHANNEL_GUILD_4] 		= "GUILD",
	[CHAT_CHANNEL_GUILD_5] 		= "GUILD",
	[CHAT_CHANNEL_OFFICER_1] 	= "OFFICER",
	[CHAT_CHANNEL_OFFICER_2] 	= "OFFICER",
	[CHAT_CHANNEL_OFFICER_3] 	= "OFFICER",
	[CHAT_CHANNEL_OFFICER_4] 	= "OFFICER",
	[CHAT_CHANNEL_OFFICER_5] 	= "OFFICER",
}
local function GetChatChannelTable(channelId)
	return chatChannelToTableKey[channelId]
end

------------------------------------------------------------------------------------------
--  Set Functions --
------------------------------------------------------------------------------------------
-- Set the line fade (delay & duration of text fade) --
local function SetTextFade(chatContainer)
	local iLineFadeDelay = ChatIt.SavedVariables["LINE_FADE_DELAY"]
	local iLineFadeDuration = ChatIt.SavedVariables["LINE_FADE_DURATION"]
	
	chatContainer.currentBuffer:SetLineFade(iLineFadeDelay, iLineFadeDuration)
end

-- Change the min alpha to stop the bg from fading, or put it back to normal --
local function SetBgFade(chatContainer)
	local bFadeBg = ChatIt.SavedVariables["BACKGROUND_FADE"]
	
	if ChatIt.SavedVariables["BACKGROUND_FADE"] then
		chatContainer:SetMinAlpha(0)
	else
		chatContainer:SetMinAlpha(1)
	end
end

-- show or hide default background --
local function SetDefaultBgVisibleState(chatContainer)
	local bHideDefaultBg = ChatIt.SavedVariables["HIDE_DEFAULT_BG"] 
	
	chatContainer.backdrop:SetHidden(bHideDefaultBg)
end
	
-- show or hide my custom background --
local function SetChatItBgVisibility(chatContainer)
	local bHideExtraBg = ChatIt.SavedVariables["HIDE_EXTRA_BG"]
	
	chatContainer.ChatItBackground:SetHidden(bHideExtraBg)
end

-- adjust the alpha on my custom background --
local function SetChatItBgAlpha(chatContainer)
	local iBgAlpha = ChatIt.SavedVariables["EXTRA_BG_ALPHA"]

	-- Divided by 100 because I didn't want to use values of 0-1 in the settings menu --
	-- It is values of 1 - 100 (0-1 messes up & looks like its numbers in the thousands in the menu) --
	chatContainer.ChatItBackground:SetAlpha(iBgAlpha/100)
end



------------------------------------------------------------------------------------------
--  Update Functions --
------------------------------------------------------------------------------------------
function ChatIt.UpdateChatPropertiesByContainer(chatContainer)
	SetTextFade(chatContainer)
	SetBgFade(chatContainer)
	SetChatItBgVisibility(chatContainer)
	SetChatItBgAlpha(chatContainer)
	SetDefaultBgVisibleState(chatContainer)
end

local function UpdateAll()
	local tContainers = CHAT_SYSTEM.containers
	
	for k,chatContainer in pairs(tContainers) do
		ChatIt.UpdateChatPropertiesByContainer(chatContainer)
	end
end

function ChatIt.UpdateTextFade()
	local tContainers = CHAT_SYSTEM.containers
	
	for k,chatContainer in pairs(tContainers) do
		SetTextFade(chatContainer)
	end
end

function ChatIt.UpdateBgFade()
	local tContainers = CHAT_SYSTEM.containers
	
	for k,chatContainer in pairs(tContainers) do
		SetBgFade(chatContainer)
	end
end

-- Called from bindings.xml
function ChatIt.ToggleBackground()
	ChatIt.SavedVariables["HIDE_EXTRA_BG"] = not ChatIt.SavedVariables["HIDE_EXTRA_BG"]
	
	ChatIt.UpdateVisibilityStates()
end

-- this one is for the default backdrops
function ChatIt.UpdateDefaultBgVisibilityStates()
	local tContainers = CHAT_SYSTEM.containers
	
	for k,chatContainer in pairs(tContainers) do
		SetDefaultBgVisibleState(chatContainer)
	end
end

function ChatIt.UpdateVisibilityStates()
	local tContainers = CHAT_SYSTEM.containers
	
	for k,chatContainer in pairs(tContainers) do
		SetChatItBgVisibility(chatContainer)
	end
end

function ChatIt.UpdateBgAlpha()
	local tContainers = CHAT_SYSTEM.containers
	
	for k,chatContainer in pairs(tContainers) do
		SetChatItBgAlpha(chatContainer)
	end
end

------------------------------------------------------------------------------------------
--  Create Backgrounds --
-- Called on player activate to recreate backgrounds for window containers that all ready exist --
------------------------------------------------------------------------------------------
local function CreateBackgrounds()
	local tContainers = CHAT_SYSTEM.containers
	
	for k,chatContainer in pairs(tContainers) do
		ChatIt.CreateExtraBg(chatContainer)
	end
end

--  Pass in the parent window to anchor to. Used to create all the backgrounds --
function ChatIt.CreateExtraBg(chatContainer)
	local chatControl = chatContainer.control
	local myBackground = chatContainer.ChatItBackground
	
	if(not myBackground) then
		myBackground = WINDOW_MANAGER:CreateControlFromVirtual(chatControl:GetName()..BG_CHILD_NAME, chatControl, "ZO_DefaultBackdrop")
		chatContainer.ChatItBackground = myBackground
		
		myBackground:SetAnchor(TOPLEFT, chatControl, TOPLEFT, 0, 0)
		myBackground:SetDrawLevel(0)
		myBackground:SetDrawLayer(0)
		myBackground:SetDrawTier(0)
		myBackground:SetAlpha(ChatIt.SavedVariables["EXTRA_BG_ALPHA"])
		myBackground:SetHidden(ChatIt.SavedVariables["HIDE_EXTRA_BG"])
	end
end

---------------------------------------------------------------------------------------
--  Set Up Stuff (on Player Activated..can't do on load, windows aren't ready yet)	 --
--	Destroy any containers left on screen (shouldn't be any) & update all properties --
---------------------------------------------------------------------------------------
local  function SetUpOnActivated()
	--ChatIt.DestroyAllTablessWindows()	-- Just in case something weird happened --
	ChatIt.DestroyExtraContainers()		-- NEW CODE 100012: Just in case something weird happened --
	CreateBackgrounds()			-- Recreate all backgrounds, cannot be done on initialize --
	UpdateAll()							-- Update all properties (bg, fade, ect..) --
	
	-- Now handled individually when each container is created in the containerPool
	--ChatIt.FixAllContainers()			-- Fix all chat container anchors & draw layer/level/tier --
	
	-- We need to wait until playerActivation to initialize the chat handler
	-- Because if pChat is loaded we do not want to do it.
	if not ChatIt.pChatLoaded then
		ChatIt.InitializeTimestamp()   -- SetUp the timestamp --
	end
	ChatIt.ReloadChat()	-- Reload buffered chat
	
	-- We need the OnAddonLoaded event to run until all addons are loaded.
	-- To catch if pChat is loaded or not, so this is unregistered here.
	EVENT_MANAGER:UnregisterForEvent(ChatIt.name, EVENT_ADD_ON_LOADED)
	EVENT_MANAGER:UnregisterForEvent(ChatIt.name, EVENT_PLAYER_ACTIVATED)
end

local function LogTime()
	-- Capture start playing time, for time played clock --
	ChatIt.StartTime = GetTimeStamp()
end

local function OnChatReceived(eventCode, messageType, fromName, message, isCustomerService) 
	local timeStamp =  GetTimeStamp()
	local colorRed 	= "|cFF0000" 	-- Red
	----------------------------------------------
	-- Temporary --
	----------------------------------------------
	--local actualTime = GetFormattedTime()
	local iTimeInSec = GetSecondsSinceMidnight()
	local timeFormatPrecision = (ChatIt.SavedVariables["TIME_PRECISION"] == "12 hr" and TIME_FORMAT_PRECISION_TWELVE_HOUR) or TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR 
	local actualTime = FormatTimeSeconds(iTimeInSec, TIME_FORMAT_STYLE_CLOCK_TIME, timeFormatPrecision, TIME_FORMAT_DIRECTION_NONE)
	----------------------------------------------
	
	local msgTable = {
		["event"] 		= eventCode, -- This is the event code
		["messageType"] = messageType,
		["fromName"] 	= fromName,
		["message"]		= colorRed.."["..actualTime.."]|r "..message,
		["isCustomerService"]	= isCustomerService,
		["timeStamp"]	= timeStamp,
	}
	
	if #ChatIt.SavedVariables["CHAT_BUFFER"]["ALL"] >= MAX_BUFFER then
		table.remove(ChatIt.SavedVariables["CHAT_BUFFER"]["ALL"], 1)
	end
	table.insert(ChatIt.SavedVariables["CHAT_BUFFER"]["ALL"], msgTable)
	
	local chatTableKey = GetChatChannelTable(messageType)
	-- This is for saving copies of special chat channel text like whispers, guild,
	-- officer, & party chat. if there is no chatTableKey it only gets saved under ALL table
	-- The purpose of this is to be able to keep up to MAX_BUFFER of each without
	-- the other channels causing them to get wiped out.
	if not chatTableKey then return end
	
	if #ChatIt.SavedVariables["CHAT_BUFFER"][chatTableKey] >= MAX_BUFFER then
		table.remove(ChatIt.SavedVariables["CHAT_BUFFER"][chatTableKey], 1)
	end
	
	table.insert(ChatIt.SavedVariables["CHAT_BUFFER"][chatTableKey] , msgTable)
end

-----------------------------------------------------------------------------------------
--  OnAddOnLoaded  --
-----------------------------------------------------------------------------------------
local function OnAddOnLoaded(_event, _sAddonName)
	if _sAddonName == ChatIt.name then
		ChatIt:Initialize()
		
		EVENT_MANAGER:RegisterForEvent(ChatIt.name, EVENT_PLAYER_ACTIVATED, SetUpOnActivated)
		EVENT_MANAGER:RegisterForEvent(ChatIt.name, EVENT_CHAT_MESSAGE_CHANNEL, OnChatReceived)
	end
	if _sAddonName == "pChat" then
		ChatIt.pChatLoaded = true
	end
end
-----------------------------------------------------------------------------------------
--  Initialize Function --
-----------------------------------------------------------------------------------------
function ChatIt:Initialize()
	local savedVarVersion 		= 2.5  -- Saved Vars do not touch
	
	self.SavedVariables = ZO_SavedVars:New("ChatItSavedVars", savedVarVersion, nil, ChatItPlayerDefault)
	ZO_CreateStringId("SI_BINDING_NAME_CHATIT_TOGGLE_BACKGROUND", "Toggle Background")
	
	ChatIt.CreateSettingsMenu()
	ChatIt.SetMultipleWindows()
	LogTime()				-- Capture start playing time, for time played clock --
	
	-- Increase maximum chat window size:
	local guiWidth, guiHeight = GuiRoot:GetDimensions()
	-- For some reason when changing from windowed (Fullscreen) to windowed mode the height
	-- dimension does not update on GuiRoot
	CHAT_SYSTEM.maxContainerHeight = guiHeight-100
	CHAT_SYSTEM.maxContainerWidth = guiWidth-100
end

----------------------------------------------------------------------------
--  Register Events --
----------------------------------------------------------------------------
EVENT_MANAGER:RegisterForEvent(ChatIt.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
  

