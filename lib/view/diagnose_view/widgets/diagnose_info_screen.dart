import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:plantify/view/analyzing_sc/analyzing_screen.dart';
import 'package:plantify/view/diagnose_view/daignose_screen_camera.dart';
import 'package:plantify/view/diagnose_view/widgets/diagnose_result_screen.dart';
import 'package:plantify/view_model/camera_controller/diagnose_camera_controller.dart';
import 'package:svg_flutter/svg.dart';

class DiagnoseInfoScreen extends StatefulWidget {
  const DiagnoseInfoScreen({Key? key}) : super(key: key);

  @override
  State<DiagnoseInfoScreen> createState() => _DiagnoseInfoScreenState();
}

class _DiagnoseInfoScreenState extends State<DiagnoseInfoScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  var diagnoseController = Get.put(DiagnoseCameraController());
  int _currentIndex = 0;

  // Har screen ke liye selected options store karne ke liye
  Map<int, Set<int>> _selectedOptions = {};

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();

    // Initialize empty sets for each screen
    for (int i = 0; i < diagnoseController.screens.length; i++) {
      _selectedOptions[i] = {};
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _toggleOption(int optionIndex) {
    setState(() {
      if (_selectedOptions[_currentIndex]!.contains(optionIndex)) {
        _selectedOptions[_currentIndex]!.remove(optionIndex);
      } else {
        _selectedOptions[_currentIndex]!.add(optionIndex);
      }
    });
  }

  void _nextScreen() {
    if (_currentIndex < diagnoseController.screens.length - 1) {
      _fadeController.reverse().then((_) {
        setState(() {
          _currentIndex++;
        });
        _fadeController.forward();
      });
    } else {
      log('its done now request');
      Get.off(() => DiagnosePlantScreen(isfromHome: false));
      // Last screen par "Done" button press hone par
      // Navigator.of(context).pop();
    }
  }

  void _previousScreen() {
    if (_currentIndex > 0) {
      _fadeController.reverse().then((_) {
        setState(() {
          _currentIndex--;
        });
        _fadeController.forward();
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var tabcontroller = TabController(length: 2, vsync: this);
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _previousScreen,
                    child: Icon(
                      Icons.chevron_left,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                  // Progress Indicator
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      diagnoseController.screens.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Container(
                          height: 4,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: index <= _currentIndex
                                ? AppColors.themeColor
                                : Colors.grey[300],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(''),
                ],
              ),
            ),

            // Content Area
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _currentIndex == 2
                            ? _diagnoseOptionFrame2()
                            : _currentIndex == 3
                            ? _diagnoseOptionFrame3(tabcontroller)
                            : _diagnoseOptionFrame1(),

                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        // : SizedBox.fromSize(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Continue Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.themeColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentIndex == diagnoseController.screens.length - 1
                        ? 'Done'
                        : 'Continue',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextScreen,
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'I don’t know',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeading,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskButton(String risk) {
    final isSelected = selectedRisk == risk;

    return Expanded(
      child: SizedBox(
        height: 38,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: isSelected
                  ? AppColors.themeColor
                  : const Color(0xFFDDDDDD),
              width: isSelected ? 1 : 1,
            ),
            backgroundColor: isSelected ? Color(0xFFE0F2F0) : Color(0xffF3F3F3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: () {
            setState(() {
              selectedRisk = risk;
            });
          },
          child: Text(
            risk,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF1A9B8E)
                  : const Color(0xFFAAAAAA),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  String selectedUnit = 'C';

  String selectedRisk = 'High';
  double sliderValue = 80;
  double tempSlider = 60;
  Widget _diagnoseOptionFrame1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: SizeConfig.h(70)),
        Text(
          diagnoseController.screens[_currentIndex].title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.themeColor,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              itemCount: diagnoseController.capturedImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      decoration: BoxDecoration(
                        // color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(6),
                            child: Image.memory(
                              height: 50,
                              width: double.infinity,
                              diagnoseController.capturedImages[index],
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

        SizedBox(height: 10),
        Column(
          children: List.generate(
            diagnoseController.screens[_currentIndex].options.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OptionButton(
                text: diagnoseController.screens[_currentIndex].options[index],
                isSelected: _selectedOptions[_currentIndex]!.contains(index),
                onTap: () {
                  _toggleOption(index);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _diagnoseOptionFrame2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: SizeConfig.h(70)),
        Text(
          'Humidity Level',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.themeColor,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              itemCount: diagnoseController.capturedImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      decoration: BoxDecoration(
                        // color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(6),
                            child: Image.memory(
                              height: 50,
                              width: double.infinity,
                              diagnoseController.capturedImages[index],
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

        SizedBox(height: 10),
        Column(
          children: [
            Image.asset(AppImages.diagnose_image_bg),

            SizedBox(height: 30),
            // SizedBox(height: Get.height * 0.12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRiskButton('Low'),
                  const SizedBox(width: 6),
                  _buildRiskButton('Medium'),
                  const SizedBox(width: 6),
                  _buildRiskButton('High'),
                ],
              ),
            ), // Slider
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      activeTrackColor: const Color(0xFF1A9B8E),
                      inactiveTrackColor: const Color(0xFFD9D9D9),
                      thumbColor: Colors.white,

                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 12,
                      ),
                      trackHeight: 6,
                    ),
                    child: Slider(
                      value: sliderValue,
                      min: 0,
                      max: 100,
                      onChanged: (value) {
                        setState(() {
                          sliderValue = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '${sliderValue.toInt()}%',
                  style: TextStyle(
                    color: AppColors.textHeading,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _diagnoseOptionFrame3(TabController? tabcontroller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: SizeConfig.h(70)),
        Text(
          'Temperature',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.themeColor,
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              itemCount: diagnoseController.capturedImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      decoration: BoxDecoration(
                        // color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(6),
                            child: Image.memory(
                              height: 50,
                              width: double.infinity,
                              diagnoseController.capturedImages[index],
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

        SizedBox(height: 10),
        Column(
          children: [
            Image.asset(AppImages.diagnose_image_bg),

            SizedBox(height: 30),
            Container(
              width: 90,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Color(0xffF3F3F3),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: TabBar(
                  labelStyle: TextStyle(color: AppColors.textHeading),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  indicatorColor: Colors.white,
                  dividerColor: Colors.transparent,
                  controller: tabcontroller,
                  tabs: [
                    Tab(text: 'C'),
                    Tab(text: 'F'),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      activeTrackColor: const Color(0xFF1A9B8E),
                      inactiveTrackColor: const Color(0xFFD9D9D9),
                      thumbColor: Colors.white,

                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 12,
                      ),
                      trackHeight: 6,
                    ),
                    child: Slider(
                      value: tempSlider,
                      min: 0,
                      max: 100,
                      onChanged: (value) {
                        setState(() {
                          tempSlider = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '${tempSlider.toInt()}%',
                  style: TextStyle(
                    color: AppColors.textHeading,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 62,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppColors.themeColor.withOpacity(0.9)
                : Colors.grey[300] ?? Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? const Color(0xFFE0F2F0) : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? AppColors.themeColor : Colors.black,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF2BA84A),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
