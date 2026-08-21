import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;

  const ConversationScreen({super.key, required this.conversationId});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  // Mock messages
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: 'Anh ơi, chiều nay mình đi ăn lẩu không?',
      isMe: false,
      time: '10:30',
    ),
    _ChatMessage(
      text: 'OK em, lẩu nào vậy?',
      isMe: true,
      time: '10:31',
    ),
    _ChatMessage(
      text: 'Lẩu Thái nhé! Quán ở đường Nguyễn Huệ ấy, anh biết không?',
      isMe: false,
      time: '10:32',
    ),
    _ChatMessage(
      text: 'Biết rồi, quán quen mà 😄',
      isMe: true,
      time: '10:32',
    ),
    _ChatMessage(
      text: 'Vậy 6h chiều nhé anh!',
      isMe: false,
      time: '10:33',
    ),
    _ChatMessage(
      text: 'Anh ơi đến đâu rồi? Em đợi ở quán cà phê nhé.',
      isMe: false,
      time: '17:45',
    ),
  ];

  // AI quick reply suggestions
  final List<String> _quickReplies = [
    'Anh sắp đến rồi, 5 phút nữa nhé!',
    'Anh đang lái xe, gọi lại sau nhé',
    'OK em, anh đến rồi đây!',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surfaceVariant = isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? Colors.white : AppColors.lightOnSurface;
    final subtextColor = isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ───
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(
                  bottom: BorderSide(color: borderColor, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: textColor,
                      size: 20,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nguyễn Văn An',
                          style: AppTextStyles.titleMedium(color: textColor),
                        ),
                        Text(
                          'Đang hoạt động',
                          style: AppTextStyles.bodySmall(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TTS read button
                  _ActionIcon(
                    icon: Icons.volume_up_rounded,
                    onTap: () {},
                    tooltip: 'Đọc tin nhắn',
                  ),
                  const SizedBox(width: 4),
                  _ActionIcon(
                    icon: Icons.summarize_rounded,
                    onTap: () {},
                    tooltip: 'Tóm tắt',
                  ),
                ],
              ),
            ),

            // ─── Messages ───
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _ChatBubble(
                    message: msg,
                    receivedBubbleColor: surfaceVariant,
                    textColor: textColor,
                    subtextColor: subtextColor,
                  );
                },
              ),
            ),

            // ─── Quick Reply Chips ───
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.smart_toy_rounded,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Gợi ý AI',
                        style: AppTextStyles.labelSmall(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _quickReplies.map((reply) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _messages.add(_ChatMessage(
                              text: reply,
                              isMe: true,
                              time: '17:46',
                            ));
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            reply,
                            style: AppTextStyles.bodySmall(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // ─── Input bar ───
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(
                  top: BorderSide(color: borderColor, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: surfaceVariant,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              style: AppTextStyles.bodyMedium(
                                color: textColor,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Nhập tin nhắn...',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                hintStyle: AppTextStyles.bodyMedium(
                                  color: subtextColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Mic button
                  GestureDetector(
                    onTap: () => context.push('/voice'),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mic_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Action Icon ───
class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _ActionIcon({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: AppColors.primary, size: 22),
      tooltip: tooltip,
    );
  }
}

// ─── Chat Message Model ───
class _ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  const _ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

// ─── Chat Bubble Widget ───
class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;
  final Color receivedBubbleColor;
  final Color textColor;
  final Color subtextColor;

  const _ChatBubble({
    required this.message,
    required this.receivedBubbleColor,
    required this.textColor,
    required this.subtextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.primary,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: message.isMe
                    ? AppColors.primary
                    : receivedBubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(message.isMe ? 18 : 4),
                  bottomRight: Radius.circular(message.isMe ? 4 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message.text,
                    style: AppTextStyles.bodyMedium(
                      color: message.isMe
                          ? Colors.white
                          : textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.time,
                    style: AppTextStyles.bodySmall(
                      color: message.isMe
                          ? Colors.white.withValues(alpha: 0.7)
                          : subtextColor,
                    ).copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          if (message.isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
