import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intellistudy/view/pages/home_page.dart';

//Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  //Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await Hive.openBox('responsesDataBase');
  await dotenv.load(fileName: ".env");
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );

  //Demo Firebase Anonymous Auth Demo
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    print("Signed in with temporary account.");
    print(FirebaseAuth.instance.currentUser!.uid.toString());
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        print("Anonymous auth hasn't been enabled for this project.");
        break;
      default:
        print("Unknown error.");
    }
  }

  //Firebase Firestore Demo
  FirebaseFirestore db = FirebaseFirestore.instance;
  final user = <String, dynamic>{
    "first": "Ada",
    "last": "Lovelace",
    "born": 1815
  };

// Add a new document with a generated ID
  db
      .collection(FirebaseAuth.instance.currentUser!.uid.toString())
      .add(user)
      .then((DocumentReference doc) =>
          print('DocumentSnapshot added with ID: ${doc.id}'));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StudyAI',
      theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: GoogleFonts.poppins().fontFamily),
      home: const HomePage(),
    );
  }
}
