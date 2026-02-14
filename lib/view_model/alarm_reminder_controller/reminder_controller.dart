// import 'package:get/get.dart';
// import 'package:plantify/constant/app_icons.dart';

// class ReminderController extends GetxController {
//   final expandedReminder = true.obs;
//   final expanded_previous = true.obs;
//   final expandRepeatCard = true.obs;
//   final expand_timer_card = true.obs;
//   RxString selectedPlant = 'Watermeal'.obs;
//   RxInt selectedHour = 7.obs;
//   RxInt selectedMinute = 00.obs;
//   RxString period = "AM".obs;
//   final selectedItemIndex = 1.obs;
//   final selected_previous_index = 1.obs;
//   final selected_time_hours = 6.obs;
//   final selected_time_index = 0.obs;
//   final selected_time_minutes = 00.obs;
//   final selectedRepeaseIndex = 0.obs;
//   final selectedRepeaseDayIndex = 0.obs;
//   final repeatDays = 7.obs;
//   final selectedReminder = 'Select'.obs;
//   final selected_previous = 'Select'.obs;
//   final selectedRepeat = ''.obs;
//   final selectedIcon = AppIcons.misting.obs;
//   final repeatListDays = [1, 2, 3, 4, 5, 6, 7].obs;
//   final repeatdaysMonth = ["Days", "Weeks", "Monthly"].obs;
//   final previous_list = ["Today", "Yesterday", "1 weeek  ago"].obs;
//   final reminders = <RemindModel>[
//     RemindModel(image: AppIcons.misting, text: 'Misting'),
//     RemindModel(image: AppIcons.watering, text: 'Watering'),
//     RemindModel(image: AppIcons.rotating, text: 'Rotating'),
//   ].obs;
// }

// class RemindModel {
//   String text;
//   String image;
//   RemindModel({required this.image, required this.text});
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/models/reminder_model.dart';
import 'package:plantify/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============= REMINDER CONTROLLER =============
class ReminderController extends GetxController {
  // Storage key
  static const String _remindersKey = 'saved_reminders';

  // UI State
  final expandedReminder = true.obs;
  final expanded_previous = true.obs;
  final expandRepeatCard = true.obs;
  final expand_timer_card = true.obs;

  // Selected Values
  RxString selectedPlant = 'Select'.obs;
  RxInt selectedHour = 7.obs;
  RxInt selectedMinute = 0.obs;
  RxString period = "AM".obs;
  final selectedItemIndex = 1.obs;
  final selected_time_hours = 6.obs;
  final selectedRepeaseIndex = 0.obs;
  final selectedRepeaseDayIndex = 0.obs;
  final repeatDays = 7.obs;
  final selectedReminder = 'Select'.obs;
  Uint8List reminderImage = Uint8List(0);
  final selectedRepeat = ''.obs;
  final selectedIcon = AppIcons.misting.obs;

  // Lists
  final repeatListDays = [1, 2, 3, 4, 5, 6, 7].obs;
  final repeatdaysMonth = ["Days", "Weeks", "Monthly"].obs;
  final reminders = <RemindModel>[
    RemindModel(image: AppIcons.misting, text: 'Misting'),
    RemindModel(image: AppIcons.watering, text: 'Watering'),
    RemindModel(image: AppIcons.rotating, text: 'Rotating'),
  ].obs;

  // Reminders list
  RxList<ReminderModel> allReminders = <ReminderModel>[].obs;
  RxInt nextReminderId = 1.obs;

  // // SharedPreferences instance
  // late SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    _initStorage();
  }

  // ============= INITIALIZE STORAGE =============
  Future<void> _initStorage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      _prefs = await SharedPreferences.getInstance();
      await loadAllReminders();
      print('✅ Storage initialized');
    } catch (e) {
      print('❌ Error initializing storage: $e');
    }
  }

  // ============= SAVE REMINDER =============
  Future<void> saveReminder({bool isEdit = false, int? editId}) async {
    try {
      // Validate inputs
      if (selectedPlant.value.isEmpty ||
          selectedReminder.value == 'Select' ||
          selectedRepeat.value.isEmpty) {
        // Get.snackbar('Error', 'Please fill all required fields');
        return;
      }
      log('the id ${isEdit ? editId! : nextReminderId.value}');
      final reminder = ReminderModel(
        id: isEdit ? editId! : nextReminderId.value,
        plantName: selectedPlant.value,
        image: reminderImage,
        reminderType: selectedReminder.value,
        reminderIcon: selectedIcon.value,
        hour: selectedHour.value,
        minute: selectedMinute.value,
        period: period.value,
        repeatEvery: repeatDays.value,
        repeatUnit: repeatdaysMonth[selectedRepeaseDayIndex.value],
        createdDate: DateTime.now(),
        isActive: true,
      );

      // Save to storage
      await _saveReminderToStorage(reminder);

      // Schedule notification
      await _scheduleReminderNotification(reminder);

      if (!isEdit) {
        nextReminderId.value++;
      }

      Get.snackbar('Success', 'Reminder set successfully');
      resetForm();
    } catch (e) {
      Get.snackbar('Error', 'Failed to save reminder: $e');
      print('❌ Error saving reminder: $e');
    }
  }

  // ============= SCHEDULE NOTIFICATION =============
  Future<void> _scheduleReminderNotification(ReminderModel reminder) async {
    try {
      // Convert 12-hour to 24-hour format
      int hour24 = reminder.hour;
      if (reminder.period == 'PM' && reminder.hour != 12) {
        hour24 = reminder.hour + 12;
      } else if (reminder.period == 'AM' && reminder.hour == 12) {
        hour24 = 0;
      }

      // Create first notification time
      DateTime now = DateTime.now();
      DateTime scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        hour24,
        reminder.minute,
      );

      // If time has passed today, schedule for tomorrow
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(Duration(days: 1));
      }

      // TODO: Uncomment when you have NotificationService
      // await NotificationService.instance.scheduleReminderNotification(
      //   id: reminder.id,
      //   title: '🌱 ${reminder.plantName} - ${reminder.reminderType}',
      //   body: 'Time to ${reminder.reminderType.toLowerCase()} your plant!',
      //   hour: hour24,
      //   minute: reminder.minute,
      //   repeatEveryDays: reminder.repeatEvery,
      // );

      print('✅ Notification scheduled for ${reminder.plantName}');
    } catch (e) {
      print('❌ Error scheduling notification: $e');
    }
  }

  // ============= SAVE TO STORAGE =============
  Future<void> _saveReminderToStorage(ReminderModel reminder) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      // Get existing reminders
      List<ReminderModel> reminders = await _loadRemindersFromStorage();

      // Check if reminder already exists (for edit)
      int existingIndex = reminders.indexWhere((r) => r.id == reminder.id);

      if (existingIndex != -1) {
        // Update existing
        reminders[existingIndex] = reminder;
      } else {
        // Add new
        reminders.add(reminder);
      }

      // Save to SharedPreferences
      List<String> jsonList = reminders
          .map((r) => jsonEncode(r.toJson()))
          .toList();
      await _prefs.setStringList(_remindersKey, jsonList);

      // Update in-memory list
      allReminders.assignAll(reminders);

      print('💾 Reminder saved to storage: ${reminder.plantName}');
    } catch (e) {
      print('❌ Error saving to storage: $e');
      rethrow;
    }
  }

  // ============= LOAD FROM STORAGE =============
  Future<List<ReminderModel>> _loadRemindersFromStorage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      List<String>? jsonList = _prefs.getStringList(_remindersKey);

      if (jsonList == null || jsonList.isEmpty) {
        print('📂 No reminders found in storage');
        return [];
      }

      List<ReminderModel> reminders = jsonList
          .map((jsonString) => ReminderModel.fromJson(jsonDecode(jsonString)))
          .toList();

      print('📂 Loaded ${reminders.length} reminders from storage');
      return reminders;
    } catch (e) {
      print('❌ Error loading from storage: $e');
      return [];
    }
  }

  // ============= LOAD ALL REMINDERS =============
  Future<void> loadAllReminders() async {
    try {
      List<ReminderModel> reminders = await _loadRemindersFromStorage();
      allReminders.assignAll(reminders);

      // Calculate next ID
      if (reminders.isNotEmpty) {
        int maxId = reminders.map((r) => r.id).reduce((a, b) => a > b ? a : b);
        nextReminderId.value = maxId + 1;
      } else {
        nextReminderId.value = 1;
      }

      print('✅ All reminders loaded: ${reminders.length}');
    } catch (e) {
      print('❌ Error loading all reminders: $e');
    }
  }

  // ============= DELETE REMINDER =============
  Future<void> deleteReminder(int reminderId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      // Remove from list
      allReminders.removeWhere((r) => r.id == reminderId);

      // Update storage
      List<String> jsonList = allReminders
          .map((r) => jsonEncode(r.toJson()))
          .toList();
      await _prefs.setStringList(_remindersKey, jsonList);

      // TODO: Cancel notification
      // await NotificationService.instance.cancel(reminderId);

      print('🗑️ Reminder deleted: $reminderId');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete reminder: $e');
      print('❌ Error deleting reminder: $e');
    }
  }

  // ============= TOGGLE REMINDER =============
  Future<void> toggleReminder(int reminderId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      int index = allReminders.indexWhere((r) => r.id == reminderId);
      if (index != -1) {
        ReminderModel reminder = allReminders[index];
        ReminderModel updated = ReminderModel(
          id: reminder.id,
          plantName: reminder.plantName,
          image: reminder.image,
          reminderType: reminder.reminderType,
          reminderIcon: reminder.reminderIcon,
          hour: reminder.hour,
          minute: reminder.minute,
          period: reminder.period,
          repeatEvery: reminder.repeatEvery,
          repeatUnit: reminder.repeatUnit,
          createdDate: reminder.createdDate,
          isActive: !reminder.isActive,
        );
        allReminders[index] = updated;

        // Update storage
        List<String> jsonList = allReminders
            .map((r) => jsonEncode(r.toJson()))
            .toList();
        await _prefs.setStringList(_remindersKey, jsonList);
      }
    } catch (e) {
      print('❌ Error toggling reminder: $e');
    }
  }

  // ============= RESET FORM =============
  void resetForm() {
    selectedPlant.value = 'Select';
    selectedHour.value = 7;
    selectedMinute.value = 0;
    period.value = 'AM';
    selectedReminder.value = 'Select';
    repeatDays.value = 7;
    selectedRepeat.value = '';
    expandedReminder.value = true;
    expanded_previous.value = true;
    expandRepeatCard.value = true;
    expand_timer_card.value = true;
    selectedIcon.value = AppIcons.misting;
  }

  // ============= CLEAR ALL REMINDERS =============
  Future<void> clearAllReminders() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      await _prefs.remove(_remindersKey);
      allReminders.clear();
      nextReminderId.value = 1;
      print('🗑️ All reminders cleared');
    } catch (e) {
      print('❌ Error clearing reminders: $e');
    }
  }

  // ============= UTILITIES =============
  String getNextWateringDate() {
    DateTime next = DateTime.now();

    if (selectedRepeaseDayIndex.value == 0) {
      // Days
      next = next.add(Duration(days: repeatDays.value));
    } else if (selectedRepeaseDayIndex.value == 1) {
      // Weeks
      next = next.add(Duration(days: repeatDays.value * 7));
    } else {
      // Monthly
      next = DateTime(next.year, next.month + repeatDays.value, next.day);
    }

    return '${next.day.toString().padLeft(2, '0')}-${next.month.toString().padLeft(2, '0')}-${next.year}';
  }
}

class RemindModel {
  String text;
  String image;
  RemindModel({required this.image, required this.text});
}
