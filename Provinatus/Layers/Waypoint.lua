ProvinatusWaypoint = ZO_Object:Subclass()

function ProvinatusWaypoint:New(...)
  return ZO_Object.New(self)
end

local Texture = "esoui/art/compass/compass_waypoint.dds"

function ProvinatusWaypoint:Update()
  local Elements = {}
  if Provinatus.SavedVars.Waypoint.Enabled then
    local WaypointX, WaypointY = GetMapPlayerWaypoint()
    if WaypointX ~= 0 and WaypointY ~= 0 then
      table.insert(
        Elements,
        {
          X = WaypointX,
          Y = WaypointY,
          Alpha = Provinatus.SavedVars.Waypoint.Alpha,
          Texture = Texture,
          Width = Provinatus.SavedVars.Waypoint.Size,
          Height = Provinatus.SavedVars.Waypoint.Size
        }
      )
    end
  end

  Provinatus.DrawElements(self, Elements)
end

function ProvinatusWaypoint:GetMenu()
  local controls =
    ProvinatusMenu.GetIconSettingsMenu(
    PROVINATUS_WAYPOINT_SETTINGS,
    function()
      return Provinatus.SavedVars.Waypoint.Size
    end,
    function(value)
      Provinatus.SavedVars.Waypoint.Size = value
    end,
    function()
      return Provinatus.SavedVars.Waypoint.Alpha * 100
    end,
    function(value)
      Provinatus.SavedVars.Waypoint.Alpha = value / 100
    end,
    ProvinatusConfig.Waypoint.Size,
    ProvinatusConfig.Waypoint.Alpha * 100,
    function()
      return not Provinatus.SavedVars.Waypoint.Enabled
    end
  )

  table.insert(
    controls,
    1,
    {
      type = "checkbox",
      name = PROVINATUS_ENABLE,
      getFunc = function()
        return Provinatus.SavedVars.Waypoint.Enabled
      end,
      setFunc = function(value)
        Provinatus.SavedVars.Waypoint.Enabled = value
      end,
      tooltip = PROVINATUS_WAYPOINT_TT,
      width = "full",
      default = ProvinatusConfig.Waypoint.Enabled
    }
  )

  return {
    type = "submenu",
    name = PROVINATUS_WAYPOINT,
    icon = Texture,
    reference = "ProvinatusWaypointMenu",
    controls = controls
  }
end
