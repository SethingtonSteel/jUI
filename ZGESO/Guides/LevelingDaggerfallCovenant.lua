local ZGV = _G.ZGV
if ZGV:DoMutex("LevelingDC") then return end
if ZGV.Utils.GetFaction() ~= "DC" and not ZGV.CFG_LOAD_ALL_FACTIONS then return end
ZGV.GuideMenuTier = "TAM"
