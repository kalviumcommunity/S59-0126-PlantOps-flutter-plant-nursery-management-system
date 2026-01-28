import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/plant_model.dart';

/// Plant card widget for lists
/// P2: Plant List Component ✅
class PlantCard extends StatelessWidget {
  final PlantModel plant;
  final VoidCallback onTap;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onTap,
  });

  Color _getCategoryColor() {
    switch (plant.category) {
      case 'Indoor':
        return Colors.green.shade700;
      case 'Outdoor':
        return Colors.blue.shade700;
      case 'Succulents':
        return Colors.orange.shade700;
      case 'Herbs':
        return Colors.purple.shade700;
      case 'Flowering':
        return Colors.pink.shade700;
      case 'Trees':
        return Colors.brown.shade700;
      case 'Vegetables':
        return Colors.red.shade700;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1,
                child: plant.imageUrl != null
                    ? Image.network(
                        plant.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),
            // Plant Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getCategoryColor(),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      plant.category,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getCategoryColor(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                  Text(
                    plant.scientificName,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Care Icons
                  Row(
                    children: [
                      Icon(
                        Icons.water_drop,
                        size: 14,
                        color: Colors.blue.shade600,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.wb_sunny,
                        size: 14,
                        color: Colors.orange.shade600,
                      ),
                      const Spacer(),
                      if (plant.viewCount > 0)
                        Row(
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 12,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${plant.viewCount}',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: const Center(
        child: Icon(
          Icons.local_florist,
          size: 48,
          color: AppColors.primary,
        ),
      ),
    );
  }
}