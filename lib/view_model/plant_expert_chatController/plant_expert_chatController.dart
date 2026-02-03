import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:plantify/models/chat_model.dart';
import 'package:plantify/services/query_manager_services.dart';
import 'package:plantify/services/remote_config_service.dart';

class PlantExpertChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;

  // 🔧 Constants
  static String apiKey = RemoteConfigService().api_key_gemini;
  static const String baseUrl =
      'https://generativelanguage.googleapis.com/v1/models';

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
          QueryManager.useQuery();
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
