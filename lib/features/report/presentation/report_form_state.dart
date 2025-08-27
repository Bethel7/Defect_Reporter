class ReportFormState {
  final String title;
  final String description;
  final int? locationId;
  final String? locationName;
  final String imagePath;
  final bool isSubmitting;
  final String? error;

  ReportFormState({
    required this.title,
    required this.description,
    required this.locationId,
    required this.locationName,
    required this.imagePath,
    this.isSubmitting = false,
    this.error,
  });

  factory ReportFormState.initial() => ReportFormState(
    title: '',
    description: '',
    locationId: null,
    locationName: null,
    imagePath: '',
    isSubmitting: false,
    error: null,
  );

  ReportFormState copyWith({
    String? title,
    String? description,
    int? locationId,
    String? locationName,
    String? imagePath,
    bool? isSubmitting,
    String? error,
  }) {
    return ReportFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      imagePath: imagePath ?? this.imagePath,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}
