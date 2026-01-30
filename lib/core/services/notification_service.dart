import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

/// Mobile notification service using FCM and local notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  bool _isInitialized = false;
  String? _fcmToken;

  /// Initialize notification service
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Request FCM permission
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        debugPrint('⚠️ Notification permission denied');
        return false;
      }

      // Initialize local notifications
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings();
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Get FCM token
      _fcmToken = await _fcm.getToken();
      debugPrint('🔔 FCM Token: $_fcmToken');

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Listen to background messages
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

      _isInitialized = true;
      debugPrint('✅ Notification service initialized');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to initialize notifications: $e');
      return false;
    }
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('📬 Foreground message: ${message.notification?.title}');

    if (message.notification != null) {
      await showNotification(
        title: message.notification!.title ?? 'PlantOps',
        body: message.notification!.body ?? '',
      );
    }
  }

  /// Handle background messages
  void _handleBackgroundMessage(RemoteMessage message) {
    debugPrint('📬 Background message opened: ${message.notification?.title}');
    // Handle navigation based on message data
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('👆 Notification tapped: ${response.payload}');
    // Handle navigation based on payload
  }

  /// Show local notification
  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'plantops_channel',
      'PlantOps Notifications',
      channelDescription: 'Notifications for plant care reminders',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );

    debugPrint('🔔 Local notification shown: $title');
  }

  /// Schedule notification (simplified for now)
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    // For now, just show immediate notification
    // TODO: Implement proper scheduling with timezone package
    final delay = scheduledTime.difference(DateTime.now());
    
    if (delay.isNegative) {
      // Time already passed, show now
      await showNotification(title: title, body: body, payload: payload);
    } else {
      // Schedule using Future.delayed
      Future.delayed(delay, () async {
        await showNotification(title: title, body: body, payload: payload);
      });
    }

    debugPrint('⏰ Notification scheduled for ${scheduledTime.toString()}');
  }

  /// Cancel notification
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
    debugPrint('❌ Cancelled notification: $id');
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    debugPrint('❌ Cancelled all notifications');
  }

  /// Get FCM token
  String? get fcmToken => _fcmToken;

  /// Check if notifications are enabled
  bool get areNotificationsEnabled => _isInitialized;

  /// Show test notification
  Future<void> showTestNotification() async {
    await showNotification(
      title: '🌱 PlantOps Test',
      body: 'Notifications are working! You\'ll receive reminders for your plants.',
    );
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📬 Background message: ${message.notification?.title}');
}
