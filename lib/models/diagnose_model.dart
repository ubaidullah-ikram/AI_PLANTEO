class DiagnosisData {
  final String plantName;
  final String scientificName;
  final String disease;
  final String description;
  final List<String> treatments;
  final List<String> commonProblems;
  final List<String> careTips;
  final String imagePath;
  final double confidence;

  DiagnosisData({
    required this.plantName,
    required this.scientificName,
    required this.disease,
    required this.description,
    required this.treatments,
    required this.commonProblems,
    required this.careTips,
    required this.imagePath,
    required this.confidence,
  });

  factory DiagnosisData.fromJson(Map<String, dynamic> json) {
    return DiagnosisData(
      plantName: json['plant_name'] ?? 'Unknown Plant',
      scientificName: json['scientific_name'] ?? 'N/A',
      disease: json['disease'] ?? 'Healthy Plant',
      description: json['description'] ?? '',
      treatments: List<String>.from(json['treatments'] ?? []),
      commonProblems: List<String>.from(json['common_problems'] ?? []),
      careTips: List<String>.from(json['care_tips'] ?? []),
      imagePath: json['image_path'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }
}

// ============ Plant Environmental Data Model ============

class PlantEnvironmentData {
  final String wateringFrequency;
  final String lightCondition;
  final String humidity;
  final String temperature;
  final String? additionalNotes;

  PlantEnvironmentData({
    required this.wateringFrequency,
    required this.lightCondition,
    required this.humidity,
    required this.temperature,
    this.additionalNotes,
  });
}
