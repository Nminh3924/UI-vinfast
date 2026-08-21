import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'vinfast_logo.dart';

/// Taskbar cách điệu cao cấp mô phỏng mặt ca-lăng xe VinFast:
/// - Nền liền mạch nguyên khối theo dáng ca-lăng xe sang.
/// - 2 dải LED cánh chim phát quang chuyển màu Gradient (Cyan -> Xenon White), dừng ở 2/3 chữ V.
/// - Họa tiết lưới tản nhiệt kim cương 3D chìm rõ nét ở cả Dark Mode và Light Mode.
/// - Logo VinFast 3D mạ crom nổi bật ở vị trí trung tâm.
class BottomNavShell extends StatelessWidget {
  final Widget child;

  const BottomNavShell({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/messages')) return 1;
    if (location.startsWith('/station-finder')) return 3;
    if (location.startsWith('/settings')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedColor = isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.lightOnSurfaceVariant;
    final navBg = isDark ? const Color(0xFF000000) : Colors.white;

    return Scaffold(
      body: child,
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // ─── Thân Taskbar với mặt ca-lăng VinFast liền mạch cao cấp ───
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 78),
            painter: _VinFastGrillePainter(
              backgroundColor: navBg,
              ledColor: isDark ? const Color(0xFF00E5FF) : AppColors.primary,
              isDark: isDark,
            ),
            child: SafeArea(
              child: SizedBox(
                height: 72,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 1. Trang chủ
                    _GrilleNavItem(
                      icon: Icons.home_rounded,
                      label: 'Trang chủ',
                      isSelected: currentIndex == 0,
                      unselectedColor: unselectedColor,
                      onTap: () => context.go('/home'),
                    ),

                    // 2. Tin nhắn
                    _GrilleNavItem(
                      icon: Icons.chat_bubble_rounded,
                      label: 'Tin nhắn',
                      isSelected: currentIndex == 1,
                      unselectedColor: unselectedColor,
                      onTap: () => context.go('/messages'),
                      badgeCount: 3,
                    ),

                    // Khoảng trống trung tâm cho logo chữ V
                    const SizedBox(width: 68),

                    // 4. Tìm trạm
                    _GrilleNavItem(
                      icon: Icons.ev_station_rounded,
                      label: 'Tìm trạm',
                      isSelected: currentIndex == 3,
                      unselectedColor: unselectedColor,
                      onTap: () => context.go('/station-finder'),
                    ),

                    // 5. Cài đặt
                    _GrilleNavItem(
                      icon: Icons.settings_rounded,
                      label: 'Cài đặt',
                      isSelected: currentIndex == 4,
                      unselectedColor: unselectedColor,
                      onTap: () => context.go('/settings'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Logo VinFast 3D mạ crom đặt vững chãi ở trung tâm ca-lăng ───
          const Positioned(
            top: -6,
            child: IgnorePointer(
              child: SizedBox(
                width: 68,
                height: 68,
                child: Center(
                  child: VinFastLogo(
                    size: 55,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter vẽ mặt ca-lăng VinFast liền khối nguyên bản sang trọng
class _VinFastGrillePainter extends CustomPainter {
  final Color backgroundColor;
  final Color ledColor;
  final bool isDark;

  _VinFastGrillePainter({
    required this.backgroundColor,
    required this.ledColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w * 0.5;

    // ─── 1. Khung nền Taskbar liền khối uốn lượn theo dáng ca-lăng ───
    final bgPath = Path()
      ..moveTo(0, 4)
      ..lineTo(cx - 52, 4)
      ..cubicTo(cx - 36, 4, cx - 28, 14, cx - 20, 32)
      ..cubicTo(cx - 14, 44, cx - 8, 48, cx, 50)
      ..cubicTo(cx + 8, 48, cx + 14, 44, cx + 20, 32)
      ..cubicTo(cx + 28, 14, cx + 36, 4, cx + 52, 4)
      ..lineTo(w, 4)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(bgPath, bgPaint);

    // ─── 2. Họa tiết lưới ca-lăng kim cương 3D chìm rõ nét ở cả 2 mode ───
    final meshPaint = Paint()
      ..color = (isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000))
          .withValues(alpha: isDark ? 0.10 : 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.save();
    canvas.clipPath(bgPath);
    const double step = 14.0;
    for (double i = -h; i < w + h; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i + h, h), meshPaint);
      canvas.drawLine(Offset(i, h), Offset(i + h, 0), meshPaint);
    }
    canvas.restore();

    // ─── 3. Đường hình học 2 cánh LED độc lập (dừng ở 2/3 chữ V) ───
    final leftWing = Path()
      ..moveTo(0, 4)
      ..lineTo(cx - 52, 4)
      ..cubicTo(cx - 36, 4, cx - 28, 14, cx - 20, 32);

    final rightWing = Path()
      ..moveTo(w, 4)
      ..lineTo(cx + 52, 4)
      ..cubicTo(cx + 36, 4, cx + 28, 14, cx + 20, 32);

    // ─── 4. Hiệu ứng phát quang LED DRL đa tầng (Ambient Halo Glow) ───
    final haloGlowPaint = Paint()
      ..color = ledColor.withValues(alpha: isDark ? 0.30 : 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(leftWing, haloGlowPaint);
    canvas.drawPath(rightWing, haloGlowPaint);

    // ─── 5. Dải LED Gradient chính (Cyan Electric sang Trắng Xenon sáng bóng) ───
    final leftShader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: isDark
          ? [
              const Color(0xFF0066CC),
              const Color(0xFF00E5FF),
              Colors.white,
            ]
          : [
              const Color(0xFF0A84FF),
              const Color(0xFF00B0FF),
              const Color(0xFFE1F5FE),
            ],
    ).createShader(Rect.fromLTWH(0, 0, cx, h));

    final rightShader = LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: isDark
          ? [
              const Color(0xFF0066CC),
              const Color(0xFF00E5FF),
              Colors.white,
            ]
          : [
              const Color(0xFF0A84FF),
              const Color(0xFF00B0FF),
              const Color(0xFFE1F5FE),
            ],
    ).createShader(Rect.fromLTWH(cx, 0, cx, h));

    final ledMainPaintLeft = Paint()
      ..shader = leftShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final ledMainPaintRight = Paint()
      ..shader = rightShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(leftWing, ledMainPaintLeft);
    canvas.drawPath(rightWing, ledMainPaintRight);

    // ─── 6. Dải nẹp Crom kép phụ bên dưới (Chrome Trim) ───
    final leftSubWing = Path()
      ..moveTo(w * 0.08, 7)
      ..lineTo(cx - 52, 7)
      ..cubicTo(cx - 36, 7, cx - 28, 16, cx - 20, 34);

    final rightSubWing = Path()
      ..moveTo(w * 0.92, 7)
      ..lineTo(cx + 52, 7)
      ..cubicTo(cx + 36, 7, cx + 28, 16, cx + 20, 34);

    final chromeSubPaint = Paint()
      ..color = (isDark ? const Color(0xFF888888) : const Color(0xFFAAAAAA))
          .withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(leftSubWing, chromeSubPaint);
    canvas.drawPath(rightSubWing, chromeSubPaint);
  }

  @override
  bool shouldRepaint(covariant _VinFastGrillePainter oldDelegate) =>
      oldDelegate.backgroundColor != backgroundColor ||
      oldDelegate.ledColor != ledColor;
}

class _GrilleNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final Color unselectedColor;
  final VoidCallback onTap;
  final int badgeCount;

  const _GrilleNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.unselectedColor,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : unselectedColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            // Icon with badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 23),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$badgeCount',
                        style: AppTextStyles.labelSmall(color: Colors.white)
                            .copyWith(fontSize: 9),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            // Label
            Text(
              label,
              style: (isSelected
                      ? AppTextStyles.labelSmall(color: AppColors.primary)
                      : AppTextStyles.labelSmall(color: color))
                  .copyWith(fontSize: 10, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
