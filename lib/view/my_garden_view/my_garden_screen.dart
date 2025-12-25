import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:plantify/view_model/my_garden_controller/my_garden_controller.dart';
import 'package:svg_flutter/svg_flutter.dart';

class MyGardenScreen extends StatefulWidget {
  const MyGardenScreen({super.key});

  @override
  State<MyGardenScreen> createState() => _MyGardenScreenState();
}

class _MyGardenScreenState extends State<MyGardenScreen> {
  var mygardenController = Get.put(MyGardenController());
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
          'My Garden',
          style: TextStyle(
            fontFamily: AppFonts.sfPro,
            fontWeight: FontWeight.w600,
            color: AppColors.themeColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mygardenController.gardenFilterList.length,
                itemBuilder: (context, index) {
                  return Obx(
                    () => Center(
                      child: GestureDetector(
                        onTap: () {
                          mygardenController.selectFilter.value = index;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffE0E0E0)),
                            color:
                                mygardenController.selectFilter.value == index
                                ? Colors.white
                                : Color(0xffF3F3F3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          height: 34,
                          child: Center(
                            child: Text(
                              mygardenController.gardenFilterList[index],
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    mygardenController.selectFilter.value ==
                                        index
                                    ? AppColors.themeColor
                                    : Color(0xffA2ABA8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Obx(
              () => mygardenController.selectFilter.value == 1
                  ? _buildEmptyWidget()
                  : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: 10,
                        // shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _cardWidget();
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardWidget() {
    return Stack(
      // fit: StackFit.expand,
      // clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            // color: Colors.amber,
            borderRadius: BorderRadius.circular(16),

            border: Border.all(color: Color(0xffE0E0E0)),
          ),
          margin: EdgeInsets.only(top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Image.asset(AppImages.garden_image, height: 115, width: 100),
                ],
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    'Wolffiella gladiata',
                    style: TextStyle(fontFamily: AppFonts.sfPro, fontSize: 12),
                  ),
                  Text(
                    'Watermeal',
                    style: TextStyle(
                      fontFamily: AppFonts.sfPro,
                      fontSize: 18,
                      color: AppColors.themeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Flowering Plant',
                    style: TextStyle(fontFamily: AppFonts.sfPro, fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 1,
                    width: SizeConfig.w(200),
                    color: Color(0xffE6E6E6),
                  ),
                  SizedBox(height: 10),
                  //   Container(
                  //     height: 30,
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: 20,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color: AppColors.themeColor.withOpacity(
                  //           0.5,
                  //         ),
                  //       ),
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: Center(
                  //       child: Row(
                  //         children: [
                  //           SvgPicture.asset(AppIcons.clock),
                  //           SizedBox(width: 8),
                  //           Text(
                  //             'Add Reminder',
                  //             style: TextStyle(
                  //               fontSize: 10,
                  //               color: AppColors.themeColor,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          right: 20,
          top: SizeConfig.h(10),
          child: Icon(Icons.more_horiz),
        ),

        Positioned(
          right: 20,
          bottom: SizeConfig.h(10),
          child: Container(
            height: 30,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.themeColor.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Row(
                children: [
                  SvgPicture.asset(AppIcons.clock),
                  SizedBox(width: 8),
                  Text(
                    'Add Reminder',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.themeColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyWidget() {
    return Padding(
      padding: EdgeInsets.only(top: Get.height * .28),
      child: Column(
        children: [
          Text(
            'Your Mushroom List Is Empty',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.themeColor,
            ),
          ),
          Text(
            'Start exploring! Identify or diagnose \nany plant to see it appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xff797979)),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: SizeConfig.h(54),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.themeColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 18),
                  Text(
                    ' Add Mushroom',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'SFPRO',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
