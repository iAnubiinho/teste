-- 3D Box Rendering Utility

-- Renders a rotated 3D box at the specified position with given dimensions and rotation
-- Parameters:
--   centerX, centerY, centerZ: Center position of the box
--   width, length, height: Dimensions of the box
--   rotation: Rotation angle in degrees around the Z axis
--   r, g, b, a: RGBA color values
function RenderRotatedBox(centerX, centerY, centerZ, width, length, height, rotation, r, g, b, a)
    local halfWidth = width / 2
    local halfLength = length / 2
    local halfHeight = height / 2
    local rotationRad = math.rad(rotation)
    
    -- Rotates a point around the center position
    local function rotatePoint(x, y, z)
        local relativeX = x - centerX
        local relativeY = y - centerY
        
        local cosAngle = math.cos(rotationRad)
        local sinAngle = math.sin(rotationRad)
        
        local rotatedX = relativeX * cosAngle - relativeY * sinAngle
        local rotatedY = relativeX * sinAngle + relativeY * cosAngle
        
        return rotatedX + centerX, rotatedY + centerY, z
    end
    
    -- Define the 8 corners of the box (before rotation)
    local corners = {
        { centerX - halfWidth, centerY - halfLength, centerZ - halfHeight },
        { centerX + halfWidth, centerY - halfLength, centerZ - halfHeight },
        { centerX - halfWidth, centerY + halfLength, centerZ - halfHeight },
        { centerX + halfWidth, centerY + halfLength, centerZ - halfHeight },
        { centerX - halfWidth, centerY - halfLength, centerZ + halfHeight },
        { centerX + halfWidth, centerY - halfLength, centerZ + halfHeight },
        { centerX - halfWidth, centerY + halfLength, centerZ + halfHeight },
        { centerX + halfWidth, centerY + halfLength, centerZ + halfHeight }
    }
    
    -- Apply rotation to all corners
    local rotatedCorners = {}
    for i, corner in ipairs(corners) do
        local rx, ry, rz = rotatePoint(table.unpack(corner))
        rotatedCorners[i] = { rx, ry, rz }
    end
    
    -- Draw the 12 triangles that form the 6 faces of the box
    -- Bottom face
    DrawPoly(rotatedCorners[1][1], rotatedCorners[1][2], rotatedCorners[1][3],
             rotatedCorners[3][1], rotatedCorners[3][2], rotatedCorners[3][3],
             rotatedCorners[2][1], rotatedCorners[2][2], rotatedCorners[2][3],
             r, g, b, a)
    DrawPoly(rotatedCorners[3][1], rotatedCorners[3][2], rotatedCorners[3][3],
             rotatedCorners[4][1], rotatedCorners[4][2], rotatedCorners[4][3],
             rotatedCorners[2][1], rotatedCorners[2][2], rotatedCorners[2][3],
             r, g, b, a)
    
    -- Top face
    DrawPoly(rotatedCorners[5][1], rotatedCorners[5][2], rotatedCorners[5][3],
             rotatedCorners[6][1], rotatedCorners[6][2], rotatedCorners[6][3],
             rotatedCorners[7][1], rotatedCorners[7][2], rotatedCorners[7][3],
             r, g, b, a)
    DrawPoly(rotatedCorners[6][1], rotatedCorners[6][2], rotatedCorners[6][3],
             rotatedCorners[8][1], rotatedCorners[8][2], rotatedCorners[8][3],
             rotatedCorners[7][1], rotatedCorners[7][2], rotatedCorners[7][3],
             r, g, b, a)
    
    -- Left face
    DrawPoly(rotatedCorners[1][1], rotatedCorners[1][2], rotatedCorners[1][3],
             rotatedCorners[5][1], rotatedCorners[5][2], rotatedCorners[5][3],
             rotatedCorners[7][1], rotatedCorners[7][2], rotatedCorners[7][3],
             r, g, b, a)
    DrawPoly(rotatedCorners[1][1], rotatedCorners[1][2], rotatedCorners[1][3],
             rotatedCorners[7][1], rotatedCorners[7][2], rotatedCorners[7][3],
             rotatedCorners[3][1], rotatedCorners[3][2], rotatedCorners[3][3],
             r, g, b, a)
    
    -- Right face
    DrawPoly(rotatedCorners[2][1], rotatedCorners[2][2], rotatedCorners[2][3],
             rotatedCorners[4][1], rotatedCorners[4][2], rotatedCorners[4][3],
             rotatedCorners[6][1], rotatedCorners[6][2], rotatedCorners[6][3],
             r, g, b, a)
    DrawPoly(rotatedCorners[4][1], rotatedCorners[4][2], rotatedCorners[4][3],
             rotatedCorners[8][1], rotatedCorners[8][2], rotatedCorners[8][3],
             rotatedCorners[6][1], rotatedCorners[6][2], rotatedCorners[6][3],
             r, g, b, a)
    
    -- Front face
    DrawPoly(rotatedCorners[1][1], rotatedCorners[1][2], rotatedCorners[1][3],
             rotatedCorners[2][1], rotatedCorners[2][2], rotatedCorners[2][3],
             rotatedCorners[6][1], rotatedCorners[6][2], rotatedCorners[6][3],
             r, g, b, a)
    DrawPoly(rotatedCorners[1][1], rotatedCorners[1][2], rotatedCorners[1][3],
             rotatedCorners[6][1], rotatedCorners[6][2], rotatedCorners[6][3],
             rotatedCorners[5][1], rotatedCorners[5][2], rotatedCorners[5][3],
             r, g, b, a)
    
    -- Back face
    DrawPoly(rotatedCorners[3][1], rotatedCorners[3][2], rotatedCorners[3][3],
             rotatedCorners[7][1], rotatedCorners[7][2], rotatedCorners[7][3],
             rotatedCorners[4][1], rotatedCorners[4][2], rotatedCorners[4][3],
             r, g, b, a)
    DrawPoly(rotatedCorners[7][1], rotatedCorners[7][2], rotatedCorners[7][3],
             rotatedCorners[8][1], rotatedCorners[8][2], rotatedCorners[8][3],
             rotatedCorners[4][1], rotatedCorners[4][2], rotatedCorners[4][3],
             r, g, b, a)
end