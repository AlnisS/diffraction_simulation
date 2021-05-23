class Hole {
  HoleType type;
  float w, h, radius;
  PVector r;
  
  Hole(HoleType type, PVector r, float w, float h, float radius) {
    this.type = type;
    this.r = r;
    this.w = w;
    this.h = h;
    this.radius = radius;
  }
}
