import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Auth
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/profile_screen.dart';
import 'features/auth/screens/edit_profile_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/auth/screens/settings_screen.dart';
import 'features/auth/controllers/auth_controller.dart';

// Plants
import 'features/plants/screens/plant_list_screen.dart';
import 'features/plants/screens/plant_detail_screen.dart';
import 'features/plants/screens/add_plant_screen.dart';
import 'features/plants/screens/my_plants_screen.dart';
import 'features/plants/screens/qr_code_display_screen.dart';
import 'features/plants/screens/qr_scanner_screen.dart';
import 'features/plants/controllers/plant_controller.dart';

// Reminders
import 'features/reminders/screens/reminders_screen.dart';
import 'features/reminders/screens/add_reminder_screen.dart';
import 'features/reminders/controllers/reminder_controller.dart';

// Models
import 'models/plant_model.dart';

// Services
import 'core/services/notification_service.dart';
import 'core/services/cloudinary_service.dart';

// Utilities
import 'core/utils/seed_data.dart';

// Background message handler (must be top-level)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('📬 Background message: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with platform-specific options
  if (kIsWeb) {
    // Web-specific Firebase configuration
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyASq7AVToqHrNj0dr783I5ap_Wj9S9BdqU",
        authDomain: "plantops-c2202.firebaseapp.com",
        projectId: "plantops-c2202",
        storageBucket: "plantops-c2202.firebasestorage.app",
        messagingSenderId: "886126051689",
        appId: "1:886126051689:web:7c45d941d3712378f67df8",
        measurementId: "G-HCRTWHNGFT",
      ),
    );
  } else {
    // Android/iOS will use google-services.json/GoogleService-Info.plist
    await Firebase.initializeApp();
    
    // Initialize Firebase Cloud Messaging background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Initialize mobile notification service
    await NotificationService().initialize();
  }
  
  // Initialize Cloudinary
  CloudinaryService().initialize();
  
  // Auto-seed database if empty (production-ready!)
  await _autoSeedIfNeeded();
  
  runApp(const PlantOpsApp());
}

/// Auto-seed the database with sample plants if it's empty
Future<void> _autoSeedIfNeeded() async {
  try {
    final hasPlants = await SeedData.hasPlants();
    if (!hasPlants) {
      print('🌱 Auto-seeding plant database for first-time setup...');
      // Use a default nursery for sample plants
      await SeedData.seedPlants(
        'demo_nursery',
        'PlantOps Demo Nursery',
      );
      print('✅ Database seeded successfully!');
    }
  } catch (e) {
    print('⚠️ Auto-seed skipped: $e');
    // Don't block app startup if seeding fails
  }
}

class PlantOpsApp extends StatelessWidget {
  const PlantOpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // State Management
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => PlantController()),
        ChangeNotifierProvider(create: (_) => ReminderController()),
      ],
      child: MaterialApp(
        title: 'PlantOps',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        // Start with Splash Screen
        home: const SplashScreen(),
        // Routes with arguments handled via onGenerateRoute
        onGenerateRoute: (settings) {
          switch (settings.name) {
            // Plant Detail requires ID argument
            case '/plant-detail':
              final plantId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => PlantDetailScreen(plantId: plantId),
              );
            
            // QR Code Display requires PlantModel argument
            case '/qr-display':
              final plant = settings.arguments as PlantModel;
              return MaterialPageRoute(
                builder: (context) => QRCodeDisplayScreen(plant: plant),
              );
            
            default:
              return null;
          }
        },
        routes: {
          // Auth routes
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/edit-profile': (context) => const EditProfileScreen(),
          '/settings': (context) => const SettingsScreen(),
          
          // Plant routes
          '/home': (context) => const PlantListScreen(),
          '/plants': (context) => const PlantListScreen(),
          '/add-plant': (context) => const AddPlantScreen(),
          '/my-plants': (context) => const MyPlantsScreen(),
          '/qr-scanner': (context) => const QRScannerScreen(),
          
          // Reminder routes
          '/reminders': (context) => const RemindersScreen(),
          '/add-reminder': (context) => const AddReminderScreen(),
        },
      ),
    );
  }
}

// Temporary placeholder - will be replaced by Person 1's SplashScreen on Day 1
class PlaceholderHome extends StatelessWidget {
  const PlaceholderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_florist,
              size: 100,
              color: Colors.green.shade700,
            ),
            const SizedBox(height: 24),
            const Text(
              'PlantOps',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Plant Care Made Easy',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              'Development Starting Soon...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
