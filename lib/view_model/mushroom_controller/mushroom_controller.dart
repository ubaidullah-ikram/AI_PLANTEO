import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantify/models/mushroom_model.dart';
import 'dart:developer' as dev;

import 'package:plantify/services/remote_config_service.dart';
import 'package:plantify/view/mushroom_result_sc/mushroom_result_sc.dart';

class MushroomIdentificationController extends GetxController {
  // RxVariables
  final isLoading = false.obs;
  final mushroomData = Rxn<MushroomIdentificationData>();
  final errorMessage = ''.obs;
  final selectedImagePath = ''.obs;

  // API Config
  static String GEMINI_API_KEY = RemoteConfigService().api_key_gemini;
  static const String GEMINI_BASE_URL =
      'https://generativelanguage.googleapis.com/v1/models';

  // ============ Main Mushroom Identification Function ============

  Future<void> identifyMushroom({required String imagePath}) async {
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

      dev.log('🍄 Starting Mushroom Identification...');
      dev.log('📸 Image converted to Base64');

      // Call Gemini API
      final response = await _callGeminiAPI(imageBase64: imageBase64);

      dev.log('✅ API Response received');

      // Parse response
      final parsedData = MushroomIdentificationData.fromJson(response);

      final finalData = MushroomIdentificationData(
        mushroomName: parsedData.mushroomName,
        scientificName: parsedData.scientificName,
        edibility: parsedData.edibility,
        description: parsedData.description,
        characteristics: parsedData.characteristics,
        habitat: parsedData.habitat,
        lookAlikes: parsedData.lookAlikes,
        imagePath: imagePath,
        confidence: parsedData.confidence,
        isIdentified: parsedData.isIdentified,
      );

      mushroomData.value = finalData;
      dev.log('✅ Mushroom Identification Data Set Successfully');
      isLoading.value = false;
      Get.off(() => MushroomIdentificationResultScreen());
      Fluttertoast.showToast(
        msg: finalData.isIdentified
            ? 'Mushroom identified successfully!'
            : 'No mushroom detected in this image',
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
      dev.log('❌ Error in identifyMushroom: $e');
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
  }

  // ============ Gemini HTTP API Call ============

  Future<Map<String, dynamic>> _callGeminiAPI({
    required String imageBase64,
  }) async {
    try {
      // Build prompt
      final prompt = _buildIdentificationPrompt();

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
      dev.log('📤 Sending request to Gemini API for Mushroom ID...');

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

  // ============ Build Mushroom Identification Prompt ============

  String _buildIdentificationPrompt() {
    return '''
Analyze this image and identify if it contains a mushroom. Respond ONLY with valid JSON (no markdown, no extra text):

{
  "is_identified": true or false,
  "mushroom_name": "Common mushroom name in English or 'No Mushroom Detected' if not found",
  "scientific_name": "Scientific name or 'N/A' if no mushroom",
  "edibility": "Edible, Poisonous, Inedible, or Unknown",
  "description": "Brief description of the mushroom (1-2 sentences). If no mushroom found, explain why",
  "characteristics": [
    "Cap color and shape",
    "Gill type and color",
    "Stem/stipe characteristics",
    "Spore print color if visible"
  ],
  "habitat": [
    "Habitat type 1",
    "Habitat type 2",
    "Habitat type 3"
  ],
  "look_alikes": [
    "Similar mushroom species 1",
    "Similar mushroom species 2",
    "Similar mushroom species 3"
  ],
  "confidence": 0.85
}

IMPORTANT RULES:
1. If the image does NOT contain a mushroom, set "is_identified" to false
2. Set mushroom_name to "No Mushroom Detected" if no mushroom is found
3. Return ONLY valid JSON, nothing else
4. No markdown, no backticks, no explanations
5. If edibility is Poisonous, clearly indicate this in characteristics
6. Provide accurate botanical information
7. Include look-alikes to help user differentiate
8. Confidence should be 0 if no mushroom is found
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

  void clearIdentification() {
    mushroomData.value = null;
    selectedImagePath.value = '';
    errorMessage.value = '';
    dev.log('🗑️ Mushroom identification data cleared');
  }

  // ============ Get Current Data ============

  MushroomIdentificationData? getMushroomData() => mushroomData.value;
}
