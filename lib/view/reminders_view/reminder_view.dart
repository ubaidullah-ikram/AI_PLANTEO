// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:plantify/constant/app_colors.dart';
// import 'package:plantify/res/responsive_config/responsive_config.dart';
// import 'package:plantify/services/notification_service.dart';
// import 'package:plantify/view/reminders_view/widgets/prevoius_card_widget.dart';

// import 'package:plantify/view/reminders_view/widgets/remind_me_about.dart';
// import 'package:plantify/view/reminders_view/widgets/repeat_reminder_widget.dart';
// import 'package:plantify/view/reminders_view/widgets/time_selection.dart';
// import 'package:plantify/view_model/alarm_reminder_controller/reminder_controller.dart';

// class ReminderScreen extends StatefulWidget {
//   bool isfromEdit;
//   ReminderScreen({Key? key, required this.isfromEdit}) : super(key: key);

//   @override
//   State<ReminderScreen> createState() => _ReminderScreenState();
// }

// class _ReminderScreenState extends State<ReminderScreen> {
//   // String timeFormat = 'AM';
//   // String timeValue = '07:00';
//   bool reminderEnabled = false;
//   bool isrepeating = false;
//   var controller = Get.put(ReminderController());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffF9F9F9),
//       appBar: AppBar(
//         backgroundColor: Color(0xffF9F9F9),
//         surfaceTintColor: Color(0xffF9F9F9),
//         elevation: 0,
//         centerTitle: false,
//         // leading: IconButton(
//         //   icon: const Icon(Icons.arrow_back, color: Colors.green),
//         //   onPressed: () {},
//         // ),
//         title: Text(
//           widget.isfromEdit ? 'Edit Reminder' : 'Set Reminder',
//           style: TextStyle(
//             color: Colors.green,
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Plant Selection
//                   // MyPickerPage(),
//                   _buildCard(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Plant',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Obx(
//                           () => Text(
//                             controller.selectedPlant.value,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: AppColors.textHeading,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Remind Me About Section
//                   RemindMeAboutWidget(),
//                   const SizedBox(height: 12),

//                   // Repeat Section
//                   RepeatReminderWidget(),
//                   const SizedBox(height: 12),

//                   // Time Selection
//                   CustomTimePicker(),

//                   const SizedBox(height: 12),

//                   SizedBox(height: SizeConfig.h(20)),
//                   // Next Watering Date
//                 ],
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Next Watering: ',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: AppColors.textHeading,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         'December 08, 2025',
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),

//                   // Turn on Reminder Button
//                   GestureDetector(
//                     onTap: () async {
//                       if (widget.isfromEdit) {
//                         // Turn Off Reminder Logic
//                         // Navigator.pop(context);
//                       } else {
//                         // Turn On Reminder Logic
//                         setState(() {
//                           reminderEnabled = true;
//                         });
//                         log(
//                           'the selected plant name is ${controller.selectedPlant.value}',
//                         );
//                         log(
//                           'reminder for ${controller.selectedReminder.value}',
//                         );
//                         log('repeat every ${controller.repeatDays.value} days');
//                         log(
//                           'time is ${controller.selectedHour.value}:${controller.selectedMinute.value}',
//                         );
//                         // Navigator.pop(context);
//                       }
//                       // await NotificationService.instance.showTestNotification();

//                       // await NotificationService.instance.scheduleNotification(
//                       //   id: 1,
//                       //   title: '🌱 Test Reminder',
//                       //   body: 'Notification working successfully',
//                       //   minutesFromNow: 1, // Kam se kam 5 minute
//                       // );

//                       // final pending = await NotificationService.instance
//                       //     .getPendingNotifications();
//                       // print('Total pending: ${pending.length}');
//                     },
//                     child: Container(
//                       height: 55,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         border: widget.isfromEdit
//                             ? Border.all(color: AppColors.themeColor)
//                             : null,
//                         borderRadius: BorderRadius.circular(16),
//                         color: widget.isfromEdit
//                             ? Colors.transparent
//                             : AppColors.themeColor,
//                       ),
//                       child: Center(
//                         child: Text(
//                           widget.isfromEdit
//                               ? "Turn Off Reminder"
//                               : 'Turn on Reminder',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                             color: widget.isfromEdit
//                                 ? Colors.red
//                                 : Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCard({required Widget child}) {
//     return Container(
//       // height: 64,
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Color(0xffE0E0E0)!, width: 1),
//       ),
//       child: child,
//     );
//   }

//   DateTime safeDateTime(DateTime selected) {
//     final now = DateTime.now();
//     if (selected.isBefore(now)) {
//       return selected.add(const Duration(days: 1));
//     }
//     return selected;
//   }
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:plantify/services/notification_service.dart';
import 'package:plantify/view/reminders_view/widgets/plants_view_for_reminder.dart';
import 'package:plantify/view/reminders_view/widgets/remind_me_about.dart';
import 'package:plantify/view/reminders_view/widgets/repeat_reminder_widget.dart';
import 'package:plantify/view/reminders_view/widgets/time_selection.dart';
import 'package:plantify/view_model/alarm_reminder_controller/reminder_controller.dart';

class ReminderScreen extends StatefulWidget {
  bool isfromEdit;
  bool isfromSavedPlant;
  int? editReminderId;

  ReminderScreen({
    Key? key,
    required this.isfromEdit,
    this.isfromSavedPlant = false,
    this.editReminderId,
  }) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool reminderEnabled = false;

  var controller = Get.find<ReminderController>();

  @override
  void initState() {
    super.initState();

    // If editing, load existing reminder data
    if (widget.isfromEdit && widget.editReminderId != null) {
      _loadReminderForEdit(widget.editReminderId!);
    }

    WidgetsBinding.instance.addPostFrameCallback((s) {
      if (widget.isfromSavedPlant) {
        // controller.selectedPlant.value = 'Select';
      } else {
        controller.selectedPlant.value = 'Select';
      }
    });
  }

  void _loadReminderForEdit(int reminderId) {
    try {
      final reminder = controller.allReminders.firstWhere(
        (r) => r.id == reminderId,
      );

      controller.selectedPlant.value = reminder.plantName;
      controller.selectedReminder.value = reminder.reminderType;
      controller.selectedIcon.value = reminder.reminderIcon;
      controller.selectedHour.value = reminder.hour;
      controller.selectedMinute.value = reminder.minute;
      controller.period.value = reminder.period;
      controller.repeatDays.value = reminder.repeatEvery;

      // Set repeat unit index
      controller.selectedRepeaseDayIndex.value = controller.repeatdaysMonth
          .indexOf(reminder.repeatUnit);
    } catch (e) {
      log('Error loading reminder for edit: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Color(0xffF9F9F9),
        surfaceTintColor: Color(0xffF9F9F9),
        elevation: 0,
        centerTitle: false,
        title: Text(
          widget.isfromEdit ? 'Edit Reminder' : 'Set Reminder',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plant Selection
                  _buildCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Plant',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Obx(
                          () => GestureDetector(
                            onTap: () {
                              Get.to(() => PlantsViewForReminder());
                            },
                            child: Text(
                              controller.selectedPlant.value,
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    controller.selectedPlant.value == 'Select'
                                    ? Colors.grey
                                    : AppColors.textHeading,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Remind Me About
                  RemindMeAboutWidget(),
                  const SizedBox(height: 12),

                  // Repeat
                  RepeatReminderWidget(),
                  const SizedBox(height: 12),

                  // Time
                  CustomTimePicker(),
                  const SizedBox(height: 12),

                  SizedBox(height: SizeConfig.h(20)),
                ],
              ),
            ),
          ),

          // Bottom Action
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Next Watering Date
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next Watering: ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textHeading,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          controller.getNextWateringDate(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Action Button
                  GestureDetector(
                    onTap: () async {
                      if (widget.isfromEdit) {
                        // Update Reminder
                        await _updateReminder();
                      } else {
                        // Create New Reminder
                        await _createReminder();
                      }
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: widget.isfromEdit
                            ? Border.all(color: AppColors.themeColor)
                            : null,
                        borderRadius: BorderRadius.circular(16),
                        color: widget.isfromEdit
                            ? Colors.transparent
                            : AppColors.themeColor,
                      ),
                      child: Center(
                        child: Text(
                          widget.isfromEdit
                              ? "Update Reminder"
                              : 'Turn on Reminder',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: widget.isfromEdit
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Delete Button (only for edit)
                  if (widget.isfromEdit)
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => _deleteReminder(),
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                "Delete Reminder",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red,
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
          ),
        ],
      ),
    );
  }

  // ============= SAVE REMINDER =============
  Future<void> _createReminder() async {
    try {
      // controller.clearAllReminders();
      // return;
      if (controller.selectedReminder.value == 'Select' ||
          controller.selectedRepeat.value.isEmpty) {
        Get.snackbar('Error', 'Please fill all required fields');
        return;
      }

      log('Plant: ${controller.selectedPlant.value}');
      log('Reminder: ${controller.selectedReminder.value}');
      log(
        'Time: ${controller.selectedHour.value}:${controller.selectedMinute.value}',
      );
      log('Repeat: Every ${controller.repeatDays.value} days');

      // Save reminder using controller

      // Schedule notification
      // await NotificationService.instance.scheduleNotification(
      //   id: 999,
      //   title: 'Test',
      //   body: 'Should appear in 1 minute',
      //   minutesFromNow: 1, // 1 minute baad
      // );
      await NotificationService.instance.scheduleReminderNotification(
        id: controller.nextReminderId.value,
        title:
            '🌱 ${controller.selectedPlant.value} - ${controller.selectedReminder.value}',
        body:
            'Time to ${controller.selectedReminder.value.toLowerCase()} your plant!',
        hour: controller.selectedHour.value,
        minute: controller.selectedMinute.value,
        repeatEveryDays: controller.repeatDays.value,
      );
      await controller.saveReminder();
      Get.back();
      Get.snackbar('Success', 'Reminder set successfully!');
    } catch (e) {
      log('Error creating reminder: $e');
      Get.snackbar('Error', 'Failed to set reminder: $e');
    }
  }

  // ============= UPDATE REMINDER =============
  Future<void> _updateReminder() async {
    try {
      if (widget.editReminderId == null) return;

      await controller.saveReminder(
        isEdit: true,
        editId: widget.editReminderId,
      );

      // Re-schedule notification
      await NotificationService.instance.cancel(widget.editReminderId!);

      await NotificationService.instance.scheduleReminderNotification(
        id: widget.editReminderId!,
        title:
            '🌱 ${controller.selectedPlant.value} - ${controller.selectedReminder.value}',
        body:
            'Time to ${controller.selectedReminder.value.toLowerCase()} your plant!',
        hour: controller.selectedHour.value,
        minute: controller.selectedMinute.value,
        repeatEveryDays: controller.repeatDays.value,
      );

      Get.back();
      Get.snackbar('Success', 'Reminder updated!');
    } catch (e) {
      log('Error updating reminder: $e');
      Get.snackbar('Error', 'Failed to update reminder');
    }
  }

  // ============= DELETE REMINDER =============
  Future<void> _deleteReminder() async {
    try {
      if (widget.editReminderId == null) return;

      await controller.deleteReminder(widget.editReminderId!);
      await NotificationService.instance.cancel(widget.editReminderId!);

      Get.back();
    } catch (e) {
      log('Error deleting reminder: $e');
      Get.snackbar('Error', 'Failed to delete reminder');
    }
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xffE0E0E0), width: 1),
      ),
      child: child,
    );
  }
}
