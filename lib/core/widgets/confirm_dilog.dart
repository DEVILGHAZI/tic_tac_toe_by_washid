import 'dart:ui';
import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_strings.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/utils/enum.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
  IconData? icon,
  Color? iconColor,
  ButtonType confirmButtonType = ButtonType.danger,
  bool isDismissible = true,
}) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: isDismissible,
    barrierColor: AppColors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: AppColors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isDark
                        ? [
                          AppColors.darkSurface.withOpacity(0.95),
                          AppColors.darkBackground.withOpacity(0.95),
                        ]
                        : [
                          AppColors.white.withOpacity(0.95),
                          AppColors.lightBackground.withOpacity(0.95),
                        ],
              ),
              border: Border.all(
                color:
                    isDark
                        ? AppColors.white.withOpacity(0.1)
                        : AppColors.black.withOpacity(0.05),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      isDark
                          ? AppColors.black.withOpacity(0.5)
                          : AppColors.grey.withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 5,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                (iconColor ?? AppColors.drawColor).withOpacity(
                                  0.2,
                                ),
                                (iconColor ?? AppColors.drawColor).withOpacity(
                                  0.1,
                                ),
                              ],
                            ),
                          ),
                          child: Icon(
                            icon,
                            size: 48.sp,
                            color: iconColor ?? AppColors.drawColor,
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        message,
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: AppPrimaryGradientButton(
                              label: cancelText ?? AppStrings.cancel,
                              type: ButtonType.secondary,
                              outlined: true,
                              height: 40,
                              borderRadius: BorderRadius.circular(20),
                              padding: EdgeInsets.all(0),
                              size: ButtonSize.medium,
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: AppPrimaryGradientButton(
                              label: confirmText ?? AppStrings.confirm,
                              type: confirmButtonType,
                              size: ButtonSize.medium,
                              height: 40,
                              borderRadius: BorderRadius.circular(20),
                              padding: EdgeInsets.all(0),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
