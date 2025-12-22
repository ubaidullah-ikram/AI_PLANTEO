import 'package:flutter/material.dart';
import 'package:plantify/constant/app_colors.dart';
import 'package:plantify/constant/app_icons.dart';
import 'package:plantify/constant/app_images.dart';
import 'package:plantify/res/responsive_config/responsive_config.dart';
import 'package:svg_flutter/svg.dart';

class PlanteoExpertScreen extends StatefulWidget {
  const PlanteoExpertScreen({Key? key}) : super(key: key);

  @override
  State<PlanteoExpertScreen> createState() => _PlanteoExpertScreenState();
}

class _PlanteoExpertScreenState extends State<PlanteoExpertScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({'text': _messageController.text, 'sender': 'user'});
      });
      _messageController.clear();
    }
  }

  void _handleQuickReply(String text) {
    setState(() {
      _messages.add({'text': text, 'sender': 'user'});
    });
  }

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
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
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
            // Icon(icon, color: Color(0xFF2E8B7D), size: 18),
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

  Widget _buildMessageBubble(Map<String, String> message) {
    final isUser = message['sender'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF2E8B7D) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message['text']!,
          style: TextStyle(
            color: isUser ? Colors.white : const Color(0xFF1F2937),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
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
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: _sendMessage,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        // color: Color(0xFF2E8B7D),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppIcons.send_icon,
                        // color: Colors.white,
                        width: 12,
                        height: 18,
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
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(24),
                //   borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                // ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF2E8B7D)),
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
}
