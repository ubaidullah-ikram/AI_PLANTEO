import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:plantify/view/diagnose_view/widgets/diagnose_info_screen.dart';
import 'package:plantify/view/diagnose_view/widgets/overlay_animation.dart';

import 'package:plantify/view_model/camera_controller/custom_camera_controller.dart';
import 'package:plantify/view_model/identify_plant_controller/identify_plant_controller.dart';
import 'package:plantify/view_model/mushroom_controller/mushroom_controller.dart';
import 'package:svg_flutter/svg.dart';

class DiagnosePlantScreen extends StatefulWidget {
  bool isfromHome;
  bool isfromIdentify;
  bool? isfromPlantIdentifyResult;
  bool? isfromMushroom;

  DiagnosePlantScreen({
    Key? key,
    required this.isfromHome,
    required this.isfromIdentify,
    this.isfromPlantIdentifyResult,
    this.isfromMushroom,
  }) : super(key: key);

  @override
  State<DiagnosePlantScreen> createState() => _DiagnosePlantScreenState();
}

class _DiagnosePlantScreenState extends State<DiagnosePlantScreen>
    with TickerProviderStateMixin {
  final cameraCtrl = Get.find<CustomCamerController>();
  PlantIdentifierController _identifierController = Get.put(
    PlantIdentifierController(),
    permanent: true,
  );
  MushroomIdentificationController _mushroomController = Get.put(
    MushroomIdentificationController(),
    permanent: true,
  );
  bool showScanning = false;
  late AnimationController _step1Controller;
  late AnimationController _step2Controller;
  late AnimationController _step3Controller;
  @override
  void initState() {
    super.initState();
    _checkPermissionAndInit();
    directDiagnoseFromPlantResult();
    if (widget.isfromIdentify) {
      if (widget.isfromMushroom != null) {
        log('its from mushroom');
        isTabSelected = 2;
      } else {
        log('its from identify plant');
        isTabSelected = 1;
      }
    } else {
      log('its from diagnose');
    }

    // Initialize animation controllers
    _step1Controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _step2Controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _step3Controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  Future<void> _checkPermissionAndInit() async {
    try {
      await cameraCtrl.initializeCamera();

      if (!widget.isfromHome) {
        log('Starting scanning from non-home route');
        _startScanning();
      }
    } catch (e) {
      log('Error initializing camera: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Camera error: $e')));
      }
    }
  }

  void _startScanning() {
    if (!widget.isfromHome) {
      if (mounted) {
        setState(() => showScanning = true);
        cameraCtrl.isScanning.value = true;

        _step1Controller.forward();

        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) _step2Controller.forward();
        });

        Future.delayed(const Duration(milliseconds: 1600), () {
          if (mounted) _step3Controller.forward();
        });

        Future.delayed(const Duration(milliseconds: 2000), () {
          if (mounted) {
            _step3Controller.repeat(reverse: true);
          }
        });

        // Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          // Get.off(() => DiagnoseResultScreen());
        }
        // });
      }
    } else {
      if (isTabSelected == 0) {
        log('its request for diagnose info options');
        Get.off(() => DiagnoseInfoScreen());
      } else if (isTabSelected == 2) {
        log('its request for identify mushroom');
        _mushroomController.identifyMushroom(
          imagePath: cameraCtrl.selectedCaptureImagePath.value,
        );
        _animationfn();
      } else {
        log('its request for identify plant');
        _identifierController.identifyPlant(
          imagePath: cameraCtrl.selectedCaptureImagePath.value,
        );
        _animationfn();
      }
    }
  }

  int isTabSelected = 0;

  directDiagnoseFromPlantResult() async {
    if (widget.isfromPlantIdentifyResult != null) {
      await cameraCtrl.pauseCameraPreview();
      _startScanning();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Resume camera when popping
        // await cameraCtrl.resumeCameraPreview();

        await cameraCtrl.disposeCameraProper();
        return true;
      },
      child: Scaffold(
        body: Obx(() {
          if (!cameraCtrl.isCameraInitialized.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              // Camera preview
              widget.isfromHome == false
                  ? SizedBox.expand(
                      child: Image.memory(
                        cameraCtrl.capturedImages.first,
                        fit: BoxFit.cover,
                      ),
                    )
                  : SizedBox.expand(
                      child: CameraPreview(cameraCtrl.controller!),
                    ),

              // Scanning view
              if (showScanning) buildScanningWidget(),

              // Camera view with buttons
              if (!showScanning)
                widget.isfromHome == false
                    ? SizedBox.shrink()
                    : Positioned(
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
                          child: SafeArea(
                            child: Column(
                              children: [
                                cameraCtrl.capturedImages.isNotEmpty
                                    ? isTabSelected == 1 || isTabSelected == 2
                                          ? SizedBox()
                                          : Row(
                                              children: [
                                                SizedBox(width: 30),
                                                Expanded(
                                                  child: SizedBox(
                                                    height: 50,
                                                    child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 0,
                                                            horizontal: 0,
                                                          ),
                                                      itemCount: cameraCtrl
                                                          .capturedImages
                                                          .length,
                                                      itemBuilder: (context, index) {
                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                right: 6,
                                                              ),
                                                          child: GestureDetector(
                                                            onTap: () {},
                                                            child: Container(
                                                              width: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          6,
                                                                        ),
                                                                  ),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      6,
                                                                    ),
                                                                child: Image.memory(
                                                                  height: 50,
                                                                  width: double
                                                                      .infinity,
                                                                  cameraCtrl
                                                                      .capturedImages[index],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
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
                                                  onTap: () async {
                                                    await cameraCtrl
                                                        .pauseCameraPreview();
                                                    _startScanning();
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 140,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xff359767),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        'Continue',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 30),
                                              ],
                                            )
                                    : SizedBox.shrink(),
                                isTabSelected == 2
                                    ? SizedBox()
                                    : SizedBox(height: 20),
                                isTabSelected == 2
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              isTabSelected = 1;
                                              cameraCtrl.capturedImages.clear();
                                              setState(() {});
                                            },
                                            child: Container(
                                              decoration: isTabSelected == 1
                                                  ? BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                        color: Color(
                                                          0xffE0E0E0,
                                                        ),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            50,
                                                          ),
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
                                                        color: Color(
                                                          0xffE0E0E0,
                                                        ),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            50,
                                                          ),
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
                                              borderRadius:
                                                  BorderRadius.circular(50),
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                          onTap: () async {
                                            log(
                                              'Capturing image $isTabSelected',
                                            );

                                            if (isTabSelected == 1) {
                                              await cameraCtrl
                                                  .captureImage(); // pehle capture
                                              await cameraCtrl
                                                  .pauseCameraPreview();

                                              // ⏳ small delay taake image list me insert ho jaye
                                              await Future.delayed(
                                                const Duration(
                                                  milliseconds: 300,
                                                ),
                                              );

                                              _startScanning(); // ab safely call hoga
                                            } else if (isTabSelected == 2) {
                                              await cameraCtrl
                                                  .captureImage(); // pehle capture
                                              await cameraCtrl
                                                  .pauseCameraPreview();

                                              // ⏳ small delay taake image list me insert ho jaye
                                              await Future.delayed(
                                                const Duration(
                                                  milliseconds: 300,
                                                ),
                                              );

                                              _startScanning(); // ab safely call hoga
                                            } else {
                                              await cameraCtrl
                                                  .captureImage(); // pehle capture
                                            }
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
                      ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildScanningWidget() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Stack(
        children: [
          Positioned(
            left: Get.width * 0.18,
            top: Get.height * 0.2,
            right: Get.width * 0.18,
            child: Container(
              height: SizeConfig.h(300),
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.h(54),
                horizontal: SizeConfig.w(30),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(AppImages.bg_frame)),
                color: Colors.transparent,
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: Get.width * 0.8,
                    height: SizeConfig.h(236),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.transparent,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amberAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // child: CameraPreview(cameraCtrl.controller!),
                            child: Image.memory(
                              cameraCtrl.capturedImages.first,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: Get.width * 0.15,
            top: Get.height * 0.36,
            right: Get.width * 0.15,
            child: ScanningAnimation(),
          ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAnimatedScanningStep(
                      'Analyzing Image',
                      _step1Controller,
                    ),
                    _buildAnimatedScanningStep(
                      'Detecting leaves',
                      _step2Controller,
                    ),
                    _buildAnimatedScanningStep(
                      'Identify Plant',
                      _step3Controller,
                      isPulsing: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedScanningStep(
    String text,
    AnimationController controller, {
    bool isPulsing = false,
  }) {
    return FadeTransition(
      opacity: controller,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _step1Controller.dispose();
    _step2Controller.dispose();
    _step3Controller.dispose();
    super.dispose();
  }

  _animationfn() {
    if (mounted) {
      setState(() => showScanning = true);
      cameraCtrl.isScanning.value = true;

      _step1Controller.forward();

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _step2Controller.forward();
      });

      Future.delayed(const Duration(milliseconds: 1600), () {
        if (mounted) _step3Controller.forward();
      });

      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          _step3Controller.repeat(reverse: true);
        }
      });

      // Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        // Get.off(() => DiagnoseResultScreen());
      }
      // });
    }
  }
}
