import 'package:connectivity_plus/connectivity_plus.dart';

import '../utils/base_eport.dart';
import 'connectivity_repository.dart';

class ConnectivityService implements ConnectivityRepository {
  final Connectivity _connectivity;

  final ValueNotifier<bool> isConnectedNotifier = ValueNotifier(true);

  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity() {
    _connectivity.onConnectivityChanged.listen((results) {
      isConnectedNotifier.value = _isConnectedFromResults(results);
    });
  }

  @override
  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.map(
      (results) => _isConnectedFromResults(results),
    );
  }

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();

    final connected = _isConnectedFromResults(results);
    isConnectedNotifier.value = connected;

    return connected;
  }

  bool _isConnectedFromResults(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;

    return results.any((result) => result != ConnectivityResult.none);
  }
}
