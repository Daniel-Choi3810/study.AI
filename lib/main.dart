import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intellistudy/view/pages/flash_card_view_page.dart';
import 'package:intellistudy/view/pages/flashcard_create_page.dart';
import 'package:intellistudy/view/pages/my_sets_page.dart';
import 'package:intellistudy/view/pages/search_page.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'view/pages/home_page.dart';

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
      theme: ThemeData(
          // scaffoldBackgroundColor: Colors.black,
          fontFamily: GoogleFonts.poppins().fontFamily),
      // home: const FlashCardViewPage(title: 'test 1'),
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/flashcard': (context) => const FlashCardViewPage(
              title: '',
            ),
        '/flashcardCreate': (context) => const FlashCardCreatePage(),
        '/search': (context) => const SearchPage(),
        '/mySets': (context) => const MySetsPage(),
      },
    );
  }
}
