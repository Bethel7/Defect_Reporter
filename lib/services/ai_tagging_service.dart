class AITaggingService {
  Future<Map<String, String>> analyzeDescription(String description) async {
    // Simulate AI tagging
    await Future.delayed(const Duration(seconds: 1));
    return {
      'department': 'Engineering',
      'severity': 'High',
    };
  }
}