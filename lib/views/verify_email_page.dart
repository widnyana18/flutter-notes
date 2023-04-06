import 'package:flutter/material.dart';
import 'package:flutter_begineer/extentions/context/loc.dart';
import 'package:flutter_begineer/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.verify_email),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 25),
            Text(context.loc.verify_email_view_prompt),
            const SizedBox(height: 20),
            Column(
              children: [
                TextButton(
                  onPressed: () async {
                    context.read<AuthBloc>().add(const VerifyEmailEvent());
                    // Navigator.of(context).pushNamedAndRemoveUntil(
                    //   notesRoute,
                    //   (route) => false,
                    // );
                  },
                  child: Text(context.loc.verify_email_send_email_verification),
                ),
              ],
            ),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(const LogoutEvent());
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   registerRoute,
                //   (route) => false,
                // );
              },
              child: Text(context.loc.restart),
            ),
          ],
        ),
      ),
    );
  }
}
