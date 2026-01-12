import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/view/diagnose_view/daignose_screen_camera.dart';
import 'package:plantify/view_model/camera_controller/custom_camera_controller.dart';
import 'package:plantify/view_model/identify_plant_controller/identify_plant_controller.dart';
import 'package:svg_flutter/svg_flutter.dart';

class PlantIdentifierResultScreen extends StatefulWidget {
  const PlantIdentifierResultScreen({super.key});

  @override
  State<PlantIdentifierResultScreen> createState() =>
      _PlantIdentifierResultScreenState();
}

class _PlantIdentifierResultScreenState
    extends State<PlantIdentifierResultScreen> {
  final cameraCtrl = Get.find<CustomCamerController>();
  final identifierCtrl = Get.find<PlantIdentifierController>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cameraCtrl.capturedImages.clear();
  }

  getImageToshow() {
    imageToshow = cameraCtrl.capturedImages.first;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageToshow();
  }

  Uint8List? imageToshow;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, size: 18),
        ),
        backgroundColor: Color(0xffF9F9F9),
        surfaceTintColor: Color(0xffF9F9F9),
        centerTitle: false,
        title: Text(
          'Plant Identifier',
          style: TextStyle(
            fontFamily: AppFonts.sfPro,
            fontWeight: FontWeight.w600,
            color: AppColors.themeColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.0),
        child: Obx(() {
          final identifierData = identifierCtrl.identifierData.value;

          if (identifierData == null) {
            return Center(child: Text('No identification data available'));
          }

          final isLowConfidence = identifierData.confidence < 0.75;

          return ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Plant Details',
                    style: TextStyle(
                      fontFamily: AppFonts.sfPro,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.themeColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Plant Image
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.memory(
                  imageToshow ?? cameraCtrl.capturedImages.first,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),

              // Plant Info Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffE0E0E0)),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      identifierData.plantName,
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.themeColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      identifierData.scientificName,
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.themeColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 12),
                    Divider(color: Color(0xffE0E0E0)),
                    SizedBox(height: 12),
                    Text(
                      identifierData.description,
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 13,
                        color: Color(0xff797979),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Characteristics/Tags
                    Text(
                      'Characteristics',
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: identifierData.characteristics
                          .map((tag) => _buildTag(tag))
                          .toList(),
                    ),
                    SizedBox(height: 16),

                    // Confidence Meter
                    // Row(
                    //   children: [
                    //     Text(
                    //       'Confidence: ${(identifierData.confidence * 100).toStringAsFixed(0)}%',
                    //       style: TextStyle(
                    //         fontFamily: AppFonts.sfPro,
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w600,
                    //         color: AppColors.themeColor,
                    //       ),
                    //     ),
                    //     SizedBox(width: 12),
                    //     Expanded(
                    //       child: ClipRRect(
                    //         borderRadius: BorderRadius.circular(4),
                    //         child: LinearProgressIndicator(
                    //           value: identifierData.confidence,
                    //           minHeight: 6,
                    //           backgroundColor: Colors.grey.shade300,
                    //           valueColor: AlwaysStoppedAnimation<Color>(
                    //             identifierData.confidence > 0.85
                    //                 ? Colors.green
                    //                 : identifierData.confidence > 0.7
                    //                 ? Colors.orange
                    //                 : Colors.red,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Low Confidence Warning
              // if (isLowConfidence)
              //   Container(
              //     padding: EdgeInsets.all(14),
              //     decoration: BoxDecoration(
              //       color: Colors.orange.shade50,
              //       border: Border.all(color: Colors.orange.shade300),
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     child: Row(
              //       children: [
              //         Icon(
              //           Icons.info_outline_rounded,
              //           color: Colors.orange.shade700,
              //           size: 20,
              //         ),
              //         SizedBox(width: 12),
              //         Expanded(
              //           child: Text(
              //             'Low confidence. This might not be accurate.',
              //             style: TextStyle(
              //               fontFamily: AppFonts.sfPro,
              //               fontSize: 12,
              //               color: Colors.orange.shade700,
              //               fontWeight: FontWeight.w500,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),

              // Care Points
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffE0E0E0)),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    // Care Plan Section
                    Row(
                      children: [
                        Text(
                          'Care Plan',
                          style: TextStyle(
                            fontFamily: AppFonts.sfPro,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: identifierData.carePoints
                          .map((point) => _buildCarePoint(point))
                          .toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Action Button
              GestureDetector(
                onTap: () {
                  // Get.back();
                  Get.to(
                    () => DiagnosePlantScreen(
                      isfromPlantIdentifyResult: true,
                      isfromHome: true,
                      isfromIdentify: false,
                    ),
                  );
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.themeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Diagnose This Plant',
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.themeColor.withOpacity(0.1),
        border: Border.all(color: AppColors.themeColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontFamily: AppFonts.sfPro,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.themeColor,
        ),
      ),
    );
  }

  Widget _buildCarePoint(String point) {
    // Extract icon and title from point
    final parts = point.split(':');
    final title = parts.isNotEmpty ? parts[0].trim() : 'Care Tip';
    final detail = parts.length > 1 ? parts.sublist(1).join(':').trim() : '';

    String icon = AppIcons.temperature;
    Color iconColor = Color(0xff797979);

    // Assign icons based on title
    if (title.toLowerCase().contains('temperature')) {
      icon = AppIcons.temperature;
      iconColor = Colors.red;
    } else if (title.toLowerCase().contains('sunlight') ||
        title.toLowerCase().contains('light')) {
      icon = AppIcons.sunlight_identify_result;
      iconColor = Colors.orange;
    } else if (title.toLowerCase().contains('water')) {
      icon = AppIcons.watering_identify_result;
      iconColor = Colors.blue;
    } else if (title.toLowerCase().contains('repot')) {
      icon = AppIcons.reporting;
      iconColor = Colors.brown;
    } else if (title.toLowerCase().contains('pest')) {
      icon = AppIcons.pests;
      iconColor = Colors.red;
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(icon, height: 20),
              // Container(
              //   // padding: EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     color: iconColor.withOpacity(0.1),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: Icon(iconData, color: iconColor, size: 20),
              // ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppFonts.sfPro,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          if (detail.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.only(left: 25),
              child: Text(
                detail,
                style: TextStyle(
                  fontFamily: AppFonts.sfPro,
                  fontSize: 12,
                  color: Color(0xff797979),
                  // height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
