import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uchet/resources/app_colors.dart';
import 'package:uchet/services/liver_api.dart';
import 'package:uchet/widgets/tabview.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uchet/models/LiverOffline.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDirectory.path);
  await Firebase.initializeApp();
  Hive.registerAdapter(PersonAdapter());
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SDU',
      theme: ThemeData(
        primaryColor: Color(0xff43537d),
        appBarTheme: AppBarTheme(color: AppColors.white, elevation: 0),
        scaffoldBackgroundColor: AppColors.white,
      ),
      home: TabView(),
    );
  }
}

Future updateData() async {
  final firebase = FirebaseFirestore.instance;
  firebase.collection('livers').get().then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) async {
      var box = await Hive.openBox(doc['id']);
      var allLiver = await Hive.openBox<LiverId>('allLiver');
      // var test = await Hive.openBox('allLivers');
      // test.add(doc['id']);
      var goTo = {
        "counter": box.get('counter'),
        "fullName": box.get('fullName'),
        "id": box.get('id'),
        "uchetId": box.get('uchetId'),
        "pokazanie": box.get('pokazanie'),
      };
    });
  });
}
