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

local cube = {
  { -1, 1, -1 },
  { 1, 1, -1 },
  { 1, -1, -1 },
  { -1, -1, -1 },
  { -1, -1, 1 },
  { 1, -1, 1 },
  { 1, 1, 1 },
  { -1, 1, 1 }}

local function draw3d( obj, scale )
  lst = {}
  for i = 1, #obj-1 do
    v1, v2 = obj[i], obj[i+1]
    g.line( v1[1] * scale, v1[2] * scale,
            v2[1] * scale, v2[2] * scale )
  end
end

local function rotateObject( lst, angle )
  ret = {}
  for i, vec in pairs( lst ) do
    table.insert( ret, matrix.rotate( vec, angle ))
  end
  return ret
end

local fpsize = 300
local fatplane = model.new()
for i = 1, fpsize, 1 do
  v1, v2 = fatplane:addVertex({ 1, 0, i }), fatplane:addVertex({ fpsize, 0, i })
  fatplane:addLine( v1, v2 )
  v1, v2 = fatplane:addVertex({ i, 1, 0 }), fatplane:addVertex({ i, fpsize, 0 })
  fatplane:addLine( v1, v2 )
  v1, v2 = fatplane:addVertex({ 0, i, 1 }), fatplane:addVertex({ 0, i, fpsize })
  fatplane:addLine( v1, v2 )
end

local test = model.new()
for i = 1, 100 do
  v1, v2 = test:addVertex({ i, 0, -i }), test:addVertex({ i, 100, -i })
  test:addLine( v1, v2 )
end

love.load = function()
  g.setBackgroundColor( colors.white )
  g.setLineStyle( "rough" )
  g.setLineWidth( 1 )
end

local angle = 0

love.update = function( dt )
  dangle = ( dt * math.pi / 3 )
  angle = angle + dangle
  fatplane:rotate({ dangle, dangle * .8, dangle * -.3 })
  test:rotate({ dangle, dangle / 3.0, 0 })
  cube1 = rotateObject( cube, { angle, 0, math.pi / 8 })
  cube2 = rotateObject( cube, { math.pi / 8, angle, 0 })
  cube3 = rotateObject( cube, { 0, math.pi / 8, angle })
end

love.draw = function()
  g.setColor( colors.black )

  -- 4 cubes
  g.push()
  g.translate( 200, 200 )
  draw3d( cube1, 100 )
  g.pop()

  g.push()
  g.translate( 600, 200 )
  draw3d( cube2, 100 )
  g.pop()

  g.push()
  g.translate( 200, 600 )
  draw3d( cube3, 100 )
  g.pop()

  -- a plane
  g.push()
  g.translate( 400, 400 )
  fatplane:draw( 2 )
  g.pop()

  -- testing model uniqueness
  g.push()
  g.translate( 200, 400 )
  test:draw( 2 )
  g.pop()

  console.draw()
end
