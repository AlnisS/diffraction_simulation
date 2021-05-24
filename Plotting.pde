// Map of intensity value 0-255 -> color value
color[] create_colormap(float wavelength) {
  PVector rgb = wavelength_to_rgb(wavelength);
  color[] newcolors = new color[256];

  for (int i = 0; i < 256; i++) {
    float intensity = i / 256.0;

    if (enhance)  // Use quartic mapping to expand dynamic range
      intensity = 1 - pow(1.0 - i / 256.0, 4);

    PVector newcolor = PVector.mult(rgb, intensity); 
    newcolors[i] = color(newcolor.x, newcolor.y, newcolor.z);
  }

  return newcolors;
}

void draw_screen() {
  translate(width / 2, height / 2);
  scale(width / screen_width, -height / screen_width);
  PVector[] points = create_points();
  if (no_screen) {
    loadPixels();
    color[] cmap = create_colormap(wavelength);
    for (int i = 0; i < points.length; i++) {
      for (int j = 0; j < height; j++) {
        float intensity = points[i].mag();
        //println(intensity);
        color c = cmap[int(intensity * 255)];
        pixels[i + j * width] = c;
      }
    }
    updatePixels();
  } else {
    int resolution = 100;
    if (hi_res)
      resolution = 200;
  
    // Don't draw sides of rectangular pixel things
    noStroke();
  
    color[] cmap = create_colormap(wavelength);
  
    // For every row...
    for (int i = 0; i < resolution; i++) {
      // Calculate physical z height
      float z = map(i, 0.0, resolution - 1, -screen_width/2, screen_width/2 - (screen_width / (resolution - 1)));
      // For every column (point within row)...
      for (int j = 0; j < resolution; j++) {
        // Calculate physical x position
        float x = map(j, 0.0, resolution - 1, -screen_width/2, screen_width/2 - (screen_width / (resolution - 1)));
  
        // Note that this intensity calculation is not physically accurate
        // Physical intensity is magnitude squared, but that requires a much wider dynamic range to show
        float intensity = points[resolution * i + j].mag();
  
        color c = cmap[int(intensity * 255)];
  
        fill(c);
        rect(x, z, screen_width / resolution * 1.01, screen_width / resolution * 1.01);
      }
    }
  }
}
