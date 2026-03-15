import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/di/service_locator.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/helpers/utils/spacing.dart';
import 'package:tavo/core/widgets/primary/auth_text_form_field.dart';
import 'package:tavo/feature/auth/ui/logic/cubit/auth_cubit.dart';
import 'package:tavo/feature/auth/ui/logic/cubit/auth_state.dart';
import 'package:tavo/feature/auth/ui/screens/otp_screen.dart';
import 'package:tavo/feature/auth/ui/screens/signup_screen.dart';
import 'package:tavo/feature/auth/ui/widgets/social_login_button.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: const _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatefulWidget {
  const _LoginScreenContent();

  @override
  State<_LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<_LoginScreenContent> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final String _countryCode = '+966';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(
            phone: _phoneController.text,
            countryCode: _countryCode,
          );
    }
  }

  void _navigateToOtp(AuthCubit cubit) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BlocProvider.value(
          value: cubit,
          child: OtpScreen(phone: _phoneController.text),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _onGoogleLogin() {}

  void _onAppleLogin() {}

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SendOtpSuccess) {
          _navigateToOtp(context.read<AuthCubit>());
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            _buildBackground(),
            _buildGradientOverlay(),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        AppAssets.onboarding3,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.65,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.7),
              Colors.black.withValues(alpha: 0.9),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Positioned(
      bottom: 8.h,
      left: 8.w,
      right: 8.w,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: ColorsManager.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              verticalSpace(8),
              Text(
                'login_title'.tr(),
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorsManager.black,
                ),
              ),
              verticalSpace(12),
              Text(
                'login_subtitle'.tr(),
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: ColorsManager.dark500,
                ),
              ),
              verticalSpace(32),
              _buildPhoneField(textTheme),
              verticalSpace(16),
              _buildLoginButton(textTheme),
              verticalSpace(24),
              _buildDivider(textTheme),
              verticalSpace(10),
              _buildSocialRow(),
              verticalSpace(16),
              _buildNoAccountRow(textTheme),
              verticalSpace(35),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField(TextTheme textTheme) {
    return AuthTextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textDirection: TextDirection.ltr,
      hint: 'phone_hint'.tr(),
      borderRadius: 80,
      textAlign: TextAlign.right,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      suffixIcon: Padding(
        padding: EdgeInsets.all(10.w),
        child: SvgPicture.asset(
          AppAssets.countryFlags,
          width: 24.w,
          height: 24.h,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'phone_required'.tr();
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(TextTheme textTheme) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return SizedBox(
          width: double.infinity,
          height: 48.h,
          child: MaterialButton(
            onPressed: isLoading ? null : _onLogin,
            color: ColorsManager.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80.r),
            ),
            elevation: 0,
            child: isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: const CircularProgressIndicator(
                      color: ColorsManager.black,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'send_otp'.tr(),
                    style: textTheme.bodyMedium?.copyWith(
                      color: ColorsManager.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildDivider(TextTheme textTheme) {
    return Row(
      children: [
        const Expanded(child: Divider(color: ColorsManager.lightGrey)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            'or_join_via'.tr(),
            style: textTheme.bodySmall?.copyWith(
              color: ColorsManager.darkGray300,
            ),
          ),
        ),
        const Expanded(child: Divider(color: ColorsManager.lightGrey)),
      ],
    );
  }

  Widget _buildSocialRow() {
    return Row(
      children: [
        Expanded(
          child: SocialLoginButton(
            onTap: _onGoogleLogin,
            icon: AppAssets.google,
            label: 'Google',
          ),
        ),
        horizontalSpace(12),
        Expanded(
          child: SocialLoginButton(
            onTap: _onAppleLogin,
            icon: AppAssets.apple,
            label: 'Apple',
          ),
        ),
      ],
    );
  }

  Widget _buildNoAccountRow(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'no_account'.tr(),
          style: textTheme.bodyMedium?.copyWith(
            color: ColorsManager.black,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SignupScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 300),
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'create_account'.tr(),
            style: textTheme.bodyMedium?.copyWith(
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: ColorsManager.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}