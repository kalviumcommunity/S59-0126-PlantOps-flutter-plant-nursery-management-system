import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../../../models/reminder_model.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/widgets/auth_text_field.dart';
import '../controllers/reminder_controller.dart';

/// Add/Create new reminder screen
/// R17: Add Reminder Screen ✅
class AddReminderScreen extends StatefulWidget {
  final String? plantId;
  final String? plantName;

  const AddReminderScreen({
    super.key,
    this.plantId,
    this.plantName,
  });

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedType = 'watering';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isRecurring = false;
  String? _recurringPattern;

  @override
  void initState() {
    super.initState();
    if (widget.plantName != null) {
      _titleController.text = 'Water ${widget.plantName}';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) return;

    final authController = context.read<AuthController>();
    final reminderController = context.read<ReminderController>();
    final user = authController.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to create reminders'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Combine date and time
    final scheduledDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final reminder = ReminderModel(
      id: '',
      userId: user.id,
      plantId: widget.plantId ?? '',
      plantName: widget.plantName ?? 'All Plants',
      type: _selectedType,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      scheduledTime: scheduledDateTime,
      isRecurring: _isRecurring,
      recurringPattern: _isRecurring ? _recurringPattern : null,
      createdAt: DateTime.now(),
    );

    final success = await reminderController.createReminder(reminder);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder created successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            reminderController.errorMessage ?? 'Failed to create reminder',
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
        title: const Text('Add Reminder'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Type Selection
              const Text(
                'Reminder Type *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTypeChip('watering', 'Watering', Icons.water_drop),
                  _buildTypeChip('fertilizing', 'Fertilizing', Icons.spa),
                  _buildTypeChip('pruning', 'Pruning', Icons.content_cut),
                  _buildTypeChip('repotting', 'Repotting', Icons.move_down),
                  _buildTypeChip(
                      'pest_control', 'Pest Control', Icons.bug_report),
                  _buildTypeChip(
                      'general_care', 'General Care', Icons.check_circle),
                ],
              ),
              const SizedBox(height: 24),
              // Title
              AuthTextField(
                controller: _titleController,
                label: 'Title *',
                hint: 'e.g., Water Monstera',
                prefixIcon: Icons.title,
                validator: (value) =>
                    Validators.validateRequired(value, 'Title'),
              ),
              const SizedBox(height: 16),
              // Description
              AuthTextField(
                controller: _descriptionController,
                label: 'Description (Optional)',
                hint: 'Add details about this reminder...',
                prefixIcon: Icons.description,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 24),
              // Date Selection
              const Text(
                'Date *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() => _selectedDate = date);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Time Selection
              const Text(
                'Time *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (time != null) {
                    setState(() => _selectedTime = time);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        _selectedTime.format(context),
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Recurring Toggle
              SwitchListTile(
                title: const Text(
                  'Recurring Reminder',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  _isRecurring
                      ? 'This reminder will repeat'
                      : 'One-time reminder',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                value: _isRecurring,
                onChanged: (value) {
                  setState(() {
                    _isRecurring = value;
                    if (value && _recurringPattern == null) {
                      _recurringPattern = 'weekly';
                    }
                  });
                },
                activeColor: AppColors.primary,
              ),
              if (_isRecurring) ...[
                const SizedBox(height: 16),
                const Text(
                  'Repeat Pattern *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _recurringPattern,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    prefixIcon: const Icon(Icons.repeat),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(
                        value: 'every_2_days', child: Text('Every 2 days')),
                    DropdownMenuItem(
                        value: 'every_3_days', child: Text('Every 3 days')),
                    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                    DropdownMenuItem(
                        value: 'bi_weekly', child: Text('Bi-weekly')),
                    DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                  ],
                  onChanged: (value) {
                    setState(() => _recurringPattern = value);
                  },
                ),
              ],
              const SizedBox(height: 32),
              // Save Button
              Consumer<ReminderController>(
                builder: (context, reminderController, child) {
                  return CustomButton(
                    text: 'Create Reminder',
                    onPressed: _saveReminder,
                    isLoading: reminderController.isLoading,
                    icon: Icons.add,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type, String label, IconData icon) {
    final isSelected = _selectedType == type;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedType = type);
        }
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }
}
