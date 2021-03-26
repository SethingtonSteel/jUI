ProvinatusHarvestMap = ZO_Object:Subclass()
ProvinatusHarvestMap.Elements = {}
local DisableLayer = Harvest == nil
local SupportedNodes = {}
if not DisableLayer then
  SupportedNodes = {
    [Harvest.UNKNOWN] = "Unknown", -- TODO use ZOS strings here
    [Harvest.BLACKSMITH] = "Blacksmith",
    [Harvest.CLOTHING] = "Clothing",
    [Harvest.ENCHANTING] = "Enchanting",
    [Harvest.MUSHROOM] = "Mushroom",
    [Harvest.FLOWER] = "Flower",
    [Harvest.WATERPLANT] = "Water Plant",
    [Harvest.WOODWORKING] = "Woodworking",
    [Harvest.CHESTS] = "Chests",
    [Harvest.WATER] = "Water",
    -- [Harvest.FISHING] = "Fishing",
    [Harvest.HEAVYSACK] = "Heavy Sack",
    [Harvest.TROVE] = "Trove",
    [Harvest.JUSTICE] = "Justice",
    [Harvest.STASH] = "Stash",
    [Harvest.CLAM] = "Clam",
    [Harvest.PSIJIC] = "Psijic",
    [Harvest.JEWELRY] = "Jewelry"
    -- [Harvest.TOUR] = "Tour"
  }
end

function ProvinatusHarvestMap:Initialize()
  EVENT_MANAGER:RegisterForUpdate(
    "ProvinatusHarvestMapUpdate",
    500,
    function()
      if not Provinatus.TopLevelWindow:IsHidden() then
        self:UpdateElements()
      end
    end
  )
end

function ProvinatusHarvestMap:New(...)
  return ZO_Object.New(self)
end

function ProvinatusHarvestMap:UpdateElements()
  self.Elements = {}
  local NodeIds = {}
  local function CreateElement(Cache, NodeId)
    local X, Y = LibGPS3:GlobalToLocal(Cache.globalX[NodeId], Cache.globalY[NodeId])
    if X and Y then
      return {
        X = X,
        Y = Y,
        Height = Provinatus.SavedVars.HarvestMap.Size,
        Width = Provinatus.SavedVars.HarvestMap.Size,
        Texture = Harvest.settings.availableTextures[Cache.pinTypeId[NodeId]][1],
        PinType = Cache.pinTypeId[NodeId],
        Alpha = Provinatus.SavedVars.HarvestMap.Alpha,
        NodeId = NodeId
      }
    end
  end

  local function ShouldShow(Cache, NodeId)
    return Provinatus.SavedVars.HarvestMap[Cache.pinTypeId[NodeId]] and
      (Cache.hasCompassPin[NodeId] or not Harvest.HARVEST_NODES[Cache.pinTypeId[NodeId]])
  end

  local function AddNode(Cache, NodeId)
    if not NodeIds[NodeId] and ShouldShow(Cache, NodeId) then
      NodeIds[NodeId] = true
      local Element = CreateElement(Cache, NodeId)
      if Element then
        table.insert(self.Elements, Element)
      end
    end
  end

  if Provinatus.SavedVars.HarvestMap.Enabled and not DisableLayer and Provinatus.X and Provinatus.Y then
    if Harvest and Harvest.InRangePins and Harvest.InRangePins.zoneCache and Harvest.InRangePins.zoneCache.mapCaches then
      for Map, MapCache in pairs(Harvest.InRangePins.zoneCache.mapCaches) do
        if MapCache then
          MapCache:ForNodesInRange(
            Harvest.InRangePins.worldX,
            Harvest.InRangePins.worldY,
            Provinatus.Heading,
            Harvest.GetPinVisibleDistance(),
            Harvest.PINTYPES,
            AddNode
          )
          MapCache:ForNodesInRange(
            Harvest.InRangePins.worldX,
            Harvest.InRangePins.worldY,
            Provinatus.Heading + math.pi,
            Harvest.GetPinVisibleDistance(),
            Harvest.PINTYPES,
            AddNode
          )
        end
      end
    end
  end
end

function ProvinatusHarvestMap:Update()
  for Element, Icon in pairs(Provinatus.DrawElements(self, self.Elements)) do
    local Tint = Harvest.settings.defaultSettings.pinLayouts[Element.PinType].tint
    Icon:SetColor(Tint.r, Tint.g, Tint.b, Icon:GetAlpha())
  end
end

function ProvinatusHarvestMap:GetMenu()
  local function getSize()
    return Provinatus.SavedVars.HarvestMap.Size
  end

  local function setSize(value)
    Provinatus.SavedVars.HarvestMap.Size = value
  end

  local function getAlpha()
    return Provinatus.SavedVars.HarvestMap.Alpha * 100
  end

  local function setAlpha(value)
    Provinatus.SavedVars.HarvestMap.Alpha = value / 100
  end

  local function getNodeControls()
    local NodeControls = {}
    if not DisableLayer and Harvest then
      for Type, Layout in pairs(Harvest.settings.defaultSettings.pinLayouts) do
        if SupportedNodes[Type] then
          table.insert(
            NodeControls,
            {
              type = "checkbox",
              name = SupportedNodes[Type],
              getFunc = function()
                if not Provinatus.SavedVars.HarvestMap[Type] == nil then
                  Provinatus.SavedVars.HarvestMap[Type] = false
                end

                return Provinatus.SavedVars.HarvestMap[Type]
              end,
              setFunc = function(value)
                Provinatus.SavedVars.HarvestMap[Type] = value
              end,
              width = "full",
              default = false,
              disabled = DisableLayer,
              reference = "ProvinatusHarvestMapNode" .. SupportedNodes[Type]
            }
          )
        end
      end
    end
    return NodeControls
  end

  local Controls = {
    {
      type = "checkbox",
      name = PROVINATUS_ENABLE,
      getFunc = function()
        return Provinatus.SavedVars.HarvestMap.Enabled
      end,
      setFunc = function(value)
        Provinatus.SavedVars.HarvestMap.Enabled = value
      end,
      width = "full",
      tooltip = PROVINATUS_HARVESTMAP_ENABLE_TT,
      default = ProvinatusConfig.HarvestMap.Enabled,
      disabled = DisableLayer
    },
    {
      type = "slider",
      name = PROVINATUS_ICON_SIZE,
      getFunc = getSize,
      setFunc = setSize,
      min = 20,
      max = 150,
      step = 1,
      clampInput = true,
      decimals = 0,
      autoSelect = true,
      inputLocation = "below",
      tooltip = PROVINATUS_ICON_SIZE_TT,
      width = "half",
      default = ProvinatusConfig.HarvestMap.Size,
      disabled = DisableLayer
    },
    {
      type = "slider",
      name = PROVINATUS_TRANSPARENCY,
      getFunc = getAlpha,
      setFunc = setAlpha,
      min = 0,
      max = 100,
      step = 1,
      clampInput = true,
      decimals = 0,
      autoSelect = true,
      inputLocation = "below",
      tooltip = PROVINATUS_TRANSPARENCY_TT,
      width = "half",
      default = ProvinatusConfig.HarvestMap.Alpha * 100,
      disabled = DisableLayer
    },
    {
      type = "submenu",
      name = "Nodes",
      controls = getNodeControls()
    }
  }

  return {
    type = "submenu",
    name = PROVINATUS_HARVESTMAP,
    icon = "Provinatus/Icons/HarvestMap/chest.dds",
    reference = "ProvinatusHarvestMapMenu",
    controls = Controls
  }
end

function ProvinatusHarvestMap:SetMenuIcon()
  ProvinatusHarvestMapMenu.icon:SetColor(1, 0.937, 0.38, 1)
  if DisableLayer then
    return
  end
  if Harvest then
    for Type, Layout in pairs(Harvest.settings.defaultSettings.pinLayouts) do
      if SupportedNodes[Type] then
        local Icon = ProvinatusMenu.DrawMenuIcon(_G["ProvinatusHarvestMapNode" .. SupportedNodes[Type]], Layout.texture)
        Icon:SetAnchor(CENTER, Anchor, CENTER, 0, 0)
        Icon:SetColor(Layout.tint.r, Layout.tint.g, Layout.tint.b, Layout.tint.a)
      end
    end
  end
end
