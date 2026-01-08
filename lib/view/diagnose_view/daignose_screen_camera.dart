// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:get/get.dart';
// import 'package:plantify/constant/app_icons.dart';
// import 'package:plantify/constant/app_images.dart';
// import 'package:plantify/res/responsive_config/responsive_config.dart';
// import 'package:plantify/view/diagnose_view/widgets/diagnose_info_screen.dart';
// import 'package:plantify/view/diagnose_view/widgets/diagnose_result_screen.dart';
// import 'package:plantify/view/diagnose_view/widgets/overlay_animation.dart';
// import 'dart:io';

// import 'package:plantify/view_model/camera_controller/diagnose_camera_controller.dart';
// import 'package:svg_flutter/svg.dart';

// // Camera Screen
// class DiagnosePlantScreen extends StatefulWidget {
//   bool isfromHome;
//   DiagnosePlantScreen({Key? key, required this.isfromHome}) : super(key: key);

//   @override
//   State<DiagnosePlantScreen> createState() => _DiagnosePlantScreenState();
// }

// class _DiagnosePlantScreenState extends State<DiagnosePlantScreen>
//     with TickerProviderStateMixin {
//   final cameraCtrl = Get.find<DiagnoseCameraController>();
//   // final permissionCtrl = Get.put(PermissionController());
//   bool showScanning = false;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _checkPermissionAndInit();
//   // }
//   // Animation controllers
//   late AnimationController _step1Controller;
//   late AnimationController _step2Controller;
//   late AnimationController _step3Controller;

//   @override
//   void initState() {
//     super.initState();
//     _checkPermissionAndInit();

//     // Initialize animation controllers
//     _step1Controller = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _step2Controller = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _step3Controller = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//   }

//   Future<void> _checkPermissionAndInit() async {
//     // final hasPermission = await cameraCtrl.requestCameraPermission();
//     // if (hasPermission) {
//     try {
//       await cameraCtrl.initializeCamera();
//       if (!widget.isfromHome) {
//         log('its not from home start scanning');
//         _startScanning();
//       }
//     } catch (e) {
//       log('Error initializing camera: $e');
//     }
//     // }
//   }

//   void _startScanning() {
//     if (!widget.isfromHome) {
//       if (mounted) {
//         setState(() => showScanning = true);
//         cameraCtrl.isScanning.value = true;

//         // Animate steps one by one
//         _step1Controller.forward();

//         Future.delayed(const Duration(milliseconds: 800), () {
//           if (mounted) _step2Controller.forward();
//         });

//         Future.delayed(const Duration(milliseconds: 1600), () {
//           if (mounted) _step3Controller.forward();
//         });

//         // Start pulsing animation for last step
//         Future.delayed(const Duration(milliseconds: 2000), () {
//           if (mounted) {
//             _step3Controller.repeat(reverse: true);
//           }
//         });

//         // Navigate after 3 seconds
//         Future.delayed(const Duration(seconds: 3), () {
//           if (mounted) {
//             Get.off(() => DiagnoseResultScreen());
//           }
//         });
//       }
//     } else {
//       Get.off(() => DiagnoseInfoScreen());
//     }
//   }

//   int isTabSelected = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         if (!cameraCtrl.isCameraInitialized.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return Stack(
//           children: [
//             // Camera preview
//             SizedBox.expand(child: CameraPreview(cameraCtrl.controller!)),

//             // Dark overlay with center cutout
//             // if (showScanning) Container(color: Colors.black.withOpacity(0.1)),

//             // Scanning view
//             if (showScanning) buildScanningWidget(),

//             // Camera view with buttons
//             if (!showScanning)
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xffF9F9F9),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                     ),
//                   ),
//                   child: SafeArea(
//                     child: Column(
//                       children: [
//                         // SizedBox(height: 20),
//                         cameraCtrl.capturedImages.isNotEmpty
//                             ? Row(
//                                 children: [
//                                   SizedBox(width: 30),
//                                   Expanded(
//                                     child: SizedBox(
//                                       height: 50,
//                                       child: ListView.builder(
//                                         scrollDirection: Axis.horizontal,
//                                         padding: EdgeInsets.symmetric(
//                                           vertical: 0,
//                                           horizontal: 0,
//                                         ),
//                                         itemCount:
//                                             cameraCtrl.capturedImages.length,
//                                         itemBuilder: (context, index) {
//                                           return Padding(
//                                             padding: EdgeInsets.only(right: 6),
//                                             child: GestureDetector(
//                                               onTap: () {},
//                                               child: Container(
//                                                 width: 50,
//                                                 decoration: BoxDecoration(
//                                                   // color: Colors.amberAccent,
//                                                   borderRadius:
//                                                       BorderRadius.circular(6),
//                                                 ),
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     ClipRRect(
//                                                       borderRadius:
//                                                           BorderRadiusGeometry.circular(
//                                                             6,
//                                                           ),
//                                                       child: Image.memory(
//                                                         height: 50,
//                                                         width: double.infinity,
//                                                         cameraCtrl
//                                                             .capturedImages[index],
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 20),
//                                   GestureDetector(
//                                     onTap: () {
//                                       cameraCtrl.controller?.pausePreview();
//                                       _startScanning();
//                                     },
//                                     child: Container(
//                                       height: 40,
//                                       width: 140,
//                                       decoration: BoxDecoration(
//                                         color: Color(0xff359767),
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           'Continue',
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: 30),
//                                 ],
//                               )
//                             : SizedBox.shrink(),
//                         SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 isTabSelected = 1;
//                                 setState(() {});
//                               },
//                               child: Container(
//                                 decoration: isTabSelected == 1
//                                     ? BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(
//                                           color: Color(0xffE0E0E0),
//                                         ),
//                                         borderRadius: BorderRadius.circular(50),
//                                       )
//                                     : null,
//                                 width: 100,
//                                 height: 30,
//                                 child: Center(
//                                   child: Text(
//                                     'Identify',
//                                     style: TextStyle(
//                                       color: Color(0xff797979),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             GestureDetector(
//                               onTap: () {
//                                 isTabSelected = 0;
//                                 setState(() {});
//                               },
//                               child: Container(
//                                 decoration: isTabSelected == 0
//                                     ? BoxDecoration(
//                                         color: Colors.white,
//                                         border: Border.all(
//                                           color: Color(0xffE0E0E0),
//                                         ),
//                                         borderRadius: BorderRadius.circular(50),
//                                       )
//                                     : null,
//                                 width: 100,
//                                 height: 30,
//                                 child: Center(
//                                   child: Text(
//                                     'Diagnose',
//                                     style: TextStyle(
//                                       color: Color(0xff797979),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.transparent,

//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                               width: 100,
//                               height: 30,
//                               child: Center(
//                                 child: Text(
//                                   'Identify',
//                                   style: TextStyle(
//                                     color: Colors.transparent,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         // Capture button
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 20),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               GestureDetector(
//                                 child: Container(
//                                   width: 42,
//                                   height: 42,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Color(0xffC2DFD5),
//                                   ),
//                                   child: Center(
//                                     child: SvgPicture.asset(
//                                       AppIcons.galery,
//                                       height: 24,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 padding: EdgeInsets.all(4),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Color(0xffC2DFD5),
//                                     width: 4,
//                                   ),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     log('message');
//                                     cameraCtrl.captureImage();
//                                   },
//                                   child: Container(
//                                     width: 65,
//                                     height: 65,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Color(0xffC2DFD5),
//                                     ),
//                                     child: Center(
//                                       child: SvgPicture.asset(
//                                         AppIcons.camera_icon,
//                                         height: 35,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 child: Container(
//                                   width: 42,
//                                   height: 42,
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Color(0xffC2DFD5),
//                                   ),
//                                   child: Center(
//                                     child: SvgPicture.asset(
//                                       AppIcons.refresh,
//                                       height: 24,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         );
//       }),
//     );
//   }

//   // Updated buildScanningWidget
//   Widget buildScanningWidget() {
//     return Container(
//       color: Colors.black.withOpacity(0.7),
//       child: Stack(
//         children: [
//           // Center scanning frame]
//           // Positioned(
//           //   left: Get.width * 0.12,
//           //   top: Get.height * 0.15,
//           //   right: Get.width * 0.12,
//           //   child: ClipRRect(
//           //     borderRadius: BorderRadius.circular(20),
//           //     child: Container(
//           //       // width: Get.width * 0.7,
//           //       height: 350,
//           //       color: Colors.transparent,
//           //       child: Stack(
//           //         alignment: Alignment.center,
//           //         children: [
//           //           Image.asset(AppImages.bg_frame, fit: BoxFit.contain),
//           //           // Scanning animation overlay
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//           Positioned(
//             left: Get.width * 0.18,
//             top: Get.height * 0.2,
//             right: Get.width * 0.18,
//             child: Container(
//               height: SizeConfig.h(300),
//               padding: EdgeInsets.symmetric(
//                 vertical: SizeConfig.h(54),
//                 horizontal: SizeConfig.w(30),
//               ),
//               decoration: BoxDecoration(
//                 image: DecorationImage(image: AssetImage(AppImages.bg_frame)),
//                 color: Colors.transparent,
//               ),
//               child: Center(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Container(
//                     width: Get.width * 0.8,
//                     height: SizeConfig.h(236),

//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(24),
//                       // image: DecorationImage(image: AssetImage(AppImages.bg_frame)),
//                       color: Colors.transparent,
//                     ),

//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         // Background image preview
//                         Positioned.fill(
//                           child: Container(
//                             // width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: Colors.amberAccent,
//                               borderRadius: BorderRadius.circular(20),
//                               //   border: Border.all(
//                               //     color: Colors.greenAccent,
//                               //     width: 2,
//                               //   ),
//                             ),
//                             child: CameraPreview(cameraCtrl.controller!),
//                           ),
//                         ),

//                         // Scanning animation overlay
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           Positioned(
//             left: Get.width * 0.15,
//             top: Get.height * 0.36,
//             right: Get.width * 0.15,
//             child: ScanningAnimation(),
//           ),
//           // Scanning text
//           Positioned(
//             top: Get.height * 0.60,
//             left: 0,
//             right: 0,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Scanning',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'we are detecting problems\njust wait a seconds',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//                 const SizedBox(height: 30),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildAnimatedScanningStep(
//                       'Analyzing Image',
//                       _step1Controller,
//                     ),
//                     _buildAnimatedScanningStep(
//                       'Detecting leaves',
//                       _step2Controller,
//                     ),
//                     _buildAnimatedScanningStep(
//                       'Identify Plant',
//                       _step3Controller,
//                       isPulsing: true,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Image.asset(AppImages.bg_frame),
//         ],
//       ),
//     );
//   }

//   Widget _buildAnimatedScanningStep(
//     String text,
//     AnimationController controller, {
//     bool isPulsing = false,
//   }) {
//     return FadeTransition(
//       opacity: controller,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 6),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               text,
//               style: const TextStyle(color: Colors.white70, fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void dispose() {
//     _step1Controller.dispose();
//     _step2Controller.dispose();
//     _step3Controller.dispose();
//     cameraCtrl.controller?.dispose();
//     super.dispose();
//   }
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:plantify/view/diagnose_view/widgets/diagnose_info_screen.dart';
import 'package:plantify/view/diagnose_view/widgets/diagnose_result_screen.dart';
import 'package:plantify/view/diagnose_view/widgets/overlay_animation.dart';
import 'package:plantify/view_model/api_controller/api_controller.dart';
import 'dart:io';
import 'package:plantify/view_model/camera_controller/diagnose_camera_controller.dart';
import 'package:plantify/view_model/identify_plant_controller/identify_plant_controller.dart';
import 'package:svg_flutter/svg.dart';

class DiagnosePlantScreen extends StatefulWidget {
  bool isfromHome;
  bool isfromIdentify;
  DiagnosePlantScreen({
    Key? key,
    required this.isfromHome,
    required this.isfromIdentify,
  }) : super(key: key);

  @override
  State<DiagnosePlantScreen> createState() => _DiagnosePlantScreenState();
}

class _DiagnosePlantScreenState extends State<DiagnosePlantScreen>
    with TickerProviderStateMixin {
  final cameraCtrl = Get.find<DiagnoseCameraController>();
  PlantIdentifierController _identifierController = Get.put(
    PlantIdentifierController(),
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
    if (widget.isfromIdentify) {
      isTabSelected = 1;
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
      } else {
        log('its request for identify plant');
        _identifierController.identifyPlant(
          imagePath: cameraCtrl.selectedCaptureImagePath.value,
        );
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
  }

  int isTabSelected = 0;

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
                                    ? Row(
                                        children: [
                                          SizedBox(width: 30),
                                          Expanded(
                                            child: SizedBox(
                                              height: 50,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 0,
                                                  horizontal: 0,
                                                ),
                                                itemCount: cameraCtrl
                                                    .capturedImages
                                                    .length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                      right: 6,
                                                    ),
                                                    child: GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        width: 50,
                                                        decoration: BoxDecoration(
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
                                                            width:
                                                                double.infinity,
                                                            cameraCtrl
                                                                .capturedImages[index],
                                                            fit: BoxFit.cover,
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
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Continue',
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
                                                borderRadius:
                                                    BorderRadius.circular(50),
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
                                                borderRadius:
                                                    BorderRadius.circular(50),
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
                                          onTap: () {
                                            log('Capturing image');
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
}
