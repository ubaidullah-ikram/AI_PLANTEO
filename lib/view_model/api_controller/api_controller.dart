import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer' as dev;

import 'package:plantify/services/remote_config_service.dart';

// ============ Models ============

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

// ============ Main Controller ============

class ApiToolController extends GetxController {
  // RxVariables
  final isLoading = false.obs;
  final diagnosisData = Rxn<DiagnosisData>();
  final errorMessage = ''.obs;
  final selectedImagePath = ''.obs;

  // API Config
  static String GEMINI_API_KEY = RemoteConfigService().api_key_gemini;
  static const String GEMINI_BASE_URL =
      'https://generativelanguage.googleapis.com/v1/models';

  // ============ Main Diagnosis Function ============

  Future<void> diagnosePlant({
    required String imagePath,
    String? additionalNotes,
    String? plantLocation,
    String? wateringFrequency,
    String? lightCondition,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate image
      if (!File(imagePath).existsSync()) {
        throw Exception('Image file not found');
      }

      // Convert image to Base64
      final imageBase64 = await _imageToBase64(imagePath);
      selectedImagePath.value = imagePath;

      dev.log('🌿 Starting Plant Diagnosis...');
      dev.log('📸 Image converted to Base64');

      // Call Gemini API
      final response = await _callGeminiAPI(
        imageBase64: imageBase64,
        additionalNotes: additionalNotes,
        plantLocation: plantLocation,
        wateringFrequency: wateringFrequency,
        lightCondition: lightCondition,
      );

      dev.log('✅ API Response received');

      // Parse response
      final parsedData = DiagnosisData.fromJson(response);
      final finalData = DiagnosisData(
        plantName: parsedData.plantName,
        scientificName: parsedData.scientificName,
        disease: parsedData.disease,
        description: parsedData.description,
        treatments: parsedData.treatments,
        commonProblems: parsedData.commonProblems,
        careTips: parsedData.careTips,
        imagePath: imagePath,
        confidence: parsedData.confidence,
      );

      diagnosisData.value = finalData;
      dev.log('✅ Diagnosis Data Set Successfully');
      isLoading.value = false;

      Fluttertoast.showToast(
        msg: 'Plant identified successfully!',
        toastLength: Toast.LENGTH_SHORT,
      );
    } on TimeoutException catch (e) {
      isLoading.value = false;
      errorMessage.value =
          'Request timeout. Please check your internet connection';
      dev.log('⏱️ Timeout Error: ${e.toString()}');
      Fluttertoast.showToast(
        msg: 'Request timeout. Please try again',
        toastLength: Toast.LENGTH_LONG,
      );
    } on SocketException catch (e) {
      isLoading.value = false;
      errorMessage.value = 'No internet connection';
      dev.log('🌐 Network Error: ${e.toString()}');
      Fluttertoast.showToast(
        msg: 'No internet connection. Please check and try again',
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      dev.log('❌ Error in diagnosePlant: $e');
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
  }

  // ============ Gemini HTTP API Call ============

  Future<Map<String, dynamic>> _callGeminiAPI({
    required String imageBase64,
    String? additionalNotes,
    String? plantLocation,
    String? wateringFrequency,
    String? lightCondition,
  }) async {
    try {
      // Build prompt
      final prompt = _buildDiagnosisPrompt(
        additionalNotes: additionalNotes,
        plantLocation: plantLocation,
        wateringFrequency: wateringFrequency,
        lightCondition: lightCondition,
      );

      // Prepare request body - exactly like math solver
      final List<Map<String, dynamic>> parts = [
        {'text': prompt},
        {
          'inlineData': {'mimeType': 'image/jpeg', 'data': imageBase64},
        },
      ];

      final requestBody = {
        'contents': [
          {'parts': parts},
        ],
      };

      // Make HTTP request
      final url = Uri.parse(
        '$GEMINI_BASE_URL/gemini-1.5-flash:generateContent?key=$GEMINI_API_KEY',
      );

      dev.log('🔗 API URL: ${url.toString()}');
      dev.log('📤 Sending request to Gemini API...');

      // Request with 100 second timeout
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 100),
            onTimeout: () {
              throw TimeoutException('Request took too long');
            },
          );

      dev.log('📥 Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        dev.log('✅ Request successful');

        // Extract text from response
        final text =
            responseData['candidates']?[0]?['content']?['parts']?[0]?['text'];

        if (text == null || text.isEmpty) {
          throw Exception('No response text from API');
        }

        dev.log('📝 Raw Response: $text');

        // Parse JSON from response
        final parsedJson = _parseJsonResponse(text);
        return parsedJson;
      } else {
        dev.log('❌ Error Response: ${response.body}');
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      dev.log('❌ Error in _callGeminiAPI: ${e.toString()}');
      rethrow;
    }
  }

  // ============ Build Diagnosis Prompt ============

  String _buildDiagnosisPrompt({
    String? additionalNotes,
    String? plantLocation,
    String? wateringFrequency,
    String? lightCondition,
  }) {
    return '''
Analyze this plant image and provide detailed diagnosis. Respond ONLY with valid JSON (no markdown, no extra text):

{
  "plant_name": "Common plant name (in English)",
  "scientific_name": "Scientific name",
  "disease": "Main disease/problem detected or 'Healthy'",
  "description": "Brief description of plant condition (1-2 sentences)",
  "treatments": [
    "Treatment step 1",
    "Treatment step 2",
    "Treatment step 3",
    "Treatment step 4"
  ],
  "common_problems": [
    "Common problem 1",
    "Common problem 2",
    "Common problem 3"
  ],
  "care_tips": [
    "Care tip 1",
    "Care tip 2",
    "Care tip 3",
    "Care tip 4"
  ],
  "confidence": 0.85
}

${additionalNotes != null ? 'User notes: $additionalNotes' : ''}
${plantLocation != null ? '\nLocation: $plantLocation' : ''}
${wateringFrequency != null ? '\nWatering frequency: $wateringFrequency' : ''}
${lightCondition != null ? '\nLight condition: $lightCondition' : ''}

IMPORTANT: Return ONLY valid JSON, nothing else. No markdown, no backticks, no explanations.
''';
  }

  // ============ Parse JSON Response ============

  Map<String, dynamic> _parseJsonResponse(String responseText) {
    try {
      // Remove markdown code blocks
      String cleaned = responseText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      // Find JSON object in text
      final regExp = RegExp(r'\{[\s\S]*\}', multiLine: true);
      final match = regExp.firstMatch(cleaned);

      if (match != null) {
        final jsonStr = match.group(0)!;
        dev.log('📋 Extracted JSON: $jsonStr');
        final parsed = jsonDecode(jsonStr);
        return parsed;
      }

      dev.log('❌ No JSON found in response: $cleaned');
      throw FormatException('Invalid JSON format in response');
    } catch (e) {
      dev.log('❌ JSON Parse Error: ${e.toString()}');
      throw Exception('Failed to parse JSON: $e');
    }
  }

  // ============ Image to Base64 ============

  Future<String> _imageToBase64(String imagePath) async {
    try {
      final imageBytes = await File(imagePath).readAsBytes();
      final base64String = base64Encode(imageBytes);
      dev.log('✅ Image Base64 conversion successful');
      return base64String;
    } catch (e) {
      dev.log('❌ Image conversion error: ${e.toString()}');
      throw Exception('Image conversion failed: $e');
    }
  }

  // ============ Clear Data ============

  void clearDiagnosis() {
    diagnosisData.value = null;
    selectedImagePath.value = '';
    errorMessage.value = '';
    dev.log('🗑️ Diagnosis data cleared');
  }

  // ============ Get Current Data ============

  DiagnosisData? getDiagnosisData() => diagnosisData.value;
}
