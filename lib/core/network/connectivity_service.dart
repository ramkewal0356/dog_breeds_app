import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'connectivity_repository.dart';

class ConnectivityService implements ConnectivityRepository {
  final Connectivity _connectivity;

  final ValueNotifier<bool> isConnectedNotifier = ValueNotifier(true);

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen((_) async {
      final connected = await _hasInternetConnection();
      isConnectedNotifier.value = connected;
    });

    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final connected = await _hasInternetConnection();
    isConnectedNotifier.value = connected;
  }

  @override
  Stream<bool> get connectivityStream async* {
    await for (final _ in _connectivity.onConnectivityChanged) {
      yield await _hasInternetConnection();
    }
  }

  @override
  Future<bool> get isConnected async {
    final connected = await _hasInternetConnection();
    isConnectedNotifier.value = connected;
    return connected;
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));

      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    _subscription?.cancel();
    isConnectedNotifier.dispose();
  }
}
