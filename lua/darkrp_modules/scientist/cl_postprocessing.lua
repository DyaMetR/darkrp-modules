
-- constants
local COCAINE = 'cocaine'
local METH = 'meth'
local WEED = 'weed'
local HEROIN = 'heroin'
local MUSHROOM = 'mushroom'
local LSD = 'lsd'
local WALLHACK_ENTS = {
  ['player'] = true,
  ['money_printer'] = true,
  ['spawned_shipment'] = true,
  ['spawned_weapon'] = true,
  ['microwave'] = true,
  ['drug_lab'] = true,
  ['gun_lab'] = true,
  ['sc_terminal'] = true,
  ['sc_acetylator'] = true,
  ['sc_methlab'] = true,
  ['sc_diluent'] = true
}
local WALLHACK_RANGE = 500

-- variables
local cocaine = 0
local meth = 0
local weed = 0
local heroin = 0
local mushroom = 0
local lsd = 0
local acidtrip = 0 -- blood darken amount
local blinked = false -- whether the darken value should decrease
local acidTick = 0

--[[---------------------------------------------------------------------------
  Adds an entity to be seen through the wallhack type drugs
  @param {string} entity class
]]-----------------------------------------------------------------------------
function DarkRP.addDrugWallhackEntClass(ent_class)
  WALLHACK_ENTS[ent_class] = true
end

--[[---------------------------------------------------------------------------
  Animates and renders the cocaine post processing effects
]]-----------------------------------------------------------------------------
local function CocainePostProcessing()
  local has_cocaine = DarkRP.getActiveStatus(COCAINE)
  -- animate
  if has_cocaine then
    cocaine = Lerp(.2, cocaine, 1)
  else
    cocaine = Lerp(.001, cocaine, 0)
  end
  if cocaine < .01 then return end
  -- colour modify
  local tab = {
    ['$pp_colour_addr'] = 0,
    ['$pp_colour_addg'] = 0,
    ['$pp_colour_addb'] = 0,
    ['$pp_colour_brightness'] = -.15 * cocaine,
    ['$pp_colour_contrast'] = 1 + cocaine,
    ['$pp_colour_colour'] = 1 - (.5 * cocaine),
    ['$pp_colour_mulr'] = 0,
    ['$pp_colour_mulg'] = 0,
    ['$pp_colour_mulb'] = 0
  }
  DrawColorModify(tab)
  -- do post processing
  DrawMotionBlur( 1 - (.5 * cocaine), .9, .01 )
  DrawSharpen( 3 * cocaine, .5 )
end

--[[---------------------------------------------------------------------------
  Animates and renders the meth post processing effects
]]-----------------------------------------------------------------------------
local function MethPostProcessing()
  local has_meth = DarkRP.getActiveStatus(METH)
  -- animate
  if has_meth then
    meth = Lerp(.01, meth, 1)
  else
    meth = Lerp(.01, meth, 0)
  end
  if meth < .01 then return end
  -- colour modify
  local tab = {
  	['$pp_colour_addr'] = 0,
  	['$pp_colour_addg'] = 0,
  	['$pp_colour_addb'] = 0,
  	['$pp_colour_brightness'] = -.15 * meth,
  	['$pp_colour_contrast'] = 1 + (.64 * meth),
  	['$pp_colour_colour'] = 1 - (.25 * meth),
  	['$pp_colour_mulr'] = 0,
  	['$pp_colour_mulg'] = 0,
  	['$pp_colour_mulb'] = 0
  }
  DrawColorModify(tab)
  -- do post processing
  DrawMotionBlur( 1 - (.7 * meth), .9, .01 )
  DrawSharpen( 2 * meth, .5 )
end

--[[---------------------------------------------------------------------------
  Animates and renders the weed post processing effects
]]-----------------------------------------------------------------------------
local function WeedPostProcessing()
  local has_weed = DarkRP.getActiveStatus(WEED)
  -- animate
  if has_weed then
    weed = Lerp(.001, weed, 1)
  else
    weed = Lerp(.01, weed, 0)
  end
  if weed < .01 then return end
  -- colour modify
  local tab = {
  	['$pp_colour_addr'] = 0,
  	['$pp_colour_addg'] = 0,
  	['$pp_colour_addb'] = 0,
  	['$pp_colour_brightness'] = 0,
  	['$pp_colour_contrast'] = 1 - (.15 * weed),
  	['$pp_colour_colour'] = 1 + weed,
  	['$pp_colour_mulr'] = 0,
  	['$pp_colour_mulg'] = 0,
  	['$pp_colour_mulb'] = 0
  }
  DrawColorModify(tab)
  -- do post processing
  DrawMotionBlur( .02, .62 * weed, .01 )
  DrawSharpen( 5 * weed, .5 )
end

--[[---------------------------------------------------------------------------
  Animates and renders the heroin post processing effects
]]-----------------------------------------------------------------------------
local function HeroinPostProcessing()
  local has_heroin = DarkRP.getActiveStatus(HEROIN)
  -- animate
  if has_heroin then
    heroin = Lerp(.01, heroin, 1)
  else
    heroin = Lerp(.001, heroin, 0)
  end
  if heroin < .01 then return end
  -- colour modify
  local tab = {
    ['$pp_colour_addr'] = 0,
    ['$pp_colour_addg'] = 0,
    ['$pp_colour_addb'] = 0,
    ['$pp_colour_brightness'] = 0.1 * heroin,
    ['$pp_colour_contrast'] = 1 - (.4 * heroin),
    ['$pp_colour_colour'] = 1 - (.4 * heroin),
    ['$pp_colour_mulr'] = 0,
    ['$pp_colour_mulg'] = 0,
    ['$pp_colour_mulb'] = 0
  }
  DrawColorModify(tab)
  -- do post processing
  DrawMotionBlur( .1, .8 * heroin, .01 )
end

--[[---------------------------------------------------------------------------
  Animates and renders the mushroom post processing effects
]]-----------------------------------------------------------------------------
local function MushroomPostProcessing()
  local has_mushroom = DarkRP.getActiveStatus(MUSHROOM)
  -- animate
  if has_mushroom then
    mushroom = Lerp(.01, mushroom, 1)
  else
    mushroom = Lerp(.01, mushroom, 0)
  end
  if mushroom < .01 then return end
  -- colour modify
  local tab = {
    ['$pp_colour_addr'] = 0,
    ['$pp_colour_addg'] = 0,
    ['$pp_colour_addb'] = 0,
    ['$pp_colour_brightness'] = -0.1 * mushroom,
    ['$pp_colour_contrast'] = 1 + (2 * mushroom),
    ['$pp_colour_colour'] = 1 - (.1 * mushroom),
    ['$pp_colour_mulr'] = 0,
    ['$pp_colour_mulg'] = 0,
    ['$pp_colour_mulb'] = 0
  }
  DrawColorModify(tab)
  -- do post processing
  DrawMotionBlur( .25, .6 * mushroom, .01 )
end

--[[---------------------------------------------------------------------------
  Animates and renders the LSD post processing effects
]]-----------------------------------------------------------------------------
local function LSDPostProcessing()
  local has_lsd = DarkRP.getActiveStatus(LSD)
  -- animate
  if has_lsd then
    lsd = Lerp(.001, lsd, 1)
  else
    lsd = Lerp(.001, lsd, 0)
  end
  if lsd < .01 then return end

  -- animate acid trip
  if acidTick < CurTime() then
    if blinked then
      if acidtrip > 0 then
        acidtrip = math.max(acidtrip - .001, 0)
      else
        blinked = false
      end
    else
      if acidtrip < 1 then
        acidtrip = math.min(acidtrip + .001, 1)
      else
        blinked = true
      end
    end
    acidTick = CurTime() + .01
  end

  -- do post processing
  DrawMotionBlur( .3, .8 * lsd, .04 )
  DrawBloom(acidtrip, 5 * lsd, 1, 1, 0, 20 * lsd, lsd, lsd, lsd)

  -- colour modify
  local tab = {
  	['$pp_colour_addr'] = 0,
  	['$pp_colour_addg'] = 0,
  	['$pp_colour_addb'] = 0,
  	['$pp_colour_brightness'] = -1 * lsd,
  	['$pp_colour_contrast'] = 1 + (3 * lsd),
  	['$pp_colour_colour'] = 1 + (4 * lsd),
  	['$pp_colour_mulr'] = 1,
  	['$pp_colour_mulg'] = 1,
  	['$pp_colour_mulb'] = 1
  }
  DrawColorModify(tab)
end

--[[---------------------------------------------------------------------------
  Render all effects
]]-----------------------------------------------------------------------------
hook.Add('RenderScreenspaceEffects', 'drugs_postprocess', function()
  CocainePostProcessing()
  MethPostProcessing()
  WeedPostProcessing()
  HeroinPostProcessing()
  MushroomPostProcessing()
  LSDPostProcessing()
end)

--[[---------------------------------------------------------------------------
  Render drug wallhack
]]-----------------------------------------------------------------------------
hook.Add( 'PostDrawOpaqueRenderables', 'drugs_wallhack', function()
  local alpha = lsd
  if alpha <= 0.01 or not DarkRP.getActiveStatus(LSD) then return end

	-- Reset everything to known good
	render.SetStencilWriteMask( 0xFF )
	render.SetStencilTestMask( 0xFF )
	render.SetStencilReferenceValue( 0 )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.ClearStencil()

	-- Enable stencils
	render.SetStencilEnable( true )
	-- Set the reference value to 1. This is what the compare function tests against
	render.SetStencilReferenceValue( 1 )
	-- Always draw everything
	render.SetStencilCompareFunction( STENCIL_ALWAYS )
	-- If something would draw to the screen but is behind something, set the pixels it draws to 1
	render.SetStencilZFailOperation( STENCIL_REPLACE )

	-- Draw our entities. They will draw as normal
	for i, ent in ipairs( ents.GetAll() ) do
    if not WALLHACK_ENTS[ent:GetClass()] or (ent:IsPlayer() and not ent:Alive()) or LocalPlayer():GetPos():Distance(ent:GetPos()) > WALLHACK_RANGE then continue end
		ent:DrawModel()
	end

	-- Now, only draw things that have their pixels set to 1. This is the hidden parts of the stencil tests.
	render.SetStencilCompareFunction( STENCIL_EQUAL )
	-- Flush the screen. This will draw teal over all hidden sections of the stencil tests
	render.ClearBuffersObeyStencil(255 * alpha, 0, 0, 255 * alpha, false);

	-- Let everything render normally again
	render.SetStencilEnable( false )
end )
