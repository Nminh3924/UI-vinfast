import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'vinfast_logo.dart';

/// Taskbar Messenger mặt ca-lăng VinFast với hiệu ứng kính mờ xuyên thấu.
///
/// Dùng Stack thay vì bottomNavigationBar để BackdropFilter
/// có thể blur nội dung body phía sau (cùng render layer).
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
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final barHeight = 72.0 + bottomPadding;

    return Scaffold(
      body: Stack(
        children: [
          // ─── Body nội dung ───
          Positioned.fill(
            child: child,
          ),

          // ─── Taskbar kính mờ xuyên thấu ───
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _GlassmorphicTaskbar(
              isDark: isDark,
              barHeight: barHeight,
              bottomPadding: bottomPadding,
              currentIndex: currentIndex,
              unselectedColor: unselectedColor,
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go('/home');
                  case 1:
                    context.go('/messages');
                  case 3:
                    context.go('/station-finder');
                  case 4:
                    context.go('/settings');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassmorphicTaskbar extends StatelessWidget {
  final bool isDark;
  final double barHeight;
  final double bottomPadding;
  final int currentIndex;
  final Color unselectedColor;
  final ValueChanged<int> onTap;

  const _GlassmorphicTaskbar({
    required this.isDark,
    required this.barHeight,
    required this.bottomPadding,
    required this.currentIndex,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: barHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // ── Lớp 1: ClipPath + BackdropFilter (blur xuyên thấu) ──
          ClipPath(
            clipper: _VinFastShapeClipper(barHeight),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(color: Colors.transparent),
            ),
          ),

          // ── Lớp 2: CustomPaint nền bán trong suốt + lưới + LED ──
          CustomPaint(
            size: Size(double.infinity, barHeight),
            painter: _VinFastGrillePainter(
              isDark: isDark,
              totalHeight: barHeight,
            ),
          ),

          // ── Lớp 3: Các nút nav ──
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _GrilleNavItem(
                    icon: Icons.home_rounded,
                    label: 'Trang chủ',
                    isSelected: currentIndex == 0,
                    unselectedColor: unselectedColor,
                    onTap: () => onTap(0),
                  ),
                  _GrilleNavItem(
                    icon: Icons.chat_bubble_rounded,
                    label: 'Tin nhắn',
                    isSelected: currentIndex == 1,
                    unselectedColor: unselectedColor,
                    onTap: () => onTap(1),
                    badgeCount: 3,
                  ),
                  const SizedBox(width: 68),
                  _GrilleNavItem(
                    icon: Icons.ev_station_rounded,
                    label: 'Tìm trạm',
                    isSelected: currentIndex == 3,
                    unselectedColor: unselectedColor,
                    onTap: () => onTap(3),
                  ),
                  _GrilleNavItem(
                    icon: Icons.settings_rounded,
                    label: 'Cài đặt',
                    isSelected: currentIndex == 4,
                    unselectedColor: unselectedColor,
                    onTap: () => onTap(4),
                  ),
                ],
              ),
            ),
          ),

          // ── Logo VinFast nổi ──
          const Positioned(
            top: -6,
            child: IgnorePointer(
              child: SizedBox(
                width: 68,
                height: 68,
                child: Center(
                  child: VinFastLogo(size: 55, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Clipper hình dáng ca-lăng chữ V liền khối.
class _VinFastShapeClipper extends CustomClipper<Path> {
  final double totalHeight;
  _VinFastShapeClipper(this.totalHeight);

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = totalHeight;
    final cx = w * 0.5;

    return Path()
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
  }

  @override
  bool shouldReclip(covariant _VinFastShapeClipper oldClipper) =>
      oldClipper.totalHeight != totalHeight;
}

/// Painter vẽ nền bán trong suốt + lưới kim cương + LED DRL.
class _VinFastGrillePainter extends CustomPainter {
  final bool isDark;
  final double totalHeight;

  _VinFastGrillePainter({required this.isDark, required this.totalHeight});

  Path _buildPath(double w) {
    final h = totalHeight;
    final cx = w * 0.5;
    return Path()
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
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = totalHeight;
    final cx = w * 0.5;
    final bgPath = _buildPath(w);

    // ─── 1. Nền bán trong suốt ───
    final bgPaint = Paint()
      ..color = isDark
          ? const Color(0xFF000000).withValues(alpha: 0.55)
          : Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;
    canvas.drawPath(bgPath, bgPaint);

    // ─── 2. Lưới kim cương 3D ───
    final meshPaint = Paint()
      ..color = (isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000))
          .withValues(alpha: isDark ? 0.07 : 0.03)
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

    // ─── 3. LED DRL cánh chim ───
    final leftWing = Path()
      ..moveTo(0, 4)
      ..lineTo(cx - 52, 4)
      ..cubicTo(cx - 36, 4, cx - 28, 14, cx - 20, 32);

    final rightWing = Path()
      ..moveTo(w, 4)
      ..lineTo(cx + 52, 4)
      ..cubicTo(cx + 36, 4, cx + 28, 14, cx + 20, 32);

    final ledColor = isDark ? const Color(0xFF00E5FF) : AppColors.primary;

    // Halo glow
    final haloGlowPaint = Paint()
      ..color = ledColor.withValues(alpha: isDark ? 0.30 : 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(leftWing, haloGlowPaint);
    canvas.drawPath(rightWing, haloGlowPaint);

    // LED Gradient
    final leftShader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: isDark
          ? [const Color(0xFF0066CC), const Color(0xFF00E5FF), Colors.white]
          : [const Color(0xFF0A84FF), const Color(0xFF00B0FF), const Color(0xFFE1F5FE)],
    ).createShader(Rect.fromLTWH(0, 0, cx, h));

    final rightShader = LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: isDark
          ? [const Color(0xFF0066CC), const Color(0xFF00E5FF), Colors.white]
          : [const Color(0xFF0A84FF), const Color(0xFF00B0FF), const Color(0xFFE1F5FE)],
    ).createShader(Rect.fromLTWH(cx, 0, cx, h));

    final ledLeft = Paint()
      ..shader = leftShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    final ledRight = Paint()
      ..shader = rightShader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(leftWing, ledLeft);
    canvas.drawPath(rightWing, ledRight);

    // Chrome trim
    final leftSub = Path()
      ..moveTo(w * 0.08, 7)
      ..lineTo(cx - 52, 7)
      ..cubicTo(cx - 36, 7, cx - 28, 16, cx - 20, 34);
    final rightSub = Path()
      ..moveTo(w * 0.92, 7)
      ..lineTo(cx + 52, 7)
      ..cubicTo(cx + 36, 7, cx + 28, 16, cx + 20, 34);

    final chromePaint = Paint()
      ..color = (isDark ? const Color(0xFF888888) : const Color(0xFFAAAAAA))
          .withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(leftSub, chromePaint);
    canvas.drawPath(rightSub, chromePaint);

    // ─── 4. Viền mỏng frosted edge ───
    final borderPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawPath(bgPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _VinFastGrillePainter oldDelegate) =>
      oldDelegate.isDark != isDark;
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
            Text(
              label,
              style: AppTextStyles.labelSmall(color: color).copyWith(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
