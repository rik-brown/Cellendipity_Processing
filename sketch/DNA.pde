// Borrowed from / kudos to:
// Evolution EcoSystem
// Daniel Shiffman <http://www.shiffman.net>

// Class to describe DNA
// =====================
// May be used to generate individual variation between cells, whereby key parameters may be scaled by mapping them to a specific DNA
// May also facilitate 'sexual reproduction with variation' though this requires some additional code to randomly select which genes to pick from which parent
// This could be done by simply iterating through all the genes in the array and using a random number to select 'mum' or 'dad'

class DNA {

  float[] genes;  // 'genes' is an array of float values in the range (0-1)

  // Constructor (makes a random DNA)
  DNA(float[] newgenes) {
    if (newgenes) {genes = newgenes;}
    // Tests to see if the function is called with a newgenes passed in or not:
    // if it is, simply return a copy as this.genes
    // if not, populate this.genes with 'numGenes' new genes
    else {
      genes = new float[12];  // DNA contains an array called 'genes' with [4] float values
      for (int i = 0; i < genes.length; i++) {
        genes[i] = random(0,1);    // Each gene is a random float value between 0 and 1
      }
    }
  }

  DNA combine(DNA otherDNA_) { // Returns a new set of DNA consisting of randomly selected genes from both parents
    float[] newgenes = new float[genes.length];
    for (int i = 0; i < newgenes.length; i++) {
      if (random() < 0.5) {newgenes[i] = genes[i];}
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
