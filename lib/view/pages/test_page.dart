import 'package:flutter/material.dart';
import 'package:intellistudy/view/components/flash_card/flash_card.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool isStarred = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return const SafeArea(
      child: Scaffold(
        body: Center(
            child: FlashCard(term: "Who is a poop?", definition: "Megan Doan")),
      ),
    );
  }
}

/// UI flash card, commonly found in language teaching to children
