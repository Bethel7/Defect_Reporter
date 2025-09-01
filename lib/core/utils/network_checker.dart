import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Checks the current network type (Wi-Fi, mobile, none, etc.)
class NetworkTypeChecker {
  static final NetworkTypeChecker instance = NetworkTypeChecker._internal();
  final Connectivity _connectivity = Connectivity();

  NetworkTypeChecker._internal();
  factory NetworkTypeChecker() => instance;

  Future<ConnectivityResult> get networkType async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.isNotEmpty) {
        return results.first;
      }
      return ConnectivityResult.none;
    } catch (e) {
      return ConnectivityResult.none;
    }
  }

  /// Emits network type changes (Wi-Fi, mobile, none, etc.)
  Stream<ConnectivityResult> get onNetworkTypeChanged => _connectivity
      .onConnectivityChanged
      .map(
        (results) =>
            results.isNotEmpty ? results.first : ConnectivityResult.none,
      )
      .distinct();
}

/// Checks for real internet connectivity (not just network connection)
class InternetStatusChecker {
  static final InternetStatusChecker instance =
      InternetStatusChecker._internal();
  final InternetConnectionChecker _internetChecker =
      InternetConnectionChecker.instance;

  InternetStatusChecker._internal();
  factory InternetStatusChecker() => instance;

  Future<bool> get isConnected async {
    try {
      return await _internetChecker.hasConnection;
    } catch (e) {
      return false;
    }
  }

  /// Emits true if online, false if offline
  Stream<bool> get onInternetStatusChange => _internetChecker.onStatusChange
      .map((status) => status == InternetConnectionStatus.connected)
      .distinct();
}

// Note: For iOS, ensure Info.plist contains appropriate permissions for network access.
