import 'dart:ui';
import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_colors.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/utils/enum.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/constants/app_strings.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/core/widgets/primary_button.dart';
import 'package:digital_guruji_assignment_tic_tac_toe/features/game/data/repositories/game_history_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/game_bloc.dart';
import '../bloc/game_event.dart';

final GameHistoryRepository _repository = GameHistoryRepository();
void _showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: AppColors.black.withOpacity(0.5),
    builder: (dialogContext) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with icon
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors:
                                    isDark
                                        ? [
                                          AppColors.darkPrimary.withOpacity(
                                            0.3,
                                          ),
                                          AppColors.darkPrimary.withOpacity(
                                            0.1,
                                          ),
                                        ]
                                        : [
                                          AppColors.lightPrimary.withOpacity(
                                            0.2,
                                          ),
                                          AppColors.lightPrimary.withOpacity(
                                            0.1,
                                          ),
                                        ],
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Icon(
                              Icons.settings_rounded,
                              size: 28.sp,
                              color:
                                  isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            AppStrings.settings,
                            style: GoogleFonts.poppins(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color:
                                  isDark
                                      ? AppColors.darkText
                                      : AppColors.lightText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      _buildSettingItem(
                        context: context,
                        isDark: isDark,
                        icon: Icons.refresh_rounded,
                        title: AppStrings.resetScores,
                        subtitle: AppStrings.clearAllScores,
                        iconColor:
                            isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                        onTap: () async {
                          Navigator.of(dialogContext).pop();
                          context.read<GameBloc>().add(
                            const ResetScoresEvent(),
                          );
                          await _repository.clearHistory();
                          _showSuccessSnackBar(
                            context,
                            AppStrings.scoresHistoryReset,
                          );
                        },
                      ),
                      SizedBox(height: 24.h),
                      AppPrimaryGradientButton(
                        label: AppStrings.close,
                        icon: Icons.close_rounded,
                        type: ButtonType.secondary,
                        outlined: true,
                        width: double.infinity,
                        onPressed: () => Navigator.of(dialogContext).pop(),
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

Widget _buildSettingItem({
  required BuildContext context,
  required bool isDark,
  required IconData icon,
  required String title,
  String? subtitle,
  required Color iconColor,
  required VoidCallback onTap,
}) {
  return Material(
    color: AppColors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color:
              isDark
                  ? AppColors.darkBackground.withOpacity(0.5)
                  : AppColors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color:
                isDark
                    ? AppColors.white.withOpacity(0.05)
                    : AppColors.black.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    iconColor.withOpacity(0.2),
                    iconColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18.sp,
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
            ),
          ],
        ),
      ),
    ),
  );
}

void _showSuccessSnackBar(BuildContext context, String message) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: AppColors.success.withOpacity(0.3), width: 1.5),
      ),
      margin: EdgeInsets.all(16.w),
      elevation: 8,
    ),
  );
}

class SettingsDialog {
  SettingsDialog._();

  static void show(BuildContext context) {
    _showSettingsDialog(context);
  }
}
