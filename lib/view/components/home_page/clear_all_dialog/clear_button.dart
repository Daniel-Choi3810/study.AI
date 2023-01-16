import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/providers/providers.dart';

class ClearButton extends ConsumerWidget {
  const ClearButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: const Text("Clear All"),
      onPressed: () {
        ref.read(dbProvider.notifier).clearList();
        Navigator.pop(context);
      },
    );
  }
}
