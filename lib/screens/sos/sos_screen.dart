import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  bool _isSending = false;
  bool _sent = false;

  final List<_EmergencyContact> _contacts = [
    _EmergencyContact(name: 'Cứu hộ VinFast 24/7', phone: '1900 23 23 89'),
    _EmergencyContact(name: 'Vợ', phone: '0912 345 678'),
    _EmergencyContact(name: 'Cứu hộ Giao thông', phone: '113'),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _sendSOS() async {
    setState(() => _isSending = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isSending = false;
      _sent = true;
    });
  }

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
          'SOS Khẩn cấp',
          style: AppTextStyles.titleLarge(color: AppColors.error),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ─── SOS Button ───
            Center(
              child: GestureDetector(
                onLongPress: _isSending || _sent ? null : _sendSOS,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _sent ? 1.0 : _pulseAnim.value,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: _sent
                              ? const LinearGradient(
                                  colors: [AppColors.success, Color(0xFF00A86B)],
                                )
                              : AppColors.sosGradient,
                          boxShadow: [
                            BoxShadow(
                              color: (_sent
                                      ? AppColors.success
                                      : AppColors.error)
                                  .withValues(alpha: 0.4),
                              blurRadius: 40,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: _isSending
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _sent
                                        ? Icons.check_rounded
                                        : Icons.sos_rounded,
                                    color: Colors.white,
                                    size: 56,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _sent ? 'ĐÃ GỬI' : 'SOS',
                                    style: AppTextStyles.headlineLarge(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              _sent
                  ? '✅ Đã gửi SMS thành công!'
                  : '⚠️ Nhấn giữ 3 giây để gửi SOS',
              style: AppTextStyles.bodyLarge(
                color: _sent ? AppColors.success : AppColors.warning,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            if (!_sent)
              Text(
                'SMS kèm vị trí GPS sẽ được gửi\nđến các số khẩn cấp bên dưới',
                style: AppTextStyles.bodyMedium(
                  color: subtextColor,
                ),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 32),

            // ─── GPS Location ───
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vị trí GPS hiện tại',
                          style: AppTextStyles.labelMedium(
                            color: textColor,
                          ),
                        ),
                        Text(
                          '10.8231° N, 106.6297° E',
                          style: AppTextStyles.bodySmall(
                            color: subtextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.gps_fixed_rounded,
                    color: AppColors.success,
                    size: 20,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─── Emergency contacts ───
            Row(
              children: [
                Text(
                  'Số khẩn cấp',
                  style: AppTextStyles.titleMedium(color: textColor),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_rounded, size: 16, color: AppColors.primary),
                  label: Text(
                    'Chỉnh sửa',
                    style: AppTextStyles.labelSmall(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ..._contacts.map((contact) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.error.withValues(alpha: 0.1),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.error,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              contact.name,
                              style: AppTextStyles.labelMedium(
                                color: textColor,
                              ),
                            ),
                            Text(
                              contact.phone,
                              style: AppTextStyles.bodySmall(
                                color: subtextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_sent)
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.success,
                          size: 22,
                        ),
                    ],
                  ),
                )),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _EmergencyContact {
  final String name;
  final String phone;
  _EmergencyContact({required this.name, required this.phone});
}
