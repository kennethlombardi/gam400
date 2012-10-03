require "Persistence"

function testMarshall()
end

function testUnmarshall()
end

function testFactory()
	local factory = require "ObjectFactory";
	local handle = factory.createObject( "MOAIFoo" );
	newObject = factory.getObject( handle );
	print( type( newObject ) );
	newObject.randomFunction();
end

function testSimpleIO()
	filename = "objects.txt";
	writeObjectToFile( 3, filename );
	writeObjectToFile( "asdf\n\n", filename );
end

function testAll()
	testFactory();
	testSimpleIO();
	testMarshall();
	testUnmarshall();

	--local file = assert( io.open( "objects.txt", "a" ) );
	--file:write( "writing to file\n" );

	--local t = {"entry1", "entry2", "entry3" };

	--save( "gameObjectType1", t, false );
	
end