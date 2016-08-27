/*
* GOAL: Make this work like
* Repository: https://github.com/rik-brown/Cellendipity_NOC
* Webpage: https://rik-brown.github.io/Cellendipity_NOC/
* It could also be closer to 'Aybe Sea' (only one strain, centered, not randomised by DNA but using preset values with some freedom to be random)
* Run once with randomised values and output a twitter-friendly image file once the colony has run it's course (or a time-limit is reached)
*/

Colony colony;      // A Colony object called 'colony'
Parameters p;       // A Parameters object called 'p'

 greyscaleON = true; // keep for now
 screendumpON = false;
 veilDrawON = false;
 veilRepopulateON = false;
String screendumpPath = "C:/Richard/Personal/Code/Processing_WORK/Coloured_Cells/Gallery/Better_Code/00_05/######.png";

//MOVED FROM COLONY in v00.05
 colonyMin = 10;
 colonyMax = 500;



//MOVED FROM CELL in v00.05
//ALL THESE CONTROLS ARE EXPECTED TO OPERATE AT COLONY-LEVEL
//(EQUAL FOR ALL CELLS)
  rStartMin = 50; // Minimum starting radius
 rStartMax = 50; // Maximum starting radius
 rStart = random(rStartMin, rStartMax);  // Starting radius

 void setup() {
  colorMode(HSB, 360, 255, 255, 255);
  fullScreen();
  //size(1000, 1000); // debug
  ellipseMode(RADIUS);
  p = new Parameters();
  if (p.greyscaleON) {background(p.bkgColGrey); } else {background(p.bkgColor);}
  if (p.debug) {frameRate(10);}   // debug
  colony = new Colony(p.colonySize);
}

void draw() {
  if (p.trailMode == 1 || p.debug) {background(p.bkgColor);}
  if (p.trailMode == 2) {trails();}
  colony.run();
  if (colony.cells.size() == 0) { if (keyIsPressed || p.autoRestart) {populateColony(); } } // Repopulate the colony when all the cells have died
  }

  void populateColony() {
    background(p.bkgColor); // Refresh the background
    colony.cells.clear();
    colony = new Colony(p.colonySize);
  }

  void trails() {
    blendMode(DIFFERENCE);
    noStroke();
    fill(1);
    rect(-1, -1, width+1, height+1);
    blendMode(BLEND);
    fill(255);
  }

class Parameters {
   colonySize;
   strainSize;
   numStrains;
   trailMode;
   bkgColGrey;

   centerSpawn;
   autoRestart;
   fillDisable;
   strokeDisable;
   nucleus;
   stepped;
   wraparound;
   debug;

  color bkgColor;

   fill_HTwist;
   fill_STwist;
   fill_BTwist;
   fill_ATwist;
   stroke_HTwist;
   stroke_STwist;
   stroke_BTwist;
   stroke_ATwist;
   stepSize;
   stepSizeN;

  Parameters() {
    colonySize = int(random (20,80)); // Max number of cells in the colony
    strainSize = int(random(1,10)); // Number of cells in a strain
    numStrains = int(random(1,10)); // Number of strains (a group of cells sharing the same DNA)

    centerSpawn = false; // true=initial spawn is width/2, height/2 false=random
    autoRestart = false; // If true, will not wait for keypress before starting anew

    bkgColor = color(bkgColHSV.h, bkgColHSV.s*255, bkgColHSV.v*255); // Background colour

    fill_HTwist = 0;
    fill_STwist = 255;
    fill_BTwist = 128;
    fill_ATwist = 255;
    stroke_HTwist = 0;
    stroke_STwist = 255;
    stroke_BTwist = 128;
    stroke_ATwist = 255;
    bkgColGrey = 128;

    fillDisable = false;
    strokeDisable = false;
    greyscaleON = false;
    nucleus = false;

    stepSize = 0;
    stepSizeN = 00;
    stepped = false;

    wraparound = true;
    trailMode = 3; // 1=none, 2 = blend, 3 = continuous

    restart = function () {colony.cells = []; populateColony();};
    randomRestart = function () {randomizer(); colony.cells = []; populateColony();};
    debug = false;

  }
}





void manageColony() {
  if (colony.cells.size() == 0) { //  If an extinction has occurred...
    if (screendumpON) {screendump();} //WARNING! ALWAYS repopulate & restart the colony after doing this once!
    refreshBackgroundColour(); // Select a new colour for the background
    if (veilRepopulateON) {veil();}      // Draw a veil over the previous colony to gradually fade it o oblivion
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
  PVector mousePos = new PVector (mouseX, mouseY);
  PVector vel = PVector.random2D();
  DNA dna = new DNA();
  colony.spawn(mousePos, vel, dna);
}

void mouseDragged() {
  PVector mousePos = new PVector (mouseX, mouseY);
  PVector vel = PVector.random2D();
  DNA dna = new DNA();
  colony.spawn(mousePos, vel, dna);
}

void screendump() {
  saveFrame(screendumpPath);
}

void keyReleased() {
  if (key === '1') {p.trailMode = 1;}
  if (key === '2') {p.trailMode = 2;}
  if (key === '3') {p.trailMode = 3;}
  if (key == 'r') {colony.cells = [];}
  if (key == 'b') {background(p.bkgColGrey); }
  if (key == 'd') {p.debug = !p.debug; }
  if (key == 'n') {p.nucleus = !p.nucleus; }
  if (key == 's') {screendump();}
}
