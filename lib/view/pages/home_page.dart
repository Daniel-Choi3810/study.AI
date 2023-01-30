import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/utils/utils.dart';
import 'package:intellistudy/view/pages/flashcard_create_page.dart';
import 'package:intellistudy/view/pages/search_page.dart';

import '../../providers/providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    sideMenu.addListener((p0) {
      page.jumpToPage(p0);
    });
    super.initState();
    super.initState();
  }

  final PageController page = PageController();
  final SideMenuController sideMenu = SideMenuController();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider); // Watch for changes in authProvider

    return Scaffold(
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SideMenu(
              style: SideMenuStyle(
                  // showTooltip: false,
                  displayMode: SideMenuDisplayMode.auto,
                  hoverColor: Colors.deepPurple,
                  selectedColor: AppColors.purple,
                  selectedTitleTextStyle: const TextStyle(color: Colors.white),
                  selectedIconColor: Colors.white,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  backgroundColor: Colors.blueGrey),
              // Page controller to manage a PageView
              controller: sideMenu,
              // Will shows on top of all items, it can be a logo or a Title text
              title: Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      'Cram.AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.white,
                      indent: 8.0,
                      endIndent: 8.0,
                    ),
                  ),
                ],
              ),
              // Will show on bottom of SideMenu when displayMode was SideMenuDisplayMode.open
              footer: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    auth.auth.currentUser?.email ?? "Guest Profile",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Divider(
                    color: Colors.white,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Sabres Media LLC © 2023'),
                  ),
                ],
              ),
              // Notify when display mode changed
              onDisplayModeChanged: (mode) {
                print(mode);
              },
              // List of SideMenuItem to show them on SideMenu
              items: [
                SideMenuItem(
                  priority: 0,
                  title: 'Search Page',
                  onTap: (page, _) {
                    sideMenu.changePage(page);
                  },
                  icon: const Icon(Icons.search),
                  tooltipContent: "This is a tooltip for Dashboard item",
                ),
                SideMenuItem(
                  priority: 1,
                  title: 'Create Flashcards',
                  onTap: (page, _) {
                    sideMenu.changePage(page);
                  },
                  icon: const Icon(Icons.card_giftcard_outlined),
                ),
                SideMenuItem(
                  priority: 2,
                  title: 'Settings',
                  onTap: (page, _) {
                    sideMenu.changePage(page);
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: const [SearchPage(), FlashCardCreatePage()],
            ),
          ),
        ],
      ),
    );
  }
}
