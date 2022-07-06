import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newnote/ui/read.dart';
import 'package:newnote/ui/ui.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  if (Platform.isAndroid ||
      Platform.isMacOS ||
      Platform.isWindows ||
      Platform.isIOS) {
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const UI(),
      routes: {
        '/': (context)=> const UI(),
        '/read': (context)=> const Read(),
      },
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}
