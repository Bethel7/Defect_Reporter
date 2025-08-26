import 'package:defect_reporter/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';
import 'login_provider.dart';
import '../../../core/theme/input_borders.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  bool _employeeIdValid = false;
  bool _passwordValid = false;
  bool _employeeIdTouched = false;
  bool _passwordTouched = false;
  bool _submitted = false;

  void _validateFields() {
    setState(() {
      _employeeIdValid =
          Validators.validateEmployeeId(_employeeIdController.text) == null;
      _passwordValid =
          Validators.validatePassword(_passwordController.text) == null;
    });
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Autofill: attempt to load saved credentials
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final savedEmployeeId = await _storage.read(key: 'employeeId');
      final savedPassword = await _storage.read(key: 'password');
      if (savedEmployeeId != null &&
          savedPassword != null &&
          _employeeIdController.text.isEmpty &&
          _passwordController.text.isEmpty) {
        setState(() {
          _employeeIdController.text = savedEmployeeId;
          _passwordController.text = savedPassword;
        });
      }
    });

    // Listen for login errors and show SnackBar automatically
    ref.listen(loginProvider, (previous, next) {
      if (next.error != null && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    final loginState = ref.watch(loginProvider);
    final loginNotifier = ref.read(loginProvider.notifier);

    // Use modular input borders
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          children: [
            CustomTextField(
              label: 'EmployeeID',
              controller: _employeeIdController,
              autofillHints: const [AutofillHints.username],
              validator: (val) {
                if (!_employeeIdTouched && !_submitted) return null;
                return Validators.validateEmployeeId(val);
              },
              onChanged: (val) {
                _employeeIdTouched = true;
                _validateFields();
              },
              onFieldSubmitted: (_) {
                setState(() {
                  _employeeIdTouched = true;
                });
              },
              border: InputBorders.gray,
              enabledBorder: InputBorders.gray,
              focusedBorder: _employeeIdValid
                  ? InputBorders.green
                  : InputBorders.gray,
              errorBorder: InputBorders.red,
              focusedErrorBorder: InputBorders.red,
              errorStyle: const TextStyle(color: AppColors.error),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Password',
              controller: _passwordController,
              obscureText: true,
              autofillHints: const [AutofillHints.password],
              validator: (val) {
                if (!_passwordTouched && !_submitted) return null;
                return Validators.validatePassword(val);
              },
              onChanged: (val) {
                _passwordTouched = true;
                _validateFields();
              },
              onFieldSubmitted: (_) {
                setState(() {
                  _passwordTouched = true;
                });
              },
              border: InputBorders.gray,
              enabledBorder: InputBorders.gray,
              focusedBorder: _passwordValid
                  ? InputBorders.green
                  : InputBorders.gray,
              errorBorder: InputBorders.red,
              focusedErrorBorder: InputBorders.red,
              errorStyle: const TextStyle(color: AppColors.error),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot-password');
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                label: 'Login',
                isLoading: loginState.isLoading,
                onPressed: loginState.isLoading
                    ? null
                    : () async {
                        setState(() {
                          _submitted = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          loginNotifier.setEmployeeId(
                            _employeeIdController.text,
                          );
                          loginNotifier.setPassword(_passwordController.text);
                          await _storage.write(
                            key: 'employeeId',
                            value: _employeeIdController.text,
                          );
                          await _storage.write(
                            key: 'password',
                            value: _passwordController.text,
                          );
                          final success = await loginNotifier.login(ref);
                          if (success && mounted) {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        }
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
