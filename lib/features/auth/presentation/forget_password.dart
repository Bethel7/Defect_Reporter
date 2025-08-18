import '../../../widgets/custom_text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/custom_button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _submitted = false;
  bool _isLoading = false;

  void _submit() {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    // Simulate sending reset link
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset link sent!')),
        );
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Semantics(
          header: true,
          child: const Text(
            'Forgot Password',
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.text),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'Reset password instructions',
                    child: const Text(
                      'Enter your email to reset your password.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Semantics(
                    label: 'Email input field',
                    textField: true,
                    child: CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
                      ),
                      prefixIcon: const Icon(
                        FontAwesomeIcons.envelope,
                        color: Color(0xFF717182),
                        size: 20,
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF252525),
                      ),
                      enabled: !_isLoading,
                      validator: (value) {
                        if (!_submitted) return null;
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email ';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Semantics(
                    button: true,
                    label: 'Send reset link',
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        label: 'Send Reset Link',
                        onPressed: _isLoading ? null : _submit,
                        isLoading: _isLoading,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
