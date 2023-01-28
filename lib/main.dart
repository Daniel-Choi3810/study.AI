import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:intellistudy/view/pages/flashcard_master_view_page.dart';
import 'firebase_options.dart';

void main() async {
  //Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox('flashcardDataBase');
  await Hive.openBox('responsesDataBase');
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
    // final initialize = ref.watch(firebaseinitializerProvider);
    // initialize.when(
    //     data: (data) => const AuthChecker(),
    //     loading: () => const Center(child: CircularProgressIndicator()),
    //     error: (e, stackTrace) => Center(
    //       child: Text(
    //         e.toString(),
    //       )
    //     ),
    //   );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StudyAI',
        theme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: GoogleFonts.poppins().fontFamily),
        home: const FlashcardMasterViewPage(
          title: 'stream test',
        ));
  }
}
