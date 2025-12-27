import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:plantify/view/reminders_view/widgets/prevoius_card_widget.dart';

import 'package:plantify/view/reminders_view/widgets/remind_me_about.dart';
import 'package:plantify/view/reminders_view/widgets/repeat_reminder_widget.dart';
import 'package:plantify/view/reminders_view/widgets/time_selection.dart';

class ReminderScreen extends StatefulWidget {
  bool isfromEdit;
  ReminderScreen({Key? key, required this.isfromEdit}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  String selectedPlant = 'Watermeal';

  String timeFormat = 'AM';
  String timeValue = '9:19';
  bool reminderEnabled = false;
  bool isrepeating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Color(0xffF9F9F9),
        surfaceTintColor: Color(0xffF9F9F9),
        elevation: 0,
        centerTitle: false,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.green),
        //   onPressed: () {},
        // ),
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
                  // MyPickerPage(),
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
                        Text(
                          selectedPlant,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textHeading,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Remind Me About Section
                  RemindMeAboutWidget(),
                  const SizedBox(height: 12),

                  // Repeat Section
                  RepeatReminderWidget(),
                  const SizedBox(height: 12),

                  // Time Selection
                  CustomTimePicker(),

                  const SizedBox(height: 12),

                  // Previous Section
                  PreviousCardWidget(), const SizedBox(height: 20),
                  SizedBox(height: SizeConfig.h(20)),
                  // Next Watering Date
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
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
                        'December 08, 2025',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Turn on Reminder Button
                  Container(
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
                            ? "Turn Off Reminder"
                            : 'Turn on Reminder',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: widget.isfromEdit ? Colors.red : Colors.white,
                          // color: reminderEnabled ? Colors.white : Colors.grey[600],
                        ),
                      ),
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

  Widget _buildCard({required Widget child}) {
    return Container(
      // height: 64,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xffE0E0E0)!, width: 1),
      ),
      child: child,
    );
  }

  Widget _buildTimeButton(String period) {
    bool isSelected = timeFormat == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          timeFormat = period;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          period,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.green : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((
      picked,
    ) {
      if (picked != null) {
        setState(() {
          timeValue = picked.format(context);
        });
      }
    });
  }
}
