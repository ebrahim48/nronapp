import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/app_colors.dart';
import '../controller/chatbot_controller.dart';
import '../model/chat_message_model.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  // ── Sessions bottom sheet ─────────────────────────────────────────────────
  void _showSessionsSheet(BuildContext context, ChatbotController c) {
    c.fetchSessions();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SessionsSheet(c: c),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ChatbotController());

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.smart_toy_outlined,
                  color: AppColors.primaryColor, size: 20.r),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NRON Assistant',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTextColor,
                  ),
                ),
                Obx(() => Text(
                      c.isTyping.value ? 'Typing...' : 'Online',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontFamily: 'Poppins',
                        color: c.isTyping.value
                            ? AppColors.secondaryTextColor
                            : AppColors.primaryColor,
                      ),
                    )),
              ],
            ),
          ],
        ),
        // ── 3-dots menu ──────────────────────────────────────────────
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,
                color: AppColors.primaryTextColor, size: 22.r),
            color: const Color(0xFF2A2A2A),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
            onSelected: (value) {
              if (value == 'history') {
                _showSessionsSheet(context, c);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'history',
                child: Row(
                  children: [
                    Icon(Icons.history,
                        color: AppColors.primaryTextColor, size: 18.r),
                    SizedBox(width: 10.w),
                    Text(
                      'View History',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Poppins',
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: c.scrollController,
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 12.h),
                  itemCount:
                      c.messages.length + (c.isTyping.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == c.messages.length && c.isTyping.value) {
                      return _TypingBubble();
                    }
                    return _MessageBubble(message: c.messages[index]);
                  },
                )),
          ),
          _InputBar(controller: c),
        ],
      ),
    );
  }
}

// ── Sessions bottom sheet ─────────────────────────────────────────────────────

class _SessionsSheet extends StatelessWidget {
  final ChatbotController c;
  const _SessionsSheet({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10.h, bottom: 14.h),
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Icon(Icons.history,
                    color: AppColors.primaryColor, size: 20.r),
                SizedBox(width: 8.w),
                Text(
                  'Chat History',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Divider(color: const Color(0xFF2A2A2A), height: 1),
          Expanded(
            child: Obx(() {
              if (c.isLoadingSessions.value) {
                return Shimmer.fromColors(
                  baseColor: const Color(0xFF2A2A2A),
                  highlightColor: const Color(0xFF3A3A3A),
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: 5,
                    itemBuilder: (_, __) => Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                );
              }

              if (c.sessions.isEmpty) {
                return Center(
                  child: Text(
                    'No chat history found.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Poppins',
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.all(16.r),
                itemCount: c.sessions.length,
                separatorBuilder: (_, __) =>
                    Divider(color: const Color(0xFF2A2A2A), height: 1),
                itemBuilder: (ctx, i) {
                  final session = c.sessions[i];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 4.w, vertical: 4.h),
                    leading: Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.chat_bubble_outline,
                          color: AppColors.primaryColor, size: 18.r),
                    ),
                    title: Text(
                      session.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColor,
                      ),
                    ),
                    subtitle: Text(
                      session.formattedDate,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontFamily: 'Poppins',
                        color: AppColors.secondaryTextColor,
                      ),
                    ),
                    trailing: Icon(Icons.chevron_right,
                        color: AppColors.secondaryTextColor, size: 18.r),
                    onTap: () {
                      Navigator.pop(ctx);
                      // Open session history screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => _SessionHistoryScreen(
                            c: c,
                            sessionId: session.sessionId,
                            title: session.title,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ── Session history screen ────────────────────────────────────────────────────

class _SessionHistoryScreen extends StatelessWidget {
  final ChatbotController c;
  final String sessionId;
  final String title;

  const _SessionHistoryScreen({
    required this.c,
    required this.sessionId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.fetchSessionHistory(sessionId, title);
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: AppColors.primaryTextColor, size: 18.r),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chat History',
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTextColor,
              ),
            ),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.sp,
                fontFamily: 'Poppins',
                color: AppColors.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (c.isLoadingHistory.value) {
          return Shimmer.fromColors(
            baseColor: const Color(0xFF2A2A2A),
            highlightColor: const Color(0xFF3A3A3A),
            child: ListView.builder(
              padding: EdgeInsets.all(16.r),
              itemCount: 6,
              itemBuilder: (_, i) => Align(
                alignment: i.isEven
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  width: 220.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          );
        }

        if (c.historyMessages.isEmpty) {
          return Center(
            child: Text(
              'No messages in this session.',
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'Poppins',
                color: AppColors.secondaryTextColor,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          itemCount: c.historyMessages.length,
          itemBuilder: (_, i) =>
              _MessageBubble(message: c.historyMessages[i]),
        );
      }),
    );
  }
}

// ── Message bubble ────────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 28.r,
              height: 28.r,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.smart_toy_outlined,
                  color: AppColors.primaryColor, size: 15.r),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppColors.primaryColor
                        : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(isUser ? 16.r : 4.r),
                      bottomRight: Radius.circular(isUser ? 4.r : 16.r),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Poppins',
                      color: isUser
                          ? AppColors.blackColor
                          : AppColors.primaryTextColor,
                    ),
                  ),
                ),
                if (message.attachments.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  ...message.attachments
                      .map((a) => _AttachmentCard(attachment: a)),
                ],
                SizedBox(height: 3.h),
                Text(
                  DateFormat('h:mm a').format(message.time),
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontFamily: 'Poppins',
                    color: AppColors.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          if (isUser) SizedBox(width: 8.w),
        ],
      ),
    );
  }
}

// ── Attachment card (download / open a file) ──────────────────────────────────

class _AttachmentCard extends StatelessWidget {
  final ChatAttachment attachment;
  const _AttachmentCard({required this.attachment});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ChatbotController>();
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Obx(() {
        final isDownloading =
            c.downloadingFile.value == attachment.filename;
        return InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: isDownloading
              ? null
              : () => c.downloadAttachment(attachment),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  attachment.isPdf
                      ? Icons.picture_as_pdf_rounded
                      : Icons.insert_drive_file_rounded,
                  color: AppColors.primaryColor,
                  size: 22.r,
                ),
                SizedBox(width: 10.w),
                Flexible(
                  child: Text(
                    attachment.filename,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                isDownloading
                    ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                              AppColors.primaryColor),
                        ),
                      )
                    : Icon(Icons.download_rounded,
                        color: AppColors.primaryColor, size: 20.r),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ── Typing bubble ─────────────────────────────────────────────────────────────

class _TypingBubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.smart_toy_outlined,
                color: AppColors.primaryColor, size: 15.r),
          ),
          SizedBox(width: 8.w),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => _Dot(delay: i * 200)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        width: 6.r,
        height: 6.r,
        decoration: BoxDecoration(
          color: AppColors.secondaryTextColor
              .withValues(alpha: _anim.value),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ── Input bar ─────────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final ChatbotController controller;
  const _InputBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                controller: controller.textController,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    color: AppColors.primaryTextColor),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Poppins',
                      color: AppColors.secondaryTextColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 10.h),
                ),
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: controller.sendMessage,
            child: Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send_rounded,
                  color: AppColors.blackColor, size: 20.r),
            ),
          ),
        ],
      ),
    );
  }
}
