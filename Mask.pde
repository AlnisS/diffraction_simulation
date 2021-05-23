class Mask {
  ArrayList<Hole> holes = new ArrayList<Hole>();
  ArrayList<PVector> points = new ArrayList<PVector>();
  
  void add_hole(Hole hole) {
    holes.add(hole);
  }
  
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
  
  PVector[] plot_points(int num_points) {
    float area_holes = area_holes();
    //println(num_points);
    for (Hole hole : holes) {
      if (hole.type == HoleType.SLIT)
        process_slit(hole, area_holes, num_points);
      if (hole.type == HoleType.CIRCULAR)
        process_circular(hole, area_holes, num_points);
    }
    //x = [i[0] for i in self.points]
    //z = [i[2] for i in self.points]

    //fig, ax = plt.subplots(1, 1, figsize=(4,4))
    //fig.tight_layout()
    //ax.set_ylabel("z-position (m)")
    //z_max = np.max(z)
    //ax.set_ylim(-z_max*1.1, z_max*1.1)
    //x_max = np.max(x)
    //ax.set_xlabel("x-position (m)")
    //ax.set_xlim(-x_max*1.1, x_max*1.1)
    //ax.scatter(x, z)

    //println(points.size());
    return points.toArray(new PVector[points.size()]);
  }
}
