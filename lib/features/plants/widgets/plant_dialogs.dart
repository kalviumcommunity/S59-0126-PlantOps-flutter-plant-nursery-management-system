import 'package:flutter/material.dart';
import '../../../models/plant_model.dart';
import '../../../core/theme/app_colors.dart';

/// Dialog for confirming plant removal
Future<bool?> showDeletePlantDialog(
  BuildContext context,
  String plantName,
) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Remove Plant'),
      content: Text(
        'Are you sure you want to remove $plantName from your garden? All associated care reminders will be deleted.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
          ),
          child: const Text('Remove'),
        ),
      ],
    ),
  );
}

/// Dialog for adding plant to user's garden
Future<Map<String, dynamic>?> showAddToGardenDialog(
  BuildContext context,
  PlantModel plant,
) {
  final nicknameController = TextEditingController();
  final notesController = TextEditingController();

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add ${plant.name} to Garden'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Great choice! You can customize this plant:',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nicknameController,
              decoration: const InputDecoration(
                labelText: 'Nickname (optional)',
                hintText: 'e.g., "My Monstera"',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Location, special care instructions...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'nickname': nicknameController.text.trim(),
              'notes': notesController.text.trim(),
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
          ),
          child: const Text('Add to Garden'),
        ),
      ],
    ),
  );
}

/// Bottom sheet showing plant care guide
Future<void> showPlantCareGuide(
  BuildContext context,
  PlantModel plant,
) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          controller: scrollController,
          children: [
            // Header
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${plant.name} Care Guide',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // Watering
            _buildCareSection(
              Icons.water_drop,
              'Watering',
              plant.wateringInstructions ?? 'Water when soil is dry',
              'Every ${plant.wateringFrequencyDays ?? 7} days',
              Colors.blue,
            ),
            const SizedBox(height: 16),
            // Light
            _buildCareSection(
              Icons.wb_sunny,
              'Light',
              plant.lightRequirement ?? 'Moderate light',
              'Optimal conditions',
              Colors.orange,
            ),
            const SizedBox(height: 16),
            // Fertilizing
            _buildCareSection(
              Icons.spa,
              'Fertilizing',
              plant.fertilizingInstructions ?? 'Use balanced fertilizer',
              'Every ${plant.fertilizingFrequencyDays ?? 30} days',
              Colors.green,
            ),
            const SizedBox(height: 16),
            // Pest Control
            _buildCareSection(
              Icons.bug_report,
              'Pest Check',
              'Check leaves regularly for pests',
              'Every ${plant.pestCheckFrequencyDays ?? 14} days',
              Colors.red,
            ),
            const SizedBox(height: 24),
            // Close Button
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got It'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildCareSection(
  IconData icon,
  String title,
  String description,
  String frequency,
  Color color,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          frequency,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );
}