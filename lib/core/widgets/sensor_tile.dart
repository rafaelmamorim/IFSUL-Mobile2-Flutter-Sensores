import 'package:flutter/material.dart';

/// Um widget reutilizável que exibe informações de sensores em formato de cartão.
///
/// O [SensorTile] pode apresentar dados em diferentes formatos:
/// - Valores em três eixos (`x`, `y`, `z`) — típico para acelerômetro, giroscópio, magnetômetro.
/// - Valor único (`x`) — usado em sensores como luz, proximidade, temperatura ou pressão.
/// - Valor em formato de texto (`value`) — útil para exibir estados descritivos, como status da bateria.
/// - Caso nenhum dado seja fornecido, exibe "Sem dados".
///
/// O estilo do título é herdado do tema atual do aplicativo.
class SensorTile extends StatelessWidget {
  /// Título do sensor exibido no topo do cartão.
  final String title;

  /// Valor do eixo X ou valor único do sensor.
  final double? x;

  /// Valor do eixo Y (opcional).
  final double? y;

  /// Valor do eixo Z (opcional).
  final double? z;

  /// Valor em formato de texto alternativo (opcional).
  final String? value;

  /// Cria um [SensorTile].
  ///
  /// O [title] é obrigatório, enquanto `x`, `y`, `z` e `value` são opcionais.
  const SensorTile({
    super.key,
    required this.title,
    this.x,
    this.y,
    this.z,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Exibe o título do sensor.
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            /// Exibe valores em diferentes formatos dependendo do que foi informado.
            if (x != null && y != null && z != null) ...[
              Text('X: ${x!.toStringAsFixed(2)}'),
              Text('Y: ${y!.toStringAsFixed(2)}'),
              Text('Z: ${z!.toStringAsFixed(2)}'),
            ] else if (x != null) ...[
              Text('Valor: ${x!.toStringAsFixed(2)}'),
            ] else if (value != null) ...[
              Text('Valor: $value'),
            ] else ...[
              const Text('Sem dados'),
            ],
          ],
        ),
      ),
    );
  }
}
