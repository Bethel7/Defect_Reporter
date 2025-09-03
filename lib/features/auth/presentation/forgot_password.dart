import '../../../core/theme/input_borders.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../core/constants/app_routes.dart';
import '../../../widgets/custom_button.dart';
import '../../../services/auth_service.dart';

final forgotPasswordProvider =
    StateNotifierProvider<ForgotPasswordNotifier, AsyncValue<String?>>(
      (ref) => ForgotPasswordNotifier(AuthService()),
    );

class ForgotPasswordNotifier extends StateNotifier<AsyncValue<String?>> {
  final AuthService _authService;
  ForgotPasswordNotifier(this._authService)
    : super(const AsyncValue.data(null));

  String? validateEmail(String? value) {
    return Validators.validateEmail(value);
  }

  Future<void> sendResetLink(String email) async {
    state = const AsyncValue.loading();
    try {
      final resultMsg = await _authService.forgotPassword(email);
      // If backend returns a message indicating failure, treat as error
      if (resultMsg.toLowerCase().contains('not found') ||
          resultMsg.toLowerCase().contains('error')) {
        state = AsyncValue.error(resultMsg, StackTrace.current);
      } else {
        state = AsyncValue.data(resultMsg);
      }
    } catch (e) {
      String message = 'An error occurred. Please try again.';
      if (e is Exception) {
        final msg = e.toString().toLowerCase();
        if (msg.contains('not found')) {
          message = 'No account found for this email.';
        } else if (msg.contains('network')) {
          message = 'Network error. Please check your connection.';
        }
      }
      state = AsyncValue.error(message, StackTrace.current);
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Use notifier's validation
    final emailError = ref
        .read(forgotPasswordProvider.notifier)
        .validateEmail(_emailController.text);
    if (emailError != null) {
      // Show error immediately
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(emailError),
          backgroundColor: colorScheme.primary,
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await ref
        .read(forgotPasswordProvider.notifier)
        .sendResetLink(_emailController.text);
    final state = ref.read(forgotPasswordProvider);
    if (state is AsyncData && state.value != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.value!),
            backgroundColor: colorScheme.primary,
          ),
        );
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
        title: Semantics(
          header: true,
          child: Text(
            'Forgot Password',
            style: theme.textTheme.titleLarge?.copyWith(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        centerTitle: false,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.07),
            height: 1,
          ),
        ),
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
                      border: InputBorders.adaptive(color: theme.dividerColor),
                      enabledBorder: InputBorders.adaptive(
                        color: theme.dividerColor,
                      ),
                      focusedBorder: InputBorders.adaptive(
                        color: colorScheme.primary,
                      ),
                      errorBorder: InputBorders.adaptive(
                        color: colorScheme.error,
                        isError: true,
                      ),
                      focusedErrorBorder: InputBorders.adaptive(
                        color: colorScheme.error,
                        isError: true,
                      ),
                      prefixIcon: Icon(
                        FontAwesomeIcons.envelope,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        color: colorScheme.onSurface,
                      ),
                      enabled: !isLoading,
                      validator: (value) {
                        if (!_submitted) return null;
                        return ref
                            .read(forgotPasswordProvider.notifier)
                            .validateEmail(value);
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
