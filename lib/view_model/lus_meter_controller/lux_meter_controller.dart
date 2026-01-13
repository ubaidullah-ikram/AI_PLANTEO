import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ambient_light/ambient_light.dart';

class LightMeterController extends GetxController {
  final lightLevel = 0.0.obs;
  final lightStatus = 'Initializing...'.obs;
  final statusColor = Colors.grey.obs;
  final isListening = false.obs;

  static const int optimalMin = 460;
  static const int optimalMax = 1184;

  @override
  void onInit() {
    super.onInit();
    startListeningToLightSensor();
  }

  void startListeningToLightSensor() {
    try {
      AmbientLight().ambientLightStream.listen(
        (double reading) {
          lightLevel.value = reading.toDouble();
          updateLightStatus(lightLevel.value);
          isListening.value = true;
        },
        onError: (error) {
          lightStatus.value = 'Sensor not available';
          statusColor.value = Colors.red;
          isListening.value = false;
          print('Light Sensor Error: $error');
        },
      );
    } catch (e) {
      lightStatus.value = 'Error: $e';
      statusColor.value = Colors.red;
      isListening.value = false;
      print('Exception: $e');
    }
  }

  void updateLightStatus(double lux) {
    if (lux < 50) {
      lightStatus.value = 'Too Dark - No light detected';
      statusColor.value = Colors.red;
    } else if (lux < optimalMin) {
      lightStatus.value = 'Low Light - Not enough for plants';
      statusColor.value = Colors.orange;
    } else if (lux >= optimalMin && lux <= optimalMax) {
      lightStatus.value = 'Perfect Light - Optimal for plants';
      statusColor.value = Colors.green;
    } else if (lux > optimalMax && lux < 2000) {
      lightStatus.value = 'Bright Light - Good for plants';
      statusColor.value = Colors.green;
    } else {
      lightStatus.value = 'Too Bright - May damage plants';
      statusColor.value = Colors.amber;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
