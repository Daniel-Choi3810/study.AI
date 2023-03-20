import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intellistudy/utils/utils.dart';
import 'package:intellistudy/view/pages/flashcard_create_page.dart';
import 'package:intellistudy/view/pages/search_page.dart';
import '../../providers/providers.dart';
import 'my_sets_page.dart';

final myBox = Hive.box('currentIndexDataBase');

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    sideMenu.addListener((p0) {
      page.jumpToPage(p0);
    });
    myBox.get('currentIndex') == 0 ? myBox.put('currentIndex', 0) : null;
    // print(myBox.get('currentIndex'));
  }

  final PageController page = PageController(
    initialPage: myBox.get('currentIndex') ?? 0,
  );
  final SideMenuController sideMenu = SideMenuController(
    initialPage: myBox.get('currentIndex') ?? 0,
  );
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final auth = ref.watch(authProvider); // Watch for changes in authProvider
    final profileState = ref.watch(profileNotifierProvider);
    return Scaffold(
      body: Row(
        children: [
          SideMenu(
            style: SideMenuStyle(
              openSideMenuWidth: 275,
              itemOuterPadding: const EdgeInsets.only(bottom: 2, right: 10),
              // showTooltip: false,
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: AppColors.complementaryLight,
              selectedColor: AppColors.complementary,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              decoration: const BoxDecoration(
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black12,
                //     blurRadius: 5,
                //     spreadRadius: 10,
                //   ),
                // ],
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              backgroundColor: Colors.white,
              itemBorderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              // itemInnerSpacing: 40,
            ),
            // Page controller to manage a PageView
            controller:
                sideMenu, // Will shows on top of all items, it can be a logo or a Title text
            title: Padding(
              padding: EdgeInsets.only(bottom: height * 0.125),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Icon(
                      Icons.book,
                      size: 40,
                    ),
                  ),
                  AutoSizeText(
                    MediaQuery.of(context).size.width > 600 ? 'Cram.AI' : '',
                    minFontSize: 10,
                    stepGranularity: 10,
                    maxLines: 1,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.0125,
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.all(2.0),
                  //   child: Divider(
                  //     color: Colors.black,
                  //     indent: 10.0,
                  //     endIndent: 10.0,
                  //   ),
                  // ),
                ],
              ),
            ),
            // Will show on bottom of SideMenu when displayMode was SideMenuDisplayMode.open
            footer: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: profileState == 'Guest'
                      ? const SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await auth.signOut();
                                ref
                                    .read(profileNotifierProvider.notifier)
                                    .changeProfileStatus();
                                myBox.put('currentIndex', 0);
                                sideMenu.changePage(0);
                              },
                              icon: const Icon(Icons.logout),
                            ),
                            const Text("Log Out")
                          ],
                        ),
                ),
                // ListTile(
                //   leading: profileState == 'Guest'
                //       ? const Icon(Icons.person)
                //       : CircleAvatar(
                //           backgroundColor: Colors.blue,
                //           child: Text(profileState[0].toUpperCase(),
                //               style: const TextStyle(color: Colors.white)),
                //         ),
                //   title: Text(profileState),
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0125,
                ),
                // const Divider(
                //   indent: 10.0,
                //   endIndent: 10.0,
                //   color: Colors.black,
                // ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Sabres Media LLC © 2023',
                    style: TextStyle(color: Colors.black54),
                  ),
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
                  myBox.put('currentIndex', page);
                },
                icon: const Icon(Icons.search),
                tooltipContent: "Search",
                trailing: Container(
                    decoration: const BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 3),
                      child: Text(
                        'New',
                        style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                      ),
                    )),
              ),
              SideMenuItem(
                priority: 1,
                title: 'Create Flashcards',
                onTap: (page, _) {
                  sideMenu.changePage(page);
                  myBox.put('currentIndex', page);
                },
                icon: const Icon(Icons.card_giftcard_outlined),
              ),
              SideMenuItem(
                priority: 2,
                title: 'My Sets',
                onTap: (page, _) {
                  sideMenu.changePage(page);
                  myBox.put('currentIndex', page);
                },
                icon: const Icon(Icons.home),
              ),
              // SideMenuItem(
              //   priority: 3,
              //   title: 'Settings',
              //   onTap: (page, _) {
              //     sideMenu.changePage(page);
              //     myBox.put('currentIndex', page);
              //   },
              //   icon: const Icon(Icons.settings),
              // ),
            ],
          ),
          Expanded(
            child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: page,
                children: const [
                  SearchPage(),
                  FlashCardCreatePage(),
                  MySetsPage(),
                ]),
          ),
        ],
      ),
    );
  }
}
