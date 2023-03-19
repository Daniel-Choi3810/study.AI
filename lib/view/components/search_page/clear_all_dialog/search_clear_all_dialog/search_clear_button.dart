import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/providers/providers.dart';

class SearchClearButton extends ConsumerWidget {
  const SearchClearButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton(
      child: const Text("Clear All"),
      onPressed: () {
        ref.read(localSearchDBProvider.notifier).clearList();
        Navigator.pop(context);
      },
    );
  }
}
