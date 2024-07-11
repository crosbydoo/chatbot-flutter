import 'dart:async';
import 'dart:developer';
import 'package:web_socket_channel/io.dart';

class WebSocketHelper {
  late IOWebSocketChannel _channel;
  bool _isConnected = false;

  Future<void> connect(String url, String token) async {
    try {
      _channel = IOWebSocketChannel.connect(
        Uri.parse(url),
        // headers: {'Authorization': 'Bearer $token'},
      );
      _isConnected = true;
      log('WebSocket connected successfully');
    } catch (e) {
      _isConnected = false;
      log('Failed to connect: $e');
      throw Exception('Failed to connect: $e');
    }
  }

  Stream get stream {
    return _channel.stream;
  }

  Future<void> send(String message) async {
    try {
      _channel.sink.add(message);
    } catch (e) {
      log('Failed to send message: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  void disconnect() {
    _channel.sink.close();
    _isConnected = false;
  }

  bool get isConnected => _isConnected;
}
