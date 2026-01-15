import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:plantify/view_model/alarm_reminder_controller/reminder_controller.dart';

class CustomTimePicker extends StatefulWidget {
  CustomTimePicker({super.key});

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker>
    with TickerProviderStateMixin {
  var controller = Get.find<ReminderController>();

  @override
  Widget build(BuildContext context) {
    var tabcontroller = TabController(length: 2, vsync: this);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xffE0E0E0)!, width: 1),
      ),
      child: Column(
        children: [
          /// 🔹 Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Time",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),

              /// Selected Time Display
              Obx(
                () => Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.expand_timer_card.value =
                            !controller.expand_timer_card.value;
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${controller.selectedHour.value.toString().padLeft(2, '0')}:${controller.selectedMinute.value.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Color(0xffF3F3F3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: TabBar(
                          onTap: (value) {
                            log('time tap $value');
                            controller.period.value = value == 0 ? "AM" : "PM";
                          },
                          labelStyle: TextStyle(
                            color: AppColors.textHeading,
                            fontSize: 14,
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          indicatorColor: Colors.white,
                          dividerColor: Colors.transparent,
                          controller: tabcontroller,
                          tabs: [
                            Tab(text: 'AM'),
                            Tab(text: 'PM'),
                          ],
                        ),
                      ),
                    ),

                    // ToggleButtons(
                    //   isSelected: [
                    //     controller.period.value == "AM",
                    //     controller.period.value == "PM",
                    //   ],
                    //   borderRadius: BorderRadius.circular(12),
                    //   onPressed: (index) {
                    //     controller.period.value = index == 0 ? "AM" : "PM";
                    //   },
                    //   children: const [
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 12),
                    //       child: Text("AM"),
                    //     ),
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 12),
                    //       child: Text("PM"),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),

          /// 🔹 Pickers with SAME selection row
          Obx(
            () => controller.expand_timer_card.value == false
                ? Column(
                    children: [
                      // const SizedBox(height: 20),
                      SizedBox(
                        height: 110,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            /// ✅ Common Selection Background
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            /// Pickers Row
                            Row(
                              children: [
                                /// HOURS
                                ///
                                Expanded(child: Text('')),
                                Expanded(
                                  child: CupertinoPicker(
                                    itemExtent: 40,
                                    selectionOverlay: null,
                                    scrollController:
                                        FixedExtentScrollController(
                                          initialItem: controller
                                              .selected_time_hours
                                              .value,
                                        ),
                                    onSelectedItemChanged: (index) {
                                      controller.selectedHour.value = index + 1;
                                    },
                                    children: List.generate(
                                      12,
                                      (index) => Obx(
                                        () => Center(
                                          child: Text(
                                            "${index + 1}",
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  controller
                                                          .selectedHour
                                                          .value ==
                                                      index + 1
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// MINUTES
                                Expanded(
                                  child: CupertinoPicker(
                                    itemExtent: 40,
                                    selectionOverlay: null,
                                    onSelectedItemChanged: (index) {
                                      controller.selectedMinute.value = index;
                                    },
                                    children: List.generate(
                                      60,
                                      (index) => Obx(
                                        () => Center(
                                          child: Text(
                                            index.toString().padLeft(2, '0'),
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  controller
                                                          .selectedMinute
                                                          .value ==
                                                      index
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: SizeConfig.w(39)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
