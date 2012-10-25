local function preInitialize()
	-- require managers to perform singleton initialization
	require "WindowManager";
	require "LayerManager";
 	print("PreInitialized");
end

local function initHack()
	local layerManager = require "LayerManager"
	local windowManager = require "WindowManager";
	--local backgroundLayerIndex = layerManager:createLayer();
	--local backgroundLayer = layerManager:getLayerAtIndex(backgroundLayerIndex);
	--MOAISim.pushRenderPass(backgroundLayer.layer);
	--local bg = require "background";
	--bg(backgroundLayer.layer, windowManager.screenWidth, windowManager.screenHeight);

	local foregroundLayerIndex = layerManager:createLayer();
	local foregroundLayer = layerManager:getLayerAtIndex(foregroundLayerIndex);
	MOAISim.pushRenderPass(foregroundLayer.layer);

	foregroundLayer:setPosition(-200, 0);
	--backgroundLayer:setPosition(200, 200);
	
	local function shaderTest()
		if 1 then return end;
		local file = assert ( io.open ( 'shader.vsh', mode ))
		vsh = file:read ( '*all' )
		file:close ()

		local file = assert ( io.open ( 'shader.fsh', mode ))
		fsh = file:read ( '*all' )
		file:close ()

		local gfxQuad = MOAIGfxQuad2D.new ()
		gfxQuad:setTexture ( "../textures/moai.png" )
		gfxQuad:setRect ( -64, -64, 64, 64 )
		gfxQuad:setUVRect ( 0, 1, 1, 0 )

		-- create metaball to hook shader to
		local metaball = MOAIMetaBall.new();
		metaball:setDeck(gfxQuad);
		metaball:moveRot(0, 0, 360, 5, MOAIEaseType.LINEAR);
		foregroundLayer.layer:insertProp(metaball);

		local color = MOAIColor.new ()
		color:setColor ( 0, 0, 1, 0 )
		color:seekColor(1, 1, 1, 1, 5, MOAIEaseType.LINEAR);
		--color:moveColor(1, 1, 1, 0, 1 );

		local shader = MOAIShader.new ()
		shader:reserveUniforms ( 1 )
		shader:declareUniform ( 1, 'maskColor', MOAIShader.UNIFORM_COLOR )

		shader:setAttrLink ( 1, color, MOAIColor.COLOR_TRAIT )

		shader:setVertexAttribute ( 1, 'position' )
		shader:setVertexAttribute ( 2, 'uv' )
		shader:setVertexAttribute ( 3, 'color' )
		shader:load ( vsh, fsh )

		gfxQuad:setShader ( shader )
	end

	shaderTest();
end

local function initialize()
	initHack();
  	print("Initialized");
end

local done = false;
function gamesLoop ()
	preInitialize();
	initialize();

	while not done do
		coroutine.yield()
	end
end

return gamesLoop;