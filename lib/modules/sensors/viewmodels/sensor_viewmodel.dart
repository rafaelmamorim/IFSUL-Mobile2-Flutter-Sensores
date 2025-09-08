import 'dart:async';
import 'package:flutter/material.dart';

import '../services/sensor_service.dart';
import '../services/native_sensor_service.dart';
import '../models/sensor_data.dart';
import 'package:battery_plus/battery_plus.dart';

/// [SensorViewModel] é responsável por gerenciar os dados de sensores
/// do dispositivo e disponibilizá-los como *streams* para a interface.
///
/// Ele combina os dados vindos do pacote **sensors_plus**, de sensores
/// nativos expostos via **EventChannel** e também informações de bateria
/// utilizando **battery_plus**.
///
/// Essa classe segue o padrão **MVVM**, servindo como ViewModel que
/// conecta os serviços de sensores à camada de visualização.
///
/// Recursos disponibilizados:
/// - Acelerômetro, giroscópio e magnetômetro.
/// - Sensores nativos: luz, proximidade, temperatura e pressão.
/// - Nível da bateria (atualizado periodicamente).
/// - Estado da bateria (carregando, descarregando, cheio).
class SensorViewModel extends ChangeNotifier {
  /// Serviço que fornece dados de sensores via [sensors_plus].
  final SensorService _sensorService = SensorService();

  /// Serviço que fornece dados de sensores nativos via [EventChannel].
  final NativeSensorService _nativeSensorService = NativeSensorService();

  /// Controlador para eventos do acelerômetro.
  final StreamController<SensorData> _accelerometerController =
      StreamController<SensorData>.broadcast();

  /// Controlador para eventos do giroscópio.
  final StreamController<SensorData> _gyroscopeController =
      StreamController<SensorData>.broadcast();

  /// Controlador para eventos do magnetômetro.
  final StreamController<SensorData> _magnetometerController =
      StreamController<SensorData>.broadcast();

  /// Stream pública com dados do acelerômetro.
  Stream<SensorData> get accelerometerStream => _accelerometerController.stream;

  /// Stream pública com dados do giroscópio.
  Stream<SensorData> get gyroscopeStream => _gyroscopeController.stream;

  /// Stream pública com dados do magnetômetro.
  Stream<SensorData> get magnetometerStream => _magnetometerController.stream;

  // ───────────────────────────── Sensores Nativos ─────────────────────────────

  /// Controlador para eventos do sensor de luz.
  final StreamController<double> _lightLevelController =
      StreamController<double>.broadcast();

  /// Controlador para eventos do sensor de proximidade.
  final StreamController<double> _proximityController =
      StreamController<double>.broadcast();

  /// Controlador para eventos do sensor de temperatura.
  final StreamController<double> _temperatureController =
      StreamController<double>.broadcast();

  /// Controlador para eventos do sensor de pressão.
  final StreamController<double> _pressureController =
      StreamController<double>.broadcast();

  /// Stream pública com dados de luminosidade (em lux).
  Stream<double> get lightLevelStream => _lightLevelController.stream;

  /// Stream pública com dados de proximidade (em cm).
  Stream<double> get proximityStream => _proximityController.stream;

  /// Stream pública com dados de temperatura (em °C).
  Stream<double> get temperatureStream => _temperatureController.stream;

  /// Stream pública com dados de pressão (em hPa).
  Stream<double> get pressureStream => _pressureController.stream;

  // ──────────────────────────────── Bateria ─────────────────────────────────

  /// Controlador para o nível da bateria (0–100%).
  final StreamController<int> _batteryLevelController =
      StreamController<int>.broadcast();

  /// Controlador para o estado da bateria (carregando, descarregando, cheio).
  final StreamController<BatteryState> _batteryStateController =
      StreamController<BatteryState>.broadcast();

  /// Stream pública com nível da bateria atualizado periodicamente.
  Stream<int> get batteryLevelStream => _batteryLevelController.stream;

  /// Stream pública com estado atual da bateria.
  Stream<BatteryState> get batteryStateStream => _batteryStateController.stream;

  /// Construtor: inicializa a escuta dos sensores e da bateria.
  SensorViewModel() {
    // Sensores via sensors_plus
    _sensorService.accelerometerStream.listen(_accelerometerController.add);
    _sensorService.gyroscopeStream.listen(_gyroscopeController.add);
    _sensorService.magnetometerStream.listen(_magnetometerController.add);

    // Sensores nativos via EventChannel
    _nativeSensorService.lightStream.listen(_lightLevelController.add);
    _nativeSensorService.proximityStream.listen(_proximityController.add);
    _nativeSensorService.temperatureStream.listen(_temperatureController.add);
    _nativeSensorService.pressureStream.listen(_pressureController.add);

    // Inicialização da bateria
    _initBattery();
  }

  /// Inicializa a coleta de dados da bateria.
  ///
  /// - Obtém o nível inicial da bateria.
  /// - Agenda uma atualização periódica a cada 30 segundos.
  /// - Escuta mudanças de estado da bateria.
  Future<void> _initBattery() async {
    final level = await _sensorService.getBatteryLevel();
    _batteryLevelController.add(level);

    // Atualiza o nível a cada 30 segundos
    Timer.periodic(const Duration(seconds: 30), (_) async {
      final lvl = await _sensorService.getBatteryLevel();
      _batteryLevelController.add(lvl);
    });

    // Escuta mudanças de estado (carregando, cheio, descarregando)
    _sensorService.batteryStateStream.listen(_batteryStateController.add);
  }

  /// Libera os recursos, fechando todos os controladores de stream.
  @override
  void dispose() {
    _accelerometerController.close();
    _gyroscopeController.close();
    _magnetometerController.close();
    _lightLevelController.close();
    _proximityController.close();
    _temperatureController.close();
    _pressureController.close();
    _batteryLevelController.close();
    _batteryStateController.close();
    super.dispose();
  }
}
