import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../controllers/plant_controller.dart';
import '../widgets/plant_card.dart';
import '../widgets/plant_search_bar.dart';

/// Main plant catalog screen
/// P2: Plant List Screen ✅
class PlantListScreen extends StatefulWidget {
  const PlantListScreen({super.key});

  @override
  State<PlantListScreen> createState() => _PlantListScreenState();
}

class _PlantListScreenState extends State<PlantListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlantController>().loadPlants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Catalog'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.of(context).pushNamed('/qr-scanner');
            },
            tooltip: 'Scan QR Code',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
            tooltip: 'Settings & Admin',
          ),
        ],
      ),
      body: Consumer<PlantController>(
        builder: (context, plantController, child) {
          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: PlantSearchBar(
                  onSearch: (query) {
                    plantController.searchPlants(query);
                  },
                  onClear: () {
                    plantController.clearSearch();
                  },
                ),
              ),
              // Category Filter
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _CategoryChip(
                      label: 'All',
                      isSelected: plantController.selectedCategory == 'All',
                      onTap: () => plantController.filterByCategory('All'),
                    ),
                    ...AppConstants.plantCategories.map((category) =>
                        _CategoryChip(
                          label: category,
                          isSelected: plantController.selectedCategory == category,
                          onTap: () => plantController.filterByCategory(category),
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Plants Grid
              Expanded(
                child: plantController.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : plantController.plants.isEmpty
                        ? _buildEmptyState(plantController.searchQuery)
                        : RefreshIndicator(
                            onRefresh: () => plantController.loadPlants(),
                            child: GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: plantController.plants.length,
                              itemBuilder: (context, index) {
                                final plant = plantController.plants[index];
                                return PlantCard(
                                  plant: plant,
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      '/plant-detail',
                                      arguments: plant.id,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<PlantController>(
        builder: (context, plantController, child) {
          // Show FAB only for nursery staff
          // TODO: Check user role from AuthController
          return FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/add-plant');
            },
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String searchQuery) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            searchQuery.isNotEmpty ? Icons.search_off : Icons.local_florist,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            searchQuery.isNotEmpty
                ? 'No plants found for "$searchQuery"'
                : 'No plants available yet',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (searchQuery.isEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Be the first to add a plant!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.grey.shade300,
        ),
      ),
    );
  }
}