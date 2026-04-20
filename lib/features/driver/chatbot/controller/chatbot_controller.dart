import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/chat_message_model.dart';

class ChatbotController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final isTyping = false.obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();

  final List<String> _autoReplies = [
    // General
    'Got it! How can I assist you further?',
    'Sure, let me help you with that.',
    'I understand. Is there anything else you need?',
    'Thanks for reaching out! Your request has been noted.',
    'I\'ll look into that for you right away.',
    'That\'s a great question! Let me find the best answer.',
    'I\'m here to help. Please provide more details if needed.',
    'Understood. Our team will get back to you shortly.',

    // Job requests
    'You have new job requests available on your home screen. Tap a card to view the details.',
    'Urgent shipments are marked in red. Please accept them as soon as possible.',
    'To accept a job, open the job request card and tap "Accept Job".',
    'You can view all your active and completed jobs in the Jobs section.',
    'Your current job is marked as "In Transit". Please proceed to the dropoff location.',

    // Pickup & delivery
    'Please confirm pickup by tapping "Confirm Pickup" once you\'ve collected the shipment.',
    'Make sure to verify the shipment ID before picking up the package.',
    'Special handling instructions are listed on the job details page. Please review them carefully.',
    'Once you arrive at the destination, tap "Arrived at Destination" on the map screen.',
    'To complete delivery, tap "Mark as Delivered" and upload a delivery photo if required.',
    'The pickup contact number is available in the job details. Call them if you need assistance.',

    // Navigation & location
    'Navigation is available on the map screen. Tap the route icon to start directions.',
    'Make sure your location is enabled for accurate ETA calculations.',
    'Your ETA is calculated based on real-time traffic. Please allow extra time for delays.',
    'If the address seems incorrect, contact dispatch before heading to the location.',

    // Earnings
    'Your earnings for this delivery will be updated once the shipment is marked as completed.',
    'You can view your total earnings in the Earnings section from the bottom navigation bar.',
    'Payout is processed weekly. Check the Earnings screen for your next payout date.',
    'Completed deliveries contribute to your weekly performance bonus.',

    // Shipment & package
    'The package dimensions and weight are listed in the job details. Handle with care if fragile.',
    'Medical shipments require extra care. Follow all special instructions on the delivery note.',
    'If the package is damaged upon pickup, report it immediately through the app.',
    'Proof of delivery documents are available in the attached files section of the job.',

    // Support
    'If you\'re facing any issue with a delivery, please contact your dispatcher immediately.',
    'For urgent support, call the helpline available in the Settings > Contact Support section.',
    'Your concern has been logged. A support agent will contact you within 30 minutes.',
  ];

  @override
  void onInit() {
    super.onInit();
    messages.add(ChatMessage(
      text: 'Hello! I\'m your NRON Assistant. How can I help you today?',
      isUser: false,
      time: DateTime.now(),
    ));
  }

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    messages.add(ChatMessage(text: text, isUser: true, time: DateTime.now()));
    textController.clear();
    _scrollToBottom();

    isTyping.value = true;
    Future.delayed(const Duration(milliseconds: 1200), () {
      isTyping.value = false;
      final reply = _autoReplies[messages.length % _autoReplies.length];
      messages.add(ChatMessage(text: reply, isUser: false, time: DateTime.now()));
      _scrollToBottom();
    });
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
