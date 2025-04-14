import 'dart:async';
import 'package:flutter/material.dart';

import '../services/sensor_service.dart';
import '../services/native_sensor_service.dart';
import '../models/sensor_data.dart';

class SensorViewModel extends ChangeNotifier {
  final SensorService _sensorService = SensorService();
  final NativeSensorService _nativeSensorService = NativeSensorService();

  final StreamController<SensorData> _accelerometerController =
      StreamController<SensorData>.broadcast();
  final StreamController<SensorData> _gyroscopeController =
      StreamController<SensorData>.broadcast();
  final StreamController<SensorData> _magnetometerController =
      StreamController<SensorData>.broadcast();

  Stream<SensorData> get accelerometerStream => _accelerometerController.stream;
  Stream<SensorData> get gyroscopeStream => _gyroscopeController.stream;
  Stream<SensorData> get magnetometerStream => _magnetometerController.stream;

  // 🔹 Variáveis dos sensores nativos como StreamController
  final StreamController<double> _lightLevelController =
      StreamController<double>.broadcast();
  final StreamController<double> _proximityController =
      StreamController<double>.broadcast();
  final StreamController<double> _temperatureController =
      StreamController<double>.broadcast();
  final StreamController<double> _pressureController =
      StreamController<double>.broadcast();

  Stream<double> get lightLevelStream => _lightLevelController.stream;
  Stream<double> get proximityStream => _proximityController.stream;
  Stream<double> get temperatureStream => _temperatureController.stream;
  Stream<double> get pressureStream => _pressureController.stream;

  SensorViewModel() {
    // Sensores do sensors_plus
    _sensorService.accelerometerStream.listen((event) {
      _accelerometerController.add(event);
    });
    _sensorService.gyroscopeStream.listen((event) {
      _gyroscopeController.add(event);
    });
    _sensorService.magnetometerStream.listen((event) {
      _magnetometerController.add(event);
    });

    // Sensores nativos via EventChannel
    _nativeSensorService.lightStream.listen((event) {
      _lightLevelController.add(event);
    });
    _nativeSensorService.proximityStream.listen((event) {
      _proximityController.add(event);
    });
    _nativeSensorService.temperatureStream.listen((event) {
      _temperatureController.add(event);
    });
    _nativeSensorService.pressureStream.listen((event) {
      _pressureController.add(event);
    });
  }

  @override
  void dispose() {
    _accelerometerController.close();
    _gyroscopeController.close();
    _magnetometerController.close();
    _lightLevelController.close();
    _proximityController.close();
    _temperatureController.close();
    _pressureController.close();
    super.dispose();
  }
}
