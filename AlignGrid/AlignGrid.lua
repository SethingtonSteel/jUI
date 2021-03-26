AlignGrid = {}
AlignGrid.name            = "AlignGrid"
AlignGrid.version         = 3
AlignGrid.author          = "skyraker, Crabby654, @d2allgr (EU)"
AlignGrid.color           = "DDFFEE"
AlignGrid.menuName        = "Align Grid"
AlignGrid.slashCommand    = "/align"
AlignGrid.savedVars = {
  accountWide = false,
  gridSize = 32,
  lineThickness = 2,
  tlwAlpha = 1,
  gridAlpha = 1,
  lineColor = {r = 0, g = 0, b = 0, a = 1},
  centColor = {r = 255, g = 0, b = 0, a = 1}
}

function AlignGrid.CreateLine(pool)
  local line = WINDOW_MANAGER:CreateControl(nil, AlignGrid.window, CT_TEXTURE)
  line:SetColor(0, 0, 0, AlignGrid.savedVars.gridAlpha)
  line:SetPixelRoundingEnabled(false)
  return line
end

function AlignGrid.ResetLine(object)
  object:SetHidden(true)
end

AlignGrid.linePool = ZO_ObjectPool:New(AlignGrid.CreateLine, AlignGrid.ResetLine)

function AlignGrid.ResetGrid()
  AlignGrid.linePool:ReleaseAllObjects()
end

function AlignGrid.ShowGrid()
  AlignGrid.window:SetHidden(false)
end

function AlignGrid.HideGrid()
  AlignGrid.window:SetHidden(true)
end

function AlignGrid.CreateGrid()
  local SCREEN_WIDTH, SCREEN_HEIGHT = GuiRoot:GetDimensions()
  local gridStep = AlignGrid.savedVars.gridSize / GetUIGlobalScale()
  local lineWidth = AlignGrid.savedVars.lineThickness / GetUIGlobalScale()
  local function getAlpha(index)
    if index % 10 == 0 then
      return AlignGrid.savedVars.gridAlpha
    elseif index % 5 == 0 then
      return AlignGrid.savedVars.gridAlpha * 0.7
    else
      return AlignGrid.savedVars.gridAlpha * 0.4
    end
  end
  local function horizLine(offset, color, alpha)
    local line = AlignGrid.linePool:AcquireObject()
    line:SetDimensions(SCREEN_WIDTH, lineWidth)
    line:SetAnchor(LEFT, AlignGrid.window, LEFT, 0, offset)
    line:SetHidden(false)
    line:SetColor(color.r, color.g, color.b, alpha or color.a)
  end
  local function vertLine(offset, color, alpha)
    local line = AlignGrid.linePool:AcquireObject()
    line:SetDimensions(lineWidth, SCREEN_HEIGHT)
    line:SetAnchor(TOP, AlignGrid.window, TOP, offset, 0)
    line:SetHidden(false)
    line:SetColor(color.r, color.g, color.b, alpha or color.a)
  end
  AlignGrid.ResetGrid()
  for i = 1, zo_floor(SCREEN_WIDTH / gridStep / 2) do
    local a = getAlpha(i)
    vertLine(i * gridStep, AlignGrid.savedVars.lineColor, a)
    vertLine(-i * gridStep, AlignGrid.savedVars.lineColor, a)
  end
  -- horizontal lines
  for i = 1, zo_floor(SCREEN_HEIGHT / gridStep / 2) do
    local a = getAlpha(i)
    horizLine(i * gridStep, AlignGrid.savedVars.lineColor, a)
    horizLine(-i * gridStep, AlignGrid.savedVars.lineColor, a)
  end
  -- center cross
  vertLine(0, AlignGrid.savedVars.centColor, getAlpha(0))
  horizLine(0, AlignGrid.savedVars.centColor, getAlpha(0))
end

function AlignGrid.SetupSavedVars()
  -- Load saved variables.
  AlignGrid.characterSavedVars = ZO_SavedVars:New("AlignGrid_SavedVars", AlignGrid.version, nil, AlignGrid.savedVars)
  AlignGrid.accountSavedVars = ZO_SavedVars:NewAccountWide("AlignGrid_SavedVars", AlignGrid.version, nil, AlignGrid.savedVars)
  
  if not AlignGrid.characterSavedVars.accountWide then
    AlignGrid.savedVars = AlignGrid.characterSavedVars
  else
    AlignGrid.savedVars = AlignGrid.accountSavedVars
  end
end

function AlignGrid.Colorize(text, color)
    -- Default to addon's .color.
    if not color then color = AlignGrid.color end

    text = string.format('|c%s%s|r', color, text)

    return text
end

function AlignGrid.LoadSettings()
  local LAM = LibAddonMenu2
  
  local panelData = {
    type = "panel",
    name = AlignGrid.menuName,
    displayName = AlignGrid.Colorize(AlignGrid.menuName),
    author = AlignGrid.Colorize(AlignGrid.author, "AAF0BB"),
    -- version = AlignGrid.Colorize(AlignGrid.version, "AA00FF"),
    slashCommand = AlignGrid.slashCommand,
    registerForRefresh = true,
    registerForDefaults = true,
  }
  LAM:RegisterAddonPanel(AlignGrid.menuName, panelData)

  local optionsData = {
    [1] = {
      type = "checkbox",
      name = "Account Wide",
      tooltip = "Use the same settings throughout the entire account - instead of per character.",
      getFunc = function()
          return AlignGrid.savedVars.accountWide
      end,
      setFunc = function(v)
          AlignGrid.characterSavedVars.accountWide = v
          AlignGrid.accountSavedVars.accountWide = v
      end,
      width = "full", --or "half",
      requiresReload = true,
    },
    [2] = {
      type = "button",
      name = "Reset Grid",
      tooltip = "Resets grid with currently selected sizes",
      func = function() 
              AlignGrid.CreateGrid()
            end
    },
    [3] = {
      type = "slider",
      name = "Grid Size",
      tooltip = "Adjust grid box size",
      min = 16,
      max = 54,
      step = 4,
      getFunc = function() return AlignGrid.savedVars.gridSize end,
      setFunc = function(value)
                  AlignGrid.savedVars.gridSize = value
                end,
      warning = "PRESS Reset Grid button to show changes"
    },
    [4] = {
      type = "slider",
      name = "Thickness",
      tooltip = "Adjust thickness of gridlines",
      min = 2,
      max = 6,
      step = 1,
      getFunc = function() return AlignGrid.savedVars.lineThickness end,
      setFunc = function(value)
                  AlignGrid.savedVars.lineThickness = value
                end,
      warning = "PRESS Reset Grid button to show changes"
    },
    [5] = {
      type = "slider",
      name = "Transparency",
      tooltip = "Adjust transparency of grid.",
      min = 0,
      max = 10,
      step = .5,
      getFunc = function() return AlignGrid.savedVars.tlwAlpha * 10.0 end,
      setFunc = function(value)
                  AlignGrid:SetAlpha(value / 10.0)
                  AlignGrid.savedVars.tlwAlpha = value / 10.0
                end
    },
    [6] = {
      type = "colorpicker",
      name = "Center Line Color",
      tooltip = "Color the horizontal and vertical center lines.",
      getFunc = function() return AlignGrid.savedVars.centColor.r, AlignGrid.savedVars.centColor.g, AlignGrid.savedVars.centColor.b end,
      setFunc = function(r,g,b,a)
              AlignGrid.savedVars.centColor.r = r
              AlignGrid.savedVars.centColor.g = g
              AlignGrid.savedVars.centColor.b = b
            end,
      warning = "PRESS Reset Grid button to show changes"
    },
    [7] = {
      type = "colorpicker",
      name = "Line Color",
      tooltip = "Color the non-center lines.",
      getFunc = function() return AlignGrid.savedVars.lineColor.r, AlignGrid.savedVars.lineColor.g, AlignGrid.savedVars.lineColor.b end,
      setFunc = function(r,g,b,a)
              AlignGrid.savedVars.lineColor.r = r
              AlignGrid.savedVars.lineColor.g = g
              AlignGrid.savedVars.lineColor.b = b
            end,
      warning = "PRESS Reset Grid button to show changes"
    }
  }
  LAM:RegisterOptionControls(AlignGrid.menuName, optionsData)
end

function AlignGrid.ToggleHide()
  AlignGrid.window:ToggleHidden()
end

function AlignGrid.CreateUI()
  local window = WINDOW_MANAGER:CreateTopLevelWindow("AlignGrid_window")
  window:SetDrawLayer(DL_BACKGROUND)
  window:SetAnchorFill(GuiRoot)
  window:SetMouseEnabled(false)
  window:SetAlpha(AlignGrid.savedVars.tlwAlpha)
  
  return window
end

function AlignGrid.OnAddOnLoaded(event, addonName)
  if addonName ~= AlignGrid.name then return end
  EVENT_MANAGER:UnregisterForEvent(AlignGrid.name, EVENT_ADD_ON_LOADED)

  AlignGrid.LoadSettings()
    
  AlignGrid.SetupSavedVars()
 
  AlignGrid.window = AlignGrid.CreateUI()
  
  SLASH_COMMANDS[AlignGrid.slashCommand] = AlignGrid.ToggleHide
    
  AlignGrid.CreateGrid()
  AlignGrid.HideGrid()
end

EVENT_MANAGER:RegisterForEvent(AlignGrid.name, EVENT_ADD_ON_LOADED, AlignGrid.OnAddOnLoaded)
ZO_CreateStringId("SI_BINDING_NAME_ALIGNGRID_SHOWHIDE", "AlignGrid: |cFFFFFFShow/Hide|r") 