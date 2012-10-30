local Box = {};

function makeBoxMesh ( xMin, yMin, zMin, xMax, yMax, zMax, texture )
	
	local function pushPoint ( points, x, y, z )
	
		local point = {}
		point.x = x
		point.y = y
		point.z = z
		
		table.insert ( points, point )
	end

	local function writeTri ( vbo, p1, p2, p3, uv1, uv2, uv3 )
		
		vbo:writeFloat ( p1.x, p1.y, p1.z )
		vbo:writeFloat ( uv1.x, uv1.y )
		vbo:writeColor32 ( 1, 1, 1 )
		
		vbo:writeFloat ( p2.x, p2.y, p2.z )
		vbo:writeFloat ( uv2.x, uv2.y )
		vbo:writeColor32 ( 1, 1, 1 )

		vbo:writeFloat ( p3.x, p3.y, p3.z )
		vbo:writeFloat ( uv3.x, uv3.y  )
		vbo:writeColor32 ( 1, 1, 1 )
	end
	
	local function writeFace ( vbo, p1, p2, p3, p4, uv1, uv2, uv3, uv4 )

		writeTri ( vbo, p1, p2, p4, uv1, uv2, uv4 )
		writeTri ( vbo, p2, p3, p4, uv2, uv3, uv4 )
	end
	
	local p = {}
	
	pushPoint ( p, xMin, yMax, zMax ) -- p1
	pushPoint ( p, xMin, yMin, zMax ) -- p2
	pushPoint ( p, xMax, yMin, zMax ) -- p3
	pushPoint ( p, xMax, yMax, zMax ) -- p4
	
	pushPoint ( p, xMin, yMax, zMin ) -- p5
	pushPoint ( p, xMin, yMin, zMin  ) -- p6
	pushPoint ( p, xMax, yMin, zMin  ) -- p7
	pushPoint ( p, xMax, yMax, zMin  ) -- p8

	local uv = {}
	
	pushPoint ( uv, 0, 0, 0 )
	pushPoint ( uv, 0, 1, 0 )
	pushPoint ( uv, 1, 1, 0 )
	pushPoint ( uv, 1, 0, 0 )
	
	local vertexFormat = MOAIVertexFormat.new ()
	vertexFormat:declareCoord ( 1, MOAIVertexFormat.GL_FLOAT, 3 )
	vertexFormat:declareUV ( 2, MOAIVertexFormat.GL_FLOAT, 2 )
	vertexFormat:declareColor ( 3, MOAIVertexFormat.GL_UNSIGNED_BYTE )

	local vbo = MOAIVertexBuffer.new ()
	vbo:setFormat ( vertexFormat )
	vbo:reserveVerts ( 36 )
	
	writeFace ( vbo, p [ 1 ], p [ 2 ], p [ 3 ], p [ 4 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 4 ], p [ 3 ], p [ 7 ], p [ 8 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 8 ], p [ 7 ], p [ 6 ], p [ 5 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 5 ], p [ 6 ], p [ 2 ], p [ 1 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 5 ], p [ 1 ], p [ 4 ], p [ 8 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])
	writeFace ( vbo, p [ 2 ], p [ 6 ], p [ 7 ], p [ 3 ], uv [ 1 ], uv [ 2 ], uv [ 3 ], uv [ 4 ])

	vbo:bless ()

	local mesh = MOAIMesh.new ()
	
	-- tileText = MOAITileDeck2D.new()
	-- tileText:setTexture(texture)
	-- tileText:setSize(2,2)
	-- tileText:setRect(xMin, yMin, xMax, yMax)
	
	mesh:setTexture ( texture )
	mesh:setVertexBuffer ( vbo )
	mesh:setPrimType ( MOAIMesh.GL_TRIANGLES )
	
	
	-- curve = MOAIAnimCurve.new()
	-- curve:reserveKeys(4)
	-- curve:setKey ( 1, 0.00, 1, MOAIEaseType.FLAT )
	-- curve:setKey ( 2, 0.25, 2, MOAIEaseType.FLAT )
	-- curve:setKey ( 3, 0.50, 3, MOAIEaseType.FLAT )
	-- curve:setKey ( 4, 0.75, 4, MOAIEaseType.FLAT )
	
	-- anim = MOAIAnim.new()
	-- anim:reserveLinks(1)
	-- anim:setLink(1, curve, mesh, MOAIMesh.ATTR_Index)
	-- anime:setMode(MOAITimer.LOOP)
	-- anim:start()
	return mesh
end

function makeCube ( size, texture )

	size = size * 0.5
	return makeBoxMesh ( -size, -size, -size, size, size, size, texture )
end

Box.makeCube = makeCube;
return Box;
