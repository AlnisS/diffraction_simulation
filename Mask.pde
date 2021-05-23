// A diffraction grating mask
class Mask {
  // Cutout holes in the mask (slits/rectangles and circles)
  ArrayList<Hole> holes = new ArrayList<Hole>();
  // Points randomly distributed throughout hole regions
  ArrayList<PVector> points = new ArrayList<PVector>();

  // Add hole to mask
  void add_hole(Hole hole) {
    holes.add(hole);
  }

  // Calculate total area of holes in mask
  float area_holes() {
    float area = 0;
    for (Hole hole : holes) {
      if (hole.type == HoleType.SLIT)
        area += hole.w * hole.h;
      if (hole.type == HoleType.CIRCULAR)
        area += PI * pow(hole.radius, 2);
    }
    return area;
  }
  
  // Add the given number of phasor points randomly distributed over a slit/rectangular hole
  void process_slit(Hole hole, float area_holes, int num_points) {
    float w = hole.w, h = hole.h;
    PVector r = hole.r;
    num_points = int(num_points * hole.w * hole.h / area_holes);

    for (int i = 0; i < num_points; i++) {
      float this_x = random(-w/2, w/2);
      float this_z = random(-h/2, h/2);
      points.add(new PVector(r.x + this_x, r.y, r.z + this_z));
    }
  }

  // Add the given number of phasor points randomly distributed over a circular hole
  void process_circular(Hole hole, float area_holes, int num_points) {
    PVector r = hole.r;
    float radius = hole.radius;
    num_points = int(num_points * PI * pow(radius, 2) / area_holes);
    for (int i = 0; i < num_points; i++) {
      float this_r = sqrt(random(0, pow(radius, 2)));
      float this_theta = random(0, TWO_PI);
      float this_x = this_r * cos(this_theta);
      float this_z = this_r * sin(this_theta);
      points.add(new PVector(r.x + this_x, r.y, r.z + this_z));
    }
  }

  // Add the given number of phasor points randomly distributed over
  // the shapes of each hole in the mask
  PVector[] plot_points(int num_points) {
    float area_holes = area_holes();
    for (Hole hole : holes) {
      if (hole.type == HoleType.SLIT) {
        println("processing rectangular");
        process_slit(hole, area_holes, num_points);
      }
      if (hole.type == HoleType.CIRCULAR) {
        println("processing circular");
        process_circular(hole, area_holes, num_points);
      }
    }
    
    // TODO: add visualization of added points
    
    return points.toArray(new PVector[points.size()]);
  }
}
