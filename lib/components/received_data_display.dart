import 'package:flutter/material.dart';

class ReceivedDataDisplay extends StatelessWidget {
  final List<String> receivedData;
  const ReceivedDataDisplay({
    super.key,
    required this.receivedData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListView.builder(
        itemCount: receivedData.length,
        itemBuilder: (context, index) {
          return Text(receivedData[index]);
        },
      ),
    );
  }
}