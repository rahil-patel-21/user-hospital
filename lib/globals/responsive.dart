//MediaQuery Height
double screenHeight;

//getSize
double size(double size) {
  double h = screenHeight;
  try {
    return (size * h) / 500;
  } catch (error) {
    return size;
  }
}
