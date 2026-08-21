import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';

class MessageSimulatorScreen extends StatefulWidget {
  const MessageSimulatorScreen({super.key});

  @override
  State<MessageSimulatorScreen> createState() => _MessageSimulatorScreenState();
}

class _MessageSimulatorScreenState extends State<MessageSimulatorScreen> {
  final _senderController = TextEditingController(text: 'Nguyễn Văn An');
  final _messageController = TextEditingController();
  bool _isGroup = false;
  final List<_LogEntry> _logs = [];

  void _sendSimulated() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _logs.insert(0, _LogEntry(
        step: 'Tin nhắn nhận được',
        detail: '${_senderController.text}: ${_messageController.text}',
        icon: Icons.message_rounded,
        color: AppColors.primary,
      ));
    });

    // Simulate pipeline
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _logs.insert(0, _LogEntry(
          step: 'Phân loại tin nhắn',
          detail: _isGroup ? 'Nhóm → cần tóm tắt' : '1-1 → đọc trực tiếp',
          icon: Icons.category_rounded,
          color: AppColors.info,
        ));
      });
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        if (_isGroup) {
          _logs.insert(0, _LogEntry(
            step: 'Tóm tắt LLM',
            detail: 'Qwen3-1.7B → "${_messageController.text.length > 30 ? _messageController.text.substring(0, 30) : _messageController.text}..."',
            icon: Icons.smart_toy_rounded,
            color: const Color(0xFF6C63FF),
          ));
        }
      });
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _logs.insert(0, _LogEntry(
          step: 'Đọc TTS',
          detail: 'Đang đọc tin nhắn cho tài xế...',
          icon: Icons.volume_up_rounded,
          color: AppColors.success,
        ));
      });
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      setState(() {
        _logs.insert(0, _LogEntry(
          step: 'Gợi ý trả lời',
          detail: '3 gợi ý AI đã sẵn sàng',
          icon: Icons.reply_rounded,
          color: AppColors.warning,
        ));
      });
    });
  }

  @override
  void dispose() {
    _senderController.dispose();
    _messageController.dispose();
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
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_rounded, size: 20, color: textColor),
        ),
        title: Text(
          'Giả lập tin nhắn',
          style: AppTextStyles.titleLarge(color: textColor),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.science_rounded, size: 14, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(
                  'DEV',
                  style: AppTextStyles.labelSmall(color: AppColors.warning),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // ─── Input section ───
          Container(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border(
                bottom: BorderSide(color: borderColor),
              ),
            ),
            child: Column(
              children: [
                // Mode toggle
                Row(
                  children: [
                    Text(
                      'Chế độ:',
                      style: AppTextStyles.labelMedium(
                        color: subtextColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ChoiceChip(
                      label: Text(
                        '1-1',
                        style: AppTextStyles.labelSmall(
                          color: !_isGroup ? Colors.white : subtextColor,
                        ),
                      ),
                      selected: !_isGroup,
                      selectedColor: AppColors.primary,
                      backgroundColor: surfaceVariant,
                      side: BorderSide.none,
                      onSelected: (_) => setState(() => _isGroup = false),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text(
                        'Nhóm',
                        style: AppTextStyles.labelSmall(
                          color: _isGroup ? Colors.white : subtextColor,
                        ),
                      ),
                      selected: _isGroup,
                      selectedColor: const Color(0xFF6C63FF),
                      backgroundColor: surfaceVariant,
                      side: BorderSide.none,
                      onSelected: (_) => setState(() => _isGroup = true),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Sender
                TextField(
                  controller: _senderController,
                  style: AppTextStyles.bodyLarge(
                    color: textColor,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Người gửi',
                    labelStyle: AppTextStyles.bodySmall(
                      color: subtextColor,
                    ),
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 10),
                // Message
                TextField(
                  controller: _messageController,
                  style: AppTextStyles.bodyLarge(
                    color: textColor,
                  ),
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Nội dung tin nhắn',
                    labelStyle: AppTextStyles.bodySmall(
                      color: subtextColor,
                    ),
                    prefixIcon: const Icon(Icons.chat_bubble_outline_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                // Send button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _sendSimulated,
                    icon: const Icon(Icons.send_rounded, size: 20),
                    label: Text(
                      'Gửi tin giả lập',
                      style: AppTextStyles.labelLarge(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── Pipeline log ───
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Text(
                  'Pipeline Log',
                  style: AppTextStyles.titleMedium(color: textColor),
                ),
                const Spacer(),
                if (_logs.isNotEmpty)
                  TextButton(
                    onPressed: () => setState(() => _logs.clear()),
                    child: Text(
                      'Xóa log',
                      style: AppTextStyles.labelSmall(
                        color: AppColors.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: _logs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.terminal_rounded,
                          size: 48,
                          color: surfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Gửi tin nhắn để xem pipeline',
                          style: AppTextStyles.bodyMedium(
                            color: subtextColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      final log = _logs[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: log.color.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: log.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                log.icon,
                                color: log.color,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    log.step,
                                    style: AppTextStyles.labelMedium(
                                      color: log.color,
                                    ),
                                  ),
                                  Text(
                                    log.detail,
                                    style: AppTextStyles.bodySmall(
                                      color: subtextColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _LogEntry {
  final String step;
  final String detail;
  final IconData icon;
  final Color color;

  const _LogEntry({
    required this.step,
    required this.detail,
    required this.icon,
    required this.color,
  });
}
