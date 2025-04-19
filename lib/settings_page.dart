import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('深色模式'),
              value: settings.darkMode,
              onChanged: (val) => settings.setDarkMode(val),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: '服务器地址',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: settings.serverAddress),
              onChanged: (val) => settings.setServerAddress(val),
            ),
          ],
        ),
      ),
    );
  }
}
