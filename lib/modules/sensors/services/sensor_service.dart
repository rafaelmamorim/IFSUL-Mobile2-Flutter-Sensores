import 'package:sensors_plus/sensors_plus.dart';
import '../models/sensor_data.dart';
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';
import 'package:battery_plus/battery_plus.dart';

/// Serviço responsável por fornecer acesso aos sensores disponíveis no dispositivo.
///
/// Esta classe encapsula a integração com os pacotes:
/// - [`sensors_plus`](https://pub.dev/packages/sensors_plus) para sensores
///   como **acelerômetro**, **giroscópio** e **magnetômetro**.
/// - [`battery_plus`](https://pub.dev/packages/battery_plus) para informações
///   relacionadas ao **estado da bateria**.
///
/// Os dados de sensores com múltiplos eixos são representados
/// pela classe [SensorData].
class SensorService {
  /// Instância do plugin [Battery] para acessar informações da bateria.
  final Battery battery = Battery();

  /// Retorna o nível atual da bateria em **percentual (0 a 100)**.
  ///
  /// Exemplo:
  /// ```dart
  /// final service = SensorService();
  /// final level = await service.getBatteryLevel();
  /// print('Bateria: $level%');
  /// ```
  Future<int> getBatteryLevel() async {
    return await battery.batteryLevel;
  }

  /// Stream que emite eventos sempre que o **estado da bateria**
  /// (carregando, descarregando, carregador conectado) for alterado.
  ///
  /// Pode ser usado para monitorar mudanças em tempo real.
  Stream<BatteryState> get batteryStateStream => battery.onBatteryStateChanged;

  /// Stream que emite periodicamente o **nível da bateria** em percentual.
  ///
  /// O intervalo padrão é de 30 segundos, mas pode ser personalizado.
  ///
  /// Exemplo:
  /// ```dart
  /// final service = SensorService();
  /// service.batteryLevelStream(interval: Duration(seconds: 10))
  ///   .listen((level) => print('Nível da bateria: $level%'));
  /// ```
  Stream<int> batteryLevelStream({
    Duration interval = const Duration(seconds: 30),
  }) async* {
    while (true) {
      yield await battery.batteryLevel;
      await Future.delayed(interval);
    }
  }

  /// Stream que fornece leituras do **acelerômetro** do dispositivo.
  ///
  /// Os valores [SensorData.x], [SensorData.y] e [SensorData.z] representam
  /// a aceleração nos três eixos, em **m/s²**.
  Stream<SensorData> get accelerometerStream => SensorsPlatform.instance
      .userAccelerometerEventStream()
      .map((event) => SensorData(x: event.x, y: event.y, z: event.z));

  /// Stream que fornece leituras do **giroscópio** do dispositivo.
  ///
  /// Os valores [SensorData.x], [SensorData.y] e [SensorData.z] representam
  /// a velocidade angular em radianos por segundo nos três eixos.
  Stream<SensorData> get gyroscopeStream => SensorsPlatform.instance
      .gyroscopeEventStream()
      .map((event) => SensorData(x: event.x, y: event.y, z: event.z));

  /// Stream que fornece leituras do **magnetômetro** (campo magnético).
  ///
  /// Os valores [SensorData.x], [SensorData.y] e [SensorData.z] são medidos
  /// em microteslas (µT) e indicam a intensidade do campo magnético nos três eixos.
  Stream<SensorData> get magnetometerStream => SensorsPlatform.instance
      .magnetometerEventStream()
      .map((event) => SensorData(x: event.x, y: event.y, z: event.z));
}
