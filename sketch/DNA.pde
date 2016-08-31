// Class to describe DNA
// Borrowed from 'Evolution EcoSystem'
// by Daniel Shiffman <http://www.shiffman.net>


class DNA {

  float[] genes;  // 'genes' is an array of float values in the range (0-1)

  // Constructor (makes a random DNA)
  DNA() {
      genes = new float[12];  // DNA contains an array called 'genes' with [12] float values
      for (int i = 0; i < genes.length; i++) {
        genes[i] = random(0,1);    // Each gene is a random float value between 0 and 1
        //genes[i] = 0;    // Each gene = 0.5
      }
      // DNA gene mapping (12 genes)
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

      // genes[0] = 0.5;
      // genes[1] = 1;
      // genes[2] = 0.8;
      // genes[3] = 0;
      // genes[4] = 0;
      // genes[5] = 0;
      // genes[6] = 0;
      // genes[7] = 0;
      genes[8] = 0.9;
      // genes[9] = 0.05;
      // genes[10] = 0.2;
      // genes[11] = 0;

    }

  DNA(float[] newgenes) {
    genes = newgenes;
  }

  DNA combine(DNA otherDNA_) { // Returns a new set of DNA consisting of randomly selected genes from both parents
    float[] newgenes = new float[genes.length];
    for (int i = 0; i < newgenes.length; i++) {
      if (random(1) < 0.5) {newgenes[i] = genes[i];}
      else {newgenes[i] = otherDNA_.genes[i];} // 50/50 chance of copying gene from either 'mother' or 'other'
    }
    return new DNA(newgenes);
  }

  void geneMutate(float m) {
    // Using the received mutation probability 'm', picks new, fully random values in array spots
    // This method is called from the 'reproduce' method in Cell
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < m) { genes[i] = random(0,1); }
    }
  }
} // End of DNA class