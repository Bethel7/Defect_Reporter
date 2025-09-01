import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:math';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class DateHelpers {
  static String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }
}

class FileHelpers {
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Compresses an image file and returns the compressed file.
  /// [quality] ranges from 0 (worst) to 100 (best).
  /// [format] can be 'jpg', 'png', or 'webp'. Defaults to 'jpg'.
  static Future<File> compressImage(
    File file, {
    int quality = 70,
    String format = 'jpg',
  }) async {
    final ext = format.toLowerCase();
    CompressFormat compressFormat;
    switch (ext) {
      case 'png':
        compressFormat = CompressFormat.png;
        break;
      case 'webp':
        compressFormat = CompressFormat.webp;
        break;
      default:
        compressFormat = CompressFormat.jpeg;
    }

    final tempDir = await getTemporaryDirectory();
    final targetPath =
        '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.${ext == 'png' || ext == 'webp' ? ext : 'jpg'}';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      format: compressFormat,
    );

    if (result == null) {
      throw Exception('Image compression failed');
    }
    return File(result.path);
  }
}

class NetworkHelpers {
  /// Retry with exponential backoff and jitter
  static Future<T> retryWithBackoff<T>(
    Future<T> Function() action, {
    int maxAttempts = 5,
    Duration initialDelay = const Duration(seconds: 2),
    Duration? maxDelay,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;
    final random = Random();
    while (attempt < maxAttempts) {
      try {
        return await action(); // Success!
      } catch (e) {
        attempt++;
        if (attempt >= maxAttempts) rethrow;
        // Add jitter: randomize delay by ±20%
        final jitter =
            delay.inMilliseconds * (0.2 * (random.nextDouble() - 0.5));
        final jitteredDelay = delay + Duration(milliseconds: jitter.round());
        await Future.delayed(jitteredDelay);
        delay = Duration(
          milliseconds: (delay.inMilliseconds * 2).clamp(
            initialDelay.inMilliseconds,
            maxDelay?.inMilliseconds ?? 60000,
          ),
        );
      }
    }
    throw Exception('Max retry attempts reached');
  }
}
