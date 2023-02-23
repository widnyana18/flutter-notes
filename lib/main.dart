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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // final user = FirebaseAuth.instance.currentUser;
            // final emailVerified = user?.emailVerified ?? false;
            // if (emailVerified) {
            //   return Text('Done');
            // } else {
            //   return VerifyEmailpage();
            // Navigator.of(context).push<void>(
            //   MaterialPageRoute<void>(
            //     builder: (context) => VerifyEmailpage(),
            //   ),
            // );
            // }
            return LoginPage();
          } else {
            return Text('Loading....');
          }
        },
      ),
    );
  }
}
