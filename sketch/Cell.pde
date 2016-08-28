class Cell {

  //  Objects
  DNA dna;         // DNA

  // BOOLEAN
  boolean fertile;

  // GROWTH AND REPRODUCTION
  float age;       // Age (nr. of frames since birth)
  float lifespan;
  float fertility; // Condition for becoming fertile
  float maturity;
  int spawnCount;

  // SIZE AND SHAPE
  float cellStartSize;
  float cellEndSize;
  float r;         // Radius (half the width/height of the ellipse, which is drawn with width = r * 2)
  float flatness;  // To make flatter ellipses (1 = circle)
  float growth;    // Radius grows by this amount per frame
  float drawStep;  // To enable spacing of the drawn object (ellipse)
  float drawStepN;

  // MOVEMENT
  PVector position;
  PVector velocityLinear;
  PVector velocityNoise;
  PVector velocity;
  float noisePercent;
  float spiral;
  float vMax;   // multiplication factor for velocity
  float xoff;       // x offset
  float yoff;       // y offset
  float step;       // step size

  // FILL COLOUR
  color fillColor;   // For HSB you need Hue to be the heading of a PVector
  color spawnCol;      // spawnCol needs to be a GLOBAL variable
  float fill_H;         // Hue (HSB) / Red (RGB)
  float fill_S;         // Saturation (HSB) / Green (RGB)
  float fill_B;         // Brightness (HSB) / Blue (RGB)
  float fillAlpha;      // Transparency (HSB & RGB)

  // FILL COLOUR
  color strokeColor; // For HSB you need Hue to be the heading of a PVector
  float stroke_H;       // Hue (HSB) / Red (RGB)
  float stroke_S;       // Saturation (HSB) / Green (RGB)
  float stroke_B;       // Brightness (HSB) / Blue (RGB)
  float strokeAlpha;    // Transparency (HSB & RGB)

  // CONSTRUCTOR: create a 'cell' object
  Cell (PVector pos, PVector vel, DNA dna_) {
  // OBJECTS
  dna = dna_;

  // DNA gene mapping (12 genes) NEW
  // 0 = fill Hue & vMax (Noise)
  // 1 = fill Saturation
  // 2 = fill Brightness & Spiral screw
  // 3 = fill Alpha
  // 4 = stroke Hue & step (Noise)
  // 5 = stroke Saturation
  // 6 = stroke Brightness & noisePercent
  // 7 = stroke Alpha
  // 8 = cellStartSize & Fertility (large size = lower fertility)
  // 9 = cellEndSize
  // 10 = lifespan & spawnCount (long lifespan = few children)
  // 11 = flatness & spiral handedness

  // BOOLEAN
  fertile = false; // A new cell always starts off infertile

  // GROWTH AND REPRODUCTION
  age = 0; // Age is 'number of frames since birth'. A new cell always starts with age = 0. From age comes maturity
  lifespan = map(dna.genes[10], 0, 1, 500, 2000);
  fertility = map(dna.genes[8], 1, 0, 0.7, 0.9); // How soon will the cell become fertile?
  maturity = map(age, 0, lifespan, 1, 0);
  spawnCount = int(map(dna.genes[10], 1, 0, 1, 5)); // Max. number of spawns

  // SIZE AND SHAPE
  cellStartSize = map(dna.genes[8], 0, 1, 10, 30);
  cellEndSize = cellStartSize * map(dna.genes[9], 0, 1, 0, 0.1);
  //r = cellStartSize; // Initial value for radius
  flatness = map(dna.genes[11], 0, 1, 0.5, 2); // To make circles into ellipses. range 0.5 - 1.5

  growth = (cellStartSize-cellEndSize)/lifespan; // Should work for both large>small and small>large
  drawStep = 1;
  drawStepN = 1;

  // MOVEMENT
  position = pos.copy(); //cell has position
  velocityLinear = vel.copy(); //cell has unique basic velocity component
  noisePercent = dna.genes[6]; // How much influence on velocity does Perlin noise have?
  spiral = map(dna.genes[2], 0, 1, -0.75, 0.75); // Spiral screw amount
  vMax = map(dna.genes[0], 0, 1, 0, 5); // Maximum magnitude in velocity components generated by noise
  xoff = random(1000); //Seed for noise
  yoff = random(1000); //Seed for noise
  step = map(dna.genes[3], 0, 1, 0.005, 0.005); //Step-size for noise

  // COLOUR

  fill_H = map(dna.genes[0], 0, 1, 0, 360);
  fill_S = map(dna.genes[1], 0, 1, 0, 255);
  fill_B = map(dna.genes[2], 0, 1, 0, 255);
  fillColor = color(fill_H, fill_S, fill_B); // Initial color is set
  fillAlpha = map(dna.genes[3], 0, 1, 128, 255);

  stroke_H = map(dna.genes[4], 0, 1, 0, 360);
  stroke_S = map(dna.genes[5], 0, 1, 0, 255);
  stroke_B = map(dna.genes[6], 0, 1, 0, 255);
  strokeColor = color(stroke_H, stroke_S, stroke_B); // Initial color is set
  strokeAlpha = map(dna.genes[7], 0, 1, 0, 64);
  }

  void run() {
    live();
    updatePosition();
    updateSize();
    updateFertility();
    updateColour();
    if (p.wraparound) {checkBoundaryWraparound();}
    display();
    if (p.debug) {cellDebugger();}
  }

  void live() {
    age ++;
    maturity = map(age, 0, lifespan, 1, 0);
    drawStep --;
    float drawStepStart = map(p.stepSize, 0, 100, 0 , (r *2 + growth));
    if (drawStep < 0) {drawStep = drawStepStart;}
    drawStepN--;
    float drawStepNStart = map(p.stepSizeN, 0, 100, 0 , r *2);
    if (drawStepN < 0) {drawStepN = drawStepNStart;}
  }

  void updatePosition() { //Update parameters linked to the position
    float vx = map(noise(xoff),0,1,-vMax,vMax);
    float vy = map(noise(yoff),0,1,-vMax,vMax);
    velocityNoise = new PVector(vx,vy);
    xoff += step;
    yoff += step;
    velocity = PVector.lerp(velocityLinear, velocityNoise, noisePercent); //<>// //<>//
    float screwAngle = map(maturity, 0, 1, 0, spiral * TWO_PI);
    if (dna.genes[11] >= 0.5) {screwAngle *= -1;}
    velocity.rotate(screwAngle);
    position.add(velocity);
  }

  void updateSize() {
    r = ((sin(map(maturity, 1, 0, 0, PI)))+0)*cellStartSize;
  }

  void updateFertility() {
    if (maturity <= fertility) {fertile = true; } else {fertile = false; }
    if (spawnCount == 0) {fertility = 0;} // Once spawnCount has counted down to zero, the cell will spawn no more
  }

  void updateColour() {
    if (p.fill_STwist > 0) {fill_S = map(maturity, 1, 0, (255-p.fill_STwist), 255); fillColor = color(fill_H, fill_S, fill_B);} // Modulate fill saturation by radius
    if (p.fill_BTwist > 0) {fill_B = map(maturity, 0, 1, (255-p.fill_BTwist), 255); fillColor = color(fill_H, fill_S, fill_B);} // Modulate fill brightness by radius
    if (p.fill_ATwist > 0) {fillAlpha = map(maturity, 0, 1, (255-p.fill_ATwist), 255);} // Modulate fill Alpha by radius
    if (p.fill_HTwist > 0) { // Modulate fill hue by radius. Does not change original hue value but replaces it with a 'twisted' version
      float fill_Htwisted = map(maturity, 1, 0, fill_H, fill_H+p.fill_HTwist);
      if (fill_Htwisted > 360) {fill_Htwisted -= 360;}
      fillColor = color(fill_Htwisted, fill_S, fill_B); //fill colour is updated with new hue value
    }
    if (p.stroke_STwist > 0) {stroke_S = map(maturity, 1, 0, (255-p.stroke_STwist), 255); strokeColor = color(stroke_H, stroke_S, stroke_B);} // Modulate stroke saturation by radius
    if (p.stroke_BTwist > 0) {stroke_B = map(maturity, 0, 1, (255-p.stroke_BTwist), 255); strokeColor = color(stroke_H, stroke_S, stroke_B);} // Modulate stroke brightness by radius
    if (p.stroke_ATwist > 0) {strokeAlpha = map(maturity, 0, 1, (255-p.stroke_ATwist), 255);} // Modulate stroke Alpha by radius
    if (p.stroke_HTwist > 0) { // Modulate stroke hue by radius
      float stroke_Htwisted = map(maturity, 1, 0, stroke_H, stroke_H+p.stroke_HTwist);
      if (stroke_Htwisted > 360) {stroke_Htwisted -= 360;}
      strokeColor = color(stroke_Htwisted, stroke_S, stroke_B); //stroke colour is updated with new hue value
    }
  }

  void checkBoundaryWraparound() {
    if (position.x > width + r * flatness) {
      position.x = -r * flatness;
    }
    else if (position.x < -r * flatness) {
      position.x = width + r * flatness;
    }
    else if (position.y > height + r * flatness) {
      position.y = -r * flatness;
    }
    else if (position.y < -r * flatness) {
      position.y = height + r * flatness;
    }
  }

  // Death
  boolean dead() {
    if (age >= lifespan) {return true;} // Death by old age (regardless of size, which may remain constant)
    if (position.x > width + r * flatness || position.x < -r * flatness || position.y > height + r * flatness || position.y < -r * flatness) {return true;} // Death if move beyond canvas boundary
    if (position.x > width+r ||  position.x < -r || position.y > height+r ||  position.y < -r) { return true;  } // Death if move beyond canvas boundary
    else { return false; }
    //return false; // Use if no death
  }

  void display() {
    if (p.strokeDisable) {noStroke();} else {stroke(hue(strokeColor), saturation(strokeColor), brightness(strokeColor), strokeAlpha);}
    if (p.fillDisable) {noFill();} else {fill(hue(fillColor), saturation(fillColor), brightness(fillColor), fillAlpha);}

    float angle = velocity.heading();
    pushMatrix();
    translate(position.x,position.y);
    rotate(angle);
    if (!p.stepped) {
      ellipse(0, 0, r, r * flatness);
      if (p.nucleus && drawStepN < 1) {
        if (fertile) {fill(0); ellipse(0, 0, cellEndSize, cellEndSize * flatness);}
        else {fill(255); ellipse(0, 0, cellEndSize, cellEndSize * flatness);}
      }
    }
    else if (drawStep < 1) { // stepped=true, step-counter is active for cell, draw only when counter=0
      ellipse(0, 0, r, r*flatness);
      if (p.nucleus && drawStepN < 1) { // Nucleus is always drawn when cell is drawn (no step-counter for nucleus)
        if (fertile) {
          fill(0); ellipse(0, 0, cellEndSize, cellEndSize * flatness);
        }
        else {
          fill(255); ellipse(0, 0, cellEndSize, cellEndSize * flatness);
        }
      }
    }
    popMatrix();
  }

  void checkCollision(Cell other) {       // Method receives a Cell object 'other' to get the required info about the collidee
      PVector distVect = PVector.sub(other.position, position); // Static vector to get distance between the cell & other
      float distMag = distVect.mag();       // calculate magnitude of the vector separating the balls
      if (distMag < (r + other.r)) { conception(other, distVect);} // Spawn a new cell
  }

  void conception(Cell other, PVector distVect) {
    // Decrease spawn counters.
    spawnCount --;
    other.spawnCount --;

    // Calculate position for spawn based on PVector between cell & other (leaving 'distVect' unchanged, as it is needed later)
    PVector spawnPos = distVect.copy();  // Create spawnPos as a copy of the (already available) distVect which points from parent cell to other
    spawnPos.normalize();
    spawnPos.mult(r);               // The spawn position is located at parent cell's radius
    spawnPos.add(position);

    // Calculate velocity vector for spawn as being centered between parent cell & other
    PVector spawnVel = velocity.copy(); // Create spawnVel as a copy of parent cell's velocity vector
    spawnVel.add(other.velocity);       // Add dad's velocity
    spawnVel.normalize();               // Normalize to leave just the direction and magnitude of 1 (will be multiplied later)

    // Combine the DNA of the parent cells
    DNA childDNA = dna.combine(other.dna);

    // Calculate new fill colour for child (a 50/50 blend of each parent cells)
    color childFillColor = lerpColor(fillColor, other.fillColor, 0.5);

    // Calculate new stroke colour for child (a 50/50 blend of each parent cells)
    color childStrokeColor = lerpColor(strokeColor, other.strokeColor, 0.5);

    // Genes for color require special treatment as I want childColor to be a 50/50 blend of parents colors
    // I will therefore overwrite color genes with reverse-engineered values after lerping:
    childDNA.genes[0] = map(hue(childFillColor), 0, 360, 0, 1); // Get the  lerped hue value and map it back to gene-range
    childDNA.genes[1] = map(saturation(childFillColor), 0, 255, 0, 1); // Get the  lerped hue value and map it back to gene-range
    childDNA.genes[2] = map(brightness(childFillColor), 0, 255, 0, 1); // Get the  lerped hue value and map it back to gene-range
    childDNA.genes[4] = map(hue(childStrokeColor), 0, 360, 0, 1); // Get the  lerped hue value and map it back to gene-range
    childDNA.genes[5] = map(saturation(childStrokeColor), 0, 255, 0, 1); // Get the  lerped hue value and map it back to gene-range
    childDNA.genes[6] = map(brightness(childStrokeColor), 0, 255, 0, 1); // Get the  lerped hue value and map it back to gene-range

    //childDNA.mutate(0.01); // Child DNA can mutate. HACKED! Mutation is temporarily disabled!

    // Call spawn method (in Colony) with the new parameters for position, velocity, colour & starting radius)
    // Note: Currently no combining of parent DNA
    colony.spawn(spawnPos, spawnVel, childDNA);


    //Reduce fertility for parent cells by squaring them
    fertility *= fertility;
    fertile = false;
    other.fertility *= other.fertility;
    other.fertile = false;
  }

  void cellDebugger() { // For debug only
     int rowHeight = 15;
     fill(360, 255);
     textSize(rowHeight);
     text("r:" + r, position.x, position.y + rowHeight * 0);
     text("cellStartSize:" + cellStartSize, position.x, position.y + rowHeight * 1);
     //text("fill_HR:" + fill_HR, position.x, position.y);
     //text("rMax:" + rMax, position.x, position.y);
     //text("growth:" + growth, position.x, position.y);
     //text("age:" + age, position.x, position.y+20);
     //text("fertile:" + fertile, position.x, position.y rowHeight * 2);
     //text("fertility:" + fertility, position.x, position.y rowHeight * 3);
     //text("spawnCount:" + collCount, position.x, position.y rowHeight * 4);
     //text("x-velocity:" + velocity.x, position.x, position.y+0);
     //text("y-velocity:" + velocity.y, position.x, position.y+10);
     //text("velocity heading:" + velocity.heading(), position.x, position.y+20);
     }



}