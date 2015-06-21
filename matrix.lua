-- Matrix Library
-- originally by Kjell of ZGameEditor-Forum Fame.
-- translated pretty much verbatim, including statefulness

m = {}

console = require( 'console' )

Matrix = {}
for m = 1, 6 do
  --console.log( "making matrix", m )
  Matrix[m] = {}
  for row = 1, 3 do
    Matrix[m][row] = {}
    for col = 1, 3 do
      Matrix[m][row][col] = 0
    end
  end
end

function RotationMatrixX( K, Angle )
  C = math.cos(Angle);
  S = math.sin(Angle);

  Matrix[K][1][1] = 1
  Matrix[K][1][2] = 0
  Matrix[K][1][3] = 0

  Matrix[K][2][1] = 0
  Matrix[K][2][2] = C
  Matrix[K][2][3] = S*-1

  Matrix[K][3][1] = 0
  Matrix[K][3][2] = S
  Matrix[K][3][3] = C
end

function RotationMatrixY( K, Angle)
  C = math.cos(Angle)
  S = math.sin(Angle)

  Matrix[K][1][1] = C
  Matrix[K][1][2] = 0
  Matrix[K][1][3] = S

  Matrix[K][2][1] = 0
  Matrix[K][2][2] = 1
  Matrix[K][2][3] = 0

  Matrix[K][3][1] = S*-1
  Matrix[K][3][2] = 0
  Matrix[K][3][3] = C
end

function RotationMatrixZ( K, Angle)
  C = math.cos(Angle);
  S = math.sin(Angle);
 
  Matrix[K][1][1] = C
  Matrix[K][1][2] = S*-1
  Matrix[K][1][3] = 0
 
  Matrix[K][2][1] = S
  Matrix[K][2][2] = C
  Matrix[K][2][3] = 0
 
  Matrix[K][3][1] = 0
  Matrix[K][3][2] = 0
  Matrix[K][3][3] = 1
end

-- //

function MultiplyMatrix( K, A, B )
  Matrix[K][1][1] = Matrix[A][1][1]*Matrix[B][1][1]+Matrix[A][1][2]*Matrix[B][2][1]+Matrix[A][1][3]*Matrix[B][3][1]
  Matrix[K][1][2] = Matrix[A][1][1]*Matrix[B][1][2]+Matrix[A][1][2]*Matrix[B][2][2]+Matrix[A][1][3]*Matrix[B][3][2]
  Matrix[K][1][3] = Matrix[A][1][1]*Matrix[B][1][3]+Matrix[A][1][2]*Matrix[B][2][3]+Matrix[A][1][3]*Matrix[B][3][3]
 
  Matrix[K][2][1] = Matrix[A][2][1]*Matrix[B][1][1]+Matrix[A][2][2]*Matrix[B][2][1]+Matrix[A][2][3]*Matrix[B][3][1]
  Matrix[K][2][2] = Matrix[A][2][1]*Matrix[B][1][2]+Matrix[A][2][2]*Matrix[B][2][2]+Matrix[A][2][3]*Matrix[B][3][2]
  Matrix[K][2][3] = Matrix[A][2][1]*Matrix[B][1][3]+Matrix[A][2][2]*Matrix[B][2][3]+Matrix[A][2][3]*Matrix[B][3][3]

  Matrix[K][3][1] = Matrix[A][3][1]*Matrix[B][1][1]+Matrix[A][3][2]*Matrix[B][2][1]+Matrix[A][3][3]*Matrix[B][3][1]
  Matrix[K][3][2] = Matrix[A][3][1]*Matrix[B][1][2]+Matrix[A][3][2]*Matrix[B][2][2]+Matrix[A][3][3]*Matrix[B][3][2]
  Matrix[K][3][3] = Matrix[A][3][1]*Matrix[B][1][3]+Matrix[A][3][2]*Matrix[B][2][3]+Matrix[A][3][3]*Matrix[B][3][3]
end

-- //

function Rotate(VX, VY, VZ, AX, AY, AZ)
  RotationMatrixX(2,AX)
  RotationMatrixY(3,AY)
  RotationMatrixZ(4,AZ)
 
  MultiplyMatrix(5,2,3)
  MultiplyMatrix(6,5,4)
 
  Matrix[1][1][1] = VX*Matrix[6][1][1]+VY*Matrix[6][1][2]+VZ*Matrix[6][1][3]
  Matrix[1][2][1] = VX*Matrix[6][2][1]+VY*Matrix[6][2][2]+VZ*Matrix[6][2][3]
  Matrix[1][3][1] = VX*Matrix[6][3][1]+VY*Matrix[6][3][2]+VZ*Matrix[6][3][3]
end

function m.rotate( vector, angle )
  Rotate( vector[1],
          vector[2],
          vector[3],
          angle[1],
          angle[2],
          angle[3])
  return { Matrix[1][1][1],
           Matrix[1][2][1],
           Matrix[1][3][1] }
end

function m.rotateObject( lst, angle )
  ret = {}
  for i, vec in pairs( lst ) do
    table.insert( ret, m.rotate( vec, angle ))
  end
  return ret
end

-- testing
xorig = { 0, 1, 0 }
xnew = m.rotate( xorig, { math.pi, 0, 0 })
console.log( "rotating around x " .. xnew[1] .. " " .. xnew[2] .. " " .. xnew[3])
xorig = { 0, 0, 1 }
xnew = m.rotate( xorig, { 0, math.pi, 0 })
console.log( "rotating around y " .. xnew[1] .. " " .. xnew[2] .. " " .. xnew[3])
xorig = { 1, 0, 0 }
xnew = m.rotate( xorig, { 0, 0, math.pi })
console.log( "rotating around y " .. xnew[1] .. " " .. xnew[2] .. " " .. xnew[3])

return m
