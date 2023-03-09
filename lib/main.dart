import 'package:flutter/material.dart';
import 'package:flutter_begineer/services/auth/auth_service.dart';
import 'package:flutter_begineer/views/views.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/login/': (context) => const LoginPage(),
        '/register/': (context) => const RegisterPage(),
        '/notes/': (context) => const NotesPage(),
        '/verify-email/': (context) => const VerifyEmailPage(),
      },
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final user = AuthService.firebase().currentUser;

          if (user != null) {
            if (user.isEmailVerified) {
              return const NotesPage();
            } else {
              return const VerifyEmailPage();
            }
          } else {
            return const LoginPage();
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
