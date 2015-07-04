g = love.graphics

console = require( 'console' )
local matrix = require( 'matrix' )
local model = require( 'model' )

colors = {
  black = { 0, 0, 0 },
  dark = { 20, 20, 20 },
  shady = { 40, 40, 40 },
  white = { 255, 255, 255 },
  red = { 156, 95, 80 },
  blue = { 99, 167, 194 }}

local function rotateObject( lst, angle )
  ret = {}
  for i, vec in pairs( lst ) do
    table.insert( ret, matrix.rotate( vec, angle ))
  end
  return ret
end

local player = {
  x = 0,
  y = 0,
  model = model:new(),
  draw = function( self ) self.model:draw( 100 ) end
}

do
  local v1, v2, v3, v4 = player.model:addVertex( -1, -1, 0 ),
  player.model:addVertex( -1, 1, 0 ),
  player.model:addVertex( 1, 1, 0 ),
  player.model:addVertex( 1, -1, 0 )
  player.model:addLine( v1, v2 )
  player.model:addLine( v2, v3 )
  player.model:addLine( v3, v4 )
  player.model:addLine( v4, v1 )
end

love.load = function()
  g.setBackgroundColor( colors.white )
  g.setLineStyle( "rough" )
  g.setLineWidth( 1 )
end

local angle = 0 -- temp/debug rotation of player

love.update = function( dt )
  dangle = ( dt * math.pi / 3 )
  angle = angle + dangle
  player.model:rotate( 0, 0, dangle )
end

local viewscale = 1 -- scaling viewport

local mousebuttons = {
  ["wd"] = function() 
    viewscale = viewscale * 1.5
    --console.log( viewscale )
  end,
  ["wu"] = function() 
    viewscale = viewscale / 1.5
    --console.log( viewscale )
  end
}

love.mousepressed = function( x, y, button )
  if type( mousebuttons[ button ]) == "function" then
      mousebuttons[ button ]()
  end
end

love.draw = function()
  g.push()
  g.translate( 800 - love.mouse.getX(),
               800 - love.mouse.getY()) -- scale from mouse cursor
  g.scale( viewscale ) 
  g.setLineWidth( 1.0 / viewscale ) -- keep lines 1px thick
  g.setColor( colors.black )
  player:draw()
  g.pop()
  --
  console.draw()
end
