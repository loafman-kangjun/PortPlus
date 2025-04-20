import 'package:flutter/material.dart';

class SendDataPanel extends StatelessWidget {
  final TextEditingController sendController;
  final bool isConnected;
  final VoidCallback onSend;
  const SendDataPanel({
    super.key,
    required this.sendController,
    required this.isConnected,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: sendController,
            decoration: const InputDecoration(
              labelText: '发送数据',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: isConnected ? onSend : null,
          child: const Text('发送'),
        ),
      ],
    );
  }
}