import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wasteagram/widgets/total_counter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/list_screen.dart';

bool USE_FIRESTORE_EMULATOR = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://638a88f6b8684578864442bb800b6366@o551707.ingest.sentry.io/5675387';
    },
    appRunner: () => runApp(MyApp()),
  );
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
