import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  bool _driverModeOn = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _toggleDriverMode() {
    setState(() {
      _driverModeOn = !_driverModeOn;
      if (_driverModeOn) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
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

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBg : AppColors.lightBg,
          gradient: isDark ? AppColors.splashGradient : null,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // ─── Top bar ───
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: const Center(
                        child: Text(
                          'M',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Xin chào! 👋',
                            style: AppTextStyles.bodyMedium(
                              color: subtextColor,
                            ),
                          ),
                          Text(
                            'Minh',
                            style: AppTextStyles.titleLarge(
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification bell
                    _buildIconButton(Icons.notifications_outlined, () {}, surfaceVariant, borderColor, textColor),
                  ],
                ),

                const SizedBox(height: 32),

                // ─── Driver Mode Toggle ───
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Chế độ lái xe',
                        style: AppTextStyles.titleMedium(
                          color: subtextColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: _toggleDriverMode,
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _driverModeOn ? _pulseAnim.value : 1.0,
                              child: Container(
                                width: AppSpacing.driverModeButtonSize,
                                height: AppSpacing.driverModeButtonSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: _driverModeOn
                                      ? AppColors.driverModeGradient
                                      : null,
                                  color: _driverModeOn
                                      ? null
                                      : surfaceVariant,
                                  border: Border.all(
                                    color: _driverModeOn
                                        ? AppColors.driverModeGlow
                                        : borderColor,
                                    width: _driverModeOn ? 3 : 2,
                                  ),
                                  boxShadow: _driverModeOn
                                      ? [
                                          BoxShadow(
                                            color: AppColors.driverModeGlow
                                                .withValues(alpha: 0.4),
                                            blurRadius: 40,
                                            spreadRadius: 8,
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                                            blurRadius: 16,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _driverModeOn
                                          ? Icons.directions_car_rounded
                                          : Icons.directions_car_outlined,
                                      size: 48,
                                      color: _driverModeOn
                                          ? Colors.white
                                          : subtextColor,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _driverModeOn ? 'ĐANG BẬT' : 'TẮT',
                                      style: AppTextStyles.labelLarge(
                                        color: _driverModeOn
                                            ? Colors.white
                                            : subtextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: AppTextStyles.bodySmall(
                          color: _driverModeOn
                              ? AppColors.success
                              : subtextColor,
                        ),
                        child: Text(
                          _driverModeOn
                              ? '🟢 Đang nghe tin nhắn...'
                              : 'Nhấn để bắt đầu',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ─── Status cards ───
                Row(
                  children: [
                    Expanded(
                      child: _StatusCard(
                        icon: Icons.bluetooth_rounded,
                        label: 'ESP32',
                        status: 'Đã kết nối',
                        statusColor: AppColors.success,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatusCard(
                        icon: Icons.mic_rounded,
                        label: 'Mic',
                        status: _driverModeOn ? 'Đang nghe' : 'Tắt',
                        statusColor: _driverModeOn
                            ? AppColors.success
                            : subtextColor,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatusCard(
                        icon: Icons.volume_up_rounded,
                        label: 'TTS',
                        status: 'Sẵn sàng',
                        statusColor: AppColors.primary,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textColor: textColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ─── Recent message ───
                Text(
                  'Tin nhắn gần nhất',
                  style: AppTextStyles.titleMedium(color: textColor),
                ),
                const SizedBox(height: 12),
                _RecentMessageCard(
                  sender: 'Nguyễn Văn An',
                  message: 'Anh ơi đến đâu rồi? Em đợi ở quán cà phê nhé.',
                  time: '2 phút trước',
                  isGroup: false,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onTap: () => context.push('/messages/1'),
                ),
                const SizedBox(height: 8),
                _RecentMessageCard(
                  sender: 'Nhóm Công ty',
                  message: 'Sáng mai họp lúc 9h nhé mọi người...',
                  time: '15 phút trước',
                  isGroup: true,
                  surfaceColor: surfaceColor,
                  borderColor: borderColor,
                  textColor: textColor,
                  subtextColor: subtextColor,
                  onTap: () => context.push('/messages/2'),
                ),

                const SizedBox(height: 24),

                // ─── Quick actions ───
                Text(
                  'Thao tác nhanh',
                  style: AppTextStyles.titleMedium(color: textColor),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.mic_rounded,
                        label: 'Giọng nói',
                        gradient: AppColors.driverModeGradient,
                        subtextColor: subtextColor,
                        onTap: () => context.push('/voice'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.chat_bubble_rounded,
                        label: 'Tin nhắn',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF3F51B5)],
                        ),
                        subtextColor: subtextColor,
                        onTap: () => context.go('/messages'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.local_gas_station_rounded,
                        label: 'Trạm',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF30D158), Color(0xFF00A86B)],
                        ),
                        subtextColor: subtextColor,
                        onTap: () => context.push('/station-finder'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.sos_rounded,
                        label: 'SOS',
                        gradient: AppColors.sosGradient,
                        subtextColor: subtextColor,
                        onTap: () => context.push('/sos'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 100),
              ],
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

// ─── Status Card ───
class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String status;
  final Color statusColor;
  final Color surfaceColor;
  final Color borderColor;
  final Color textColor;

  const _StatusCard({
    required this.icon,
    required this.label,
    required this.status,
    required this.statusColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: statusColor, size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.labelSmall(color: textColor),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  status,
                  style: AppTextStyles.bodySmall(color: statusColor)
                      .copyWith(fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Recent Message Card ───
class _RecentMessageCard extends StatelessWidget {
  final String sender;
  final String message;
  final String time;
  final bool isGroup;
  final Color surfaceColor;
  final Color borderColor;
  final Color textColor;
  final Color subtextColor;
  final VoidCallback onTap;

  const _RecentMessageCard({
    required this.sender,
    required this.message,
    required this.time,
    required this.isGroup,
    required this.surfaceColor,
    required this.borderColor,
    required this.textColor,
    required this.subtextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isGroup
                    ? const Color(0xFF6C63FF).withValues(alpha: 0.2)
                    : AppColors.primary.withValues(alpha: 0.2),
              ),
              child: Icon(
                isGroup ? Icons.group_rounded : Icons.person_rounded,
                color: isGroup ? const Color(0xFF6C63FF) : AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          sender,
                          style: AppTextStyles.titleMedium(
                            color: textColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        time,
                        style: AppTextStyles.bodySmall(
                          color: subtextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: AppTextStyles.bodyMedium(
                      color: subtextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.volume_up_rounded,
              color: AppColors.primary.withValues(alpha: 0.6),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Quick Action Button ───
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final Color subtextColor;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.subtextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.labelSmall(
              color: subtextColor,
            ),
          ),
        ],
      ),
    );
  }
}
