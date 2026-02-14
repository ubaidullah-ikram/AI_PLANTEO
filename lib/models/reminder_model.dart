// ============= REMINDER MODEL =============
import 'dart:convert';
import 'dart:typed_data';

class ReminderModel {
  final int id;
  final String plantName;
  final Uint8List image;
  final String reminderType;
  final String reminderIcon;
  final int hour;
  final int minute;
  final String period;
  final int repeatEvery;
  final String repeatUnit;
  final DateTime createdDate;
  final bool isActive;

  ReminderModel({
    required this.id,
    required this.plantName,
    required this.image,
    required this.reminderType,
    required this.reminderIcon,
    required this.hour,
    required this.minute,
    required this.period,
    required this.repeatEvery,
    required this.repeatUnit,
    required this.createdDate,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plantName': plantName,
      'image': base64Encode(image),
      'reminderType': reminderType,
      'reminderIcon': reminderIcon,
      'hour': hour,
      'minute': minute,
      'period': period,
      'repeatEvery': repeatEvery,
      'repeatUnit': repeatUnit,
      'createdDate': createdDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] as int,
      plantName: json['plantName'] as String,
      image: base64Decode(json['image']), // ✅ fix
      reminderType: json['reminderType'] as String,
      reminderIcon: json['reminderIcon'] as String,
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      period: json['period'] as String,
      repeatEvery: json['repeatEvery'] as int,
      repeatUnit: json['repeatUnit'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
