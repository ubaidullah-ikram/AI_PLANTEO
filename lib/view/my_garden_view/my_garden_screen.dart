import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:plantify/view/my_garden_view/widgets/plant_bottom_sheet_widget.dart';
import 'package:plantify/view/reminders_view/reminder_view.dart';
import 'package:plantify/view_model/my_garden_controller/my_garden_controller.dart';
import 'package:svg_flutter/svg_flutter.dart';

class MyGardenScreen extends StatefulWidget {
  const MyGardenScreen({super.key});

  @override
  State<MyGardenScreen> createState() => _MyGardenScreenState();
}

class _MyGardenScreenState extends State<MyGardenScreen>
    with TickerProviderStateMixin {
  var mygardenController = Get.put(MyGardenController());
  late AnimationController _controller;
  bool isReminderTap = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleReminder() {
    setState(() {
      isReminderTap = !isReminderTap;
    });
    if (isReminderTap) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
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
            Expanded(
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
                                      mygardenController.selectFilter.value ==
                                          index
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
                                      fontWeight: FontWeight.w600,
                                      color:
                                          mygardenController
                                                  .selectFilter
                                                  .value ==
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
                        : mygardenController.selectFilter.value == 2
                        ? Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.all(0),
                              itemCount: 10,
                              // shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return _reminderCardWidget();
                              },
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.all(0),
                              itemCount: 10,
                              // shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return _plantcardWidget();
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Obx(
                () => mygardenController.selectFilter.value == 1
                    ? SizedBox.shrink()
                    : GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
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
                              SizedBox(width: 4),
                              Text(
                                mygardenController.selectFilter.value == 0
                                    ? "Add Plant"
                                    : 'Add Reminder',
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _plantcardWidget() {
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
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(8),
                    child: Image.asset(
                      AppImages.garden_image,
                      height: 110,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
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
          right: 0,
          top: SizeConfig.h(0),
          child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Color(0xffF9F9F9),
                context: context,
                builder: (_) => PlantBottomSheetWidget(),
              );
            },
            icon: Icon(Icons.more_horiz),
          ),
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

  Widget _reminderCardWidget() {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Color(0xffE0E0E0)!, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(AppIcons.watering, height: 18),
                      SizedBox(width: 10),
                      Text(
                        'Watering',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.themeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _toggleReminder,
                    child: Row(
                      children: [
                        Text(
                          '1 Plants',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xffA2ABA8),
                          ),
                        ),
                        SizedBox(width: 5),
                        AnimatedRotation(
                          turns: isReminderTap ? 0.5 : 0,
                          duration: Duration(milliseconds: 300),
                          child: Icon(
                            CupertinoIcons.chevron_down,
                            size: 18,
                            color: Color(0xffA2ABA8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isReminderTap == true
                    ? Column(
                        children: [
                          Divider(color: Color(0xffE6E6E6)),
                          SizedBox(height: 4),
                          ListTile(
                            onTap: () {
                              Get.to(() => ReminderScreen(isfromEdit: true));
                            },
                            contentPadding: EdgeInsets.symmetric(horizontal: 0),
                            leading: Image.asset(AppImages.garden_image),
                            title: Text(
                              'Watermeal',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.themeColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
