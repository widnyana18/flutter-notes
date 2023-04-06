import 'package:flutter/material.dart';
import 'package:flutter_begineer/extentions/context/loc.dart';
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
              content: context.loc.forgot_password_view_generic_error,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.forgot_password),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 25),
              Text(context.loc.forgot_password_view_prompt),
              const SizedBox(height: 20),
              TextField(
                controller: _textController,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: context.loc.email_text_field_placeholder),
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
                    child: Text(context.loc.forgot_password_view_send_me_link),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const LogoutEvent(),
                          );
                    },
                    child: Text(context.loc.forgot_password_view_back_to_login),
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
