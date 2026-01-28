import 'dart:typed_data';

class SavedPlantModel {
  final String plantName;
  final String scientificName;
  final String description;
  final List<String> characteristics;
  final List<String> carePoints;
  final double confidence;
  final Uint8List image;

  SavedPlantModel({
    required this.plantName,
    required this.scientificName,
    required this.description,
    required this.characteristics,
    required this.carePoints,
    required this.confidence,
    required this.image,
  });

  Map<String, dynamic> toJson() => {
    'plantName': plantName,
    'scientificName': scientificName,
    'description': description,
    'characteristics': characteristics,
    'carePoints': carePoints,
    'confidence': confidence,
    'image': image.toList(),
  };

  factory SavedPlantModel.fromJson(Map<String, dynamic> json) {
    return SavedPlantModel(
      plantName: json['plantName'],
      scientificName: json['scientificName'],
      description: json['description'],
      characteristics: List<String>.from(json['characteristics']),
      carePoints: List<String>.from(json['carePoints']),
      confidence: json['confidence'],
      image: Uint8List.fromList(List<int>.from(json['image'])),
    );
  }
}
