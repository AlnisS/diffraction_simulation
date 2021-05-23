// A single hole in a diffraction mask
class Hole {
  // Slit (rectangle) or circle
  HoleType type;
  // Dimensions (present for all types; unused depending on type)
  float w, h, radius;
  // Position of center
  PVector r;

  Hole(HoleType type, PVector r, float w, float h, float radius) {
    this.type = type;
    this.r = r;
    this.w = w;
    this.h = h;
    this.radius = radius;
  }
}
