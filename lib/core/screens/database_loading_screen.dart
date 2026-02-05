import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/seed_data_fixed.dart';

/// Screen that checks and seeds database with visible progress
class DatabaseLoadingScreen extends StatefulWidget {
  const DatabaseLoadingScreen({super.key});

  @override
  State<DatabaseLoadingScreen> createState() => _DatabaseLoadingScreenState();
}

class _DatabaseLoadingScreenState extends State<DatabaseLoadingScreen> {
  String _status = 'Checking database...';
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkAndSeedDatabase();
  }

  Future<void> _checkAndSeedDatabase() async {
    try {
      // Step 1: Check if plants exist
      setState(() => _status = 'Connecting to database...');
      await Future.delayed(const Duration(milliseconds: 500));

      final hasPlants = await SeedDataFixed.hasPlants().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          setState(() => _status = 'Connection slow, assuming database is empty...');
          return false;
        },
      );

      if (!hasPlants) {
        // Step 2: Seed database
        setState(() => _status = 'Database is empty!\nSeeding 50 plants with images...');
        await Future.delayed(const Duration(milliseconds: 500));

        setState(() => _status = 'Adding plants (this takes 30-60 seconds)...');

        await SeedDataFixed.seedPlants(
          'demo_nursery',
          'PlantOps Demo Nursery',
        ).timeout(
          const Duration(minutes: 2),
        );

        setState(() => _status = 'Success! 50 plants loaded! 🎉');
        await Future.delayed(const Duration(seconds: 1));
      } else {
        // Check if existing plants have care frequencies
        setState(() => _status = 'Checking database integrity...');
        await Future.delayed(const Duration(milliseconds: 300));
        
        final firestore = FirebaseFirestore.instance;
        final firstPlant = await firestore.collection('plants').limit(1).get();
        
        if (firstPlant.docs.isNotEmpty) {
          final plantData = firstPlant.docs.first.data();
          final hasFrequencies = plantData.containsKey('wateringFrequencyDays') &&
                                  plantData.containsKey('fertilizingFrequencyDays') &&
                                  plantData.containsKey('pestCheckFrequencyDays');
          
          if (!hasFrequencies) {
            // OLD DATABASE - Auto-upgrade
            setState(() => _status = '⚠️ Old database detected!\nAuto-upgrading to new version...');
            await Future.delayed(const Duration(milliseconds: 500));
            
            // Delete old plants
            setState(() => _status = 'Removing old data...');
            final allPlants = await firestore.collection('plants').get();
            final batch = firestore.batch();
            for (var doc in allPlants.docs) {
              batch.delete(doc.reference);
            }
            await batch.commit();
            
            // Re-seed with new data
            setState(() => _status = 'Adding plants with care schedules...\n(30-60 seconds)');
            await SeedDataFixed.seedPlants(
              'demo_nursery',
              'PlantOps Demo Nursery',
            ).timeout(
              const Duration(minutes: 2),
            );
            
            setState(() => _status = '✅ Database upgraded successfully!');
            await Future.delayed(const Duration(seconds: 1));
          } else {
            setState(() => _status = 'Database ready! Loading app...');
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }
      }

      // Check if user has selected a role
      if (mounted) {
        final user = FirebaseAuth.instance.currentUser;
        final userId = user?.uid ?? 'demo_user_test';
        
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
          
          if (userDoc.exists && userDoc.data()?['userType'] != null) {
            // User has a role, go to home
            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            // User needs to select a role
            Navigator.of(context).pushReplacementNamed('/role-selection');
          }
        } catch (e) {
          print('Error checking user role: $e');
          // Default to role selection
          Navigator.of(context).pushReplacementNamed('/role-selection');
        }
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _status = 'Error loading database';
      });
    }
  }

  void _retrySeeding() {
    setState(() {
      _hasError = false;
      _errorMessage = null;
      _status = 'Retrying...';
    });
    _checkAndSeedDatabase();
  }

  void _skipToApp() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _hasError ? Colors.red.shade50 : AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_hasError) ...[
                  // Loading state
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _status,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Please wait...',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ] else ...[
                  // Error state
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _status,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _errorMessage ?? 'Unknown error',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontFamily: 'monospace',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _retrySeeding,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: _skipToApp,
                        child: const Text('Skip & Open App'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'You can manually seed via:\nSettings → Seed Plant Database',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}