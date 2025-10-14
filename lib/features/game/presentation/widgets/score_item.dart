import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreItem extends StatelessWidget {
  final String label;
  final int score;
  final Color? color;
  final TextStyle? labelStyle;
  final TextStyle? scoreStyle;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? labelFontSize;
  final double? scoreFontSize;
  final double? spacing;
  final bool useGradient;
  final List<Color>? gradientColors;

  const ScoreItem({
    super.key,
    required this.label,
    required this.score,
    this.color,
    this.labelStyle,
    this.scoreStyle,
    this.padding,
    this.borderRadius,
    this.labelFontSize,
    this.scoreFontSize,
    this.spacing,
    this.useGradient = true,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor =
        color ?? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style:
              labelStyle ??
              GoogleFonts.poppins(
                fontSize: labelFontSize ?? 12.sp,
                fontWeight: FontWeight.w600,
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: spacing ?? 8.h),
        Container(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
            gradient:
                useGradient
                    ? LinearGradient(
                      colors:
                          gradientColors ??
                          [
                            defaultColor.withOpacity(0.2),
                            defaultColor.withOpacity(0.1),
                          ],
                    )
                    : null,
            color: useGradient ? null : defaultColor.withOpacity(0.15),
          ),
          child: Text(
            score.toString(),
            style:
                scoreStyle ??
                GoogleFonts.poppins(
                  fontSize: scoreFontSize ?? 28.sp,
                  fontWeight: FontWeight.w900,
                  color: defaultColor,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
