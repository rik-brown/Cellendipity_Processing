/*
*  v00.00  Is a copy of Expansion_00_03
*          GOAL: Final push in refactoring. NO NEW IDEAS ADDED UNTIL I'M DONE!
*  DONE    Sub-goal 1: Tidy up in colours. Quite happy in 00.02 though could add boolean to select BW/colour
*                      Could consider using 'hue = degrees(v.heading()) + 180;'
*          Sub-goal 2: Tidy up in spawning (use DNA recombination?)
*          Sub-goal 3: Prepare for sliders
*          Sub-goal 4: Fewer variables per cell (move them up to Colony where possible - when all cells will have the same values in an given population)
*  v00.01  Saved as waypoint. Cute :-)
*          Sub-goal 5: If Perlin then don't bounce on collide
*          Sub-goal 6: Fix spawning! OK in 00.02
*  v00.02  Saved before moving on to tweak angles (from -PI/+PI to 0/TWO_PI)
*          Sub-goal 7: Need to figure out what I mean by rMax and rMaxMax. Bit wonky
*          Sub-goal 8: Fertile needs to be 'reset' after a spawn-event. Could rStart be set to r?
*  v00.03  Can't remember what I added here...
*  v00.04  Playing with a new feature :-E Central 'nucleus' indicates fertility (discovered a cute bug though - other rStart was not reset)
*
*          First KEEPER in a while :-D
*
*          This is pretty close to being a stand-alone, requiring very few controls.
*          If I should add any, they could be;
*          Background B+W/Colour
*          Foreground B+W/Colour
*          Background colour
*          Stroke colour
*          Fill colour
*          Seed colour?
*
*          Maybe this IS only an extension of the standard*: "show seed" (BOOLEAN)
*
*          And the inevitable extended set....
*          Start Radius
*          End Radius
*          FertilityThreshold
*          Perlin etc. etc.
*
*          Possible further tweaks:
*          The fill alpha of the seed starts at 0 and grows steadily higher as r approaches fertility
*          Gave it a try but on balance, I like the binary / yin/yang / white/black (plus association to frogspawn)
*
*  v00.05  Moving some cell variables from Cell and Colony up to Global
*          Bug(ish): If Growing = false (fixed radius) then cell will never become fertile. Maybe a counter is preferable?
*          Spawn position needs moving to the radius.
*          How about more than one "inner cores" ? What could they represent? A more flattened ellipse.
*/

Colony colony;      // A colony object

boolean greyscaleON = true;
boolean screendumpON = false;
boolean veilDrawON = false;
boolean veilRepopulateON = false;
String screendumpPath = "C:/Richard/Personal/Code/Processing_WORK/Coloured_Cells/Gallery/Better_Code/00_05/######.png";

//MOVED FROM COLONY in v00.05
int colonyMin = 10;
int colonyMax = 500;



//MOVED FROM CELL in v00.05
//ALL THESE CONTROLS ARE EXPECTED TO OPERATE AT COLONY-LEVEL 
//(EQUAL FOR ALL CELLS)
boolean perlin = true;  // Movement is either perlin or linear (could this be switched to 'degrees of' - 0-100% slider)?
boolean spiralling = false; // A sub-category of movement (could this be switched to 'degrees of' - 0-100% slider)?
boolean steppedOld = false; // A sub-category of movement. Seems to be a bit broken... (v00.05)
boolean stepped = false; // A sub-category of movement
boolean growing = true; // Changing size
boolean transforming = true;  // Changing shape (not currently doing anything at all)
boolean greyscale = false; // (CELL) For greyscale or colour
boolean colouring = false;  // Changing colour
boolean colourtwisting = false; // A sub-category of colouring
boolean rebounding = true; // Bounce off the walls (else wraparound)


int bkgColGrey ;  // Background colour for greyscale

int bkgColH;      // Background colour for HSB colour (H)
int bkgColS;      // Background colour for HSB colour (S)
int bkgColB;      // Background colour for HSB colour (B)

int rStartMin = 50; // Minimum starting radius
int rStartMax = 50; // Maximum starting radius
float rStart = random(rStartMin, rStartMax);  // Starting radius

int colSizeMin = 10;  // Minimum colony size
int colSizeMax = 40; // Maximum colony size

PVector col;        // PVector col needs to be declared to allow for random picker

void setup() {
  fullScreen();
  
  //size(1000, 1000); // debug
  //frameRate(3);   // debug
  
  colorMode(HSB, 360, 100, 100, 100);
  smooth();
  ellipseMode(RADIUS);
  
  refreshBackgroundColour();
  
  if (greyscaleON) {background(bkgColGrey); } else {background(bkgColH, bkgColS, bkgColB, 255);}
  
  populateColony(); //Creates a colony with initial population of cells
}

void draw() {
  //background(bkgColGrey); // To flush the background every frame
  if (veilDrawON) {veil();}     // To lay a transparent 'veil' over the background every frame
  colony.run();    //<>//
  manageColony();
  //println(colony.cells.size()); // debug  
}

void refreshBackgroundColour() {
  bkgColGrey = 128;                 // Fixed background colour (greyscale)
  //bkgColGrey = int(random(255));    // Random background colour (greyscale)

  //bkgColH = 0;                      // Fixed background colour for HSB colour (H)
  //bkgColS = 0;                      // Fixed background colour for HSB colour (S)
  //bkgColB = 0;                      // Fixed background colour for HSB colour (B)
    
  //bkgColH = int(random(255));       // Random background colour for HSB colour (H)
  //bkgColS = int(random(255));       // Random background colour for HSB colour (S)
  //bkgColB = int(random(255));       // Random background colour for HSB colour (B)
  
  bkgColH = int(random(255));       // Random background colour for HSB colour (H)
  bkgColS = int(random(10, 128));   // Random background colour for HSB colour (S) (PALE)
  bkgColB = int(random(200, 255));  // Random background colour for HSB colour (B) (PALE)
}

void veil() {
  int transparency = 4; // 255 is fully opaque, 1 is virtually invisible
  noStroke();
  if (greyscaleON) {fill(bkgColGrey, transparency);} else {fill(bkgColH, bkgColS, bkgColB, transparency);}
  rect(-1, -1, width+1, height+1);
}

void populateColony()  {
  float rStart = random(rStartMin, rStartMax); 
  //colony = new Colony(int(random(colSizeMin, colSizeMax)), rStart); //Could Colony receive a color-seed value (that is iterated through in a for- loop?) (or randomized?)
  //colony = new Colony(1, rStart); // Populate the colony with a single cell. Useful for debugging
  colony = new Colony(1, 50);
}

void manageColony() {
  if (colony.cells.size() == 0) { //  If an extinction has occurred...
    if (screendumpON) {screendump();} //WARNING! ALWAYS repopulate & restart the colony after doing this once!
    refreshBackgroundColour(); // Select a new colour for the background
    if (veilRepopulateON) {veil();}      // Draw a veil over the previous colony to gradually fade it into oblivion
    else {
     if (greyscaleON) {
       background(bkgColGrey); }
     else {
       background(bkgColH, bkgColS, bkgColB, 255); // flush the background
     }
    }
    populateColony(); // .... repopulate the colony
  }
}

// We can add a creature manually if we so desire
void mousePressed() {
  PVector vel = PVector.random2D();
  //PVector col = PVector.random2D();
  float colourPicker = random(1); // To select between Red, Green or Blue with equal probability
      if (colourPicker <= 0.333){
        col = PVector.fromAngle(PI); } // This angle gived RED (maps to 0)
        else if (colourPicker <= 0.666){
        col = PVector.fromAngle(PI/3); } // This angle gived BLUE (maps to 240)
        else {
        col = PVector.fromAngle(-PI/3); } // This angle gived GREEN (maps to 120)
  colony.spawn(mouseX, mouseY, vel.x, vel.y, col.heading(), col.mag(), rStart); 
}

void mouseDragged() {
  PVector vel = PVector.random2D();
  //PVector col = PVector.random2D();
  float colourPicker = random(1); // To select between Red, Green or Blue with equal probability
      if (colourPicker <= 0.333){
        col = PVector.fromAngle(PI); } // This angle gived RED (maps to 0)
        else if (colourPicker <= 0.666){
        col = PVector.fromAngle(PI/3); } // This angle gived BLUE (maps to 240)
        else {
        col = PVector.fromAngle(-PI/3); } // This angle gived GREEN (maps to 120)
  colony.spawn(mouseX, mouseY, vel.x, vel.y, col.heading(), col.mag(), rStart);  
}

void redSpawn() {
  PVector pos = new PVector (random(width), random(height));
  PVector vel = PVector.random2D();
  col = PVector.fromAngle(PI); // This angle gived RED (maps to 0)
  colony.spawn(pos.x, pos.y, vel.x, vel.y, col.heading(), col.mag(), rStart); 
}

void greenSpawn() {
  PVector pos = new PVector (random(width), random(height));
  PVector vel = PVector.random2D();
  col = PVector.fromAngle(-PI/3); // This angle gived GREEN (maps to 120)
  colony.spawn(pos.x, pos.y, vel.x, vel.y, col.heading(), col.mag(), rStart); 
}

void blueSpawn() {
  PVector pos = new PVector (random(width), random(height));
  PVector vel = PVector.random2D();
  col = PVector.fromAngle(PI/3); // This angle gived BLUE (maps to 240)
  colony.spawn(pos.x, pos.y, vel.x, vel.y, col.heading(), col.mag(), rStart); 
}
void screendump() {
  saveFrame(screendumpPath);
}

void keyReleased() {
  if (key == 'r') {redSpawn(); }
  if (key == 'g') {greenSpawn(); }
  if (key == 'b') {blueSpawn(); }
  if (key == 's') {screendump(); }
  if (key == 'd') {colony.cullAll(); }
  if (key == 'b') {background(bkgColGrey); }
}