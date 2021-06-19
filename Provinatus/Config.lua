ProvinatusConfig = {
  Name = "Provinatus",
  FriendlyName = "Provinatus",
  Author = "@AlbinoPython",
  Version = "2.1.15",
  Website = "http://www.esoui.com/downloads/info1943-Provinatus.html",
  Feedback = "https://www.esoui.com/portal.php?uid=25876&a=listbugs",
  SlashCommand = "/provinatus",
  AccountWideVars = true,
  Antiquities = {
    Enabled = false,
    Alpha = 1,
    Size = 20
  },
  AVA = {
    Enabled = false,
    OnlyUnderAttack,
    Alpha = 1,
    Size = 24,
    Objectives = false
  },
  Chat = {
    SaveChatCommands = false
  },
  Combat = {
    Enabled = false,
    Size = 24,
    Alpha = 1
  },
  Compass = {
    Color = {
      r = 1,
      g = 1,
      b = 1
    },
    Alpha = 1,
    Size = 350,
    AlwaysOn = false,
    LockToHUD = true,
    Font = "ZoFontAnnounceMedium"
  },
  Display = {
    RefreshRate = 60,
    Size = 350,
    X = 0,
    Y = 0,
    Offset = true,
    Fade = false,
    FadeRate = 0,
    MinFade = 0.25,
    MaxDistance = 100,
    ShowDistant = true,
    ProjectionCode = 1, -- See Projection.lua for possible values
    Orthomultiplier = 1,
    LogToChat = true
  },
  DungeonChampions = {
    Enabled = false,
    ShowDefeated = false,
    Size = 24,
    Alpha = 1
  },
  HarvestMap = {
    Enabled = false,
    Size = 24,
    Alpha = 1,
    Distance = 100,
    OnlySpawned = true
  },
  LoreBooks = {
    Enabled = false,
    ShowCollected = false,
    EideticMemory = false,
    Size = 24,
    Alpha = 1
  },
  MyIcon = {
    Enabled = false,
    Size = 24,
    Alpha = 1
  },
  POI = {
    Enabled = false,
    ShowDiscovered = false,
    Size = 24,
    Alpha = 1
  },
  Pointer = {
    -- Controls transparency of the central crown pointer thing.
    Enabled = true,
    Alpha = 1,
    Size = 50
  },
  Psijic = {
    Enabled = false,
    Alpha = 1,
    Size = 24
  },
  Quest = {
    Enabled = false,
    ShowInactive = false,
    Size = 24,
    Alpha = 1,
    InactiveSize = 24,
    InactiveAlpha = 1
  },
  RallyPoint = {
    Enabled = true,
    Size = 50,
    Alpha = 1
  },
  ServicePins = {
    Enabled = false,
    Size = 24,
    Alpha = 1
  },
  Skyshards = {
    Enabled = false,
    ShowCollected = false,
    Collected = {
      Size = 24,
      Alpha = 1
    },
    Uncollected = {
      Size = 24,
      Alpha = 1
    }
  },
  Team = {
    Enabled = true,
    ShowRoleIcons = false,
    Growth = {
      Enabled = false,
      MaxSize = 4,
      OnlyInCombat = true
    },
    Lifebars = {
      Enabled = true,
      OnlyInCombat = true
    },
    Leader = {
      Size = 50,
      Alpha = 1,
      DrawOnTop = false,
      OnlyWhenDead = false
    },
    Teammate = {
      Size = 24,
      Alpha = 1,
      OnlyWhenDead = false
    }
  },
  TreasureMaps = {
    Enabled = false,
    Size = 24,
    Alpha = 1
  },
  Waypoint = {
    Enabled = false,
    Size = 24,
    Alpha = 1
  },
  WorldEvent = {
    Enabled = false,
    Size = 50,
    Alpha = 1
  }
}
