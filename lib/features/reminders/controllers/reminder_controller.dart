import 'package:flutter/material.dart';
import '../../../models/reminder_model.dart';
import '../../../models/plant_model.dart';
import '../repositories/reminder_repository.dart';

/// Controller for managing reminder state
/// R7-R12: Reminder State Management ✅
class ReminderController extends ChangeNotifier {
  final ReminderRepository _repository = ReminderRepository();

  List<ReminderModel> _allReminders = [];
  List<ReminderModel> _upcomingReminders = [];
  List<ReminderModel> _overdueReminders = [];
  ReminderModel? _selectedReminder;
  
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ReminderModel> get allReminders => _allReminders;
  List<ReminderModel> get upcomingReminders => _upcomingReminders;
  List<ReminderModel> get overdueReminders => _overdueReminders;
  ReminderModel? get selectedReminder => _selectedReminder;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all reminders for user
  Future<void> loadReminders(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allReminders = await _repository.getUserReminders(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load upcoming reminders
  Future<void> loadUpcomingReminders(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _upcomingReminders = await _repository.getUpcomingReminders(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load overdue reminders
  Future<void> loadOverdueReminders(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _overdueReminders = await _repository.getOverdueReminders(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load reminders for specific plant
  Future<List<ReminderModel>> loadPlantReminders(
    String userId,
    String plantId,
  ) async {
    try {
      return await _repository.getPlantReminders(userId, plantId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }

  /// Create a new reminder
  Future<bool> createReminder(ReminderModel reminder) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.createReminder(reminder);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update a reminder
  Future<bool> updateReminder(ReminderModel reminder) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.updateReminder(reminder);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete a reminder
  Future<bool> deleteReminder(String reminderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteReminder(reminderId);
      _allReminders.removeWhere((r) => r.id == reminderId);
      _upcomingReminders.removeWhere((r) => r.id == reminderId);
      _overdueReminders.removeWhere((r) => r.id == reminderId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Complete a reminder
  Future<bool> completeReminder(String reminderId) async {
    try {
      await _repository.completeReminder(reminderId);
      
      // Update local state
      for (var reminder in _allReminders) {
        if (reminder.id == reminderId) {
          reminder.isCompleted = true;
          reminder.completedAt = DateTime.now();
        }
      }
      _upcomingReminders.removeWhere((r) => r.id == reminderId);
      _overdueReminders.removeWhere((r) => r.id == reminderId);
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Toggle reminder enabled/disabled
  Future<bool> toggleReminder(String reminderId, bool isEnabled) async {
    try {
      await _repository.toggleReminder(reminderId, isEnabled);
      
      // Update local state
      for (var reminder in _allReminders) {
        if (reminder.id == reminderId) {
          reminder.isEnabled = isEnabled;
        }
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Auto-generate reminders for a new plant
  Future<bool> generatePlantReminders(
    PlantModel plant,
    String userId,
  ) async {
    try {
      final reminders = <ReminderModel>[];
      final now = DateTime.now();

      // Parse watering frequency
      final wateringDays = _parseFrequencyToDays(plant.wateringFrequency);
      if (wateringDays > 0) {
        reminders.add(ReminderModel(
          id: '',
          userId: userId,
          plantId: plant.id,
          plantName: plant.name,
          type: 'watering',
          title: 'Water ${plant.name}',
          description: plant.wateringFrequency,
          scheduledTime: now.add(Duration(days: wateringDays)),
          isRecurring: true,
          recurringPattern: 'every_$wateringDays\_days',
          createdAt: now,
        ));
      }

      // Fertilizing reminder (monthly by default)
      reminders.add(ReminderModel(
        id: '',
        userId: userId,
        plantId: plant.id,
        plantName: plant.name,
        type: 'fertilizing',
        title: 'Fertilize ${plant.name}',
        description: plant.fertilizingSchedule,
        scheduledTime: now.add(const Duration(days: 30)),
        isRecurring: true,
        recurringPattern: 'monthly',
        createdAt: now,
      ));

      // General care check reminder (bi-weekly)
      reminders.add(ReminderModel(
        id: '',
        userId: userId,
        plantId: plant.id,
        plantName: plant.name,
        type: 'general_care',
        title: 'Check ${plant.name}',
        description: 'Check for pests, diseases, and overall health',
        scheduledTime: now.add(const Duration(days: 14)),
        isRecurring: true,
        recurringPattern: 'bi_weekly',
        createdAt: now,
      ));

      await _repository.createBulkReminders(reminders);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Helper: Parse frequency string to days
  int _parseFrequencyToDays(String frequency) {
    final lower = frequency.toLowerCase();
    if (lower.contains('daily') || lower.contains('every day')) {
      return 1;
    } else if (lower.contains('twice') || lower.contains('2')) {
      return 3;
    } else if (lower.contains('weekly') || lower.contains('week')) {
      return 7;
    } else if (lower.contains('bi-weekly') || lower.contains('2 weeks')) {
      return 14;
    } else if (lower.contains('monthly') || lower.contains('month')) {
      return 30;
    }
    return 7; // Default to weekly
  }

  /// Filter reminders by type
  List<ReminderModel> filterByType(String type) {
    return _allReminders.where((r) => r.type == type).toList();
  }

  /// Filter reminders by plant
  List<ReminderModel> filterByPlant(String plantId) {
    return _allReminders.where((r) => r.plantId == plantId).toList();
  }

  /// Get today's reminders
  List<ReminderModel> getTodayReminders() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return _allReminders.where((r) {
      final reminderDate = DateTime(
        r.scheduledTime.year,
        r.scheduledTime.month,
        r.scheduledTime.day,
      );
      return reminderDate.isAtSameMomentAs(today) ||
          (reminderDate.isBefore(tomorrow) && !r.isCompleted);
    }).toList();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
