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

--============================================================ player
local player = {
  x = 0,
  y = 0,
  speed = 300,
  xdir = 0,
  ydir = 0,
  model = model:new(),
  draw = function( self )
    g.push()
    g.translate( self.x, self.y )
    self.model:draw( 100 )
    g.pop()
  end,
  update = function( self, dt )
    self.x = self.x +( self.xdir * dt * self.speed )
    self.y = self.y +( self.ydir * dt * self.speed )
  end
}

do -- create player model
  local v1, v2, v3, v4 = player.model:addVertex( -1, -1, 0 ),
  player.model:addVertex( -1, 1, 0 ),
  player.model:addVertex( 1, 1, 0 ),
  player.model:addVertex( 1, -1, 0 )
  player.model:addLine( v1, v2 )
  player.model:addLine( v2, v3 )
  player.model:addLine( v3, v4 )
  player.model:addLine( v4, v1 )
end

--============================================================ shrooms
local shroomlist = {}
local shroom = {
  draw = function( self )
    --g.rectangle( "line", self.x, self.y, 10, 10 )
    g.push()
    g.translate( self.x, self.y )
    self.model:draw(1)
    g.pop()
  end
}
local shroom_mt = { __index = shroom }

for i = 1, 100 do
  local rnd = love.math.random
  local m = model:new()
  m:addVertex( rnd( 10 ), rnd( 10 ), rnd( 10 ))
  for n = 2, 7 do
    m:addVertex( rnd( 10 ), rnd( 10 ), rnd( 10 ))
    m:addLine( n-1, n )
  end
  local s = {
    x = rnd( 5000 ) - 2500,
    y = rnd( 5000 ) - 2500,
    model = m
  }
  setmetatable( s, shroom_mt )
  table.insert( shroomlist, s )
end

--============================================================ love
love.load = function()
  g.setBackgroundColor( colors.white )
  g.setLineStyle( "rough" )
  g.setLineWidth( 1 )
end

local angle = 0 -- temp/debug rotation of player

love.update = function( dt )
  dangle = ( dt * math.pi / 3 )
  angle = angle + dangle
  player:update( dt )
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

local keys = {
  ["a"] = function() player.xdir = -1 end,
  ["d"] = function() player.xdir = 1 end,
  ["w"] = function() player.ydir = -1 end,
  ["s"] = function() player.ydir = 1 end
}

love.keypressed = function( key )
  if type( keys[ key ]) == "function" then
    keys[ key ]()
    player.lastdir = key
  end
end

love.keyreleased = function( key )
  if key == player.lastdir then
    player.xdir = 0
    player.ydir = 0
  end
end  

love.draw = function()
  g.push()
  g.translate( 800 - love.mouse.getX(),
               800 - love.mouse.getY()) -- scale from mouse cursor
  g.scale( viewscale ) 
  g.translate( -player.x, -player.y )
  g.setLineWidth( 1.0 / viewscale ) -- keep lines 1px thick
  g.setColor( colors.black )
  player:draw()
  for i, shroom in ipairs( shroomlist ) do
    shroom:draw()
  end
  g.pop()
  --
  console.draw()
end
