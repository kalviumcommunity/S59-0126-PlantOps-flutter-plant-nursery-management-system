import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Dialog for completing a care task with notes
Future<String?> showCompleteTaskDialog(
  BuildContext context,
  String plantName,
  String taskType,
) {
  final notesController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Complete $taskType'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Great job caring for $plantName!',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: notesController,
            decoration: const InputDecoration(
              labelText: 'Notes (optional)',
              hintText: 'Plant looked healthy, added extra water...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(notesController.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
          ),
          child: const Text('Complete'),
        ),
      ],
    ),
  );
}

/// Dialog for skipping a care task
Future<bool?> showSkipTaskDialog(BuildContext context, String plantName) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Skip Task'),
      content: Text(
        'Skip this care task for $plantName? The next reminder will be rescheduled.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warning,
            foregroundColor: Colors.white,
          ),
          child: const Text('Skip'),
        ),
      ],
    ),
  );
}

/// Dialog for editing care task frequency
Future<int?> showEditFrequencyDialog(
  BuildContext context,
  int currentFrequency,
) {
  int selectedFrequency = currentFrequency;

  return showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Edit Frequency'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('How often should this task repeat?'),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: selectedFrequency,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Frequency',
            ),
            items: [
              for (int i in [1, 2, 3, 5, 7, 10, 14, 21, 30])
                DropdownMenuItem(
                  value: i,
                  child: Text('Every $i day${i > 1 ? 's' : ''}'),
                ),
            ],
            onChanged: (value) {
              if (value != null) selectedFrequency = value;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(selectedFrequency),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

/// Bottom sheet for care task actions
Future<String?> showCareTaskActions(
  BuildContext context,
  String plantName,
  String taskType,
) {
  return showModalBottomSheet<String>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '$plantName - $taskType',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // Actions
          ListTile(
            leading: const Icon(Icons.check_circle, color: AppColors.success),
            title: const Text('Complete Task'),
            onTap: () => Navigator.of(context).pop('complete'),
          ),
          ListTile(
            leading: const Icon(Icons.skip_next, color: AppColors.warning),
            title: const Text('Skip Task'),
            onTap: () => Navigator.of(context).pop('skip'),
          ),
          ListTile(
            leading: const Icon(Icons.repeat, color: AppColors.primary),
            title: const Text('Edit Frequency'),
            onTap: () => Navigator.of(context).pop('edit_frequency'),
          ),
          ListTile(
            leading: const Icon(Icons.visibility, color: AppColors.textSecondary),
            title: const Text('View Details'),
            onTap: () => Navigator.of(context).pop('view_details'),
          ),
          const SizedBox(height: 8),
          // Cancel Button
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    ),
  );
}
