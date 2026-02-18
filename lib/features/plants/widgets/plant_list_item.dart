import 'package:flutter/material.dart';
import '../../../models/plant_model.dart';
import '../../../core/theme/app_colors.dart';

/// List item widget for plant display (alternative to card)
class PlantListItem extends StatelessWidget {
  final PlantModel plant;
  final VoidCallback onTap;
  final VoidCallback? onAddToGarden;
  final VoidCallback? onRemove;
  final bool showActions;

  const PlantListItem({
    super.key,
    required this.plant,
    required this.onTap,
    this.onAddToGarden,
    this.onRemove,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Plant Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  plant.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.local_florist,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Plant Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plant Name
                    Text(
                      plant.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Scientific Name
                    if (plant.scientificName != null)
                      Text(
                        plant.scientificName!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    // Care Info Row
                    Row(
                      children: [
                        _buildInfoChip(
                          Icons.water_drop,
                          '${plant.wateringFrequencyDays ?? 0}d',
                          Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          Icons.wb_sunny,
                          _getLightShort(),
                          Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        if (plant.difficulty != null)
                          _buildDifficultyChip(),
                      ],
                    ),
                  ],
                ),
              ),
              // Actions
              if (showActions)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onAddToGarden != null)
                      IconButton(
                        icon: const Icon(Icons.add_circle),
                        color: AppColors.success,
                        onPressed: onAddToGarden,
                      ),
                    if (onRemove != null)
                      IconButton(
                        icon: const Icon(Icons.remove_circle),
                        color: AppColors.error,
                        onPressed: onRemove,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip() {
    Color color;
    switch (plant.difficulty?.toLowerCase()) {
      case 'easy':
        color = AppColors.success;
        break;
      case 'medium':
        color = AppColors.warning;
        break;
      case 'hard':
        color = AppColors.error;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        plant.difficulty!,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  String _getLightShort() {
    final light = plant.lightRequirement?.toLowerCase() ?? '';
    if (light.contains('high') || light.contains('full')) return 'High';
    if (light.contains('medium') || light.contains('moderate')) return 'Med';
    if (light.contains('low')) return 'Low';
    return 'N/A';
  }
}