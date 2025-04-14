import 'package:flutter/material.dart';

class SensorTile extends StatelessWidget {
  final String title;
  final double? x;
  final double? y;
  final double? z;

  const SensorTile({super.key, required this.title, this.x, this.y, this.z});

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
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (x != null && y != null && z != null) ...[
              Text('X: ${x!.toStringAsFixed(2)}'),
              Text('Y: ${y!.toStringAsFixed(2)}'),
              Text('Z: ${z!.toStringAsFixed(2)}'),
            ] else if (x != null) ...[
              Text('Valor: ${x!.toStringAsFixed(2)}'),
            ] else ...[
              const Text('Sem dados'),
            ],
          ],
        ),
      ),
    );
  }
}
