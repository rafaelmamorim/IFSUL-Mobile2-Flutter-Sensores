import 'package:flutter/services.dart';

/// Serviço responsável por acessar sensores nativos do dispositivo
/// (implementados via código nativo Android/iOS) através de
/// [EventChannel].
///
/// Este serviço fornece **streams contínuos** com os valores
/// capturados dos sensores de luz, proximidade, temperatura e pressão.
///
/// Os canais devem estar implementados na camada nativa para que
/// retornem os dados adequadamente.
class NativeSensorService {
  /// Canal para receber eventos do **sensor de luz**.
  static const _lightChannel = EventChannel('native_sensors/light');

  /// Canal para receber eventos do **sensor de proximidade**.
  static const _proximityChannel = EventChannel('native_sensors/proximity');

  /// Canal para receber eventos do **sensor de temperatura**.
  static const _temperatureChannel = EventChannel('native_sensors/temperature');

  /// Canal para receber eventos do **sensor de pressão atmosférica**.
  static const _pressureChannel = EventChannel('native_sensors/pressure');

  /// Stream de valores do **sensor de luz**.
  ///
  /// Os dados retornados representam a intensidade luminosa em **lux**.
  Stream<double> get lightStream =>
      _lightChannel.receiveBroadcastStream().map((event) => event as double);

  /// Stream de valores do **sensor de proximidade**.
  ///
  /// Os valores geralmente são em centímetros, indicando a distância
  /// de objetos próximos ao dispositivo.
  Stream<double> get proximityStream => _proximityChannel
      .receiveBroadcastStream()
      .map((event) => event as double);

  /// Stream de valores do **sensor de temperatura**.
  ///
  /// Retorna a temperatura em **graus Celsius** (°C), se o dispositivo
  /// possuir o sensor.
  Stream<double> get temperatureStream => _temperatureChannel
      .receiveBroadcastStream()
      .map((event) => event as double);

  /// Stream de valores do **sensor de pressão atmosférica**.
  ///
  /// Os valores são medidos em **hPa** (hectopascais).
  Stream<double> get pressureStream =>
      _pressureChannel.receiveBroadcastStream().map((event) => event as double);
}
