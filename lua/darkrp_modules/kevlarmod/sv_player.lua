--[[---------------------------------------------------------------------------
  Kevlar management and damage
]]-----------------------------------------------------------------------------

local Player = FindMetaTable( 'Player' )

--[[---------------------------------------------------------------------------
  Sets a kevlar type and restores the vest health
  @param {KEVLAR_} kevlar type
  @param {number|nil} armour points left
]]-----------------------------------------------------------------------------
function Player:setKevlar( kevlar_type, kevlar )
  self:setDarkRPVar( 'kevlar', kevlar or 100 )
  self:setDarkRPVar( 'kevlar_type', kevlar_type )
end

--[[---------------------------------------------------------------------------
  Removes the current kevlar armour
]]-----------------------------------------------------------------------------
function Player:removeKevlar()
  self:setDarkRPVar( 'kevlar', 0 )
  self:setDarkRPVar( 'kevlar_type', KEVLAR_NONE )
end
