PP.performanceMeterScene = function()
--===============================================================================================--
	local SV_VER		= 0.1
	local DEF = {
		toggle	= true,
		ListBG	= false,
	}
	local SV = ZO_SavedVars:NewAccountWide(PP.ADDON_NAME, SV_VER, "PerformanceMeterScene", DEF, GetWorldName())
	---------------------------------------------
	table.insert(PP.optionsData,
	{	type				= "submenu",
		name				= GetString(PP_LAM_SCENE_PERFORMANCE_METER),
		controls = {
			{	type				= "checkbox",
				name				= GetString(PP_LAM_ACTIVATE),
				getFunc				= function() return SV.toggle end,
				setFunc				= function(value) SV.toggle = value end,
				default				= DEF.toggle,
				requiresReload		= true,
			},
		},
	})
--===============================================================================================--
	--PERFORMANCE_METER_FRAGMENT
	local performanceMeterFragment = PERFORMANCE_METER_FRAGMENT
	HUD_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)
	HUD_UI_SCENE:AddFragment(PP_BACKDROP_FRAGMENT)

--ADD-ONS------------------------------------------------------------------------------------------
	if SV.toggle then
		local performanceMeterControl = ZO_PerformanceMeters
		local performanceMeterControlBg = GetControl(performanceMeterControl, "Bg")
		performanceMeterControlBg:SetHidden(true)
		--ZO_PerformanceMetersBg , textureFile="EsoUI/Art/Performance/StatusMeterMunge.dds">
		PP.SetBackdrop(1, performanceMeterControl, nil, 15, 15, -15, -15, performanceMeterFragment, nil)
	end
end