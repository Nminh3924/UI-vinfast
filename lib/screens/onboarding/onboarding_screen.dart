import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      icon: Icons.directions_car_rounded,
      secondaryIcon: Icons.headset_mic_rounded,
      title: 'Lái xe an toàn',
      subtitle: 'Nghe và trả lời tin nhắn\nbằng giọng nói khi lái xe',
      gradient: AppColors.driverModeGradient,
    ),
    _OnboardingData(
      icon: Icons.smart_toy_rounded,
      secondaryIcon: Icons.chat_bubble_rounded,
      title: 'Trả lời thông minh',
      subtitle: 'AI gợi ý 3 câu trả lời\nphù hợp ngữ cảnh tin nhắn',
      gradient: const LinearGradient(
        colors: [Color(0xFF6C63FF), Color(0xFF3F51B5)],
      ),
    ),
    _OnboardingData(
      icon: Icons.bluetooth_connected_rounded,
      secondaryIcon: Icons.gamepad_rounded,
      title: 'Nút bấm ESP32',
      subtitle: '4 nút cứng điều khiển\nkhông cần chạm màn hình',
      gradient: const LinearGradient(
        colors: [Color(0xFF00E5FF), Color(0xFF0A84FF)],
      ),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(
                      'Bỏ qua',
                      style: AppTextStyles.labelMedium(
                        color: AppColors.lightOnSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),

              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    return _OnboardingPage(data: _pages[index]);
                  },
                ),
              ),

              // Page indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: AppColors.primary,
                    dotColor: AppColors.lightSurfaceVariant,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                    spacing: 8,
                  ),
                ),
              ),

              // Button
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0,
                  AppSpacing.screenPadding,
                  AppSpacing.xl,
                ),
                child: _currentPage == _pages.length - 1
                    ? _buildGradientButton(
                        'Bắt đầu',
                        () => context.go('/login'),
                      )
                    : _buildGradientButton(
                        'Tiếp theo',
                        () => _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(text, style: AppTextStyles.labelLarge(color: Colors.white)),
      ),
    );
  }
}

// ─── Data model ───
class _OnboardingData {
  final IconData icon;
  final IconData secondaryIcon;
  final String title;
  final String subtitle;
  final LinearGradient gradient;

  const _OnboardingData({
    required this.icon,
    required this.secondaryIcon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}

// ─── Single page ───
class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon circle with gradient
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: data.gradient,
              boxShadow: [
                BoxShadow(
                  color: data.gradient.colors.first.withValues(alpha: 0.3),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(data.icon, size: 72, color: Colors.white),
                Positioned(
                  bottom: 30,
                  right: 30,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      data.secondaryIcon,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            data.title,
            style: AppTextStyles.displayMedium(color: AppColors.lightOnSurface),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            data.subtitle,
            style: AppTextStyles.bodyLarge(
              color: AppColors.lightOnSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
