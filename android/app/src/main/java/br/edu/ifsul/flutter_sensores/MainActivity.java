package br.edu.ifsul.flutter_sensores;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;

public class MainActivity extends FlutterActivity implements SensorEventListener {

    private SensorManager sensorManager;
    private Sensor lightSensor;
    private Sensor proximitySensor;
    private Sensor tempSensor;
    private Sensor pressureSensor;

    private EventChannel.EventSink lightSink;
    private EventChannel.EventSink proximitySink;
    private EventChannel.EventSink tempSink;
    private EventChannel.EventSink pressureSink;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);

        if (sensorManager != null) {
            lightSensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);
            proximitySensor = sensorManager.getDefaultSensor(Sensor.TYPE_PROXIMITY);
            tempSensor = sensorManager.getDefaultSensor(Sensor.TYPE_AMBIENT_TEMPERATURE);
            pressureSensor = sensorManager.getDefaultSensor(Sensor.TYPE_PRESSURE);
        }

        setupEventChannel(flutterEngine, "native_sensors/light", Sensor.TYPE_LIGHT);
        setupEventChannel(flutterEngine, "native_sensors/proximity", Sensor.TYPE_PROXIMITY);
        setupEventChannel(flutterEngine, "native_sensors/temperature", Sensor.TYPE_AMBIENT_TEMPERATURE);
        setupEventChannel(flutterEngine, "native_sensors/pressure", Sensor.TYPE_PRESSURE);
    }

    private void setupEventChannel(FlutterEngine engine, String channelName, int sensorType) {
        new EventChannel(engine.getDartExecutor().getBinaryMessenger(), channelName)
                .setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        switch (sensorType) {
                            case Sensor.TYPE_LIGHT:
                                lightSink = events;
                                sensorManager.registerListener(MainActivity.this, lightSensor,
                                        SensorManager.SENSOR_DELAY_NORMAL);
                                break;
                            case Sensor.TYPE_PROXIMITY:
                                proximitySink = events;
                                sensorManager.registerListener(MainActivity.this, proximitySensor,
                                        SensorManager.SENSOR_DELAY_NORMAL);
                                break;
                            case Sensor.TYPE_AMBIENT_TEMPERATURE:
                                tempSink = events;
                                sensorManager.registerListener(MainActivity.this, tempSensor,
                                        SensorManager.SENSOR_DELAY_NORMAL);
                                break;
                            case Sensor.TYPE_PRESSURE:
                                pressureSink = events;
                                sensorManager.registerListener(MainActivity.this, pressureSensor,
                                        SensorManager.SENSOR_DELAY_NORMAL);
                                break;
                        }
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        switch (sensorType) {
                            case Sensor.TYPE_LIGHT:
                                sensorManager.unregisterListener(MainActivity.this, lightSensor);
                                lightSink = null;
                                break;
                            case Sensor.TYPE_PROXIMITY:
                                sensorManager.unregisterListener(MainActivity.this, proximitySensor);
                                proximitySink = null;
                                break;
                            case Sensor.TYPE_AMBIENT_TEMPERATURE:
                                sensorManager.unregisterListener(MainActivity.this, tempSensor);
                                tempSink = null;
                                break;
                            case Sensor.TYPE_PRESSURE:
                                sensorManager.unregisterListener(MainActivity.this, pressureSensor);
                                pressureSink = null;
                                break;
                        }
                    }
                });
    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        float value = event.values[0];
        switch (event.sensor.getType()) {
            case Sensor.TYPE_LIGHT:
                if (lightSink != null)
                    lightSink.success((double) value);
                break;
            case Sensor.TYPE_PROXIMITY:
                if (proximitySink != null)
                    proximitySink.success((double) value);
                break;
            case Sensor.TYPE_AMBIENT_TEMPERATURE:
                if (tempSink != null)
                    tempSink.success((double) value);
                break;
            case Sensor.TYPE_PRESSURE:
                if (pressureSink != null)
                    pressureSink.success((double) value);
                break;
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
        // Ignorado por enquanto
    }
}
