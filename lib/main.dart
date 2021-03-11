import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Wasteagram',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TabController());
  }
}

class TabController extends StatelessWidget {
  static const tabs = [
    Tab(icon: Icon(Icons.map)),
    Tab(icon: Icon(Icons.picture_in_picture_sharp)),
    //Tab(icon: Icon(Icons.picture_as_pdf)),
  ];

  final screens = [
    ShareLocationScreen(),
    ListScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Wasteagram'),
          bottom: TabBar(tabs: tabs),
        ),
        body: SafeArea(child: TabBarView(children: screens)),
      ),
    );
  }
}
