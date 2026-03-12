// lib/feature/profile/ui/screens/personal_info_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tavo/core/constants/app_assets.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/core/widgets/primary/auth_text_form_field.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'ندى');
  final _phoneController = TextEditingController(text: '123578899');
  
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    final hasChanges = _nameController.text != 'ندى' || 
                       _phoneController.text != '123578899';
    if (hasChanges != _hasChanges) {
      setState(() => _hasChanges = hasChanges);
    }
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Handle save
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.white,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  _buildAppBar(context),
                  SizedBox(height: 20.h),
                  _buildAvatar(),
                  SizedBox(height: 24.h),
                  _buildNameField(),
                  SizedBox(height: 12.h),
                  _buildPhoneField(),
                  const Spacer(),
                  _buildSaveButton(),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        _CircleIconButton(
          icon: AppAssets.arrowRight,
          onTap: () => Navigator.of(context).maybePop(),
        ),
      SizedBox(width: 16.r),
        Text(
          'بياناتي الشخصية',
          style: TextStyles.font14DarkGray400Weight(context).copyWith(
            color: ColorsManager.black,
            fontWeight: FontWeight.w700,
          ),
        ),
       
        
      ],
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 88.r,
          height: 88.r,
          decoration: const BoxDecoration(
            color: ColorsManager.grey200,
            shape: BoxShape.circle,
          ),
        ),
        PositionedDirectional(
          bottom: 4.h,
          start: 4.w,
          child: GestureDetector(
            onTap: () {
              // TODO: Handle image picker
            },
            child: Container(
              width: 28.r,
              height: 28.r,
              decoration: const BoxDecoration(
                color: Color(0xFF2F2F5F),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.edit,
                  width: 14.r,
                  height: 14.r,
                  colorFilter: const ColorFilter.mode(
                    ColorsManager.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return AuthTextFormField(
      controller: _nameController,
      keyboardType: TextInputType.name,
      textDirection: TextDirection.rtl,
      hint: 'الاسم',
      borderRadius: 80,
      textAlign: TextAlign.right,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال الاسم';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return AuthTextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textDirection: TextDirection.ltr,
      hint: 'رقم الجوال',
      borderRadius: 80,
      textAlign: TextAlign.right,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      suffixIcon: Padding(
        padding: EdgeInsets.all(10.w),
        child: SvgPicture.asset(
          AppAssets.countryFlags,
          width: 22.w,
          height: 22.h,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'الرجاء إدخال رقم الجوال';
        }
        return null;
      },
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      height: 48.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _hasChanges ? _onSave : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: ColorsManager.primaryColor,
          disabledBackgroundColor: ColorsManager.secondary100.withValues(alpha: 0.20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.r),
          ),
        ),
        child: Text(
          'حفظ',
          style: TextStyles.font14DarkGray400Weight(context).copyWith(
            color: _hasChanges ? ColorsManager.black : ColorsManager.darkGray300,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.r,
        height: 36.r,
        decoration: BoxDecoration(
          color: backgroundColor ?? ColorsManager.grey100,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            width: 16.r,
            height: 16.r,
            colorFilter: ColorFilter.mode(
              iconColor ?? ColorsManager.black,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}