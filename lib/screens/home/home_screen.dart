import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../models/message_category.dart';
import '../../widgets/vinfast_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  bool _driverModeOn = false;

  // Controllers for Standalone Engine Start Button
  late AnimationController _glowController;
  late AnimationController _rippleController;
  late AnimationController _pressController;

  @override
  void initState() {
    super.initState();
    // Continuous breathing halo when active
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Expanding shockwave ripple on start
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    // Physical button recoil press
    _pressController = AnimationController(
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.06,
      vsync: this,
    );
  }

  void _toggleDriverMode() {
    _pressController.forward().then((_) => _pressController.reverse());
    setState(() {
      _driverModeOn = !_driverModeOn;
      if (_driverModeOn) {
        _glowController.repeat(reverse: true);
        _rippleController.repeat();
      } else {
        _glowController.stop();
        _glowController.reset();
        _rippleController.stop();
        _rippleController.reset();
      }
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _rippleController.dispose();
    _pressController.dispose();
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
        color: isDark ? AppColors.darkBg : AppColors.lightBg,
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
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.darkSurfaceVariant
                            : const Color(0xFFE2E8F0),
                      ),
                      child: Center(
                        child: Text(
                          'M',
                          style: TextStyle(
                            color: isDark ? Colors.white : AppColors.lightOnSurface,
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
                            style: AppTextStyles.bodyMedium(color: subtextColor),
                          ),
                          Text(
                            'Minh',
                            style: AppTextStyles.titleLarge(color: textColor),
                          ),
                        ],
                      ),
                    ),
                    _buildIconButton(
                      Icons.notifications_outlined, () {},
                      surfaceVariant, borderColor, textColor,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ─── Standalone Circular VinFast Engine Start Button (Không khung bao) ───
                Center(
                  child: _StandaloneVinFastStartButton(
                    driverModeOn: _driverModeOn,
                    glowController: _glowController,
                    rippleController: _rippleController,
                    pressController: _pressController,
                    isDark: isDark,
                    onTap: _toggleDriverMode,
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
                        isActive: true,
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textColor: textColor,
                        subtextColor: subtextColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatusCard(
                        icon: Icons.mic_rounded,
                        label: 'Mic',
                        status: _driverModeOn ? 'Đang nghe' : 'Tắt',
                        isActive: _driverModeOn,
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textColor: textColor,
                        subtextColor: subtextColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatusCard(
                        icon: Icons.volume_up_rounded,
                        label: 'TTS',
                        status: 'Sẵn sàng',
                        isActive: true,
                        isDark: isDark,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        textColor: textColor,
                        subtextColor: subtextColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ─── Recent messages ───
                Text(
                  'Tin nhắn gần nhất',
                  style: AppTextStyles.titleMedium(color: textColor),
                ),
                const SizedBox(height: 12),
                _RecentMessageCard(
                  sender: 'Vợ Yêu 💚',
                  message: 'Chiều về ghé siêu thị mua sữa cho con nhé anh yêu!',
                  time: '35 phút trước',
                  category: MessageCategory.family,
                  priority: MessagePriority.urgent,
                  isDark: isDark,
                  onTap: () => context.push('/messages/3'),
                ),
                _RecentMessageCard(
                  sender: 'Nguyễn Văn An',
                  message: 'Anh ơi đến đâu rồi? Em đợi ở quán cà phê nhé.',
                  time: '2 phút trước',
                  category: MessageCategory.friends,
                  priority: MessagePriority.important,
                  isDark: isDark,
                  onTap: () => context.push('/messages/1'),
                ),
                _RecentMessageCard(
                  sender: 'Nhóm Dự án VinFast',
                  message: 'Sáng mai họp lúc 9h nhé mọi người, nhớ chuẩn bị báo cáo...',
                  time: '15 phút trước',
                  category: MessageCategory.work,
                  priority: MessagePriority.important,
                  isDark: isDark,
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
                        color: AppColors.primary,
                        isDark: isDark,
                        onTap: () => context.push('/voice'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.chat_bubble_rounded,
                        label: 'Tin nhắn',
                        color: const Color(0xFF6C63FF),
                        isDark: isDark,
                        onTap: () => context.go('/messages'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.ev_station_rounded,
                        label: 'Trạm sạc',
                        color: AppColors.success,
                        isDark: isDark,
                        onTap: () => context.push('/station-finder'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.sos_rounded,
                        label: 'SOS',
                        color: AppColors.error,
                        isDark: isDark,
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

// ══════════════════════════════════════════════════════════════════════════════
// ─── STANDALONE CIRCULAR VINFAST ENGINE START BUTTON (CHỈ CÓ NÚT TRÒN ĐỘC LẬP) 
// ══════════════════════════════════════════════════════════════════════════════
class _StandaloneVinFastStartButton extends StatelessWidget {
  final bool driverModeOn;
  final AnimationController glowController;
  final AnimationController rippleController;
  final AnimationController pressController;
  final bool isDark;
  final VoidCallback onTap;

  const _StandaloneVinFastStartButton({
    required this.driverModeOn,
    required this.glowController,
    required this.rippleController,
    required this.pressController,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final subtextColor = isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant;
    final textColor = isDark ? Colors.white : AppColors.lightOnSurface;

    const buttonSize = 160.0;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedBuilder(
            animation: Listenable.merge([glowController, rippleController, pressController]),
            builder: (context, child) {
              final glowVal = glowController.value;
              final rippleVal = rippleController.value;
              final scale = 1.0 - pressController.value;

              return SizedBox(
                width: buttonSize + 60,
                height: buttonSize + 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1. Sóng xung kích phát quang khi đang BẬT
                    if (driverModeOn)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _PureShockwavePainter(
                            progress: rippleVal,
                            color: AppColors.cyanAccent,
                          ),
                        ),
                      ),

                    // 2. Hào quang Neon Cyan tỏa sáng êm ái
                    if (driverModeOn)
                      Container(
                        width: buttonSize,
                        height: buttonSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cyanAccent.withValues(alpha: 0.45 * (0.7 + 0.3 * glowVal)),
                              blurRadius: 36 * (0.8 + 0.2 * glowVal),
                              spreadRadius: 4,
                            ),
                            BoxShadow(
                              color: const Color(0xFF0066FF).withValues(alpha: 0.3),
                              blurRadius: 50,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                      ),

                    // 3. Thân Nút Tròn 3D Kim Loại Chuẩn Xe VinFast
                    Transform.scale(
                      scale: scale,
                      child: Container(
                        width: buttonSize,
                        height: buttonSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // Vành ngoài Titan
                          gradient: SweepGradient(
                            colors: isDark
                                ? [
                                    const Color(0xFF38383C),
                                    const Color(0xFF1C1C20),
                                    const Color(0xFF4A4A50),
                                    const Color(0xFF1C1C20),
                                    const Color(0xFF38383C),
                                  ]
                                : [
                                    const Color(0xFFCBD5E1),
                                    const Color(0xFF94A3B8),
                                    const Color(0xFFF1F5F9),
                                    const Color(0xFF94A3B8),
                                    const Color(0xFFCBD5E1),
                                  ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.7 : 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // Lòng nút chuyển sắc sâu
                              gradient: RadialGradient(
                                center: const Alignment(-0.15, -0.2),
                                radius: 0.85,
                                colors: isDark
                                    ? [
                                        driverModeOn ? const Color(0xFF122438) : const Color(0xFF202024),
                                        const Color(0xFF101014),
                                        const Color(0xFF060608),
                                      ]
                                    : [
                                        driverModeOn ? const Color(0xFFE5F5FF) : Colors.white,
                                        const Color(0xFFF1F5F9),
                                        const Color(0xFFCBD5E1),
                                      ],
                              ),
                              border: Border.all(
                                color: driverModeOn
                                    ? AppColors.cyanAccent
                                    : (isDark ? const Color(0xFF2E2E34) : const Color(0xFF94A3B8)),
                                width: driverModeOn ? 2.0 : 1.2,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Top: "ENGINE" + Chấm LED
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: driverModeOn ? AppColors.success : const Color(0xFF48484A),
                                          boxShadow: driverModeOn
                                              ? [
                                                  BoxShadow(
                                                    color: AppColors.success.withValues(alpha: 0.9),
                                                    blurRadius: 6,
                                                  ),
                                                ]
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'ENGINE',
                                        style: TextStyle(
                                          color: driverModeOn
                                              ? (isDark ? Colors.white : AppColors.lightOnSurface)
                                              : subtextColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 2.2,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Center: Logo VinFast 3D Kim Loại
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      if (driverModeOn)
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.cyanAccent.withValues(alpha: 0.6),
                                                blurRadius: 20,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                      const VinFastLogo(size: 52, fit: BoxFit.contain),
                                    ],
                                  ),

                                  // Bottom: "START / STOP"
                                  Text(
                                    driverModeOn ? 'START' : 'START / STOP',
                                    style: TextStyle(
                                      color: driverModeOn ? AppColors.cyanAccent : subtextColor,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // ─── Status Text below button ───
        Text(
          'CHẾ ĐỘ LÁI XE',
          style: TextStyle(
            color: subtextColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            color: driverModeOn ? AppColors.success : textColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
          child: Text(
            driverModeOn ? 'ĐANG BẬT' : 'TẮT',
          ),
        ),
        const SizedBox(height: 4),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            driverModeOn
                ? '🟢 Đang lắng nghe & đọc tin nhắn rảnh tay'
                : 'Chạm nút để khởi động chế độ rảnh tay',
            key: ValueKey<bool>(driverModeOn),
            style: TextStyle(
              color: driverModeOn
                  ? AppColors.success.withValues(alpha: 0.9)
                  : subtextColor.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Custom Painter: Sóng xung kích tròn bung tỏa độc lập ───
class _PureShockwavePainter extends CustomPainter {
  final double progress;
  final Color color;

  _PureShockwavePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    final minRadius = maxRadius * 0.65;

    for (int i = 0; i < 2; i++) {
      final p = (progress + i * 0.5) % 1.0;
      final currentRadius = minRadius + (maxRadius - minRadius) * p;
      final alpha = ((1.0 - p) * 0.6).clamp(0.0, 1.0);

      final wavePaint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5 * (1.0 - p)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(center, currentRadius, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PureShockwavePainter oldDelegate) => true;
}

// ─── Status Card ───
class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String status;
  final bool isActive;
  final bool isDark;
  final Color surfaceColor;
  final Color borderColor;
  final Color textColor;
  final Color subtextColor;

  const _StatusCard({
    required this.icon,
    required this.label,
    required this.status,
    required this.isActive,
    required this.isDark,
    required this.surfaceColor,
    required this.borderColor,
    required this.textColor,
    required this.subtextColor,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isActive ? AppColors.success : subtextColor;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(icon, color: subtextColor, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
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
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
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

// ─── Recent Message Card (divider style) ───
class _RecentMessageCard extends StatelessWidget {
  final String sender;
  final String message;
  final String time;
  final MessageCategory category;
  final MessagePriority priority;
  final bool isDark;
  final VoidCallback onTap;

  const _RecentMessageCard({
    required this.sender,
    required this.message,
    required this.time,
    required this.category,
    required this.priority,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUrgent = priority == MessagePriority.urgent;
    final isImportant = priority == MessagePriority.important;
    final subtextColor = isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.lightOnSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isDark
                    ? AppColors.darkBorder.withValues(alpha: 0.5)
                    : const Color(0xFFE2E8F0),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            sender,
                            style: TextStyle(
                              color: isDark ? Colors.white : AppColors.lightOnSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(color: subtextColor, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      message,
                      style: TextStyle(color: subtextColor, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          category.displayName,
                          style: TextStyle(
                            color: subtextColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isUrgent || isImportant) ...[
                          Text('  ', style: TextStyle(color: subtextColor, fontSize: 11)),
                          Text(
                            priority.label,
                            style: TextStyle(
                              color: subtextColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFCBD5E1),
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

// ─── Quick Action Button ───
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
