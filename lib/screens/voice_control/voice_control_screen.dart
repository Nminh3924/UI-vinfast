import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';

class VoiceControlScreen extends StatefulWidget {
  const VoiceControlScreen({super.key});

  @override
  State<VoiceControlScreen> createState() => _VoiceControlScreenState();
}

class _VoiceControlScreenState extends State<VoiceControlScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _textController;
  String _status = 'Đang nghe...';
  String _recognizedText = '';

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _textController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Simulate voice recognition
    _simulateRecognition();
  }

  void _simulateRecognition() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _recognizedText = 'Anh sắp đến rồi';
      _status = 'Đang nghe...';
    });
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _recognizedText = 'Anh sắp đến rồi, 5 phút nữa nhé!';
      _status = 'Đã nhận diện';
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg.withValues(alpha: 0.95),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ───
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    'Điều khiển giọng nói',
                    style: AppTextStyles.titleLarge(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.darkSurfaceVariant,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ─── Wave Animation ───
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(280, 280),
                  painter: _VoiceWavePainter(
                    progress: _waveController.value,
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            // ─── Status ───
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Row(
                key: ValueKey(_status),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_status == 'Đang nghe...')
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.error,
                      ),
                    ),
                  if (_status == 'Đã nhận diện')
                    Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                      ),
                    ),
                  Text(
                    _status,
                    style: AppTextStyles.titleMedium(
                      color: _status == 'Đang nghe...'
                          ? AppColors.error
                          : AppColors.success,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─── Recognized Text ───
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(20),
              constraints: const BoxConstraints(minHeight: 80),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.darkBorder),
              ),
              child: Center(
                child: Text(
                  _recognizedText.isEmpty
                      ? 'Hãy nói gì đó...'
                      : _recognizedText,
                  style: AppTextStyles.bodyLarge(
                    color: _recognizedText.isEmpty
                        ? AppColors.darkOnSurfaceVariant
                        : Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const Spacer(),

            // ─── Bottom actions ───
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel
                  _BottomAction(
                    icon: Icons.close_rounded,
                    label: 'Hủy',
                    color: AppColors.error,
                    onTap: () => context.pop(),
                  ),
                  // Mic (main)
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mic_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  // Send
                  _BottomAction(
                    icon: Icons.send_rounded,
                    label: 'Gửi',
                    color: AppColors.success,
                    onTap: () => context.pop(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Action ───
class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BottomAction({
    required this.icon,
    required this.label,
    required this.color,
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
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.15),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.labelSmall(color: color),
          ),
        ],
      ),
    );
  }
}

// ─── Voice Wave Painter ───
class _VoiceWavePainter extends CustomPainter {
  final double progress;

  _VoiceWavePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw concentric pulse circles
    for (int i = 0; i < 4; i++) {
      final p = (progress + i * 0.25) % 1.0;
      final radius = 40.0 + p * 100.0;
      final opacity = (1.0 - p) * 0.3;

      final paint = Paint()
        ..color = AppColors.primary.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius, paint);
    }

    // Center glow
    final glowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 50, glowPaint);

    // Inner circle
    final innerPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 35, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _VoiceWavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
