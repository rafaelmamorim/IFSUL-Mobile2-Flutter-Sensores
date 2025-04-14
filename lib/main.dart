import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'modules/sensors/viewmodels/sensor_viewmodel.dart';
import 'modules/sensors/views/sensor_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensores',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChangeNotifierProvider(
        create: (_) => SensorViewModel(),
        child: SensorView(),
      ),
    );
  }
}
