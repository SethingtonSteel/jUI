_Layer = ZO_Object:Subclass()
local DisableLayer = false

local function CreateElement()
  return {}
end

function _Layer:New(...)
  return ZO_Object.New(self)
end

function _Layer:Update()
  if Provinatus.SavedVars.Layer.Enabled and not DisableLayer then
    local Elements = {}

    Provinatus.DrawElements(self, Elements)
  end
end

function _Layer:GetMenu()
  local function getSize()
    return Provinatus.SavedVars.Layer.Size
  end

  local function setSize(value)
    Provinatus.SavedVars.Layer.Size = value
  end

  local function getAlpha()
    return Provinatus.SavedVars.Layer.Alpha * 100
  end

  local function setAlpha(value)
    Provinatus.SavedVars.Layer.Alpha = value / 100
  end

  local Controls = {
    {
      type = "checkbox",
      name = PROVINATUS_ENABLE,
      getFunc = function()
        return Provinatus.SavedVars.Layer.Enabled
      end,
      setFunc = function(value)
        Provinatus.SavedVars.Layer.Enabled = value
      end,
      width = "full",
      tooltip = PROVINATUS_LAYER_ENABLE_TT,
      default = ProvinatusConfig.Layer.Enabled,
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
      default = ProvinatusConfig.Layer.Size,
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
      default = ProvinatusConfig.Layer.Alpha * 100,
      disabled = DisableLayer
    }
  }

  return {
    type = "submenu",
    name = PROVINATUS_LAYER,
    tooltip = PROVINATUS_LAYER_TT,
    reference = "ProvinatusLayerMenu",
    controls = Controls
  }
end

function _Layer:SetMenuIcon()
  ProvinatusMenu.DrawMenuIcon(ProvinatusLayerMenu.arrow, "/esoui/art/icons/poi/poi_groupboss_complete.dds")
end
