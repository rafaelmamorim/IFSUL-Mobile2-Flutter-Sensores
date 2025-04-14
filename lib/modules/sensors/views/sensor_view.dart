import 'package:flutter/material.dart';
import 'package:flutter_sensores/modules/sensors/models/sensor_data.dart';
import 'package:flutter_sensores/modules/sensors/viewmodels/sensor_viewmodel.dart';
import 'package:flutter_sensores/core/widgets/sensor_tile.dart';
import 'package:provider/provider.dart';

class SensorView extends StatelessWidget {
  const SensorView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SensorViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Sensores')),
      body: ListView(
        children: [
          StreamBuilder<SensorData>(
            stream: viewModel.accelerometerStream,
            builder: (context, snapshot) {
              final data = snapshot.data ?? SensorData(x: 0, y: 0, z: 0);
              return SensorTile(
                title: 'Acelerômetro',
                x: data.x,
                y: data.y,
                z: data.z,
              );
            },
          ),
          StreamBuilder<SensorData>(
            stream: viewModel.gyroscopeStream,
            builder: (context, snapshot) {
              final data = snapshot.data ?? SensorData(x: 0, y: 0, z: 0);
              return SensorTile(
                title: 'Giroscópio',
                x: data.x,
                y: data.y,
                z: data.z,
              );
            },
          ),
          StreamBuilder<SensorData>(
            stream: viewModel.magnetometerStream,
            builder: (context, snapshot) {
              final data = snapshot.data ?? SensorData(x: 0, y: 0, z: 0);
              return SensorTile(
                title: 'Magnômetro',
                x: data.x,
                y: data.y,
                z: data.z,
              );
            },
          ),
        ],
      ),
    );
  }
}
