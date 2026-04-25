import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context){
  return showGenericDialog(context: context, title: 'Password Reset', content: 'Your password reset link has been sent, please check your email', optionsBuilder: () => {
    'Ok':null,
  },);
}