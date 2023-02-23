import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_begineer/firebase_options.dart';
import 'package:flutter_begineer/views/login_page.dart';
import 'package:flutter_begineer/views/register_page.dart';
import 'package:flutter_begineer/views/verify_email_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final user = FirebaseAuth.instance.currentUser;
          final emailVerified = user?.emailVerified ?? false;

          if (user != null) {
            if (emailVerified) {
              return Text('Email is verified');
            } else {
              return VerifyEmailpage();
            }
          } else {
            return LoginPage();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
