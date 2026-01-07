// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:plantify/models/chat_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class PlantExpertChatController extends GetxController {
//   final RxList<ChatMessage> messages = <ChatMessage>[].obs;

//   // 🔧 Constants
//   static String apiKey = 'AIzaSyACtmKBoA3tdIhGeVpSbPpruXOyCbC-GUE';
//   static const String baseUrl =
//       'https://generativelanguage.googleapis.com/v1/models';

//   @override
//   void onInit() {
//     super.onInit();
//     log('PlantExpertChatController initialized');
//   }

//   // ✅ Add message to list
//   void addMessage(ChatMessage message) {
//     messages.add(message);
//   }

//   // ✅ Clear chat
//   void clearChat() {
//     messages.value = [];
//     log('Chat cleared');
//   }

//   // ✅ Send message to Gemini API
//   Future<String> sendMessageToGemini(String userMessage) async {
//     try {
//       log('📤 Sending message to Gemini: $userMessage');

//       // 📝 Build system instruction
//       final systemInstruction =
//           '''You are Planteo Expert - an AI assistant specialized in plant care, gardening, and farming. Your expertise includes:

// YOUR EXPERTISE:
// 1. Plant diseases diagnosis and treatment
// 2. Plant care tips (watering, sunlight, soil requirements)
// 3. Gardening and farming techniques
// 4. Pest control and plant health
// 5. Seasonal gardening advice
// 6. Crop management
// 7. Fertilizers and nutrients recommendations
// 8. Common plant problems and solutions

// GUIDELINES:
// 1. You MUST ONLY answer questions related to plants, gardening, farming, and agriculture
// 2. If user asks non-plant related questions, respond with: "I'm here to help with plant and farming questions. Please ask about plants, gardening, diseases, or farming!"
// 3. Be friendly, helpful, and use plant emojis when appropriate
// 4. Provide practical, actionable solutions
// 5. Give step-by-step guidance when explaining treatments or procedures
// 6. Keep responses concise but informative

// Remember: Your ONLY purpose is helping with plants and farming!''';

//       // 🔄 Prepare request body for Gemini API
//       final requestBody = {

//         // 'system_instruction': {
//         //   'parts': {'text': systemInstruction},
//         // },
//         'contents': [
//           {
//             'role': 'user',
//             'parts': [
//               {'text': userMessage},
//             ],
//           },
//         ],
//         'generationConfig': {
//           'temperature': 0.7,
//           'topP': 0.95,
//           'maxOutputTokens': 1024,
//         },
//       };

//       // 🌐 Make HTTP request
//       final url = Uri.parse(
//         '$baseUrl/gemini-2.5-flash-lite:generateContent?key=$apiKey',
//       );

//       final response = await http
//           .post(
//             url,
//             headers: {'Content-Type': 'application/json'},
//             body: jsonEncode(requestBody),
//           )
//           .timeout(
//             const Duration(seconds: 60),
//             onTimeout: () {
//               throw TimeoutException('Request took too long');
//             },
//           );

//       log('📨 Response Status Code: ${response.statusCode}');

//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);

//         // 📦 Extract response text
//         final aiResponse =
//             responseData['candidates']?[0]?['content']?['parts']?[0]?['text'];

//         if (aiResponse != null && aiResponse.isNotEmpty) {
//           log('✅ Got response from Gemini');

//           // 🔻 Deduct query
//           // await deductQuery();

//           return aiResponse;
//         } else {
//           log('❌ Empty response from Gemini');
//           return 'Sorry, I could not generate a response. Please try again.';
//         }
//       } else {
//         log('❌ Error Response: ${response.body}');

//         // 🎯 Handle specific error codes
//         if (response.statusCode == 401) {
//           return 'API key error. Please contact support.';
//         } else if (response.statusCode == 429) {
//           return 'Too many requests. Please wait a moment and try again.';
//         } else {
//           return 'API Error: ${response.statusCode}. Please try again.';
//         }
//       }
//     } on TimeoutException catch (e) {
//       log('⏱️ Timeout Error: ${e.toString()}');
//       Fluttertoast.showToast(
//         msg: 'Request timeout. Please check your internet connection.',
//         toastLength: Toast.LENGTH_LONG,
//       );
//       return 'timeout_error';
//     } on SocketException catch (e) {
//       log('🌐 Network Error: ${e.toString()}');
//       Fluttertoast.showToast(
//         msg: 'No internet connection. Please check and try again.',
//         toastLength: Toast.LENGTH_LONG,
//       );
//       return 'network_error';
//     } catch (e) {
//       log('❌ Unexpected Error: ${e.toString()}');
//       Fluttertoast.showToast(msg: 'Something went wrong. Please try again.');
//       return 'error';
//     }
//   }

//   // // 🔻 Deduct free query
//   // Future<void> deductQuery() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   int current = prefs.getInt(kFreeQueriesKey) ?? kInitialFreeQueries;
//   //   if (current > 0) {
//   //     await prefs.setInt(kFreeQueriesKey, current - 1);
//   //     log('🔻 Query deducted: ${current - 1} remaining');
//   //   }
//   // }

//   // // 📊 Get remaining free queries
//   // Future<int> getRemainingQueries() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   return prefs.getInt(kFreeQueriesKey) ?? kInitialFreeQueries;
//   // }

//   // String kFreeQueriesKey = 'plant_expert_remaining_queries';
//   // int kInitialFreeQueries = 10;
// }import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:plantify/models/chat_model.dart';
import 'package:plantify/services/remote_config_service.dart';

class PlantExpertChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  // 🔧 Constants
  static String apiKey = RemoteConfigService().api_key_gemini;
  static const String baseUrl =
      'https://generativelanguage.googleapis.com/v1/models';

  /// 🌱 System Instruction for Gemini
  //   static const String systemInstruction = '''
  // You are Planteo Expert - an AI assistant specialized in plant care, gardening, and farming.

  // YOUR EXPERTISE:
  // 1. Plant diseases diagnosis and treatment
  // 2. Plant care tips (watering, sunlight, soil requirements)
  // 3. Gardening and farming techniques
  // 4. Pest control and plant health
  // 5. Seasonal gardening advice
  // 6. Crop management
  // 7. Fertilizers and nutrient recommendations
  // 8. Common plant problems and solutions

  // GUIDELINES:
  // 1. ONLY answer plant / gardening / farming questions
  // 2. If user asks non-plant question, reply:
  //    "I'm here to help with plant and farming questions. Please ask about plants, gardening, diseases, or farming!"
  // 3. Be friendly, helpful & use 🌿🍃 emojis naturally
  // 4. Provide step-by-step guidance for treatments & solutions
  // 5. Keep responses helpful & practical
  // ''';

  @override
  void onInit() {
    super.onInit();
    log("🌿 PlantExpertChatController initialized — session starts");
  }

  // 📝 Add user or AI message (INTERNAL USE ONLY)
  void addMessage(ChatMessage message) {
    messages.add(message);
  }

  // 🧹 Clear chat manually
  void clearChat() {
    messages.clear();
    log("🧹 Chat cleared by user");
  }

  /// 🔥 Send message to Gemini - ONLY returns AI response, does NOT add user message
  Future<String> sendMessageToGemini(String userMsg) async {
    try {
      log("📤 Sending to Gemini (${messages.length} messages in session)");

      // 🔄 Prepare full session content
      final sessionMessages = messages.map((msg) {
        return {
          'role': msg.isUser ? 'user' : 'model',
          'parts': [
            {'text': msg.text},
          ],
        };
      }).toList();

      // 🧠 COMPLETE Gemini request body
      final body = {
        'contents': sessionMessages,
        'generationConfig': {
          'temperature': 0.7,
          'topP': 0.95,
          'maxOutputTokens': 1024,
        },
      };

      final url = Uri.parse(
        '$baseUrl/gemini-2.5-flash-lite:generateContent?key=$apiKey',
      );

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      log("📨 Response Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final text = json['candidates']?[0]?['content']?['parts']?[0]?['text'];

        if (text != null) {
          // ✅ ONLY add AI response here
          addMessage(ChatMessage(text: text, isUser: false, time: ''));
          return text;
        } else {
          return "❌ Could not understand the response.";
        }
      } else {
        log("❌ Gemini Error Body: ${response.body}");
        return "API Error: ${response.statusCode}";
      }
    } on SocketException {
      Fluttertoast.showToast(msg: "Check your internet connection");
      return "network_error";
    } catch (e) {
      log("⚠️ Unexpected Error: $e");
      return "error";
    }
  }
}
