import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/reminder_model.dart';

/// Repository for reminder-related operations
/// R1-R6: Reminder CRUD Operations ✅
class ReminderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'reminders';

  /// Create a new reminder
  Future<String?> createReminder(ReminderModel reminder) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'userId': reminder.userId,
        'plantId': reminder.plantId,
        'plantName': reminder.plantName,
        'type': reminder.type,
        'title': reminder.title,
        'description': reminder.description,
        'scheduledTime': Timestamp.fromDate(reminder.scheduledTime),
        'isRecurring': reminder.isRecurring,
        'recurringPattern': reminder.recurringPattern,
        'isCompleted': reminder.isCompleted,
        'completedAt': reminder.completedAt != null
            ? Timestamp.fromDate(reminder.completedAt!)
            : null,
        'createdAt': Timestamp.fromDate(reminder.createdAt),
        'isEnabled': reminder.isEnabled,
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create reminder: $e');
    }
  }

  /// Get all reminders for a user
  Future<List<ReminderModel>> getUserReminders(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('scheduledTime', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => _reminderFromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get reminders: $e');
    }
  }

  /// Get reminders for a specific plant
  Future<List<ReminderModel>> getPlantReminders(
    String userId,
    String plantId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('plantId', isEqualTo: plantId)
          .orderBy('scheduledTime', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => _reminderFromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get plant reminders: $e');
    }
  }

  /// Get upcoming reminders (next 7 days)
  Future<List<ReminderModel>> getUpcomingReminders(String userId) async {
    try {
      final now = DateTime.now();
      final nextWeek = now.add(const Duration(days: 7));

      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('isCompleted', isEqualTo: false)
          .where('isEnabled', isEqualTo: true)
          .where('scheduledTime', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .where('scheduledTime', isLessThan: Timestamp.fromDate(nextWeek))
          .orderBy('scheduledTime', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => _reminderFromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get upcoming reminders: $e');
    }
  }

  /// Get overdue reminders
  Future<List<ReminderModel>> getOverdueReminders(String userId) async {
    try {
      final now = DateTime.now();

      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('isCompleted', isEqualTo: false)
          .where('isEnabled', isEqualTo: true)
          .where('scheduledTime', isLessThan: Timestamp.fromDate(now))
          .orderBy('scheduledTime', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => _reminderFromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get overdue reminders: $e');
    }
  }

  /// Update a reminder
  Future<void> updateReminder(ReminderModel reminder) async {
    try {
      await _firestore.collection(_collection).doc(reminder.id).update({
        'type': reminder.type,
        'title': reminder.title,
        'description': reminder.description,
        'scheduledTime': Timestamp.fromDate(reminder.scheduledTime),
        'isRecurring': reminder.isRecurring,
        'recurringPattern': reminder.recurringPattern,
        'isCompleted': reminder.isCompleted,
        'completedAt': reminder.completedAt != null
            ? Timestamp.fromDate(reminder.completedAt!)
            : null,
        'isEnabled': reminder.isEnabled,
      });
    } catch (e) {
      throw Exception('Failed to update reminder: $e');
    }
  }

  /// Mark reminder as completed
  Future<void> completeReminder(String reminderId) async {
    try {
      await _firestore.collection(_collection).doc(reminderId).update({
        'isCompleted': true,
        'completedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to complete reminder: $e');
    }
  }

  /// Delete a reminder
  Future<void> deleteReminder(String reminderId) async {
    try {
      await _firestore.collection(_collection).doc(reminderId).delete();
    } catch (e) {
      throw Exception('Failed to delete reminder: $e');
    }
  }

  /// Toggle reminder enabled state
  Future<void> toggleReminder(String reminderId, bool isEnabled) async {
    try {
      await _firestore.collection(_collection).doc(reminderId).update({
        'isEnabled': isEnabled,
      });
    } catch (e) {
      throw Exception('Failed to toggle reminder: $e');
    }
  }

  /// Create multiple reminders at once
  Future<void> createBulkReminders(List<ReminderModel> reminders) async {
    try {
      final batch = _firestore.batch();

      for (var reminder in reminders) {
        final docRef = _firestore.collection(_collection).doc();
        batch.set(docRef, {
          'userId': reminder.userId,
          'plantId': reminder.plantId,
          'plantName': reminder.plantName,
          'type': reminder.type,
          'title': reminder.title,
          'description': reminder.description,
          'scheduledTime': Timestamp.fromDate(reminder.scheduledTime),
          'isRecurring': reminder.isRecurring,
          'recurringPattern': reminder.recurringPattern,
          'isCompleted': reminder.isCompleted,
          'completedAt': reminder.completedAt != null
              ? Timestamp.fromDate(reminder.completedAt!)
              : null,
          'createdAt': Timestamp.fromDate(reminder.createdAt),
          'isEnabled': reminder.isEnabled,
        });
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to create bulk reminders: $e');
    }
  }

  /// Delete all reminders for a plant
  Future<void> deletePlantReminders(String userId, String plantId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('plantId', isEqualTo: plantId)
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete plant reminders: $e');
    }
  }

  /// Helper: Convert Firestore document to ReminderModel
  ReminderModel _reminderFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReminderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      plantId: data['plantId'] ?? '',
      plantName: data['plantName'] ?? '',
      type: data['type'] ?? 'watering',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      scheduledTime: (data['scheduledTime'] as Timestamp).toDate(),
      isRecurring: data['isRecurring'] ?? false,
      recurringPattern: data['recurringPattern'],
      isCompleted: data['isCompleted'] ?? false,
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      isEnabled: data['isEnabled'] ?? true,
    );
  }
}
