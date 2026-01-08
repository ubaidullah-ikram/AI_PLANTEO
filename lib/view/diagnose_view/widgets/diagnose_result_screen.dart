// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:plantify/constant/app_colors.dart';
// import 'package:plantify/constant/app_fonts.dart';
// import 'package:plantify/constant/app_icons.dart';
// import 'package:plantify/constant/app_images.dart';
// import 'package:plantify/view/plantio_expert_chat_sc/plant_chat_screen.dart';
// import 'package:plantify/view_model/api_controller/api_controller.dart';
// import 'package:plantify/view_model/camera_controller/diagnose_camera_controller.dart';
// import 'package:svg_flutter/svg_flutter.dart';

// class DiagnoseResultScreen extends StatefulWidget {
//   const DiagnoseResultScreen({super.key});

//   @override
//   State<DiagnoseResultScreen> createState() => _DiagnoseResultScreenState();
// }

// class _DiagnoseResultScreenState extends State<DiagnoseResultScreen> {
//   final cameraCtrl = Get.find<DiagnoseCameraController>();
//   final apicontroller = Get.find<ApiToolController>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffF9F9F9),
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Get.back();
//           },
//           child: Icon(Icons.arrow_back_ios, size: 18),
//         ),
//         backgroundColor: Color(0xffF9F9F9),
//         surfaceTintColor: Color(0xffF9F9F9),
//         centerTitle: false,
//         title: Text(
//           'Diagnosis',
//           style: TextStyle(
//             fontFamily: AppFonts.sfPro,
//             fontWeight: FontWeight.w600,
//             color: AppColors.themeColor,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 14.0),
//         child: ListView(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Result',
//                   style: TextStyle(
//                     fontFamily: AppFonts.sfPro,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.themeColor,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 10),
//             ClipRRect(
//               borderRadius: BorderRadius.circular(24),
//               child: Image.memory(
//                 // AppImages.diagnose_image_bg,
//                 cameraCtrl.capturedImages.first,
//                 height: 180,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             SizedBox(height: 12),

//             // Root Rot Expansion Tile
//             _buildExpansionTile(
//               title: 'Root Rot',
//               icon: null,
//               content:
//                   'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. content here\', making it look like readable English.',
//             ),
//             SizedBox(height: 10),

//             // Treatment Expansion Tile
//             _buildExpansionTile(
//               title: 'Treatment',
//               icon: AppIcons.treatment,
//               isBulletList: true,
//               bulletPoints: apicontroller.diagnosisData,
//             ),
//             SizedBox(height: 10),

//             // Common Problems Expansion Tile
//             _buildExpansionTile(
//               title: 'Common Problems',
//               icon: AppIcons.common_problem,
//               content: 'Common problems and solutions for this disease.',
//             ),
//             SizedBox(height: 10),

//             // Care Tips Expansion Tile
//             _buildExpansionTile(
//               title: 'Care Tips',
//               icon: AppIcons.care_tips,
//               content:
//                   'Important care tips to prevent and manage this condition.',
//             ),
//             SizedBox(height: 8),
//             _bottomCard(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildExpansionTile({
//     required String title,
//     String? icon,
//     String? content,
//     bool isBulletList = false,
//     List<String>? bulletPoints,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Color(0xffE0E0E0)),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: ExpansionTile(
//         tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         collapsedShape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         title: Row(
//           children: [
//             if (icon != null) ...[
//               // Icon(icon, size: 24, color: AppColors.themeColor),
//               SvgPicture.asset(icon, height: 24),
//               SizedBox(width: 12),
//             ],
//             Text(
//               title,
//               style: TextStyle(
//                 fontFamily: AppFonts.sfPro,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
//             child: isBulletList
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: bulletPoints!
//                         .map((point) => _buildBulletPoint(point))
//                         .toList(),
//                   )
//                 : Text(
//                     content ?? '',
//                     style: TextStyle(
//                       fontFamily: AppFonts.sfPro,
//                       fontSize: 13,
//                       color: Color(0xff797979),
//                       // height: 1.5,
//                       letterSpacing: 0,
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBulletPoint(String text) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(right: 12, top: 6),
//             child: Container(
//               width: 6,
//               height: 6,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade400,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontFamily: AppFonts.sfPro,
//                 fontSize: 14,
//                 color: Colors.grey.shade600,
//                 height: 1.5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _bottomCard() {
//     return GestureDetector(
//       onTap: () {
//         Get.to(() => PlanteoExpertScreen());
//       },
//       child: Container(
//         height: 155,
//         width: double.infinity,

//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(20),
//             bottomRight: Radius.circular(20),
//           ),
//           // color: Colors.green,
//           image: DecorationImage(
//             alignment: Alignment(0, -0.7),
//             image: AssetImage(AppImages.home_first_tool),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.only(left: 20.0, right: 130),
//           child: Column(
//             children: [
//               SizedBox(height: 28),
//               Row(
//                 children: [
//                   Text(
//                     'Planteo Expert',
//                     style: TextStyle(
//                       fontSize: 23,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xff216E49),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'Chat with Planteo’s expert AI and get instant solutions for all your plant and farming questions.',
//                       style: TextStyle(
//                         fontSize: 12,
//                         // fontWeight: FontWeight.w700,
//                         color: Color(0xff797979),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/view/plantio_expert_chat_sc/plant_chat_screen.dart';
import 'package:plantify/view_model/api_controller/api_controller.dart';
import 'package:plantify/view_model/camera_controller/diagnose_camera_controller.dart';
import 'package:svg_flutter/svg_flutter.dart';

class DiagnoseResultScreen extends StatefulWidget {
  const DiagnoseResultScreen({super.key});

  @override
  State<DiagnoseResultScreen> createState() => _DiagnoseResultScreenState();
}

class _DiagnoseResultScreenState extends State<DiagnoseResultScreen> {
  final cameraCtrl = Get.find<DiagnoseCameraController>();
  final apicontroller = Get.find<ApiToolController>();
  @override
  void dispose() {
    // TODO: implement dispose
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
          'Diagnosis',
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
          final diagnosisData = apicontroller.diagnosisData.value;

          if (diagnosisData == null) {
            return Center(child: Text('No diagnosis data available'));
          }

          // Check if disease is found (not Healthy)
          final hasDisease =
              diagnosisData.disease.toLowerCase() != 'healthy' &&
              diagnosisData.disease.toLowerCase() != 'healthy plant';

          // Check if confidence is low
          final isLowConfidence = diagnosisData.confidence < 0.65;

          return ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Result',
                    style: TextStyle(
                      fontFamily: AppFonts.sfPro,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.themeColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Image with disease warning tag and greyscale filter
              Stack(
                alignment: Alignment.center,
                children: [
                  // Greyscale filter if disease found
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ColorFiltered(
                      colorFilter: hasDisease
                          ? ColorFilter.matrix(_getGreyscaleMatrix())
                          : ColorFilter.matrix(_getIdentityMatrix()),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.memory(
                          cameraCtrl.capturedImages.first,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Red warning tag in center if disease found
                  if (hasDisease)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.warning_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Disease Detected',
                            style: TextStyle(
                              fontFamily: AppFonts.sfPro,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Plant is Healthy',
                            style: TextStyle(
                              fontFamily: AppFonts.sfPro,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),

              // Low Confidence Warning
              if (isLowConfidence)
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
                        Icons.info_outline_rounded,
                        color: Colors.orange.shade700,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Low confidence in diagnosis. Please verify with an expert.',
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
              SizedBox(height: 12),
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
                      diagnosisData.plantName,
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.themeColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      diagnosisData.scientificName,
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff797979),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      diagnosisData.description,
                      style: TextStyle(
                        fontFamily: AppFonts.sfPro,
                        fontSize: 13,
                        color: Color(0xff797979),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 6),
                    // Confidence meter
                    // Row(
                    //   children: [
                    //     Text(
                    //       'Confidence: ${(diagnosisData.confidence * 100).toStringAsFixed(0)}%',
                    //       style: TextStyle(
                    //         fontFamily: AppFonts.sfPro,
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.w600,
                    //         color: AppColors.themeColor,
                    //       ),
                    //     ),
                    //     SizedBox(width: 8),
                    //     Expanded(
                    //       child: ClipRRect(
                    //         borderRadius: BorderRadius.circular(4),
                    //         child: LinearProgressIndicator(
                    //           value: diagnosisData.confidence,
                    //           minHeight: 6,
                    //           backgroundColor: Colors.grey.shade300,
                    //           valueColor: AlwaysStoppedAnimation<Color>(
                    //             diagnosisData.confidence > 0.8
                    //                 ? Colors.green
                    //                 : diagnosisData.confidence > 0.6
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
              SizedBox(height: 10),

              // Disease Expansion Tile
              if (hasDisease)
                _buildExpansionTile(
                  title: diagnosisData.disease,
                  icon: null,
                  content: diagnosisData.description,
                  isDisease: true,
                ),
              SizedBox(height: 10),

              // Treatment Expansion Tile
              _buildExpansionTile(
                title: 'Treatment',
                icon: AppIcons.treatment,
                isBulletList: true,
                bulletPoints: diagnosisData.treatments,
              ),
              SizedBox(height: 10),

              // Common Problems Expansion Tile
              _buildExpansionTile(
                title: 'Common Problems',
                icon: AppIcons.common_problem,
                isBulletList: true,
                bulletPoints: diagnosisData.commonProblems,
              ),
              SizedBox(height: 10),

              // Care Tips Expansion Tile
              _buildExpansionTile(
                title: 'Care Tips',
                icon: AppIcons.care_tips,
                isBulletList: true,
                bulletPoints: diagnosisData.careTips,
              ),
              SizedBox(height: 8),
              _bottomCard(),
              SizedBox(height: 10),
            ],
          );
        }),
      ),
    );
  }

  // Greyscale matrix for ColorFilter
  List<double> _getGreyscaleMatrix() {
    return [
      0.299,
      0.587,
      0.114,
      0,
      0,
      0.299,
      0.587,
      0.114,
      0,
      0,
      0.299,
      0.587,
      0.114,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  // Identity matrix for no filter
  List<double> _getIdentityMatrix() {
    return [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
  }

  Widget _buildExpansionTile({
    required String title,
    String? icon,
    String? content,
    bool isBulletList = false,
    List<String>? bulletPoints,
    bool isDisease = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDisease ? Colors.red.shade300 : Color(0xffE0E0E0),
        ),
        borderRadius: BorderRadius.circular(16),
        color: isDisease ? Colors.red.shade50 : Colors.white,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            if (isDisease)
              Icon(Icons.warning_rounded, size: 24, color: Colors.red.shade600)
            else if (icon != null)
              SvgPicture.asset(icon, height: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: AppFonts.sfPro,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDisease ? Colors.red.shade700 : Colors.black,
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child:
                isBulletList && bulletPoints != null && bulletPoints.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: bulletPoints
                        .map((point) => _buildBulletPoint(point))
                        .toList(),
                  )
                : Text(
                    content ?? 'No information available',
                    style: TextStyle(
                      fontFamily: AppFonts.sfPro,
                      fontSize: 13,
                      color: Color(0xff797979),
                      height: 1.5,
                      letterSpacing: 0,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 12, top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: AppFonts.sfPro,
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomCard() {
    return GestureDetector(
      onTap: () {
        Get.to(() => PlanteoExpertScreen());
      },
      child: Container(
        height: 155,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          image: DecorationImage(
            alignment: Alignment(0, -0.7),
            image: AssetImage(AppImages.home_first_tool),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 130),
          child: Column(
            children: [
              SizedBox(height: 28),
              Row(
                children: [
                  Text(
                    'Planteo Expert',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff216E49),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Chat with Planteo\'s expert AI and get instant solutions for all your plant and farming questions.',
                      style: TextStyle(fontSize: 12, color: Color(0xff797979)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:plantify/constant/app_colors.dart';
// import 'package:plantify/constant/app_fonts.dart';
// import 'package:plantify/constant/app_icons.dart';
// import 'package:plantify/constant/app_images.dart';
// import 'package:plantify/view/plantio_expert_chat_sc/plant_chat_screen.dart';
// import 'package:plantify/view_model/api_controller/api_controller.dart';
// import 'package:plantify/view_model/camera_controller/diagnose_camera_controller.dart';
// import 'package:svg_flutter/svg_flutter.dart';

// class DiagnoseResultScreen extends StatefulWidget {
//   const DiagnoseResultScreen({super.key});

//   @override
//   State<DiagnoseResultScreen> createState() => _DiagnoseResultScreenState();
// }

// class _DiagnoseResultScreenState extends State<DiagnoseResultScreen> {
//   final cameraCtrl = Get.find<DiagnoseCameraController>();
//   final apicontroller = Get.find<ApiToolController>();
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     cameraCtrl.capturedImages.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffF9F9F9),
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Get.back();
//           },
//           child: Icon(Icons.arrow_back_ios, size: 18),
//         ),
//         backgroundColor: Color(0xffF9F9F9),
//         surfaceTintColor: Color(0xffF9F9F9),
//         centerTitle: false,
//         title: Text(
//           'Diagnosis',
//           style: TextStyle(
//             fontFamily: AppFonts.sfPro,
//             fontWeight: FontWeight.w600,
//             color: AppColors.themeColor,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 14.0),
//         child: Obx(() {
//           final diagnosisData = apicontroller.diagnosisData.value;

//           if (diagnosisData == null) {
//             return Center(child: Text('No diagnosis data available'));
//           }

//           // Check if disease is found (not Healthy)
//           final hasDisease =
//               diagnosisData.disease.toLowerCase() != 'healthy' &&
//               diagnosisData.disease.toLowerCase() != 'healthy plant';

//           return ListView(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Result',
//                     style: TextStyle(
//                       fontFamily: AppFonts.sfPro,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.themeColor,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),

//               // Image with disease warning tag and greyscale filter
//               Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   // Greyscale filter if disease found
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(24),
//                     ),
//                     child: ColorFiltered(
//                       colorFilter: hasDisease
//                           ? ColorFilter.matrix(_getGreyscaleMatrix())
//                           : ColorFilter.matrix(_getIdentityMatrix()),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(24),
//                         child: Image.memory(
//                           cameraCtrl.capturedImages.first,
//                           height: 180,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Red warning tag in center if disease found
//                   if (hasDisease)
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.red.shade600,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.red.withOpacity(0.3),
//                             blurRadius: 8,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.warning_rounded,
//                             color: Colors.white,
//                             size: 18,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             'Disease Detected',
//                             style: TextStyle(
//                               fontFamily: AppFonts.sfPro,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   else
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 12,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.green.shade600,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.green.withOpacity(0.3),
//                             blurRadius: 8,
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.check_circle_rounded,
//                             color: Colors.white,
//                             size: 22,
//                           ),
//                           SizedBox(width: 8),
//                           Text(
//                             'Plant is Healthy',
//                             style: TextStyle(
//                               fontFamily: AppFonts.sfPro,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                               letterSpacing: 0.5,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//               SizedBox(height: 16),

//               // Plant Name Card
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Color(0xffE0E0E0)),
//                   borderRadius: BorderRadius.circular(16),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       diagnosisData.plantName,
//                       style: TextStyle(
//                         fontFamily: AppFonts.sfPro,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.themeColor,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       diagnosisData.scientificName,
//                       style: TextStyle(
//                         fontFamily: AppFonts.sfPro,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                         color: Color(0xff797979),
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       diagnosisData.description,
//                       style: TextStyle(
//                         fontFamily: AppFonts.sfPro,
//                         fontSize: 13,
//                         color: Color(0xff797979),
//                         height: 1.5,
//                       ),
//                     ),
//                     SizedBox(height: 6),

//                     // Confidence meter
//                     // Row(
//                     //   children: [
//                     //     Text(
//                     //       'Confidence: ${(diagnosisData.confidence * 100).toStringAsFixed(0)}%',
//                     //       style: TextStyle(
//                     //         fontFamily: AppFonts.sfPro,
//                     //         fontSize: 12,
//                     //         fontWeight: FontWeight.w600,
//                     //         color: AppColors.themeColor,
//                     //       ),
//                     //     ),
//                     //     SizedBox(width: 8),
//                     //     Expanded(
//                     //       child: ClipRRect(
//                     //         borderRadius: BorderRadius.circular(4),
//                     //         child: LinearProgressIndicator(
//                     //           value: diagnosisData.confidence,
//                     //           minHeight: 6,
//                     //           backgroundColor: Colors.grey.shade300,
//                     //           valueColor: AlwaysStoppedAnimation<Color>(
//                     //             diagnosisData.confidence > 0.8
//                     //                 ? Colors.green
//                     //                 : diagnosisData.confidence > 0.6
//                     //                 ? Colors.orange
//                     //                 : Colors.red,
//                     //           ),
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 16),

//               // Disease Expansion Tile
//               if (hasDisease)
//                 _buildExpansionTile(
//                   title: diagnosisData.disease,
//                   icon: null,
//                   content: diagnosisData.description,
//                   isDisease: true,
//                 ),
//               SizedBox(height: 10),

//               // Treatment Expansion Tile
//               _buildExpansionTile(
//                 title: 'Treatment',
//                 icon: AppIcons.treatment,
//                 isBulletList: true,
//                 bulletPoints: diagnosisData.treatments,
//               ),
//               SizedBox(height: 10),

//               // Common Problems Expansion Tile
//               _buildExpansionTile(
//                 title: 'Common Problems',
//                 icon: AppIcons.common_problem,
//                 isBulletList: true,
//                 bulletPoints: diagnosisData.commonProblems,
//               ),
//               SizedBox(height: 10),

//               // Care Tips Expansion Tile
//               _buildExpansionTile(
//                 title: 'Care Tips',
//                 icon: AppIcons.care_tips,
//                 isBulletList: true,
//                 bulletPoints: diagnosisData.careTips,
//               ),
//               SizedBox(height: 8),
//               _bottomCard(),
//               SizedBox(height: 10),
//             ],
//           );
//         }),
//       ),
//     );
//   }

//   // Greyscale matrix for ColorFilter
//   List<double> _getGreyscaleMatrix() {
//     return [
//       0.299,
//       0.587,
//       0.114,
//       0,
//       0,
//       0.299,
//       0.587,
//       0.114,
//       0,
//       0,
//       0.299,
//       0.587,
//       0.114,
//       0,
//       0,
//       0,
//       0,
//       0,
//       1,
//       0,
//     ];
//   }

//   // Identity matrix for no filter
//   List<double> _getIdentityMatrix() {
//     return [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
//   }

//   Widget _buildExpansionTile({
//     required String title,
//     String? icon,
//     String? content,
//     bool isBulletList = false,
//     List<String>? bulletPoints,
//     bool isDisease = false,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: isDisease ? Colors.red.shade300 : Color(0xffE0E0E0),
//         ),
//         borderRadius: BorderRadius.circular(16),
//         color: isDisease ? Colors.red.shade50 : Colors.white,
//       ),
//       child: ExpansionTile(
//         tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         collapsedShape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         title: Row(
//           children: [
//             if (isDisease)
//               Icon(Icons.warning_rounded, size: 24, color: Colors.red.shade600)
//             else if (icon != null)
//               SvgPicture.asset(icon, height: 24),
//             SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontFamily: AppFonts.sfPro,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: isDisease ? Colors.red.shade700 : Colors.black,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
//             child:
//                 isBulletList && bulletPoints != null && bulletPoints.isNotEmpty
//                 ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: bulletPoints
//                         .map((point) => _buildBulletPoint(point))
//                         .toList(),
//                   )
//                 : Text(
//                     content ?? 'No information available',
//                     style: TextStyle(
//                       fontFamily: AppFonts.sfPro,
//                       fontSize: 13,
//                       color: Color(0xff797979),
//                       height: 1.5,
//                       letterSpacing: 0,
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBulletPoint(String text) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(right: 12, top: 6),
//             child: Container(
//               width: 6,
//               height: 6,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade400,
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontFamily: AppFonts.sfPro,
//                 fontSize: 14,
//                 color: Colors.grey.shade600,
//                 height: 1.5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _bottomCard() {
//     return GestureDetector(
//       onTap: () {
//         Get.to(() => PlanteoExpertScreen());
//       },
//       child: Container(
//         height: 155,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(20),
//             bottomRight: Radius.circular(20),
//           ),
//           image: DecorationImage(
//             alignment: Alignment(0, -0.7),
//             image: AssetImage(AppImages.home_first_tool),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.only(left: 20.0, right: 130),
//           child: Column(
//             children: [
//               SizedBox(height: 28),
//               Row(
//                 children: [
//                   Text(
//                     'Planteo Expert',
//                     style: TextStyle(
//                       fontSize: 23,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xff216E49),
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'Chat with Planteo\'s expert AI and get instant solutions for all your plant and farming questions.',
//                       style: TextStyle(fontSize: 12, color: Color(0xff797979)),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
