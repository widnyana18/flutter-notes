import 'package:flutter/material.dart';
import 'package:flutter_begineer/utils/dialogs/generic_dialog.dart';

Future<void> showConfirmPasswoedResetSendDialog(BuildContext context) {
  return showGenericDialog(
    context,
    title: 'Forgot Password',
    content:
        'We have mpw sent you a password reset link. Please check your email for more information',
    optionsBuilder: () => {'OKE': null},
  );
}
