import 'package:connectivity_plus/connectivity_plus.dart';

/// Utility for checking network connectivity status.
class NetworkChecker {
  static final NetworkChecker instance = NetworkChecker._internal();
  final Connectivity _connectivity = Connectivity();

  NetworkChecker._internal();
  factory NetworkChecker() => instance;

  /// Returns true if the device is connected to a network.
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Stream of connectivity changes.
  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.asyncExpand((results) => Stream.fromIterable(results));
}