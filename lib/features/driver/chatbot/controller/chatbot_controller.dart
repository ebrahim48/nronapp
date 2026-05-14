import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/services/api_service.dart';
import '../model/chat_message_model.dart';

class ChatbotController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final isTyping = false.obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();

  String? _sessionId;
  final _api = ApiService();

  @override
  void onInit() {
    super.onInit();
    messages.add(ChatMessage(
      text: 'Hello! I\'m your NRON Assistant. How can I help you today?',
      isUser: false,
      time: DateTime.now(),
    ));
  }

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty || isTyping.value) return;

    messages.add(ChatMessage(text: text, isUser: true, time: DateTime.now()));
    textController.clear();
    _scrollToBottom();

    isTyping.value = true;

    try {
      final token = await PrefsHelper.getString('auth_token');
      final body = <String, dynamic>{'message': text};
      if (_sessionId != null) body['sessionId'] = _sessionId;

      final response = await _api.post(
        ApiConstants.messageChatBot,
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data?['data'];
      _sessionId ??= data?['sessionId'];
      final reply = (data?['message'] as String?)?.trim() ?? 'Sorry, I could not get a response.';

      messages.add(ChatMessage(text: reply, isUser: false, time: DateTime.now()));
    } catch (_) {
      messages.add(ChatMessage(
        text: 'Something went wrong. Please try again.',
        isUser: false,
        time: DateTime.now(),
      ));
    } finally {
      isTyping.value = false;
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
