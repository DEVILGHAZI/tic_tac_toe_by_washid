import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/animated_background.dart';
import '../../data/models/game_history_model.dart';
import '../../data/repositories/game_history_repository.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final GameHistoryRepository _repository = GameHistoryRepository();
  List<GameHistoryModel> _history = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final stats = await _repository.getStatistics();
    setState(() {
      _history = stats['history'] as List<GameHistoryModel>;
      _stats = stats;
      _isLoading = false;
    });
  }

  Future<void> _clearHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(AppStrings.clearHistoryTitle),
            content: const Text(AppStrings.clearHistoryMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(AppStrings.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(AppStrings.clear),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await _repository.clearHistory();
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => Navigator.pop(context),
                      iconSize: 28.sp,
                    ),
                    const Spacer(),
                    Text(
                      AppStrings.gameHistory,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      onPressed: _clearHistory,
                      iconSize: 28.sp,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              if (!_isLoading) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          AppStrings.totalGames,
                          _stats['totalGames'].toString(),
                          Icons.sports_esports,
                          AppColors.lightPrimary,
                          isDark,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildStatCard(
                          AppStrings.avgMoves,
                          _stats['avgMovesPerGame'].toString(),
                          Icons.timeline,
                          AppColors.drawColor,
                          isDark,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],

              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _history.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history_rounded,
                                size: 64.sp,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                AppStrings.noHistoryYet,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: Colors.grey),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                AppStrings.playSomeGames,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: _history.length,
                          itemBuilder: (context, index) {
                            final game = _history[index];
                            return _buildHistoryCard(game, isDark);
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3), width: 2.w),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(GameHistoryModel game, bool isDark) {
    final winnerColor =
        game.isDraw
            ? AppColors.drawColor
            : game.winner == 'X'
            ? AppColors.playerXColor
            : AppColors.playerOColor;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: winnerColor.withOpacity(0.3), width: 2.w),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: winnerColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child:
                  game.isDraw
                      ? Icon(Icons.handshake, color: winnerColor, size: 24.sp)
                      : Text(
                        game.winner,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: winnerColor,
                        ),
                      ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.isDraw
                      ? AppStrings.draw
                      : AppStrings.playerWon.replaceFirst(
                        '{player}',
                        game.winner,
                      ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${game.totalMoves} ${AppStrings.moves} • ${_formatDate(game.completedAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(Icons.emoji_events_rounded, color: winnerColor, size: 24.sp),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        return '${diff.inMinutes}${AppStrings.minutesAgoSuffix}';
      }
      return '${diff.inHours}${AppStrings.hoursAgoSuffix}';
    } else if (diff.inDays == 1) {
      return AppStrings.yesterday;
    } else if (diff.inDays < 7) {
      return '${diff.inDays}${AppStrings.daysAgoSuffix}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
