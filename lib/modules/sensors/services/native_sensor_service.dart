import 'package:flutter/services.dart';

class NativeSensorService {
  static const _lightChannel = EventChannel('native_sensors/light');
  static const _proximityChannel = EventChannel('native_sensors/proximity');
  static const _temperatureChannel = EventChannel('native_sensors/temperature');
  static const _pressureChannel = EventChannel('native_sensors/pressure');

  Stream<double> get lightStream =>
      _lightChannel.receiveBroadcastStream().map((event) => event as double);

  Stream<double> get proximityStream => _proximityChannel
      .receiveBroadcastStream()
      .map((event) => event as double);

  Stream<double> get temperatureStream => _temperatureChannel
      .receiveBroadcastStream()
      .map((event) => event as double);

  Stream<double> get pressureStream =>
      _pressureChannel.receiveBroadcastStream().map((event) => event as double);
}
