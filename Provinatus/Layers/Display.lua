local ZOOMRATE = 0.1
local MINDISTANCE = 5
local MAXDISTANCE = 9000

ProvinatusDisplay = ZO_Object:Subclass()

function ProvinatusDisplay:New(...)
  return ZO_Object.New(self)
end

function ProvinatusDisplay:GetMenu()
  local AvailableProjections = {}
  local Menu = {
    type = "submenu",
    name = PROVINATUS_SETTINGS,
    icon = "esoui/art/tutorial/gamepad/gp_playermenu_icon_settings.dds",
    controls = {
      {
        type = "slider",
        name = PROVINATUS_HUD_SIZE,
        getFunc = function()
          return Provinatus.SavedVars.Display.Size
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.Size = value
        end,
        min = 25,
        max = 750,
        step = 1,
        clampInput = true,
        decimals = 0,
        autoSelect = true,
        inputLocation = "below",
        width = "full",
        default = ProvinatusConfig.Display.Size
      },
      {
        type = "slider",
        name = PROVINATUS_REFRESH_RATE,
        getFunc = function()
          return Provinatus.SavedVars.Display.RefreshRate
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.RefreshRate = value
          Provinatus.SetRefreshRate()
        end,
        min = 24,
        max = 144,
        step = 1,
        clampInput = true,
        decimals = 0,
        autoSelect = true,
        inputLocation = "below",
        width = "full",
        default = ProvinatusConfig.Display.RefreshRate
      },
      {
        type = "slider",
        name = PROVINATUS_HORIZONTAL_POSITION,
        getFunc = function()
          return Provinatus.SavedVars.Display.X
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.X = value
        end,
        min = math.floor(-GuiRoot:GetWidth() / 2),
        max = math.floor(GuiRoot:GetWidth() / 2),
        step = 1,
        clampInput = true,
        decimals = 0,
        autoSelect = true,
        inputLocation = "below",
        width = "half",
        default = ProvinatusConfig.Display.X
      },
      {
        type = "slider",
        name = PROVINATUS_VERTICAL_POSITION,
        getFunc = function()
          return Provinatus.SavedVars.Display.Y
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.Y = value
        end,
        min = math.floor(-GuiRoot:GetHeight() / 2),
        max = math.floor(GuiRoot:GetHeight() / 2),
        step = 1,
        clampInput = true,
        decimals = 0,
        autoSelect = true,
        inputLocation = "below",
        width = "half",
        default = ProvinatusConfig.Display.Y
      },
      {
        type = "checkbox",
        name = PROVINATUS_OFFSET_CENTER,
        reference = "ProvinatusOffsetCenterCheckbox",
        getFunc = function()
          return Provinatus.SavedVars.Display.Offset
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.Offset = value
          self:SetMenuIcon()
        end,
        tooltip = PROVINATUS_OFFSET_CENTER_TT,
        width = "full",
        default = ProvinatusConfig.Display.Offset
      },
      {
        type = "slider",
        name = PROVINATUS_MAX_DISTANCE,
        tooltip = PROVINATUS_MAX_DISTANCE_TT,
        getFunc = function()
          return Provinatus.SavedVars.Display.MaxDistance
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.MaxDistance = value
        end,
        min = MINDISTANCE,
        max = MAXDISTANCE,
        step = 1,
        clampInput = true,
        decimals = 0,
        autoSelect = true,
        inputLocation = "below",
        width = "half",
        default = ProvinatusConfig.Display.MaxDistance,
        tooltip = PROVINATUS_ZOOM_TT
      },
      {
        type = "checkbox",
        name = "Show distant",
        getFunc = function()
          return Provinatus.SavedVars.Display.ShowDistant
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.ShowDistant = value
        end,
        tooltip = "Hides icons further than the max distance",
        width = "half",
        default = ProvinatusConfig.Display.ShowDistant
      },
      {
        type = "dropdown",
        name = "Projection",
        choices = {GetString(PROVINATUS_LINEAR), GetString(PROVINATUS_FISHEYE)},
        choicesValues = {PROV_LINEAR, PROV_ORTHO},
        getFunc = function()
          return Provinatus.SavedVars.Display.ProjectionCode
        end,
        setFunc = function(var)
          Provinatus.SavedVars.Display.ProjectionCode = var
        end,
        tooltip = PROVINATUS_PROJECTION_TT,
        sort = "name-down",
        width = "full",
        scrollable = true,
        requiresReload = false,
        choicesTooltips = {
          GetString(PROVINATUS_LINEAR_TT),
          GetString(PROVINATUS_FISHEYE_TT)
        },
        default = ProvinatusConfig.Display.ProjectionCode
      },
      {
        type = "slider",
        name = PROVINATUS_FISHEYE_AMOUNT,
        getFunc = function()
          return Provinatus.SavedVars.Display.Orthomultiplier
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.Orthomultiplier = value
        end,
        min = 0.1,
        max = 100,
        step = 1,
        clampInput = true,
        decimals = 0,
        autoSelect = true,
        inputLocation = "below",
        width = "full",
        default = ProvinatusConfig.Display.Orthomultiplier,
        tooltip = PROVINATUS_ZOOM_TT,
        disabled = function()
          return Provinatus.SavedVars.Display.ProjectionCode == PROV_LINEAR
        end
      },
      {
        type = "checkbox",
        name = PROVINATUS_FADE,
        getFunc = function()
          return Provinatus.SavedVars.Display.Fade
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.Fade = value
        end,
        tooltip = PROVINATUS_FADE_TT,
        width = "full",
        default = ProvinatusConfig.Display.Fade
      },
      {
        type = "slider",
        name = PROVINATUS_FADE_MIN,
        getFunc = function()
          return Provinatus.SavedVars.Display.MinFade
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.MinFade = value
        end,
        min = 0,
        max = 1,
        step = 0.01,
        decimals = 2,
        autoSelect = true,
        inputLocation = "below",
        width = "half",
        default = ProvinatusConfig.Display.MinFade,
        tooltip = PROVINATUS_FADE_MIN_TT,
        disabled = function()
          return not Provinatus.SavedVars.Display.Fade
        end
      },
      {
        type = "slider",
        name = PROVINATUS_FADE_RATE,
        getFunc = function()
          return Provinatus.SavedVars.Display.FadeRate
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.FadeRate = value
        end,
        min = 0.01,
        max = 5,
        step = 0.01,
        decimals = 2,
        autoSelect = true,
        inputLocation = "below",
        width = "half",
        default = ProvinatusConfig.Display.FadeRate,
        tooltip = PROVINATUS_FADE_RATE_TT,
        disabled = function()
          return not Provinatus.SavedVars.Display.Fade
        end
      },
      {
        type = "checkbox",
        name = PROVINATUS_LOGTOCHAT,
        getFunc = function()
          return Provinatus.SavedVars.Display.LogToChat
        end,
        setFunc = function(value)
          Provinatus.SavedVars.Display.LogToChat = value
        end,
        tooltip = PROVINATUS_LOGTOCHAT_TT,
        width = "full",
        default = ProvinatusConfig.Display.LogToChat
      }
    }
  }

  return Menu
end

function ProvinatusDisplay:SetMenuIcon()
  if not ProvinatusOffsetCenterCheckbox.Reticle then
    ProvinatusOffsetCenterCheckbox.Reticle =
      WINDOW_MANAGER:CreateControl(nil, ProvinatusOffsetCenterCheckbox, CT_TEXTURE)
    ProvinatusOffsetCenterCheckbox.Reticle:SetTexture("esoui/art/worldmap/map_centerreticle.dds")
    ProvinatusOffsetCenterCheckbox.Reticle:SetAlpha(1)
    ProvinatusOffsetCenterCheckbox.Reticle:SetAnchor(CENTER, ProvinatusOffsetCenterCheckbox, CENTER, 0, 0)
    ProvinatusOffsetCenterCheckbox.Reticle:SetDimensions(24, 24)
    ProvinatusOffsetCenterCheckbox.Reticle:SetTextureRotation(math.pi / 4)

    ProvinatusOffsetCenterCheckbox.Pointer =
      WINDOW_MANAGER:CreateControl(nil, ProvinatusOffsetCenterCheckbox.Reticle, CT_TEXTURE)
    ProvinatusOffsetCenterCheckbox.Pointer:SetTexture("esoui/art/floatingmarkers/quest_icon_assisted.dds")
    ProvinatusOffsetCenterCheckbox.Pointer:SetDimensions(24, 24)
    ProvinatusOffsetCenterCheckbox.Pointer:SetTextureRotation(math.pi)
    ProvinatusOffsetCenterCheckbox.Pointer:SetColor(0, 1, 0, 1)
  end

  local AnchorPosition
  if Provinatus.SavedVars.Display.Offset then
    AnchorPosition = BOTTOM
  else
    AnchorPosition = CENTER
  end
  ProvinatusOffsetCenterCheckbox.Pointer:SetAnchor(CENTER, ProvinatusOffsetCenterCheckbox, AnchorPosition, 0, 0)
end

function ProvinatusZoomIn()
  Provinatus.SavedVars.Display.MaxDistance =
    math.max(Provinatus.SavedVars.Display.MaxDistance - Provinatus.SavedVars.Display.MaxDistance * 0.175, MINDISTANCE)
  if Provinatus.SavedVars.Display.LogToChat then
    d(
      zo_strformat(
        "[Provinatus]:Max Distance - <<1>> meters",
        ZO_LocalizeDecimalNumber(math.floor(Provinatus.SavedVars.Display.MaxDistance))
      )
    )
  end
end

function ProvinatusZoomOut()
  Provinatus.SavedVars.Display.MaxDistance =
    math.min(Provinatus.SavedVars.Display.MaxDistance + Provinatus.SavedVars.Display.MaxDistance * 0.175, MAXDISTANCE)
  if Provinatus.SavedVars.Display.LogToChat then
    d(
      zo_strformat(
        "[Provinatus]:Max Distance - <<1>> meters",
        ZO_LocalizeDecimalNumber(math.floor(Provinatus.SavedVars.Display.MaxDistance))
      )
    )
  end
end
