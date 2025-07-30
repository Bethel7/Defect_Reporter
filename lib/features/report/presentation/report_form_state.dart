class ReportFormState {
  final String title;
  final String description;
  final String location;
  final String? imagePath;
  final bool isSubmitting;
  final String? error;

  ReportFormState({
    required this.title,
    required this.description,
    required this.location,
    this.imagePath,
    this.isSubmitting = false,
    this.error,
  });

  factory ReportFormState.initial() => ReportFormState(
        title: '',
        description: '',
        location: '',
        imagePath: null,
        isSubmitting: false,
        error: null,
      );

  ReportFormState copyWith({
    String? title,
    String? description,
    String? location,
    String? imagePath,
    bool? isSubmitting,
    String? error,
  }) {
    return ReportFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      imagePath: imagePath ?? this.imagePath,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}