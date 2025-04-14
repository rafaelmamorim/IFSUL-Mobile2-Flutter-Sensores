class SensorData {
  final double x;
  final double y;
  final double z;

  const SensorData({required this.x, required this.y, required this.z});

  factory SensorData.fromList(List<double> values) {
    return SensorData(x: values[0], y: values[1], z: values[2]);
  }
}
