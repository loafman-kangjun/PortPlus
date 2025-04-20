import 'package:web_socket_channel/io.dart';

class SocketManager {
  IOWebSocketChannel? _channel;

  bool get isConnected => _channel != null;

  /// 建立连接，url 传入完整地址，如 "ws://xxx" 或 "ws://xxx:port"
  Future<IOWebSocketChannel> connect(String url) async {
    _channel = IOWebSocketChannel.connect(url);
    return _channel!;
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void send(String message) {
    _channel?.sink.add(message);
  }

  Stream get stream {
    return _channel!.stream;
  }
}