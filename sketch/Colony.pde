class Colony {

  // VARIABLES
  ArrayList<Cell> cells;    // An arraylist for all the cells
  int colonyMaxSize = 300;

  // CONSTRUCTOR: Create a 'Colony' object, initially populated with 'num' cells
  Colony(int colonySize) {

    // Create initial population of cells
    cells = new ArrayList<Cell>();                              // Initialize the arraylist
    for (int i = 0; i < p.numStrains; i++) {
      DNA dna = new DNA();
      if (p.centerSpawn) {PVector pos = new PVector(width/2, height/2);}  // Initial position vector is centered
      else {PVector pos = new PVector(random(width), random(height));} // Initial position vector is random
      for (int j = 0; j < p.strainSize; j++) {
        PVector vel = PVector.random2D();   // Initial velocity vector is random
        cells.add(new Cell(pos, vel, dna)); // Add new Cell with DNA
      }
    }
   }


  void spawn(float xpos, float ypos, float xvel, float yvel, float hue, float sat, float rStart) {
  // Spawn a new cell (called by e.g. MousePressed in main, accepting mouse coords for start position)
    PVector pos = new PVector(xpos, ypos);
    PVector vel = new PVector(xvel, yvel);

    PVector fillCol = PVector.fromAngle(hue); //Create a new PVector from the hue angle
    fillCol.setMag(sat);
    DNA dna = new DNA();
    cells.add(new Cell(pos, vel, fillCol, dna, rStart));
    debugTextColony();  // Debug only
  } // closes spawn method



  void run() {        // Run the colony

    //debugTextColony();  // Debug only

    for (int i = cells.size()-1; i >= 0; i--) {  // Iterate backwards through the ArrayList because we are removing items
      Cell c = cells.get(i);                     // Get one cell at a time //<>// //<>// //<>// //<>// //<>//
      c.run();                                   // Run it (grow, move, boundaries etc.)
      if (c.dead()) {
        cells.remove(i);
        debugTextColony();  // Debug only
      }         // If it has died, remove it

      // Iteration to check collision between current cell(i) and the rest
      if (cells.size() <= colonyMax) {                          // Don't check for collisons if there are too many cells (wait until some die off)
        for (int others = i-1; others >= 0; others--) {         // Since main iteration (i) goes backwards, this one needs to too
          Cell other = cells.get(others);                       // Get the other cells, one by one
          //stroke(128, 32);
          //line (c.position.x, c.position.y, other.position.x, other.position.y); // old thing, playing around
          // c.checkCollision(other); No age-limit, use wisely
          if (c.age > 20 && other.age > 20) { c.checkCollision(other); } // Don't check for collisions between newly-spawned cells
        } // closes for - others - loop
      } // closes -if-
    } // closes for - i - loop

   if (cells.size() > colonyMax) { cull(50); }   // If there are still too many cells, remove some by 'culling' (not actually active now)

  } // End of 'run' method



  void cull(int div)  {  // To remove a proportion of the cells from (the oldest part of) the colony
    int cull = (cells.size()/div);
    //for (int i = cull; i >= 0; i--) { cells.remove(i); } // Not in use - only active part is to draw a transparent 'veil' when method is called.
    //background(0);
    //fill(255, 1);
    //rect(-1, -1, width+1, height+1);
  }

  void cullAll()  {    // To remove ALL cells from the colony
    cells.clear();
  }

  void debugTextColony() {  // For debug only
    noStroke();
    fill(128);
    rect(0,0,240,22);
    fill(360);
    textSize(12);
    text("Nr. cells: " + cells.size() + " MinLimit:" + colonyMin+ " MaxLimit:" + colonyMax, 10, 20);
  }

} // End of 'Colony' class
