ProvinatusTreasureMaps = ZO_Object:Subclass()

local Texture = "Provinatus/Icons/Treasure.dds"
local PinTypes = {LOST_TREASURE_PIN_TYPE_TREASURE, LOST_TREASURE_PIN_TYPE_SURVEYS}

function ProvinatusTreasureMaps:Update()
  local Elements = {}
  if LostTreasure_GetAllData then
    local ZoneData = LostTreasure_GetAllData()[GetCurrentMapId()]
    if ZoneData then
      for _, PinType in pairs(PinTypes) do
        local TypeData = ZoneData[PinType]
        if TypeData then
          for _, PinData in pairs(TypeData) do
            for _, ItemData in pairs(SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)) do
              if ItemData and ItemData.itemType == ITEMTYPE_TROPHY then
                local ItemId = GetItemId(BAG_BACKPACK, ItemData.slotIndex)
                if ItemId == PinData[LOST_TREASURE_DATA_INDEX_ITEMID] then
                  table.insert(
                    Elements,
                    {
                      X = PinData[LOST_TREASURE_DATA_INDEX_X],
                      Y = PinData[LOST_TREASURE_DATA_INDEX_Y],
                      Alpha = Provinatus.SavedVars.TreasureMaps.Alpha,
                      Width = Provinatus.SavedVars.TreasureMaps.Size,
                      Height = Provinatus.SavedVars.TreasureMaps.Size,
                      Texture = Texture
                    }
                  )
                end
              end
            end
          end
        end
      end
    end
  end

  Provinatus.DrawElements(self, Elements)
end

function ProvinatusTreasureMaps:GetMenu()
  return {
    type = "submenu",
    name = PROVINATUS_TREASURE_MAPS,
    reference = "ProvinatusTreasureMapsMenu",
    icon = Texture,
    controls = {
      [1] = {
        type = "checkbox",
        name = PROVINATUS_TREASURE_MAPS_ENABLE,
        getFunc = function()
          return Provinatus.SavedVars.TreasureMaps.Enabled
        end,
        setFunc = function(value)
          Provinatus.SavedVars.TreasureMaps.Enabled = value
        end,
        tooltip = function()
          if LOST_TREASURE_DATA == nil then
            return PROVINATUS_TREASURE_MAPS_ENABLE_NO_ADDON
          end
        end,
        width = "full",
        default = ProvinatusConfig.TreasureMaps.Enabled
      },
      [2] = {
        type = "submenu",
        name = PROVINATUS_ICON_SETTINGS,
        controls = ProvinatusMenu.GetIconSettingsMenu(
          "",
          function()
            return Provinatus.SavedVars.TreasureMaps.Size
          end,
          function(value)
            Provinatus.SavedVars.TreasureMaps.Size = value
          end,
          function()
            return Provinatus.SavedVars.TreasureMaps.Alpha * 100
          end,
          function(value)
            Provinatus.SavedVars.TreasureMaps.Alpha = value / 100
          end,
          ProvinatusConfig.TreasureMaps.Size,
          ProvinatusConfig.TreasureMaps.Alpha * 100
        )
      }
    }
  }
end
