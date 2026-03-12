// lib/core/network/connectivity/connectivity_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum NetworkStatus { online, offline }

class ConnectivityService {
  ConnectivityService._internal() {
    _init();
  }

  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;

  final Connectivity _connectivity = Connectivity();
  final _controller = StreamController<NetworkStatus>.broadcast();

  NetworkStatus _lastStatus = NetworkStatus.online;
  NetworkStatus get currentStatus => _lastStatus;
  bool get isOnline => _lastStatus == NetworkStatus.online;

  Stream<NetworkStatus> get statusStream => _controller.stream;

  // Callbacks للاستماع لتغييرات الحالة
  final List<VoidCallback> _onOnlineCallbacks = [];
  final List<VoidCallback> _onOfflineCallbacks = [];

  void _init() {
    _connectivity.onConnectivityChanged.listen(_updateStatus);
    checkConnection();
  }

  Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return _updateStatus(result);
  }

  bool _updateStatus(List<ConnectivityResult> results) {
    final hasConnection = results.any((r) =>
    r != ConnectivityResult.none
    );

    final newStatus = hasConnection ? NetworkStatus.online : NetworkStatus.offline;
    final wasOffline = _lastStatus == NetworkStatus.offline;

    if (newStatus != _lastStatus) {
      _lastStatus = newStatus;
      _controller.add(newStatus);

      debugPrint('🌐 Network Status: $newStatus');


      if (wasOffline && newStatus == NetworkStatus.online) {
        _notifyOnlineCallbacks();
      } else if (newStatus == NetworkStatus.offline) {
        _notifyOfflineCallbacks();
      }
    }

    return hasConnection;
  }

  void addOnOnlineCallback(VoidCallback callback) {
    _onOnlineCallbacks.add(callback);
  }

  void removeOnOnlineCallback(VoidCallback callback) {
    _onOnlineCallbacks.remove(callback);
  }

  void addOnOfflineCallback(VoidCallback callback) {
    _onOfflineCallbacks.add(callback);
  }

  void removeOnOfflineCallback(VoidCallback callback) {
    _onOfflineCallbacks.remove(callback);
  }

  void _notifyOnlineCallbacks() {
    for (final callback in _onOnlineCallbacks) {
      callback();
    }
  }

  void _notifyOfflineCallbacks() {
    for (final callback in _onOfflineCallbacks) {
      callback();
    }
  }

  void dispose() {
    _controller.close();
    _onOnlineCallbacks.clear();
    _onOfflineCallbacks.clear();
  }
}