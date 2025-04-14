import 'package:sensors_plus/sensors_plus.dart';
import '../models/sensor_data.dart';
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

class SensorService {
  Stream<SensorData> get accelerometerStream => SensorsPlatform.instance.userAccelerometerEventStream().map(
        (event) => SensorData(x: event.x, y: event.y, z: event.z),
      );

  Stream<SensorData> get gyroscopeStream => SensorsPlatform.instance.gyroscopeEventStream().map(
        (event) => SensorData(x: event.x, y: event.y, z: event.z),
      );

  Stream<SensorData> get magnetometerStream => SensorsPlatform.instance.magnetometerEventStream().map(
        (event) => SensorData(x: event.x, y: event.y, z: event.z),
      );
}