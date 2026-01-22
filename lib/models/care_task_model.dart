import 'package:cloud_firestore/cloud_firestore.dart';

/// Care Task Model - Represents a recurring plant care reminder
/// Examples: "Water Monstera", "Fertilize Snake Plant", "Check pests on Fiddle Leaf Fig"
class CareTaskModel {
  final String id;
  final String userId;
  final String plantId;
  final String plantName;
  final String taskType; // 'watering', 'fertilizing', 'pest_check'
  final String title; // e.g., "Water Monstera"
  final String? description; // Optional care instruction
  
  // Scheduling
  final int frequencyDays; // Repeat every X days
  final DateTime nextDueDate; // When this task is next due
  final DateTime? lastCompletedDate; // When was it last completed
  
  // Status
  final bool isCompleted; // True if marked as done for this cycle
  final bool isActive; // False if plant was removed or task disabled
  
  // Metadata
  final DateTime createdAt;
  final DateTime? updatedAt;

  CareTaskModel({
    required this.id,
    required this.userId,
    required this.plantId,
    required this.plantName,
    required this.taskType,
    required this.title,
    this.description,
    required this.frequencyDays,
    required this.nextDueDate,
    this.lastCompletedDate,
    this.isCompleted = false,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create from Firestore
  factory CareTaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return CareTaskModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      plantId: data['plantId'] ?? '',
      plantName: data['plantName'] ?? '',
      taskType: data['taskType'] ?? 'watering',
      title: data['title'] ?? '',
      description: data['description'],
      frequencyDays: data['frequencyDays'] ?? 7,
      nextDueDate: (data['nextDueDate'] as Timestamp).toDate(),
      lastCompletedDate: data['lastCompletedDate'] != null
          ? (data['lastCompletedDate'] as Timestamp).toDate()
          : null,
      isCompleted: data['isCompleted'] ?? false,
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert to Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'plantId': plantId,
      'plantName': plantName,
      'taskType': taskType,
      'title': title,
      'description': description,
      'frequencyDays': frequencyDays,
      'nextDueDate': Timestamp.fromDate(nextDueDate),
      'lastCompletedDate': lastCompletedDate != null
          ? Timestamp.fromDate(lastCompletedDate!)
          : null,
      'isCompleted': isCompleted,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// Copy with updated fields
  CareTaskModel copyWith({
    String? title,
    String? description,
    int? frequencyDays,
    DateTime? nextDueDate,
    DateTime? lastCompletedDate,
    bool? isCompleted,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return CareTaskModel(
      id: id,
      userId: userId,
      plantId: plantId,
      plantName: plantName,
      taskType: taskType,
      title: title ?? this.title,
      description: description ?? this.description,
      frequencyDays: frequencyDays ?? this.frequencyDays,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Check if task is overdue
  bool get isOverdue {
    return !isCompleted && nextDueDate.isBefore(DateTime.now());
  }

  /// Check if task is due today
  bool get isDueToday {
    final now = DateTime.now();
    return !isCompleted &&
        nextDueDate.year == now.year &&
        nextDueDate.month == now.month &&
        nextDueDate.day == now.day;
  }

  /// Check if task is due tomorrow
  bool get isDueTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return !isCompleted &&
        nextDueDate.year == tomorrow.year &&
        nextDueDate.month == tomorrow.month &&
        nextDueDate.day == tomorrow.day;
  }

  /// Get days until due (negative if overdue)
  int get daysUntilDue {
    final now = DateTime.now();
    final diff = nextDueDate.difference(DateTime(now.year, now.month, now.day));
    return diff.inDays;
  }

  /// Get icon based on task type
  String get icon {
    switch (taskType) {
      case 'watering':
        return '💧';
      case 'fertilizing':
        return '🧪';
      case 'pest_check':
        return '🐛';
      default:
        return '🌱';
    }
  }

  /// Get color based on due status
  String get statusColor {
    if (isCompleted) return 'green';
    if (isOverdue) return 'red';
    if (isDueToday) return 'orange';
    return 'gray';
  }
}
