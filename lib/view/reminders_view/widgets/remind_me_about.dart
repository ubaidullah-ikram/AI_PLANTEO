import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/view_model/alarm_reminder_controller/reminder_controller.dart';
import 'package:svg_flutter/svg_flutter.dart';

class RemindMeAboutWidget extends StatefulWidget {
  const RemindMeAboutWidget({super.key});

  @override
  State<RemindMeAboutWidget> createState() => _RemindMeAboutWidgetState();
}

class _RemindMeAboutWidgetState extends State<RemindMeAboutWidget> {
  var reminderController = Get.put(ReminderController());
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 64,
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
              const Text(
                'Remind Me About',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              GestureDetector(
                onTap: () {
                  reminderController.expandedReminder.value =
                      !reminderController.expandedReminder.value;
                },
                child: Row(
                  children: [
                    Obx(
                      () =>
                          reminderController.selectedReminder.value == "Select"
                          ? Container()
                          : SvgPicture.asset(
                              reminderController.selectedIcon.value,
                              height: 18,
                              color: AppColors.themeColor,
                            ),
                    ),
                    SizedBox(width: 8),
                    Obx(
                      () => Text(
                        reminderController.selectedReminder.value,
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              reminderController.selectedReminder.value ==
                                  "Select"
                              ? Colors.grey
                              : AppColors.textHeading,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Obx(
            () => reminderController.expandedReminder.value == false
                ? Container(
                    height: 110,
                    child: CupertinoPicker(
                      itemExtent: 40.0,
                      scrollController: FixedExtentScrollController(
                        initialItem: reminderController.selectedItemIndex.value,
                      ),
                      // backgroundColor: Color(0xffF3F3F3),
                      onSelectedItemChanged: (int index) {
                        reminderController.selectedReminder.value =
                            reminderController.reminders[index].text;

                        reminderController.selectedItemIndex.value = index;
                        reminderController.selectedIcon.value =
                            reminderController.reminders[index].image;

                        print('Selected index: $index');
                      },
                      children: List<Widget>.generate(
                        reminderController.reminders.length,
                        (int index) {
                          return Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  reminderController.reminders[index].image,
                                  color:
                                      reminderController
                                              .selectedItemIndex
                                              .value ==
                                          index
                                      ? AppColors
                                            .textHeading // center item color
                                      : Colors.black,
                                  height:
                                      reminderController
                                              .selectedItemIndex
                                              .value ==
                                          index
                                      ? 18
                                      : 17,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  reminderController.reminders[index].text,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        reminderController
                                                .selectedItemIndex
                                                .value ==
                                            index
                                        ? AppColors
                                              .textHeading // center item color
                                        : Colors.grey,
                                  ), // side items),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : SizedBox.fromSize(),
          ),
        ],
      ),
    );
  }
}
