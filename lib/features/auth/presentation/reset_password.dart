import 'package:flutter/material.dart';
import '../../../core/theme/input_borders.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/utils/validators.dart';
import '../../../services/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService().resetPassword(
          _codeController.text,
          _newPasswordController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset successfully!')),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        setState(() {
          _error = e.toString();
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter the reset code sent to your email and choose a new password.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Reset Code',
                  controller: _codeController,
                  border: InputBorders.gray,
                  enabledBorder: InputBorders.gray,
                  focusedBorder: InputBorders.green,
                  errorBorder: InputBorders.red,
                  focusedErrorBorder: InputBorders.red,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter the reset code'
                      : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'New Password',
                  controller: _newPasswordController,
                  obscureText: true,
                  border: InputBorders.gray,
                  enabledBorder: InputBorders.gray,
                  focusedBorder: InputBorders.green,
                  errorBorder: InputBorders.red,
                  focusedErrorBorder: InputBorders.red,
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Confirm Password',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  border: InputBorders.gray,
                  enabledBorder: InputBorders.gray,
                  focusedBorder: InputBorders.green,
                  errorBorder: InputBorders.red,
                  focusedErrorBorder: InputBorders.red,
                  validator: (value) => Validators.validateConfirmPassword(
                    value,
                    _newPasswordController.text,
                  ),
                ),
                const SizedBox(height: 28),
                CustomButton(
                  label: _isLoading ? 'Resetting...' : 'Reset Password',
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _resetPassword,
                ),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
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
