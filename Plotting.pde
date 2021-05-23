


PVector rotate_phasor(PVector phasor, float rotation) {
  return phasor.copy().rotate(rotation);
}


//def create_colormap(wavelength):
//  //global enhance
//  rgb = wavelength_to_rgb(wavelength)
//  newcolors = []
//  for i in range(256):
//    intensity = i/256
//    if enhance:
//      intensity = 1 - math.pow(1-i/256, 4)
//    newcolors.append(np.array(rgb)*intensity)
//  return colors.ListedColormap(newcolors)


void draw_screen() {
  translate(width / 2, height / 2);
  scale(width / screen_width * 1, -height / screen_width * 1);
  PVector[] points = create_points();
  //println(points);


  int resolution = 100;
  if (hi_res)
    resolution = 200;
  
  ////loadPixels();
  
  noStroke();

  for (int i = 0; i < resolution; i++) {
    float z = map(i, 0.0, resolution - 1, -screen_width/2, screen_width/2 - (screen_width / (resolution - 1)));
    for (int j = 0; j < resolution; j++) {
      float x = map(j, 0.0, resolution - 1, -screen_width/2, screen_width/2 - (screen_width / (resolution - 1)));
      //println(x, z, points[resolution * i + j]);
      color c = color(points[resolution * i + j].mag() * 255);
      fill(c);
      rect(x, z, screen_width / resolution * 1.01, screen_width / resolution * 1.01);
      
      //pixels[width * i + j] = c;
      println(z);
      
      //println(c);
    }
  }
  //background(255);
  //fill(255);
  //noStroke();
  //rect(0, 0, .000001, .000001);
  //rect(0 / 2 * .95, 0 / 2 * .95, screen_width / resolution, screen_width / resolution);
  
  println(screen_width / resolution);
  
  //updatePixels();
}

//if no_screen:
//  fig, ax2 = plt.subplots(1, 1, figsize=(8,4))
//  ax2.set_ylabel("Amplitude along center of screen")
//  ax2.set_ylim(0.0, 1.0)
//  ax2.grid(True)
//  ax2.set_xlabel("x-position (m)")
//  ax2.set_xlim(-screen_width/2, screen_width/2)
//  plot1D = ax2.plot(x_range, phasor_mag)[0]
//else:
//  fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(8,4))
//  cmap = create_colormap(wavelength)
//  fig.tight_layout()
//  ax1.axis('square')
//  ax1.set_ylabel("z-position (m)")
//  ax1.set_ylim(-screen_width/2, screen_width/2)
//  ax2.set_ylabel("Amplitude along center of screen")
//  ax2.set_ylim(0.0, 1.0)
//  ax1.set_xlabel("x-position (m)")
//  ax1.set_xlim(-screen_width/2, screen_width/2)
//  ax2.grid(True)
//  ax2.set_xlabel("x-position (m)")
//  ax2.set_xlim(-screen_width/2, screen_width/2)
//  #phasor_mag = np.multiply(phasor_mag, phasor_mag>(4.604/np.sqrt(2*num_points)))
//  plot2D = ax1.pcolor(x_points, z_points, phasor_mag, cmap=cmap, vmin=0, vmax=1)
//  plot1D = ax2.plot(x_range, phasor_mag[int(resolution/2)])[0]
