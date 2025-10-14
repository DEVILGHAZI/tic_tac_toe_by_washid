import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/utils/enum.dart';

class AppPrimaryGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final double? iconSize;
  final ButtonType type;
  final ButtonSize size;
  final bool outlined;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final Color? textColor;
  final Color? iconColor;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final bool enableShadow;
  final double? shadowBlurRadius;
  final Offset? shadowOffset;
  final Color? shadowColor;
  final bool isLoading;
  final bool isDisabled;
  final Widget? loadingWidget;
  final TextStyle? textStyle;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? iconSpacing;
  final EdgeInsetsGeometry? padding;

  const AppPrimaryGradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.iconSize,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.outlined = false,
    this.width,
    this.height,
    this.gradient,
    this.textColor,
    this.iconColor,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.enableShadow = true,
    this.shadowBlurRadius,
    this.shadowOffset,
    this.shadowColor,
    this.isLoading = false,
    this.isDisabled = false,
    this.loadingWidget,
    this.textStyle,
    this.fontWeight,
    this.fontSize,
    this.iconSpacing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isButtonDisabled = isDisabled || onPressed == null || isLoading;
    final sizeConfig = _getSizeConfig();
    final buttonGradient = gradient ?? _getGradient(isDark, isButtonDisabled);
    final buttonTextColor =
        textColor ?? _getTextColor(isDark, isButtonDisabled);
    final buttonIconColor = iconColor ?? buttonTextColor;
    final buttonShadowColor = shadowColor ?? _getShadowColor(isDark);

    return SizedBox(
      width: width,
      height: height ?? sizeConfig.height,
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              borderRadius ?? BorderRadius.circular(sizeConfig.borderRadius),
          gradient: outlined ? null : buttonGradient,
          color: outlined ? AppColors.transparent : null,
          border:
              outlined || borderColor != null
                  ? Border.all(
                    color: borderColor ?? _getBorderColor(isDark),
                    width: borderWidth ?? 2,
                  )
                  : null,
          boxShadow:
              enableShadow && !isButtonDisabled && !outlined
                  ? [
                    BoxShadow(
                      color: buttonShadowColor,
                      blurRadius: shadowBlurRadius ?? sizeConfig.shadowBlur,
                      offset: shadowOffset ?? sizeConfig.shadowOffset,
                    ),
                  ]
                  : null,
        ),
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: isButtonDisabled ? null : onPressed,
            borderRadius:
                borderRadius ?? BorderRadius.circular(sizeConfig.borderRadius),
            child: Padding(
              padding: padding ?? sizeConfig.padding,
              child: _buildContent(
                buttonTextColor,
                buttonIconColor,
                sizeConfig,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    Color textColor,
    Color iconColor,
    _ButtonSizeConfig config,
  ) {
    if (isLoading) {
      return Center(
        child:
            loadingWidget ??
            SizedBox(
              width: config.iconSize,
              height: config.iconSize,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(textColor),
              ),
            ),
      );
    }

    final textWidget = Text(
      label,
      style:
          textStyle ??
          GoogleFonts.poppins(
            fontSize: fontSize ?? config.fontSize,
            fontWeight: fontWeight ?? FontWeight.w600,
            color: textColor,
          ),
      textAlign: TextAlign.center,
    );

    if (icon == null && trailingIcon == null) {
      return Center(child: textWidget);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: iconColor, size: iconSize ?? config.iconSize),
          SizedBox(width: iconSpacing ?? config.iconSpacing),
        ],
        Flexible(child: textWidget),
        if (trailingIcon != null) ...[
          SizedBox(width: iconSpacing ?? config.iconSpacing),
          Icon(
            trailingIcon,
            color: iconColor,
            size: iconSize ?? config.iconSize,
          ),
        ],
      ],
    );
  }

  _ButtonSizeConfig _getSizeConfig() {
    switch (size) {
      case ButtonSize.small:
        return _ButtonSizeConfig(
          height: 40.h,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          fontSize: 14.sp,
          iconSize: 18.sp,
          iconSpacing: 8.w,
          borderRadius: 12.r,
          shadowBlur: 12,
          shadowOffset: const Offset(0, 4),
        );
      case ButtonSize.medium:
        return _ButtonSizeConfig(
          height: 50.h,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w),
          fontSize: 16.sp,
          iconSize: 22.sp,
          iconSpacing: 10.w,
          borderRadius: 16.r,
          shadowBlur: 16,
          shadowOffset: const Offset(0, 6),
        );
      case ButtonSize.large:
        return _ButtonSizeConfig(
          height: 60.h,
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 32.w),
          fontSize: 18.sp,
          iconSize: 26.sp,
          iconSpacing: 12.w,
          borderRadius: 20.r,
          shadowBlur: 20,
          shadowOffset: const Offset(0, 8),
        );
    }
  }

  Gradient _getGradient(bool isDark, bool isDisabled) {
    if (isDisabled) {
      return LinearGradient(
        colors: [
          AppColors.grey.withOpacity(0.6),
          AppColors.grey.withOpacity(0.5),
        ],
      );
    }

    switch (type) {
      case ButtonType.primary:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    AppColors.darkPrimary,
                    AppColors.darkPrimary.withOpacity(0.8),
                  ]
                  : [
                    AppColors.lightPrimary,
                    AppColors.lightPrimary.withOpacity(0.8),
                  ],
        );
      case ButtonType.secondary:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [
                    AppColors.darkSecondary,
                    AppColors.darkSecondary.withOpacity(0.8),
                  ]
                  : [
                    AppColors.lightSecondary,
                    AppColors.lightSecondary.withOpacity(0.8),
                  ],
        );
      case ButtonType.success:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.success, AppColors.success.withOpacity(0.85)],
        );
      case ButtonType.danger:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.error, AppColors.error.withOpacity(0.85)],
        );
      case ButtonType.warning:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.drawColor, AppColors.drawColor.withOpacity(0.8)],
        );
      case ButtonType.info:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lightPrimary,
            AppColors.lightPrimary.withOpacity(0.85),
          ],
        );
    }
  }

  Color _getTextColor(bool isDark, bool isDisabled) {
    if (isDisabled) {
      return Colors.white70;
    }
    if (outlined) {
      return isDark ? AppColors.darkText : AppColors.lightText;
    }
    return AppColors.white;
  }

  Color _getBorderColor(bool isDark) {
    switch (type) {
      case ButtonType.primary:
        return isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
      case ButtonType.secondary:
        return isDark ? AppColors.darkSecondary : AppColors.lightSecondary;
      case ButtonType.success:
        return AppColors.success;
      case ButtonType.danger:
        return AppColors.error;
      case ButtonType.warning:
        return AppColors.drawColor;
      case ButtonType.info:
        return AppColors.lightPrimary;
    }
  }

  Color _getShadowColor(bool isDark) {
    switch (type) {
      case ButtonType.primary:
        return (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
            .withOpacity(0.3);
      case ButtonType.secondary:
        return (isDark ? AppColors.darkSecondary : AppColors.lightSecondary)
            .withOpacity(0.3);
      case ButtonType.success:
        return AppColors.success.withOpacity(0.3);
      case ButtonType.danger:
        return AppColors.error.withOpacity(0.3);
      case ButtonType.warning:
        return AppColors.drawColor.withOpacity(0.3);
      case ButtonType.info:
        return AppColors.lightPrimary.withOpacity(0.3);
    }
  }
}

// Size configuration class
class _ButtonSizeConfig {
  final double height;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final double iconSize;
  final double iconSpacing;
  final double borderRadius;
  final double shadowBlur;
  final Offset shadowOffset;

  _ButtonSizeConfig({
    required this.height,
    required this.padding,
    required this.fontSize,
    required this.iconSize,
    required this.iconSpacing,
    required this.borderRadius,
    required this.shadowBlur,
    required this.shadowOffset,
  });
}
