import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/reminder_controller.dart';
import '../widgets/reminder_card.dart';

/// Main reminders screen
/// R14-R16: Reminders List Screen ✅
class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filterType = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReminders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReminders() async {
    final authController = context.read<AuthController>();
    final reminderController = context.read<ReminderController>();
    final userId = authController.currentUser?.id;

    if (userId == null) return;

    await Future.wait([
      reminderController.loadReminders(userId),
      reminderController.loadUpcomingReminders(userId),
      reminderController.loadOverdueReminders(userId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reminders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All', icon: Icon(Icons.list, size: 20)),
            Tab(text: 'Upcoming', icon: Icon(Icons.upcoming, size: 20)),
            Tab(text: 'Overdue', icon: Icon(Icons.warning_amber, size: 20)),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() => _filterType = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Types')),
              const PopupMenuItem(value: 'watering', child: Text('Watering')),
              const PopupMenuItem(
                  value: 'fertilizing', child: Text('Fertilizing')),
              const PopupMenuItem(value: 'pruning', child: Text('Pruning')),
              const PopupMenuItem(
                  value: 'repotting', child: Text('Repotting')),
              const PopupMenuItem(
                  value: 'pest_control', child: Text('Pest Control')),
            ],
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllReminders(),
          _buildUpcomingReminders(),
          _buildOverdueReminders(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-reminder');
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Reminder'),
      ),
    );
  }

  Widget _buildAllReminders() {
    return Consumer<ReminderController>(
      builder: (context, reminderController, child) {
        if (reminderController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var reminders = reminderController.allReminders;

        // Apply filter
        if (_filterType != 'all') {
          reminders = reminders.where((r) => r.type == _filterType).toList();
        }

        if (reminders.isEmpty) {
          return _buildEmptyState(
            'No reminders yet',
            'Create your first reminder to get started',
          );
        }

        return RefreshIndicator(
          onRefresh: _loadReminders,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              return ReminderCard(
                reminder: reminder,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/reminder-detail',
                    arguments: reminder.id,
                  );
                },
                onComplete: () async {
                  await reminderController.completeReminder(reminder.id);
                  _loadReminders();
                },
                onDelete: () async {
                  final confirm = await _showDeleteConfirmation();
                  if (confirm == true) {
                    await reminderController.deleteReminder(reminder.id);
                    _loadReminders();
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildUpcomingReminders() {
    return Consumer<ReminderController>(
      builder: (context, reminderController, child) {
        if (reminderController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var reminders = reminderController.upcomingReminders;

        // Apply filter
        if (_filterType != 'all') {
          reminders = reminders.where((r) => r.type == _filterType).toList();
        }

        if (reminders.isEmpty) {
          return _buildEmptyState(
            'No upcoming reminders',
            'You\'re all caught up!',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            final reminder = reminders[index];
            return ReminderCard(
              reminder: reminder,
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/reminder-detail',
                  arguments: reminder.id,
                );
              },
              onComplete: () async {
                await reminderController.completeReminder(reminder.id);
                _loadReminders();
              },
              onDelete: () async {
                final confirm = await _showDeleteConfirmation();
                if (confirm == true) {
                  await reminderController.deleteReminder(reminder.id);
                  _loadReminders();
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildOverdueReminders() {
    return Consumer<ReminderController>(
      builder: (context, reminderController, child) {
        if (reminderController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var reminders = reminderController.overdueReminders;

        // Apply filter
        if (_filterType != 'all') {
          reminders = reminders.where((r) => r.type == _filterType).toList();
        }

        if (reminders.isEmpty) {
          return _buildEmptyState(
            'No overdue reminders',
            'Great job staying on top of your plants!',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reminders.length,
          itemBuilder: (context, index) {
            final reminder = reminders[index];
            return ReminderCard(
              reminder: reminder,
              onTap: () {
                Navigator.of(context).pushNamed(
                  '/reminder-detail',
                  arguments: reminder.id,
                );
              },
              onComplete: () async {
                await reminderController.completeReminder(reminder.id);
                _loadReminders();
              },
              onDelete: () async {
                final confirm = await _showDeleteConfirmation();
                if (confirm == true) {
                  await reminderController.deleteReminder(reminder.id);
                  _loadReminders();
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 100,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reminder'),
        content: const Text(
          'Are you sure you want to delete this reminder?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
