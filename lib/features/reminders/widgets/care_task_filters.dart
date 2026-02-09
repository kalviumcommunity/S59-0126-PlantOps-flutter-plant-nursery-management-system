import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Filter chip for care task types
class CareTaskFilter extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const CareTaskFilter({
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

/// Horizontal scrollable filter bar for care tasks
class CareTaskFilterBar extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const CareTaskFilterBar({
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
          CareTaskFilter(
            label: 'All Tasks',
            icon: Icons.list,
            isSelected: selectedFilter == 'all',
            onTap: () => onFilterChanged('all'),
          ),
          const SizedBox(width: 8),
          CareTaskFilter(
            label: 'Watering',
            icon: Icons.water_drop,
            isSelected: selectedFilter == 'watering',
            onTap: () => onFilterChanged('watering'),
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          CareTaskFilter(
            label: 'Fertilizing',
            icon: Icons.spa,
            isSelected: selectedFilter == 'fertilizing',
            onTap: () => onFilterChanged('fertilizing'),
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          CareTaskFilter(
            label: 'Pruning',
            icon: Icons.content_cut,
            isSelected: selectedFilter == 'pruning',
            onTap: () => onFilterChanged('pruning'),
            color: Colors.orange,
          ),
          const SizedBox(width: 8),
          CareTaskFilter(
            label: 'Pest Check',
            icon: Icons.bug_report,
            isSelected: selectedFilter == 'pest_check',
            onTap: () => onFilterChanged('pest_check'),
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}

/// Sort dropdown for care tasks
class CareTaskSortDropdown extends StatelessWidget {
  final String selectedSort;
  final ValueChanged<String> onSortChanged;

  const CareTaskSortDropdown({
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
          value: 'due_date',
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 18),
              SizedBox(width: 12),
              Text('Sort by Due Date'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'plant_name',
          child: Row(
            children: [
              Icon(Icons.eco, size: 18),
              SizedBox(width: 12),
              Text('Sort by Plant Name'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'task_type',
          child: Row(
            children: [
              Icon(Icons.category, size: 18),
              SizedBox(width: 12),
              Text('Sort by Task Type'),
            ],
          ),
        ),
      ],
    );
  }
}
