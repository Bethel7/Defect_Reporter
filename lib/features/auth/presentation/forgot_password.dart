import '../../../core/theme/input_borders.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../services/auth_service.dart';

final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordNotifier, AsyncValue<String?>>((ref) {
      final authService = AuthService();
      return ForgotPasswordNotifier(authService);
    });

class ForgotPasswordNotifier extends StateNotifier<AsyncValue<String?>> {
  final AuthService _authService;
  ForgotPasswordNotifier(this._authService)
    : super(const AsyncValue.data(null));

  Future<void> sendResetLink(String email) async {
    state = const AsyncValue.loading();
    try {
      await _authService.forgotPassword(email);
      state = const AsyncValue.data('Password reset link sent!');
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
    });
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await ref
        .read(forgotPasswordProvider.notifier)
        .sendResetLink(_emailController.text);
    final state = ref.read(forgotPasswordProvider);
    if (state is AsyncData && state.value != null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.value!)));
        Navigator.pushReplacementNamed(context, '/reset-password');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final forgotState = ref.watch(forgotPasswordProvider);
    final isLoading = forgotState is AsyncLoading;
    final error = forgotState is AsyncError
        ? forgotState.error.toString()
        : null;
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
                      border: InputBorders.gray,
                      enabledBorder: InputBorders.gray,
                      focusedBorder: InputBorders.gray,
                      errorBorder: InputBorders.red,
                      focusedErrorBorder: InputBorders.red,
                      prefixIcon: const Icon(
                        FontAwesomeIcons.envelope,
                        color: Color(0xFF717182),
                        size: 20,
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF252525),
                      ),
                      enabled: !isLoading,
                      validator: (value) {
                        if (!_submitted) return null;
                        return Validators.validateEmail(value);
                      },
                    ),
                  ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 32),
                  Semantics(
                    button: true,
                    label: 'Send reset Code',
                    child: SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        label: 'Send Reset Code',
                        onPressed: isLoading ? null : _submit,
                        isLoading: isLoading,
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
