// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:newnote/database/db.dart';
import 'package:newnote/model/model.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:newnote/ui/constants.dart';

class Read extends StatefulWidget {
  const Read({Key? key}) : super(key: key);

  @override
  State<Read> createState() => _ReadState();
}

class _ReadState extends State<Read> {
  late bool isEdit;
  late bool isCreate;
  var data = 0;
  TextEditingController controller = TextEditingController();
  ScrollController scroller = ScrollController();
  String category = '';
  String content = '';
  Color colorA = Colors.black;
  createData() async {
    if (controller.text.isNotEmpty && category.isNotEmpty) {
      final note = Note(
        content: controller.text,
        category: category,
        date: DateTime.now(),
        del: 0,
      );
      await Db.db.createData(note);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var received = ModalRoute.of(context)!.settings.arguments as Map;
    isEdit = received['isEdit'];
    isCreate = received['isCreate'];
    if (isCreate == false) {
      controller.text = received['data']['content'];
      category= received['data']['category'];
      isEdit = true;
      data = received['data']['id'];
    }
    updateData() async {
      if (controller.text.isNotEmpty && category.isNotEmpty) {
        final note = Note(
          content: controller.text,
          category: category,
          date: DateTime.now(),
          del: 0,
        );
        await Db.db.updateData(note, data);
        // print(note.id);
        // print(note);
      }
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        actions: [
          IconButton(
              onPressed: () {
                isEdit ? updateData() : createData() ;
              },
              icon: const Icon(Icons.save_alt_rounded))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: TextField(
            controller: controller,
            maxLines: null,
            minLines: null,
            expands: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            // enabled: isEdit,
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: tabIcons
                    .map((e) => IconButton(
                        tooltip: e.text,
                        onPressed: () {
                          showToast(e.text,
                              context: context,
                              position: StyledToastPosition.center,
                              backgroundColor: e.color);

                          category = e.text;
                        },
                        icon: Icon(e.icon),
                        color: e.color))
                    .toList()),
          )
        ],
      ),
      // floatingActionButton: isCreate
      //     ? const SizedBox.shrink()
      //     : FloatingActionButton(
      //         onPressed: () {
      //           setState(() {
      //             isCreate = true;
      //           });
      //         },
      //         child: const Icon(Icons.edit_outlined)),
    );
  }
}
