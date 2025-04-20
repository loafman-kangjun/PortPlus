import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ConnectionPanel extends StatelessWidget {
  final String protocol;
  final ValueChanged<String> onProtocolChanged;
  final TextEditingController ipController;
  final TextEditingController portController;
  final bool isConnected;
  final VoidCallback onConnect;

  const ConnectionPanel({
    super.key,
    required this.protocol,
    required this.onProtocolChanged,
    required this.ipController,
    required this.portController,
    required this.isConnected,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb;
    return Row(
      children: [
        DropdownButton<String>(
          value: protocol,
          items: [
            const DropdownMenuItem(value: 'ws', child: Text('WebSocket')),
            DropdownMenuItem<String>(
              value: 'tcp',
              enabled: !isWeb, // web 上置为不可用
              child: Text(
                'TCP',
                style: TextStyle(color: isWeb ? Colors.grey : null),
              ),
            ),
          ],
          onChanged: (String? newValue) {
            // 如果是 web，选 tcp 不响应
            if (newValue != null && !(isWeb && newValue == 'tcp')) {
              onProtocolChanged(newValue);
            }
          },
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: TextField(
            controller: ipController,
            decoration: InputDecoration(
              labelText: protocol == 'ws'
                  ? '完整链接（ws://...）'
                  : 'IP 地址',
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        if (protocol == 'tcp') ...[
          Expanded(
            child: TextField(
              controller: portController,
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
          onPressed: onConnect,
          style: ElevatedButton.styleFrom(
            backgroundColor: isConnected ? Colors.red : Colors.green,
          ),
          child: Text(isConnected ? '断开' : '连接'),
        ),
      ],
    );
  }
}