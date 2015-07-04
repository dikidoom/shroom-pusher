local m = {}

local matrix = require( 'matrix' )

local function draw( self, scale )
  for i = 1, #self.lines do
    local l = self.lines[i] 
    local v1, v2 = self.vertices[l[1]], self.vertices[l[2]]
    p1x, p1y = v1[1], v1[2]
    p2x, p2y = v2[1], v2[2]
    love.graphics.line( p1x * scale, 
                        p1y * scale, 
                        p2x * scale, 
                        p2y * scale )
  end
end

local function addVertex( self, v1, v2, v3 )
  table.insert( self.vertices, {v1, v2, v3})
  return #self.vertices
end

local function addLine( self, i1, i2 )
  table.insert( self.lines, {i1, i2})
  return #self.lines
end

local function rotate( self, a1, a2, a3 )
  lst = {}
  for i = 1, #self.vertices do
    table.insert( lst, matrix.rotate( self.vertices[i], {a1, a2, a3} ))
  end
  self.vertices = lst
end

function m.new()
  return {
    ["vertices"] = {},
    ["lines"] = {},
    ["draw"] = draw,
    ["addVertex"] = addVertex,
    ["addLine"] = addLine,
    ["rotate"] = rotate
  }
end

return m
