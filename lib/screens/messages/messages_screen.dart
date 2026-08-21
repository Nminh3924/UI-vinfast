import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surfaceVariant = isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? Colors.white : AppColors.lightOnSurface;
    final subtextColor = isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBg : AppColors.lightBg,
          gradient: isDark ? AppColors.splashGradient : null,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Header ───
              Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tin nhắn',
                        style: AppTextStyles.displayMedium(color: textColor),
                      ),
                    ),
                    _buildIconButton(Icons.search_rounded, () {}, surfaceVariant, borderColor, textColor),
                  ],
                ),
              ),

              // ─── Search bar ───
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: surfaceVariant,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      Icon(
                        Icons.search_rounded,
                        color: subtextColor,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tìm kiếm cuộc trò chuyện...',
                          style: AppTextStyles.bodyMedium(
                            color: subtextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ─── Message list ───
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.screenPadding,
                    right: AppSpacing.screenPadding,
                    bottom: 90,
                  ),
                  children: [
                    _ConversationTile(
                      name: 'Nguyễn Văn An',
                      lastMessage: 'Anh ơi đến đâu rồi? Em đợi ở quán cà phê nhé.',
                      time: '2 phút',
                      isGroup: false,
                      unreadCount: 2,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      subtextColor: subtextColor,
                      onTap: () => context.push('/messages/1'),
                    ),
                    _ConversationTile(
                      name: 'Nhóm Công ty',
                      lastMessage: 'Sáng mai họp lúc 9h nhé mọi người...',
                      time: '15 phút',
                      isGroup: true,
                      unreadCount: 5,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      subtextColor: subtextColor,
                      onTap: () => context.push('/messages/2'),
                    ),
                    _ConversationTile(
                      name: 'Trần Thị Hoa',
                      lastMessage: 'Cảm ơn anh nhé! 😊',
                      time: '1 giờ',
                      isGroup: false,
                      unreadCount: 0,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      subtextColor: subtextColor,
                      onTap: () => context.push('/messages/3'),
                    ),
                    _ConversationTile(
                      name: 'Nhóm Gia đình',
                      lastMessage: 'Cuối tuần mình đi chơi nha',
                      time: '3 giờ',
                      isGroup: true,
                      unreadCount: 0,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      subtextColor: subtextColor,
                      onTap: () => context.push('/messages/4'),
                    ),
                    _ConversationTile(
                      name: 'Lê Minh Tuấn',
                      lastMessage: 'OK, gặp nhau lúc 7h sáng mai.',
                      time: 'Hôm qua',
                      isGroup: false,
                      unreadCount: 0,
                      surfaceColor: surfaceColor,
                      borderColor: borderColor,
                      textColor: textColor,
                      subtextColor: subtextColor,
                      onTap: () => context.push('/messages/5'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // FAB: Giả lập tin nhắn
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          onPressed: () => context.push('/simulator'),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.science_rounded, color: Colors.white),
          label: Text(
            'Giả lập',
            style: AppTextStyles.labelMedium(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, Color surfaceVariant, Color borderColor, Color textColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Icon(icon, color: textColor, size: 22),
      ),
    );
  }
}

// ─── Conversation Tile ───
class _ConversationTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final bool isGroup;
  final int unreadCount;
  final Color surfaceColor;
  final Color borderColor;
  final Color textColor;
  final Color subtextColor;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.isGroup,
    required this.unreadCount,
    required this.surfaceColor,
    required this.borderColor,
    required this.textColor,
    required this.subtextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: unreadCount > 0
                ? AppColors.primary.withValues(alpha: 0.3)
                : borderColor,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isGroup
                        ? const Color(0xFF6C63FF).withValues(alpha: 0.15)
                        : AppColors.primary.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    isGroup ? Icons.group_rounded : Icons.person_rounded,
                    color: isGroup ? const Color(0xFF6C63FF) : AppColors.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isGroup)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Icon(
                                Icons.groups_rounded,
                                size: 14,
                                color: subtextColor,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              name,
                              style: AppTextStyles.titleMedium(
                                color: unreadCount > 0
                                    ? AppColors.primary
                                    : textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            time,
                            style: AppTextStyles.bodySmall(
                              color: unreadCount > 0
                                  ? AppColors.primary
                                  : subtextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lastMessage,
                              style: AppTextStyles.bodyMedium(
                                color: unreadCount > 0
                                    ? textColor
                                    : subtextColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$unreadCount',
                                style: AppTextStyles.labelSmall(color: Colors.white)
                                    .copyWith(fontSize: 11),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
