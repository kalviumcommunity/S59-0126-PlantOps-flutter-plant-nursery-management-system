import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../../../models/plant_model.dart';
import '../controllers/plant_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/widgets/auth_text_field.dart';

/// Add plant screen for nursery staff
/// P4: Add Plant Screen ✅
class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({super.key});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _scientificNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _wateringController = TextEditingController();
  final _sunlightController = TextEditingController();
  final _soilController = TextEditingController();
  final _fertilizingController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedCategory = 'Indoor';

  @override
  void dispose() {
    _nameController.dispose();
    _scientificNameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _wateringController.dispose();
    _sunlightController.dispose();
    _soilController.dispose();
    _fertilizingController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _savePlant() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = context.read<AuthController>();
    final plantController = context.read<PlantController>();
    final user = authController.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to add plants'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Generate unique QR code
    const uuid = Uuid();
    final qrCode = 'plant_${uuid.v4()}';

    final plant = PlantModel(
      id: '',  // Firestore will generate this
      name: _nameController.text.trim(),
      scientificName: _scientificNameController.text.trim(),
      category: _selectedCategory,
      description: _descriptionController.text.trim(),
      imageUrl: _imageUrlController.text.trim().isEmpty 
          ? null 
          : _imageUrlController.text.trim(),
      nurseryId: user.id,
      nurseryName: user.nurseryName ?? user.name,
      wateringFrequency: _wateringController.text.trim(),
      sunlightRequirement: _sunlightController.text.trim(),
      soilType: _soilController.text.trim(),
      fertilizingSchedule: _fertilizingController.text.trim(),
      additionalCareNotes: _notesController.text.trim().isEmpty 
          ? null 
          : _notesController.text.trim(),
      createdAt: DateTime.now(),
      qrCode: qrCode,
    );

    final success = await plantController.addPlant(plant);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Plant added successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            plantController.errorMessage ?? 'Failed to add plant',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Plant'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Plant Name
              AuthTextField(
                controller: _nameController,
                label: 'Plant Name *',
                hint: 'e.g., Monstera Deliciosa',
                prefixIcon: Icons.local_florist,
                validator: (value) => 
                    Validators.validateRequired(value, 'Plant name'),
              ),
              const SizedBox(height: 16),
              // Scientific Name
              AuthTextField(
                controller: _scientificNameController,
                label: 'Scientific Name *',
                hint: 'e.g., Monstera deliciosa',
                prefixIcon: Icons.science,
                validator: (value) => 
                    Validators.validateRequired(value, 'Scientific name'),
              ),
              const SizedBox(height: 16),
              // Category
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category *',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      prefixIcon: const Icon(Icons.category),
                    ),
                    items: AppConstants.plantCategories
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategory = value!);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Description
              AuthTextField(
                controller: _descriptionController,
                label: 'Description *',
                hint: 'Describe the plant...',
                prefixIcon: Icons.description,
                validator: (value) => 
                    Validators.validateRequired(value, 'Description'),
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),
              // Image URL
              AuthTextField(
                controller: _imageUrlController,
                label: 'Image URL (Optional)',
                hint: 'https://example.com/plant-image.jpg',
                prefixIcon: Icons.image,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              // Care Instructions Header
              const Text(
                'Care Instructions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              // Watering
              AuthTextField(
                controller: _wateringController,
                label: 'Watering Frequency *',
                hint: 'e.g., Once a week',
                prefixIcon: Icons.water_drop,
                validator: (value) => 
                    Validators.validateRequired(value, 'Watering frequency'),
              ),
              const SizedBox(height: 16),
              // Sunlight
              AuthTextField(
                controller: _sunlightController,
                label: 'Sunlight Requirement *',
                hint: 'e.g., Bright indirect light',
                prefixIcon: Icons.wb_sunny,
                validator: (value) => 
                    Validators.validateRequired(value, 'Sunlight requirement'),
              ),
              const SizedBox(height: 16),
              // Soil
              AuthTextField(
                controller: _soilController,
                label: 'Soil Type *',
                hint: 'e.g., Well-draining potting mix',
                prefixIcon: Icons.grass,
                validator: (value) => 
                    Validators.validateRequired(value, 'Soil type'),
              ),
              const SizedBox(height: 16),
              // Fertilizing
              AuthTextField(
                controller: _fertilizingController,
                label: 'Fertilizing Schedule *',
                hint: 'e.g., Monthly during growing season',
                prefixIcon: Icons.spa,
                validator: (value) => 
                    Validators.validateRequired(value, 'Fertilizing schedule'),
              ),
              const SizedBox(height: 16),
              // Additional Notes
              AuthTextField(
                controller: _notesController,
                label: 'Additional Care Notes (Optional)',
                hint: 'Any other care tips...',
                prefixIcon: Icons.note,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 32),
              // Save Button
              Consumer<PlantController>(
                builder: (context, plantController, child) {
                  return CustomButton(
                    text: 'Add Plant',
                    onPressed: _savePlant,
                    isLoading: plantController.isLoading,
                    icon: Icons.add,
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                '* Required fields',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}