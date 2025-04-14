import 'dart:async';
import 'package:flutter/material.dart';
import '../services/sensor_service.dart';
import '../models/sensor_data.dart';

class SensorViewModel extends ChangeNotifier {
  final SensorService _sensorService = SensorService();

  final StreamController<SensorData> _accelerometerController = StreamController<SensorData>.broadcast();
  final StreamController<SensorData> _gyroscopeController = StreamController<SensorData>.broadcast();
  final StreamController<SensorData> _magnetometerController = StreamController<SensorData>.broadcast();

  Stream<SensorData> get accelerometerStream => _accelerometerController.stream;
  Stream<SensorData> get gyroscopeStream => _gyroscopeController.stream;
  Stream<SensorData> get magnetometerStream => _magnetometerController.stream;

  SensorViewModel() {
    _sensorService.accelerometerStream.listen((event) {
      _accelerometerController.add(event);
    });
    _sensorService.gyroscopeStream.listen((event) {
      _gyroscopeController.add(event);
    });
    _sensorService.magnetometerStream.listen((event) {
      _magnetometerController.add(event);
    });
  }

  @override
  void dispose() {
    _accelerometerController.close();
    _gyroscopeController.close();
    _magnetometerController.close();
    super.dispose();
  }
}
