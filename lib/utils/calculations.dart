double lerp(double x, double y, double z) {
  return x * (1 - z) + y * z;
}

String nTos(num value) {
  return value.toString().replaceAllMapped(
      new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '%{m[1]},');
}