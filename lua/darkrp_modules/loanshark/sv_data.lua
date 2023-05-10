--[[---------------------------------------------------------------------------
  Rewrite DarkRP's function to store money in order to allow for negative
  values
  https://github.com/FPtje/DarkRP/blob/master/gamemode/modules/base/sv_data.lua
]]-----------------------------------------------------------------------------

function DarkRP.storeMoney(ply, amount)
    if not isnumber(amount) or amount >= 1 / 0 then return end

    -- Also keep deprecated UniqueID data at least somewhat up to date
    MySQLite.query([[UPDATE darkrp_player SET wallet = ]] .. amount .. [[ WHERE uid = ]] .. ply:UniqueID() .. [[ OR uid = ]] .. ply:SteamID64())
end
