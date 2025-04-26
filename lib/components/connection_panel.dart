import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_libserialport/flutter_libserialport.dart';

class ConnectionPanel extends StatelessWidget {
  final String protocol;
  final ValueChanged<String> onProtocolChanged;
  final TextEditingController ipController; // 对于UART，该字段存放串口名称
  final TextEditingController portController; // 用于 TCP 的端口或 UART 的波特率
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
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: Colors.grey.shade400,
        width: 0.8,
      ),
    );

    String firstFieldLabel() {
      switch (protocol) {
        case 'ws':
          return '完整链接（ws://...）';
        case 'tcp':
          return 'IP 地址';
        case 'uart':
          return '串口设备'; // 改为简洁提示
        default:
          return '';
      }
    }

    String secondFieldLabel() {
      switch (protocol) {
        case 'tcp':
          return '端口';
        case 'uart':
          return '波特率';
        default:
          return '';
      }
    }

    // 根据协议，返回第一个输入区域组件
    Widget firstFieldWidget() {
      if (protocol == 'uart') {
        // 获取系统中的可用串口列表
        final ports = SerialPort.availablePorts;
        // 如果 ipController 为空且有可用串口，预设第一个串口
        if (ports.isNotEmpty && ipController.text.isEmpty) {
          ipController.text = ports[0];
        }
        return DropdownButtonFormField<String>(
          value: ipController.text.isNotEmpty ? ipController.text : (ports.isNotEmpty ? ports[0] : null),
          decoration: InputDecoration(
            labelText: firstFieldLabel(),
            border: border,
          ),
          items: ports
              .map((port) => DropdownMenuItem(
                    value: port,
                    child: Text(port),
                  ))
              .toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              ipController.text = newValue;
            }
          },
        );
      } else {
        return TextField(
          controller: ipController,
          decoration: InputDecoration(
            labelText: firstFieldLabel(),
            border: border,
          ),
        );
      }
    }

    return Row(
      children: [
        // 选择连接协议的下拉框
        SizedBox(
          width: 150,
          child: DropdownButtonFormField<String>(
            value: protocol,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: border,
            ),
            items: [
              DropdownMenuItem(
                value: 'ws',
                child: const Text('WebSocket'),
              ),
              DropdownMenuItem(
                value: 'tcp',
                enabled: !isWeb,
                child: Text(
                  'TCP',
                  style: TextStyle(
                    color: isWeb ? Theme.of(context).disabledColor : null,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'uart',
                enabled: !isWeb,
                child: Text(
                  'UART',
                  style: TextStyle(
                    color: isWeb ? Theme.of(context).disabledColor : null,
                  ),
                ),
              ),
            ],
            onChanged: (String? newValue) {
              if (newValue != null && !(isWeb && newValue != 'ws')) {
                onProtocolChanged(newValue);
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        // 根据协议显示第一个输入区域（地址或串口下拉列表）
        Expanded(
          flex: 2,
          child: firstFieldWidget(),
        ),
        const SizedBox(width: 16),
        // 仅在 TCP 或 UART 时显示第二输入框（端口或波特率）
        if (protocol == 'tcp' || protocol == 'uart') ...[
          Expanded(
            child: TextField(
              controller: portController,
              decoration: InputDecoration(
                labelText: secondFieldLabel(),
                border: border,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 16),
        ],
        ElevatedButton(
          onPressed: onConnect,
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 16),
          ),
          child: Text(isConnected ? '断开' : '连接'),
        ),
      ],
    );
  }
}