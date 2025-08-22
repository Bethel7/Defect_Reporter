import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Helpers {
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Compresses an image file and returns the compressed file.
  /// [quality] ranges from 0 (worst) to 100 (best).
  /// [format] can be 'jpg' or 'png'. Defaults to 'jpg'.
  static Future<File?> compressImage(
    File file, {
    int quality = 70,
    String format = 'jpg',
  }) async {
    final ext = format.toLowerCase() == 'png' ? 'png' : 'jpg';
    final targetPath =
        '${file.parent.path}/compressed_${file.uri.pathSegments.last}.$ext';

    CompressFormat compressFormat = ext == 'png'
        ? CompressFormat.png
        : CompressFormat.jpeg;

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      format: compressFormat,
    );

    return result != null ? File(result.path) : null;
  }

  static Future<T> retryWithBackoff<T>(
    Future<T> Function() action, {
    int maxAttempts = 5,
    Duration initialDelay = const Duration(seconds: 2),
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;
    while (attempt < maxAttempts) {
      try {
        return await action(); // Success!
      } catch (e) {
        attempt++;
        if (attempt >= maxAttempts) rethrow;
        await Future.delayed(delay);
        delay *= 2; // Exponential backoff
      }
    }
    throw Exception('Max retry attempts reached');
  }
}
