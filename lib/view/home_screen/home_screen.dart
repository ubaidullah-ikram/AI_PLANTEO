import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/services/remote_config_service.dart';
import 'package:plantify/view/diagnose_view/daignose_screen_camera.dart';
import 'package:plantify/view/diagnose_view/widgets/diagnose_result_screen.dart';
import 'package:plantify/view/light_meter/light_meter_sc.dart';
import 'package:plantify/view/my_garden_view/my_garden_screen.dart';
import 'package:plantify/view/plantio_expert_chat_sc/plant_chat_screen.dart';
import 'package:plantify/view/reminders_view/reminder_view.dart';
import 'package:plantify/view/setting_sc/setting_screen.dart';
import 'package:plantify/view_model/camera_controller/diagnose_camera_controller.dart';
import 'package:svg_flutter/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final cameraCtrl = Get.put(DiagnoseCameraController());
  final List<Map<String, dynamic>> cards = [
    {
      'title': 'Reminder',
      'icon': AppImages.reminder_icon, // apna icon path
      'color': Color(0xffC2DFD5),
    },
    {
      'title': 'Light Meter',
      'icon': AppImages.light_meter_icon, // apna icon path
      'color': Color(0xffFFF4D0),
    },
    {
      'title': 'My Garden',
      'icon': AppImages.my_garden_icon, // apna icon path
      'color': Color(0xffC6D8B9),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Color(0xffF9F9F9),
        surfaceTintColor: Color(0xffF9F9F9),
        automaticallyImplyLeading: false,
        title: Row(
          children: [SvgPicture.asset(AppIcons.home_logo, height: 24)],
        ),
        actions: [
          Container(
            height: 30,
            width: 94,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColors.themeColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(
                    color: Colors.white,
                    AppIcons.pro_icon_white,
                    height: 14,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  'Upgrade',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Get.to(() => SettingScreen());
            },
            child: SvgPicture.asset(AppIcons.setting, height: 24),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),

              // Image.asset(AppImages.home_first_tool),
              GestureDetector(
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
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Support Tools',
                    style: TextStyle(
                      fontFamily: AppFonts.sfPro,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textHeading,
                    ),
                  ),
                ],
              ),
              // TextButton(
              //   onPressed: () {
              //     Get.to(() => DiagnoseResultScreen());
              //   },
              //   child: Text('data'),
              // ),
              SizedBox(height: 10),
              supportToolCard(
                "Identify Plants",
                "Snap a photo and instantly discover the name, type, and details of any plant.",
                AppImages.identify_plant,
                Color(0xffC2DFD5),
                0,
              ),
              supportToolCard(
                "Diagnose Plants",
                "Find out what’s wrong with your plant and get fixes to help it recover.",
                AppImages.diagnose_plant,
                Color(0xffFFF4D0),
                1,
              ),
              supportToolCard(
                "Identify Mushroom",
                "Identify mushrooms with a quick photo and get reliable information instantly.",
                AppImages.mushroom,
                Color(0xffC6D8B9),
                2,
              ),

              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Monitor & Maintain',
                    style: TextStyle(
                      fontFamily: AppFonts.sfPro,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textHeading,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 94,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          // Card click action
                          if (index == 0) {
                            Get.to(() => ReminderScreen(isfromEdit: false));
                          } else if (index == 2) {
                            Get.to(() => MyGardenScreen());
                          } else {
                            Get.to(() => LightMeterScreen());
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          width: 130,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffE0E0E0)),
                            color: card['color'],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image/Icon
                              Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Image.asset(
                                  card['icon'],
                                  height: 50,
                                  // fit: BoxFit.cover,
                                  // width: 50,
                                  // color: Colors.amber,
                                ),
                              ),
                              SizedBox(height: 6),
                              // Text
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 12),
                                  Text(
                                    card['title'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  // SizedBox(width: 8),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    // color: Colors.black54,
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget supportToolCard(
    String toolNAme,
    String toolDesc,
    String toolImg,
    Color cardColor,
    int index,
  ) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (index == 0) {
              // Get.to(() => PlanteoExpertScreen());
            } else if (index == 1) {
              Get.to(() => DiagnosePlantScreen(isfromHome: true));
            } else if (index == 2) {
              // Get.to(() => PlanteoExpertScreen());
            }
          },
          child: SizedBox(
            height: 105,
            child: Center(
              child: Container(
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        toolNAme,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff054023),
                        ),
                      ),
                      Text(
                        toolDesc,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,

                          color: Color(0xff797979),
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
          right: index == 2 ? 5 : -10,
          top: index == 2 ? 0 : -10,
          child: Image.asset(
            toolImg,
            height: index == 2 ? 80 : 110,
            // fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
