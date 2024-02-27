import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisualMap extends ConsumerWidget {
  const VisualMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Map'),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text("Coming soon"),
          ),
        ),
      ),
    );
  }
}
