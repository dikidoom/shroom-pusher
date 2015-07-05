g = love.graphics

console = require( 'console' )
local matrix = require( 'matrix' )
local model = require( 'model' )
local generator = require( 'generator' )

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
    g.push()
    g.translate( self.x, self.y )
    -- if self.finger then
    --   g.setColor( colors.red )
    -- else
    --   g.setColor( colors.black )
    -- end
    self.model:draw(1)
    g.translate( 20, 20 )
    --g.print( self.x .. ", " .. self.y )
    g.pop()
  end
}

local shroom_mt = { __index = shroom }

for i = 1, 100 do -- populate shrooms
  local rnd = love.math.random
  local m = model:new()
  local bush
  if rnd() > .5 then
    bush = generator.con.first2rest
  else
    bush = generator.con.pairs
  end
  bush( generator.gen.random( 10, 20 ), m )
  generator.con.loop( generator.gen.circular( 10, 20 ), m )
  local s = {
    --finger = false,
    x = rnd( 5000 ) - 2500,
    y = rnd( 5000 ) - 2500,
    model = m
  }
  setmetatable( s, shroom_mt )
  table.insert( shroomlist, s )
end

local function pick( x, y, tolerance )
  for i, shroom in ipairs( shroomlist ) do
    if (( x <= shroom.x + tolerance ) and
        ( x >= shroom.x - tolerance ) and
        ( y <= shroom.y + tolerance ) and
      ( y >= shroom.y - tolerance )) then
      return shroom
    end
  end
  return nil
end  

--============================================================ love
local finger = { -- store mouse position in world space
  x = 0,
  y = 0,
  dx = 0,
  dy = 0
}

love.load = function()
  g.setBackgroundColor( colors.white )
  g.setLineStyle( "rough" )
  g.setLineWidth( 1 )
end

local viewscale = 1 -- scaling viewport

local grab = { -- grab shrooms with finger
  grab = false,
  shroom = nil,
  xoffset = 0,
  yoffset = 0
}

local mousebuttons = {
  ["l"] = function()
    if not grab.grab then
      grab.grab = true
      local s = pick( finger.x, finger.y, 20 )
      if s then 
        grab.shroom = s 
        grab.xoffset = s.x - finger.x
        grab.yoffset = s.y - finger.y
      end
    end
  end,
  ["wd"] = function() 
    viewscale = math.min( viewscale * 3, 3 )
    --console.log( viewscale )
  end,
  ["wu"] = function() 
    viewscale = math.max( viewscale / 3, 1.0/9.0 )
    --console.log( viewscale )
  end
}

love.mousepressed = function( x, y, button )
  if type( mousebuttons[ button ]) == "function" then
      mousebuttons[ button ]()
  end
end

love.mousereleased = function()
  grab.grab = false
end

love.mousemoved = function( x, y, dx, dy )
  finger.x = player.x +((( x - 400 ) / viewscale ) * 2 ) -- *2 because view follows mouse
  finger.y = player.y +((( y - 400 ) / viewscale ) * 2 ) 
  finger.dx = dx / viewscale
  finger.dy = dy / viewscale
  --console.log( finger.x .. ", " .. finger.y )
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

local angle = 0 -- temp/debug rotation of player

love.update = function( dt )
  dangle = ( dt * math.pi / 3 )
  angle = angle + dangle
  player:update( dt )
  if ( grab.grab and grab.shroom ) then
    grab.shroom.x = finger.x + grab.xoffset
    grab.shroom.y = finger.y + grab.yoffset
  else
    local shroom = pick( finger.x, finger.y, 10 )
    if shroom then
      shroom.x = shroom.x + finger.dx * 2
      shroom.y = shroom.y + finger.dy * 2
      shroom.model:rotate( finger.dy / -10, 
                           finger.dx / 10, 0 )
    end
  end
  finger.dx = 0
  finger.dy = 0
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
