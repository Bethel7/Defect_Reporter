import 'package:defect_reporter/core/utils/validators.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  void _handleChangePassword() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    if (_formKey.currentState!.validate()) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pop(context, true); // Return to previous page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully!')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Semantics(
          label: 'Back',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.popAndPushNamed(context, '/settings'),
            tooltip: 'Back',
          ),
        ),
        title: Semantics(
          label: 'Change Password Page',
          header: true,
          child: Text(
            'Change Password',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Align(
              alignment : Alignment.topCenter,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Change Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Semantics(
                        label: 'New Password',
                        textField: true,
                        child: TextFormField(
                          controller: _newPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'New Password',
                            border: OutlineInputBorder(),
                          ),
                         validator: Validators.validatePassword,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Semantics(
                        label: 'Confirm Password',
                        textField: true,
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => Validators.validateConfirmPassword(
                            value,
                            _newPasswordController.text,
                          ),
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                      const SizedBox(height: 28),
                      Semantics(
                        label: 'Save new password',
                        button: true,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: _isLoading
                                ? null
                                : _handleChangePassword,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'SAVE',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
