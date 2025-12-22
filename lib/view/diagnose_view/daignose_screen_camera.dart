import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/view/diagnose_view/widgets/diagnose_info_screen.dart';
import 'dart:io';

import 'package:plantify/view_model/camera_controller/diagnose_camera_controller.dart';
import 'package:svg_flutter/svg.dart';

// Improved Scanning Animation Widget
class ScanningAnimation extends StatefulWidget {
  const ScanningAnimation({Key? key}) : super(key: key);

  @override
  State<ScanningAnimation> createState() => _ScanningAnimationState();
}

class _ScanningAnimationState extends State<ScanningAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat(
            reverse: true,
          ); // Reverse animation - opr se nechy, phir nechy se opr
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Corner brackets - Top Left
        // Positioned(
        //   top: 0,
        //   left: 0,
        //   child: Container(
        //     width: 50,
        //     height: 150,
        //     decoration: BoxDecoration(
        //       border: Border(
        //         top: BorderSide(color: Colors.white, width: 3),
        //         left: BorderSide(color: Colors.white, width: 3),
        //       ),
        //     ),
        //   ),
        // ),
        // // Corner brackets - Top Right
        // Positioned(
        //   top: 0,
        //   right: 0,
        //   child: Container(
        //     width: 50,
        //     height: 150,
        //     decoration: BoxDecoration(
        //       border: Border(
        //         top: BorderSide(color: Colors.white, width: 3),
        //         right: BorderSide(color: Colors.white, width: 3),
        //       ),
        //     ),
        //   ),
        // ),
        // // Corner brackets - Bottom Left
        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   child: Container(
        //     width: 50,
        //     height: 150,
        //     decoration: BoxDecoration(
        //       border: Border(
        //         bottom: BorderSide(color: Colors.white, width: 3),
        //         left: BorderSide(color: Colors.white, width: 3),
        //       ),
        //     ),
        //   ),
        // ),
        // // Corner brackets - Bottom Right
        // Positioned(
        //   bottom: 0,
        //   right: 0,
        //   child: Container(
        //     width: 50,
        //     height: 150,
        //     decoration: BoxDecoration(
        //       border: Border(
        //         bottom: BorderSide(color: Colors.white, width: 3),
        //         right: BorderSide(color: Colors.white, width: 3),
        //       ),
        //     ),
        //   ),
        // ),

        // Scanning line animation (top to bottom, phir bottom to top)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // 0 to 1 -> -100 to 100 (top to bottom)
            // 1 to 0 -> 100 to -100 (bottom to top) - reverse animation
            double offset = (_controller.value * 200) - 100;

            return Transform.translate(
              offset: Offset(0, offset),
              child: Container(
                width: Get.width * 0.8,
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.greenAccent.withOpacity(0),
                      Colors.greenAccent.withOpacity(0.8),
                      Colors.greenAccent.withOpacity(0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.6),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Glow effect behind scanning line
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double offset = (_controller.value * 400) - 200;

            return Transform.translate(
              offset: Offset(0, 0),
              child: Container(
                // width: 250,
                // height: 80,
                // decoration: BoxDecoration(
                //   gradient: RadialGradient(
                //     colors: [
                //       Colors.greenAccent.withOpacity(0.3),
                //       Colors.greenAccent.withOpacity(0.1),
                //       Colors.greenAccent.withOpacity(0),
                //     ],
                //   ),
                // ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Camera Screen
class DiagnosePlantScreen extends StatefulWidget {
  const DiagnosePlantScreen({Key? key}) : super(key: key);

  @override
  State<DiagnosePlantScreen> createState() => _DiagnosePlantScreenState();
}

class _DiagnosePlantScreenState extends State<DiagnosePlantScreen> {
  final cameraCtrl = Get.put(DiagnoseCameraController(), permanent: true);
  // final permissionCtrl = Get.put(PermissionController());
  bool showScanning = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndInit();
  }

  Future<void> _checkPermissionAndInit() async {
    // final hasPermission = await cameraCtrl.requestCameraPermission();
    // if (hasPermission) {
    try {
      await cameraCtrl.initializeCamera();
    } catch (e) {
      log('Error initializing camera: $e');
    }
    // }
  }

  void _startScanning() {
    if (mounted) {
      setState(() => showScanning = true);
      cameraCtrl.isScanning.value = true;
      //
    }
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => DiagnoseInfoScreen());
    });
  }

  int isTabSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (!cameraCtrl.isCameraInitialized.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // Camera preview
            SizedBox.expand(child: CameraPreview(cameraCtrl.controller!)),

            // Dark overlay with center cutout
            // if (showScanning) Container(color: Colors.black.withOpacity(0.1)),

            // Scanning view
            if (showScanning) buildScanningWidget(),

            // Camera view with buttons
            if (!showScanning)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF9F9F9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      cameraCtrl.capturedImages.isNotEmpty
                          ? Row(
                              children: [
                                SizedBox(width: 30),
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 0,
                                        horizontal: 0,
                                      ),
                                      itemCount:
                                          cameraCtrl.capturedImages.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(right: 6),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              width: 50,
                                              decoration: BoxDecoration(
                                                // color: Colors.amberAccent,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadiusGeometry.circular(
                                                          6,
                                                        ),
                                                    child: Image.memory(
                                                      height: 50,
                                                      width: double.infinity,
                                                      cameraCtrl
                                                          .capturedImages[index],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () {
                                    cameraCtrl.controller?.pausePreview();
                                    _startScanning();
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Color(0xff359767),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Contniue',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 30),
                              ],
                            )
                          : SizedBox.shrink(),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              isTabSelected = 1;
                              setState(() {});
                            },
                            child: Container(
                              decoration: isTabSelected == 1
                                  ? BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(0xffE0E0E0),
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    )
                                  : null,
                              width: 100,
                              height: 30,
                              child: Center(
                                child: Text(
                                  'Identify',
                                  style: TextStyle(
                                    color: Color(0xff797979),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              isTabSelected = 0;
                              setState(() {});
                            },
                            child: Container(
                              decoration: isTabSelected == 0
                                  ? BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(0xffE0E0E0),
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                    )
                                  : null,
                              width: 100,
                              height: 30,
                              child: Center(
                                child: Text(
                                  'Diagnose',
                                  style: TextStyle(
                                    color: Color(0xff797979),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,

                              borderRadius: BorderRadius.circular(50),
                            ),
                            width: 100,
                            height: 30,
                            child: Center(
                              child: Text(
                                'Identify',
                                style: TextStyle(
                                  color: Colors.transparent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Capture button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffC2DFD5),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppIcons.galery,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xffC2DFD5),
                                  width: 4,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  log('message');
                                  cameraCtrl.captureImage();
                                },
                                child: Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffC2DFD5),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      AppIcons.camera_icon,
                                      height: 35,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffC2DFD5),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppIcons.refresh,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  // Updated buildScanningWidget
  Widget buildScanningWidget() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Stack(
        children: [
          // Center scanning frame
          Positioned(
            left: Get.width * 0.18,
            top: Get.height * 0.2,
            right: Get.width * 0.18,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: Get.width * 0.7,
                height: 250,
                color: Colors.transparent,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background image preview
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          //   border: Border.all(
                          //     color: Colors.greenAccent,
                          //     width: 2,
                          //   ),
                        ),
                        child: CameraPreview(cameraCtrl.controller!),
                      ),
                    ),

                    // Scanning animation overlay
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: Get.width * 0.15,
            top: Get.height * 0.37,
            right: Get.width * 0.15,
            child: ScanningAnimation(),
          ),
          // Scanning text
          Positioned(
            top: Get.height * 0.60,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Scanning',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'we are detecting problems\njust wait a seconds',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    _buildScanningStep('Analyzing Image'),
                    _buildScanningStep('Detecting leaves'),
                    _buildScanningStep('Identify Plant'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningStep(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   width: 6,
          //   height: 6,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Colors.greenAccent,
          //   ),
          // ),
          // SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    cameraCtrl.controller?.dispose();
  }
}
