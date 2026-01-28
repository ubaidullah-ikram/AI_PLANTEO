import 'dart:typed_data';

import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plantify/models/diagnose_model.dart';
import 'dart:developer' as dev;

import 'package:plantify/services/remote_config_service.dart';
import 'package:plantify/view/diagnose_view/daignose_screen_camera.dart';
import 'package:plantify/view/diagnose_view/widgets/diagnose_result_screen.dart';

// ============ Main Controller ============

class DiagnoseApiController extends GetxController {
  // RxVariables
  final isLoading = false.obs;
  final diagnosisData = Rxn<DiagnosisData>();
  final errorMessage = ''.obs;
  final selectedImagePath = ''.obs;
  Uint8List temImage = Uint8List(0);
  // API Config
  static String GEMINI_API_KEY = RemoteConfigService().api_key_gemini;
  static const String GEMINI_BASE_URL =
      'https://generativelanguage.googleapis.com/v1/models';

  // ============ Main Diagnosis Function ============

  Future<void> diagnosePlant({
    required String imagePath,
    required PlantEnvironmentData environmentData,
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
      dev.log(
        '🌡️ Environment Data: Watering=${environmentData.wateringFrequency}, Light=${environmentData.lightCondition}, Humidity=${environmentData.humidity}, Temp=${environmentData.temperature}',
      );

      Get.off(
        () => DiagnosePlantScreen(isfromHome: false, isfromIdentify: false),
      );
      // Call Gemini API with environment data
      final response = await _callGeminiAPI(
        imageBase64: imageBase64,
        environmentData: environmentData,
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
      dev.log('✅ Diagnosis Data Set Successfully response : ${response}');
      isLoading.value = false;
      Get.off(() => DiagnoseResultScreen());
      Fluttertoast.showToast(
        msg: 'Plant Diagnosed successfully!',
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
      Get.back();
      Fluttertoast.showToast(msg: 'Error: ${e.toString()}');
    }
  }

  // ============ Gemini HTTP API Call ============

  Future<Map<String, dynamic>> _callGeminiAPI({
    required String imageBase64,
    required PlantEnvironmentData environmentData,
  }) async {
    try {
      // Build prompt with environment data
      final prompt = _buildDiagnosisPrompt(environmentData);

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
        // Get.back();
        dev.log('❌ Error Response: ${response.body}');
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      dev.log('❌ Error in _callGeminiAPI: ${e.toString()}');
      rethrow;
    }
  }

  // ============ Build Diagnosis Prompt with Environment Data ============

  String _buildDiagnosisPrompt(PlantEnvironmentData environmentData) {
    return '''
Analyze this plant image and provide detailed diagnosis based on the plant's current environment. Respond ONLY with valid JSON (no markdown, no extra text):

**Plant Environment Information:**
- Watering Frequency: ${environmentData.wateringFrequency}
- Light Condition: ${environmentData.lightCondition}
- Humidity Level: ${environmentData.humidity}
- Temperature: ${environmentData.temperature}
${environmentData.additionalNotes != null && environmentData.additionalNotes!.isNotEmpty ? '- Additional Notes: ${environmentData.additionalNotes}' : ''}

Based on this environment and the plant image, provide diagnosis in this exact JSON format:

{
  "plant_name": "Common plant name (in English)",
  "scientific_name": "Scientific name",
  "disease": "Main disease/problem detected or 'Healthy'",
  "description": "Brief description of plant condition considering the environment (1-2 sentences)",
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

IMPORTANT: 
1. Return ONLY valid JSON, nothing else
2. No markdown, no backticks, no explanations
3. Consider the watering frequency, light, humidity, and temperature in your diagnosis
4. Provide treatments and care tips that match the given environment
5. Be specific about why the plant might be suffering given its current conditions
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

  // void clearDiagnosis() {
  //   diagnosisData.value = null;
  //   selectedImagePath.value = '';
  //   errorMessage.value = '';
  //   dev.log('🗑️ Diagnosis data cleared');
  // }

  // ============ Get Current Data ============

  // DiagnosisData? getDiagnosisData() => diagnosisData.value;
}
