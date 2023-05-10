--[[---------------------------------------------------------------------------
  Visual effects
]]-----------------------------------------------------------------------------

local _alcohol = 0
local _hangover = 0
local colour = {
  [ '$pp_colour_addr' ] = 0,
	[ '$pp_colour_addg' ] = 0,
	[ '$pp_colour_addb' ] = 0,
	[ '$pp_colour_brightness' ] = 0,
	[ '$pp_colour_contrast' ] = 1,
	[ '$pp_colour_colour' ] = 1,
	[ '$pp_colour_mulr' ] = 0,
	[ '$pp_colour_mulg' ] = 0,
	[ '$pp_colour_mulb' ] = 0
}

hook.Add('RenderScreenspaceEffects', 'alcoholmod_effects', function()
  local overdose = GAMEMODE.Config.alcoholOverdose

  -- get values
  local alcohol, hangover = LocalPlayer():getDarkRPVar( 'alcohol' ) or 0, LocalPlayer():getDarkRPVar( 'hangover' ) or 0
  alcohol, hangover = math.min(alcohol * 1.25, 100), math.min(hangover * 1.25, 100)

  -- animate effects
  _alcohol = Lerp( 0.01, _alcohol, ( alcohol - overdose ) / ( 100 - overdose )  )
  _hangover = Lerp( 0.01, _hangover, ( hangover - overdose ) / ( 100 - overdose ) )

  -- draw alcohol intoxication
  if _alcohol > .01 then
    colour[ '$pp_colour_contrast' ] = 1 - ( 0.4 * _alcohol )
    DrawColorModify( colour )
    DrawMotionBlur( 0.02, 0.99 * _alcohol, 0.01 )
  end

  -- draw hangover
  if _hangover > .01 then
    DrawSharpen( 2.5 * _hangover, 1.5 * _hangover )
  end
end)
