class PlantIdentifierData {
  final String plantName;
  final String scientificName;
  final String description;
  final List<String> characteristics; // Tags like "carnivorous", "tropical"
  final List<String> carePoints; // Temperature, Sunlight, Watering, etc
  final String imagePath;
  final double confidence;

  PlantIdentifierData({
    required this.plantName,
    required this.scientificName,
    required this.description,
    required this.characteristics,
    required this.carePoints,
    required this.imagePath,
    required this.confidence,
  });

  factory PlantIdentifierData.fromJson(Map<String, dynamic> json) {
    return PlantIdentifierData(
      plantName: json['plant_name'] ?? 'Unknown Plant',
      scientificName: json['scientific_name'] ?? 'N/A',
      description: json['description'] ?? '',
      characteristics: List<String>.from(json['characteristics'] ?? []),
      carePoints: List<String>.from(json['care_points'] ?? []),
      imagePath: json['image_path'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }
}
