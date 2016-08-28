/*
* GOAL: Make this work like
* Repository: https://github.com/rik-brown/Cellendipity_NOC
* Webpage: https://rik-brown.github.io/Cellendipity_NOC/
* It could also be closer to 'Aybe Sea' (only one strain, centered, not randomised by DNA but using preset values with some freedom to be random)
* Run once with randomised values and output a twitter-friendly image file once the colony has run it's course (or a time-limit is reached)
*/

Colony colony;      // A Colony object called 'colony'
//DNA dna;            // A DNA object called 'dna'
Parameters p;       // A Parameters object called 'p'
String screendumpPath = "C:/Richard/Personal/Code/Gallery/Cellendipity_Processing/######.png";

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
  if (colony.cells.size() == 0) { if ((keyPressed == true) || p.autoRestart) {populateColony(); } } // Repopulate the colony when all the cells have died
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
  boolean debug;
  boolean centerSpawn;
  boolean autoRestart;
  boolean screendumpON;
  boolean veilDrawON;
  boolean veilRepopulateON;
  boolean fillDisable;
  boolean strokeDisable;
  boolean greyscaleON;
  boolean nucleus;
  boolean stepped;
  boolean wraparound;

  int colonySize;
  int strainSize;
  int numStrains;
  int stepSize;
  int stepSizeN;
  int trailMode;

  int bkgColGrey;
  color bkgColor;

  int fill_STwist;
  int fill_HTwist;
  int fill_BTwist;
  int fill_ATwist;

  int stroke_HTwist;
  int stroke_STwist;
  int stroke_BTwist;
  int stroke_ATwist;

  Parameters() {
    debug = false;
    centerSpawn = false; // true=initial spawn is width/2, height/2 false=random
    autoRestart = false; // If true, will not wait for keypress before starting anew
    screendumpON = false;
    veilDrawON = false;
    veilRepopulateON = false;
    fillDisable = false;
    strokeDisable = false;
    greyscaleON = false;
    nucleus = false;
    stepped = false;
    wraparound = true;

    colonySize = int(random (20,80)); // Max number of cells in the colony
    strainSize = int(random(1,10)); // Number of cells in a strain
    numStrains = int(random(1,10)); // Number of strains (a group of cells sharing the same DNA)
    stepSize = 0;
    stepSizeN = 0;
    trailMode = 3; // 1=none, 2 = blend, 3 = continuous

    bkgColor = color(random(360), random(255), random(255)); // Background colour
    bkgColGrey = 128;

    fill_HTwist = 0;
    fill_STwist = 255;
    fill_BTwist = 128;
    fill_ATwist = 255;

    stroke_HTwist = 0;
    stroke_STwist = 255;
    stroke_BTwist = 128;
    stroke_ATwist = 255;
  }
}

void manageColony() {
  if (colony.cells.size() == 0) { //  If an extinction has occurred...
    if (p.screendumpON) {screendump();} //WARNING! ALWAYS repopulate & restart the colony after doing this once!
    //refreshBackgroundColour(); // Select a new colour for the background
    else {
     if (p.greyscaleON) {background(p.bkgColGrey); }
     else {background(p.bkgColGrey);} // flush the background
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
  if (key == '1') {p.trailMode = 1;}
  if (key == '2') {p.trailMode = 2;}
  if (key == '3') {p.trailMode = 3;}
  if (key == 'r') {colony.cells.clear();}
  if (key == 'b') {background(p.bkgColGrey); }
  if (key == 'd') {p.debug = !p.debug; }
  if (key == 'n') {p.nucleus = !p.nucleus; }
  if (key == 's') {screendump();}
}
