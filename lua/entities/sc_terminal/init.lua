include( 'shared.lua' )
AddCSLuaFile( 'shared.lua' )
AddCSLuaFile( 'cl_init.lua' )

local NET_MENU = 'sc_terminal_menu'
local NET_BUY = 'sc_terminal_buy'
local DISTANCE = 200
local DELAY = 1.5

-- add network strings
util.AddNetworkString( NET_MENU )
util.AddNetworkString( NET_BUY )

--[[---------------------------------------------------------------------------
  Makes a player buy an ingredient
  @param {Player} player
  @param {string} ingredient to buy
]]-----------------------------------------------------------------------------
function ENT:buyIngredient(_player, ingredient)
  if _player.nextDrugIngredBuy and _player.nextDrugIngredBuy > CurTime() then return end
  -- check that the player isn't cheating
  if not _player:GetEyeTrace().Hit or _player:GetEyeTrace().Entity ~= self or self:GetPos():Distance( _player:GetPos() ) > DISTANCE then
    return
  end
  -- check that the player hasn't spawned too many ingredients
  if _player.drugIngredientCount and _player.drugIngredientCount >= GAMEMODE.Config.maxDrugIngredients then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('limit', DarkRP.getPhrase('drug_ingredients')))
    return
  end

  -- get ingredient data
  local data = DarkRP.getIngredient(ingredient)

  -- check whether the player can afford it
  if _player:getDarkRPVar('money') < data.price then
    DarkRP.notify(_player, NOTIFY_ERROR, 4, DarkRP.getPhrase('cant_afford', data.name))
    return
  end

  -- pay
  _player:addMoney(-data.price)
  DarkRP.notify(_player, NOTIFY_GENERIC, 4, DarkRP.getPhrase('you_bought', data.name, DarkRP.formatMoney(data.price)))

  -- trace player view
  local _trace = {
    start = _player:EyePos(),
    endpos = _player:EyePos() + (_player:GetAimVector() * 40),
    filter = _player
  }
  local trace = util.TraceLine(_trace)

  -- spawn ingredient
  local ent = ents.Create('spawned_ingredient')
  ent.class = ingredient
  ent.itemPhrase = data.name
  ent:SetModel(data.model)
  ent:SetPos(trace.HitPos)
  ent:Setowning_ent(_player)
  ent:Spawn()

  -- increase ingredient count
  if not _player.drugIngredientCount then _player.drugIngredientCount = 0 end
  _player.drugIngredientCount = _player.drugIngredientCount + 1

  -- apply delay
  _player.nextDrugIngredBuy = CurTime() + DELAY
end

-- receive food to make
net.Receive( NET_BUY, function( len, _player )
  local ent = net.ReadEntity()
  local ingredient = net.ReadString()
  if not IsValid( ent ) or ent:GetClass() ~= 'sc_terminal' then return end
  ent:buyIngredient(_player, ingredient)
end )

-- load menu
function ENT:Use(activator, caller, use_type)
  net.Start(NET_MENU)
  net.WriteEntity(self)
  net.Send(activator)
end
