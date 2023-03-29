import 'package:flutter/material.dart';
import 'package:flutter_begineer/services/auth/auth_service.dart';
import 'package:flutter_begineer/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_begineer/utils/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        if (state is UnauthenticatedState) {
          if (state.error is UserNotFoundException) {
            await showErrorDialog(context, content: 'User not Found');
          } else if (state.error is WrongPasswordException) {
            await showErrorDialog(context, content: 'Wrong Password');
          } else if (state.error is GenericAuthException) {
            await showErrorDialog(context, content: 'Authentication Error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
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
                autofocus: true,
                decoration:
                    const InputDecoration(hintText: 'Enter your email here'),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                autofocus: true,
                decoration:
                    const InputDecoration(hintText: 'Enter your password here'),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  TextButton(
                    child: const Text('Login'),
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;

                      context.read<AuthBloc>().add(
                            LoginEvent(
                              email: email,
                              password: password,
                            ),
                          );
                      // Navigator.of(context)
                      //     .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(const ResetPasswordByEmailEvent(null));
                      // Navigator.of(context)
                      //     .pushNamedAndRemoveUntil(forgotPassword, (route) => false);
                    },
                    child: const Text('Forgot password?'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const NeedRegisterEvent());
                      // Navigator.of(context)
                      //     .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                    },
                    child: const Text('Not regitered yet? Register here!'),
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
