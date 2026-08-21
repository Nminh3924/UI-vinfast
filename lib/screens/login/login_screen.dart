import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.lightOnSurface;
    final subtextColor = isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bgColor = isDark ? AppColors.darkBg : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        decoration: BoxDecoration(
          color: bgColor,
          gradient: isDark ? AppColors.splashGradient : null,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: SlideTransition(
              position: _slideUp,
              child: FadeTransition(
                opacity: _fadeIn,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),

                    // Logo with text (transparent - centered and large)
                    Center(
                      child: Image.asset(
                        'assets/images/logo_with_text.png',
                        height: 310,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Welcome text
                    Text(
                      'Chào mừng trở lại!',
                      style: AppTextStyles.displayMedium(color: textColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Đăng nhập để tiếp tục',
                      style: AppTextStyles.bodyLarge(
                        color: subtextColor,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Email field
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: AppTextStyles.bodyLarge(
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: AppTextStyles.bodyMedium(
                          color: subtextColor,
                        ),
                        hintText: 'yourname@email.com',
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Password field
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: AppTextStyles.bodyLarge(
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        labelStyle: AppTextStyles.bodyMedium(
                          color: subtextColor,
                        ),
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                          ),
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Quên mật khẩu?',
                          style: AppTextStyles.labelMedium(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Login button
                    Container(
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
                        onPressed: () async {
                          final email = _emailController.text.trim().isNotEmpty
                              ? _emailController.text.trim()
                              : 'minh@email.com';
                          await AuthService.login(email: email);
                          if (context.mounted) {
                            context.go('/home');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Đăng nhập',
                          style: AppTextStyles.labelLarge(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: borderColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: Text(
                            'hoặc',
                            style: AppTextStyles.bodySmall(
                              color: subtextColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: borderColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Google sign in
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                      label: Text(
                        'Đăng nhập với Google',
                        style: AppTextStyles.labelMedium(
                          color: textColor,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        side: BorderSide(
                          color: borderColor,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Chưa có tài khoản? ',
                          style: AppTextStyles.bodyMedium(
                            color: subtextColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/register'),
                          child: Text(
                            'Đăng ký',
                            style: AppTextStyles.labelMedium(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
