import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/models/mushroom_db_model.dart';
import 'package:plantify/models/mushroom_model.dart';
import 'package:plantify/view_model/api_controller/api_controller.dart';
import 'package:plantify/view_model/camera_controller/custom_camera_controller.dart';
import 'package:plantify/view_model/mushroom_controller/mushroom_controller.dart';
import 'package:plantify/view_model/my_garden_controller/my_garden_controller.dart';

class MushroomIdentificationResultScreen extends StatefulWidget {
  bool? isfromHistory;
  MushroomIdentificationResultScreen({super.key, this.isfromHistory});

  @override
  State<MushroomIdentificationResultScreen> createState() =>
      _MushroomIdentificationResultScreenState();
}

class _MushroomIdentificationResultScreenState
    extends State<MushroomIdentificationResultScreen> {
  final cameraCtrl = Get.find<CustomCamerController>();
  final mushroomCtrl = Get.find<MushroomIdentificationController>();

  Uint8List? imageToshow;

  @override
  void initState() {
    super.initState();
    if (cameraCtrl.capturedImages.isNotEmpty) {
      imageToshow = cameraCtrl.capturedImages.first;
    } else {
      // imageToshow = mushroomCtrl.mushroomData.value.imagePath;
    }
  }

  @override
  void dispose() {
    super.dispose();
    cameraCtrl.capturedImages.clear();
  }

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
          'Mushroom Identifier',
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
          final mushroomData = mushroomCtrl.mushroomData.value;

          // Show error or loading state
          if (mushroomData == null) {
            return Center(
              child: Text(
                'No mushroom identification data available',
                style: TextStyle(
                  fontFamily: AppFonts.sfPro,
                  fontSize: 14,
                  color: Color(0xff797979),
                ),
              ),
            );
          }

          // Check if mushroom was identified
          if (!mushroomData.isIdentified) {
            return _buildNoMushroomDetectedScreen(mushroomData);
          }

          // Get edibility color
          final edibilityColor = _getEdibilityColor(mushroomData.edibility);
          final isHighConfidence = mushroomData.confidence >= 0.75;

          return ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mushroom Details',
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

              // Mushroom Image
              Obx(
                () => ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: cameraCtrl.capturedImages.isEmpty
                      ? Image.memory(
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          widget.isfromHistory == true
                              ? base64Decode(mushroomData.imagePath)
                              : Get.find<DiagnoseApiController>().temImage,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        )
                      : Image.memory(
                          imageToshow ?? cameraCtrl.capturedImages.first,
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        ),
                ),
              ),
              SizedBox(height: 16),

              // Mushroom Info Card
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
                    // Mushroom Name
                    Text(
                      mushroomData.mushroomName,
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.themeColor,
                      ),
                    ),
                    SizedBox(height: 4),

                    // Scientific Name
                    Text(
                      mushroomData.scientificName,
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

                    // Edibility Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: edibilityColor.withOpacity(0.1),
                        border: Border.all(color: edibilityColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            mushroomData.edibility.toLowerCase() == 'poisonous'
                                ? Icons.warning_rounded
                                : Icons.check_circle_rounded,
                            color: edibilityColor,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Edibility: ${mushroomData.edibility}',
                            style: TextStyle(
                              fontFamily: AppFonts.sfPro,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: edibilityColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),

                    // Description
                    Text(
                      mushroomData.description,
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 13,
                        color: Color(0xff797979),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              widget.isfromHistory == false
                  ? SizedBox(height: 16)
                  : SizedBox.shrink(),
              widget.isfromHistory == true
                  ? SizedBox.shrink()
                  : GestureDetector(
                      onTap: () {
                        final data = mushroomCtrl.mushroomData.value!;
                        final image =
                            imageToshow ?? cameraCtrl.capturedImages.first;

                        final saved = SavedMushroomModel(
                          mushroomName: data.mushroomName,
                          scientificName: data.scientificName,
                          description: data.description,
                          edibility: data.edibility,
                          characteristics: data.characteristics,
                          habitat: data.habitat,
                          lookAlikes: data.lookAlikes,
                          confidence: data.confidence,
                          image: image,
                        );

                        Get.find<MyGardenController>().addMushroom(saved);

                        Get.snackbar(
                          'Saved',
                          'Mushroom added to My Garden 🍄',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      child: Container(
                        height: 56,
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.themeColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'Add to My Mushrooms',
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
              SizedBox(height: 10),
              // Characteristics Card
              if (mushroomData.characteristics.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffE0E0E0)),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Physical Characteristics',
                        style: TextStyle(
                          fontFamily: AppFonts.sfPro,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: mushroomData.characteristics
                            .map((char) => _buildCharacteristicItem(char))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 16),

              // Habitat Card
              if (mushroomData.habitat.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffE0E0E0)),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Typical Habitat',
                        style: TextStyle(
                          fontFamily: AppFonts.sfPro,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: mushroomData.habitat
                            .map((hab) => _buildHabitatItem(hab))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 16),

              // Look-alikes Warning Card
              if (mushroomData.lookAlikes.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    border: Border.all(color: Colors.amber.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Colors.amber.shade700,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Similar Looking Species',
                            style: TextStyle(
                              fontFamily: AppFonts.sfPro,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber.shade700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: mushroomData.lookAlikes
                            .map(
                              (lookAlike) => Padding(
                                padding: EdgeInsets.only(bottom: 6, left: 32),
                                child: Row(
                                  children: [
                                    Text(
                                      '• ',
                                      style: TextStyle(
                                        color: Colors.amber.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        lookAlike,
                                        style: TextStyle(
                                          fontFamily: AppFonts.sfPro,
                                          fontSize: 12,
                                          color: Colors.amber.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 16),

              // Confidence Warning if low
              if (!isHighConfidence)
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    border: Border.all(color: Colors.orange.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        color: Colors.orange.shade700,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Low confidence identification. Verify carefully.',
                          style: TextStyle(
                            fontFamily: AppFonts.sfPro,
                            fontSize: 12,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildNoMushroomDetectedScreen(MushroomIdentificationData data) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.memory(
              imageToshow ?? cameraCtrl.capturedImages.first,
              height: 240,
              width: 240,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 32),

          // Icon
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              color: Colors.orange.shade700,
              size: 48,
            ),
          ),
          SizedBox(height: 24),

          // Title
          Text(
            'No Mushroom Detected',
            style: TextStyle(
              fontFamily: AppFonts.sfPro,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12),

          // Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'This image does not contain a mushroom. Please try again with a clear photo of a mushroom.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.sfPro,
                fontSize: 14,
                color: Color(0xff797979),
                height: 1.6,
              ),
            ),
          ),
          SizedBox(height: 32),

          // Retry Button
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 56,
              margin: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.themeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Try Again',
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
        ],
      ),
    );
  }

  Widget _buildCharacteristicItem(String characteristic) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.themeColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              characteristic,
              style: TextStyle(
                fontFamily: AppFonts.sfPro,
                fontSize: 13,
                color: Color(0xff797979),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitatItem(String habitat) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              habitat,
              style: TextStyle(
                fontFamily: AppFonts.sfPro,
                fontSize: 13,
                color: Color(0xff797979),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getEdibilityColor(String edibility) {
    switch (edibility.toLowerCase()) {
      case 'edible':
        return Colors.green;
      case 'poisonous':
        return Colors.red;
      case 'inedible':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
