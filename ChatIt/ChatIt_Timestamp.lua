


local function CreateFromLink(fromName, channelInfo)
    if channelInfo.playerLinkable then
       return ZO_LinkHandler_CreatePlayerLink(fromName)
    end
    return fromName
end

local function CreateChannelLink(channelInfo, overrideName)
    if channelInfo.channelLinkable then
        local channelName = overrideName or GetChannelName(channelInfo.id)
        return ZO_LinkHandler_CreateChannelLink(channelName)
    end
end

--[[
GetDateStringFromTimestamp(integer timestamp)
	Returns: string dateString 
GetTimeString()
	Returns: string currentTimeString 
GetDate()
	Returns: integer currentTime 
GetTimeStamp()
	Returns: id64 timestamp 
GetDiffBetweenTimeStamps(id64 laterTime, id64 earlierTime)
	Returns: number difference in seconds
GetFormattedTime()
	Returns: integer formattedTime 
	
FormatTimeSeconds(number timeValueInSeconds, TimeFormatStyleCode formatType, TimeFormatPrecisionCode precisionType, TimeFormatDirectionCode direction)
	Returns: string formattedTimeString, number nextUpdateTimeInSec 
	
FormatTimeMilliseconds(integer timeValueInMilliseconds, TimeFormatStyleCode formatType, TimeFormatPrecisionCode precisionType, TimeFormatDirectionCode direction)
	Returns: string formattedTimeString, integer nextUpdateTimeInMilliseconds   
	
GetSecondsPlayed()
	Returns: integer secondsPlayed 
time = GetSecondsSinceMidnight()
style = TIME_FORMAT_STYLE_CLOCK_TIME 
prec = TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR 
dir = TIME_FORMAT_DIRECTION_NONE 
i = FormatTimeSeconds(time,style,prec,dir)
--]]
local function GetStyle()
	local iStyle =  TIME_FORMAT_STYLE_CLOCK_TIME 
	local sStyle = ChatIt.SavedVariables["TIME_STYLE"]
	
		if sStyle == "Clock" 					then iStyle = TIME_FORMAT_STYLE_CLOCK_TIME
	elseif sStyle == "Colons" 					then iStyle = TIME_FORMAT_STYLE_COLONS
	elseif sStyle == "Descriptive" 				then iStyle = TIME_FORMAT_STYLE_DESCRIPTIVE
	elseif sStyle == "Descriptive Short" 		then iStyle = TIME_FORMAT_STYLE_DESCRIPTIVE_SHORT_SHOW_ZERO_SECS
	elseif sStyle == "Largest Unit" 			then iStyle = TIME_FORMAT_STYLE_SHOW_LARGEST_UNIT
	elseif sStyle == "Largest Unit Descriptive" then iStyle = TIME_FORMAT_STYLE_SHOW_LARGEST_UNIT_DESCRIPTIVE
	end
	return iStyle
end

local function GetPrecision()
	local iPrecision = TIME_FORMAT_PRECISION_TWELVE_HOUR
	local sPrecision = ChatIt.SavedVariables["TIME_PRECISION"]
	
	if 	   sPrecision == "Seconds" 			then iPrecision = TIME_FORMAT_PRECISION_SECONDS
	elseif sPrecision == "12 hr" 			then iPrecision = TIME_FORMAT_PRECISION_TWELVE_HOUR
	elseif sPrecision == "24 hr" 			then iPrecision = TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR
	end
	return iPrecision
end
local function GetFormattedTimeFromSeconds()
	local iTimeInSec = GetSecondsSinceMidnight()
	local sTime = FormatTimeSeconds(iTimeInSec, GetStyle(), GetPrecision(), TIME_FORMAT_DIRECTION_NONE)
	return ("["..sTime.."] ")
end

local function GetTimePlayed()
	local id64TimeNow = GetTimeStamp()
	local id64TimeStart = ChatIt.StartTime
	local iTimeDiff = GetDiffBetweenTimeStamps(id64TimeNow, id64TimeStart)
	local sFormattedTime = FormatTimeSeconds(iTimeDiff, GetStyle(), GetPrecision(), TIME_FORMAT_DIRECTION_NONE)
	return ("["..sFormattedTime.."] ")
end

local function GetTimePrefix()
	local sTimeOption = ChatIt.SavedVariables["SHOW_TIME"]
	local sTime = ""
	
	if 	sTimeOption == "Clock" then
		sTime = GetFormattedTimeFromSeconds()
	elseif sTimeOption == "Time Played" then 
		sTime = GetTimePlayed()
	end
	return sTime
end

local function GetCustomerServiceIcon(isCustomerServiceAccount)
    if(isCustomerServiceAccount) then
        return "|t16:16:EsoUI/Art/ChatWindow/csIcon.dds|t"
    end

    return ""
end 
    
function ChatIt.ChatHandler(_MessageType, _FromName, _Text, isFromCustomerService, bufferingMsg)
	local tChannelInfo 	= ZO_ChatSystem_GetChannelInfo()
	local tMessageInfo 	= tChannelInfo[_MessageType]
	local sTime 		= GetTimePrefix()
	
	if bufferingMsg and ChatIt.SavedVariables["RELOAD_TIMESTAMP"] then
		sTime = GetFormattedTimeFromSeconds()
	end
	if tMessageInfo and tMessageInfo.format then
		local lChannelLink = CreateChannelLink(tMessageInfo)
		local lFromLink = CreateFromLink(_FromName, tMessageInfo)
		
		if lChannelLink then
			return sTime..zo_strformat(tMessageInfo.format, lChannelLink, lFromLink, _Text), tMessageInfo.saveTarget
		end
		return sTime..zo_strformat(tMessageInfo.format, lFromLink, _Text, GetCustomerServiceIcon(isFromCustomerService)), tMessageInfo.saveTarget
	end
end

function ChatIt.InitializeTimestamp()
	if not ChatIt.pChatLoaded then
		ZO_ChatSystem_AddEventHandler(EVENT_CHAT_MESSAGE_CHANNEL, ChatIt.ChatHandler)
	end
end
