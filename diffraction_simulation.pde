// Global data **********
// Diffraction grating mask data
Mask mask = new Mask();
// Randomly distributed points throughout mask holes
PVector[] r_sources; 

void setup() {
  size(600, 600);

  // Add slits to mask according to settings in the Mask section
  many_slits();
}

void draw() {
  noLoop();
  draw_screen();
}
