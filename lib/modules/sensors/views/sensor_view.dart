import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_sensores/modules/sensors/models/sensor_data.dart';
import 'package:flutter_sensores/modules/sensors/viewmodels/sensor_viewmodel.dart';
import 'package:flutter_sensores/core/widgets/sensor_tile.dart';

class SensorView extends StatelessWidget {
  const SensorView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SensorViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Sensores')),
      body: ListView(
        children: [
          // Sensores com Stream (sensors_plus)
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
                title: 'Magnetômetro',
                x: data.x,
                y: data.y,
                z: data.z,
              );
            },
          ),

          const Divider(),

          // Sensores nativos via EventChannel (agora usando Stream)
          StreamBuilder<double>(
            stream: viewModel.lightLevelStream,
            builder: (context, snapshot) {
              final lightLevel = snapshot.data ?? 0.0;
              return SensorTile(title: 'Luz (lux)', x: lightLevel);
            },
          ),
          StreamBuilder<double>(
            stream: viewModel.proximityStream,
            builder: (context, snapshot) {
              final proximity = snapshot.data ?? 0.0;
              return SensorTile(title: 'Proximidade (cm)', x: proximity);
            },
          ),
          StreamBuilder<double>(
            stream: viewModel.temperatureStream,
            builder: (context, snapshot) {
              final temperature = snapshot.data ?? 0.0;
              return SensorTile(title: 'Temperatura (°C)', x: temperature);
            },
          ),
          StreamBuilder<double>(
            stream: viewModel.pressureStream,
            builder: (context, snapshot) {
              final pressure = snapshot.data ?? 0.0;
              return SensorTile(title: 'Pressão (hPa)', x: pressure);
            },
          ),
        ],
      ),
    );
  }
}
