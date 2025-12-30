import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/view/plantio_expert_chat_sc/plant_chat_screen.dart';
import 'package:svg_flutter/svg_flutter.dart';

class DiagnoseResultScreen extends StatefulWidget {
  const DiagnoseResultScreen({super.key});

  @override
  State<DiagnoseResultScreen> createState() => _DiagnoseResultScreenState();
}

class _DiagnoseResultScreenState extends State<DiagnoseResultScreen> {
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
        child: ListView(
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
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                AppImages.diagnose_image_bg,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 12),

            // Root Rot Expansion Tile
            _buildExpansionTile(
              title: 'Root Rot',
              icon: null,
              content:
                  'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. content here\', making it look like readable English.',
            ),
            SizedBox(height: 10),

            // Treatment Expansion Tile
            _buildExpansionTile(
              title: 'Treatment',
              icon: AppIcons.treatment,
              isBulletList: true,
              bulletPoints: [
                'It is a long established fact that a reader will be distracted',
                'It is a long established fact that a reader will be distracted',
                'It is a long established fact that a reader will be distracted',
                'It is a long established fact that a reader will be distracted',
              ],
            ),
            SizedBox(height: 10),

            // Common Problems Expansion Tile
            _buildExpansionTile(
              title: 'Common Problems',
              icon: AppIcons.common_problem,
              content: 'Common problems and solutions for this disease.',
            ),
            SizedBox(height: 10),

            // Care Tips Expansion Tile
            _buildExpansionTile(
              title: 'Care Tips',
              icon: AppIcons.care_tips,
              content:
                  'Important care tips to prevent and manage this condition.',
            ),
            SizedBox(height: 8),
            _bottomCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    String? icon,
    String? content,
    bool isBulletList = false,
    List<String>? bulletPoints,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffE0E0E0)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            if (icon != null) ...[
              // Icon(icon, size: 24, color: AppColors.themeColor),
              SvgPicture.asset(icon, height: 24),
              SizedBox(width: 12),
            ],
            Text(
              title,
              style: TextStyle(
                fontFamily: AppFonts.sfPro,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: isBulletList
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: bulletPoints!
                        .map((point) => _buildBulletPoint(point))
                        .toList(),
                  )
                : Text(
                    content ?? '',
                    style: TextStyle(
                      fontFamily: AppFonts.sfPro,
                      fontSize: 13,
                      color: Color(0xff797979),
                      // height: 1.5,
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
          // color: Colors.green,
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
                      'Chat with Planteo’s expert AI and get instant solutions for all your plant and farming questions.',
                      style: TextStyle(
                        fontSize: 12,
                        // fontWeight: FontWeight.w700,
                        color: Color(0xff797979),
                      ),
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
