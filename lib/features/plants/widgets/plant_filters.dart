import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Filter chip for plant categories
class PlantFilter extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const PlantFilter({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected ? chipColor : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? chipColor : AppColors.textSecondary,
            ),
          ),
        ],
      ),
      onSelected: (_) => onTap(),
      selectedColor: chipColor.withOpacity(0.15),
      checkmarkColor: chipColor,
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? chipColor : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
    );
  }
}

/// Horizontal scrollable filter bar for plants
class PlantFilterBar extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const PlantFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          PlantFilter(
            label: 'All Plants',
            icon: Icons.eco,
            isSelected: selectedFilter == 'all',
            onTap: () => onFilterChanged('all'),
          ),
          const SizedBox(width: 8),
          PlantFilter(
            label: 'Indoor',
            icon: Icons.home,
            isSelected: selectedFilter == 'indoor',
            onTap: () => onFilterChanged('indoor'),
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          PlantFilter(
            label: 'Outdoor',
            icon: Icons.park,
            isSelected: selectedFilter == 'outdoor',
            onTap: () => onFilterChanged('outdoor'),
            color: Colors.brown,
          ),
          const SizedBox(width: 8),
          PlantFilter(
            label: 'Easy Care',
            icon: Icons.child_care,
            isSelected: selectedFilter == 'easy',
            onTap: () => onFilterChanged('easy'),
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          PlantFilter(
            label: 'Low Light',
            icon: Icons.nights_stay,
            isSelected: selectedFilter == 'low_light',
            onTap: () => onFilterChanged('low_light'),
            color: Colors.purple,
          ),
        ],
      ),
    );
  }
}

/// Sort dropdown for plants
class PlantSortDropdown extends StatelessWidget {
  final String selectedSort;
  final ValueChanged<String> onSortChanged;

  const PlantSortDropdown({
    super.key,
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: selectedSort,
      onSelected: onSortChanged,
      icon: const Icon(Icons.sort),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'name',
          child: Row(
            children: [
              Icon(Icons.sort_by_alpha, size: 18),
              SizedBox(width: 12),
              Text('Sort by Name'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'difficulty',
          child: Row(
            children: [
              Icon(Icons.stars, size: 18),
              SizedBox(width: 12),
              Text('Sort by Difficulty'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'light',
          child: Row(
            children: [
              Icon(Icons.wb_sunny, size: 18),
              SizedBox(width: 12),
              Text('Sort by Light Need'),
            ],
          ),
        ),
      ],
    );
  }
}