--[[---------------------------------------------------------------------------
  Register kevlar variables and kevlar types
]]-----------------------------------------------------------------------------

KEVLAR_NONE = -1 -- default kevlar state

local kevlar_types = {}

--[[---------------------------------------------------------------------------
  Registers a kevlar type
  @param {table} kevlar data
  @return {number} position in table
]]-----------------------------------------------------------------------------
function DarkRP.addKevlarType(data)
  local ap = data.ap or 1
  local torso = data.torso or 0
  local head = data.head or 0
  local removeOnEmpty = data.removeOnEmpty

  local kevlar_type = { ap = ap, torso = torso, head = head }

  if CLIENT then
    kevlar_type.icon = data.icon
  end

  if SERVER then
    kevlar_type.removeOnEmpty = removeOnEmpty
  end

  return table.insert(kevlar_types, kevlar_type)
end

--[[---------------------------------------------------------------------------
  Gets the protection data of a kevlar vest type
  @return {table} kevlar type data
]]-----------------------------------------------------------------------------
function DarkRP.getKevlarType(kevlar_type)
  return kevlar_types[kevlar_type]
end


DarkRP.DARKRP_LOADING = true

  -- register variables
  DarkRP.registerDarkRPVar('kevlar', net.WriteFloat, net.ReadFloat)
  DarkRP.registerDarkRPVar('kevlar_type', fp{fn.Flip(net.WriteInt), 16}, fp{net.ReadInt, 16})

  -- add phrases
  DarkRP.addPhrase('en', 'kevlar_replace', 'You replaced your kevlar vest.')
  DarkRP.addPhrase('en', 'kevlar_cannot_replace', 'You are already wearing this armour type on optimal condition.')

  -- add kevlar types
  KEVLAR_CIVILIAN = DarkRP.addKevlarType({ ap = 2.5, torso = 40, removeOnEmpty = true })
  KEVLAR_ADVANCED = DarkRP.addKevlarType({ ap = 1.75, torso = 60, removeOnEmpty = true, icon = Material('icon16/shield_go.png') })
  KEVLAR_POLICE = DarkRP.addKevlarType({ ap = 2, torso = 75, head = 50, icon = Material('icon16/shield_add.png') })
  KEVLAR_CONTRABAND = DarkRP.addKevlarType({ ap = 3.5, torso = 80, head = 33, icon = Material('icon16/shield_delete.png') })

DarkRP.DARKRP_LOADING = nil
