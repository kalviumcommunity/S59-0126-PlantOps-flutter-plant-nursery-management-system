import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/reminder_model.dart';

/// Widget to display a single reminder
/// R13: Reminder Card Widget ✅
class ReminderCard extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onTap;
  final VoidCallback onComplete;
  final VoidCallback onDelete;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.onTap,
    required this.onComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = reminder.scheduledTime.isBefore(DateTime.now()) &&
        !reminder.isCompleted;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isOverdue
              ? AppColors.error.withOpacity(0.5)
              : Colors.transparent,
          width: 2,
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
                  // Type Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTypeColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTypeIcon(),
                      color: _getTypeColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title & Plant Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            decoration: reminder.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reminder.plantName,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Complete Button
                  if (!reminder.isCompleted)
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      color: AppColors.success,
                      onPressed: onComplete,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // Description
              if (reminder.description != null &&
                  reminder.description!.isNotEmpty)
                Text(
                  reminder.description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              const SizedBox(height: 12),
              // Footer Row
              Row(
                children: [
                  // Time Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isOverdue
                          ? AppColors.error.withOpacity(0.1)
                          : AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isOverdue ? Icons.warning_amber : Icons.schedule,
                          size: 14,
                          color: isOverdue ? AppColors.error : AppColors.info,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getTimeText(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color:
                                isOverdue ? AppColors.error : AppColors.info,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Recurring Badge
                  if (reminder.isRecurring)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.repeat,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Recurring',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  // Delete Button
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: AppColors.error,
                    iconSize: 20,
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (reminder.type) {
      case 'watering':
        return Icons.water_drop;
      case 'fertilizing':
        return Icons.spa;
      case 'pruning':
        return Icons.content_cut;
      case 'repotting':
        return Icons.move_down;
      case 'pest_control':
        return Icons.bug_report;
      default:
        return Icons.check_circle;
    }
  }

  Color _getTypeColor() {
    switch (reminder.type) {
      case 'watering':
        return Colors.blue.shade600;
      case 'fertilizing':
        return Colors.green.shade600;
      case 'pruning':
        return Colors.orange.shade600;
      case 'repotting':
        return Colors.purple.shade600;
      case 'pest_control':
        return Colors.red.shade600;
      default:
        return AppColors.primary;
    }
  }

  String _getTimeText() {
    final now = DateTime.now();
    final difference = reminder.scheduledTime.difference(now);

    if (reminder.isCompleted) {
      return 'Completed';
    }

    if (difference.isNegative) {
      final days = difference.inDays.abs();
      if (days == 0) return 'Today (Overdue)';
      if (days == 1) return '1 day overdue';
      return '$days days overdue';
    }

    final days = difference.inDays;
    if (days == 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    if (days < 7) return 'In $days days';
    return 'In ${(days / 7).floor()} weeks';
  }
}
