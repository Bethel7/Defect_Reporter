class LoginState {
  final String employeeId;
  final String password;
  final bool isLoading;
  final String? error;

  LoginState({
    required this.employeeId,
    required this.password,
    required this.isLoading,
    this.error,
  });

  factory LoginState.initial() => LoginState(
        employeeId: '',
        password: '',
        isLoading: false,
        error: null,
      );

  LoginState copyWith({
    String? employeeId,
    String? password,
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      employeeId: employeeId ?? this.employeeId,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
