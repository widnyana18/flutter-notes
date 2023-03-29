import 'package:flutter/material.dart';
import 'package:flutter_begineer/services/auth/auth_service.dart';
import 'package:flutter_begineer/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_begineer/utils/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is RegisteringState) {
          if (state.error is WeakPasswordException) {
            await showErrorDialog(context, content: 'Weak password');
          } else if (state.error is EmailAlreadyInUseException) {
            await showErrorDialog(context, content: 'Email already in use');
          } else if (state.error is InvalidEmailException) {
            await showErrorDialog(context, content: 'Invalid email');
          } else {
            await showErrorDialog(context, content: 'Failed to register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 25),
              const Text('Input your account address to display your notes'),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;

                      context.read<AuthBloc>().add(
                            RegisterEvent(
                              email: email,
                              password: password,
                            ),
                          );
                      // Navigator.of(context).pushNamed(verifyEmailRoute);
                    },
                    child: const Text('Register'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const LogoutEvent());
                      // Navigator.of(context)
                      //     .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                    },
                    child: const Text('Already registered? Login here!'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
