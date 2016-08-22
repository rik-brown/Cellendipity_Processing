class Colony {

  // VARIABLES
  ArrayList<Cell> cells;    // An arraylist for all the cells
  PVector fillCol;          // PVector col needs to be declared to allow for random picker
  float size;               // Used to draw a line showing colony size
  float rStart;
  float colRand = random( -PI, PI);
  float colOff1 = random( -PI/12, PI/12);
  float colOff2 = random( -PI/12, PI/12);
  float spin = random (0, TWO_PI);
  
  // CONSTRUCTOR: Create a 'Colony' object, initially populated with 'num' cells
  Colony(int num, float rStart_) {         // Imports 'num' from Setup in main, the number of Cells in initial spawn 
    
    // Create initial population of cells
    cells = new ArrayList<Cell>();                              // Initialize the arraylist
    float colRand = random( -PI, PI);
    float colOff1 = random( -PI/12, PI/12);
    float colOff2 = random( -PI/18, PI/18);
    rStart = rStart_;
        
    for (int i = 0; i < num; i++) {
      
      // 1) Divide a circle into num segments
      float offsetAngle = TWO_PI/num;
      /*PVector pos = PVector.fromAngle(i*offsetAngle);
      PVector vel = pos.copy(); // Make a copy before setting magnitude. In this case, direction is pointing outwards
      // 2) The starting radius and number of cells determine the radius R of the circle 
      // (num * rStart * 2 = circumference = TWO_PI * R)
      // R = num * rStart / PI;
      pos.mult(num * rStart / PI);
      //pos.mult(200); //start with fixed radius for now
      pos.add(width/2, height/2); //to locate the center of the circle in the middle of the canvas
      
      //vel.mult(-1); //reverse the direction to point inwards (for collisions...)
      vel.rotate(spin);
      */
      PVector pos = new PVector(random(rStart, (width-rStart)), random(rStart, (height-rStart)));  // Initial position vector is random
      //PVector pos = new PVector(width/2, height/2);           // Initial position vector is center of canvas
      //PVector pos = new PVector(   (((i+1)*2*rStart) + rStart/2), height/2);
      
      PVector vel = PVector.random2D();                         // Initial velocity vector is random
      
      fillCol = PVector.fromAngle(0);
      //fillCol = new PVector();
      //fillCol = PVector.fromAngle(i*offsetAngle);
      //fillCol = PVector.fromAngle((i/20)+1);
      
      //// COLOUR NOT RANDOM
      //float colourPicker = random(1); // To select between Red, Green or Blue with equal probability
      //if (colourPicker <= 0.333){ fillCol = PVector.fromAngle(colRand); }      // This angle gives BLACK (maps to 0)
      //else if (colourPicker <= 0.666){ fillCol = PVector.fromAngle(colRand + colOff1); } // This angle gived BLUE (maps to 240)
      //else { fillCol = PVector.fromAngle(colRand + colOff2); }                       // This angle gived WHITE (maps to 360)
      
      
      
      
      DNA dna = new DNA();                                      // Get new DNA
      cells.add(new Cell(pos, vel, fillCol, dna, rStart));                  // Add new Cell with DNA
      //println("i:" + i + " fillColHead:" + fillCol.heading());
    } // closes for-i-loop
     
   } // closes Constructor


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