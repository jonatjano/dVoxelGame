module main;

import raylib;
import libs.modlib;

import std.conv : to;
import std.random : choice, Random, uniform;
import std.range: iota, take;
import std.stdio : writeln;
import std.string : toStringz, fromStringz, lastIndexOf;

alias getModDefinition_t = extern(C) ModDefinition* function();

import map;

Block[] mMap = [];
const mapSize = 64;
auto rnd = Random(42);

int main() {
    BlockType*[] blocks = [];
	string[] mods = [
		"./mods/libcppmod.so",
		"./mods/libdmod.so",
		"./mods/libcmod.so"
	];
	foreach(string modPath; mods) {
        SharedHandle libHandle = sharedLib_load(modPath.toStringz);
        writeln("successfully loaded ", fromStringz(libHandle.path));
        
        SymbolHandle func = sharedLib_get(libHandle, "getModDefinition".toStringz);
        writeln("successfully loaded mod definition");
        getModDefinition_t getModDefinition = cast(getModDefinition_t)func.ptr;
        ModDefinition* mod = getModDefinition();

        List* listBlock = mod.blocks;
        while (listBlock != null) {
            BlockType* newBlock = cast(BlockType*)(listBlock.value);
            blocks ~= newBlock;
            writeln("block\n", "\t", fromStringz(newBlock.name), "\n", "\t", fromStringz(newBlock.texture), "\n");
            listBlock = listBlock.next;
        }
        
        sharedLib_close(libHandle);
	}

	for (int i = -mapSize; i < mapSize; i++) {
		for (int j = -mapSize; j < mapSize; j++) {
			mMap ~= Block(i, 0, j, blocks.choice(rnd));
		}
	}
	
	InitWindow(800, 600, "voxest");
	
	Camera camera;
	camera.position = Vector3(0, 2, 0);
	camera.target = Vector3(1, 1, 0);
	camera.up = Vector3(1, 1, 0);
	camera.fovy = 60;
	camera.projection = CAMERA_PERSPECTIVE;

    SetCameraMode(camera, CAMERA_FIRST_PERSON); // Set a first person camera mode
	
	SetTargetFPS(60);
	
	while(! WindowShouldClose()) {
		UpdateCamera(&camera);
		
		BeginDrawing();
		{
			ClearBackground(raywhite);
			
			BeginMode3D(camera);
			{
		        foreach (block; mMap) {
		            DrawCube(block.pos, 1.0f, 1, 1.0f, block.color);
		        }
	            DrawCubeWires(Vector3(0, 1, 0), 1.0f, 1, 1.0f, black);
			}
            EndMode3D();
        }
        EndDrawing();
	}
	
    CloseWindow();
    
    
    return 0;
}


/+
/// 3d fps
const int MAX_COLUMNS = 20;

int main()
{
    // Initialization
    //--------------------------------------------------------------------------------------
    const int screenWidth = 800;
    const int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera first person");

    // Define the camera to look into our 3d world (position, target, up vector)
    Camera camera = { };
    camera.position = Vector3( 4.0f, 2.0f, 4.0f );
    camera.target = Vector3( 0.0f, 1.8f, 0.0f );
    camera.up = Vector3( 0.0f, 1.0f, 0.0f );
    camera.fovy = 60.0f;
    camera.projection = CAMERA_PERSPECTIVE;

    // Generates some random columns
    float[MAX_COLUMNS] heights;
    Vector3[MAX_COLUMNS] positions;
    Color[MAX_COLUMNS] colors;

    for (int i = 0; i < MAX_COLUMNS; i++)
    {
        heights[i] = GetRandomValue(1, 12).to!float;
        positions[i] = Vector3( GetRandomValue(-15, 15).to!float, heights[i]/2.0f, GetRandomValue(-15, 15).to!float );
        colors[i] = Color( GetRandomValue(20, 255).to!ubyte, GetRandomValue(10, 55).to!ubyte, 30, 255 );
    }

    SetCameraMode(camera, CAMERA_FIRST_PERSON); // Set a first person camera mode

    SetTargetFPS(60);                           // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose())                // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        UpdateCamera(&camera);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing();

            ClearBackground(raywhite);

            BeginMode3D(camera);

                DrawPlane(Vector3( 0.0f, 0.0f, 0.0f ), Vector2( 32.0f, 32.0f ), lightgray); // Draw ground
                DrawCube(Vector3( -16.0f, 2.5f, 0.0f ), 1.0f, 5.0f, 32.0f, blue);     // Draw a blue wall
                DrawCube(Vector3( 16.0f, 2.5f, 0.0f ), 1.0f, 5.0f, 32.0f, lime);      // Draw a green wall
                DrawCube(Vector3( 0.0f, 2.5f, 16.0f ), 32.0f, 5.0f, 1.0f, gold);      // Draw a yellow wall

                // Draw some cubes around
                for (int i = 0; i < MAX_COLUMNS; i++)
                {
                    DrawCube(positions[i], 2.0f, heights[i], 2.0f, colors[i]);
                    DrawCubeWires(positions[i], 2.0f, heights[i], 2.0f, maroon);
                }

            EndMode3D();

            DrawRectangle( 10, 10, 220, 70, Fade(skyblue, 0.5f));
            DrawRectangleLines( 10, 10, 220, 70, blue);

            DrawText("First person camera default controls:", 20, 20, 10, black);
            DrawText("- Move with keys: W, A, S, D", 40, 40, 10, darkgray);
            DrawText("- Mouse move to look around", 40, 60, 10, darkgray);

        EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}
+/

/+
/// 3d freecam
int main()
{
    // Initialization
    //--------------------------------------------------------------------------------------
    const int screenWidth = 800;
    const int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera free");

    // Define the camera to look into our 3d world
    Camera3D camera = { };
    camera.position = Vector3( 10.0f, 10.0f, 10.0f ); // Camera position
    camera.target = Vector3( 0.0f, 0.0f, 0.0f );      // Camera looking at point
    camera.up = Vector3( 0.0f, 1.0f, 0.0f );          // Camera up vector (rotation towards target)
    camera.fovy = 45.0f;                                // Camera field-of-view Y
    camera.projection = CAMERA_PERSPECTIVE;                   // Camera mode type

    Vector3 cubePosition = Vector3( 0.0f, 0.0f, 0.0f );

    SetCameraMode(camera, CAMERA_FREE); // Set a free camera mode

    SetTargetFPS(60);                   // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose())        // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        UpdateCamera(&camera);

        if (IsKeyDown(KEY_Z)) camera.target = Vector3( 0.0f, 0.0f, 0.0f );
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing();

            ClearBackground(raywhite);

            BeginMode3D(camera);

                DrawCube(cubePosition, 2.0f, 2.0f, 2.0f, red);
                DrawCubeWires(cubePosition, 2.0f, 2.0f, 2.0f, maroon);

                DrawGrid(10, 1.0f);

            EndMode3D();

            DrawRectangle( 10, 10, 320, 133, Fade(skyblue, 0.5f));
            DrawRectangleLines( 10, 10, 320, 133, blue);

            DrawText("Free camera default controls:", 20, 20, 10, black);
            DrawText("- Mouse Wheel to Zoom in-out", 40, 40, 10, darkgray);
            DrawText("- Mouse Wheel Pressed to Pan", 40, 60, 10, darkgray);
            DrawText("- Alt + Mouse Wheel Pressed to Rotate", 40, 80, 10, darkgray);
            DrawText("- Alt + Ctrl + Mouse Wheel Pressed for Smooth Zoom", 40, 100, 10, darkgray);
            DrawText("- Z to zoom to (0, 0, 0)", 40, 120, 10, darkgray);

        EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}
+/

/+
/// 3d world
int main()
{
    // Initialization
    //--------------------------------------------------------------------------------------
    const int screenWidth = 800;
    const int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 3d camera mode");

    // Define the camera to look into our 3d world
    Camera3D camera = { };
    camera.position = Vector3( 0.0f, 10.0f, 10.0f );  // Camera position
    camera.target = Vector3( 0.0f, 0.0f, 0.0f );      // Camera looking at point
    camera.up = Vector3( 0.0f, 1.0f, 0.0f );          // Camera up vector (rotation towards target)
    camera.fovy = 45.0f;                                // Camera field-of-view Y
    camera.projection = CAMERA_PERSPECTIVE;             // Camera mode type

    Vector3 cubePosition = { 0.0f, 0.0f, 0.0f };

    SetTargetFPS(60);               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose())    // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing();

            ClearBackground(raywhite);

            BeginMode3D(camera);

                DrawCube(cubePosition, 2.0f, 2.0f, 2.0f, red);
                DrawCubeWires(cubePosition, 2.0f, 2.0f, 2.0f, maroon);

                DrawGrid(10, 1.0f);

            EndMode3D();

            DrawText("Welcome to the third dimension!", 10, 40, 20, darkgray);

            DrawFPS(10, 10);

        EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}
+/


/+
/// 2d camera
const int MAX_BUILDINGS = 100;

int main()
{

    // Initialization
    //--------------------------------------------------------------------------------------
    const int screenWidth = 800;
    const int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera");

    Rectangle player = { 400, 280, 40, 40 };
    Rectangle[MAX_BUILDINGS] buildings = { 0 };
    Color[MAX_BUILDINGS] buildColors = { 0 };

    int spacing = 0;

    for (int i = 0; i < MAX_BUILDINGS; i++)
    {
        buildings[i].width = GetRandomValue(50, 200).to!float;
        buildings[i].height = GetRandomValue(100, 800).to!float;
        buildings[i].y = screenHeight - 130.0f - buildings[i].height;
        buildings[i].x = -6000.0f + spacing;

        spacing += buildings[i].width.to!int;

        buildColors[i] = Color( GetRandomValue(200, 240).to!ubyte, GetRandomValue(200, 240).to!ubyte, GetRandomValue(200, 250).to!ubyte, 255 );
    }

    Camera2D camera = { };
    camera.target = Vector2( player.x + 20.0f, player.y + 20.0f );
    camera.offset = Vector2( screenWidth/2.0f, screenHeight/2.0f );
    camera.rotation = 0.0f;
    camera.zoom = 1.0f;

    SetTargetFPS(60);                   // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose())        // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Player movement
        if (IsKeyDown(KEY_RIGHT)) player.x += 2;
        else if (IsKeyDown(KEY_LEFT)) player.x -= 2;

        // Camera target follows player
        camera.target = Vector2( player.x + 20, player.y + 20 );

        // Camera rotation controls
        if (IsKeyDown(KEY_A)) camera.rotation--;
        else if (IsKeyDown(KEY_S)) camera.rotation++;

        // Limit camera rotation to 80 degrees (-40 to 40)
        if (camera.rotation > 40) camera.rotation = 40;
        else if (camera.rotation < -40) camera.rotation = -40;

        // Camera zoom controls
        camera.zoom += (GetMouseWheelMove().to!float * 0.05f);

        if (camera.zoom > 3.0f) camera.zoom = 3.0f;
        else if (camera.zoom < 0.1f) camera.zoom = 0.1f;

        // Camera reset (zoom and rotation)
        if (IsKeyPressed(KEY_R))
        {
            camera.zoom = 1.0f;
            camera.rotation = 0.0f;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing();

            ClearBackground(raywhite);

            BeginMode2D(camera);

                DrawRectangle(-6000, 320, 13000, 8000, darkgray);

                for (int i = 0; i < MAX_BUILDINGS; i++) DrawRectangleRec(buildings[i], buildColors[i]);

                DrawRectangleRec(player, red);

                DrawLine(camera.target.x.to!int, -screenHeight*10, camera.target.x.to!int, screenHeight*10, green);
                DrawLine(-screenWidth*10, camera.target.y.to!int, screenWidth*10, camera.target.y.to!int, green);

            EndMode2D();

            DrawText("SCREEN AREA", 640, 10, 20, red);

            DrawRectangle(0, 0, screenWidth, 5, red);
            DrawRectangle(0, 5, 5, screenHeight - 10, red);
            DrawRectangle(screenWidth - 5, 5, 5, screenHeight - 10, red);
            DrawRectangle(0, screenHeight - 5, screenWidth, 5, red);

            DrawRectangle( 10, 10, 250, 113, Fade(skyblue, 0.5f));
            DrawRectangleLines( 10, 10, 250, 113, blue);

            DrawText("Free 2d camera controls:", 20, 20, 10, black);
            DrawText("- Right/Left to move Offset", 40, 40, 10, darkgray);
            DrawText("- Mouse Wheel to Zoom in-out", 40, 60, 10, darkgray);
            DrawText("- A / S to Rotate", 40, 80, 10, darkgray);
            DrawText("- R to reset Zoom and Rotation", 40, 100, 10, darkgray);

        EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}
+/

/*
/// scroll
int main()
{
    // Initialization
    //--------------------------------------------------------------------------------------
    const int screenWidth = 800;
    const int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - input mouse wheel");

    int boxPositionY = screenHeight/2 - 40;
    int scrollSpeed = 4;            // Scrolling speed in pixels

    SetTargetFPS(60);               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose())    // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        boxPositionY -= (GetMouseWheelMove()*scrollSpeed);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing();

            ClearBackground(raywhite);

            DrawRectangle(screenWidth/2 - 40, boxPositionY, 80, 80, maroon);

            DrawText("Use mouse wheel to move the cube up and down!", 10, 10, 20, gray);
            DrawText(TextFormat("Box position Y: %03i", boxPositionY), 10, 40, 20, lightgray);

        EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}
*/

/*
/// mouse input
int main()
{
    // Initialization
    //--------------------------------------------------------------------------------------
    const int screenWidth = 800;
    const int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - mouse input");

    Vector2 ballPosition = { -100.0f, -100.0f };
    Color ballColor = darkblue;

    SetTargetFPS(60);               // Set our game to run at 60 frames-per-second
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose())    // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        ballPosition = GetMousePosition();

        if (IsMouseButtonPressed(MOUSE_BUTTON_LEFT)) ballColor = maroon;
        else if (IsMouseButtonPressed(MOUSE_BUTTON_MIDDLE)) ballColor = lime;
        else if (IsMouseButtonPressed(MOUSE_BUTTON_RIGHT)) ballColor = darkblue;
        else if (IsMouseButtonPressed(MOUSE_BUTTON_SIDE)) ballColor = purple;
        else if (IsMouseButtonPressed(MOUSE_BUTTON_EXTRA)) ballColor = yellow;
        else if (IsMouseButtonPressed(MOUSE_BUTTON_FORWARD)) ballColor = orange;
        else if (IsMouseButtonPressed(MOUSE_BUTTON_BACK)) ballColor = beige;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing();

            ClearBackground(raywhite);

            DrawCircleV(ballPosition, 40, ballColor);

            DrawText("move ball with mouse and click mouse button to change color", 10, 10, 20, darkgray);

        EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}
*/

/*
/// basic keybind
int main()
{
    // Initialization
    //--------------------------------------------------------------------------------------
    const int screenWidth = 800;
    const int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - keyboard input");

    Vector2 ballPosition = { screenWidth.to!float / 2, screenHeight.to!float / 2 };

    SetTargetFPS(60);               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose())    // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (IsKeyDown(KEY_RIGHT)) ballPosition.x += 2.0f;
        if (IsKeyDown(KEY_LEFT)) ballPosition.x -= 2.0f;
        if (IsKeyDown(KEY_UP)) ballPosition.y -= 2.0f;
        if (IsKeyDown(KEY_DOWN)) ballPosition.y += 2.0f;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing();

            ClearBackground(raywhite);

            DrawCircleV(ballPosition, 50, blue);

            DrawText("move the ball with arrow keys", 10, 10, 20, gray);

        EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}
*/

/*
/// empty window
void main() {
    import raylib;

	InitWindow(640, 480, "importC");
	while(!WindowShouldClose()) {
        BeginDrawing();
        {
            ClearBackground(darkbrown);
            DrawText("hello, importC!", 120, 100, 60, white);
            DrawText("D", 50, 200, 210, red);
            DrawText("+ Raylib", 210, 240, 100, orange);
        }
        EndDrawing();
    }
    CloseWindow();
}
*/

