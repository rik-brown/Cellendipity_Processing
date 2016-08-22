// Borrowed from / kudos to:
// Evolution EcoSystem
// Daniel Shiffman <http://www.shiffman.net>

// Class to describe DNA
// =====================
// May be used to generate individual variation between cells, whereby key parameters may be scaled by mapping them to a specific DNA
// May also facilitate 'sexual reproduction with variation' though this requires some additional code to randomly select which genes to pick from which parent
// This could be done by simply iterating through all the genes in the array and using a random number to select 'mum' or 'dad'

class DNA {

  // The genetic sequence
  float[] genes;  // 'genes' is a standard array, initially containing float values in the range (0-1). It could also containg, for example variables for colour
  
  // Constructor (makes a random DNA)
  DNA() {
    genes = new float[14];  // DNA contains an array called 'genes' with [4] float values  
    for (int i = 0; i < genes.length; i++) {
      genes[i] = random(0,1);    // Each gene is a random float value between 0 and 1      
    } // closes for - i - loop
    
  } // closes 'DNA' method
  
  DNA(float[] newgenes) { // Not sure about this one....
                          // A method called DNA accepting the array called newgenes?
    genes = newgenes;     // The existing array 'genes' is filled by 'newgenes' ?
  }
  
  
  
  DNA copy() {            // 'copy' is a method which returns a copy of the DNA which are put in
                          // It is called by the method 'reproduce' in Cell to create 'childDNA' which are a copy of the parent
    
    float[] newgenes = new float[genes.length];
    //arraycopy(genes,newgenes);
    // JS mode not supporting arraycopy
    
    for (int i = 0; i < newgenes.length; i++) {
      newgenes[i] = genes[i];
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

  void newColourGenes(int fill_HR, int fill_SG, int fill_BB, int fill_Alpha, int stroke_HR, int stroke_SG, int stroke_BB, int stroke_Alpha) {
    // Goal is to return new DNA containing the genes for spawning a new cell whose colours (fill & stroke) are a combination of the parents
  }
  
} // End of DNA class