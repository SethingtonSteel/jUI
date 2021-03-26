----------------------------------------------
--          MyXPView -- XP Display          --
--        Edda's Comprehensive XP UI        --
----------------------------------------------

-- Main objects
local MXPV = {}
MXPV.Meter = {}

-- Init main vars
local ADDON_NAME = "MXPV"
local ADDON_VERSION = 2.5

MXPV.command = "/mxpv"
MXPV.varVersion = 1
MXPV.XPBarWidth = 342
MXPV.CombatState = false
MXPV.OutOfCombatTime = 0
MXPV.StartOfCombatTime = 0

-- Init XP vars
MXPV.fadeXPCountdown = false
MXPV.lastXPGainTime = 0
MXPV.XPGainPool = 0
MXPV.XPGainPack = 0

-- Init RP vars
MXPV.fadeRPCountdown = false
MXPV.lastRPGainTime = 0
MXPV.RPGainPool = 0
MXPV.RPGainPack = 0

-- Init meter vars
MXPV.Meter.InitTime = GetGameTimeMilliseconds()
MXPV.Meter.TimeElapsed = 0
MXPV.Meter.XPGains = 0
MXPV.Meter.RPGains = 0
MXPV.Meter.XPTimeLeft = 0
MXPV.Meter.RPTimeLeft = 0
MXPV.Meter.CurrentXPGain = 0
MXPV.Meter.CurrentRPGain = 0
MXPV.Meter.BufferSize = 10
MXPV.Meter.Buffer = {}
MXPV.Meter.RPBuffer = {}
MXPV.Meter.XPTimeLeft = 0
MXPV.Meter.MobsLeft = 0
MXPV.Meter.KillsLeft = 0
MXPV.Meter.XPPerHour = 0
MXPV.Meter.RPPerHour = 0
MXPV.Meter.PercentXPPerHour = 0
MXPV.Meter.PercentRPPerHour = 0
MXPV.Meter.XPHoursLeft = 0
MXPV.Meter.XPMinutesLeft = 0
MXPV.Meter.XPSecondsLeft = 0
MXPV.Meter.Paused = false

-- Options
local defaults = {
	ConsoleMode = false,
	UIMode = true,
	XPBarMode = true,
	MeterMode = true,
	CombatOnly = false,
	StartPaused = false,
	CombatUnpauses = false,
	XPMode = true,
	RPMode = false,
	AutoSwitch = true,
	fadeXPGainDelay = 10000,
	RateFactor = 1,
	OffsetX = -50,
	OffsetY = -40,
	point = 12,
	relativePoint = 12,
	ScaleFactor = 1,
}

local db

-- Called by OnUpdate should not be done
local function EyeOfMoscow()

	-- Update meter
	if not db.CombatOnly or db.CombatOnly and not MXPV.Meter.Paused then
		MXPV.Meter.Update()
	end
	
	local now = GetGameTimeMilliseconds()

	-- Pool Management
	if (now - MXPV.lastXPGainTime) > db.fadeXPGainDelay and (now - MXPV.lastRPGainTime) > db.fadeXPGainDelay and (MXPV.fadeXPCountdown or MXPV.fadeRPCountdown) then
		MXPV.XPGainPool = 0
		MXPV.RPGainPool = 0
		MXPV.XPGainPack = 0
		MXPV.RPGainPack = 0
		MXPV.BeforeGainXP = MXPV.GetUnit("XP")
		MXPV.BeforeGainRP = MXPV.GetUnit("RP")
		MXPV.BeforeGainLevel = MXPV.GetUnit("Level")
		MXPV.BeforeGainRank = MXPV.GetUnit("Rank")
		MXPV.BeforeGainMaxXP = MXPV.GetUnit("XPMax")
		MXPV.BeforeGainMaxRP = MXPV.GetUnit("RPMax")
		MXPV.fadeXPCountdown = false
		MXPV_XP_PROGRESSBAR_GAIN:SetHidden(true)
		MXPV.UpdateProgressbar(false)
	end

end

-- Get user data function
function MXPV.GetUnit(arg)
	if arg == "XP" then
		if MXPV.IsChampion then
			return GetPlayerChampionXP()
		else
			return GetUnitXP("player")
		end
	elseif arg == "Level" then
		if MXPV.IsChampion then
			return GetPlayerChampionPointsEarned()
		else
			return GetUnitLevel("player")
		end
	elseif arg == "XPMax" then
		if MXPV.IsChampion then
			return GetNumChampionXPInChampionPoint(GetPlayerChampionPointsEarned())
		else
			return GetUnitXPMax("player")
		end
	elseif arg == "RP" then
		return GetUnitAvARankPoints("player")
	elseif arg == "RPMax" then
		return GetNumPointsNeededForAvARank(MXPV.CurrentRank + 1)
	elseif arg == "Rank" then
		return GetUnitAvARank("player")
	end
end

-- Experience Update
function MXPV.ExperienceUpdate(_, unitTag, currentExp, maxExp, reason)
	if AreUnitsEqual(unitTag, "player") then
		MXPV.Update(unitTag, currentExp, maxExp, reason)
	end
end

-- Alliance points update
function MXPV.RankPointsUpdate(event, unitTag, rankPoints, difference)
	if AreUnitsEqual(unitTag, "player") then
		if (difference > 0) then MXPV.RPUpdate (rankPoints, difference) end
	end
end

function MXPV.LayerPopped(_, layerIndex)
	if (layerIndex == 2 or layerIndex == 12) and db.UIMode then
		MXPVUI:SetHidden(false)
		if MXPV.Meter.Paused then MXPV.Meter.Update() end -- Visual glitch when pausing the meter while interface is open i.e. from the option menu! -> always refresh meter ?
	end
end

function MXPV.LayerPushed(event, layerIndex, activeLayerIndex)
	if (layerIndex == 2 or layerIndex == 12) and db.UIMode then MXPVUI:SetHidden(true) end
end

-- log
function MXPV.Log(text)
	MXPV_UI_DEBUG_LABEL:SetText(text .. "\n.\n" .. MXPV_UI_DEBUG_LABEL:GetText())
end

--Should auto switch?
-- Unit types:
-- 0 = UNIT_TYPE_INVALID
-- 1 = UNIT_TYPE_PLAYER
-- 2 = UNIT_TYPE_MONSTER
-- 3 = UNIT_TYPE_INTERACTOBJ
-- 4 = UNIT_TYPE_INTERACTFIXTURE
-- 5 = UNIT_TYPE_ANCHOR
-- 6 = UNIT_TYPE_SIEGEWEAPON
-- 7 = UNIT_TYPE_SIMPLEINTERACTOBJ
-- 8 = UNIT_TYPE_SIMPLEINTERACTFIXTURE

-- Tracking switch
local function SwitchTracking(arg, silent)

	-- Set values
	if arg == 'XP tracking' then db.XPMode = true end
	if arg == 'XP tracking' then db.RPMode = false end
	if arg == 'RP tracking' then db.XPMode = false end
	if arg == 'RP tracking' then db.RPMode = true end

	-- Switch values
	if arg == nil then db.XPMode = not db.XPMode end
	if arg == nil then db.RPMode = not db.RPMode end

	-- Update meter if paused
	if MXPV.Meter.Paused then
		MXPV.Meter.Update()
	end

	-- Update progress bar
	if MXPV.fadeXPCountdown or MXPV.fadeRPCountdown then MXPV.UpdateProgressbar(true)
	else MXPV.UpdateProgressbar(false) end

	-- Notify
	if not silent and db.XPMode then d("MyXpView v" .. ADDON_VERSION .. " : now tracking XP") end
	if not silent and db.RPMode then d("MyXpView v" .. ADDON_VERSION .. " : now tracking RP") end

end

function MXPV.AutoSwitchMode()

	if db.AutoSwitch then
		local unitType = GetUnitType("reticleover")
		if unitType == UNIT_TYPE_INVALID then return end

		if MXPV.CombatState and GetUnitReaction("reticleover") == UNIT_REACTION_HOSTILE then
			if (db.XPMode and unitType == UNIT_TYPE_PLAYER) or (db.RPMode and unitType == UNIT_TYPE_MONSTER) then SwitchTracking(nil, true) end
		end
	end

end

-- Combat state
function MXPV.GetSetCombatState (event, inCombat)

	-- Save combat state
	MXPV.CombatState = inCombat

	-- Register combat state tymes
	if inCombat then
		MXPV.StartOfCombatTime = GetGameTimeMilliseconds()
	else
		 MXPV.OutOfCombatTime = GetGameTimeMilliseconds()
	end

	-- Pause / start meter
	if db.CombatOnly then
		if inCombat then
			MXPV.Meter.Start()
		else
			MXPV.Meter.Pause()
		end
	elseif db.CombatUnpauses and MXPV.Meter.Paused and inCombat then
		MXPV.Meter.Start()
	end

	-- Handle auto-switch
	MXPV.AutoSwitchMode()

end

-- Reticle changed event
function MXPV.ReticleChangedEvent ()

	MXPV.AutoSwitchMode()

end

local function InsertIntoBuffer(item)
	table.insert(MXPV.Meter.Buffer, 1, item)
	while #MXPV.Meter.Buffer > MXPV.Meter.BufferSize do
		table.remove(MXPV.Meter.Buffer, #MXPV.Meter.Buffer)
	end
	return lolmode or item
end

-- Main
function MXPV.Update (unitTag, currentExp, maxExp, reason)

	-- Check if we gained XP
	if MXPV.GetUnit("XP") - MXPV.CurrentXP > 0 or MXPV.GetUnit("Level") > MXPV.CurrentLevel then

		-- Calculate XP Gain
		local XPGain = -1
		if MXPV.GetUnit("XP") - MXPV.CurrentXP > 0 then XPGain = MXPV.GetUnit("XP") - MXPV.CurrentXP end
		if MXPV.GetUnit("Level") > MXPV.CurrentLevel then XPGain = MXPV.CurrentMaxXP - MXPV.CurrentXP + MXPV.GetUnit("XP") end

		-- Update our vars
		MXPV.CurrentXP = MXPV.GetUnit("XP")
		MXPV.CurrentLevel = MXPV.GetUnit("Level")
		MXPV.CurrentMaxXP = MXPV.GetUnit("XPMax")
		MXPV.lastXPGainTime = GetGameTimeMilliseconds()
		MXPV.fadeXPCountdown = true

		-- Add XP to pool & update pack
		MXPV.XPGainPool = MXPV.XPGainPool + XPGain
		MXPV.XPGainPack = MXPV.XPGainPack + 1

		-- Display XP gain
		if db.fadeXPGainDelay ~= 0 then MXPV.UpdateProgressbar(true)
		else MXPV.UpdateProgressbar(false) end

		-- Update Meter
		if reason == 0 or reason == 9 or reason == 24 then MXPV.Meter.CurrentXPGain = InsertIntoBuffer(XPGain) end
		MXPV.Meter.XPGains = MXPV.Meter.XPGains + XPGain
		if MXPV.Meter.Paused then MXPV.Meter.Update() end

		-- Console mode
		if db.ConsoleMode then d(string.format("You gained %d XP", XPGain)) end
	end

end

local function InsertIntoRPBuffer(item)
	table.insert(MXPV.Meter.RPBuffer, 1, item)
	while #MXPV.Meter.RPBuffer > MXPV.Meter.BufferSize do
		table.remove(MXPV.Meter.RPBuffer, #MXPV.Meter.RPBuffer)
	end
	return lolmode or item
end

-- RP
function MXPV.RPUpdate()

	-- Check if we gained RP
	if MXPV.GetUnit("RP") - MXPV.CurrentRP > 0 or MXPV.GetUnit("Rank") > MXPV.CurrentRank then

		-- Calculate RP Gain
		local RPGain = -1
		if MXPV.GetUnit("RP") - MXPV.CurrentRP > 0 then
			RPGain = MXPV.GetUnit("RP") - MXPV.CurrentRP
		end
		
		-- Update our vars
		MXPV.IsChampion = GetUnitLevel("player") == GetMaxLevel()
		MXPV.CurrentRP = MXPV.GetUnit("RP")
		MXPV.CurrentRank = MXPV.GetUnit("Rank")
		MXPV.CurrentMaxRP = MXPV.GetUnit("RPMax")
		MXPV.lastRPGainTime = GetGameTimeMilliseconds()
		MXPV.fadeRPCountdown = true

		-- Add RP to pool & update pack
		MXPV.RPGainPool = MXPV.RPGainPool + RPGain
		MXPV.RPGainPack = MXPV.RPGainPack + 1

		-- Display RP gain
		if db.fadeXPGainDelay ~= 0 then
			MXPV.UpdateProgressbar(true)
		else
			MXPV.UpdateProgressbar(false)
		end

		-- Update Meter
		MXPV.Meter.CurrentRPGain = InsertIntoRPBuffer(RPGain)
		MXPV.Meter.RPGains = MXPV.Meter.RPGains + RPGain
		if MXPV.Meter.Paused then MXPV.Meter.Update() end

		-- Console mode
		if db.ConsoleMode then d(string.format("You gained %d RP", RPGain)) end
	end

end

-- Updating progress bar visuals
function MXPV.UpdateProgressbar(gainMode)

	-- Progress %
	local progressPercent
	if db.XPMode then progressPercent = MXPV.CurrentXP / MXPV.CurrentMaxXP * 100 end
	if db.RPMode and MXPV.CurrentRank == 0 then progressPercent = MXPV.CurrentRP / MXPV.CurrentMaxRP * 100 end
	if db.RPMode and MXPV.CurrentRank > 0 then progressPercent = (MXPV.CurrentRP - GetNumPointsNeededForAvARank(MXPV.CurrentRank - 1)) / (MXPV.CurrentMaxRP - GetNumPointsNeededForAvARank(MXPV.CurrentRank - 1)) * 100 end

	if gainMode then

		-- Progress % before gain
		local progressPercentBefore
		if db.XPMode then progressPercentBefore = MXPV.BeforeGainXP / MXPV.BeforeGainMaxXP * 100 end
		if db.RPMode and MXPV.CurrentRank == 0 then progressPercentBefore = MXPV.BeforeGainRP / MXPV.BeforeGainMaxRP * 100 end
		if db.RPMode and MXPV.CurrentRank > 0 then progressPercentBefore = (MXPV.BeforeGainRP - GetNumPointsNeededForAvARank(MXPV.BeforeGainRank)) / (MXPV.BeforeGainMaxRP - GetNumPointsNeededForAvARank(MXPV.BeforeGainRank)) * 100 end

		-- Display gain bar
		local GainPercent
		if db.XPMode then GainPercent = MXPV.XPGainPool / MXPV.BeforeGainMaxXP * 100 end
		if db.RPMode and MXPV.CurrentRank == 0 then GainPercent = MXPV.RPGainPool / MXPV.BeforeGainMaxRP * 100 end
		if db.RPMode and MXPV.CurrentRank > 0 then GainPercent = MXPV.RPGainPool / (MXPV.BeforeGainMaxRP - GetNumPointsNeededForAvARank(MXPV.BeforeGainRank)) * 100 end

		if progressPercentBefore + GainPercent > 100 then GainPercent = 100 - progressPercentBefore end
		local offsetX = MXPV.XPBarWidth * progressPercentBefore / 100 + 4

		MXPV_XP_PROGRESSBAR_GAIN:SetAnchor (BOTTOMLEFT, parent, BOTTOMLEFT, offsetX, -4)
		MXPV_XP_PROGRESSBAR_GAIN:SetValue (GainPercent)
		MXPV_XP_PROGRESSBAR_GAIN:SetHidden (false)

		-- Display gain text
		local XPGainText, RPGainText, Separator

		if MXPV.XPGainPack > 0 and MXPV.RPGainPack > 0 then Separator = " & " else Separator = "" end

		if MXPV.XPGainPack == 0 then XPGainText = "" end
		if MXPV.XPGainPack == 1 then XPGainText = string.format("%d XP", MXPV.XPGainPool) end
		if MXPV.XPGainPack > 1 then XPGainText = string.format("%d XP (+%d)", MXPV.XPGainPool, MXPV.XPGainPack - 1) end

		if MXPV.RPGainPack == 0 then RPGainText = "" end
		if MXPV.RPGainPack == 1 then RPGainText = string.format("%d RP", MXPV.RPGainPool) end
		if MXPV.RPGainPack > 1 then RPGainText = string.format("%d RP (+%d)", MXPV.RPGainPool, MXPV.RPGainPack - 1) end

		MXPV_XP_LABEL:SetText("You gained " .. XPGainText .. Separator .. RPGainText)

		--if MXPV.XPGainPack == 1 then MXPV_XP_LABEL:SetText (string.format("You gained %d XP", MXPV.XPGainPool)) end
		--if MXPV.XPGainPack > 1 then MXPV_XP_LABEL:SetText (string.format("You gained %d XP (+%d)", MXPV.XPGainPool, MXPV.XPGainPack - 1)) end

	else
		-- Set XP bar progress
		MXPV_XP_PROGRESSBAR:SetValue(progressPercent)

		-- Set XP bar text
		local LvlOrVrOrCP
		if MXPV.IsChampion then LvlOrVrOrCP = "CP"
		else LvlOrVrOrCP = "Lvl" end
		if db.XPMode then MXPV_XP_LABEL:SetText (LvlOrVrOrCP .. " " .. MXPV.CurrentLevel .. "  " .. string.format("%d / %d XP  [%d", MXPV.CurrentXP, MXPV.CurrentMaxXP, progressPercent) .. "%]") end
		if db.RPMode then MXPV_XP_LABEL:SetText ("Rank " .. MXPV.CurrentRank .. "  " .. string.format("%d / %d RP  [%d", MXPV.CurrentRP, MXPV.CurrentMaxRP, progressPercent) .. "%]") end
	end

end

-- Pausing Meter
function MXPV.Meter.Pause()
	MXPV.Meter.TimeElapsed = MXPV.Meter.TimeElapsed + GetGameTimeMilliseconds() - MXPV.Meter.InitTime
	MXPV.Log("MXPV.Meter.TimeElapsed = " .. MXPV.Meter.TimeElapsed)
	MXPV.Meter.Paused = true
end

-- Starting Meter
function MXPV.Meter.Start()
	MXPV.Meter.InitTime = GetGameTimeMilliseconds()
	MXPV.Log("MXPV.Meter.InitTime = " .. MXPV.Meter.InitTime)
	MXPV.Meter.Paused = false
end

local function GetRPBufferAvg()
	local sum = 0
	for index, item in ipairs(MXPV.Meter.RPBuffer) do
		sum = sum + item
	end

	return sum / #MXPV.Meter.RPBuffer
end

local function GetBufferAvg()
	local sum = 0
	for index, item in ipairs(MXPV.Meter.Buffer) do
		sum = sum + item
	end

	return sum / #MXPV.Meter.Buffer
end

-- Updating meter
function MXPV.Meter.Update()

	-- Meter vars
	local RateFactor, TimeElapsed
	local XPLeft = MXPV.CurrentMaxXP - MXPV.CurrentXP
	local RPLeft = MXPV.CurrentMaxRP - MXPV.CurrentRP

	-- Rate factor
	if db.CombatOnly then RateFactor = db.RateFactor else RateFactor = 1 end

	-- Time elapsed
	if not MXPV.Meter.Paused then TimeElapsed = (MXPV.Meter.TimeElapsed + GetGameTimeMilliseconds() - MXPV.Meter.InitTime) / 1000
	else TimeElapsed = MXPV.Meter.TimeElapsed / 1000 end

	local HoursElapsed = math.floor(TimeElapsed / 3600)
	local MinutesElapsed = math.floor((TimeElapsed - HoursElapsed * 3600) / 60)
	local SecondsElapsed = TimeElapsed % 60

	-- XP rates
	if TimeElapsed == 0 then MXPV.Meter.XPPerHour = 0 else MXPV.Meter.XPPerHour = math.floor(RateFactor * (3600 / TimeElapsed * MXPV.Meter.XPGains)) end
	MXPV.Meter.PercentXPPerHour = math.floor(MXPV.Meter.XPPerHour / MXPV.CurrentMaxXP * 100)

	-- RP rates
	if TimeElapsed == 0 then MXPV.Meter.RPPerHour = 0 else MXPV.Meter.RPPerHour = math.floor(RateFactor * (3600 / TimeElapsed * MXPV.Meter.RPGains)) end
	MXPV.Meter.PercentRPPerHour = math.floor(MXPV.Meter.RPPerHour / (MXPV.CurrentMaxRP - GetNumPointsNeededForAvARank(MXPV.BeforeGainRank)) * 100)

	-- XP time left
	if MXPV.Meter.XPGains == 0 then MXPV.Meter.XPTimeLeft = 0 else MXPV.Meter.XPTimeLeft = TimeElapsed / MXPV.Meter.XPGains * XPLeft / RateFactor end

	MXPV.Meter.XPHoursLeft = math.floor(MXPV.Meter.XPTimeLeft / 3600)
	MXPV.Meter.XPMinutesLeft = math.floor((MXPV.Meter.XPTimeLeft - 3600 * MXPV.Meter.XPHoursLeft) / 60)
	MXPV.Meter.XPSecondsLeft = MXPV.Meter.XPTimeLeft % 60

	-- RP time left
	if MXPV.Meter.RPGains == 0 then MXPV.Meter.RPTimeLeft = 0 else MXPV.Meter.RPTimeLeft = TimeElapsed / MXPV.Meter.RPGains * RPLeft / RateFactor end

	MXPV.Meter.RPHoursLeft = math.floor(MXPV.Meter.RPTimeLeft / 3600)
	MXPV.Meter.RPMinutesLeft = math.floor((MXPV.Meter.RPTimeLeft - 3600 * MXPV.Meter.RPHoursLeft) / 60)
	MXPV.Meter.RPSecondsLeft = MXPV.Meter.RPTimeLeft % 60

	-- Mobs left
	if MXPV.Meter.CurrentXPGain == 0 then MXPV.Meter.MobsLeft = 0 else MXPV.Meter.MobsLeft =  math.floor(XPLeft / GetBufferAvg()) end

	-- Kills left
	if MXPV.Meter.CurrentRPGain == 0 then MXPV.Meter.KillsLeft = 0 else MXPV.Meter.KillsLeft =  math.floor(RPLeft / GetRPBufferAvg()) end

	-- Update UI
	local MeterText

	if db.XPMode then MeterText = ' Time : ' .. string.format("%02d", HoursElapsed) .. ':' .. string.format("%02d", MinutesElapsed) .. ':' .. string.format("%02d", SecondsElapsed) .. ' - |cffff00' .. MXPV.Meter.XPGains .. ' XP|r gained\n' end
	if db.RPMode then MeterText = ' Time : ' .. string.format("%02d", HoursElapsed) .. ':' .. string.format("%02d", MinutesElapsed) .. ':' .. string.format("%02d", SecondsElapsed) .. ' - |cffff00' .. MXPV.Meter.RPGains .. ' RP|r gained\n' end

	if db.XPMode then MeterText = MeterText .. 'XP rate : |cffff00' .. MXPV.Meter.XPPerHour .. ' XP|r/hour (|cffff00' .. MXPV.Meter.PercentXPPerHour .. '%|r) = |cff1111' .. MXPV.Meter.MobsLeft .. ' mobs|r left\n' end
	if db.RPMode then MeterText = MeterText .. 'RP rate : |cffff00' .. MXPV.Meter.RPPerHour .. ' RP|r/hour (|cffff00' .. MXPV.Meter.PercentRPPerHour .. '%|r) = |cff1111' .. MXPV.Meter.KillsLeft .. ' kills|r left\n' end

	if db.XPMode then MeterText = MeterText .. 'Next level in approx. : |c9999ff' .. string.format("%02d", MXPV.Meter.XPHoursLeft) .. ':' .. string.format("%02d", MXPV.Meter.XPMinutesLeft) .. ':' .. string.format("%02d", MXPV.Meter.XPSecondsLeft) .. '|r' end
	if db.RPMode then MeterText = MeterText .. 'Next rank in approx. : |c9999ff' .. string.format("%02d", MXPV.Meter.RPHoursLeft) .. ':' .. string.format("%02d", MXPV.Meter.RPMinutesLeft) .. ':' .. string.format("%02d", MXPV.Meter.RPSecondsLeft) .. '|r' end

	MXPV_METER_LABEL:SetText(MeterText)

end

-- Reset meter
local function Reset()
	MXPV.Meter.InitTime = GetGameTimeMilliseconds()
	MXPV.Meter.TimeElapsed = 0
	MXPV.Meter.XPTimeLeft = 0
	MXPV.Meter.XPGains = 0
	MXPV.Meter.CurrentXPGain = 0
	MXPV.Meter.Buffer = {}
	MXPV.Meter.MobsLeft = 0
	MXPV.Meter.XPPerHour = 0
	MXPV.Meter.XPHoursLeft = 0
	MXPV.Meter.XPMinutesLeft = 0
	MXPV.Meter.XPSecondsLeft = 0
	if db.StartPaused then MXPV.Meter.Pause() end
	MXPV.Meter.Update()

	-- Notify
	d("MyXpView v" .. ADDON_VERSION .. " : xp meter reseted")

end

-- Setting XP gain UI message fade delay
local function SetFadeXPGainDelay(fadevalue, silent)

	-- Set fade value
	db.fadeXPGainDelay = tonumber(fadevalue)

	-- Notify
	if not silent then d("MyXpView v" .. ADDON_VERSION .. " : fade delay now set to " .. db.fadeXPGainDelay) end

end

-- Setting rate factor
local function SetRateFactor(rateFactor, silent)

	-- If rateFactor is > 1 then set it to 1
	local cleanValue = 0
	if tonumber(rateFactor) > 1 then cleanValue = 1 else cleanValue = tonumber(rateFactor) end

	-- Set rate factor value
	db.RateFactor = tonumber(cleanValue)

	-- Update visuals if meter is paused
	if MXPV.Meter.Paused then
		MXPV.Meter.Update()
	end

	-- Notify
	if not silent then d("MyXpView v" .. ADDON_VERSION .. " : rate factor now set to " .. db.RateFactor) end

end

-- Setting console mode
local function ToggleConsole(mode)

	-- Set console mode
	db.ConsoleMode = mode

	-- Notify
	d("MyXpView v" .. ADDON_VERSION .. " : console mode now set to " .. tostring(db.ConsoleMode))

end

-- Hide / Unhide UI
local function ToggleUI(mode, notify)

	MXPVUI:SetHidden(not mode)
	db.UIMode = mode

	-- Notify
	if notify then d("MyXpView v" .. ADDON_VERSION .. " : UI mode now set to " .. tostring(db.UIMode)) end

end

-- Hide / Unhide XP progress bar
local function ToggleXPBar(mode)

	MXPV_XP_CONTAINER:SetHidden(not mode)
	MXPV_XP_PROGRESSBAR:SetHidden(not mode)
	MXPV_XP_LABEL:SetHidden(not mode)
	db.XPBarMode = mode

	-- Notify
	d("MyXpView v" .. ADDON_VERSION .. " : XP bar mode now set to " .. tostring(db.XPBarMode))

end

-- Hide / Unhide XP meter
local function ToggleMeter(mode)

	db.MeterMode = mode
	MXPV_METER_LABEL:SetHidden(not mode)

	-- Notify
	d("MyXpView v" .. ADDON_VERSION .. " : meter now set to " .. tostring(db.MeterMode))

end

-- Combat only meter update
local function ToggleCombatOnly(mode)

	db.CombatOnly = mode
	if not db.CombatOnly then MXPV.Meter.Start()
	elseif not MXPV.CombatState then MXPV.Meter.Pause() end

	-- Notify
	d("MyXpView v" .. ADDON_VERSION .. " : combatonly now set to " .. tostring(db.CombatOnly))

end

-- Pause the timer until combat on start/reset
local function ToggleStartPaused(mode)

	db.StartPaused = mode

	-- Notify
	d("MyXpView v" .. ADDON_VERSION .. " : startpaused now set to " .. tostring(db.StartPaused))
end

-- Unpause the timer when entering combat
local function ToggleCombatUnpauses(mode)

	db.CombatUnpauses = mode

	-- Notify
	d("MyXpView v" .. ADDON_VERSION .. " : combatunpauses now set to " .. tostring(db.CombatUnpauses))
end

-- Autoswitch toggle
local function ToggleAutoSwitch(mode)

	db.AutoSwitch = mode

	-- Notify
	d("MyXpView v" .. ADDON_VERSION .. " : autoswitch now set to " .. tostring(db.AutoSwitch))

end

-- Get tracking switch value
local function GetTrackingValue()
	if db.XPMode then return "XP tracking" end
	if db.RPMode then return "RP tracking" end
end

local function SetScale(scaleFactor)

	-- If rateFactor is > 1 then set it to 1
	local cleanValue = 0
	if tonumber(scaleFactor) > 1 then cleanValue = 1 else cleanValue = tonumber(scaleFactor) end

	-- Set scale factor value
	db.ScaleFactor = tonumber(cleanValue)

	-- Update visuals
	MXPVUI:SetScale(db.ScaleFactor)

end

local function SplitCommand(command)

	-- Search for white-space indexes
	local chunk = command
	local index = string.find(command, " ")
	if index == nil then return {command, nil} end

	-- Iterate our command for white-space indexes
	local explode = {}
	local n = 1
	while index ~= nil do
		explode[n] = string.sub(chunk, 1, index - 1)
		chunk = string.sub(chunk, index + 1, #chunk)
		index = string.find(chunk, " ")
		n = n + 1
	end

	-- Add chunk after last white-space
	explode[n] = chunk

	return {explode[1], explode[2]}
end

local function ShowHelp()
	local helpString = "\n MyXpView v" .. ADDON_VERSION .. " - Usable commands : \n\n "
	helpString = helpString .. "- 'toggle' : enable/disable MyXpView UI globally \n "
	helpString = helpString .. "- 'xpbar' : enable/disable XP bar display \n "
	helpString = helpString .. "- 'meter' : enable/disable the XP meter UI \n "
	helpString = helpString .. "- 'reset' : resets the XP meter \n "
	helpString = helpString .. "- 'fade x' : sets the XP gain display & pool duration (can be set to '0' to disable) \n "
	helpString = helpString .. "- 'rf x' : sets the XP rate factor (maximum 1 - only used in 'combatonly' mode) \n "
	helpString = helpString .. "- 'console' : enable/disable XP logs in chat window \n "
	helpString = helpString .. "- 'combatonly' : enable/disable XP meter updating only when in combat \n "
	helpString = helpString .. "- 'startpaused' : enable/disable pausing meter on login or reset \n "
	helpString = helpString .. "- 'combatunpauses' : enable/disable unpausing meter when entering combat \n "
	helpString = helpString .. "- 'switch' : switch between XP and RP tracking \n "
	helpString = helpString .. "- 'autoswitch' : auto-switch between XP and RP tracking \n "
	helpString = helpString .. "- 'scale' : scales the UI size - from 0 to 1 \n "
	helpString = helpString .. "- 'dump' : dumps a few variables and options \n "
	return helpString
end

local function ShowDump()
	d(string.format("MXPV.CurrentLevel : %d", MXPV.CurrentLevel))
	d(string.format("MXPV.CurrentXP : %d", MXPV.CurrentXP))
	d(string.format("MXPV.CurrentMaxXP : %d", MXPV.CurrentMaxXP))
	d(string.format("MXPV.CurrentRank : %d", MXPV.CurrentRank))
	d(string.format("MXPV.CurrentRP : %d", MXPV.CurrentRP))
	d(string.format("MXPV.CurrentMaxRP : %d", MXPV.CurrentMaxRP))
	d(string.format("db.UIMode : %s", tostring(db.UIMode)))
	d(string.format("db.XPBarMode : %s", tostring(db.XPBarMode)))
	d(string.format("db.MeterMode : %s", tostring(db.MeterMode)))
	d(string.format("db.ConsoleMode : %s", tostring(db.ConsoleMode)))
	d(string.format("db.CombatOnly : %s", tostring(db.CombatOnly)))
	d(string.format("db.StartPaused : %s", tostring(db.StartPaused)))
	d(string.format("db.CombatUnpauses : %s", tostring(db.CombatUnpauses)))
	d(string.format("db.XPMode : %s", tostring(db.XPMode)))
	d(string.format("db.RPMode : %s", tostring(db.RPMode)))
	d(string.format("db.AutoSwitch : %s", tostring(db.AutoSwitch)))
	d(string.format("db.fadeXPGainDelay : %d", db.fadeXPGainDelay))
	d(string.format("db.RateFactor : %f", db.RateFactor))
end

local function SlashCommands(text)

	local command = SplitCommand(text)
	local trigger = command[1]

	if (trigger == "?") then d(ShowHelp())
	elseif (trigger == "toggle") then ToggleUI(not db.UIMode, true)
	elseif (trigger == "xpbar") then ToggleXPBar(not db.XPBarMode)
	elseif (trigger == "meter") then ToggleMeter(not db.MeterMode)
	elseif (trigger == "reset") then Reset()
	elseif (trigger == "console") then ToggleConsole(not db.ConsoleMode)
	elseif (trigger == "combatonly") then ToggleCombatOnly(not db.CombatOnly)
	elseif (trigger == "startpaused") then ToggleStartPaused(not db.StartPaused)
	elseif (trigger == "combatunpauses") then ToggleCombatUnpauses(not db.CombatUnpauses)
	elseif (trigger == "autoswitch") then ToggleAutoSwitch(not db.AutoSwitch)
	elseif (trigger == "fade") then
		local fadevalue = command[2]
		if tonumber(fadevalue) ~= nil then
			SetFadeXPGainDelay(fadevalue)
		else d("MyXpView " .. ADDON_VERSION .. " : wrong input value for 'fade x' - please insert a number.") end
	elseif (trigger == "rf") then
		local ratefactor = command[2]
		if tonumber(ratefactor) ~= nil then
			SetRateFactor(ratefactor)
		else d("MyXpView " .. ADDON_VERSION .. " : wrong input value for 'rf x' - please insert a number.") end
	elseif (trigger == "scale") then
		local scalefactor = command[2]
		if tonumber(scalefactor) ~= nil then
			SetScale(scalefactor)
		else d("MyXpView " .. ADDON_VERSION .. " : wrong input value for 'scale x' - please insert a number.") end
	elseif (trigger == "dump") then ShowDump()
	elseif (trigger == 'pause') then --experimental
		if not MXPV.Meter.Paused then
			MXPV.Meter.Pause()
			d("MyXpView " .. ADDON_VERSION .. " : meter paused.")
		end
	elseif (trigger == 'start') then --experimental
		if MXPV.Meter.Paused then
			MXPV.Meter.Start()
			d("MyXpView " .. ADDON_VERSION .. " : meter started.")
		end
	elseif (trigger == "switch") then SwitchTracking(nil, false)
	elseif (trigger == "scale") then MXPV.SwitchSize("big")
	else d("MyXpView v" .. ADDON_VERSION .. " : No input or wrong command. Type '" .. MXPV.command .. " ?' for help.") end

end

local function BuildLAM()

	-- Build menu
	local LAM = LibStub("LibAddonMenu-2.0")
	
	local panelData = {
		type = "panel",
		name = "MyXPView v" .. ADDON_VERSION,
		author = "Edda",
		version = ADDON_VERSION,
		registerForRefresh = true,
		registerForDefaults = true,
	}
	
	LAM:RegisterAddonPanel("MXPV_OPTIONS", panelData)
	
	local optionsData = {
		{
			type = "header",
			name = "Display Options",
		},
		{
			type = "checkbox",
			name = "+ Display MyXPView",
			getFunc = function() return db.UIMode end,
			setFunc = function() ToggleUI(not db.UIMode, true) end,
			default = defaults.UIMode,
		},
		{
			type = "checkbox",
			name = "+ Display XP bar",
			getFunc = function() return db.XPBarMode end,
			setFunc = function() ToggleXPBar(not db.XPBarMode, true) end,
			default = defaults.XPBarMode,
		},
		{
			type = "checkbox",
			name = "+ Display XP meter",
			getFunc = function() return db.MeterMode end,
			setFunc = function() ToggleMeter(not db.MeterMode, true) end,
			default = defaults.MeterMode,
		},
		{
			type = "checkbox",
			name = "+ Enable console logs",
			tooltip = "Display XP gains in the chat box",
			getFunc = function() return db.ConsoleMode end,
			setFunc = function() ToggleConsole(not db.ConsoleMode, true) end,
			default = defaults.ConsoleMode,
		},
		{
			type = "slider",
			name = "+ Scale Factor %",
			tooltip = "Scales the UI from 25% to 100%",
			min = 25,
			max = 100,
			getFunc = function() return math.floor(100 * db.ScaleFactor) end,
			setFunc = function (value) SetScale(value / 100, true) end,
			default = math.floor(100 * defaults.ScaleFactor),
		},
		{
			type = "header",
			name = "Meter Options",
		},
		{
			type = "checkbox",
			name = "+ Combat Only",
			tooltip = "Only run the XP meter when you are in combat",
			getFunc = function() return db.CombatOnly end,
			setFunc = function() ToggleCombatOnly(not db.CombatOnly) end,
			default = defaults.CombatOnly,
		},
		{
			type = "slider",
			name = "+ Rate Factor %",
			tooltip = "Rate factor for the combatonly mode",
			min = 0,
			max = 100,
			getFunc = function() return math.floor(100 * db.RateFactor) end,
			setFunc = function (value) SetRateFactor(value / 100, true) end,
			default = math.floor(100 * defaults.RateFactor),
		},
		{
			type = "checkbox",
			name = "+ Start with Timer Paused",
			tooltip = "Automaticlly pause the timer when logging in or when it is reset",
			getFunc = function() return db.StartPaused end,
			setFunc = function() ToggleStartPaused(not db.StartPaused) end,
			default = defaults.StartPaused,
		},
		{
			type = "checkbox",
			name = "+ Combat Unpauses Timer",
			tooltip = "Automatically unpause the timer if you enter combat",
			getFunc = function() return db.CombatUnpauses end,
			setFunc = function() ToggleCombatUnpauses(not db.CombatUnpauses) end,
			default = defaults.CombatUnpauses,
		},
		{
			type = "description",
			title = nil,
			text = "+ Reset the XP meter",
		},
		{
			type = "button",
			name = "Reset now",
			func = function() Reset() end,
			warning = "Will reset all meter data",
		},
		{
			type = "header",
			name = "XP Bar Options",
		},
		{
			type = "slider",
			name = "+ Persistance - in seconds",
			tooltip = "Sets the XP gain display & pool duration",
			min = 0,
			max = 20,
			getFunc = function() return math.floor(db.fadeXPGainDelay / 1000) end,
			setFunc = function (value) SetFadeXPGainDelay(value * 1000, true) end,
			default = math.floor(defaults.fadeXPGainDelay / 1000),
		},
		{
			type = "header",
			name = "PvP and PvM Options",
		},
		{
			type = "dropdown",
			name = "+ XP or RP tracking",
			choices = {"XP tracking", "RP tracking"},
			getFunc = function() return GetTrackingValue() end,
			setFunc = function(valueString) SwitchTracking(valueString, true) end,
		},
		{
			type = "checkbox",
			name = "+ Autoswitch tracking",
			tooltip = "Automatically switch between XP and RP tracking",
			getFunc = function() return db.AutoSwitch end,
			setFunc = function() ToggleAutoSwitch(not db.AutoSwitch, true) end,
			default = defaults.AutoSwitch,
		},
		{
			type = "header",
			name = "Command Line",
		},
		{
			type = "description",
			title = nil,
			text = "+ All options are available via command-line. For a list of available commands type '/mxpv ?'",
		},
	}
	
	LAM:RegisterOptionControls("MXPV_OPTIONS", optionsData)
		
end

local function OnAddonLoaded(eventCode, addOnName)

	-- Verify Add-On
	if addOnName == ADDON_NAME then

		-- Load user's variables
		db = ZO_SavedVars:New("MXPVvars", math.floor(MXPV.varVersion * 100), nil, defaults, nil)

		-- Set loaded variables
		if not db.UIMode then ToggleUI(false) end
		if not db.XPBarMode then ToggleXPBar(false) end
		if not db.MeterMode then ToggleMeter(false) end

		-- Init more XP vars
		MXPV.IsChampion = IsUnitVeteran("player")
		MXPV.CurrentXP = MXPV.GetUnit("XP")
		MXPV.CurrentLevel = MXPV.GetUnit("Level")
		MXPV.CurrentMaxXP = MXPV.GetUnit("XPMax")
		MXPV.BeforeGainXP = MXPV.GetUnit("XP")
		MXPV.BeforeGainLevel = MXPV.GetUnit("Level")
		MXPV.BeforeGainMaxXP = MXPV.GetUnit("XPMax")

		-- Init more RP vars
		MXPV.CurrentRP = MXPV.GetUnit("RP")
		MXPV.CurrentRank = MXPV.GetUnit("Rank")
		MXPV.CurrentMaxRP = MXPV.GetUnit("RPMax")
		MXPV.BeforeGainRP = MXPV.GetUnit("RP")
		MXPV.BeforeGainRank = MXPV.GetUnit("Rank")
		MXPV.BeforeGainMaxRP = MXPV.GetUnit("RPMax")

		-- Register the slash command handler
		SLASH_COMMANDS[MXPV.command] = SlashCommands

		-- Attach Event listeners
		EVENT_MANAGER:RegisterForUpdate(ADDON_NAME, 500, EyeOfMoscow)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_EXPERIENCE_UPDATE, MXPV.ExperienceUpdate)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_RANK_POINT_UPDATE, MXPV.RankPointsUpdate)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PLAYER_COMBAT_STATE, MXPV.GetSetCombatState)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_RETICLE_TARGET_CHANGED, MXPV.ReticleChangedEvent)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ACTION_LAYER_POPPED, MXPV.LayerPopped)
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ACTION_LAYER_PUSHED, MXPV.LayerPushed)
		
		-- Scale the UI
		SetScale(db.ScaleFactor)
		
		-- Update XP bar
		MXPV.UpdateProgressbar(false)

		-- Init Meter
		if db.CombatOnly or db.StartPaused then
			MXPV.Meter.Pause()
		else
			MXPV.Meter.Start()
		end
		
		MXPV.Meter.Update()

		-- Position the UI
		MXPVUI:ClearAnchors()
		MXPVUI:SetAnchor (db.point, parent, db.relativePoint, db.OffsetX, db.OffsetY)

		BuildLAM()
	
	end
	
end

function MXPV_SaveUIPosition()
	local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY = MXPVUI:GetAnchor()
	db.OffsetX = offsetX
	db.OffsetY = offsetY
	db.point = point
	db.relativePoint = relativePoint
end

-- Hook initialization onto the ADD_ON_LOADED event
EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)