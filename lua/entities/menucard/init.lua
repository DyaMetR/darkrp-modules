include('shared.lua')
include('commands.lua')
include('settings.lua')
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
AddCSLuaFile('commands.lua')
AddCSLuaFile('settings.lua')

-- reduce count on removal
function ENT:OnRemove()
  local ply = self:Getowning_ent()
  ply.maxMenuCards = ply.maxMenuCards and ply.maxMenuCards - 1 or 0
end

-- popup the menu for the activator
function ENT:Use(activator, caller, use_type)
  if self.NextUse and self.NextUse > CurTime() then return end
  net.Start('darkrp_menucard')
  net.WriteEntity(self:Getowning_ent())
  net.WriteEntity(self)
  net.WriteTable(self:Getowning_ent().CookMenuCard)
  net.Send(activator)
  self.NextUse = CurTime() + 1
end

--[[---------------------------------------------------------------------------
  Gamemode related functions and hooks
]]-----------------------------------------------------------------------------
util.AddNetworkString('darkrp_menucard')
local Player = FindMetaTable('Player')

--[[---------------------------------------------------------------------------
  Removes all menu cards related to this player
]]-----------------------------------------------------------------------------
function Player:removeAllMenuCards()
  for _, menucard in pairs(ents.GetAll()) do
    if menucard.Getowning_ent and menucard:Getowning_ent() == self and menucard:GetClass() == 'menucard' then
      menucard:Remove()
    end
  end
end

-- setup on team change
hook.Add('PlayerChangedTeam', 'menucard_spawn', function(_player, oldTeam, newTeam)
  -- delete old menu cards
  if oldTeam == TEAM_COOK and newTeam ~= TEAM_COOK then
    _player:removeAllMenuCards()
  end
  -- setup data
  if newTeam ~= TEAM_COOK or _player.CookMenuCard then return end
  _player.CookMenuCard = {
    label = nil, -- if nil, it'll be set to default on the client
    prices = {}
  }
end)

-- remove menu cards on disconnect
hook.Add('PlayerDisconnected', 'menucard_disconnect', function(_player)
  _player:removeAllMenuCards()
end)
