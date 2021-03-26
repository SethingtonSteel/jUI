Provinatus = {}

Provinatus.Listeners = {
  OnClear = {}
}

Provinatus.DisplayEnable = true

local DisplaySettings

local function OnUpdate()
  if not Provinatus.DisplayEnable or Provinatus.TopLevelWindow:IsHidden() then
    return
  end

  if
    not ZO_WorldMap_IsWorldMapShowing() and not DoesCurrentMapMatchMapForPlayerLocation() and
      SetMapToPlayerLocation() == SET_MAP_RESULT_MAP_CHANGED
   then
    CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
  end

  Provinatus:SetPlayerData()
  for Name, Layer in pairs(Provinatus.Layers) do
    if Layer.Update and not Provinatus.DisabledLayers[Name] then
      Layer:Update()
    end
  end
end

local function OnPlayerActivated(EventCode, Initial)
  AVA_LAYER_INDEX = 5
  LOREBOOKS_LAYER_INDEX = 12
  HARVESTMAP_LAYER_INDEX = 17
  Provinatus.Layers = {
    [1] = ProvinatusDisplay:New(),
    [2] = ProvinatusCompass:New(),
    [3] = ProvinatusPointer:New(),
    [4] = ProvinatusTeam:New(),
    [AVA_LAYER_INDEX] = ProvinatusAVA:New(),
    [6] = ProvinatusQuests:New(),
    [7] = ProvinatusWaypoint:New(),
    [8] = ProvinatusServicePins:New(),
    [9] = ProvinatusSkyshards:New(),
    [10] = ProvinatusTreasureMaps:New(),
    [11] = ProvinatusPOI:New(),
    [LOREBOOKS_LAYER_INDEX] = ProvinatusLoreBooks:New(),
    [13] = ProvinatusRallyPoint:New(),
    [14] = ProvinatusPlayerOrientation:New(),
    [15] = ProvinatusWorldEvents:New(),
    [16] = ProvinatusDungeonChampions:New(),
    [HARVESTMAP_LAYER_INDEX] = ProvinatusHarvestMap:New(),
    [18] = ProvinatusPsijic:New(),
    [19] = ProvinatusCombat:New(),
    [20] = ProvinatusChat:New(),
    [21] = ProvinatusAntiquities:New()
  }

  Provinatus.Projection = ProvinatusProjection:New()
  Provinatus:SetPlayerData()
  for Index, Layer in pairs(Provinatus.Layers) do
    if Layer.Initialize then
      Provinatus.DisabledLayers[Index] = false
      Layer:Initialize()
    end
  end

  ProvinatusMenu.Initialize()
  local Fragment = ZO_SimpleSceneFragment:New(Provinatus.TopLevelWindow)
  HUD_SCENE:AddFragment(Fragment)
  HUD_UI_SCENE:AddFragment(Fragment)
  SIEGE_BAR_SCENE:AddFragment(Fragment)

  EVENT_MANAGER:UnregisterForEvent("Provinatus", EventCode)
  EVENT_MANAGER:RegisterForUpdate("ProvinatusUpdate", 1000 / DisplaySettings.RefreshRate, OnUpdate)
end

local function AddonLoaded(EventCode, AddonName)
  if AddonName == "Provinatus" then
    Provinatus.Icons = {}
    Provinatus.DisabledLayers = {}
    Provinatus.SavedVarsAccount = ZO_SavedVars:NewAccountWide("ProvinatusVariables", 1, nil, ProvinatusConfig)
    Provinatus.Profile = ZO_SavedVars:NewAccountWide("ProvinatusProfileConfig", 1, nil, {Profiles = {}})
    if Provinatus.SavedVarsAccount.AccountWideVars then
      Provinatus.SavedVars = Provinatus.SavedVarsAccount
    else
      Provinatus.SavedVars = ZO_SavedVars:NewCharacterIdSettings("ProvinatusVariables", 1, nil, ProvinatusConfig)
    end
    DisplaySettings = Provinatus.SavedVars.Display
    Provinatus.TopLevelWindow = CreateTopLevelWindow("ProvinatusHUD")
    Provinatus.TopLevelWindow:SetAnchor(CENTER, nil, CENTER, DisplaySettings.X, DisplaySettings.Y)
    EVENT_MANAGER:RegisterForEvent("Provinatus", EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
    EVENT_MANAGER:UnregisterForEvent("Provinatus", EventCode)
  end
end

local function Fade(Alpha, ProjectedDistance)
  local DistanceRatio = math.pow(ProjectedDistance / DisplaySettings.Size, DisplaySettings.FadeRate)
  local CalculatedAlpha = Alpha * (1 - DistanceRatio)
  return math.max(CalculatedAlpha, DisplaySettings.MinFade)
end

function Provinatus:SetPlayerData()
  local X, Y, Heading = GetMapPlayerPosition("player")
  local Zone, Subzone =
    select(3, (GetMapTileTexture()):lower():gsub("ui_map_", ""):find("maps/([%w%-]+)/([%w%-]+_[%w%-]+)"))
  self.X = X
  self.Y = Y
  self.GlobalX, self.GlobalY = LibGPS3:LocalToGlobal(X, Y)
  self.Heading = Heading
  self.CameraHeading = GetPlayerCameraHeading()
  self.Zone = Zone
  self.Subzone = Subzone
  self.GroupSize = GetGroupSize()
end

function Provinatus.DrawElements(Layer, Elements)
  if not Provinatus.Icons[Layer] and Elements ~= nil then
    Provinatus.Icons[Layer] = {}
  end

  local RenderedElements = {}

  if Elements ~= nil and #Elements > 0 then
    for Index, Element in pairs(Elements) do
      if not Provinatus.Icons[Layer][Index] then
        Provinatus.Icons[Layer][Index] = WINDOW_MANAGER:CreateControl(nil, Provinatus.TopLevelWindow, CT_TEXTURE)
      end

      local Projection = Provinatus.Projection:Project(Element.X, Element.Y)
      Element.Projection = Projection
      if not DisplaySettings.ShowDistant and Projection.DistanceM >= DisplaySettings.MaxDistance then
        Provinatus.Icons[Layer][Index]:SetAlpha(0)
      elseif DisplaySettings.Fade then
        Provinatus.Icons[Layer][Index]:SetAlpha(Fade(Element.Alpha, Projection.Distance))
      else
        Provinatus.Icons[Layer][Index]:SetAlpha(Element.Alpha)
      end

      Provinatus.Icons[Layer][Index]:SetAnchor(
        CENTER,
        Provinatus.TopLevelWindow,
        CENTER,
        Projection.XProjected,
        Projection.YProjected
      )
      Provinatus.Icons[Layer][Index]:SetDimensions(Element.Width, Element.Height)
      Provinatus.Icons[Layer][Index]:SetTexture(Element.Texture)

      -- Map the icon to the element in case the caller wants to modify it
      RenderedElements[Element] = Provinatus.Icons[Layer][Index]
    end
  end

  for Index, Icon in pairs(Provinatus.Icons[Layer]) do
    if Elements == nil or Index > #Elements then
      Icon:SetAlpha(0)
    end
  end

  return RenderedElements
end

function Provinatus.SetRefreshRate(Rate)
  Rate = Rate or DisplaySettings.RefreshRate
  EVENT_MANAGER:UnregisterForUpdate("ProvinatusUpdate")
  EVENT_MANAGER:RegisterForUpdate("ProvinatusUpdate", 1000 / Rate, OnUpdate)
end

function Provinatus:ClearHUD()
  for _, Layer in pairs(self.Layers) do
    self.DrawElements(Layer, {})
  end

  for _, Action in pairs(self.Listeners.OnClear) do
    Action()
  end
end

function Provinatus:RegisterOnClearListener(Action)
  if Action then
    table.insert(self.Listeners.OnClear, Action)
  end
end

function Provinatus:ToggleHUD()
  self.DisplayEnable = not self.DisplayEnable
  if not self.DisplayEnable then
    Provinatus:ClearHUD()
  end
end

function Provinatus:ToggleLayer(Layer)
  self.DisabledLayers[Layer] = not self.DisabledLayers[Layer]
  if self.DisabledLayers[Layer] then
    self.DrawElements(self.Layers[Layer], {})
  end
end

function Provinatus:ToggleShowDistant()
  DisplaySettings.ShowDistant = not DisplaySettings.ShowDistant
end

EVENT_MANAGER:RegisterForEvent("Provinatus", EVENT_ADD_ON_LOADED, AddonLoaded)
