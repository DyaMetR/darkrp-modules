AddCSLuaFile()

DEFINE_BASECLASS('weaponchecker')
SWEP.Base         = 'weaponchecker'
SWEP.MinCheckTime = 2
SWEP.MaxCheckTime = 4
SWEP.Spawnable    = true
SWEP.AdminOnly    = true
SWEP.Category     = 'DarkRP (Utility)'

-- language
DarkRP.addPhrase('en', 'licensed_weapons', '%s\'s licensed weapons:')

-- print a list separated by commas
function SWEP:PrintList(list)
  local Owner = self:GetOwner()
  if not IsValid(Owner) then return end

  local result = table.concat(list, ', ')
  if string.len(result) >= 126 then
      local amount = math.ceil(string.len(result) / 126)
      for i = 1, amount, 1 do
          Owner:ChatPrint(string.sub(result, (i-1) * 126, i * 126 - 1))
      end
  else
      Owner:ChatPrint(result)
  end
end

-- display ilegal weapons and legal weapons separatedly
function SWEP:PrintWeapons(ent, weaponsFoundPhrase)
    local Owner = self:GetOwner()

    if not IsValid(Owner) then return end

    local weps = {} -- unlicensed or illegal weapons
    local legal = {} -- weapons that are legal under a license
    self:GetStrippableWeapons(ent, function(wep)
      local name = wep:GetPrintName() and language.GetPhrase(wep:GetPrintName()) or wep:GetClass()
      if ent:getDarkRPVar('HasGunlicense') and GAMEMODE.Config.licenseWeapons[wep:GetClass()] then
        table.insert(legal, name)
      else
        table.insert(weps, name)
      end
    end)

    -- no weapons found
    if #weps + #legal <= 0 then
      Owner:ChatPrint(DarkRP.getPhrase('no_illegal_weapons', ent:Nick()))
      return
    end

    -- licensed weapons found
    if #legal > 0 then
      Owner:ChatPrint(DarkRP.getPhrase('licensed_weapons', ent:Nick()))
      self:PrintList(legal)
    end

    -- illegal weapons found
    if #weps > 0 then
      Owner:ChatPrint(weaponsFoundPhrase)
      self:PrintList(weps)
    end

end

function SWEP:Succeed()
    if not IsValid(self:GetOwner()) then return end
    self:SetIsWeaponChecking(false)

    local trace = self:GetOwner():GetEyeTrace()
    local ent = trace.Entity
    if not IsValid(ent) or not ent:IsPlayer() then return end

    if CLIENT then
        if not IsFirstTimePredicted() then return end
        self:PrintWeapons(ent, DarkRP.getPhrase("confiscated_these_weapons"))
        return
    end

    local stripped = {}

    self:GetStrippableWeapons(ent, function(wep)
        if ent:getDarkRPVar('HasGunlicense') and GAMEMODE.Config.licenseWeapons[wep:GetClass()] then return end
        ent:StripWeapon(wep:GetClass())
        stripped[wep:GetClass()] = {
            class = wep:GetClass(),
            primaryAmmoCount = ent:GetAmmoCount(wep:GetPrimaryAmmoType()),
            primaryAmmoType = wep:GetPrimaryAmmoType(),
            secondaryAmmoCount = ent:GetAmmoCount(wep:GetSecondaryAmmoType()),
            secondaryAmmoType = wep:GetSecondaryAmmoType(),
            clip1 = wep:Clip1(),
            clip2 = wep:Clip2()
        }
    end)

    if not ent.ConfiscatedWeapons then
        if next(stripped) ~= nil then ent.ConfiscatedWeapons = stripped end
    else
        -- Merge stripped weapons into confiscated weapons
        for k,v in pairs(stripped) do
            if ent.ConfiscatedWeapons[k] then continue end

            ent.ConfiscatedWeapons[k] = v
        end
    end

    hook.Call("playerWeaponsConfiscated", nil, self:GetOwner(), ent, ent.ConfiscatedWeapons)

    if next(stripped) ~= nil then
        self:EmitSound("npc/combine_soldier/gear5.wav", 50, 100)
        self:SetNextSoundTime(CurTime() + 0.3)
    else
        self:EmitSound("ambient/energy/zap1.wav", 50, 100)
        self:SetNextSoundTime(0)
    end
end
