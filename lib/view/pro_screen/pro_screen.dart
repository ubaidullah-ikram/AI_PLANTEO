import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/view_model/pro_screen_controller/pro_screen_controller.dart';

class PlanteoProScreen extends StatefulWidget {
  const PlanteoProScreen({Key? key}) : super(key: key);

  @override
  State<PlanteoProScreen> createState() => _PlanteoProScreenState();
}

class _PlanteoProScreenState extends State<PlanteoProScreen>
    with SingleTickerProviderStateMixin {
  // String selectedPlan = 'yearly'; // 'yearly' or 'weekly'
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int selectedIndex = 1;
  var procontroller = Get.find<ProScreenController>();
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              // Image Carousel Section
              Stack(
                children: [
                  Container(
                    height: 230,

                    child: Center(
                      child: Image.asset(
                        AppIcons.proScreengif,

                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Text('Gif placeholder'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.close),
                    ),
                  ),
                ],
              ),

              // Content Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 24,
                  vertical: isMobile ? 20 : 28,
                ),
                child: Column(
                  children: [
                    // Title with Crown Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppIcons.small_pro,
                          height: 15,
                          // fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Text('Gif placeholder'),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'PLANTEO PRO',
                          style: TextStyle(
                            fontSize: isMobile ? 28 : 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D7A6B),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 10),
                        Image.asset(
                          AppIcons.small_pro,
                          height: 15,
                          // fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Text('Gif placeholder'),
                        ),
                      ],
                    ),

                    SizedBox(height: isMobile ? 8 : 12),

                    // Subtitle
                    Text(
                      'Help your plants grow healthier with\nPlanteo PRO',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: isMobile ? 10 : 28),

                    // Features List
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFeatureItem(
                          '✦',
                          'Unlimited plant identification',
                          isMobile,
                        ),

                        _buildFeatureItem(
                          '✦',
                          'Instant disease detection',
                          isMobile,
                        ),

                        _buildFeatureItem(
                          '✦',
                          'Smart care reminders',
                          isMobile,
                        ),
                        _buildFeatureItem(
                          '✦',
                          'Smart watering reminders',
                          isMobile,
                        ),
                        _buildFeatureItem('✦', 'No ads experience', isMobile),
                      ],
                    ),

                    SizedBox(height: isMobile ? 24 : 32),
                    ListView.builder(
                      itemCount: procontroller.products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final product = procontroller.products[index];

                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: _buildPricingPlan(
                                product.title == 'Weekly Plan'
                                    ? 'Weekly'
                                    : 'Yearly',
                                product.priceString,
                                index == 1
                                    ? '3 Days Free Trial'
                                    : 'Billed Weekly',
                                selectedIndex == index, // ✅ selection yahan
                                isMobile,
                                () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                              ),
                            ),
                            index == 0
                                ? SizedBox.shrink()
                                : Positioned(
                                    right: 20,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Color(0xff359767),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 2,
                                        ),
                                        child: Text(
                                          'Recommended',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        );
                      },
                    ),

                    // Pricing Plans
                    // SizedBox(height: isMobile ? 12 : 16),

                    // _buildPricingPlan(
                    //   'Weekly',
                    //   'Rs 1254.98',
                    //   'Billed Weekly',
                    //   false,
                    //   isMobile,
                    // ),
                    SizedBox(height: isMobile ? 10 : 28),

                    // CTA Button
                    SizedBox(
                      width: double.infinity,
                      height: isMobile ? 52 : 56,
                      child: ElevatedButton(
                        onPressed: () {
                          final product = procontroller.products[selectedIndex];
                          procontroller.buyProduct(product, context);
                          log('the selected product is $product');
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text(
                          //       'Starting ${selectedPlan.toUpperCase()} plan...',
                          //     ),
                          //     duration: const Duration(seconds: 2),
                          //   ),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF359767),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          // elevation: 4,
                        ),
                        child: Text(
                          selectedIndex == 0
                              ? "Continue"
                              : 'Get Free Trail Now',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: isMobile ? 12 : 16),

                    // No Payment Info
                    selectedIndex == 0
                        ? SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: isMobile ? 18 : 20,
                                color: Colors.black,
                              ),
                              SizedBox(width: isMobile ? 8 : 10),
                              Text(
                                'No Payment Now',
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),

                    SizedBox(height: isMobile ? 6 : 20),

                    // Footer Links
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFooterLink('Privacy Policy', isMobile),
                        _buildDividerVertical(),
                        _buildFooterLink('Terms & Conditions', isMobile),
                        _buildDividerVertical(),
                        _buildFooterLink('Restore Purchase', isMobile),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String icon, String text, bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min, // 🔥 important
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppImages.pro_txt, height: 10),
        SizedBox(width: isMobile ? 6 : 16),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 13 : 15,
            color: Color(0xff216E49),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDividerVertical() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text('|', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
    );
  }

  Widget _buildPricingPlan(
    String title,
    String price,
    String subtitle,
    bool isSelected,
    bool isMobile,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFE0F2F0) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF359767) : Color(0xffE0E0E0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2D7A6B).withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isMobile ? 14 : 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF359767),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 14,
                    color: const Color(0xFF359767),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLink(String text, bool isMobile) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(text)));
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: isMobile ? 11 : 12,
          color: Color(0xff5E626C),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
