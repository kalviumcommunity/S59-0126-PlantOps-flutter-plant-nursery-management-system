/// App-wide constants
/// Used by all features to maintain consistency
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // App Information
  static const String appName = 'PlantOps';
  static const String appTagline = 'Plant Care Made Easy';
  static const String appVersion = '1.0.0';

  // Firestore Collection Names
  static const String usersCollection = 'users';
  static const String plantsCollection = 'plants';
  static const String remindersCollection = 'reminders';
  static const String nurseriesCollection = 'nurseries';
  static const String userPlantsCollection = 'user_plants';

  // Firebase Storage Paths
  static const String plantImagesPath = 'plant_images';
  static const String userAvatarsPath = 'user_avatars';
  static const String nurseryLogosPath = 'nursery_logos';

  // Shared Preferences Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyNotificationsEnabled = 'notifications_enabled';

  // User Roles
  static const String roleCustomer = 'customer';
  static const String roleNurseryStaff = 'nursery_staff';
  static const String roleAdmin = 'admin';

  // Plant Categories
  static const List<String> plantCategories = [
    'Indoor',
    'Outdoor',
    'Succulents',
    'Herbs',
    'Flowering',
    'Trees',
    'Vegetables',
    'Other',
  ];

  // Care Types
  static const String careTypeWatering = 'watering';
  static const String careTypeFertilizing = 'fertilizing';
  static const String careTypePruning = 'pruning';
  static const String careTypeRepotting = 'repotting';

  // Reminder Frequencies
  static const String frequencyDaily = 'daily';
  static const String frequencyWeekly = 'weekly';
  static const String frequencyBiweekly = 'biweekly';
  static const String frequencyMonthly = 'monthly';

  // Notification Channels
  static const String notificationChannelId = 'plantops_reminders';
  static const String notificationChannelName = 'Plant Care Reminders';
  static const String notificationChannelDescription = 'Reminders for watering, fertilizing, and caring for your plants';

  // API Keys & External Services (add as needed)
  // static const String weatherApiKey = 'YOUR_API_KEY';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const int animationDurationMs = 300;

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPlantNameLength = 50;
  static const int maxDescriptionLength = 500;
}