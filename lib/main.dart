import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODOリスト',
      theme: ThemeData(
        primaryColor: Colors.cyan,
      ),
      home: LoginCheck(),
    );
  }
}

class LoginCheck extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null ? Home() : Login();
  }
}
