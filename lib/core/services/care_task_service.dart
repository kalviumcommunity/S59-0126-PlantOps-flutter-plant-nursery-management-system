import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/care_task_model.dart';
import '../../models/plant_model.dart';
import './notification_service.dart';

/// Service to manage care tasks (automatic reminders)
class CareTaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  /// Auto-create care tasks when plant is added to collection
  /// Creates tasks for: watering, fertilizing, pest checking
  Future<void> createTasksForPlant({
    required String userId,
    required PlantModel plant,
    DateTime? startDate,
  }) async {
    print('\n🌱🌱🌱 === CREATING CARE TASKS ===');
    print('📝 Plant: ${plant.name}');
    print('📝 UserId: $userId');
    print('📝 Plant ID: ${plant.id}');
    print('📊 Care frequencies:');
    print('   - Watering: ${plant.wateringFrequencyDays} days');
    print('   - Fertilizing: ${plant.fertilizingFrequencyDays} days');
    print('   - Pest Check: ${plant.pestCheckFrequencyDays} days');
    
    final start = startDate ?? DateTime.now();
    final tasks = <Map<String, dynamic>>[];

    // Task 1: Watering
    if (plant.wateringFrequencyDays != null && plant.wateringFrequencyDays! > 0) {
      final wateringTask = CareTaskModel(
        id: '',  // Firestore will generate
        userId: userId,
        plantId: plant.id,
        plantName: plant.name,
        taskType: 'watering',
        title: '💧 Water ${plant.name}',
        description: plant.wateringFrequency,
        frequencyDays: plant.wateringFrequencyDays!,
        nextDueDate: start.add(Duration(days: plant.wateringFrequencyDays!)),
        createdAt: DateTime.now(),
      );
      
      final taskMap = wateringTask.toFirestore();
      tasks.add(taskMap);
      print('  ✅ Watering task prepared:');
      print('     - userId: ${taskMap['userId']}');
      print('     - isActive: ${taskMap['isActive']}');
      print('     - nextDueDate: ${taskMap['nextDueDate']}');
    }

    // Task 2: Fertilizing
    if (plant.fertilizingFrequencyDays != null && plant.fertilizingFrequencyDays! > 0) {
      final fertilizingTask = CareTaskModel(
        id: '',
        userId: userId,
        plantId: plant.id,
        plantName: plant.name,
        taskType: 'fertilizing',
        title: '🧪 Fertilize ${plant.name}',
        description: plant.fertilizingSchedule,
        frequencyDays: plant.fertilizingFrequencyDays!,
        nextDueDate: start.add(Duration(days: plant.fertilizingFrequencyDays!)),
        createdAt: DateTime.now(),
      );
      
      tasks.add(fertilizingTask.toFirestore());
      print('  ✅ Created fertilizing task (every ${plant.fertilizingFrequencyDays} days)');
    }

    // Task 3: Pest Check
    if (plant.pestCheckFrequencyDays != null && plant.pestCheckFrequencyDays! > 0) {
      final pestCheckTask = CareTaskModel(
        id: '',
        userId: userId,
        plantId: plant.id,
        plantName: plant.name,
        taskType: 'pest_check',
        title: '🐛 Check ${plant.name} for pests',
        description: 'Inspect leaves for signs of pests or disease',
        frequencyDays: plant.pestCheckFrequencyDays!,
        nextDueDate: start.add(Duration(days: plant.pestCheckFrequencyDays!)),
        createdAt: DateTime.now(),
      );
      
      tasks.add(pestCheckTask.toFirestore());
      print('  ✅ Created pest check task (every ${plant.pestCheckFrequencyDays} days)');
    }

    // Add defaults if no frequencies set
    if (tasks.isEmpty) {
      print('  ⚠️ No care schedule set, using defaults...');
      
      // Default watering (every 7 days)
      tasks.add(CareTaskModel(
        id: '',
        userId: userId,
        plantId: plant.id,
        plantName: plant.name,
        taskType: 'watering',
        title: '💧 Water ${plant.name}',
        description: 'Check soil moisture before watering',
        frequencyDays: 7,
        nextDueDate: start.add(const Duration(days: 7)),
        createdAt: DateTime.now(),
      ).toFirestore());
      
      print('  ✅ Created default watering task (every 7 days)');
    }

    // Batch write all tasks
    print('\n💾 Writing ${tasks.length} tasks to Firestore...');
    final batch = _firestore.batch();
    final taskRefs = <DocumentReference>[];
    
    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      final docRef = _firestore.collection('care_tasks').doc();
      print('   [$i] Writing task to doc: ${docRef.id}');
      print('       userId: ${task['userId']}');
      print('       plantName: ${task['plantName']}');
      print('       isActive: ${task['isActive']}');
      batch.set(docRef, task);
      taskRefs.add(docRef);
    }
    
    print('💾 Committing batch...');
    await batch.commit();
    print('✅✅✅ Successfully wrote ${tasks.length} tasks to Firestore!');
    
    // Verify tasks were written
    print('\n🔍 Verifying tasks in database...');
    for (final docRef in taskRefs) {
      final doc = await docRef.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        print('   ✓ Task ${docRef.id}: ${data['title']} (isActive: ${data['isActive']})');
      } else {
        print('   ❌ Task ${docRef.id} NOT FOUND!');
      }
    }
    
    // Schedule notifications for each task
    print('\n🔔 Scheduling notifications...');
    for (int i = 0; i < taskRefs.length; i++) {
      final docRef = taskRefs[i];
      final taskData = tasks[i];
      await _scheduleNotificationForTask(
        taskId: docRef.id,
        title: taskData['title'] as String,
        plantName: plant.name,
        nextDueDate: (taskData['nextDueDate'] as Timestamp).toDate(),
      );
    }
    print('✅ All notifications scheduled!');
    print('🎉 === CARE TASKS CREATION COMPLETE ===\n');
  }

  /// Get all active tasks for a user
  Future<List<CareTaskModel>> getTasksForUser(String userId) async {
    try {
      print('🔍 Querying tasks for userId: $userId');
      
      // SIMPLIFIED QUERY (no composite index needed)
      final snapshot = await _firestore
          .collection('care_tasks')
          .where('userId', isEqualTo: userId)
          .get();

      print('📊 Raw query returned ${snapshot.docs.length} documents');
      
      // Filter and sort in memory (avoid index requirement)
      final tasks = snapshot.docs
          .map((doc) {
            try {
              return CareTaskModel.fromFirestore(doc);
            } catch (e) {
              print('❌ Error parsing task ${doc.id}: $e');
              return null;
            }
          })
          .where((task) => task != null && task.isActive) // Filter active in memory
          .cast<CareTaskModel>()
          .toList();
      
      // Sort by nextDueDate in memory
      tasks.sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
      
      print('✅ Filtered to ${tasks.length} active tasks');
      
      return tasks;
    } catch (e, stackTrace) {
      print('❌ CRITICAL ERROR fetching tasks: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Get tasks for a specific plant
  Future<List<CareTaskModel>> getTasksForPlant(String userId, String plantId) async {
    try {
      // SIMPLIFIED QUERY (no composite index needed)
      final snapshot = await _firestore
          .collection('care_tasks')
          .where('userId', isEqualTo: userId)
          .where('plantId', isEqualTo: plantId)
          .get();

      // Filter and sort in memory
      final tasks = snapshot.docs
          .map((doc) => CareTaskModel.fromFirestore(doc))
          .where((task) => task.isActive)
          .toList();
      
      tasks.sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
      
      return tasks;
    } catch (e) {
      print('❌ Error fetching plant tasks: $e');
      return [];
    }
  }

  /// Mark task as complete and reschedule for next cycle
  Future<void> completeTask(String taskId) async {
    try {
      print('✅ Completing task $taskId...');
      
      final taskDoc = await _firestore.collection('care_tasks').doc(taskId).get();
      if (!taskDoc.exists) {
        throw 'Task not found';
      }

      final task = CareTaskModel.fromFirestore(taskDoc);
      
      // Calculate next due date
      final now = DateTime.now();
      final nextDue = now.add(Duration(days: task.frequencyDays));
      
      print('  → Next due date: $nextDue');

      // Update task
      await _firestore.collection('care_tasks').doc(taskId).update({
        'isCompleted': false,  // Reset for next cycle
        'lastCompletedDate': Timestamp.fromDate(now),
        'nextDueDate': Timestamp.fromDate(nextDue),
        'updatedAt': Timestamp.fromDate(now),
      });

      print('✅ Task completed and rescheduled!');
      
      // Schedule notification for next due date
      await _scheduleNotificationForTask(
        taskId: taskId,
        title: task.title,
        plantName: task.plantName,
        nextDueDate: nextDue,
      );
      print('🔔 Notification rescheduled!');
    } catch (e) {
      print('❌ Error completing task: $e');
      throw 'Failed to complete task: $e';
    }
  }

  /// Delete all tasks for a plant (when plant is removed)
  Future<void> deleteTasksForPlant(String userId, String plantId) async {
    try {
      print('🗑️ Deleting all tasks for plant $plantId...');
      
      final snapshot = await _firestore
          .collection('care_tasks')
          .where('userId', isEqualTo: userId)
          .where('plantId', isEqualTo: plantId)
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      print('✅ Deleted ${snapshot.docs.length} tasks');
    } catch (e) {
      print('❌ Error deleting tasks: $e');
    }
  }

  /// Clear ALL tasks for a user (for "Clear My Garden" feature)
  Future<void> clearAllTasksForUser(String userId) async {
    try {
      print('\n🗑️🗑️🗑️ === CLEARING ALL TASKS FOR USER ===');
      print('📝 UserId: $userId');
      
      final snapshot = await _firestore
          .collection('care_tasks')
          .where('userId', isEqualTo: userId)
          .get();

      print('📊 Found ${snapshot.docs.length} tasks to delete');

      if (snapshot.docs.isEmpty) {
        print('⚠️ No tasks found for this user');
        return;
      }

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        print('   🗑️ Deleting task: ${doc.id}');
        batch.delete(doc.reference);
        // Cancel notification for this task
        await _notificationService.cancelNotification(doc.id.hashCode);
      }
      
      await batch.commit();
      print('✅✅✅ Deleted ${snapshot.docs.length} tasks successfully!');
      print('🎉 === CLEAR COMPLETE ===\n');
    } catch (e, stackTrace) {
      print('❌ CRITICAL ERROR clearing tasks: $e');
      print('Stack trace: $stackTrace');
      throw 'Failed to clear tasks: $e';
    }
  }

  /// Update task frequency
  Future<void> updateTaskFrequency(String taskId, int newFrequencyDays) async {
    try {
      print('🔄 Updating task frequency to $newFrequencyDays days...');
      
      final taskDoc = await _firestore.collection('care_tasks').doc(taskId).get();
      if (!taskDoc.exists) {
        throw 'Task not found';
      }

      final task = CareTaskModel.fromFirestore(taskDoc);
      
      // Recalculate next due date based on new frequency
      final now = DateTime.now();
      final daysSinceLastComplete = task.lastCompletedDate != null
          ? now.difference(task.lastCompletedDate!).inDays
          : 0;
      
      final daysUntilNext = newFrequencyDays - daysSinceLastComplete;
      final nextDue = now.add(Duration(days: daysUntilNext > 0 ? daysUntilNext : 0));

      await _firestore.collection('care_tasks').doc(taskId).update({
        'frequencyDays': newFrequencyDays,
        'nextDueDate': Timestamp.fromDate(nextDue),
        'updatedAt': Timestamp.fromDate(now),
      });

      print('✅ Task frequency updated!');
    } catch (e) {
      print('❌ Error updating frequency: $e');
      throw 'Failed to update frequency: $e';
    }
  }

  /// Schedule a notification for a care task
  Future<void> _scheduleNotificationForTask({
    required String taskId,
    required String title,
    required String plantName,
    required DateTime nextDueDate,
  }) async {
    try {
      // Schedule notification for 9 AM on the due date
      final notificationTime = DateTime(
        nextDueDate.year,
        nextDueDate.month,
        nextDueDate.day,
        9, // 9 AM
        0,
      );

      // Generate unique notification ID from task ID
      final notificationId = taskId.hashCode.abs();

      await _notificationService.scheduleNotification(
        id: notificationId,
        title: '🌱 $title',
        body: 'Time to take care of your $plantName!',
        scheduledTime: notificationTime,
        payload: 'task_$taskId',
      );

      print('🔔 Notification scheduled for $notificationTime (ID: $notificationId)');
    } catch (e) {
      print('⚠️ Failed to schedule notification: $e');
      // Don't throw - task should still be created even if notification fails
    }
  }
}
