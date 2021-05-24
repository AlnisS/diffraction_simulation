// Global data **********
// Diffraction grating mask data
Mask mask = new Mask();
// Randomly distributed points throughout mask holes
PVector[] r_sources;
// Number of threads to use for simulation
int THREADS = 8;

void settings() {
  if (no_screen)
    size(no_screen_resolution, 128);
  else
    size(600, 600);
}

void setup() {
  //size(600, 600);

  // Add slits to mask according to settings in the Mask section
  many_slits();
}

void draw() {
  int start = millis();
  noLoop();
  draw_screen();
  println("time: " + (millis() - start) / 1000.0);
}
