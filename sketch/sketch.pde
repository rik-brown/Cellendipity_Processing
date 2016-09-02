/*
* GOAL: Make this work like
* Repository: https://github.com/rik-brown/Cellendipity_NOC
* Webpage: https://rik-brown.github.io/Cellendipity_NOC/
* It could also be closer to 'Aybe Sea' (only one strain, centered, not randomised by DNA but using preset values with some freedom to be random)
* Run once with randomised values and output a twitter-friendly image file once the colony has run it's course (or a time-limit is reached)
*/

Colony colony;      // A Colony object called 'colony'
Parameters p;       // A Parameters object called 'p'
String screendumpPath = "C:/Richard/Personal/Code/Gallery/Cellendipity_Processing/######.png";

void setup() {
  colorMode(HSB, 360, 255, 255, 255);
  // fullScreen();
  size(1000, 1000); // debug
  ellipseMode(RADIUS);
  p = new Parameters();
  colony = new Colony();
  if (p.greyscaleON) {background(p.bkgColGrey); } else {background(p.bkgColor);}
  //if (p.debug) {frameRate(15);}
}

void draw() {
  //if (p.trailMode == 1 || p.debug) {background(p.bkgColor);}
  if (p.trailMode == 2) {trails();}
  colony.run();
  manageColony();
  //if (colony.cells.size() == 0) { if ((keyPressed == true) || p.autoRestart) {populateColony(); } } // Repopulate the colony when all the cells have died
}

void populateColony() {
  if (p.greyscaleON) {background(p.bkgColGrey); } else {background(p.bkgColGrey);} // flush the background
  colony.cells.clear();
  colony = new Colony();
}

void trails() {
  blendMode(SUBTRACT);
  noStroke();
  fill(1);
  rect(0,0,width,height);
  blendMode(BLEND);
  fill(255);
}

void manageColony() {
  if (colony.cells.size() == 0 || frameCount > 5000) { //  If an extinction has occurred...
    if (p.screendumpON) {screendump();} //WARNING! ALWAYS repopulate & restart the colony after doing this once!
    exit();
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
  if (key == '1') {println("1"); p.trailMode = 1;}
  if (key == '2') {println("2"); p.trailMode = 2;}
  if (key == '3') {println("3"); p.trailMode = 3;}
  if (key == 'r') {println("r"); colony.cells.clear();}
  if (key == 'b') {println("b"); background(p.bkgColGrey); }
  if (key == 'd') {println("d"); p.debug = !p.debug; }
  if (key == 'n') {println("n"); p.nucleus = !p.nucleus; }
  if (key == 's') {println("s"); screendump();}
}