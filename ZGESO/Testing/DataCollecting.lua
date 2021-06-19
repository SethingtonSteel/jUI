-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local ZGV = _G.ZGV
local DataCollecting = {}
local tinsert = table.insert
local Testing = ZGV.Testing
local Data = ZGV.Data

-----------------------------------------
-- TESTS
-----------------------------------------

-- TODO could expand this to work for data based on faction and for objects and quests

function DataCollecting.TestNpcData()
  local function cleanUpTestAndReturn(pass,comment,...)
    comment = string.format(tostring(comment),...)

    return pass,comment
  end

  -- First npcid

  local nname = "The Prophet"
  local nid = 3360001

  local name = Data:GetNpcNameById(nid)
  if name ~= nname then
    return cleanUpTestAndReturn(false,"Npc name no match. %s~=%s",nname,tostring(name))
  end

  local id = Data:GetNpcIdByName(nname)
  if nid ~= id then
    return cleanUpTestAndReturn(false,"Npc id no match. %s~=%s",nid,tostring(id))
  end

  --Last npcid

  nname = "Gruzdash"
  nid = 3360012

  name = Data:GetNpcNameById(nid)
  if name ~= nname then
    return cleanUpTestAndReturn(false,"Npc name no match. %s~=%s",nname,tostring(name))
  end

  id = Data:GetNpcIdByName(nname)
  if nid~=id then
    return cleanUpTestAndReturn(false,"Npc id no match. %s~=%s",nid,tostring(id))
  end

  return cleanUpTestAndReturn(true)
end

-----------------------------------------
-- STARTUP
-----------------------------------------

tinsert(ZGV.startups,function(self)
    Testing:RegisterTestGroup("DataCollecting",DataCollecting)
  end)
