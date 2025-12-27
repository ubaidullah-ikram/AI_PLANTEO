import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_fonts.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/view/reminders_view/reminder_view.dart';
import 'package:svg_flutter/svg.dart';

class PlantBottomSheetWidget extends StatefulWidget {
  const PlantBottomSheetWidget({super.key});

  @override
  State<PlantBottomSheetWidget> createState() => _PlantBottomSheetWidgetState();
}

class _PlantBottomSheetWidgetState extends State<PlantBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

            _buttonWidget(
              onTap: () {
                // Navigator.pop(context);

                Get.back();
                showModalBottomSheet(
                  backgroundColor: Color(0xffF9F9F9),
                  context: context,
                  builder: (_) => _renameBottomSheet(),
                );
              },
              icon: AppIcons.edit_icon,
              text: 'Rename',
            ),
            SizedBox(height: 8),
            _buttonWidget(
              onTap: () {
                Get.back();
                Get.to(() => ReminderScreen(isfromEdit: false));
              },
              icon: AppIcons.alarm_icon,
              text: 'Add Reminder',
            ),
            SizedBox(height: 8),

            _buttonWidget(
              onTap: () {
                Get.back();
                showDialog(
                  context: context,
                  builder: (context) {
                    return _deleteAlert();
                  },
                );
              },
              icon: AppIcons.delete_icon,
              text: 'Remove',
              isRemove: true,
            ),
            SizedBox(height: 8),
            Container(
              height: 62,
              width: double.infinity,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cancel',
                      style: TextStyle(
                        // fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buttonWidget({
    required Function() onTap,
    required String icon,
    required String text,
    bool? isRemove,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xffE0E0E0)),
        ),
        height: 62,
        width: double.infinity,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(icon),
              SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isRemove != null ? Colors.red : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renameBottomSheet() {
    return Container(
      width: double.infinity,
      height: 290,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 14),
            Text(
              'Give Name To Your Plant',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.sfPro,
              ),
            ),
            SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xffE0E0E0)),
              ),
              height: 62,
              width: double.infinity,
              child: Center(
                child: TextFormField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 18),
                    border: InputBorder.none,
                    hintText: 'Write here',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: AppColors.themeColor,
                borderRadius: BorderRadius.circular(16),
                // border: Border.all(color: Color(0xffE0E0E0)),
              ),
              height: 55,
              width: double.infinity,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
                // Navigator.pop(context);
              },
              child: SizedBox(
                height: 62,
                width: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cancel',
                        style: TextStyle(
                          // fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _deleteAlert() {
    return Dialog(
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            SizedBox(height: 15),
            Text(
              'Remove',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Are you sure you want to delete this permanently",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: AppFonts.sfPro, fontSize: 14),
            ),
            SizedBox(height: 14),
            Container(
              height: 55,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.themeColor,
                borderRadius: BorderRadius.circular(16),
              ),
              width: double.infinity,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Delete',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: SizedBox(
                height: 55,
                width: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cancel',
                        style: TextStyle(
                          // fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
