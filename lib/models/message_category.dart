import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Danh mục tin nhắn được phân loại tự động bởi LLM On-Device (Qwen3-1.7B)
enum MessageCategory {
  family,
  work,
  friends,
  emergency,
  finance,
  general,
}

extension MessageCategoryExtension on MessageCategory {
  String get displayName {
    switch (this) {
      case MessageCategory.family:
        return 'Gia đình';
      case MessageCategory.work:
        return 'Công việc';
      case MessageCategory.friends:
        return 'Bạn bè';
      case MessageCategory.emergency:
        return 'Khẩn cấp';
      case MessageCategory.finance:
        return 'Tài chính';
      case MessageCategory.general:
        return 'Chung';
    }
  }

  IconData get icon {
    switch (this) {
      case MessageCategory.family:
        return Icons.family_restroom_rounded;
      case MessageCategory.work:
        return Icons.work_rounded;
      case MessageCategory.friends:
        return Icons.people_alt_rounded;
      case MessageCategory.emergency:
        return Icons.warning_amber_rounded;
      case MessageCategory.finance:
        return Icons.account_balance_wallet_rounded;
      case MessageCategory.general:
        return Icons.chat_bubble_outline_rounded;
    }
  }

  Color get color {
    switch (this) {
      case MessageCategory.family:
        return AppColors.familyPurple;
      case MessageCategory.work:
        return AppColors.workCyan;
      case MessageCategory.friends:
        return AppColors.friendsGreen;
      case MessageCategory.emergency:
        return AppColors.urgentRed;
      case MessageCategory.finance:
        return AppColors.financeGold;
      case MessageCategory.general:
        return AppColors.primary;
    }
  }

  LinearGradient get gradient {
    switch (this) {
      case MessageCategory.family:
        return const LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
        );
      case MessageCategory.work:
        return const LinearGradient(
          colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
        );
      case MessageCategory.friends:
        return const LinearGradient(
          colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
        );
      case MessageCategory.emergency:
        return const LinearGradient(
          colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
        );
      case MessageCategory.finance:
        return const LinearGradient(
          colors: [Color(0xFFF7971E), Color(0xFFFFD200)],
        );
      case MessageCategory.general:
        return const LinearGradient(
          colors: [Color(0xFF0A84FF), Color(0xFF0066CC)],
        );
    }
  }
}

/// Mức độ quan trọng của tin nhắn được đánh giá bởi LLM
enum MessagePriority {
  urgent, // Khẩn cấp / Rất quan trọng
  important, // Quan trọng (cần chú ý / hẹn giờ)
  normal, // Bình thường
}

extension MessagePriorityExtension on MessagePriority {
  String get label {
    switch (this) {
      case MessagePriority.urgent:
        return 'KHẨN CẤP';
      case MessagePriority.important:
        return 'QUAN TRỌNG';
      case MessagePriority.normal:
        return 'BÌNH THƯỜNG';
    }
  }

  Color get color {
    switch (this) {
      case MessagePriority.urgent:
        return AppColors.urgentRed;
      case MessagePriority.important:
        return AppColors.importantAmber;
      case MessagePriority.normal:
        return AppColors.darkOnSurfaceVariant;
    }
  }

  IconData get icon {
    switch (this) {
      case MessagePriority.urgent:
        return Icons.error_rounded;
      case MessagePriority.important:
        return Icons.local_fire_department_rounded;
      case MessagePriority.normal:
        return Icons.lens_rounded;
    }
  }
}

/// Dữ liệu một cuộc hội thoại kèm metadata phân loại LLM
class ConversationItem {
  final String id;
  final String name;
  final String lastMessage;
  final String aiSummary; // Tóm tắt ý chính từ LLM
  final String time;
  final bool isGroup;
  final int unreadCount;
  final MessageCategory category;
  final MessagePriority priority;
  final String avatarInitials;

  const ConversationItem({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.aiSummary,
    required this.time,
    required this.isGroup,
    required this.unreadCount,
    required this.category,
    required this.priority,
    required this.avatarInitials,
  });
}
