import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intellistudy/view/pages/flashcard_master_view_page.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'view/pages/flash_card_view_page.dart';
import 'view/pages/flashcard_create_page.dart';
import 'view/pages/home_page.dart';
import 'view/pages/login_page.dart';
import 'view/pages/my_sets_page.dart';
import 'view/pages/search_page.dart';

void main() async {
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
  //Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox('flashcardDataBase');
  await Hive.openBox('responsesDataBase');
  await Hive.openBox('masterViewDataBase');
  await Hive.openBox('currentIndexDataBase');
  await Hive.openBox('pageArgumentsDataBase');
  await Hive.openBox('flashcardIndexDataBase');
  await Hive.openBox('flashcardIsShuffledDataBase');
  // await Hive.openBox('isAuthenticated');
  await dotenv.load(fileName: ".env");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CramAI',
      theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
      home: const HomePage(),
      onGenerateRoute: (settings) {
        final myBox = Hive.box('pageArgumentsDataBase');
        if (settings.name == '/flashcardView') {
          // Use Hive to save and retrieve the argument, then pass it to the page.  If the argument is null, then retrieve the argument from Hive.  If argument is not null, update hive with the new argument.
          var args = settings.arguments;

          if (args != null) {
            myBox.put('flashcardViewArgs', args);
          } else {
            // on refresh, args is null, so retrieve the previous args from hive
            args = myBox.get('flashcardViewArgs');
          }
          print("args in flashcardView: $args");
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => FlashCardViewPage(
              title: args as String,
            ),
          );
        }
        if (settings.name == '/flashcardMasterView') {
          var args = settings.arguments;
          if (args != null) {
            myBox.put('flashcardMasterViewArgs', args);
          } else {
            args = myBox.get('flashcardMasterViewArgs');
          }
          print("args in flashcardMasterView: $args");
          return PageRouteBuilder(
            settings: settings,
            pageBuilder: (_, __, ___) => FlashcardMasterViewPage(
              title: args as String,
            ),
          );
        }
        return PageRouteBuilder(pageBuilder: (_, __, ___) => const HomePage());
      },
      routes: {
        '/home': (context) => const HomePage(),
        '/flashcardCreate': (context) => const FlashCardCreatePage(),
        '/search': (context) => const SearchPage(),
        '/mySets': (context) => const MySetsPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
