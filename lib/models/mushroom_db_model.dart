import 'dart:typed_data';

class SavedMushroomModel {
  final String mushroomName;
  final String scientificName;
  final String description;
  final String edibility;
  final List<String> characteristics;
  final List<String> habitat;
  final List<String> lookAlikes;
  final double confidence;
  final Uint8List image;

  SavedMushroomModel({
    required this.mushroomName,
    required this.scientificName,
    required this.description,
    required this.edibility,
    required this.characteristics,
    required this.habitat,
    required this.lookAlikes,
    required this.confidence,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
    'mushroomName': mushroomName,
    'scientificName': scientificName,
    'description': description,
    'edibility': edibility,
    'characteristics': characteristics,
    'habitat': habitat,
    'lookAlikes': lookAlikes,
    'confidence': confidence,
    'image': image.toList(), // ✅ VERY IMPORTANT
  };

  factory SavedMushroomModel.fromJson(Map<String, dynamic> json) {
    return SavedMushroomModel(
      mushroomName: json['mushroomName'],
      scientificName: json['scientificName'],
      description: json['description'],
      edibility: json['edibility'],
      characteristics: List<String>.from(json['characteristics']),
      habitat: List<String>.from(json['habitat']),
      lookAlikes: List<String>.from(json['lookAlikes']),
      confidence: (json['confidence'] as num).toDouble(),
      image: Uint8List.fromList(List<int>.from(json['image'])),
    );
  }
}
