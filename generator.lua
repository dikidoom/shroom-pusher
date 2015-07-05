local m = {}

local rnd = love.math.random

local function random_vertex( dimension ) -- test/debug return random vertex
  return { rnd( dimension ) - (dimension / 2),
           rnd( dimension ) - (dimension / 2),
           rnd( dimension ) -(dimension / 2) }
end

-- generators
-- generate lists of vertices
m.gen = {}

function m.gen.random( count, dimension )
  local result = {}
  for i = 0, count do
    table.insert( result, random_vertex( dimension ))
  end
  return result
end

function m.gen.circular( count, radius )
  local result = {}
  local frac = (math.pi * 2.0 ) / count
  for i = 0, count do
    table.insert( result, { math.cos( frac * i ) * radius,
                            math.sin( frac * i ) * radius,
                            0 })
  end
  return result
end

-- connectors
-- consume list of vertices and model
-- add vertices to model and connect them according to specific rules
m.con = {}

local function introduce( vlst, model )
  local is = {}
  for i, v in ipairs( vlst ) do
    is[i] = model:addVertex( unpack(v) )
  end
  return is
end

function m.con.first2rest( vlst, model )
  local is = introduce( vlst, model )
  for i = 2, #is do
    model:addLine( is[1], is[i] )
  end
  return model
end

function m.con.loop( vlst, model )
  local is = introduce( vlst, model )
  for i = 2, #is do
    model:addLine( is[i-1], is[i] )
  end  
  model:addLine( is[#is], is[1] )
  return model
end

return m
