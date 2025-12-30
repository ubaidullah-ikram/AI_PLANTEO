import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';

class DiagnoseCameraController extends GetxController {
  CameraController? controller;
  List<CameraDescription>? cameras;
  RxBool isCameraInitialized = false.obs;
  RxBool isScanning = false.obs;

  // Observable list jo properly update hoga
  final RxList<Uint8List> capturedImages = <Uint8List>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> initializeCamera() async {
    try {
      log('Starting camera initialization...');
      if (controller != null && controller!.value.isInitialized) {
        await controller!.dispose();
      }

      cameras = await availableCameras();
      log('Available cameras: ${cameras?.length}');

      if (cameras != null && cameras!.isNotEmpty) {
        controller = CameraController(
          cameras![1],
          ResolutionPreset.medium,
          enableAudio: false,
        );

        log('Initializing camera controller...');
        await controller!.initialize();

        log('Camera initialized successfully');
        isCameraInitialized.value = true;
      } else {
        log('No cameras available');
      }
    } catch (e) {
      log('Camera initialization error: $e');
      isCameraInitialized.value = false;
    }
  }

  Future<void> captureImage() async {
    try {
      if (controller != null && controller!.value.isInitialized) {
        final image = await controller!.takePicture();
        final bytes = await File(image.path).readAsBytes();

        // Add to observable list - isse UI automatically update hoga
        capturedImages.add(bytes);
        log('Image captured and added. Total images: ${capturedImages.length}');
      }
    } catch (e) {
      log('Error capturing image: $e');
    }
  }

  void resetImages() {
    capturedImages.clear();
  }

  final List<DiagonoseScreen> screens = [
    DiagonoseScreen(
      title: 'how often do you water this plant ?',
      options: [
        'Daily',
        'Every 2-3 days',
        'once a week',
        'every 2 weeks',
        'once a month or less',
      ],
    ),
    DiagonoseScreen(
      title: 'where is it placed?',
      options: [
        'Indoors, close to a bright window',
        'Indoors, in a shaded area',
        'outdoors, in a planter or pot',
        'outdoors, planted in the soil',
        'outdoors, under partial shade',
      ],
    ),
    DiagonoseScreen(title: '', options: [
 
      ],
    ),
    DiagonoseScreen(title: '', options: [
      
      ],
    ),
  ];
}

class DiagonoseScreen {
  final String title;
  final String subtitle;
  final List<String> options;

  DiagonoseScreen({
    required this.title,
    this.subtitle = '',
    required this.options,
  });
}
