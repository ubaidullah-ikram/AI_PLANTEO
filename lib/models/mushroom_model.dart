class MushroomIdentificationData {
  final String mushroomName;
  final String scientificName;
  final String edibility; // Edible, Poisonous, Inedible
  final String description;
  final List<String> characteristics;
  final List<String> habitat;
  final List<String> lookAlikes;
  final String imagePath;
  final double confidence;
  final bool isIdentified;

  MushroomIdentificationData({
    required this.mushroomName,
    required this.scientificName,
    required this.edibility,
    required this.description,
    required this.characteristics,
    required this.habitat,
    required this.lookAlikes,
    required this.imagePath,
    required this.confidence,
    required this.isIdentified,
  });

  factory MushroomIdentificationData.fromJson(Map<String, dynamic> json) {
    return MushroomIdentificationData(
      mushroomName: json['mushroom_name'] ?? 'Unknown Mushroom',
      scientificName: json['scientific_name'] ?? 'N/A',
      edibility: json['edibility'] ?? 'Unknown',
      description: json['description'] ?? '',
      characteristics: List<String>.from(json['characteristics'] ?? []),
      habitat: List<String>.from(json['habitat'] ?? []),
      lookAlikes: List<String>.from(json['look_alikes'] ?? []),
      imagePath: json['image_path'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      isIdentified: json['is_identified'] ?? false,
    );
  }

  factory MushroomIdentificationData.notIdentified({
    required String imagePath,
  }) {
    return MushroomIdentificationData(
      mushroomName: 'No Mushroom Detected',
      scientificName: 'N/A',
      edibility: 'Unknown',
      description: 'No mushroom could be identified in this image.',
      characteristics: [],
      habitat: [],
      lookAlikes: [],
      imagePath: imagePath,
      confidence: 0.0,
      isIdentified: false,
    );
  }
}
