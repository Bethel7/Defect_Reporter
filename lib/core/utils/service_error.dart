import 'package:dio/dio.dart';

class ServiceError implements Exception {
  final String userMessage; // User-friendly message
  final String debugMessage; // Technical message for debugging
  final int? statusCode;
  final dynamic data;

  ServiceError({
    required this.userMessage,
    required this.debugMessage,
    this.statusCode,
    this.data,
  });

  // Factory constructor for creating user-friendly errors
  factory ServiceError.fromDioError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    
    // Get the raw error message for debugging
    String debugMsg = _extractDebugMessage(e, data);
    
    // Convert to user-friendly message
    String userMsg = _toUserFriendlyMessage(debugMsg, status);
    
    return ServiceError(
      userMessage: userMsg,
      debugMessage: debugMsg,
      statusCode: status,
      data: data,
    );
  }

  // Extract technical message from DioException
  static String _extractDebugMessage(DioException e, dynamic data) {
    if (data is Map) {
      return data['Message'] ?? 
             data['message'] ?? 
             data['error'] ?? 
             e.message ?? 
             'Request failed';
    } else if (data is String && data.isNotEmpty) {
      return data;
    } else if (e.message != null) {
      return e.message!;
    }
    return 'Network error';
  }

  // Convert technical message to user-friendly message
  static String _toUserFriendlyMessage(String debugMsg, int? statusCode) {
    // Handle by status code first (most reliable)
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Authentication failed. Please check your credentials.';
      case 403:
        return 'Access denied. You don\'t have permission for this action.';
      case 404:
        return 'The requested resource was not found.';
      case 409:
        return 'Conflict occurred. This action cannot be completed.';
      case 500:
      case 502:
      case 503:
        return 'Server is temporarily unavailable. Please try again later.';
      case 504:
        return 'Request timeout. Please check your connection and try again.';
    }

    // Handle by common error message patterns
    final lowerMsg = debugMsg.toLowerCase();
    
    if (lowerMsg.contains('network') || lowerMsg.contains('connection')) {
      return 'Network connection failed. Please check your internet connection.';
    }
    
    if (lowerMsg.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    
    if (lowerMsg.contains('password') || lowerMsg.contains('credential')) {
      return 'Invalid credentials. Please check your employee ID and password.';
    }
    
    if (lowerMsg.contains('email') || lowerMsg.contains('mail')) {
      return 'Invalid email address. Please check and try again.';
    }
    
    if (lowerMsg.contains('token') || lowerMsg.contains('session')) {
      return 'Your session has expired. Please log in again.';
    }

    // Generic fallback messages based on context
    return 'Something went wrong. Please try again.';
  }

  @override
  String toString() => userMessage; // Show user-friendly message by default

  // For debugging purposes
  String toDebugString() => 'ServiceError: $debugMessage (Status: $statusCode)';
}

// Updated error handler
ServiceError handleDioError(DioException e) {
  return ServiceError.fromDioError(e);
}