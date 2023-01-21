import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/providers/providers.dart';
import 'package:intellistudy/view/pages/flash_card_create_page.dart';
import 'sign_up_page.dart';

class AuthCheckerPage extends ConsumerStatefulWidget {
  const AuthCheckerPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthCheckerPageState();
}

class _AuthCheckerPageState extends ConsumerState<AuthCheckerPage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (data) {
        if (data != null) {
          return const FlashCardCreatePage();
        }
        return const LoginPage();
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stackTrace) => Center(
        child: Text(
          e.toString(),
        ),
      ),
    );
  }
}
