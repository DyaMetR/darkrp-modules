AddCSLuaFile()

ENT.Type        = 'anim'
ENT.Base        = 'base_gmodentity'
ENT.PrintName   = 'Civil Protection Supply Locker'
ENT.Author      = 'DyaMetR'
ENT.Spawnable   = true
ENT.AdminOnly   = true
ENT.UseCooldown = 60

function ENT:Initialize()
  self:SetModel( 'models/props_c17/Lockers001a.mdl' )

  if SERVER then
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
    if IsValid( self:GetPhysicsObject() ) then
      self:GetPhysicsObject():EnableMotion( false )
    end
  end
end

if SERVER then

  function ENT:Use(activator, caller, use_type)

    if not activator:IsPlayer() then return end

    if not activator:isCP() or activator:isMayor() then
      DarkRP.notify(activator, NOTIFY_ERROR, 4, DarkRP.getPhrase('need_to_be_cp'))
      return
    end

    if activator.CPLockerCooldown and activator.CPLockerCooldown > CurTime() then
      DarkRP.notify(activator, NOTIFY_ERROR, 4, DarkRP.getPhrase('have_to_wait', math.ceil(activator.CPLockerCooldown - CurTime()), DarkRP.getPhrase('cp_locker')))
      return
    end

    -- apply cooldown
    activator.CPLockerCooldown = CurTime() + self.UseCooldown

    -- replenish ammo from extra weapons
    local replenished = activator:updatePoliceGearAmmo()

    -- replenish default class ammo
    local ammo = RPExtraTeams[activator:Team()].ammo
    if GetGlobalBool('DarkRP_LockDown') then table.Add(ammo, DarkRP.getLockdownTeam(activator:Team()).ammo) end
    if ammo then
      for ammo_type, amount in pairs(ammo) do
        if activator:GetAmmoCount(ammo_type) >= amount then continue end
        activator:SetAmmo(amount, ammo_type)
        replenished = true
      end
    end

    if replenished then
      DarkRP.notify(activator, NOTIFY_GENERIC, 4, DarkRP.getPhrase('cp_locker_ammo'))
    else
      if not DarkRP.isKevlarVestsInstalled then
        DarkRP.notify(activator, NOTIFY_ERROR, 4, DarkRP.getPhrase('cp_locker_full'))
      end
    end

    -- replace kevlar armour
    if not DarkRP.isKevlarVestsInstalled then return end

    local needs_kevlar = activator:getDarkRPVar('kevlar') < 100 or activator:getDarkRPVar('kevlar_type') ~= KEVLAR_POLICE

    if needs_kevlar then
      activator:setKevlar(KEVLAR_POLICE)
      DarkRP.notify( activator, NOTIFY_GENERIC, 4, DarkRP.getPhrase('cp_locker_armour'))
    end

    if not needs_kevlar and not replenished then
      DarkRP.notify(activator, NOTIFY_ERROR, 6, DarkRP.getPhrase('cp_locker_full_kev'))
    end
  end

end
