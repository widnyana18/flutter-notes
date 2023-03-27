import 'package:flutter/material.dart';
import 'package:flutter_begineer/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text(
              "We've sent you an email verification. Please open it to verify your account."),
          const Text(
              "If you haven't recived a verification email yet, press the button below"),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(const VerifyEmailEvent());
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //   notesRoute,
              //   (route) => false,
              // );
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(const LogoutEvent());
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //   registerRoute,
              //   (route) => false,
              // );
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
