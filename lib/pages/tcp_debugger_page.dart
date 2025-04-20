import 'package:flutter/material.dart';
import 'package:port_plus/services/socket_manager.dart';
import 'package:port_plus/components/connection_panel.dart';
import 'package:port_plus/components/received_data_display.dart';
import 'package:port_plus/components/send_data_panel.dart';

class TcpDebuggerPage extends StatefulWidget {
  const TcpDebuggerPage({super.key});

  @override
  State<TcpDebuggerPage> createState() => _TcpDebuggerPageState();
}

class _TcpDebuggerPageState extends State<TcpDebuggerPage> {
  final TextEditingController _ipController =
      TextEditingController(text: '127.0.0.1');
  final TextEditingController _portController =
      TextEditingController(text: '8080');
  final TextEditingController _sendController = TextEditingController();

  final List<String> _receivedData = [];
  SocketManager? _socketManager;
  bool _isConnected = false;
  String _protocol = 'ws';

  void _connect() async {
    if (_isConnected) {
      _socketManager?.disconnect();
      setState(() {
        _isConnected = false;
        _socketManager = null;
      });
      return;
    }

    try {
      final url = _protocol == 'ws'
          ? _ipController.text
          : 'ws://${_ipController.text}:${_portController.text}';

      _socketManager = SocketManager();
      await _socketManager!.connect(url);
      setState(() {
        _isConnected = true;
      });

      _socketManager!.stream.listen(
        (data) {
          setState(() {
            _receivedData.add('收到: $data');
          });
        },
        onError: (error) {
          setState(() {
            _isConnected = false;
            _socketManager = null;
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('连接错误: $error')),
            );
          }
        },
        onDone: () {
          setState(() {
            _isConnected = false;
            _socketManager = null;
          });
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('连接失败: $e')),
        );
      }
    }
  }

  void _sendData() {
    if (!_isConnected || _sendController.text.isEmpty) return;

    try {
      _socketManager?.send(_sendController.text);
      setState(() {
        _receivedData.add('发送: ${_sendController.text}');
        _sendController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发送失败: $e')),
      );
    }
  }

  @override
  void dispose() {
    _socketManager?.disconnect();
    _ipController.dispose();
    _portController.dispose();
    _sendController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket 调试器'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ConnectionPanel(
              protocol: _protocol,
              ipController: _ipController,
              portController: _portController,
              isConnected: _isConnected,
              onProtocolChanged: (newProtocol) {
                setState(() {
                  _protocol = newProtocol;
                });
              },
              onConnect: _connect,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ReceivedDataDisplay(
                receivedData: _receivedData,
              ),
            ),
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