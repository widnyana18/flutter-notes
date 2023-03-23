import 'package:flutter/material.dart';
import 'package:flutter_begineer/constants/routes.dart';
import 'package:flutter_begineer/services/auth/auth_service.dart';
import 'package:flutter_begineer/utils/dialogs/error_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            child: const Text('Register'),
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on WeakPasswordException {
                await showErrorDialog(context, content: 'Weak password');
              } on EmailAlreadyInUseException {
                await showErrorDialog(context, content: 'Email already in use');
              } on InvalidEmailException {
                await showErrorDialog(context, content: 'Invalid email');
              } on GenericAuthException {
                await showErrorDialog(context, content: 'Failed to register');
              }
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already registered? Login here!'),
          ),
        ],
      ),
    );
  }
}
