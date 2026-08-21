import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';

class QuickReplyScreen extends StatefulWidget {
  const QuickReplyScreen({super.key});

  @override
  State<QuickReplyScreen> createState() => _QuickReplyScreenState();
}

class _QuickReplyScreenState extends State<QuickReplyScreen> {
  final List<String> _templates = [
    'Tôi đang lái xe, gọi lại sau nhé!',
    'OK, anh/chị nhé!',
    'Sắp đến rồi, 5 phút nữa thôi!',
    'Cảm ơn bạn!',
    'Đang bận, nhắn tin sau nhé.',
    'Anh/chị gọi lại giúp em nhé.',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
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
          'Trả lời nhanh',
          style: AppTextStyles.titleLarge(color: textColor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Text(
              'Quản lý các mẫu trả lời nhanh. Kéo để sắp xếp lại thứ tự.',
              style: AppTextStyles.bodyMedium(
                color: subtextColor,
              ),
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              itemCount: _templates.length,
              onReorderItem: (oldIndex, newIndex) {
                setState(() {
                  final item = _templates.removeAt(oldIndex);
                  _templates.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                return _TemplateCard(
                  key: ValueKey(_templates[index]),
                  text: _templates[index],
                  index: index,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onDelete: () {
                    setState(() => _templates.removeAt(index));
                  },
                  onEdit: () => _showEditDialog(index, surfaceColor, textColor),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(surfaceColor, textColor),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          'Thêm mẫu',
          style: AppTextStyles.labelMedium(color: Colors.white),
        ),
      ),
    );
  }

  void _showAddDialog(Color surfaceColor, Color textColor) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Thêm mẫu mới',
          style: AppTextStyles.titleLarge(color: textColor),
        ),
        content: TextField(
          controller: controller,
          style: AppTextStyles.bodyLarge(color: textColor),
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Nhập nội dung trả lời nhanh...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => _templates.add(controller.text.trim()));
                Navigator.pop(ctx);
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int index, Color surfaceColor, Color textColor) {
    final controller = TextEditingController(text: _templates[index]);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Chỉnh sửa mẫu',
          style: AppTextStyles.titleLarge(color: textColor),
        ),
        content: TextField(
          controller: controller,
          style: AppTextStyles.bodyLarge(color: textColor),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => _templates[index] = controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final String text;
  final int index;
  final Color surfaceColor;
  final Color borderColor;
  final Color textColor;
  final Color subtextColor;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _TemplateCard({
    super.key,
    required this.text,
    required this.index,
    required this.surfaceColor,
    required this.borderColor,
    required this.textColor,
    required this.subtextColor,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Icon(
            Icons.drag_handle_rounded,
            color: subtextColor,
          ),
          title: Text(
            text,
            style: AppTextStyles.bodyLarge(color: textColor),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
