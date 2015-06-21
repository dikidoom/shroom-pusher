g = love.graphics

console = require( 'console' )
matrix = require( 'matrix' )

colors = {
  dark = { 20, 20, 20 },
  shady = { 40, 40, 40 },
  white = { 255, 255, 255 },
  red = { 156, 95, 80 },
  blue = { 99, 167, 194 }}

cube = {
  { -1, 1, -1 },
  { 1, 1, -1 },
  { 1, -1, -1 },
  { -1, -1, -1 },
  { -1, -1, 1 },
  { 1, -1, 1 },
  { 1, 1, 1 },
  { -1, 1, 1 }}

function draw3d( obj, scale )
  lst = {}
  --g.setColor( colors.white )
  -- for i, vec in pairs( obj ) do
  --   g.point( vec[1] * scale, vec[2] * scale )
  --   table.insert( lst, vec[1] * scale )
  --   table.insert( lst, vec[2] * scale )
  -- end
  --console.log( #lst )
  --g.setColor( colors.red )
  --g.line( lst )
  for i = 1, #obj-1 do
    v1, v2 = obj[i], obj[i+1]
    g.line( v1[1] * scale, v1[2] * scale,
            v2[1] * scale, v2[2] * scale )
  end
end

love.load = function()
  g.setLineStyle( "rough" )
  g.setLineWidth( 1 )
end

local angle = 0

love.update = function( dt )
  angle = angle +( dt * math.pi / 4 )
  cube1 = matrix.rotateObject( cube, { angle, 0, math.pi / 8 })
  cube2 = matrix.rotateObject( cube, { math.pi / 8, angle, 0 })
  cube3 = matrix.rotateObject( cube, { 0, math.pi / 8, angle })
end

love.draw = function()
  g.setColor( colors.white )
  --g.line( 0, 0, 200, 400, 750, 50 )
  --g.line({ 0, 10, 200, 410, 750, 60 })
  --g.rotate( love.mouse.getX() / 100 )
  --g.scale( 100 )
  g.setColor( colors.blue )
  --g.line({ -1, -1, 1, -1, 1, 1, 3, -3 })
  --g.line( 100, 100, 200, 110, 120, 100 )
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

  console.draw()
end
