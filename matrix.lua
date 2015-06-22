-- Matrix Library
-- originally by Kjell of ZGameEditor-Forum Fame.
-- translated pretty much verbatim, including statefulness

local matrix = {}

console = require( 'console' )

TheMatrix = {}
for m = 1, 6 do
  --console.log( "making matrix", m )
  TheMatrix[m] = {}
  for row = 1, 3 do
    TheMatrix[m][row] = {}
    for col = 1, 3 do
      TheMatrix[m][row][col] = 0
    end
  end
end

function RotationMatrixX( K, Angle )
  C = math.cos(Angle);
  S = math.sin(Angle);

  TheMatrix[K][1][1] = 1
  TheMatrix[K][1][2] = 0
  TheMatrix[K][1][3] = 0

  TheMatrix[K][2][1] = 0
  TheMatrix[K][2][2] = C
  TheMatrix[K][2][3] = S*-1

  TheMatrix[K][3][1] = 0
  TheMatrix[K][3][2] = S
  TheMatrix[K][3][3] = C
end

function RotationMatrixY( K, Angle)
  C = math.cos(Angle)
  S = math.sin(Angle)

  TheMatrix[K][1][1] = C
  TheMatrix[K][1][2] = 0
  TheMatrix[K][1][3] = S

  TheMatrix[K][2][1] = 0
  TheMatrix[K][2][2] = 1
  TheMatrix[K][2][3] = 0

  TheMatrix[K][3][1] = S*-1
  TheMatrix[K][3][2] = 0
  TheMatrix[K][3][3] = C
end

function RotationMatrixZ( K, Angle)
  C = math.cos(Angle);
  S = math.sin(Angle);
  
  TheMatrix[K][1][1] = C
  TheMatrix[K][1][2] = S*-1
  TheMatrix[K][1][3] = 0
  
  TheMatrix[K][2][1] = S
  TheMatrix[K][2][2] = C
  TheMatrix[K][2][3] = 0
  
  TheMatrix[K][3][1] = 0
  TheMatrix[K][3][2] = 0
  TheMatrix[K][3][3] = 1
end

-- //

function MultiplyMatrix( K, A, B )
  TheMatrix[K][1][1] = TheMatrix[A][1][1]*TheMatrix[B][1][1]+TheMatrix[A][1][2]*TheMatrix[B][2][1]+TheMatrix[A][1][3]*TheMatrix[B][3][1]
  TheMatrix[K][1][2] = TheMatrix[A][1][1]*TheMatrix[B][1][2]+TheMatrix[A][1][2]*TheMatrix[B][2][2]+TheMatrix[A][1][3]*TheMatrix[B][3][2]
  TheMatrix[K][1][3] = TheMatrix[A][1][1]*TheMatrix[B][1][3]+TheMatrix[A][1][2]*TheMatrix[B][2][3]+TheMatrix[A][1][3]*TheMatrix[B][3][3]
  
  TheMatrix[K][2][1] = TheMatrix[A][2][1]*TheMatrix[B][1][1]+TheMatrix[A][2][2]*TheMatrix[B][2][1]+TheMatrix[A][2][3]*TheMatrix[B][3][1]
  TheMatrix[K][2][2] = TheMatrix[A][2][1]*TheMatrix[B][1][2]+TheMatrix[A][2][2]*TheMatrix[B][2][2]+TheMatrix[A][2][3]*TheMatrix[B][3][2]
  TheMatrix[K][2][3] = TheMatrix[A][2][1]*TheMatrix[B][1][3]+TheMatrix[A][2][2]*TheMatrix[B][2][3]+TheMatrix[A][2][3]*TheMatrix[B][3][3]

  TheMatrix[K][3][1] = TheMatrix[A][3][1]*TheMatrix[B][1][1]+TheMatrix[A][3][2]*TheMatrix[B][2][1]+TheMatrix[A][3][3]*TheMatrix[B][3][1]
  TheMatrix[K][3][2] = TheMatrix[A][3][1]*TheMatrix[B][1][2]+TheMatrix[A][3][2]*TheMatrix[B][2][2]+TheMatrix[A][3][3]*TheMatrix[B][3][2]
  TheMatrix[K][3][3] = TheMatrix[A][3][1]*TheMatrix[B][1][3]+TheMatrix[A][3][2]*TheMatrix[B][2][3]+TheMatrix[A][3][3]*TheMatrix[B][3][3]
end

-- //

function Rotate(VX, VY, VZ, AX, AY, AZ)
  RotationMatrixX(2,AX)
  RotationMatrixY(3,AY)
  RotationMatrixZ(4,AZ)
  
  MultiplyMatrix(5,2,3)
  MultiplyMatrix(6,5,4)
  
  TheMatrix[1][1][1] = VX*TheMatrix[6][1][1]+VY*TheMatrix[6][1][2]+VZ*TheMatrix[6][1][3]
  TheMatrix[1][2][1] = VX*TheMatrix[6][2][1]+VY*TheMatrix[6][2][2]+VZ*TheMatrix[6][2][3]
  TheMatrix[1][3][1] = VX*TheMatrix[6][3][1]+VY*TheMatrix[6][3][2]+VZ*TheMatrix[6][3][3]
end

function matrix.rotate( vector, angle )
  Rotate( vector[1],
          vector[2],
          vector[3],
          angle[1],
          angle[2],
          angle[3])
  return { TheMatrix[1][1][1],
           TheMatrix[1][2][1],
           TheMatrix[1][3][1] }
end

-- testing
-- xorig = { 0, 1, 0 }
-- xnew = m.rotate( xorig, { math.pi, 0, 0 })
-- console.log( "rotating around x " .. xnew[1] .. " " .. xnew[2] .. " " .. xnew[3])
-- xorig = { 0, 0, 1 }
-- xnew = m.rotate( xorig, { 0, math.pi, 0 })
-- console.log( "rotating around y " .. xnew[1] .. " " .. xnew[2] .. " " .. xnew[3])
-- xorig = { 1, 0, 0 }
-- xnew = m.rotate( xorig, { 0, 0, math.pi })
-- console.log( "rotating around y " .. xnew[1] .. " " .. xnew[2] .. " " .. xnew[3])

return matrix
