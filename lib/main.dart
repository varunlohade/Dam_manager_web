import 'package:firebase_core/firebase_core.dart';
import 'package:floodmanager/screens/home.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyBh8P1C2YRVnTv79j11qirc1c52sKQd6Q0',
          appId: '1:328244263238:android:01eb826f63cc4071bd4d47',
          messagingSenderId: '328244263238',
          projectId: 'genderdetection-8f69b'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}
