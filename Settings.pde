// Screen ***************
// Screen width (m):
float screen_width = 0.2;
// Distance from mask (m):
float screen_y = 1.5;

// Mask *****************
// Number of slits:
int N = 3;
// Slit width (mm -> m):
float a = 0.02 * 1E-3;
// Slit height (mm -> m):
float sh = 2.0 * 1E-3;
// Slit spacing (N > 1) (center to center) (mm -> m):
float d = 0.05 * 1E-3;

//Laser *****************
// Wavelength (nm -> m):
float wavelength = 650 * 1e-9;

float y_laser = -0.1;

// Image ****************
// Enhance dim light:
boolean enhance = true;
// High resolution:
boolean hi_res = true;
// Only show intensity along z = 0 line:
boolean no_screen = false;
// Number of points per hole in mask
int num_points = hi_res ? 10000 : 1000;
