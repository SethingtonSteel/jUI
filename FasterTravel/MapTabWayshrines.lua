
local MapTabWayshrines = FasterTravel.class(FasterTravel.MapTab)
FasterTravel.MapTabWayshrines = MapTabWayshrines

local Location = FasterTravel.Location
local Wayshrine = FasterTravel.Wayshrine
local Transitus = FasterTravel.Transitus
local Campaign = FasterTravel.Campaign
local Utils = FasterTravel.Utils
local Options = FasterTravel.Options

local chat = FasterTravel.Utils.chat
local empty_prefix = '   '
local wayshrinesCache

local function ShowWayshrineConfirm(data,isRecall)
	local nodeIndex,name,refresh,clicked = data.nodeIndex,data.name,data.refresh,data.clicked
	ZO_Dialogs_ReleaseDialog("FAST_TRAVEL_CONFIRM")
	ZO_Dialogs_ReleaseDialog("RECALL_CONFIRM")
	name = name or select(2, Wayshrine.Data.GetNodeInfo(nodeIndex)) -- just in case
	local id = (isRecall == true and "RECALL_CONFIRM") or "FAST_TRAVEL_CONFIRM"
	if isRecall == true then
		local _, timeLeft = GetRecallCooldown()
		if timeLeft ~= 0 then
			local text = zo_strformat(SI_FAST_TRAVEL_RECALL_COOLDOWN, name, ZO_FormatTimeMilliseconds(timeLeft, TIME_FORMAT_STYLE_DESCRIPTIVE, TIME_FORMAT_PRECISION_SECONDS))
		    ZO_Alert(UI_ALERT_CATEGORY_ERROR, SOUNDS.NEGATIVE_CLICK, text)
			return
		end
	end
	ZO_Dialogs_ShowPlatformDialog(id, {nodeIndex = nodeIndex}, {mainTextParams = {name}})
end


local function ShowWayshrineMenu(owner,data,favourites)
	ClearMenu()
	if data == nil or favourites == nil then return end
	local nodeIndex = data.nodeIndex
	if favourites.list:contains(nodeIndex) then
		AddMenuItem(GetString(FASTER_TRAVEL_REMOVE_FAVOURITE), function()
			favourites.remove(nodeIndex)
			ClearMenu()
		end)
	else
		AddMenuItem(GetString(FASTER_TRAVEL_ADD_FAVOURITE), function()
			favourites.add(nodeIndex)
			ClearMenu()
		end)
	end
	ShowMenu(owner)
end

local function ShowTransitusConfirm(data,isRecall)
	if not isRecall then
		TravelToKeep(data.nodeIndex)
	end
end

local function AttachRefreshHandler(args,data)
	local refresh = args.refresh
	data.refresh = function(self,control)
		control.label:SetText(self.name)
		if refresh then
			refresh(self,control)
		end
	end
end

local function AttachWayshrineDataHandlers(args, data)
	AttachRefreshHandler(args,data)
	local clicked = args.clicked
	local isRecall = args.nodeIndex == nil
	local isKeep = args.isKeep
	local inCyrodiil = args.inCyrodiil
	data.clicked = function(self,control,button)
		if inCyrodiil == true and (isRecall == true or isKeep == true) then return end
		if button == 1 then
			ShowWayshrineConfirm(self,isRecall)
		elseif button == 2 then
			ShowWayshrineMenu(control,self,args.favourites)
		end
	end
	return data
end

local function AttachTransitusDataHandlers(args,data)

	AttachRefreshHandler(args,data)

	local clicked = args.clicked

	data.clicked = function(self,control,button)
		if button ~= 1 then return end
		ShowTransitusConfirm(self,args.nodeIndex == nil)

	end

	return data
end

local function AttachCampaignDataHandlers(args,data)
	AttachRefreshHandler(args,data)

	data.clicked = function(self,control,button)
		if button ~= 1 then return end
		local id,name,group = data.id,data.name,data.group
		Campaign.EnterLeaveOrJoin(id,name,group)
	end

	return data
end

local function AddRowToLookup(self,control,lookup)
	local nidx = self.nodeIndex
	local lk = lookup[nidx]
	if lk == nil then
		lookup[nidx] = {control=control,data=self}
	else
		lk.control = control
		lk.data = self
	end
end

local function IsTransitusDataRequired(isKeep,nodeIndex)
	return (isKeep or nodeIndex == nil)
end

local function GetCyrodiilWayshrinesData(args)
	local nodes = Transitus.GetKnownNodes(args.nodeIndex, args.nodeIndex ~= nil or nil)

	nodes = Utils.map(nodes,function(item)
		return AttachTransitusDataHandlers(args,item)
	end)

	return nodes
end

local function GetPlayerCampaignsData(args)
	-- TODO: return player campaigns

	local nodes = Campaign.GetPlayerCampaigns()

	nodes = Utils.map(nodes,function(item)
		return AttachCampaignDataHandlers(args,item)
	end)

	return nodes
end

local function GetZoneWayshrinesData(args)

	local zoneIndex = args.zoneIndex
	local nodeIndex = args.nodeIndex
	local isKeep = args.isKeep
	local inCyrodiil = args.inCyrodiil
	local data

	atTransitus = IsTransitusDataRequired(isKeep,nodeIndex)
	if Location.Data.IsZoneIndexCyrodiil(zoneIndex) and (atTransitus or not inCyrodiil) then
		-- special handling for Cyrodiil =(
		if inCyrodiil and atTransitus then
			data = GetCyrodiilWayshrinesData(args)
		else
			data = GetPlayerCampaignsData(args)
		end
		for i, item in ipairs(data) do
			item.barename = Utils.BareName(item.name)
		    item.name = empty_prefix .. Utils.ShortName(item.name)
		end
	else
		local iter = Wayshrine.GetKnownWayshrinesByZoneIndex(zoneIndex,nodeIndex)
		iter = Utils.map(iter,function(item)
			if item.traders_cnt then
				item.name = string.format("|ce000e0%1d|r %s", -- magenta
					item.traders_cnt, Utils.ShortName(item.name))
			else
				item.name = empty_prefix .. Utils.ShortName(item.name)
			end
			return AttachWayshrineDataHandlers(args,item)
		end)
		data = Utils.toTable(iter)
	end
	table.sort(data, Utils.SortByBareName)
	return data
end

local function GetListWayshrinesData(list,args)
	if list == nil then return {} end
	local nodeIndex = args.nodeIndex
	local iter =  Utils.where(list:items(),
		function(v) return (nodeIndex == nil or v.nodeIndex ~= nodeIndex) end)
	iter = Utils.map(iter,function(d)
		local known,name = Wayshrine.Data.GetNodeInfo(d.nodeIndex)
		d.name = empty_prefix .. Utils.ShortName(name)
		return AttachWayshrineDataHandlers(args,d)
	end)
	return Utils.toTable(iter)
end

local function GetRecentWayshrinesData(recentList,args)
	return GetListWayshrinesData(recentList,args)
end

local function GetFavouritesWayshrinesData(favourites,args)
	return GetListWayshrinesData(favourites.list,args)
end

local function HandleCategoryClicked(self,i,item,data,control,c)
	local idx = GetCurrentMapIndex()
	if idx ~= item.mapIndex then
		if self:IsCategoryHidden(i) == true then
			self:SetCategoryHidden(i,false)
		end
		ZO_WorldMap_SetMapByIndex(item.mapIndex)
	else
		self:SetCategoryHidden(i, not self:IsCategoryHidden(i) )
	end
	self:OnCategoryClicked(i,item,data,control,c)
end

local function PopulateLookup(lookup,data)
	for i,node in ipairs(data) do
		lookup[node.nodeIndex] = {data=node}
	end
end

local nonZoneCategoriesCount = 4

function MapTabWayshrines:init(control,locations,locationsLookup,recentList,favourites)
	self.base.init(self,control)

	control.IconMouseEnter = FasterTravel.hook(control.IconMouseEnter,function(base,control,...)
		base(control,...)
		self:IconMouseEnter(...)
	end)

	control.IconMouseExit = FasterTravel.hook(control.IconMouseExit,function(base,control,...)
		base(control,...)
		self:IconMouseExit(...)
	end)

	control.IconMouseClicked = FasterTravel.hook(control.IconMouseClicked,function(base,control,...)
		base(control,...)
		self:IconMouseClicked(...)
	end)

	control.RowMouseEnter = FasterTravel.hook(control.RowMouseEnter,function(base,control,...)
		base(control,...)
		self:RowMouseEnter(...)
	end)

	control.RowMouseExit = FasterTravel.hook(control.RowMouseExit,function(base,control,...)
		base(control,...)
		self:RowMouseExit(...)
	end)

	control.RowMouseClicked = FasterTravel.hook(control.RowMouseClicked,function(base,control,...)
		base(control,...)
		self:RowMouseClicked(...)
	end)

	local _first = true

	local _rowLookup = {}

	local currentZoneIndex
	local currentMapIndex

	local _locations = locations
	local _locationsLookup = locationsLookup

	self.ws_order_func = Utils.SortByBareName
	
	local currentNodeIndex,currentIsKeep, currentInCyrodiil

	self.IsRecall = function(self)
		return currentNodeIndex == nil
	end

	self.IsKeep = function(self)
		return currentIsKeep
	end

	self.InCyrodiil = function(self)
		return currentInCyrodiil
	end

	self.GetRowLookups = function(self)
		return _rowLookup
	end

	self.GetCurrentZoneMapIndexes = function(self)
		return currentZoneIndex,currentMapIndex
	end

	self.SetCurrentZoneMapIndexes = function(self,zoneIndex,mapIndex)

		currentZoneIndex = zoneIndex

		if zoneIndex == nil then
			currentMapIndex = nil
		elseif mapIndex == nil then
			loc = locationsLookup[zoneIndex]
			if loc ~= nil then
				currentMapIndex = loc.mapIndex
			end
		elseif mapIndex ~= nil then
			currentMapIndex = mapIndex
		end

	end

	self.SetAllWSOrder = function(self, order)
		local lookup = {
			[Options.AllWSOrder.TRADERS] =
				function(x,y) -- sort by number of traders at the WS
					return 	(y.traders_cnt or 0) < (x.traders_cnt or 0) or
							(y.traders_cnt or 0) == (x.traders_cnt or 0) and
							(x.barename or x.name) < (y.barename or y.name)
   					end,
			[Options.AllWSOrder.NAME] = Utils.SortByBareName -- sort alphabetically
		}
		self.ws_order_func = lookup[order]
	end
	
	self.Refresh = function(self,nodeIndex,isKeep)
		_rowLookup.categories = {}
		_rowLookup.current = {}
		_rowLookup.favourites = {}
		_rowLookup.recent = {}
		_rowLookup.allshrines = {}
		_rowLookup.zone = {}

		isKeep = isKeep == true

		currentNodeIndex = nodeIndex
		currentIsKeep = isKeep

		-- d(string.format('currentZoneIndex= %d', currentZoneIndex))
		local inCyrodiil = IsInCampaign() or IsInCyrodiil() or IsInImperialCity() or Location.Data.IsZoneIndexCyrodiil(currentZoneIndex)

		currentInCyrodiil = inCyrodiil

		local recentlookup = _rowLookup.recent
		local favouriteslookup = _rowLookup.favourites
		local currentlookup = _rowLookup.current
		local alllookup = _rowLookup.allshrines
		
		local recent = GetRecentWayshrinesData(recentList,{nodeIndex=nodeIndex,favourites=favourites, refresh=function(self,control) AddRowToLookup(self,control,recentlookup) end})
		local faves = GetFavouritesWayshrinesData(favourites,{nodeIndex=nodeIndex,favourites=favourites, refresh=function(self,control) AddRowToLookup(self,control,favouriteslookup) end})
		local current = GetZoneWayshrinesData({nodeIndex = nodeIndex, zoneIndex = currentZoneIndex, isKeep = isKeep, inCyrodiil = inCyrodiil, favourites=favourites, refresh=function(self,control) AddRowToLookup(self,control,currentlookup) end})

		table.sort(current, self.ws_order_func)

		local curLoc = _locationsLookup[currentZoneIndex] or _locationsLookup["tamriel"]

		local categories = { 
			{
				name = GetString(FASTER_TRAVEL_WAYSHRINES_CATEGORY_FAVOURITES),
				data = faves,
			},
			{
				name = string.format("%s (%s)", GetString(FASTER_TRAVEL_WAYSHRINES_CATEGORY_CURRENT), curLoc.name),
				data = current,
				clicked=function(data,control,c)
					HandleCategoryClicked(self,3,{zoneIndex=currentZoneIndex,mapIndex=currentMapIndex},currentlookup,data,control,c)
					if self:IsCategoryHidden(3) == false and curLoc.click then
						curLoc.click()
					end
				end,
				curZoneIndex = currentZoneIndex
			},
			{
				name = GetString(FASTER_TRAVEL_WAYSHRINES_CATEGORY_ALL),
			}
		}

		table.insert(categories, FasterTravel.settings.recentsPosition, -- either 1 or 2
			{
				name = GetString(FASTER_TRAVEL_WAYSHRINES_CATEGORY_RECENT),
				data = recent,
			}
		)

		for i = 1, 4 do 
			categories[i].hidden = not _first and self:IsCategoryHidden(i)
		end
		
		PopulateLookup(recentlookup, recent)
		if FasterTravel.settings.sortFav then
			table.sort(faves, self.ws_order_func)
		end
		PopulateLookup(favouriteslookup, faves)
		table.sort(current, self.ws_order_func)
		PopulateLookup(currentlookup, current)

		local zoneLookup = _rowLookup.zone

		local locations = _locations

		local categoryLookup = _rowLookup.categories

		if locations ~= nil then
			local allshrines = {}
			local lcount = #locations

			for i,item in ipairs(locations) do
				local id = i + nonZoneCategoriesCount
				local lookup = {}
				zoneLookup[item.zoneIndex] = lookup

				local data = GetZoneWayshrinesData({
					nodeIndex = nodeIndex,
					isKeep = isKeep,
					zoneIndex = item.zoneIndex,
					inCyrodiil = inCyrodiil,
					favourites = favourites,
					refresh = function(self,control) AddRowToLookup(self,control,lookup) end
				})

				table.sort(data, self.ws_order_func)
				PopulateLookup(lookup, data)
				Utils.copy(data, allshrines)

				local category = {
					name = item.name,
					hidden = _first or self:IsCategoryHidden(id),
					data = data,
					clicked = function(data,control,c)
						local ii
						HandleCategoryClicked(self, id, item, lookup, data, control, c)
						if item.click then
							item.click()
						end
						if not self:IsCategoryHidden(id) then
							for ii = nonZoneCategoriesCount + 1, lcount do
								if ii ~= id and self:IsCategoryHidden(ii) == false then
									self:SetCategoryHidden(ii,true)
								end
							end
						end
					end,
					zoneIndex = item.zoneIndex
				}

				table.insert(categories,category)
			end

			table.sort(allshrines, self.ws_order_func)
			categories[nonZoneCategoriesCount].data = allshrines
			PopulateLookup(alllookup, allshrines)
		end

		self:ClearControl()

		local cdata = self:AddCategories(categories, 1) -- 1 for Wayshrines tab

		self:RefreshControl(categories)

		for i,c in ipairs(cdata) do
			if c.zoneIndex ~= nil then
				categoryLookup[c.zoneIndex] = c
			end
		end

		_rowLookup.categoriesTable = cdata

		_first = false

	end

	self.HideAllZoneCategories = function(self)
		for i, loc in ipairs(locations) do
			self:SetCategoryHidden(i + nonZoneCategoriesCount, true)
		end
	end

end

function MapTabWayshrines:OnCategoryClicked(i,item,lookup,data,control,c)

end

function MapTabWayshrines:IconMouseEnter(...)

end

function MapTabWayshrines:IconMouseExit(...)

end

function MapTabWayshrines:IconMouseClicked(...)

end

function MapTabWayshrines:RowMouseEnter(...)

end

function MapTabWayshrines:RowMouseExit(...)

end

function MapTabWayshrines:RowMouseClicked(...)

end

function MapTabWayshrines:ChangeFilter(listcontrol, editbox)
	local substring = string.lower(editbox:GetText())
	local i, itemIndex, item
	if substring == "" then
		-- reinstate default text
		ZO_EditDefaultText_Initialize(editbox, GetString(FASTER_TRAVEL_WAYSHRINES_SEARCH))
	else
		-- remove default text
		ZO_EditDefaultText_Disable(editbox)
	end
	local show_all = string.len(substring) < 3
	-- unhide All unconditionally 
	ZO_ScrollList_ShowCategory(listcontrol, nonZoneCategoriesCount)
	-- and Recent, Favourites, Zone only if no search conducted yet
	for i = 1, nonZoneCategoriesCount - 1 do
		if show_all then 
			ZO_ScrollList_ShowCategory(listcontrol, i)
		else
			ZO_ScrollList_HideCategory(listcontrol, i)
		end
	end
	wayshrinesCache = wayshrinesCache or
		ZO_ScrollList_GetDataList(listcontrol)
	for itemIndex, item in ipairs(wayshrinesCache) do
		if item.categoryId == nonZoneCategoriesCount then
			if (item.data.barename and string.find(string.lower(item.data.barename), substring) or
				item.data.name and string.find(string.lower(item.data.name), substring)) then
				chat(3, "%s in %s (%s)", substring, item.data.name, itemIndex)
				ZO_ScrollList_ShowData(listcontrol, itemIndex)
			else
				ZO_ScrollList_HideData(listcontrol, itemIndex)
			end
		end
	end
end

function MapTabWayshrines:ResetFilter(editbox)
	editbox:SetText("")
	editbox:LoseFocus()
	ZO_EditDefaultText_Initialize(editbox, GetString(FASTER_TRAVEL_WAYSHRINES_SEARCH))
end
