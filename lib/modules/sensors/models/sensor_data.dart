/// Representa uma leitura de um sensor com três eixos: `x`, `y` e `z`.
///
/// Essa estrutura é utilizada para armazenar dados de sensores que
/// fornecem informações em três dimensões, como **acelerômetro**,
/// **giroscópio** ou **magnetômetro**.
class SensorData {
  /// Valor medido no eixo **X**.
  final double x;

  /// Valor medido no eixo **Y**.
  final double y;

  /// Valor medido no eixo **Z**.
  final double z;

  /// Cria uma instância de [SensorData] com valores obrigatórios
  /// para os eixos `x`, `y` e `z`.
  const SensorData({required this.x, required this.y, required this.z});

  /// Constrói uma instância de [SensorData] a partir de uma lista de valores.
  ///
  /// A lista [values] deve conter exatamente **três elementos**,
  /// representando respectivamente os eixos `x`, `y` e `z`.
  ///
  /// Exemplo:
  /// ```dart
  /// final sensor = SensorData.fromList([0.5, -1.2, 9.8]);
  /// print(sensor.x); // 0.5
  /// print(sensor.y); // -1.2
  /// print(sensor.z); // 9.8
  /// ```
  factory SensorData.fromList(List<double> values) {
    return SensorData(x: values[0], y: values[1], z: values[2]);
  }
}
