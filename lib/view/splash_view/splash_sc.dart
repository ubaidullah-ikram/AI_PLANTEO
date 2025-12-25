import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:plantify/view/home_screen/home_screen.dart';
import 'package:plantify/view/instruction_screen/onb_instruction_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(20)),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.h(180)),
              Container(
                // color: Colors.amber,
                height: SizeConfig.h(292),
                width: double.infinity,
                child: Image.asset(
                  alignment: Alignment(-1.4, 0),
                  AppImages.splashLogo,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Image.asset(
                    height: SizeConfig.h(32),
                    AppImages.splash_text_logo,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'Your Plants Deserve Better Planteo Helps Them Thrive Every Day.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xff242424),
                  fontFamily: 'SFPRO',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  // Get.to(() => HomeScreen());
                  Get.to(() => InstructionScreens());
                },
                child: Container(
                  height: SizeConfig.h(54),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.themeColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'SFPRO',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
