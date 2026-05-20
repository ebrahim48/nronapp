import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../model/chat_message_model.dart';

class ChatbotController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final isTyping = false.obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();

  // ── History ───────────────────────────────────────────────────────────────
  final sessions = <ChatSession>[].obs;
  final isLoadingSessions = false.obs;
  final isLoadingHistory = false.obs;
  final historyMessages = <ChatMessage>[].obs;
  final selectedSessionTitle = ''.obs;

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

  // ── Send message ──────────────────────────────────────────────────────────

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
      final reply = (data?['message'] as String?)?.trim() ??
          'Sorry, I could not get a response.';

      messages.add(
          ChatMessage(text: reply, isUser: false, time: DateTime.now()));
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

  // ── Fetch sessions ────────────────────────────────────────────────────────

  Future<void> fetchSessions() async {
    try {
      isLoadingSessions.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final response = await _api.get(
        ApiConstants.getChatBotSessions,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final raw = response.data?['data'];
      if (raw is List) {
        sessions.assignAll(
          raw.map((e) => ChatSession.fromJson(e as Map<String, dynamic>)),
        );
      }
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load chat sessions');
    } finally {
      isLoadingSessions.value = false;
    }
  }

  // ── Fetch session history ─────────────────────────────────────────────────

  Future<void> fetchSessionHistory(String sessionId, String title) async {
    try {
      isLoadingHistory.value = true;
      historyMessages.clear();
      selectedSessionTitle.value = title;
      final token = await PrefsHelper.getString('auth_token');
      final response = await _api.get(
        ApiConstants.getChatBotHistory(sessionId),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = response.data?['data'];
      if (data is Map) {
        final msgs = data['messages'] as List<dynamic>? ?? [];
        historyMessages.assignAll(
          msgs.map((m) {
            final mMap = m as Map<String, dynamic>;
            return ChatMessage(
              text: mMap['content']?.toString() ?? '',
              isUser: mMap['role']?.toString() == 'user',
              time: DateTime.tryParse(
                      mMap['timestamp']?.toString() ?? '') ??
                  DateTime.now(),
            );
          }),
        );
      }
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load chat history');
    } finally {
      isLoadingHistory.value = false;
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
