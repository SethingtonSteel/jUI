ProvinatusSkyshards = ZO_Object:Subclass()

local UnknownTexture = "Provinatus/Icons/Skyshard-unknown.dds"
local KnownTexture = "Provinatus/Icons/Skyshard-collected.dds"

local function CreateElement(SkyshardData)
  local _, NumCompleted, NumRequired = GetAchievementCriterion(SkyshardData[3], SkyshardData[4])
  local Element = {
    X = SkyshardData[1],
    Y = SkyshardData[2],
    Alpha = Provinatus.SavedVars.Skyshards.Uncollected.Alpha,
    Height = Provinatus.SavedVars.Skyshards.Uncollected.Size,
    Width = Provinatus.SavedVars.Skyshards.Uncollected.Size,
    Texture = UnknownTexture
  }

  if NumCompleted == NumRequired and Provinatus.SavedVars.Skyshards.ShowCollected then
    Element.Alpha = Provinatus.SavedVars.Skyshards.Collected.Alpha
    Element.Height = Provinatus.SavedVars.Skyshards.Collected.Size
    Element.Width = Provinatus.SavedVars.Skyshards.Collected.Size
    Element.Texture = KnownTexture
  elseif NumCompleted == NumRequired then
    Element.Alpha = 0
  end
  if Element.Alpha ~= 0 then
    return Element
  end
end

function ProvinatusSkyshards:Update()
  local Skyshards = {}
  local SkyShardZoneData
  if SkyShards_GetLocalData then
    SkyShardZoneData = SkyShards_GetLocalData(Provinatus.Zone, Provinatus.Subzone)
  else
    SkyShardZoneData = ProvinatusSkyshardsData[Provinatus.Subzone]
  end

  if Provinatus.SavedVars.Skyshards.Enabled then
    for _, SkyshardData in pairs(SkyShardZoneData or {}) do
      local Element = CreateElement(SkyshardData)
      if Element then
        table.insert(Skyshards, Element)
      end
    end
  end

  Provinatus.DrawElements(self, Skyshards)
end

function ProvinatusSkyshards:GetMenu()
  return {
    type = "submenu",
    name = "Skyshards",
    reference = "ProvinatusSkyshard",
    icon = KnownTexture,
    controls = {
      [1] = {
        type = "checkbox",
        name = PROVINATUS_ENABLE_SKYSHARDS,
        getFunc = function()
          return Provinatus.SavedVars.Skyshards.Enabled
        end,
        setFunc = function(value)
          self.CurrentZone = nil
          Provinatus.SavedVars.Skyshards.Enabled = value
        end,
        tooltip = function()
          if SkyShards_GetLocalData then
            return PROVINATUS_ENABLE_SKYSHARDS_TT
          else
            return PROVINATUS_ENABLE_SKYSHARDS_NO_SS_TT
          end
        end,
        width = "full",
        default = ProvinatusConfig.Skyshards.Enabled
      },
      [2] = {
        type = "submenu",
        name = PROVINATUS_UNDISCOVERED,
        controls = {
          [1] = {
            type = "slider",
            name = PROVINATUS_ICON_SIZE,
            getFunc = function()
              return Provinatus.SavedVars.Skyshards.Uncollected.Size
            end,
            setFunc = function(value)
              Provinatus.SavedVars.Skyshards.Uncollected.Size = value
            end,
            min = 20,
            max = 150,
            step = 1,
            clampInput = true,
            decimals = 0,
            autoSelect = true,
            inputLocation = "below",
            tooltip = PROVINATUS_ICON_SIZE_TT,
            width = "half",
            disabled = function()
              return not Provinatus.SavedVars.Skyshards.Enabled
            end,
            default = ProvinatusConfig.Skyshards.Uncollected.Size
          },
          [2] = {
            type = "slider",
            name = PROVINATUS_TRANSPARENCY,
            getFunc = function()
              return Provinatus.SavedVars.Skyshards.Uncollected.Alpha * 100
            end,
            setFunc = function(value)
              Provinatus.SavedVars.Skyshards.Uncollected.Alpha = value / 100
            end,
            min = 0,
            max = 100,
            step = 1,
            clampInput = true,
            decimals = 0,
            autoSelect = true,
            inputLocation = "below",
            tooltip = PROVINATUS_TRANSPARENCY_TT,
            width = "half",
            disabled = function()
              return not Provinatus.SavedVars.Skyshards.Enabled
            end,
            default = ProvinatusConfig.Skyshards.Uncollected.Alpha * 100
          }
        }
      },
      [3] = {
        type = "submenu",
        name = PROVINATUS_DISCOVERED,
        controls = {
          [1] = {
            type = "checkbox",
            name = PROVINATUS_SHOW_DISCOVERED,
            getFunc = function()
              return Provinatus.SavedVars.Skyshards.ShowCollected
            end,
            setFunc = function(value)
              Provinatus.SavedVars.Skyshards.ShowCollected = value
            end,
            tooltip = PROVINATUS_SHOW_DISCOVERED_TT,
            width = "full",
            default = ProvinatusConfig.Skyshards.ShowCollected,
            disabled = function()
              return not Provinatus.SavedVars.Skyshards.Enabled
            end
          },
          [2] = {
            type = "slider",
            name = PROVINATUS_ICON_SIZE,
            getFunc = function()
              return Provinatus.SavedVars.Skyshards.Collected.Size
            end,
            setFunc = function(value)
              Provinatus.SavedVars.Skyshards.Collected.Size = value
            end,
            min = 20,
            max = 150,
            step = 1,
            clampInput = true,
            decimals = 0,
            autoSelect = true,
            inputLocation = "below",
            tooltip = PROVINATUS_ICON_SIZE_TT,
            width = "half",
            disabled = function()
              return not Provinatus.SavedVars.Skyshards.ShowCollected or not Provinatus.SavedVars.Skyshards.Enabled
            end,
            default = ProvinatusConfig.Skyshards.Collected.Size
          },
          [3] = {
            type = "slider",
            name = PROVINATUS_TRANSPARENCY,
            getFunc = function()
              return Provinatus.SavedVars.Skyshards.Collected.Alpha * 100
            end,
            setFunc = function(value)
              Provinatus.SavedVars.Skyshards.Collected.Alpha = value / 100
            end,
            min = 0,
            max = 100,
            step = 1,
            clampInput = true,
            decimals = 0,
            autoSelect = true,
            inputLocation = "below",
            tooltip = PROVINATUS_TRANSPARENCY_TT,
            width = "half",
            disabled = function()
              return not Provinatus.SavedVars.Skyshards.ShowCollected or not Provinatus.SavedVars.Skyshards.Enabled
            end,
            default = ProvinatusConfig.Skyshards.Collected.Alpha * 100
          }
        }
      }
    }
  }
end
