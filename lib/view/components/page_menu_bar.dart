import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../utils/utils.dart';

class PageMenuBar extends ConsumerStatefulWidget {
  const PageMenuBar({super.key, required this.title});

  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PageMenuBarState();
}

class _PageMenuBarState extends ConsumerState<PageMenuBar> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final auth = ref.watch(authProvider); // Watch for changes in authProvider

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 35.0,
        vertical: 10.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: height * 0.08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 4,
              child: AutoSizeText(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            MaterialButton(
              hoverElevation: 10,
              hoverColor: AppColors.complementaryDark,
              color: AppColors.complementary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              minWidth: width * 0.1,
              height: height * 0.065,
              onPressed: () {},
              child: const Text(
                'Subscription Plans',
                style: TextStyle(
                  fontSize: 16,
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            Flexible(
              child: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    profileState == 'Guest'
                        ? const Icon(Icons.person)
                        : CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text(profileState[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white)),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Text(profileState)),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            PopupMenuButton(
                offset: const Offset(50, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                splashRadius: 2,
                itemBuilder: (context) => [
                      const PopupMenuItem(child: Text('My Profile')),
                      PopupMenuItem(
                        enabled: profileState == 'Guest' ? false : true,
                        onTap: () async {
                          await auth.signOut();
                          ref
                              .read(profileNotifierProvider.notifier)
                              .changeProfileStatus();
                        },
                        child: const Text('Sign Out'),
                      ),
                    ]),
          ],
        ),
      ),
    );
  }
}
