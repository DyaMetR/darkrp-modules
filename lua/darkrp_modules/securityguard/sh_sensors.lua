--[[---------------------------------------------------------------------------
  Motion sensor synchronization
]]-----------------------------------------------------------------------------

local NET = 'securityguard_motion'

if SERVER then

  local Player = FindMetaTable('Player')
  local CLASSNAME = 'sg_sensor'

  DarkRP.addPhrase('en', 'guard_sensor_destroyed', 'Your motion sensor has been destroyed!')

  util.AddNetworkString(NET)

  --[[---------------------------------------------------------------------------
    Wipes all sensors
  ]]-----------------------------------------------------------------------------
  function Player:cleanUpSensors()
    for _, ent in pairs(ents.GetAll()) do
      if ent:GetClass() ~= CLASSNAME or ent:Getowning_ent() ~= self then continue end
      ent:Remove()
    end
  end

  --[[---------------------------------------------------------------------------
    Detect motion sensor spawning
    @param {Player} owner
    @param {Entity} entity
  ]]-----------------------------------------------------------------------------
  hook.Add('OnEntityCreated', 'securityguard_motion_spawn', function(ent)
    if ent:GetClass() ~= CLASSNAME then return end

    timer.Simple(0.1, function()
      if not IsValid(ent) then return end
      net.Start(NET)
      net.WriteFloat(ent:EntIndex())
      net.WriteBool(false)
      net.Send(ent:Getowning_ent())
    end)
  end)

  --[[---------------------------------------------------------------------------
    Detect motion sensor removal
    @param {Entity} entity
  ]]-----------------------------------------------------------------------------
  hook.Add('EntityRemoved', 'securityguard_motion_remove', function(ent)
    if ent:GetClass() ~= CLASSNAME or not IsValid(ent:Getowning_ent()) then return end

    net.Start(NET)
    net.WriteFloat(ent:EntIndex())
    net.WriteBool(true)
    net.Send(ent:Getowning_ent())
  end)

end

if CLIENT then

  local sensors = {}
  local sorted_sensors = {}

  --[[---------------------------------------------------------------------------
    Gets all of the spawned motion sensors
    @return {table} motion sensors
  ]]-----------------------------------------------------------------------------
  function DarkRP.getMotionSensors()
    return sorted_sensors
  end

  --[[---------------------------------------------------------------------------
    Receive sensor spawn/removal
  ]]-----------------------------------------------------------------------------
  net.Receive(NET, function(len)
    local index = net.ReadFloat()
    local remove = net.ReadBool()

    hook.Run('securitySensorUpdated', index, remove)

    if remove then
      sensors[index] = nil
    else
      sensors[index] = index
    end

    sorted_sensors = table.SortByKey(sensors, true)
  end)

end
