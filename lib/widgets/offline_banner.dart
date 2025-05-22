import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  final bool isOffline;

  const OfflineBanner({super.key, required this.isOffline});

  @override
  Widget build(BuildContext context) {
    return isOffline
        ? Container(
          color: Colors.orange,
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: Text(
            'Offline mode',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        )
        : SizedBox.shrink();
  }
}
