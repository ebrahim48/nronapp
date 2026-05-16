import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../constants/api_constants.dart';

class SocketService extends GetxService {
  static SocketService get instance => Get.find<SocketService>();

  io.Socket? _socket;
  final hasUnread = false.obs;
  final isConnected = false.obs;

  Future<void> connect(String token) async {
    if (token.isEmpty) {
      debugPrint('[Socket] No token — skipping connect');
      return;
    }

    _socket?.dispose();
    _socket = null;

    debugPrint('[Socket] Connecting to ${ApiConstants.socketUrl}');

    _socket = io.io(
      ApiConstants.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': 'Bearer $token'})
          .disableAutoConnect()
          .enableReconnection()
          .build(),
    );

    _socket!.onConnect((_) {
      isConnected.value = true;
      debugPrint('[Socket] ✅ Connected — id: ${_socket?.id}');
    });

    _socket!.onDisconnect((_) {
      isConnected.value = false;
      debugPrint('[Socket] ❌ Disconnected');
    });

    _socket!.onConnectError((data) {
      debugPrint('[Socket] ⚠️ Connect error: $data');
    });

    _socket!.onError((data) {
      debugPrint('[Socket] ⚠️ Error: $data');
    });

    _socket!.on('notification:new', (data) {
      debugPrint('[Socket] 🔔 notification:new — $data');
      hasUnread.value = true;
    });

    _socket!.connect();
  }

  void clearBadge() => hasUnread.value = false;

  void disconnect() {
    _socket?.dispose();
    _socket = null;
    isConnected.value = false;
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
