import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intellistudy/view/pages/flashcard_master_view_page.dart';

import '../../providers/providers.dart';
import 'login_page.dart';

class MySetsPage extends ConsumerStatefulWidget {
  const MySetsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MySetsPageState();
}

class _MySetsPageState extends ConsumerState<MySetsPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final firestore = ref.watch(fireStoreProvider);
    final auth = ref.watch(authProvider);
    final authState = ref.watch(authStateProvider);
    // Stream<List<Map<String, dynamic>>> myCardSetsStream = firestore
    //     .collection('flashcardSets')
    //     .doc(auth.auth.currentUser!.uid.toString())
    //     .collection('sets')
    //     .snapshots()
    //     .map((querySnap) => querySnap
    //         .docs // Mapping Stream of CollectionReference to List<QueryDocumentSnapshot>
    //         .map((doc) => {
    //               'id': doc.id,
    //               'data': doc.data()
    //             }) // Getting each document ID from the data property of QueryDocumentSnapshot
    //         .toList());
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Sets'),
      ),
      body: authState.when(
        data: (data) {
          print("data before conditional: $data");
          if (data != null) {
            Stream<List<Map<String, dynamic>>> myCardSetsStream = firestore
                .collection('flashcardSets')
                .doc(auth.auth.currentUser!.uid.toString())
                .collection('sets')
                .snapshots()
                .map((querySnap) => querySnap
                    .docs // Mapping Stream of CollectionReference to List<QueryDocumentSnapshot>
                    .map((doc) => {
                          'id': doc.id,
                          'data': doc.data()
                        }) // Getting each document ID from the data property of QueryDocumentSnapshot
                    .toList());
            print("data: $data");
            return SafeArea(
              child: Center(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: myCardSetsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      //print(flashcardStream);
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ListTile(
                                title: Text(
                                    snapshot.data![index]['data']['title']),
                                subtitle: Text(snapshot.data![index]['data']
                                    ['description']),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return FlashcardMasterViewPage(
                                        title: snapshot.data![index]['data']
                                            ['title']);
                                  }));
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            );
          }
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 2,
              sigmaY: 2,
            ),
            child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: Container(
                height: height * 0.75,
                width: width * 0.75,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: const LoginPage(),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stackTrace) => Center(
          child: Text(
            e.toString(),
          ),
        ),
      ),
      // body: Center(
      //   child: StreamBuilder<List<Map<String, dynamic>>>(
      //     stream: myCardSetsStream,
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         //print(flashcardStream);
      //         return ListView.builder(
      //           itemCount: snapshot.data!.length,
      //           itemBuilder: (context, index) {
      //             return Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: Card(
      //                 child: ListTile(
      //                   title: Text(snapshot.data![index]['data']['title']),
      //                   subtitle:
      //                       Text(snapshot.data![index]['data']['description']),
      //                   onTap: () {
      //                     Navigator.push(context,
      //                         MaterialPageRoute(builder: (context) {
      //                       return FlashcardMasterViewPage(
      //                           title: snapshot.data![index]['data']['title']);
      //                     }));
      //                   },
      //                 ),
      //               ),
      //             );
      //           },
      //         );
      //       }
      //       if (snapshot.hasError) {
      //         return const Text('Error');
      //       } else {
      //         return const Center(child: CircularProgressIndicator());
      //       }
      //     },
      //   ),
      // ),
    );
  }
}
