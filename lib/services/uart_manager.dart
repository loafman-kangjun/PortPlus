import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';

/// UARTManager 使用 flutter_libserialport 实现串口通信
class UartManager {
  late SerialPort _port;
  late SerialPortReader _reader;
  bool isConnected = false;

  /// 建立 UART 连接
  ///
  /// [portName] 为串口名称（例如：COM3 或 /dev/ttyUSB0），[baudRate] 为波特率
  Future<void> connect(String portName, int baudRate) async {
    _port = SerialPort(portName);
    if (!_port.openReadWrite()) {
      throw Exception('无法打开端口: ${SerialPort.lastError}');
    }
    final config = SerialPortConfig();
    config.baudRate = baudRate;
    _port.config = config;
    isConnected = true;
    _reader = SerialPortReader(_port);
  }

  /// 断开 UART 连接
  void disconnect() {
    if (isConnected) {
      _reader.close();
      _port.close();
      isConnected = false;
    }
  }

  /// 发送消息到串口
  void send(String message) {
    if (isConnected) {
      final data = Uint8List.fromList(message.codeUnits);
      _port.write(data);
    }
  }

  /// UART 数据流，数据以 List<int> 形式输出
  Stream<List<int>> get stream => _reader.stream;
}