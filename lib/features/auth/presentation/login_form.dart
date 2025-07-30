import 'package:defect_reporter/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _employeeIdValid = false;
  bool _passwordValid = false;
  bool _isLoading = false;


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

  // disposes the controller to free up memory space and memory leaks
  @override
  void dispose() {
    _employeeIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder grayBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.borderGray),
    );
    OutlineInputBorder greenBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.borderGreen),
    );
    OutlineInputBorder redBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.borderRed),
    );
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
                border: grayBorder,
                enabledBorder: grayBorder,
                focusedBorder: _employeeIdValid ? greenBorder : grayBorder,
                errorBorder: redBorder,
                focusedErrorBorder: redBorder,
                errorStyle: const TextStyle(color: AppColors.error),
    ),
         const SizedBox(height: 16),
           CustomTextField(
               label: 'Password',
               controller: _passwordController,
               obscureText: true,
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
                    border: grayBorder,
                    enabledBorder: grayBorder,
                    focusedBorder: _passwordValid ? greenBorder : grayBorder,
                    errorBorder: redBorder,
                    focusedErrorBorder: redBorder,
                    errorStyle: const TextStyle(color: AppColors.error),
),
          const SizedBox(height: 24),
          CustomButton(
              label: 'Login',
              isLoading: _isLoading,
             onPressed: _isLoading
                      ? null
                      : () async {
                 setState(() {
                       _submitted = true;
             });
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            await Future.delayed(const Duration(seconds: 2));
            setState(() {
              _isLoading = false;
            });
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          }
        },
         ),
        ],
      ),
    ),
    );
  }
}
