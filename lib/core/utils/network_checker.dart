import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// Utility for checking both network type and real internet connectivity status.
class NetworkChecker {
  static final NetworkChecker instance = NetworkChecker._internal();
  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _internetChecker = InternetConnectionChecker.instance;

  NetworkChecker._internal();
  factory NetworkChecker() => instance;

  /// Returns true if the device is actually connected to the internet.
  Future<bool> get isConnected async {
    return await _internetChecker.hasConnection;
  }

  /// Returns the current network type (Wi-Fi, mobile, none, etc.)
  Future<ConnectivityResult> get networkType async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty ? results.first : ConnectivityResult.none;
  }

  /// Stream of network type changes (Wi-Fi, mobile, none, etc.)
  Stream<ConnectivityResult> get onNetworkTypeChanged =>
      _connectivity.onConnectivityChanged.expand((results) => results);

  /// Stream of internet status changes (true = online, false = offline)
  Stream<bool> get onInternetStatusChange =>
      _internetChecker.onStatusChange.map(
        (status) => status == InternetConnectionStatus.connected,
      );
}