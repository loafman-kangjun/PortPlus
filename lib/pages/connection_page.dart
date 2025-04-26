import 'package:flutter/material.dart';
import 'package:port_plus/services/socket_manager.dart';
import 'package:port_plus/services/uart_manager.dart';
import 'package:port_plus/components/connection_panel.dart';
import 'package:port_plus/components/received_data_display.dart';
import 'package:port_plus/components/send_data_panel.dart';

/// 用于展示并管理 WebSocket/TCP/UART 调试的页面，包括连接、断开、发送和接收数据
class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage>
    with AutomaticKeepAliveClientMixin<ConnectionPage> {
  @override
  bool get wantKeepAlive => true;

  // 控制器：用于存放设备地址、端口/波特率和发送数据的文本输入值
  final TextEditingController _ipController = TextEditingController(
    text: 'COM3',
  ); // 对于 UART，此处填写串口名称，例如 COM3
  final TextEditingController _portController = TextEditingController(
    text: '9600',
  ); // 对于 UART，此处填写波特率
  final TextEditingController _sendController = TextEditingController();

  // 接收到的数据列表
  final List<String> _receivedData = [];

  // 用于管理 WebSocket/TCP 连接
  SocketManager? _socketManager;
  // 用于管理 UART 连接
  UartManager? _uartManager;

  // 当前连接状态
  bool _isConnected = false;
  // 当前连接协议（ws、tcp、uart等）
  String _connectionProtocol = 'ws';

  /// 连接或断开服务，根据协议选择不同的连接方式
  void _connect() async {
    // 已连接状态下直接断开
    if (_isConnected) {
      if (_connectionProtocol == 'uart') {
        _uartManager?.disconnect();
        _uartManager = null;
      } else {
        _socketManager?.disconnect();
        _socketManager = null;
      }
      setState(() {
        _isConnected = false;
      });
      return;
    }

    try {
      if (_connectionProtocol == 'ws' || _connectionProtocol == 'tcp') {
        // 对于 ws/tcp，构造连接 URL
        final url =
            _connectionProtocol == 'ws'
                ? _ipController.text
                : 'ws://${_ipController.text}:${_portController.text}';
        _socketManager = SocketManager();
        await _socketManager!.connect(url);
        setState(() {
          _isConnected = true;
        });
        _socketManager!.stream.listen(
          (data) {
            if (mounted) {
              setState(() {
                _receivedData.add('收到: $data');
              });
            }
          },
          onError: (error) {
            if (mounted) {
              setState(() {
                _isConnected = false;
                _socketManager = null;
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('连接错误: $error')));
            }
          },
          onDone: () {
            if (mounted) {
              setState(() {
                _isConnected = false;
                _socketManager = null;
              });
            }
          },
        );
      } else if (_connectionProtocol == 'uart') {
        // 对于 UART，使用串口名称和波特率建立连接
        final portName = _ipController.text;
        final baudRate = int.tryParse(_portController.text) ?? 9600;
        _uartManager = UartManager();
        await _uartManager!.connect(portName, baudRate);
        setState(() {
          _isConnected = true;
        });
        _uartManager!.stream.listen(
          (dataBytes) {
            if (mounted) {
              final data = String.fromCharCodes(dataBytes);
              setState(() {
                _receivedData.add('收到: $data');
              });
            }
          },
          onError: (error) {
            if (mounted) {
              setState(() {
                _isConnected = false;
                _uartManager = null;
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('UART 连接错误: $error')));
            }
          },
          onDone: () {
            if (mounted) {
              setState(() {
                _isConnected = false;
                _uartManager = null;
              });
            }
          },
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('不支持的连接协议')));
        return;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('连接失败: $e')));
      }
    }
  }

  /// 根据不同协议发送数据
  void _sendData() {
    if (!_isConnected || _sendController.text.isEmpty) return;

    try {
      if (_connectionProtocol == 'uart') {
        _uartManager?.send(_sendController.text);
      } else {
        _socketManager?.send(_sendController.text);
      }
      setState(() {
        _receivedData.add('发送: ${_sendController.text}');
        _sendController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('发送失败: $e')));
    }
  }

  @override
  void dispose() {
    _socketManager?.disconnect();
    _uartManager?.disconnect();
    _ipController.dispose();
    _portController.dispose();
    _sendController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket / UART 调试器'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ConnectionPanel(
              protocol: _connectionProtocol,
              ipController: _ipController,
              portController: _portController,
              isConnected: _isConnected,
              onProtocolChanged: (newProtocol) {
                setState(() {
                  _connectionProtocol = newProtocol;
                });
              },
              onConnect: _connect,
            ),
            const SizedBox(height: 16),
            Expanded(child: ReceivedDataDisplay(receivedData: _receivedData)),
            const SizedBox(height: 16),
            SendDataPanel(
              sendController: _sendController,
              isConnected: _isConnected,
              onSend: _sendData,
            ),
          ],
        ),
      ),
    );
  }
}
