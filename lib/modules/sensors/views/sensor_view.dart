import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_sensores/modules/sensors/models/sensor_data.dart';
import 'package:flutter_sensores/modules/sensors/viewmodels/sensor_viewmodel.dart';
import 'package:flutter_sensores/core/widgets/sensor_tile.dart';

/// A [SensorView] é a camada **View** do padrão **MVVM**.
///
/// Esta tela é responsável por:
///
/// - Consumir os dados expostos pelo [SensorViewModel];
/// - Exibir valores de sensores em tempo real utilizando `StreamBuilder`;
/// - Reagir a mudanças de estado vindas do [ViewModel];
/// - Renderizar cada informação em um [SensorTile] de forma organizada.
///
/// ### Estrutura exibida:
///
/// 1. **Sensores do `sensors_plus`:**
///    - Acelerômetro
///    - Giroscópio
///    - Magnetômetro
///
/// 2. **Sensores nativos via `EventChannel`:**
///    - Luz (lux)
///    - Proximidade (cm)
///    - Temperatura (°C)
///    - Pressão (hPa)
///
/// 3. **Informações de bateria via `battery_plus`:**
///    - Nível da bateria em porcentagem
///    - Estado da bateria (Carregando, Descarregando, Cheio ou Desconhecido)
///
/// Cada grupo de sensores é separado por um [Divider] para melhor organização visual.
///
/// ### Integração com o ViewModel:
/// O [SensorViewModel] é obtido via [Provider] e fornece todos os `Stream`
/// necessários para construir a interface reativa.
class SensorView extends StatelessWidget {
  /// Construtor padrão da [SensorView].
  ///
  /// Utiliza `const` para permitir otimizações em tempo de compilação.
  const SensorView({super.key});

  @override
  Widget build(BuildContext context) {
    /// Obtém a instância do [SensorViewModel] provida pelo [Provider].
    final viewModel = Provider.of<SensorViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Sensores')),
      body: ListView(
        children: [
          /// Exibe dados do acelerômetro.
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

          /// Exibe dados do giroscópio.
          StreamBuilder<SensorData>(
            stream: viewModel.gyroscopeStream,
            builder: (context, snapshot) {
              final data = snapshot.data ?? SensorData(x: 0, y: 0, z: 0);
              return SensorTile(
                title: 'Rotação (Giroscópio)',
                x: data.x,
                y: data.y,
                z: data.z,
              );
            },
          ),

          /// Exibe dados do magnetômetro.
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

          /// Exibe dados do sensor de luz.
          StreamBuilder<double>(
            stream: viewModel.lightLevelStream,
            builder: (context, snapshot) {
              final lightLevel = snapshot.data ?? 0.0;
              return SensorTile(title: 'Luz (lux)', x: lightLevel);
            },
          ),

          /// Exibe dados do sensor de proximidade.
          StreamBuilder<double>(
            stream: viewModel.proximityStream,
            builder: (context, snapshot) {
              final proximity = snapshot.data ?? 0.0;
              return SensorTile(title: 'Proximidade (cm)', x: proximity);
            },
          ),

          /// Exibe dados do sensor de temperatura.
          StreamBuilder<double>(
            stream: viewModel.temperatureStream,
            builder: (context, snapshot) {
              final temperature = snapshot.data ?? 0.0;
              return SensorTile(title: 'Temperatura (°C)', x: temperature);
            },
          ),

          /// Exibe dados do sensor de pressão.
          StreamBuilder<double>(
            stream: viewModel.pressureStream,
            builder: (context, snapshot) {
              final pressure = snapshot.data ?? 0.0;
              return SensorTile(title: 'Pressão (hPa)', x: pressure);
            },
          ),

          const Divider(),

          /// Exibe o nível da bateria (%).
          StreamBuilder<int>(
            stream: viewModel.batteryLevelStream,
            builder: (context, snapshot) {
              final batteryLevel = snapshot.data ?? 0;
              return SensorTile(
                title: 'Nível da Bateria (%)',
                x: batteryLevel.toDouble(),
              );
            },
          ),

          /// Exibe o estado atual da bateria.
          StreamBuilder<BatteryState>(
            stream: viewModel.batteryStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data ?? BatteryState.unknown;
              String stateText;
              switch (state) {
                case BatteryState.charging:
                  stateText = 'Carregando';
                  break;
                case BatteryState.discharging:
                  stateText = 'Descarregando';
                  break;
                case BatteryState.full:
                  stateText = 'Cheio';
                  break;
                default:
                  stateText = 'Desconhecido';
              }
              return SensorTile(title: 'Estado da Bateria', value: stateText);
            },
          ),
        ],
      ),
    );
  }
}
