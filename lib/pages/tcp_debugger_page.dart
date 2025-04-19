import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

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
  IOWebSocketChannel? _channel;
  bool _isConnected = false;
  String _protocol = 'ws';

  void _connect() async {
    if (_isConnected) {
      _channel?.sink.close();
      setState(() {
        _isConnected = false;
        _channel = null;
      });
      return;
    }

    try {
      final url = _protocol == 'ws'
          ? _ipController.text
          : 'ws://${_ipController.text}:${_portController.text}';

      final channel = IOWebSocketChannel.connect(url);
      setState(() {
        _channel = channel;
        _isConnected = true;
      });

      _channel?.stream.listen(
        (data) {
          setState(() {
            _receivedData.add('收到: $data');
          });
        },
        onError: (error) {
          setState(() {
            _isConnected = false;
            _channel = null;
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
            _channel = null;
          });
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('连接失败: $e')),
      );
    }
  }

  void _sendData() {
    if (!_isConnected || _sendController.text.isEmpty) return;

    try {
      _channel?.sink.add(_sendController.text);
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
    _channel?.sink.close();
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
            Row(
              children: [
                DropdownButton<String>(
                  value: _protocol,
                  items: const [
                    DropdownMenuItem(value: 'ws', child: Text('WebSocket')),
                    DropdownMenuItem(value: 'tcp', child: Text('TCP')),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _protocol = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _ipController,
                    decoration: InputDecoration(
                      labelText: _protocol == 'ws'
                          ? '完整链接（ws://...）'
                          : 'IP 地址',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                if (_protocol == 'tcp') ...[
                  Expanded(
                    child: TextField(
                      controller: _portController,
                      decoration: const InputDecoration(
                        labelText: '端口',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                ElevatedButton(
                  onPressed: _connect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isConnected ? Colors.red : Colors.green,
                  ),
                  child: Text(_isConnected ? '断开' : '连接'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ListView.builder(
                  itemCount: _receivedData.length,
                  itemBuilder: (context, index) {
                    return Text(_receivedData[index]);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _sendController,
                    decoration: const InputDecoration(
                      labelText: '发送数据',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isConnected ? _sendData : null,
                  child: const Text('发送'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}