import 'package:defect_reporter/core/utils/validators.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'dart:ui';
import '../../core/theme/input_borders.dart';
import '../../services/auth_service.dart';

Future<bool?> showChangePasswordSheet(BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? error;
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  // Move controllers outside the builder so they persist for the lifetime of the bottom sheet
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void disposeControllers() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return WillPopScope(
            onWillPop: () async {
              disposeControllers();
              return true;
            },
            child: GestureDetector(
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
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(28),
                            ),
                            boxShadow: [
                              if (colorScheme.brightness != Brightness.dark)
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
                          // child: NotificationListener<DraggableScrollableNotification>(
                          //   onNotification: (notification) {
                          //     if (notification.extent <=
                          //         notification.minExtent + 0.01) {
                          //       disposeControllers();
                          //     }
                              //return false;
                            // },
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: 40,
                                        height: 4,
                                        margin: const EdgeInsets.only(
                                          bottom: 18,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.onSurface
                                              .withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Change Password',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: colorScheme.onSurface,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    CustomTextField(
                                      label: 'Current Password',
                                      controller: currentPasswordController,
                                      obscureText: true,
                                      border: InputBorders.adaptive(
                                        color: colorScheme.outline,
                                      ),
                                      enabledBorder: InputBorders.adaptive(
                                        color: colorScheme.outline,
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
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                          ? 'Enter your current password'
                                          : null,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      label: 'New Password',
                                      controller: newPasswordController,
                                      obscureText: true,
                                      border: InputBorders.adaptive(
                                        color: colorScheme.outline,
                                      ),
                                      enabledBorder: InputBorders.adaptive(
                                        color: colorScheme.outline,
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
                                      validator: Validators.validatePassword,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextField(
                                      label: 'Confirm Password',
                                      controller: confirmPasswordController,
                                      obscureText: true,
                                      border: InputBorders.adaptive(
                                        color: colorScheme.outline,
                                      ),
                                      enabledBorder: InputBorders.adaptive(
                                        color: colorScheme.outline,
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
                                              setState(() {
                                                isLoading = true;
                                                error = null;
                                              });
                                              if (formKey.currentState!
                                                  .validate()) {
                                                try {
                                                  await AuthService()
                                                      .changePassword(
                                                        currentPasswordController
                                                            .text,
                                                        newPasswordController
                                                            .text,
                                                      );
                                                  if (context.mounted) {
                                                    Navigator.pop(
                                                      context,
                                                      true,
                                                    );
                                                  }
                                                } catch (e) {
                                                  setState(() {
                                                    if (e
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(
                                                          'incorrect',
                                                        )) {
                                                      error =
                                                          'Incorrect current password.';
                                                    } else {
                                                      error = e.toString();
                                                    }
                                                  });
                                                }
                                              }
                                              setState(() => isLoading = false);
                                            },
                                    ),
                                    if (error != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 12.0,
                                        ),
                                        child: Text(
                                          error!,
                                          style: TextStyle(
                                            color: colorScheme.error,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
  return result;
}
