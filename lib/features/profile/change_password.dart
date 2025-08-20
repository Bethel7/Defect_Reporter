import 'package:defect_reporter/core/utils/validators.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'dart:ui';

Future<void> showChangePasswordSheet(BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  String? error;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withOpacity(0.15),
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.55,
                  minChildSize: 0.4,
                  maxChildSize: 0.8,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 24,
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  margin: const EdgeInsets.only(bottom: 18),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const Text(
                                'Change Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: AppColors.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              CustomTextField(
                                label: 'New Password',
                                controller: newPasswordController,
                                obscureText: true,
                                validator: Validators.validatePassword,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                label: 'Confirm Password',
                                controller: confirmPasswordController,
                                obscureText: true,
                                validator: (value) =>
                                    Validators.validateConfirmPassword(
                                      value,
                                      newPasswordController.text,
                                    ),
                              ),
                              const SizedBox(height: 28),
                              CustomButton(
                                label: isLoading ? 'Saving...' : 'Save',
                                isLoading: isLoading,
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        setState(() => isLoading = true);
                                        if (formKey.currentState!.validate()) {
                                          await Future.delayed(
                                            const Duration(seconds: 1),
                                          );
                                          if (context.mounted) {
                                            Navigator.pop(context, true);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Password changed successfully!',
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          setState(() => isLoading = false);
                                        }
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
