import 'package:flutter/material.dart';
import 'package:flutter_begineer/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_begineer/utils/dialogs/dialogs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is ForgotPasswordState) {
          if (state.hasSentEmail) {
            _textController.clear();
            await showConfirmPasswoedResetSendDialog(context);
          }

          if (state.error != null) {
            await showErrorDialog(
              context,
              content:
                  'We could not process your request. Please make sure you are a registered user',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 25),
              const Text(
                  'Input your email to get the link of reset password in your inbox'),
              const SizedBox(height: 20),
              TextField(
                controller: _textController,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'your email...'),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      final email = _textController.text;
                      context.read<AuthBloc>().add(
                            ResetPasswordByEmailEvent(email),
                          );
                    },
                    child: const Text('Send me password reset link'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const LogoutEvent(),
                          );
                    },
                    child: const Text('Go back to login'),
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
