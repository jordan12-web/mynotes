import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/theme/app_theme.dart';
import 'package:mynotes/widgets/auth_shell.dart';

class verifyEmailView extends StatelessWidget {
  const verifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthShell(
      title: 'Verify your email',
      subtitle:
          'We sent a confirmation link to your inbox. Tap the link, then return here.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.mark_email_unread_outlined, color: AppColors.primary, size: 32),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Did not receive it? Resend the verification email below.',
                    style: TextStyle(color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
            },
            child: const Text('Resend verification email'),
          ),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventLogOut());
            },
            child: const Text('Use a different account'),
          ),
        ],
      ),
    );
  }
}
