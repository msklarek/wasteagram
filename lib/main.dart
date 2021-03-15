import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:wasteagram/widgets/total_counter.dart';
import 'location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/list_screen.dart';

bool USE_FIRESTORE_EMULATOR = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Wasteagram',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorObservers: <NavigatorObserver>[observer],
        home: Scaffold(
            appBar: TotalCounter(context),
            body: ListScreen(
              analytics: analytics,
              observer: observer,
            )));
  }
}
