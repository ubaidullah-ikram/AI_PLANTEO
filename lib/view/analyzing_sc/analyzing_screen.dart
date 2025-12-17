import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/view/home_screen/home_screen.dart';

class AnalyzingScreen extends StatefulWidget {
  const AnalyzingScreen({super.key});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Start animation
    _controller.forward();

    // Navigate to home screen jab progress complete ho
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Get.to(() => HomeScreen());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE0F2F0),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.instruction_loading,
              fit: BoxFit.cover,
              // color: Color(0xffE0F2F0),
            ),
          ), // Background image
          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Progress bar indicator

                // Text
                Text(
                  'Hold on!\nyour personalized plant care \njourney is being crafted!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.themeColor,
                  ),
                ),
                const SizedBox(height: 30),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      width: 200,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Color(0xff7EC639),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: _animation.value,
                          minHeight: 6,
                          backgroundColor: Color(0xff7EC639),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.themeColor!,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 15),
                // Percentage text
                // AnimatedBuilder(
                //   animation: _animation,
                //   builder: (context, child) {
                //     return Text(
                //       '${(_animation.value * 100).toStringAsFixed(0)}%',
                //       style: const TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w500,
                //         color: Colors.green,
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
