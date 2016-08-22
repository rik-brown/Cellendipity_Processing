class Cell {
  
  //  Objects
  DNA dna;         // DNA
  
  // BOOLEAN - Define settings for the whole colony - do they need to exist per cell?
  // These variables might need to be kept cell-specific (to be changed individually based on rules & events)
  boolean moving;     // Changing position
  boolean spawning;   // Reproducing new cells on collision (if fertility rules are met)
  boolean displaying; // Being displayed
  
  //  Variables for movement (COMMON)
  PVector position;
  PVector velocity; 
    
  //  Variables for movement (LINEAR+COLLISONS)
  float m;  // Mass
    
  //  Variables for movement (PERLIN only)
  float vMax;   // multiplication factor for velocity
  float xoff;       // x offset
  float yoff;       // y offset
  float step;       // step size
  
  //  Variables for COLOUR
  PVector fill_Colour;   // For HSB you need Hue to be the heading of a PVector
  PVector spawnCol;      // spawnCol needs to be a GLOBAL variable
  float fill_HR;         // Hue (HSB) / Red (RGB)
  float fill_SG;         // Saturation (HSB) / Green (RGB)
  float fill_BB;         // Brightness (HSB) / Blue (RGB)
  float fill_Alpha;      // Transparency (HSB & RGB)
  PVector stroke_Colour; // For HSB you need Hue to be the heading of a PVector
  float stroke_HR;       // Hue (HSB) / Red (RGB)
  float stroke_SG;       // Saturation (HSB) / Green (RGB)
  float stroke_BB;       // Brightness (HSB) / Blue (RGB)
  float stroke_Alpha;    // Transparency (HSB & RGB)
  float strokeOffset;
  float seed_Alpha;      // Transparency of seed
  
  //  Variables for GROWTH AND REPRODUCTION
  float age;       // Age (nr. of frames since birth)
  float fertility; // Condition for becoming fertile
  //float fertile; // Limit for fertility (it used to be a counter before turning boolean. Might turn back...)
  boolean fertile; // Fertile is a BOOLEAN state
  float health;    // Health. Counts down from initial value to 0 (= DEATH)
  int collCount;   // Counter for number of collisions. Counts down from initial value to 0 (= DEATH)
  
  //  Variables for SIZE AND SHAPE
  float rStart;      // Starting radius
  float r;         // Radius (half the width/height of the ellipse, which is drawn with width = r * 2)
  float rMin;      // Minimum (& starting) radius
  float rMax;      // Maximum radius 
  int rMaxMax;// Highest possible rMax when mapping
  float growth;    // Radius grows by this amount per frame
  int growShrink;  // If 1 then growth is positive (expansion), if -1 then growth is negative (contraction)
  float flatness;  // To make flatter ellipses (1 = circle)
  float drawStep;  // To enable spacing of the drawn object (ellipse)
  float drawStepMax;
  
  boolean toggle;
  float handedness;
  
    
  // CONSTRUCTOR: create a 'cell' object  
  Cell (PVector pos, PVector vel, PVector fillCol, DNA dna_, float rStart_) {
  // OBJECTS
  dna = dna_;
  // gene assignment:
  // 0 = rMin
  // 1 = rMax
  // 2 = growth
  // 3 = step
  // 4 = vMax
  // 5 = fill_HR
  // 6 = fill_SG
  // 7 = fill_BB
  // 8 = fill_Alpha
  // 9 = stroke_HR
  // 10 = stroke_SG
  // 11 = stroke_BB
  // 12 = stroke_Alpha
  // 13 = flatness
  
  // BOOLEAN
  moving = true;
  spawning = true;
  displaying = true;
  toggle = false; //Used when movement is stepped. Always false to begin with.
  fertile = false; // A new cell always starts off infertile
  
    
  // GROWTH AND REPRODUCTION
  age = 0; // A new cell always starts with age = 0
  fertility = 0.9;
  //fertility = random(0.75, 0.85); // Percentage of radius. If r is less than this (when r tends to shrink) then fertile = true
  health = 300;   // Max. number of frames before DEATH
  collCount = 10;  // Max. number of collisions before DEATH
    
  // SIZE AND SHAPE
  rMaxMax = 100;
  rStart = rStart_;
  r = rStart;          // Initial value for radius
  //rMax = rStart + map(dna.genes[1], 0, 1, 1, rMaxMax);
  rMax = 100;
  //rMin = map(dna.genes[0], 0, 1, 1, rStart/3);
  rMin = r * 0.03;
  //growth = 0; // For fixed radius
  //growth = 0.1; // Simple linear growth, all cells identical
  growth = map(dna.genes[2], 0, 1, 0.03, 0.03); // Simple linear growth, all cells unique
  //growth = 1/(rStart-r+1);
  //growth = (rStart-r+0.3)/rStart;
  //growth = (rStart-r+1)/rStart;
  growShrink = -1; // Growth is +ve = Expansion. Growth is -ve = Contraction.
  growth *= growShrink;
  //flatness = map(dna.genes[13], 0, 1, 1, 1.4); // Scaling factor for radius in 'height' axis
  flatness = 1;
  drawStepMax = r*2/3;
  //drawStepMax = 8;
  //drawStep = r*2;
  //drawStep = r*2/velocity.mag();
  drawStep = drawStepMax;
  handedness = random(1); // Controls spiralling direction
 
  // COMMON
  position = pos.copy();
  velocity = vel.copy();
  //velocity.mult(2);      // Does initial velocity not have a magnitude? Or is this to allow for individual variation?
      
  // PERLIN
  vMax = map(dna.genes[4], 0, 1, 0, 4);
  xoff = random(1000); //Seed for noise
  yoff = random(1000); //Seed for noise
  step = map(dna.genes[3], 0, 1, 0.005, 0.05);
  
  // COLOUR
  
  // COLOUR FROM DNA
    //fill_HR = map(dna.genes[5], 0, 1, 0, 360);
    //fill_SG = map(dna.genes[6], 0, 1, 0, 100);
    //fill_BB = map(dna.genes[7], 0, 1, 0, 100);
    //fill_Alpha = map(dna.genes[8], 0, 1, 0, 100);
    
    //stroke_HR = map(dna.genes[9], 0, 1, 0, 360);
    //stroke_SG = map(dna.genes[10], 0, 1, 0, 100);
    //stroke_BB = map(dna.genes[11], 0, 1, 0, 100);
    //stroke_Alpha = map(dna.genes[12], 0, 1, 0, 100);
  
  // COLOUR FROM FIXED VALUES
    //fill_HR = 0;
    fill_SG = 100;  
    fill_BB = 100;
    fill_Alpha = 100;
    
    stroke_HR = 180;
    stroke_SG = 100;
    stroke_BB = 100;
    stroke_Alpha = 4; // (previous: 18, 45, 24)

  // COLOUR FROM VECTORS
    fill_Colour = fillCol;
    fill_Colour = fillCol.copy(); // Is this actually needed? Why a copy and not just = ?
    ////println("fillColHead: " + fill_Colour.heading()); //DEBUG
    fill_HR = map(fill_Colour.heading(), -PI, PI, 0, 360); // Hue is an angle between 0-360 given by the heading of the colour vector
    //fill_SG = map(fill_Colour.mag(), 0, 1, 0, 100);  

  // COLOUR FROM SIZE
    //fill_HR = map(r, rStart, rMaxMax, 0, 360);
    //fill_BB = map(r, rStart, rMaxMax, 0, 100);
    seed_Alpha = map(r, rStart, (rStart*fertility), 0, 50);

  // COLOUR <other stuff>
    strokeOffset = random (-PI/2, PI/2); // Used in colourTwist to offset the stroke colour from the fill colour by this angle
  
  // LINEAR+COLLISIONS
  m = r * 0.1;
  }

  void run() {
    live();
    if (moving) {changePosition();}
    if (growing) {changeSize();}
    if (transforming) {changeShape();}
    if (colouring) {changeColour();}
    if (rebounding) {checkBoundaryRebound();} else {checkBoundaryWraparound();}
    if (spawning) {changeFertility();}
    if (displaying) {display();}
    //debugTextCell(); // FOR DEBUG ONLY
  }  //<>//
  
  void changePosition() { //Update parameters linked to the position
    if (perlin) {movePerlin();} else {moveLinear();}
  }
   
  void changeShape() { // Update parameters linked to the shape
    // Nothing happening here
  }
    
  void live() { 
    age ++;
    //health -= 1; //health is not in use
    drawStep --;
    drawStepMax = r/3;
    if (drawStep < 0) {drawStep = drawStepMax; toggle = true; }
    if (collCount ==0) {fertile = false;}
  }
  
  void changeSize() { // Put all code related to updating SIZE variables HERE
    r += growth; // Simple linear growth
    //growth = 1/(rStart-r+1);  // Comment this out for linear growth
    //growth = ((rStart-r+0.1)*2)/(rStart*13);  // Comment this out for linear growth
    //growth *= growShrink; // Earlier attempt to toggle between +ve and -ve growth. Needs some work...
    //if (r >= rMax) { growth *= -1; } // To cause a growing r to 'rebound' when upper limit is reached
  }
  
  void changeFertility() { // Put all code related to updating Fertility variables HERE
    if (r < rStart * fertility) {fertile = true;} else {fertile = false;} // A cell is fertile if r is within limit (a % of rStart)
  }
  
  void changeColour() {
    //fill_HR = map(r, rMin, rStart, 0, 360);    // Modulate fill hue by radius 
    //fill_BB = map(r, rMin, rStart, 100, 50);      // Modulate fill brightness by radius
    //fill_SG = map(r, rMin, rStart, 20, 100);      // Modulate fill saturation by radius
    //fill_Alpha = map(r, rMin, rStart, 100, 20);  // Modulate fill_Alpha by radius
    stroke_Alpha = map(r, rMin, rStart, 45, 5); // Modulate stroke_Alpha by radius
    seed_Alpha = map(r, rStart, (rStart*fertility), 0, 50);
    if (colourtwisting) {colourTwist();}
  }

  void moveLinear() {
    if (spiralling) {velTwist();}
    if (steppedOld) {
      velocity.normalize();           // Convert to a unit-vector (magnitude = 1)
      velocity.mult(r + r + growth);} // Set the magnitude to a size which will place the two consecutive circles adjacent to one another.
    position.add(velocity);
  }

 void movePerlin() {
    // Simple movement based on perlin noise
    float vx = map(noise(xoff),0,1,-vMax,vMax);
    float vy = map(noise(yoff),0,1,-vMax,vMax);
    velocity = new PVector(vx,vy);
    xoff += step;
    yoff += step;
    if (steppedOld) {
      velocity.normalize();          // Convert to a unit-vector (magnitude = 1)
      velocity.mult(r + r + growth); // Set the magnitude to a size which will place the two consecutive circles adjacent to one another.
    }
    position.add(velocity);
  }
    
  void checkBoundaryRebound() {
    if (position.x > width-r) {
      position.x = width-r;
      velocity.x *= -1;
    } 
    else if (position.x < r) {
      position.x = r;
      velocity.x *= -1;
    } 
    else if (position.y > height-r) {
      position.y = height-r;
      velocity.y *= -1;
    } 
    else if (position.y < r) {
      position.y = r;
      velocity.y *= -1;
    }
  }

  void checkBoundaryWraparound() {
    if (position.x > width+r) {
      position.x = -r;
    } 
    else if (position.x < -r) {
      position.x = width+r;
    } 
    else if (position.y > height+r) {
      position.y = -r;
    } 
    else if (position.y < -r) {
      position.y = height+r;
    }
  }

 //<>//
  // Death
  boolean dead() {
    //if (velocity.mag() == 0) {return true; } // Death if stationary
    //if (collCount <= 0) {return true; } // Death if collision limit reached
    if (r < rMin) {return true; } // Death if size lower limit reached
    //if (health <0) {return true; } // Death if no health left
    if (position.x > width+r ||  position.x < -r || position.y > height+r ||  position.y < -r) { return true;  } // Death if move beyond canvas boundary
    else { return false; }
    //return false; // Use if no death
  }


  // Copied from the original Evolution EcoSystem sketch
  // NOT IN USE
  // Called from 'run' in colony to determine if a cell will spontaneously (& asexually) reproduce
  // Note: instead of void, the method returns a 'Cell' object
  Cell reproduce() {
    if (random(1) < 0.003) {
      DNA childDNA = dna.copy();    // Child DNA is exact copy of single parent
      // childDNA.geneMutate(0.01); // DNA can mutate if a random number is less than 0.01
      return new Cell (position, velocity, fill_Colour, childDNA, rStart); // this is a pretty cool trick!
    } 
    else {
      return null; // If no child was spawned
    }
  }
 
  void colourTwist() { // To calculate fill colour H (in HSB) from PVector 'fill_Colour' heading. Assumes fill_HR is started from fill_colour PVector
    float twistAngle = map(r, rMin, rStart, -PI/12, PI/12);  // (rMax*PI/rMaxMax*4)
    PVector fillTemp = fill_Colour.copy();
    fillTemp.rotate(twistAngle); // Temporary vector to avoid the need to rotate back again
    spawnCol = fillTemp.copy();  // Set the spawnCol at the 'twisted' fillColour now (needed because colour is passed on as a vector, not fill_HR)
    fill_HR = map(fillTemp.heading(), -PI, PI, 0, 360);
    flatness = map(twistAngle, -PI/12, PI/12, 1, 1); // NOTE: This should probably be a seperate function 'shapetwist'
    
    fillTemp.rotate(strokeOffset); // stroke_HR has opposite heading to fill_HR. Angle offset could be mapped from something...
    //stroke_HR = map(fillTemp.heading(), -PI, PI, 0, 360); 
  }
  
  void velTwist() { // For linear movement, adds an angular offset to the velocity vector, causing spirals
    PVector twist = velocity.copy();
    twist.normalize();
    float twistAngle = map(r, rStart, rMax, PI/360, 0);
    if (handedness >= 0.5) {twistAngle *= -1; }
    twist.rotate(twistAngle); 
    velocity.add(twist);
    velocity.normalize();
  }
   
  void display() { 
    if (greyscale) {
      stroke(stroke_HR); //stroke = Greyscale, 100% Alpha
      //stroke(stroke_HR, stroke_Alpha); // stroke = Greyscale
      //stroke(fill_HR, stroke_Alpha);   // stroke = Greyscale (use fill colour)
      fill(fill_HR, fill_Alpha); // fill = Greyscale
    }
    else {
      stroke(stroke_HR, stroke_SG, stroke_BB, stroke_Alpha); // stroke = Colour
      //stroke(fill_HR, stroke_SG, stroke_BB, stroke_Alpha);   // stroke = Colour (use fill colour)
      fill(fill_HR, fill_SG, fill_BB, fill_Alpha); // fill = Colour
    }
    //if (!fertile) {noStroke();}
    //noFill(); 
          
    if (stepped) { // Will only draw ellipse when toggle is true, giving a stepped effect. See develop();
      if (toggle) {
      float angle = velocity.heading();
      pushMatrix();
      translate(position.x,position.y);
      rotate(angle);
      ellipse(0, 0, r, r*flatness);
      popMatrix();
      toggle = false;
      }
    }
    else {
      float angle = velocity.heading();
      pushMatrix();
      translate(position.x,position.y);
      rotate(angle);
      ellipse(0, 0, r, r*flatness);
      if (fertile) {fill(0); ellipse(0, 0, rMin, rMin);} else {fill(255); ellipse(0, 0, rMin, rMin);}
      //if (fertile) {fill(255); ellipse(0, 0, rMin, rMin);} else {fill(255, seed_Alpha); ellipse(0, 0, rMin, rMin);}
      //if (fertile) {fill(255); noStroke(); ellipse(0, 0, rMin, rMin);} else {stroke(255); noFill(); ellipse(0, 0, rMin, rMin);}
      popMatrix();
    }
  }

  void checkCollision(Cell other) {       // Method receives a Cell object 'other' to get the required info about the collidee
    if (fertile) {                        // Collision is only checked on fertile cells. 
                                          // This is a hack to prevent young spawn from colliding with their parents. Is already prevented in Colony by age-limit (20)
      PVector distVect = PVector.sub(other.position, position); // Static vector to get distance between the cell & other
    
      // calculate magnitude of the vector separating the balls
      float distMag = distVect.mag();
      
      if (distMag < (r + other.r)) { // Test to see if a collision has occurred : is distance < sum of cell radius + other cell radius?
        
        //growth *= -1;         // Trying an idea - collision causes growthrate to toggle, even for infertile cells. See below.
        //other.growth *= -1;
        
        //grow = false;         // Trying an idea - stop growing on collision
        //other.grow = false;
        //move = false;         // Trying an idea - stop moving on collision
        //other.move = false;
                
        if (fertile && other.fertile) { // Test to see if both cell & other are fertile
            
         //growth *= -1;         // Collision resulting in spawn causes growth-rate to toggle.
         //other.growth *= -1;
          
         // Update radius's    // Trying an idea - collision causes radius to shrink
         //r *= 0.1;
         //other.r *= 0.1;
          
         // Decrease collision counters. NOTE Only done on spawn, so is more like a 'spawn limit'
         collCount --;
         other.collCount --;
                  
         // Calculate position for spawn based on PVector between cell & other (leaving 'distVect' unchanged, as it is needed later)
         PVector spawnPos = distVect.copy();  // Create spawnPos as a copy of the (already available) distVect which points from parent cell to other
         spawnPos.normalize();
         spawnPos.mult(r);               // The spawn position is located at parent cell's radius
         spawnPos.add(position);
          
         // Calculate velocity vector for spawn as being centered between parent cell & other
         PVector spawnVel = velocity.copy(); // Create spawnVel as a copy of parent cell's velocity vector 
         spawnVel.add(other.velocity);       // Add dad's velocity
         spawnVel.normalize();               // Normalize to leave just the direction and magnitude of 1 (will be multiplied later)
          
         // Calculate colour vector for spawn
         PVector spawnCol = fill_Colour.copy(); // Create spawnCol by copying the current cell's colour vector
         spawnCol.add(other.fill_Colour);       // Add the other cell's colour vector (for heading)
         spawnCol.normalize();          // Normalize to magnitude = 1
         float spawnMag = (fill_Colour.mag() + other.fill_Colour.mag())/2; // New magnitude is average of mum & dad. Could this be the culprit? //<>// //<>//
         spawnCol.mult(spawnMag);       // Give spawnCol the averaged magnitude
          
         // Calculate rStart for child;
         rStart = r; // Spawn starts with same radius as current r (& resets fertility at the same time)
         other.rStart = other.r; // Resets fertility for other too
          
         // Call spawn method (in Colony) with the new parameters for position, velocity and fill-colour etc.)
         colony.spawn(position.x, position.y, spawnVel.x, spawnVel.y, spawnCol.heading(), spawnCol.mag(), rStart);
                   
         // Reset fertility counter (from before fertile became boolean)
         //fertility = 0;
         //other.fertility = 0;
        }
      
      // get angle of distVect
      float theta  = distVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      // posTemp will hold rotated cell positions. You just need to worry about posTemp[1] position
      PVector[] posTemp = { new PVector(), new PVector() };

      /* this ball's position is relative to the other so you can use the vector between them (distVect) as the reference point in the rotation expressions.
      posTemp[0].position.x and posTemp[0].position.y will initialize automatically to 0.0, which is what you want since b[1] will rotate around b[0] */
      posTemp[1].x  = cosine * distVect.x + sine * distVect.y;
      posTemp[1].y  = cosine * distVect.y - sine * distVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = { new PVector(), new PVector() };

      vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      // Now that velocities are rotated, you can use 1D conservation of momentum equations to calculate  the final velocity along the x-axis.
      PVector[] vFinal = { new PVector(), new PVector() };

      // final rotated velocity for b[0]
      vFinal[0].x = ((m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (m + other.m);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((other.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + other.m);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping (???????? How does it work, actually?)
      posTemp[0].x += vFinal[0].x;
      posTemp[1].x += vFinal[1].x;

      // Rotate ball positions and velocities back. Reverse signs in trig expressions to rotate in the opposite direction
      PVector[] posFinal = { new PVector(), new PVector() };

      posFinal[0].x = cosine * posTemp[0].x - sine * posTemp[0].y;
      posFinal[0].y = cosine * posTemp[0].y + sine * posTemp[0].x;
      posFinal[1].x = cosine * posTemp[1].x - sine * posTemp[1].y;
      posFinal[1].y = cosine * posTemp[1].y + sine * posTemp[1].x;

      // update balls to screen position
      other.position.x = position.x + posFinal[1].x;
      other.position.y = position.y + posFinal[1].y;

      position.add(posFinal[0]);

      // update velocities
      velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;   
      }
    }
  }

  void debugTextCell() { // For debug only
     //stroke(255);
     fill(0);
     //textSize(12);
     //text("Cells alive:" + colony.cells.size(), 0, 10);
     textSize(15);
     text("r:" + r, position.x, position.y);
     text("rStart:" + rStart, position.x, position.y+10);
     //text("fill_HR:" + fill_HR, position.x, position.y);
     
     //text("rMax:" + rMax, position.x, position.y+30);
     //text("growth:" + growth, position.x, position.y+30);
     //text("age:" + age, position.x, position.y+20);
     text("fertile:" + fertile, position.x, position.y+30);
     text("fertility:" + fertility, position.x, position.y+40);
     text("collCount:" + collCount, position.x, position.y+50);
     //text("x-velocity:" + velocity.x, position.x, position.y+0);
     //text("y-velocity:" + velocity.y, position.x, position.y+10);
     //text("velocity heading:" + velocity.heading(), position.x, position.y+20);
     //println("X: " + position.x + "   Y:" + position.y + "   r:" + r + "   m:" + m + "  collCount:" + collCount);
     //println("X: " + position.x + "   Width+r:" + (width+r) + "   Y:" + position.y  + "   height+r:" +(height+r) + "  r:" + r);
     }



}  