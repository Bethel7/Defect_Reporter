import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/auth_service.dart';
import '../../../core/utils/validators.dart';

class ResetPasswordState {
  final bool isLoading;
  final String? error;
  final bool success;

  const ResetPasswordState({
    this.isLoading = false,
    this.error,
    this.success = false,
  });

  ResetPasswordState copyWith({bool? isLoading, String? error, bool? success}) {
    return ResetPasswordState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? this.success,
    );
  }

  factory ResetPasswordState.initial() => const ResetPasswordState();
}

class ResetPasswordNotifier extends StateNotifier<ResetPasswordState> {
  final AuthService _authService;
  ResetPasswordNotifier(this._authService)
    : super(ResetPasswordState.initial());

  String? validateCode(String? value) {
    if (value == null || value.isEmpty) return 'Enter the reset code';
    return null;
  }

  String? validatePassword(String? value) => Validators.validatePassword(value);

  String? validateConfirmPassword(String? value, String password) =>
      Validators.validateConfirmPassword(value, password);

  Future<void> resetPassword(
    String code,
    String newPassword,
    String confirmNewPassword,
  ) async {
    state = state.copyWith(isLoading: true, error: null, success: false);
    try {
      await _authService.resetPassword(code, newPassword, confirmNewPassword);
      state = state.copyWith(isLoading: false, success: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        success: false,
      );
    }
  }
}

final resetPasswordProvider =
    StateNotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
      (ref) => ResetPasswordNotifier(AuthService()),
    );
