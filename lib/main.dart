import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hoodhappen_creator/features/authentication/provider/auth_provider.dart';

import 'package:hoodhappen_creator/features/create_event/provider/create_event_provider.dart';
import 'package:hoodhappen_creator/features/get_event/provider/get_event_provider.dart';
import 'package:hoodhappen_creator/features/joined_events/provider/joined_event_provider.dart';
import 'package:hoodhappen_creator/features/my_events/provider/my_event_provider.dart';
import 'package:hoodhappen_creator/features/profile/provider/profile_provider.dart';
import 'package:hoodhappen_creator/features/splashs/provider/splash_provider.dart';
import 'package:hoodhappen_creator/routes/app_router.dart';
import 'package:hoodhappen_creator/theme/theme.dart';
import 'package:hoodhappen_creator/utils/helper.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message: ${message.notification?.title}");
}

void requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print("🔔 User granted permission: ${settings.authorizationStatus}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Helper.clearOnFirstLaunch();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  requestNotificationPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground notification: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification click se app open hua");
      // yahan tum navigation bhi karwa sakte ho
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CreateEventProvider()),
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => GetEventProvider()),
        ChangeNotifierProvider(create: (_) => MyEventProvider()),
        ChangeNotifierProvider(create: (_) => JoinedEventProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        title: 'Hood Happen',
        theme: theme,
      ),
    );
  }
}
