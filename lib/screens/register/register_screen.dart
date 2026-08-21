import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeTerms = false;
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceVariant = isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? Colors.white : AppColors.lightOnSurface;
    final subtextColor = isDark ? AppColors.darkOnSurfaceVariant : AppColors.lightOnSurfaceVariant;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
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
            child: SlideTransition(
              position: _slideUp,
              child: FadeTransition(
                opacity: _fadeIn,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Back button
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Tạo tài khoản',
                            style: AppTextStyles.displayMedium(
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Bắt đầu trải nghiệm lái xe an toàn',
                            style: AppTextStyles.bodyLarge(
                              color: subtextColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Name field
                    TextField(
                      controller: _nameController,
                      style: AppTextStyles.bodyLarge(
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Họ và tên',
                        labelStyle: AppTextStyles.bodyMedium(
                          color: subtextColor,
                        ),
                        hintText: 'Nguyễn Văn A',
                        prefixIcon: Icon(Icons.person_outline_rounded, color: subtextColor),
                      ),
                    ),

                    const SizedBox(height: 20),

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
                        prefixIcon: Icon(Icons.email_outlined, color: subtextColor),
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
                        prefixIcon: Icon(Icons.lock_outline_rounded, color: subtextColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: subtextColor,
                          ),
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Confirm password field
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      style: AppTextStyles.bodyLarge(
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Xác nhận mật khẩu',
                        labelStyle: AppTextStyles.bodyMedium(
                          color: subtextColor,
                        ),
                        hintText: '••••••••',
                        prefixIcon: Icon(Icons.lock_outline_rounded, color: subtextColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: subtextColor,
                          ),
                          onPressed: () {
                            setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Terms checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _agreeTerms,
                            onChanged: (v) {
                              setState(() => _agreeTerms = v ?? false);
                            },
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            side: BorderSide(
                              color: borderColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _agreeTerms = !_agreeTerms);
                            },
                            child: RichText(
                              text: TextSpan(
                                style: AppTextStyles.bodySmall(
                                  color: subtextColor,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Tôi đồng ý với ',
                                  ),
                                  TextSpan(
                                    text: 'Điều khoản sử dụng',
                                    style: AppTextStyles.labelSmall(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const TextSpan(text: ' và '),
                                  TextSpan(
                                    text: 'Chính sách bảo mật',
                                    style: AppTextStyles.labelSmall(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Register button
                    Container(
                      width: double.infinity,
                      height: AppSpacing.buttonHeight,
                      decoration: BoxDecoration(
                        gradient: _agreeTerms
                            ? AppColors.primaryGradient
                            : LinearGradient(
                                colors: [
                                  surfaceVariant,
                                  surfaceVariant,
                                ],
                              ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: _agreeTerms
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      child: ElevatedButton(
                        onPressed: _agreeTerms
                            ? () async {
                                final email = _emailController.text.trim().isNotEmpty
                                    ? _emailController.text.trim()
                                    : 'minh@email.com';
                                await AuthService.login(email: email);
                                if (context.mounted) {
                                  context.go('/home');
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          disabledBackgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Đăng ký',
                          style: AppTextStyles.labelLarge(
                            color: _agreeTerms
                                ? Colors.white
                                : subtextColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Login link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Đã có tài khoản? ',
                            style: AppTextStyles.bodyMedium(
                              color: subtextColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Text(
                              'Đăng nhập',
                              style: AppTextStyles.labelMedium(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
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
