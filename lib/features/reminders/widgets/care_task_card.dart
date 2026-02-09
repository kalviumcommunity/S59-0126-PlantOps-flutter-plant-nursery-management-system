import 'package:flutter/material.dart';
import '../../../models/care_task_model.dart';
import '../../../core/theme/app_colors.dart';

/// Reusable card widget for displaying care tasks
/// Used in upcoming_care_screen.dart
class CareTaskCard extends StatelessWidget {
  final CareTaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  const CareTaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onComplete,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOverdue = task.isOverdue;
    final bool isDueToday = task.isDueToday;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isOverdue
              ? AppColors.error
              : isDueToday
                  ? AppColors.warning
                  : Colors.grey.shade300,
          width: isOverdue || isDueToday ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Task Type Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTaskColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTaskIcon(),
                      color: _getTaskColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Plant Name & Task Type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.plantName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getTaskTitle(),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  if (isOverdue || isDueToday)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isOverdue
                            ? AppColors.error.withOpacity(0.1)
                            : AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isOverdue ? 'Overdue' : 'Due Today',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isOverdue ? AppColors.error : AppColors.warning,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Due Date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    task.dueDateFormatted,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.repeat,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Every ${task.frequencyDays} days',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              if (task.notes != null && task.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  task.notes!,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 16),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onSkip,
                      icon: const Icon(Icons.skip_next, size: 18),
                      label: const Text('Skip'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: onComplete,
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Mark Complete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTaskIcon() {
    switch (task.taskType.toLowerCase()) {
      case 'watering':
        return Icons.water_drop;
      case 'fertilizing':
        return Icons.spa;
      case 'pruning':
        return Icons.content_cut;
      case 'pest_check':
        return Icons.bug_report;
      default:
        return Icons.eco;
    }
  }

  Color _getTaskColor() {
    switch (task.taskType.toLowerCase()) {
      case 'watering':
        return Colors.blue;
      case 'fertilizing':
        return Colors.green;
      case 'pruning':
        return Colors.orange;
      case 'pest_check':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  String _getTaskTitle() {
    switch (task.taskType.toLowerCase()) {
      case 'watering':
        return 'Time to water';
      case 'fertilizing':
        return 'Time to fertilize';
      case 'pruning':
        return 'Time to prune';
      case 'pest_check':
        return 'Check for pests';
      default:
        return 'Care task';
    }
  }
}
