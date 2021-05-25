// Screen ***************
// Screen width (m):
float screen_width = 0.2;
// Distance from mask (m):
float screen_y = 1.5;

// Mask *****************
// Number of slits:
int N = 3;
// Slit width (mm -> m):
float a = 0.02 * 1E-5;
// Slit height (mm -> m):
float sh = 2.0 * 1E-3;
// Slit spacing (N > 1) (center to center) (mm -> m):
float d = 0.1 * 1E-3;
// Phase shift per slit
float phase_shift = 0.0;

//Laser *****************
// Wavelength (nm -> m):
float wavelength_nm = 532;
float wavelength = wavelength_nm * 1e-9;

float y_laser = -0.1;

// Image ****************
// Enhance dim light:
boolean enhance = true;
// High resolution:
boolean hi_res = false;
// Only show intensity along z = 0 line:
boolean no_screen = true;
// Resolution of single row output
int no_screen_resolution = 1800;
// Number of points per hole in mask
int num_points = hi_res ? 10000 : 1000;
