class Colony {

  // VARIABLES
  ArrayList<Cell> cells;    // An arraylist for all the cells //<>// //<>// //<>//
  int colonyMaxSize = 300;

  // CONSTRUCTOR: Create a 'Colony' object, initially populated with 'num' cells
  Colony() {

    // Create initial population of cells
    cells = new ArrayList<Cell>();                              // Initialize the arraylist
    for (int i = 0; i < p.numStrains; i++) {
      DNA dna = new DNA();
      // if (p.centerSpawn == true) {PVector pos = new PVector(width/2, height/2);}  // Initial position vector is centered
      // else {PVector pos = new PVector(random(width), random(height));} // Initial position vector is random
      PVector pos = new PVector(width/2, height/2);
      for (int j = 0; j < p.strainSize; j++) {
        PVector vel = PVector.random2D();   // Initial velocity vector is random
        cells.add(new Cell(pos, vel, dna)); // Add new Cell with DNA
      }
    }
  }

// Spawn a new cell (called by e.g. MousePressed in main, accepting mouse coords for start position)
  void spawn(PVector mousePos, PVector vel, DNA dna_) {
    cells.add(new Cell(mousePos, vel, dna_));
  }

// Run the colony
  void run() {
    if (p.debug) {colonyDebugger(); }
    for (int i = cells.size()-1; i >= 0; i--) {  // Iterate backwards through the ArrayList because we are removing items
      Cell c = cells.get(i);                     // Get one cell at a time
      c.run();                                   // Run the cell (grow, move, spawn, check position vs boundaries etc.)
      if (c.dead()) {cells.remove(i);}           // If the cell has died, remove it from the array

      // Iteration to check collision between current cell(i) and the rest
      if (cells.size() <= colonyMaxSize && c.fertile) {             // Don't check for collisons if there are too many cells (wait until some die off)
        for (int others = i-1; others >= 0; others--) {         // Since main iteration (i) goes backwards, this one needs to too
          Cell other = cells.get(others);                       // Get the other cells, one by one
          if (other.fertile) { c.checkCollision(other); }       // Only check for collisions when both cells are fertile
        }
      }
    }
    // If there are too many cells, remove some by 'culling'
   if (cells.size() > colonyMaxSize) { cull(colonyMaxSize); }
  }

  void cull(int div)  {  // To remove a proportion of the cells from (the oldest part of) the colony
    int cull = (cells.size()/div);
    for (int i = cull; i >= 0; i--) {cells.remove(i); }
  }

  void colonyDebugger() {  // Displays some values as text at the top left corner (for debug only)
    noStroke();
    fill(0);
    rect(0,0,230,40);
    fill(360);
    textSize(16);
    text("Nr. cells: " + cells.size() + " MaxLimit:" + colonyMaxSize, 10, 18);
    text("TrailMode: " + p.trailMode + " Debug:" + p.debug, 10, 36);
  }
}