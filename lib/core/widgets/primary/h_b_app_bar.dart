import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';


class HBAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const HBAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBack,
    this.actions,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: AppBar(


        elevation: 0,
        surfaceTintColor: context.backgroundColor,
        automaticallyImplyLeading: false,
        toolbarHeight: 56.h,
        centerTitle: false,
        leadingWidth: showBackButton ? 28.w : 0,
        titleSpacing: showBackButton ? 4.w : 20.w,

        leading: showBackButton
            ? IconButton(
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          icon: Icon(Icons.arrow_back_ios_new, size: 18, color: context.iconColor),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        )
            : null,
        title: Text(
          title,
          style: TextStyles.header(context),
          overflow: TextOverflow.ellipsis,
        ),
        actions: actions,
      ),
    );
  }
}