import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:get/get.dart';
import 'package:plantify/view_model/alarm_reminder_controller/reminder_controller.dart';

class RepeatReminderWidget extends StatefulWidget {
  const RepeatReminderWidget({super.key});

  @override
  State<RepeatReminderWidget> createState() => _RepeatReminderWidgetState();
}

class _RepeatReminderWidgetState extends State<RepeatReminderWidget> {
  var reminderController = Get.find<ReminderController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 64,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
              Text(
                'Repeat',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Obx(
                () => GestureDetector(
                  onTap: () {
                    reminderController.expandRepeatCard.value =
                        !reminderController.expandRepeatCard.value;
                  },
                  child: reminderController.selectedRepeat.value.isEmpty
                      ? Text(
                          'Select',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Text(
                          'Every ${reminderController.repeatDays.value} Days',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textHeading,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),

          Obx(
            () => reminderController.expandRepeatCard.value == false
                ? Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        height: 110,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            /// 🔹 Common Selection Overlay (SAME ROW HIGHLIGHT)
                            Container(
                              height: 40,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.withOpacity(0.15),
                              ),
                            ),

                            /// 🔹 Two Pickers in One Row
                            Row(
                              children: [
                                Expanded(child: Container()),

                                /// ===== LEFT PICKER (Numbers) =====
                                Expanded(
                                  child: CupertinoPicker(
                                    itemExtent: 40,
                                    scrollController:
                                        FixedExtentScrollController(
                                          initialItem: reminderController
                                              .selectedRepeaseIndex
                                              .value,
                                        ),
                                    selectionOverlay: null, // ❌ disable default
                                    onSelectedItemChanged: (index) {
                                      reminderController
                                              .selectedRepeaseIndex
                                              .value =
                                          index;
                                      reminderController.repeatDays.value =
                                          index + 1;
                                      reminderController.selectedRepeat.value =
                                          'index';
                                    },
                                    children: List.generate(
                                      reminderController.repeatListDays.length,
                                      (index) => Center(
                                        child: Obx(
                                          () => Text(
                                            reminderController
                                                .repeatListDays[index]
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  reminderController
                                                          .selectedRepeaseIndex
                                                          .value ==
                                                      index
                                                  ? AppColors.textHeading
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// ===== RIGHT PICKER (Label) =====
                                Expanded(
                                  child: CupertinoPicker(
                                    itemExtent: 40,
                                    selectionOverlay: null, // ❌ disable default
                                    onSelectedItemChanged: (index) {
                                      // reminderController.selectedRepeat.value =
                                      //     reminderController
                                      //         .repeatdaysMonth[index];
                                      reminderController
                                              .selectedRepeaseDayIndex
                                              .value =
                                          index;
                                    },
                                    children: List.generate(
                                      reminderController.repeatdaysMonth.length,
                                      (index) => Center(
                                        child: Text(
                                          reminderController
                                              .repeatdaysMonth[index],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                reminderController
                                                        .selectedRepeaseDayIndex
                                                        .value ==
                                                    index
                                                ? AppColors.textHeading
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
