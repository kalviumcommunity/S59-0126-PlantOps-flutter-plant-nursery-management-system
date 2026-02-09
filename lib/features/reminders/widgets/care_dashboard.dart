import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Statistics card showing care task metrics
class CareStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const CareStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              // Value
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Care statistics dashboard widget
class CareDashboard extends StatelessWidget {
  final int totalTasks;
  final int dueTodayCount;
  final int overdueCount;
  final int completedThisWeek;

  const CareDashboard({
    super.key,
    required this.totalTasks,
    required this.dueTodayCount,
    required this.overdueCount,
    required this.completedThisWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Care Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          // Stats Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
            children: [
              CareStatsCard(
                title: 'Total Tasks',
                value: totalTasks.toString(),
                icon: Icons.eco,
                color: AppColors.primary,
              ),
              CareStatsCard(
                title: 'Due Today',
                value: dueTodayCount.toString(),
                icon: Icons.today,
                color: AppColors.warning,
              ),
              CareStatsCard(
                title: 'Overdue',
                value: overdueCount.toString(),
                icon: Icons.warning,
                color: AppColors.error,
              ),
              CareStatsCard(
                title: 'This Week',
                value: completedThisWeek.toString(),
                icon: Icons.check_circle,
                color: AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Progress indicator for care task completion
class CareProgressIndicator extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;

  const CareProgressIndicator({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = totalTasks > 0 ? (completedTasks / totalTasks * 100) : 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Progress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$completedTasks/$totalTasks tasks',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                minHeight: 12,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentage >= 100
                      ? AppColors.success
                      : percentage >= 50
                          ? AppColors.warning
                          : AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Percentage Text
            Center(
              child: Text(
                '${percentage.toStringAsFixed(0)}% Complete',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: percentage >= 100
                      ? AppColors.success
                      : percentage >= 50
                          ? AppColors.warning
                          : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
