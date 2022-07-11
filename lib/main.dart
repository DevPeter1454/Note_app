import 'dart:io';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:newnote/ui/read.dart';
import 'package:newnote/ui/ui.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:flutter/foundation.dart' as foundation;
// import 'package:sq'

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (
      Platform.isMacOS ||
      Platform.isWindows ) {
    if (Platform.isWindows) {
    sqfliteFfiInit();

      String path = '';

      path = "sqlite3.dll";
      open.overrideFor(OperatingSystem.windows, () {
        // devPrint('loading $path');
        try {
          return DynamicLibrary.open(path);
        } catch (e) {
          stderr.writeln('Failed to load sqlite3.dll at $path');
          rethrow;
        }
      });
      final db = sqlite3.openInMemory();
      db.dispose();
          }

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
        '/': (context) => const UI(),
        '/read': (context) => const Read(),
      },
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}
