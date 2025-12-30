// import 'package:flutter/material.dart';
// import 'package:plantify/constant/app_colors.dart';
// import 'package:plantify/constant/app_icons.dart';
// import 'package:plantify/res/responsive_config/responsive_config.dart';
// import 'package:svg_flutter/svg.dart';

// class PlanteoExpertScreen extends StatefulWidget {
//   const PlanteoExpertScreen({Key? key}) : super(key: key);

//   @override
//   State<PlanteoExpertScreen> createState() => _PlanteoExpertScreenState();
// }

// class _PlanteoExpertScreenState extends State<PlanteoExpertScreen> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<Map<String, String>> _messages = [];

//   void _sendMessage() {
//     if (_messageController.text.trim().isNotEmpty) {
//       setState(() {
//         _messages.add({'text': _messageController.text, 'sender': 'user'});
//       });
//       _messageController.clear();
//     }
//   }

//   void _handleQuickReply(String text) {
//     setState(() {
//       _messages.add({'text': text, 'sender': 'user'});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffF9F9F9),
//       appBar: AppBar(
//         backgroundColor: Color(0xffF9F9F9),
//         surfaceTintColor: Color(0xffF9F9F9),
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Planteo Expert',
//           style: TextStyle(
//             color: AppColors.textHeading,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: false,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: _messages.isEmpty
//                 ? _buildEmptyState()
//                 : ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: _messages.length,
//                     itemBuilder: (context, index) {
//                       final message = _messages[index];
//                       return _buildMessageBubble(message);
//                     },
//                   ),
//           ),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(height: SizeConfig.h(70)),
//           Text(
//             'Ask anything, grow\nbetter!',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: AppColors.textHeading,
//               fontSize: 28,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'Start chatting to get personalized plant\ncare suggestions.',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Color(0xFF797979),
//               fontSize: 13,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           const SizedBox(height: 40),
//           _buildQuickReplyButton(
//             'Why are my leaves turning yellow?',
//             Icons.help_outline,
//           ),
//           const SizedBox(height: 12),
//           _buildQuickReplyButton(
//             'Recommend an easy-care plant',
//             Icons.lightbulb_outline,
//           ),
//           const SizedBox(height: 12),
//           _buildQuickReplyButton('My plant looks sick', Icons.healing),
//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickReplyButton(String text, IconData icon) {
//     return GestureDetector(
//       onTap: () => _handleQuickReply(text),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16),
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         decoration: BoxDecoration(
//           border: Border.all(color: const Color(0xFFE0E0E0)),
//           borderRadius: BorderRadius.circular(24),
//           color: Colors.white,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Icon(icon, color: Color(0xFF2E8B7D), size: 18),
//             SvgPicture.asset(
//               AppIcons.setting,
//               color: Color(0xff797979),
//               height: 14,
//             ),
//             const SizedBox(width: 8),
//             Text(
//               text,
//               style: const TextStyle(
//                 color: Color(0xFF6B7280),
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageBubble(Map<String, String> message) {
//     final isUser = message['sender'] == 'user';
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//         decoration: BoxDecoration(
//           color: isUser ? const Color(0xFF2E8B7D) : const Color(0xFFF3F4F6),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Text(
//           message['text']!,
//           style: TextStyle(
//             color: isUser ? Colors.white : const Color(0xFF1F2937),
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageInput() {
//     return Container(
//       margin: EdgeInsets.only(bottom: SizeConfig.h(20)),
//       padding: const EdgeInsets.all(16),

//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               onTapOutside: (event) {
//                 FocusScope.of(context).unfocus();
//               },
//               decoration: InputDecoration(
//                 suffixIcon: GestureDetector(
//                   onTap: _sendMessage,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: const BoxDecoration(
//                         // color: Color(0xFF2E8B7D),
//                         shape: BoxShape.circle,
//                       ),
//                       child: SvgPicture.asset(
//                         AppIcons.send_icon,
//                         // color: Colors.white,
//                         width: 12,
//                         height: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//                 border: InputBorder.none,
//                 hintText: 'Type your message here',
//                 hintStyle: const TextStyle(
//                   color: Color(0xFFD1D5DB),
//                   fontSize: 14,
//                 ),
//                 // border: OutlineInputBorder(
//                 //   borderRadius: BorderRadius.circular(24),
//                 //   borderSide: BorderSide(color: Color(0xFFE0E0E0)),
//                 // ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                   borderSide: const BorderSide(color: Color(0xFF2E8B7D)),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 filled: true,
//                 fillColor: Colors.transparent,
//               ),
//               onSubmitted: (_) => _sendMessage(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/models/chat_model.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:plantify/view_model/plant_expert_chatController/plant_expert_chatController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svg_flutter/svg.dart';

class PlanteoExpertScreen extends StatefulWidget {
  const PlanteoExpertScreen({Key? key}) : super(key: key);

  @override
  State<PlanteoExpertScreen> createState() => _PlanteoExpertScreenState();
}

class _PlanteoExpertScreenState extends State<PlanteoExpertScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late PlantExpertChatController _plantController;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();

    // ✅ Controller initialize karo
    if (Get.isRegistered<PlantExpertChatController>()) {
      _plantController = Get.find<PlantExpertChatController>();
    } else {
      _plantController = Get.put(PlantExpertChatController());
    }

    _scrollToBottom();
    log('Plant Expert Screen loaded');
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) {
      return;
    }

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    // ✅ Screen se user message add karo (SIRF YEK BAAR)
    _plantController.addMessage(
      ChatMessage(text: userMessage, isUser: true, time: ""),
    );

    setState(() {
      _isTyping = true;
    });

    _scrollToBottom();

    try {
      // ✅ Controller sirf AI response return karega
      final aiResponse = await _plantController.sendMessageToGemini(
        userMessage,
      );

      setState(() {
        _isTyping = false;
      });

      // ✅ AI message pehle se add ho gaya controller main
      // Sirf state update karo
      _plantController.messages.refresh();

      if (aiResponse.isNotEmpty &&
          aiResponse != 'timeout_error' &&
          aiResponse != 'network_error' &&
          aiResponse != 'limit_reached') {
        trackExpertMessage();
      }

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isTyping = false;
      });

      _plantController.addMessage(
        ChatMessage(
          text: "Sorry, something went wrong. Please try again.",
          isUser: false,
          time: "",
        ),
      );

      log("Plant Expert Chat Error: $e");
    }
  }

  void _handleQuickReply(String text) {
    _messageController.text = text;
    _sendMessage();
  }

  Future<void> trackExpertMessage() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(expertMessageCountKey) ?? 0;
    count++;
    await prefs.setInt(expertMessageCountKey, count);

    if (count == 3) {
      // showRatingPrompt();
    }
  }

  var expertMessageCountKey = "plant_expert_message_count";

  // Future<void> showRatingPrompt() async {
  //   final InAppReview inAppReview = InAppReview.instance;
  //   log('Time to rate app');
  //   if (await inAppReview.isAvailable()) {
  //     inAppReview.requestReview();
  //   } else {
  //     inAppReview.openStoreListing(
  //       appStoreId: 'YOUR_IOS_APP_ID',
  //       microsoftStoreId: null,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      appBar: AppBar(
        backgroundColor: Color(0xffF9F9F9),
        surfaceTintColor: Color(0xffF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Planteo Expert',
          style: TextStyle(
            color: AppColors.textHeading,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // ✅ Messages or Empty State
          Expanded(
            child: Obx(
              () => _plantController.messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount:
                          _plantController.messages.length +
                          (_isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _plantController.messages.length &&
                            _isTyping) {
                          return _buildTypingIndicator();
                        }
                        return _buildMessageBubble(
                          _plantController.messages[index],
                        );
                      },
                    ),
            ),
          ),
          // ✅ Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.h(70)),
          Text(
            'Ask anything, grow\nbetter!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textHeading,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start chatting to get personalized plant\ncare suggestions.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF797979),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 40),
          _buildQuickReplyButton(
            'Why are my leaves turning yellow?',
            Icons.help_outline,
          ),
          const SizedBox(height: 12),
          _buildQuickReplyButton(
            'Recommend an easy-care plant',
            Icons.lightbulb_outline,
          ),
          const SizedBox(height: 12),
          _buildQuickReplyButton('My plant looks sick', Icons.healing),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildQuickReplyButton(String text, IconData icon) {
    return GestureDetector(
      onTap: () => _handleQuickReply(text),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.setting,
              color: Color(0xff797979),
              height: 14,
            ),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        constraints: BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF2E8B7D) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: isUser
            // ✅ User messages: plain text (no markdown)
            ? Text(
                message.text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              )
            // ✅ AI messages: markdown support
            : MarkdownWidget(
                data: message.text,
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),

                // markdownWidgetConfig: MarkdownWidgetConfig(
                //   markdownExtensionSet: MarkdownExtensionSet.gitHubFlavored,
                // ),
                // styleConfig: StyleConfig(
                //   // 📝 Heading styles
                //   h1: const TextStyle(
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //     color: Color(0xFF1F2937),
                //   ),
                //   h2: const TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold,
                //     color: Color(0xFF1F2937),
                //   ),
                //   h3: const TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.bold,
                //     color: Color(0xFF1F2937),
                //   ),
                //   // 📄 Paragraph styles
                //   p: const TextStyle(
                //     fontSize: 14,
                //     color: Color(0xFF1F2937),
                //     height: 1.5,
                //   ),
                //   // 🔗 Link styles
                //   a: const TextStyle(
                //     fontSize: 14,
                //     color: Color(0xFF2E8B7D),
                //     decoration: TextDecoration.underline,
                //   ),
                //   // 📋 List styles
                //   li: const TextStyle(
                //     fontSize: 14,
                //     color: Color(0xFF1F2937),
                //   ),
                //   // 💻 Code styles
                //   code: const TextStyle(
                //     fontSize: 12,
                //     backgroundColor: Color(0xFFEEEEEE),
                //     color: Color(0xFF1F2937),
                //     fontFamily: 'monospace',
                //   ),
                //   // 🔲 Block quote styles
                //   blockquote: const TextStyle(
                //     fontSize: 14,
                //     color: Color(0xFF6B7280),
                //     fontStyle: FontStyle.italic,
                //   ),
                // ),
              ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E8B7D)),
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Planteo is thinking...',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.h(20)),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              enabled: !_isTyping,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: _isTyping ? null : _sendMessage,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: SvgPicture.asset(
                        AppIcons.send_icon,
                        width: 12,
                        height: 18,
                        color: _isTyping ? Colors.grey : Color(0xFF2E8B7D),
                      ),
                    ),
                  ),
                ),
                border: InputBorder.none,
                hintText: 'Type your message here',
                hintStyle: const TextStyle(
                  color: Color(0xFFD1D5DB),
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF2E8B7D)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
