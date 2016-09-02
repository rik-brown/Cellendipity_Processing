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
    fillDisable = false;
    strokeDisable = false;
    greyscaleON = false;
    nucleus = true;
    stepped = true;
    wraparound = false;

    strainSize = int(random(1,10)); // Number of cells in a strain
    numStrains = int(random(1,3)); // Number of strains (a group of cells sharing the same DNA)
    stepSize = 0;
    stepSizeN = 0;
    trailMode = 3; // 1=none, 2 = blend, 3 = continuous

    bkgColor = color(random(360), random(255), random(255)); // Background colour
    bkgColGrey = 128;

    fill_HTwist = 0;
    fill_STwist = 0;
    fill_BTwist = 64;
    fill_ATwist = 0;

    stroke_HTwist = 0;
    stroke_STwist = 128;
    stroke_BTwist = 0;
    stroke_ATwist = 128;
  }
}
