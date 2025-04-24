import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:tdesign_flutter/tdesign_flutter.dart';

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
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: Colors.grey.shade400,
        width: 0.8,
      ),
    );
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: border,
                enabledBorder: border,
                focusedBorder: border.copyWith(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.2,
                  ),
                ),
              ),
            ),
            child: DropdownButtonFormField<String>(
              value: protocol,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                filled: true,
                fillColor: Colors.grey.shade50,
                hoverColor: Colors.grey.shade100,
                suffixIcon: Icon(
                  Icons.expand_more_rounded,
                  color: Colors.grey.shade600,
                  size: 22,
                ),
              ),
              dropdownColor: Colors.white,
              elevation: 2,
              borderRadius: BorderRadius.circular(4),
              // icon设为空，使用自定义suffixIcon
              icon: const SizedBox.shrink(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w400,
              ),
              items: [
                DropdownMenuItem(
                  value: 'ws',
                  child: _DropdownItem(
                    icon: Icons.web,
                    text: 'WebSocket',
                  ),
                ),
                DropdownMenuItem<String>(
                  value: 'tcp',
                  enabled: !isWeb,
                  child: _DropdownItem(
                    icon: Icons.settings_ethernet,
                    text: 'TCP',
                    isDisabled: isWeb,
                  ),
                ),
              ],
              onChanged: (String? newValue) {
                if (newValue != null && !(isWeb && newValue == 'tcp')) {
                  onProtocolChanged(newValue);
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: TextField(
            controller: ipController,
            decoration: InputDecoration(
              labelText: protocol == 'ws' ? '完整链接（ws://...）' : 'IP 地址',
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
        TDButton(
          text: isConnected ? '断开' : '连接',
          size: TDButtonSize.large,
          type: TDButtonType.fill,
          shape: TDButtonShape.rectangle,
          theme: isConnected ? TDButtonTheme.danger : TDButtonTheme.primary,
          onTap: onConnect,
        ),
      ],
    );
  }
}

/// 下拉框项的自定义组件，用于统一样式
class _DropdownItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDisabled;

  const _DropdownItem({
    Key? key,
    required this.icon,
    required this.text,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = isDisabled
        ? Theme.of(context).disabledColor
        : Colors.grey.shade800;
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}