import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:plantify/constant/app_colors.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  String selectedPlant = 'Watermeal';
  String selectedReminder = 'Watering';
  int repeatDays = 7;
  String timeFormat = 'AM';
  String timeValue = '9:19';
  bool reminderEnabled = false;
  bool expandedReminder = true;
  bool isrepeating = false;
  List<String> reminders = ['Misting', 'Watering', 'Rotating'];
  var _selectedItemIndex = 1;
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
          'Set Reminder',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Remind Me About',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            expandedReminder = !expandedReminder;
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              selectedReminder,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textHeading,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!expandedReminder)
                    Container(
                      height: 100,
                      child: CupertinoPicker(
                        itemExtent: 40.0,
                        scrollController: FixedExtentScrollController(
                          initialItem: _selectedItemIndex,
                        ),
                        // backgroundColor: Color(0xffF3F3F3),
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            selectedReminder = reminders[index];
                            _selectedItemIndex = index;
                          });
                          print('Selected index: $index');
                        },
                        children: List<Widget>.generate(reminders.length, (
                          int index,
                        ) {
                          return Center(
                            child: Text(
                              reminders[index],
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }),
                      ),
                    ),
                  // Container(
                  //   height: 50,
                  //   child: CupertinoPicker(
                  //     backgroundColor: Colors.amber,
                  //     itemExtent: 1,
                  //     onSelectedItemChanged: (value) {},
                  //     children: [Text('data'), Text('data')],
                  //   ),
                  // ),
                  // if (expandedReminder) ...[
                  //   const SizedBox(height: 12),
                  //   Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey[100],
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: Column(
                  //       children: List.generate(
                  //         reminders.length,
                  //         (index) => GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               selectedReminder = reminders[index];
                  //               expandedReminder = false;
                  //             });
                  //           },
                  //           child: Container(
                  //             padding: const EdgeInsets.symmetric(
                  //               horizontal: 12,
                  //               vertical: 12,
                  //             ),
                  //             decoration: BoxDecoration(
                  //               color: selectedReminder == reminders[index]
                  //                   ? Colors.green[50]
                  //                   : Colors.transparent,
                  //             ),
                  //             child: Row(
                  //               children: [
                  //                 _getReminderIcon(reminders[index]),
                  //                 const SizedBox(width: 12),
                  //                 Text(
                  //                   reminders[index],
                  //                   style: TextStyle(
                  //                     fontSize: 15,
                  //                     color:
                  //                         selectedReminder == reminders[index]
                  //                         ? Colors.green
                  //                         : Colors.grey[700],
                  //                     fontWeight:
                  //                         selectedReminder == reminders[index]
                  //                         ? FontWeight.w600
                  //                         : FontWeight.w500,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Repeat Section
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Repeat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Every $repeatDays Days',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textHeading,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildRepeatButton('6', 6),
                      _buildRepeatButton('7', 7),
                      _buildRepeatButton('8', 8),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Days',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Time Selection
            _buildCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Time',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showTimePicker();
                        },
                        child: Text(
                          timeValue,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildTimeButton('AM'),
                      const SizedBox(width: 8),
                      _buildTimeButton('PM'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Previous Section
            _buildCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Previous',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Select',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Next Watering Date
            Text(
              'Next Watering: December 08, 2025',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Turn on Reminder Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    reminderEnabled = !reminderEnabled;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        reminderEnabled
                            ? 'Reminder activated!'
                            : 'Reminder disabled!',
                      ),
                      backgroundColor: reminderEnabled
                          ? Colors.green
                          : Colors.grey,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: reminderEnabled
                      ? Colors.green
                      : Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Turn on Reminder',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: reminderEnabled ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildRepeatButton(String label, int value) {
    bool isSelected = repeatDays == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          repeatDays = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? AppColors.textHeading : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
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

  Widget _getReminderIcon(String reminder) {
    if (reminder == 'Misting') {
      return const Text('💧', style: TextStyle(fontSize: 18));
    } else if (reminder == 'Watering') {
      return const Text('🚿', style: TextStyle(fontSize: 18));
    } else {
      return const Text('☀️', style: TextStyle(fontSize: 18));
    }
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
