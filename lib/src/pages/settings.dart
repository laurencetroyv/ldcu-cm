import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
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
