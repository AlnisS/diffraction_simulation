import java.util.Arrays;
//###################################################################
//######################### Code to look at #########################
//###################################################################


//###################################################################
//### Section 1
//# Many slits
void many_slits() {
  float left_slit_x = -(N-1)/2*d;
  for (int slit = 0; slit < N; slit++) {
    float slit_x = left_slit_x + slit*d;
    //#a_new = np.random.uniform(a/2, a)
    Hole hole = new Hole(HoleType.SLIT, new PVector(slit_x, 0, 0), a, 2e-3, 0);
    mask.add_hole(hole);
  }


  //# 225 cicular holes in random x and z locations in mask
  //# for i in range(225):
  //#   this_x = np.random.uniform(-1.25E-3, 1.25E-3)
  //#   this_z = np.random.uniform(-1.25E-3, 1.25E-3)
  //#   hole = {'type':'circular', 'r':[this_x, 0, this_z], 'radius':0.03E-3}
  //#   mask.add_hole(hole)


  //# Gets random points sampled from within mask and plots them
  //r_sources = mask.plot_points(num_points)
}

//###################################################################
//### Section 2
float calc_distance(PVector r1, PVector r2) {
  float distance = PVector.sub(r1, r2).mag();
  return distance;
}

float[] calc_distance(PVector r1, PVector[] r2s) {
  float[] distances = new float[r2s.length];
  for (int i = 0; i < r2s.length; i++) {
    distances[i] = PVector.sub(r1, r2s[i]).mag();
  }
  return distances;
}



//###################################################################
//### Section 3
// Calculates phase at source in mask.
float calc_phase_source(PVector r_source, float wavelength) {
  //# Phase at laser changes by 2pi over an x distance of 0.1 mm 
  float phase_laser = 2*PI*r_source.x/0.1E-3 * 0.0;

  //# Distance from laser to source in mask
  PVector r_laser = new PVector(r_source.x, -0.1, r_source.z);
  float dist = calc_distance(r_laser, r_source);

  //# Phase at source
  float phase_source = phase_laser + 2*PI*dist/wavelength;

  return phase_source;
}


//###################################################################
//### Section 4
// Calculates phasor at screen.
PVector[] calc_phasor(PVector r_source, PVector[] r_points, float wavelength) {
  //# Distance from point source to points on screen
  float[] dist = calc_distance(r_source, r_points);

  //# Phase at screen
  //float phase = 0
  float phasei = calc_phase_source(r_source, wavelength);
  float[] phase = new float[r_points.length];
  Arrays.fill(phase, phasei);

  for (int i = 0; i < r_points.length; i++) {
    phase[i] += 2*PI*dist[i]/wavelength;
  }

  //# Phasor components
  PVector[] result = new PVector[r_points.length];
  for (int i = 0; i < r_points.length; i++) {
    float phasor_x = cos(phase[i]);
    float phasor_y = sin(phase[i]);
    result[i] = new PVector(phasor_x, phasor_y);
  }

  return result;
}


//###################################################################
//### Section 5
// Adds phasors from multiple points of light within mask
PVector[] add_phasors(PVector[] r_sources, PVector[] r_points, float wavelength) {
  //# Initalize total phasor to zero
  PVector[] total_phasor = new PVector[r_points.length];
  for (int i = 0; i < total_phasor.length; i++)
    total_phasor[i] = new PVector(0, 0);

  //# Loop over all points in the mask
  //for i, r_source in enumerate(r_sources):
  int j = 0;
  for (PVector r_source : r_sources) {
    //# Phasor x and y component at screen due to point source
    PVector[] phasor = calc_phasor(r_source, r_points, wavelength);

    for (int i = 0; i < total_phasor.length; i++)
      total_phasor[i].add(phasor[i]);

    //# Add phasor from this point to the total phasor
    //total_phasor_x += phasor.x
    //total_phasor_y += phasor.y
    
    println((++j * 1.0) / r_sources.length);
    //progbar.update(progress(i+1, len(r_sources)))
  }


  for (PVector phasor : total_phasor)
    phasor.div(r_sources.length);

  //total_phasor_x /= r_sources.length
  //total_phasor_y /= r_sources.length

  return total_phasor;
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
    //float x_range = np.linspace(-screen_width/2, screen_width/2, resolution)
    //float z_range = np.linspace(-screen_width/2, screen_width/2, resolution)
    //x_points, z_points = np.meshgrid(x_range, z_range)
    //r_points = [x_points, screen_y, z_points]

    PVector[] r_points = new PVector[resolution * resolution];

    for (int i = 0; i < resolution; i++) {
      float z = map(i / (resolution - 1.0), 0.0, 1.0, -screen_width/2, screen_width/2);
      for (int j = 0; j < resolution; j++) {
        float x = map(j / (resolution - 1.0), 0, 1, -screen_width/2, screen_width/2);
        r_points[resolution * i + j] = new PVector(x, screen_y, z);
      }
    }

    //println(r_sources);
    //println(r_points);
    println("Adding phasors");
    PVector[] phasor = add_phasors(r_sources, r_points, wavelength);
    return phasor;
  }

  return null;
  //# Calculate total phasor at points 
  //# Init progress bar
  //progbar = display(progress(0, len(r_sources)), display_id=True)

  //phasor_x, phasor_y = add_phasors(r_sources, r_points, wavelength)

  //phasor_mag = np.sqrt(phasor_x**2 + phasor_y**2)
}
