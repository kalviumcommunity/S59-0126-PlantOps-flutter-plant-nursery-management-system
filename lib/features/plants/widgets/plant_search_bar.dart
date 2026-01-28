import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Search bar for plants
/// P6: Plant Search Component ✅
class PlantSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback? onClear;

  const PlantSearchBar({
    super.key,
    required this.onSearch,
    this.onClear,
  });

  @override
  State<PlantSearchBar> createState() => _PlantSearchBarState();
}

class _PlantSearchBarState extends State<PlantSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search plants...',
                border: InputBorder.none,
              ),
              onChanged: widget.onSearch,
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.clear,
                color: AppColors.textSecondary,
              ),
              onPressed: () {
                _controller.clear();
                widget.onSearch('');
                widget.onClear?.call();
              },
            ),
        ],
      ),
    );
  }
}