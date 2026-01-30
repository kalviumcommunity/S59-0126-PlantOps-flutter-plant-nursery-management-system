import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../models/care_task_model.dart';
import '../../../core/services/care_task_service.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../core/theme/app_colors.dart';

/// Upcoming Care Screen - Shows all care tasks organized by date
class UpcomingCareScreen extends StatefulWidget {
  const UpcomingCareScreen({Key? key}) : super(key: key);

  @override
  State<UpcomingCareScreen> createState() => _UpcomingCareScreenState();
}

class _UpcomingCareScreenState extends State<UpcomingCareScreen> {
  final CareTaskService _careTaskService = CareTaskService();
  List<CareTaskModel> _allTasks = [];
  bool _isLoading = true;
  String _filterStatus = 'all'; // 'all', 'today', 'overdue', 'upcoming'

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    
    try {
      // TEMPORARY: Use demo user if not authenticated
      final userId = context.read<AuthController>().currentUser?.id ?? 'demo_user_test';
      
      print('\n🔍🔍🔍 CARE TAB: Loading care tasks...');
      print('📝 User ID: $userId');
      
      final tasks = await _careTaskService.getTasksForUser(userId);
      
      print('📊 Query returned ${tasks.length} tasks');
      
      if (tasks.isEmpty) {
        print('❌ NO TASKS FOUND!');
        print('🔍 Checking Firestore directly...');
        
        // Direct Firestore check
        final firestore = FirebaseFirestore.instance;
        final allTasksSnapshot = await firestore.collection('care_tasks').get();
        print('📊 Total tasks in Firestore: ${allTasksSnapshot.docs.length}');
        
        if (allTasksSnapshot.docs.isNotEmpty) {
          print('🔍 Sample tasks in database:');
          for (var doc in allTasksSnapshot.docs.take(3)) {
            final data = doc.data();
            print('   - Task userId: ${data['userId']}, plantName: ${data['plantName']}');
          }
        }
      } else {
        print('✅ Successfully loaded ${tasks.length} care tasks:');
        for (final task in tasks) {
          print('   ✓ ${task.title} (Due: ${task.nextDueDate}, isActive: ${task.isActive})');
        }
      }
      
      setState(() {
        _allTasks = tasks;
        _isLoading = false;
      });
      
    } catch (e, stackTrace) {
      print('❌ CRITICAL ERROR loading tasks: $e');
      print('Stack trace: $stackTrace');
      setState(() => _isLoading = false);
    }
  }

  List<CareTaskModel> get _filteredTasks {
    switch (_filterStatus) {
      case 'today':
        return _allTasks.where((t) => t.isDueToday).toList();
      case 'overdue':
        return _allTasks.where((t) => t.isOverdue).toList();
      case 'upcoming':
        return _allTasks.where((t) => !t.isOverdue && !t.isDueToday).toList();
      default:
        return _allTasks;
    }
  }

  Future<void> _markAsDone(CareTaskModel task) async {
    try {
      await _careTaskService.completeTask(task.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ ${task.title} completed!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Reload tasks
      await _loadTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to complete task: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final overdueTasks = _allTasks.where((t) => t.isOverdue).length;
    final todayTasks = _allTasks.where((t) => t.isDueToday).length;
    final upcomingTasks = _allTasks.where((t) => !t.isOverdue && !t.isDueToday).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Upcoming Care', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTasks,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _allTasks.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    _buildSummaryCards(overdueTasks, todayTasks, upcomingTasks),
                    _buildFilterChips(),
                    Expanded(
                      child: _buildTaskList(),
                    ),
                  ],
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No care tasks yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Add plants to your collection to get\nautomatic care reminders!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(int overdue, int today, int upcoming) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Overdue',
              overdue,
              Icons.warning_amber_rounded,
              Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Today',
              today,
              Icons.today,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Upcoming',
              upcoming,
              Icons.calendar_today,
              AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip('All', 'all'),
          const SizedBox(width: 8),
          _buildFilterChip('Today', 'today'),
          const SizedBox(width: 8),
          _buildFilterChip('Overdue', 'overdue'),
          const SizedBox(width: 8),
          _buildFilterChip('Upcoming', 'upcoming'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildTaskList() {
    final tasks = _filteredTasks;

    if (tasks.isEmpty) {
      return Center(
        child:         Text(
          'No tasks in this category',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      );
    }

    // Group tasks by date
    final Map<String, List<CareTaskModel>> groupedTasks = {};
    for (final task in tasks) {
      final dateKey = _getDateKey(task.nextDueDate);
      if (!groupedTasks.containsKey(dateKey)) {
        groupedTasks[dateKey] = [];
      }
      groupedTasks[dateKey]!.add(task);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupedTasks.length,
      itemBuilder: (context, index) {
        final dateKey = groupedTasks.keys.elementAt(index);
        final tasksForDate = groupedTasks[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
              child:               Text(
                _formatDateHeader(tasksForDate.first.nextDueDate),
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...tasksForDate.map((task) => _buildTaskCard(task)).toList(),
          ],
        );
      },
    );
  }

  Widget _buildTaskCard(CareTaskModel task) {
    final isOverdue = task.isOverdue;
    final isDueToday = task.isDueToday;
    
    // Format exact date (e.g., "Jan 23, 2026")
    final dateFormat = DateFormat('MMM d, yyyy');
    final exactDate = dateFormat.format(task.nextDueDate);
    
    Color statusColor = AppColors.textSecondary;
    String statusText = '${task.daysUntilDue} days';
    
    if (isOverdue) {
      statusColor = Colors.red;
      statusText = '${-task.daysUntilDue} days overdue';
    } else if (isDueToday) {
      statusColor = Colors.orange;
      statusText = 'Due today';
    } else if (task.daysUntilDue == 1) {
      statusColor = Colors.orange;
      statusText = 'Tomorrow';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOverdue ? Colors.red.withOpacity(0.3) : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Text(
            task.icon,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            // Exact date (e.g., "Jan 23, 2026")
            Text(
              '📅 $exactDate',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            // Relative time (e.g., "7 days" or "Due today")
            Text(
              statusText,
              style: TextStyle(
                fontSize: 11,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (task.description != null) ...[
              const SizedBox(height: 4),
              Text(
                task.description!,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _markAsDone(task),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text('Done'),
        ),
      ),
    );
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);
    
    final difference = taskDate.difference(today).inDays;
    
    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference < 0) {
      return '${-difference} days ago';
    } else if (difference < 7) {
      return _getDayName(date);
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _getDayName(DateTime date) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[date.weekday - 1];
  }
}
