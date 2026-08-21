import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../theme/theme_controller.dart';
import '../../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _vehicleType = 'VinFast VF8';
  double _ttsSpeed = 1.0;

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                Text(
                  'Cài đặt',
                  style: AppTextStyles.displayMedium(color: textColor),
                ),

                const SizedBox(height: 24),

                // ─── Profile ───
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        child: const Center(
                          child: Text(
                            'M',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Minh',
                              style: AppTextStyles.titleLarge(
                                color: textColor,
                              ),
                            ),
                            Text(
                              'minh@email.com',
                              style: AppTextStyles.bodyMedium(
                                color: subtextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: subtextColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ─── Giao diện ───
                _SectionTitle('Giao diện', subtextColor),
                _SettingsTile(
                  icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  iconColor: isDark ? AppColors.warning : const Color(0xFFFF9500),
                  title: 'Giao diện tối (Dark mode)',
                  subtitle: isDark ? 'Đang dùng giao diện tối' : 'Đang dùng giao diện sáng',
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  trailing: Switch(
                    value: isDark,
                    onChanged: (v) {
                      ThemeController.toggleTheme(v);
                    },
                    activeThumbColor: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 16),

                // ─── Phương tiện ───
                _SectionTitle('Phương tiện', subtextColor),
                _SettingsTile(
                  icon: Icons.electric_car_rounded,
                  iconColor: AppColors.success,
                  title: 'Loại xe',
                  subtitle: _vehicleType,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  trailing: DropdownButton<String>(
                    value: _vehicleType,
                    dropdownColor: surfaceColor,
                    underline: const SizedBox.shrink(),
                    style: AppTextStyles.bodyMedium(color: AppColors.primary),
                    items: [
                      'VinFast VF8',
                      'VinFast VF3',
                      'VinFast VF5',
                      'VinFast VF6',
                      'VinFast VF7',
                      'VinFast VF9',
                      'VinFast VFe34',
                      'Khác',
                    ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _vehicleType = v!),
                  ),
                ),

                const SizedBox(height: 16),

                // ─── TTS ───
                _SectionTitle('Giọng đọc (TTS)', subtextColor),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.record_voice_over_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Tốc độ đọc',
                            style: AppTextStyles.titleMedium(
                              color: textColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${_ttsSpeed.toStringAsFixed(1)}x',
                            style: AppTextStyles.labelLarge(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: AppColors.primary,
                          inactiveTrackColor: surfaceVariant,
                          thumbColor: AppColors.primary,
                          overlayColor: AppColors.primary.withValues(alpha: 0.1),
                        ),
                        child: Slider(
                          value: _ttsSpeed,
                          min: 0.5,
                          max: 2.0,
                          divisions: 6,
                          onChanged: (v) => setState(() => _ttsSpeed = v),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chậm',
                            style: AppTextStyles.bodySmall(
                              color: subtextColor,
                            ),
                          ),
                          Text(
                            'Nhanh',
                            style: AppTextStyles.bodySmall(
                              color: subtextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ─── Connections ───
                _SectionTitle('Kết nối', subtextColor),
                _SettingsTile(
                  icon: Icons.bluetooth_rounded,
                  iconColor: AppColors.primary,
                  title: 'Thiết bị BLE',
                  subtitle: '2 thiết bị đã ghép',
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onTap: () => context.push('/ble-settings'),
                ),
                _SettingsTile(
                  icon: Icons.sos_rounded,
                  iconColor: AppColors.error,
                  title: 'Số khẩn cấp SOS',
                  subtitle: '3 số đã cài',
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onTap: () => context.push('/sos'),
                ),
                _SettingsTile(
                  icon: Icons.reply_all_rounded,
                  iconColor: const Color(0xFF6C63FF),
                  title: 'Mẫu trả lời nhanh',
                  subtitle: '6 mẫu',
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onTap: () => context.push('/quick-reply'),
                ),

                const SizedBox(height: 16),

                // ─── App ───
                _SectionTitle('Ứng dụng', subtextColor),
                _SettingsTile(
                  icon: Icons.language_rounded,
                  iconColor: AppColors.info,
                  title: 'Ngôn ngữ',
                  subtitle: 'Tiếng Việt',
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                ),
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  iconColor: subtextColor,
                  title: 'Về ứng dụng',
                  subtitle: 'Version 1.0.0',
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                ),

                const SizedBox(height: 16),

                // ─── Logout ───
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: AppColors.error.withValues(alpha: 0.2),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      leading: const Icon(
                        Icons.logout_rounded,
                        color: AppColors.error,
                      ),
                      title: Text(
                        'Đăng xuất',
                        style: AppTextStyles.titleMedium(
                          color: AppColors.error,
                        ),
                      ),
                      onTap: () async {
                        await AuthService.logout();
                        if (context.mounted) {
                          context.go('/login');
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionTitle(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: AppTextStyles.labelMedium(
          color: color,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color surfaceColor;
  final Color borderColor;
  final Color textColor;
  final Color subtextColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.surfaceColor,
    required this.borderColor,
    required this.textColor,
    required this.subtextColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          title: Text(
            title,
            style: AppTextStyles.titleMedium(color: textColor),
          ),
          subtitle: Text(
            subtitle,
            style: AppTextStyles.bodySmall(
              color: subtextColor,
            ),
          ),
          trailing: trailing ??
              (onTap != null
                  ? Icon(
                      Icons.chevron_right_rounded,
                      color: subtextColor,
                    )
                  : null),
          onTap: onTap,
        ),
      ),
    );
  }
}
