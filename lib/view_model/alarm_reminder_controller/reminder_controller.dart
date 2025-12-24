import 'package:get/get.dart';
import 'package:plantify/constant/app_icons.dart';

class ReminderController extends GetxController {
  final expandedReminder = true.obs;
  final expanded_previous = true.obs;
  final expandRepeatCard = true.obs;
  final expand_timer_card = true.obs;
  RxInt selectedHour = 7.obs;
  RxInt selectedMinute = 00.obs;
  RxString period = "AM".obs;
  final selectedItemIndex = 1.obs;
  final selected_previous_index = 1.obs;
  final selected_time_hours = 6.obs;
  final selected_time_index = 0.obs;
  final selected_time_minutes = 00.obs;
  final selectedRepeaseIndex = 0.obs;
  final selectedRepeaseDayIndex = 0.obs;
  final repeatDays = 7.obs;
  final selectedReminder = 'Select'.obs;
  final selected_previous = 'Select'.obs;
  final selectedRepeat = ''.obs;
  final selectedIcon = AppIcons.misting.obs;
  final repeatListDays = [1, 2, 3, 4, 5, 6, 7].obs;
  final repeatdaysMonth = ["Days", "Weeks", "Monthly"].obs;
  final previous_list = ["Today", "Yesterday", "1 weeek  ago"].obs;
  final reminders = <RemindModel>[
    RemindModel(image: AppIcons.misting, text: 'Misting'),
    RemindModel(image: AppIcons.watering, text: 'Watering'),
    RemindModel(image: AppIcons.rotating, text: 'Rotating'),
  ].obs;
}

class RemindModel {
  String text;
  String image;
  RemindModel({required this.image, required this.text});
}
