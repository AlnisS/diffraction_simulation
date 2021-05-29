// Global data **********
// Diffraction grating mask data
Mask mask = new Mask();
// Randomly distributed points throughout mask holes
PVector[] r_sources;
// Number of threads to use for simulation
int THREADS = 8;

PrintWriter out;

void settings() {
  if (no_screen)
    size(no_screen_resolution, 335);
  else
    size(600, 600);
}

void setup() {
  //size(600, 600);

  out = createWriter(String.format("local/data_%.0f_nm_sc_%d_sw_%.3f_um.csv", wavelength_nm, N, a * 1E6));
  
  for (int i = 0; i < num_points; i++) {
    float x = map(i / (num_points - 1.0), 0.0, 1.0, -screen_width / 2, screen_width / 2);
    out.print("," + x);
  }
  
  // Add slits to mask according to settings in the Mask section
  many_slits();
  background(0);
}

void draw() {
  int start = millis();
  //noLoop();
  draw_screen();
  println("time: " + (millis() - start) / 1000.0);
  stroke(255);
  fill(255);
  text(String.format("wavelength: %.0f nm    slit count: %d    slit separation: %.3f m    slit width: %.3f um    phase shift: %.3f phases", wavelength_nm, N, d, a * 1E6, phase_shift), 2, height - 2);
  saveFrame(String.format("local/frames_%.0f_sc_%d_sw_%.3f_um/frame_%.0f_nm_sc_%d_sw_%.3f_um_####.png", wavelength_nm, N, a * 1E6, wavelength_nm, N, a * 1E6));
  println(phase_shift);
  println(frameCount);
  phase_shift = (frameCount - 1) * .02;
  if (frameCount > 600) {
    out.flush();
    out.close();
    exit();
  }
}
