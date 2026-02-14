import 'dart:convert';

class FreeQueryConfig {
  final int freeLimit;
  final int weekly;
  final int yearly;

  FreeQueryConfig({
    required this.freeLimit,
    required this.weekly,
    required this.yearly,
  });

  factory FreeQueryConfig.fromJson(Map<String, dynamic> json) {
    return FreeQueryConfig(
      freeLimit: json['free_plan'] ?? 0,

      weekly: json['weekly_plan'] ?? 0,
      yearly: json['yearly_plan'] ?? 0,
    );
  }

  static FreeQueryConfig fromString(String source) {
    final Map<String, dynamic> json = jsonDecode(source);
    return FreeQueryConfig.fromJson(json);
  }
}
