import java.util.Arrays;

//###################################################################
//### Section 1
//# Many slits
void many_slits() {
  // Shift slits to the left so that they are centered
  float left_slit_x = -(N - 1.0) / 2 * d;
  // Adds slits to mask
  for (int slit = 0; slit < N; slit++) {
    float slit_x = left_slit_x + slit * d;
    //#a_new = np.random.uniform(a/2, a)
    Hole hole = new Hole(HoleType.SLIT, new PVector(slit_x, 0, 0), a, sh, 0);
    mask.add_hole(hole);
  }

  //# 225 cicular holes in random x and z locations in mask
  //# for i in range(225):
  //#   this_x = np.random.uniform(-1.25E-3, 1.25E-3)
  //#   this_z = np.random.uniform(-1.25E-3, 1.25E-3)
  //#   hole = {'type':'circular', 'r':[this_x, 0, this_z], 'radius':0.03E-3}
  //#   mask.add_hole(hole)

  // Sets up point sources based on mask shape
  // Plotting/visualization of points not yet implemented
  r_sources = mask.plot_points(num_points);
}


//###################################################################
//### Section 2
// Double precision calculation because differences are small, but distances are large
double calc_distance(PVector r1, PVector r2) {
  return Math.sqrt(
    Math.pow((double) r1.x - (double) r2.x, 2) + 
    Math.pow((double) r1.y - (double) r2.y, 2) + 
    Math.pow((double) r1.z - (double) r2.z, 2)
    );
}

double[] calc_distance(PVector r1, PVector[] r2s) {
  double[] distances = new double[r2s.length];
  for (int i = 0; i < r2s.length; i++)
    distances[i] = calc_distance(r1, r2s[i]);
  return distances;
}


//###################################################################
//### Section 3
// Calculates phase at source in mask.
double calc_phase_source(PVector r_source, float wavelength) {
  //// Phase at laser changes by 2pi over an x distance of 0.1 mm 
  //float phase_laser = 2 * PI * r_source.x / 0.1E-3;
  //// Phase at laser is always zero
  //float phase_laser = 0.0;

  //// Distance from laser to source point in mask
  //PVector r_laser = new PVector(r_source.x, y_laser, r_source.z);
  //double dist = calc_distance(r_laser, r_source);

  //// Phase at source point
  //double phase_source = phase_laser + 2 * PI * dist / wavelength;

  //return phase_source;

  // Other stuff is useful if laser is angled, makes out of phase points, etc.
  // However, in the simple case, this saves computation time
  return 0d;
}


//###################################################################
//### Section 4
// Calculates phasor at screen.
PVector[] calc_phasor(PVector r_source, PVector[] r_points, float wavelength) {
  // Distance from point source to points on screen
  double[] dist = calc_distance(r_source, r_points);

  // Phase at source point; will be zero for simple laser setup
  // Non-zero for angled laser, light arriving out of phase, etc.
  double phasei = calc_phase_source(r_source, wavelength);
  // Phases at points; initialzed to zero
  double[] phase = new double[r_points.length];
  Arrays.fill(phase, phasei);

  // Offset phases at points by their distance from the source
  for (int i = 0; i < r_points.length; i++) {
    phase[i] += 2 * Math.PI * dist[i] / wavelength;
  }

  // Create phasor vectors
  PVector[] result = new PVector[r_points.length];
  for (int i = 0; i < r_points.length; i++) {
    double phasor_x = Math.cos(phase[i]);
    double phasor_y = Math.sin(phase[i]);
    result[i] = new PVector((float) phasor_x, (float) phasor_y);
  }

  return result;
}

//###################################################################
//### Section 5
// Adds phasors from multiple points of light within mask
PVector[] add_phasors(PVector[] r_sources, PVector[] r_points, float wavelength) {

  PVector[][] total_phasors = new PVector[r_points.length][THREADS];
  Arrays.fill(progress, 0.0);

  int pixels_per_thread = r_sources.length / THREADS;
  for (int thread = 0; thread < THREADS; thread++) {
    g_target = total_phasors;
    g_target_i = thread;
    g_r_sources = r_sources;
    g_r_points = r_points;
    g_wavelength = wavelength;
    g_i_start = pixels_per_thread * thread;
    g_i_upto = pixels_per_thread * (thread + 1);
    if (thread == THREADS - 1)
      g_i_upto = r_sources.length;
    thread("add_phasors_section");
    // Wait for thread to start
    delay(50);
  }

  boolean ready = false;
  while (!ready) {
    delay(200);
    println("\n");
    ready = true;
    for (int i = 0; i < THREADS; i++) {
      print("Checking thread " + i + "... ");
      if (total_phasors[i][0] == null) {
        ready = false;
        println("Not ready. " + progress[i]);
      } else {
        println("Ready!");
      }
    }
  }

  println("finished threaded portion");

  // Initialize all phasors to zero
  PVector[] total_phasor = new PVector[r_points.length];
  for (int i = 0; i < total_phasor.length; i++) {
    total_phasor[i] = new PVector(0, 0);
    for (int j = 0; j < THREADS; j++) {
      total_phasor[i].add(total_phasors[j][i]);
    }
  }

  // Scale phasors down such that max possible length is 1
  // (all addition was of unit vectors)
  for (PVector phasor : total_phasor)
    phasor.div(r_sources.length);

  return total_phasor;
}

float[] progress = new float[THREADS];

PVector[][] g_target;
int g_target_i;
PVector[] g_r_sources;
PVector[] g_r_points;
float g_wavelength;
int g_i_start;
int g_i_upto;

// Thread for adding phasors over a section
void add_phasors_section() {
  PVector[][] target = g_target;
  int target_i = g_target_i;
  PVector[] r_sources = g_r_sources;
  PVector[] r_points = g_r_points;
  float wavelength = g_wavelength;
  int i_start = g_i_start;
  int i_upto = g_i_upto;

  println(target_i);
  println(target[target_i ]);

  PVector[] total_phasor = new PVector[r_points.length];
  for (int i = 0; i < total_phasor.length; i++) {
    total_phasor[i] = new PVector(0, 0);
  }
  for (int i = i_start; i < i_upto; i++) {
    PVector r_source = r_sources[i];
    // Calculate influence of this source on all screen points
    PVector[] phasor = calc_phasor(r_source, r_points, wavelength);

    // Add influences from this source to total screen values
    for (int j = 0; j < total_phasor.length; j++)
      total_phasor[j].add(phasor[j]);
    
    progress[target_i] = 1.0 * (i - i_start) / (i_upto - i_start);
    //progress(i - i_start, i_upto - i_start);
  }
  target[target_i] = total_phasor;
  println("done");
}


//###################################################################
//### Section 6
//# Create points on screen to calculate phase at
PVector[] create_points() {
  if (no_screen) {
    //x_range = np.linspace(-screen_width/2, screen_width/2, 10000)
    //r_points = [x_range, screen_y, 0]
  } else {
    int resolution = 100;
    if (hi_res)
      resolution = 200;

    // Original python code, helps visualize function
    //float x_range = np.linspace(-screen_width/2, screen_width/2, resolution)
    //float z_range = np.linspace(-screen_width/2, screen_width/2, resolution)
    //x_points, z_points = np.meshgrid(x_range, z_range)
    //r_points = [x_points, screen_y, z_points]

    // Screen calculation location points
    PVector[] r_points = new PVector[resolution * resolution];

    // Note: screen is square, so width is used for both z and x dimension
    // For resolution rows/vertical positions...
    for (int i = 0; i < resolution; i++) {
      // Map row number to physical z position
      float z = map(i / (resolution - 1.0), 0.0, 1.0, -screen_width / 2, screen_width / 2);
      // For resolution x positions (dots) within row...
      for (int j = 0; j < resolution; j++) {
        // Map position (column) number to physical x position
        float x = map(j / (resolution - 1.0), 0, 1, -screen_width/2, screen_width/2);
        // Add point to screen calculation location points
        r_points[resolution * i + j] = new PVector(x, screen_y, z);
      }
    }

    println("Adding phasors");
    init_phasor_progress_bar();
    PVector[] phasor = add_phasors(r_sources, r_points, wavelength);
    return phasor;
  }

  return null;
}
