PP.performanceMeter = function()
--===============================================================================================--
	local SV_VER		= 0.1
	local DEF = {
		toggle	= true,
	}
	local SV = ZO_SavedVars:NewAccountWide(PP.ADDON_NAME, SV_VER, "PerformanceMeter", DEF, GetWorldName())
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

	if SV.toggle then
		local pm = ZO_PerformanceMeters
		local bg = ZO_PerformanceMetersBg
		bg:SetTexture(PP.t.clear)
		PP:CreateBackground(bg, --[[#1]] nil, pm, nil, 15, 15, --[[#2]] nil, pm, nil, -15, -15, true)
	end
end