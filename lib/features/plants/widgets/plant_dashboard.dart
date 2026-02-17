import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Dashboard widget showing plant collection statistics
class PlantDashboard extends StatelessWidget {
  final int totalPlants;
  final int needsWaterToday;
  final int needsFertilizer;
  final int healthyPlants;

  const PlantDashboard({
    super.key,
    required this.totalPlants,
    required this.needsWaterToday,
    required this.needsFertilizer,
    required this.healthyPlants,
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
            'Garden Overview',
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
              _buildStatCard(
                'Total Plants',
                totalPlants.toString(),
                Icons.eco,
                AppColors.primary,
              ),
              _buildStatCard(
                'Needs Water',
                needsWaterToday.toString(),
                Icons.water_drop,
                Colors.blue,
              ),
              _buildStatCard(
                'Needs Fertilizer',
                needsFertilizer.toString(),
                Icons.spa,
                Colors.green,
              ),
              _buildStatCard(
                'Healthy',
                healthyPlants.toString(),
                Icons.favorite,
                AppColors.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            // Value
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Progress widget showing garden health
class GardenHealthWidget extends StatelessWidget {
  final int healthyPlants;
  final int totalPlants;

  const GardenHealthWidget({
    super.key,
    required this.healthyPlants,
    required this.totalPlants,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = totalPlants > 0 ? (healthyPlants / totalPlants * 100) : 0.0;

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
                  'Garden Health',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$healthyPlants/$totalPlants healthy',
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
                value: totalPlants > 0 ? healthyPlants / totalPlants : 0,
                minHeight: 12,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentage >= 80
                      ? AppColors.success
                      : percentage >= 50
                          ? AppColors.warning
                          : AppColors.error,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Percentage Text
            Center(
              child: Text(
                '${percentage.toStringAsFixed(0)}% Healthy',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: percentage >= 80
                      ? AppColors.success
                      : percentage >= 50
                          ? AppColors.warning
                          : AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}