import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../models/message_category.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String _selectedFilter = 'all';

  final List<ConversationItem> _allConversations = const [
    ConversationItem(
      id: '1',
      name: 'Nguyễn Văn An',
      lastMessage: 'Anh ơi đến đâu rồi? Em đợi ở quán cà phê nhé.',
      aiSummary: 'Hẹn gặp tại quán cà phê, đang đợi',
      time: '2 phút trước',
      isGroup: false,
      unreadCount: 2,
      category: MessageCategory.friends,
      priority: MessagePriority.important,
      avatarInitials: 'AN',
    ),
    ConversationItem(
      id: '2',
      name: 'Nhóm Dự án VinFast',
      lastMessage: 'Sáng mai họp lúc 9h nhé mọi người, nhớ chuẩn bị báo cáo tiến độ.',
      aiSummary: 'Lịch họp 9h sáng mai + Chuẩn bị báo cáo',
      time: '15 phút trước',
      isGroup: true,
      unreadCount: 5,
      category: MessageCategory.work,
      priority: MessagePriority.important,
      avatarInitials: 'VF',
    ),
    ConversationItem(
      id: '3',
      name: 'Vợ Yêu ❤️',
      lastMessage: 'Chiều về ghé siêu thị mua sữa cho con nhé anh yêu!',
      aiSummary: 'Nhắc mua sữa cho con trên đường về',
      time: '35 phút trước',
      isGroup: false,
      unreadCount: 1,
      category: MessageCategory.family,
      priority: MessagePriority.urgent,
      avatarInitials: 'VY',
    ),
    ConversationItem(
      id: '4',
      name: 'Ngân hàng VCB',
      lastMessage: 'TK 007100... biến động: +15,000,000 VND. Số dư: 45,230,000 VND.',
      aiSummary: 'Nhận tiền +15,000,000 VND từ đối tác',
      time: '1 giờ trước',
      isGroup: false,
      unreadCount: 0,
      category: MessageCategory.finance,
      priority: MessagePriority.normal,
      avatarInitials: 'VCB',
    ),
    ConversationItem(
      id: '5',
      name: 'Nhóm Bạn Phượt',
      lastMessage: 'Cuối tuần này cung Tây Bắc thời tiết đẹp lắm, anh em chốt xe nhé!',
      aiSummary: 'Kế hoạch phượt Tây Bắc cuối tuần',
      time: '3 giờ trước',
      isGroup: true,
      unreadCount: 0,
      category: MessageCategory.friends,
      priority: MessagePriority.normal,
      avatarInitials: 'BP',
    ),
    ConversationItem(
      id: '6',
      name: 'Lê Minh Tuấn',
      lastMessage: 'OK, gặp nhau lúc 7h sáng mai tại trạm sạc VinFast Landmark 81.',
      aiSummary: 'Chốt hẹn 7h sáng mai tại trạm sạc Landmark 81',
      time: 'Hôm qua',
      isGroup: false,
      unreadCount: 0,
      category: MessageCategory.work,
      priority: MessagePriority.normal,
      avatarInitials: 'MT',
    ),
  ];

  List<ConversationItem> get _filteredConversations {
    if (_selectedFilter == 'important') {
      return _allConversations.where((c) => c.priority == MessagePriority.important || c.priority == MessagePriority.urgent).toList();
    }
    if (_selectedFilter == 'family') {
      return _allConversations.where((c) => c.category == MessageCategory.family).toList();
    }
    if (_selectedFilter == 'work') {
      return _allConversations.where((c) => c.category == MessageCategory.work).toList();
    }
    if (_selectedFilter == 'friends') {
      return _allConversations.where((c) => c.category == MessageCategory.friends).toList();
    }
    if (_selectedFilter == 'emergency') {
      return _allConversations.where((c) => c.priority == MessagePriority.urgent || c.category == MessageCategory.emergency).toList();
    }
    return _allConversations;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceVariant = isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? Colors.white : AppColors.lightOnSurface;
    final subtextColor = isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ───
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding, 16, AppSpacing.screenPadding, 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tin nhắn',
                      style: AppTextStyles.displayMedium(color: textColor),
                    ),
                  ),
                  _buildIconButton(
                    Icons.search_rounded, () {},
                    surfaceVariant, borderColor, textColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // ─── Filter Chips (Clean, no glow) ───
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                children: [
                  _FilterChip(label: 'Tất cả', isSelected: _selectedFilter == 'all', isDark: isDark, onTap: () => setState(() => _selectedFilter = 'all')),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Quan trọng', isSelected: _selectedFilter == 'important', isDark: isDark, onTap: () => setState(() => _selectedFilter = 'important')),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Khẩn cấp', isSelected: _selectedFilter == 'emergency', isDark: isDark, onTap: () => setState(() => _selectedFilter = 'emergency')),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Gia đình', isSelected: _selectedFilter == 'family', isDark: isDark, onTap: () => setState(() => _selectedFilter = 'family')),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Công việc', isSelected: _selectedFilter == 'work', isDark: isDark, onTap: () => setState(() => _selectedFilter = 'work')),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Bạn bè', isSelected: _selectedFilter == 'friends', isDark: isDark, onTap: () => setState(() => _selectedFilter = 'friends')),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ─── Message List ───
            Expanded(
              child: _filteredConversations.isEmpty
                  ? Center(
                      child: Text(
                        'Không có tin nhắn nào trong mục này',
                        style: AppTextStyles.bodyMedium(color: subtextColor),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        left: AppSpacing.screenPadding,
                        right: AppSpacing.screenPadding,
                        bottom: 96,
                      ),
                      itemCount: _filteredConversations.length,
                      itemBuilder: (context, index) {
                        final item = _filteredConversations[index];
                        return _ConversationCard(
                          item: item,
                          isDark: isDark,
                          onTap: () => context.push('/messages/${item.id}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // FAB: Giả lập tin nhắn
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          onPressed: () => context.push('/simulator'),
          backgroundColor: AppColors.primary,
          elevation: 2,
          icon: const Icon(Icons.science_rounded, color: Colors.white),
          label: Text(
            'Giả lập',
            style: AppTextStyles.labelMedium(color: Colors.white).copyWith(
              fontWeight: FontWeight.bold,
            ),
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

// ─── Filter Chip (Simple, clean — no glow, no neon) ───
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.primary.withValues(alpha: 0.1))
              : (isDark ? AppColors.darkSurfaceVariant : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 1.2 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (isDark ? Colors.white : AppColors.primary)
                : (isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ─── Conversation Card (Minimalist, clean) ───
class _ConversationCard extends StatelessWidget {
  final ConversationItem item;
  final bool isDark;
  final VoidCallback onTap;

  const _ConversationCard({
    required this.item,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = item.unreadCount > 0;
    final isUrgent = item.priority == MessagePriority.urgent;
    final isImportant = item.priority == MessagePriority.important;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              border: Border.all(
                color: isDark
                    ? AppColors.darkBorder.withValues(alpha: 0.5)
                    : AppColors.lightBorder.withValues(alpha: 0.5),
                width: 0.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar — simple circle with initials
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.primary.withValues(alpha: 0.08),
                  ),
                  child: Center(
                    child: Text(
                      item.avatarInitials,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name row + time
                      Row(
                        children: [
                          if (item.isGroup)
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                Icons.groups_rounded,
                                size: 14,
                                color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              item.name,
                              style: AppTextStyles.titleMedium(
                                color: isDark ? Colors.white : AppColors.lightOnSurface,
                              ).copyWith(
                                fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            item.time,
                            style: TextStyle(
                              color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Last message
                      Text(
                        item.lastMessage,
                        style: TextStyle(
                          color: hasUnread
                              ? (isDark ? Colors.white : AppColors.lightOnSurface)
                              : (isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant),
                          fontSize: 13,
                          fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 6),

                      // AI tags row — subtle text-only labels
                      Row(
                        children: [
                          _MiniTag(
                            text: item.category.displayName,
                            color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant,
                          ),
                          if (isUrgent || isImportant) ...[
                            const SizedBox(width: 8),
                            _MiniTag(
                              text: item.priority.label,
                              color: isUrgent ? AppColors.urgentRed : AppColors.importantAmber,
                            ),
                          ],
                          const Spacer(),
                          if (hasUnread)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${item.unreadCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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

// ─── Tiny text-only tag ───
class _MiniTag extends StatelessWidget {
  final String text;
  final Color color;

  const _MiniTag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 10.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}
