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

void draw_graph(PVector[] points) {
  float last_y = 0.0;
  stroke(255);
  for (int i = 0; i < points.length; i++) {
    float intensity = points[i].mag();
    float y = 20 + 300 * intensity;
    //println(intensity);
    if (i > 0)
      line(i-1, last_y, i, y);
    last_y = y;
  }
}

void draw_screen() {
  PVector[] points = create_points();
  if (no_screen) {
    background(0);
    loadPixels();
    color[] cmap = create_colormap(wavelength);
    out.print(phase_shift + ",");
    for (int i = 0; i < points.length; i++) {
      out.print(points[i].mag() + (i == points.length - 1 ? "" : ","));
      for (int j = 10 - 5; j < 10 + 6; j++) {
        float intensity = points[i].mag();
        //println(intensity);
        color c = cmap[int(intensity * 255)];
        pixels[i + j * width] = c;
      }
    }
    out.println();
    updatePixels();

    draw_graph(points);

    filter(BLUR, 3);

    draw_graph(points);
    
    stroke(255);
    line(0, 20, width, 20);
    line(width / 2, 0, width / 2, 330);
    stroke(127, 127);
    line(0, 320, width, 320);
    fill(255, 0, 255);
    text("0.0 intensity", width / 2 + 2, 30);
    text("1.0 intensity", width / 2 + 2, 330);
    
    stroke(127, 127);
    int labels = 11;
    for (int j = 0; j < labels; j++) {
      // Map position (column) number to physical x position
      float x = map(j / (labels - 1.0), 0, 1, -screen_width/2, screen_width/2);
      // Add point to screen calculation location points
      int screen_x = j * width / (labels - 1);
      line(screen_x, 320, screen_x, 0);
      text(String.format("%.0f mm", x * 1000), screen_x + 2, 320-2);
    }
    
  } else {
    translate(width / 2, height / 2);
    scale(width / screen_width, -height / screen_width);
    background(0);
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
