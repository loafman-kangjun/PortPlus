import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MyApp());
}

// 应用程序的根Widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebSocket调试器',  // 更改标题以反映实际功能
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TcpDebuggerPage(),
    );
  }
}

// WebSocket调试器的主页面
class TcpDebuggerPage extends StatefulWidget {
  const TcpDebuggerPage({super.key});

  @override
  State<TcpDebuggerPage> createState() => _TcpDebuggerPageState();
}

class _TcpDebuggerPageState extends State<TcpDebuggerPage> {
  // 用于控制输入框的控制器
  final TextEditingController _ipController = TextEditingController(text: '127.0.0.1');
  final TextEditingController _portController = TextEditingController(text: '8080');
  final TextEditingController _sendController = TextEditingController();
  
  // 存储接收到的数据
  final List<String> _receivedData = [];
  
  // WebSocket连接通道
  IOWebSocketChannel? _channel;
  
  // 连接状态标志
  bool _isConnected = false;
  
  // 添加协议类型选择
  String _protocol = 'ws';  // 默认为WebSocket

  // 修改连接方法
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
      // 根据协议类型构建不同的连接URL
      final url = _protocol == 'ws' 
          ? 'ws://${_ipController.text}'
          : 'ws://${_ipController.text}:${_portController.text}';
      
      final channel = IOWebSocketChannel.connect(url);
      
      setState(() {
        _channel = channel;
        _isConnected = true;
      });

      // 监听WebSocket数据流
      _channel?.stream.listen(
        // 数据接收处理
        (data) {
          setState(() {
            _receivedData.add('收到: $data');
          });
        },
        // 错误处理
        onError: (error) {
          setState(() {
            _isConnected = false;
            _channel = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('连接错误: $error')),
          );
        },
        // 连接关闭处理
        onDone: () {
          setState(() {
            _isConnected = false;
            _channel = null;
          });
        },
      );
    } catch (e) {
      // 连接异常处理
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('连接失败: $e')),
      );
    }
  }

  // 发送数据
  void _sendData() {
    if (!_isConnected || _sendController.text.isEmpty) return;
    
    try {
      // 通过WebSocket发送数据
      _channel?.sink.add(_sendController.text);
      setState(() {
        _receivedData.add('发送: ${_sendController.text}');
        _sendController.clear();  // 清空输入框
      });
    } catch (e) {
      // 发送异常处理
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发送失败: $e')),
      );
    }
  }

  // 资源释放
  @override
  void dispose() {
    _channel?.sink.close();  // 关闭WebSocket连接
    _ipController.dispose();  // 释放控制器资源
    _portController.dispose();
    _sendController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('WebSocket调试器'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 连接设置区域
            Row(
              children: [
                // 协议选择下拉菜单
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
                // IP地址/链接输入框
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _ipController,
                    decoration: InputDecoration(
                      labelText: _protocol == 'ws' ? '链接' : 'IP地址',  // 根据协议类型动态改变标签
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 端口输入框 - 仅在TCP模式下显示
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
                // 连接/断开按钮
                ElevatedButton(
                  onPressed: _connect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isConnected ? Colors.red : Colors.green,
                  ),
                  child: Text(_isConnected ? '断开' : '连接'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 数据显示区域
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
            // 数据发送区域
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
