import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkChecker {
  final Connectivity _connectivity = Connectivity();

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}