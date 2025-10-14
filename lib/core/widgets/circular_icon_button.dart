import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularIconButton extends StatelessWidget {
  final VoidCallback? onPressed;

  final IconData icon;
  final double? iconSize;
  final Color? iconColor;

  final double? size;
  final BoxShape shape;

  final Gradient? gradient;
  final List<Color>? gradientColors;

  final bool enableShadow;
  final Color? shadowColor;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;
  final Offset shadowOffset;

  final BorderRadius? borderRadius;
  final Border? border;

  final String? tooltip;
  final EdgeInsetsGeometry? padding;

  const CircularIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize,
    this.iconColor,
    this.size,
    this.shape = BoxShape.circle,
    this.gradient,
    this.gradientColors,
    this.enableShadow = true,
    this.shadowColor,
    this.shadowBlurRadius = 12.0,
    this.shadowSpreadRadius = 0.0,
    this.shadowOffset = const Offset(0, 4),
    this.borderRadius,
    this.border,
    this.tooltip,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    final defaultGradient =
        gradient ??
        LinearGradient(
          colors:
              gradientColors ??
              [
                theme.primaryColor.withOpacity(0.2),
                theme.primaryColor.withOpacity(0.1),
              ],
        );

    final defaultIconColor = iconColor ?? theme.iconTheme.color ?? Colors.white;
    final defaultSize = (size ?? 48.0).w;
    final defaultIconSize = (iconSize ?? 24.0).sp;
    final defaultShadowColor =
        shadowColor ??
        (isDark
            ? AppColors.black.withOpacity(0.4)
            : theme.primaryColor.withOpacity(0.3));

    final button = Container(
      width: defaultSize,
      height: defaultSize,
      padding: padding,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
        gradient: defaultGradient,
        border: border,
        boxShadow:
            enableShadow
                ? [
                  BoxShadow(
                    color: defaultShadowColor,
                    blurRadius: shadowBlurRadius,
                    spreadRadius: shadowSpreadRadius,
                    offset: shadowOffset,
                  ),
                ]
                : null,
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder:
              shape == BoxShape.circle
                  ? const CircleBorder()
                  : RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(12.r),
                  ),
          child: Center(
            child: Icon(icon, color: defaultIconColor, size: defaultIconSize),
          ),
        ),
      ),
    );
    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
