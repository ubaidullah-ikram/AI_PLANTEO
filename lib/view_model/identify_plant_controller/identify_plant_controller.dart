import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantify/models/plant_idenfier_model.dart';
import 'dart:developer' as dev;

import 'package:plantify/services/remote_config_service.dart';
import 'package:plantify/view/identify_plant_view/identify_plant_result_sc.dart';

// ============ Plant Identifier Controller ============

class PlantIdentifierController extends GetxController {
  // RxVariables
  final isLoading = false.obs;
  final identifierData = Rxn<PlantIdentifierData>();
  final errorMessage = ''.obs;
  final selectedImagePath = ''.obs;

  // API Config
  static String GEMINI_API_KEY = RemoteConfigService().api_key_gemini;
  static const String GEMINI_BASE_URL =
      'https://generativelanguage.googleapis.com/v1/models';

  @override
  void onClose() {
    dev.log('🔒 PlantIdentifierController - onClose called');
    super.onClose();
  }

  // ============ Main Identifier Function ============

  Future<void> identifyPlant({required String imagePath}) async {
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

      dev.log('🌿 Starting Plant Identification...');
      dev.log('📸 Image converted to Base64');

      // Navigate to loading screen
      // Get.to(
      //   () => DiagnosePlantScreen(isfromHome: false, isfromIdentify: false),
      // );
      // Call Gemini API
      final response = await _callGeminiAPI(imageBase64: imageBase64);

      dev.log('✅ API Response received');

      // Parse response
      final parsedData = PlantIdentifierData.fromJson(response);
      final finalData = PlantIdentifierData(
        plantName: parsedData.plantName,
        scientificName: parsedData.scientificName,
        description: parsedData.description,
        characteristics: parsedData.characteristics,
        carePoints: parsedData.carePoints,
        imagePath: imagePath,
        confidence: parsedData.confidence,
      );

      // Set data BEFORE navigating
      identifierData.value = finalData;
      dev.log('✅ Plant Identifier Data Set Successfully');
      isLoading.value = false;

      // Navigate to result screen
      Get.off(() => PlantIdentifierResultScreen());

      Fluttertoast.showToast(
        msg: 'Plant identified successfully!',
        toastLength: Toast.LENGTH_SHORT,
      );
    } on TimeoutException catch (e) {
      isLoading.value = false;
      errorMessage.value =
          'Request timeout. Please check your internet connection';
      dev.log('⏱️ Timeout Error: ${e.toString()}');
      Get.back();
      Fluttertoast.showToast(
        msg: 'Request timeout. Please try again',
        toastLength: Toast.LENGTH_LONG,
      );
    } on SocketException catch (e) {
      isLoading.value = false;
      errorMessage.value = 'No internet connection';
      dev.log('🌐 Network Error: ${e.toString()}');
      Get.back();
      Fluttertoast.showToast(
        msg: 'No internet connection. Please check and try again',
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      dev.log('❌ Error in identifyPlant: $e');
      Get.back();
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
  }

  // ============ Gemini HTTP API Call ============

  Future<Map<String, dynamic>> _callGeminiAPI({
    required String imageBase64,
  }) async {
    try {
      // Build prompt
      final prompt = _buildIdentifierPrompt();

      // Prepare request body
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
        '$GEMINI_BASE_URL/gemini-2.5-flash:generateContent?key=$GEMINI_API_KEY',
      );

      dev.log('🔗 API URL: ${url.toString()}');
      dev.log('📤 Sending request to Gemini API...');

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

  // ============ Build Identifier Prompt ============

  String _buildIdentifierPrompt() {
    return '''
Analyze this plant image and identify it. Respond ONLY with valid JSON (no markdown, no extra text):

{
  "plant_name": "Common plant name (in English)",
  "scientific_name": "Scientific name",
  "description": "Detailed description of the plant (2-3 sentences including origin, characteristics, and uses)",
  "characteristics": [
    "Tag 1 (e.g., carnivorous)",
    "Tag 2 (e.g., tropical)",
    "Tag 3 (e.g., rare)",
    "Tag 4 (e.g., flowering)"
  ],
  "care_points": [
    "Temperature: X-Y°C (F-F°F) range",
    "Sunlight: Type of light needed",
    "Watering: Frequency and type of water",
    "Repotting: When and how to repot",
    "Pests: Common pests to watch for"
  ],
  "confidence": 0.95
}

IMPORTANT:
1. Return ONLY valid JSON, nothing else
2. No markdown, no backticks, no explanations
3. Make characteristics like tags (short, catchy)
4. Care points should be specific and actionable
5. Include temperature, sunlight, watering, repotting, and pests
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

  void clearIdentifierData() {
    identifierData.value = null;
    selectedImagePath.value = '';
    errorMessage.value = '';
    dev.log('🗑️ Identifier data cleared');
  }

  // ============ Get Current Data ============

  PlantIdentifierData? getIdentifierData() => identifierData.value;
}
