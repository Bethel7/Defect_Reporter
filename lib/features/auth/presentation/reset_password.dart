import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/input_borders.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import 'reset_password_notifier.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(resetPasswordProvider.notifier)
          .resetPassword(_codeController.text, _newPasswordController.text);
      final state = ref.read(resetPasswordProvider);
      if (state.success && mounted) {
        final theme = Theme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password reset successfully!'),
            backgroundColor: theme.colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resetState = ref.watch(resetPasswordProvider);
    // final isDark = theme.brightness == Brightness.dark;
    final borderGray = theme.dividerColor;
    final borderSuccess = theme.colorScheme.secondary;
    final borderError = theme.colorScheme.error;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
        title: Text(
          'Reset Password',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter the reset code sent to your email and choose a new password.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.85),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Reset Code',
                  controller: _codeController,
                  border: InputBorders.adaptive(color: borderGray),
                  enabledBorder: InputBorders.adaptive(color: borderGray),
                  focusedBorder: InputBorders.adaptive(color: borderSuccess),
                  errorBorder: InputBorders.adaptive(
                    color: borderError,
                    isError: true,
                  ),
                  focusedErrorBorder: InputBorders.adaptive(
                    color: borderError,
                    isError: true,
                  ),
                  validator: (value) => ref
                      .read(resetPasswordProvider.notifier)
                      .validateCode(value),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'New Password',
                  controller: _newPasswordController,
                  obscureText: true,
                  border: InputBorders.adaptive(color: borderGray),
                  enabledBorder: InputBorders.adaptive(color: borderGray),
                  focusedBorder: InputBorders.adaptive(color: borderSuccess),
                  errorBorder: InputBorders.adaptive(
                    color: borderError,
                    isError: true,
                  ),
                  focusedErrorBorder: InputBorders.adaptive(
                    color: borderError,
                    isError: true,
                  ),
                  validator: ref
                      .read(resetPasswordProvider.notifier)
                      .validatePassword,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  border: InputBorders.adaptive(color: borderGray),
                  enabledBorder: InputBorders.adaptive(color: borderGray),
                  focusedBorder: InputBorders.adaptive(color: borderSuccess),
                  errorBorder: InputBorders.adaptive(
                    color: borderError,
                    isError: true,
                  ),
                  focusedErrorBorder: InputBorders.adaptive(
                    color: borderError,
                    isError: true,
                  ),
                  validator: (value) => ref
                      .read(resetPasswordProvider.notifier)
                      .validateConfirmPassword(
                        value,
                        _newPasswordController.text,
                      ),
                ),
                const SizedBox(height: 28),
                CustomButton(
                  label: resetState.isLoading
                      ? 'Resetting...'
                      : 'Reset Password',
                  isLoading: resetState.isLoading,
                  onPressed: resetState.isLoading ? null : _submit,
                ),
                if (resetState.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      resetState.error!,
                      style:
                          theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                          ) ??
                          TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
