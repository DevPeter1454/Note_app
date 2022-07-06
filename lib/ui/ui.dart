import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newnote/database/db.dart';
import 'package:newnote/model/model.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class UI extends StatefulWidget {
  const UI({Key? key}) : super(key: key);

  @override
  State<UI> createState() => _UIState();
}

class _UIState extends State<UI> {
  List<Map<String, Object?>>? uiData;
  List<Note> reservedNotes = [];
  dynamic delItems = [];
  List<Map<String, Object?>>? theData = [];
  List<Map<String, Object?>>? timeData = [];
  // List<Map<String, Object?>>? theData = [];

  bool isEdit = false;
  bool toDel = false;
  bool isDel = false;
  bool delAll = false;
  bool selectAll = false;
  bool toSortA = false;
  bool toSortB = false;
  bool toSortc = false;
  String dropVal = '';
  // String appBar =;
  late bool delMe;
  getData() async {
    var retrievedData = await Db.db.retrieveData();
    return retrievedData;
  }

  initializeDel() {
    setState(() {
      toDel = true;
    });
  }

  deleteData(int id) async {
    await Db.db.deleteData(id);
    setState(() {});
  }

  toDefault() {
    setState(() {
      toDel = false;
    });
  }

  bulkDelete() {
    for (var item in delItems) {
      deleteData(item.id!);
    }
    toDefault();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber[700],
          title: toDel
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(onPressed: () {
                      setState(() {
                        toDel = false;
                      });
                    }),
                    Text('${delItems.length} / ${uiData!.length}'),
                    IconButton(
                      icon: delItems.length == uiData!.length
                          ? const Icon(Icons.check_circle)
                          : const Icon(Icons.circle_outlined),
                      onPressed: () {
                        setState(() {
                          selectAll = !selectAll;
                          if (selectAll  ) {
                            // delItems.clear();
                            delItems = [
                              ...reservedNotes.toSet().toList().map((e) => e)
                            ];
                          } else {
                            delItems.clear();
                          }
                        });
                      },
                    ),
                  ],
                )
              : const Text('Note App'),
          elevation: 0.0,
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: RefreshProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              // print(snapshot.data);
              //  theData!.isEmpty && th?uiData = snapshot.data : uiData = theData;
              uiData = snapshot.data;
              uiData == null ? theData = [] : theData = [...uiData!];
              uiData == null ? timeData = [] : timeData = [...uiData!];
              theData!.sort((a, b) => a['category']
                  .toString()
                  .length
                  .compareTo(b['category'].toString().length));

              // timeData = [...uiData!];
              timeData!.sort((a, b) => int.parse(a['date'].toString())
                  .compareTo(int.parse(b['date'].toString())));
              toSortA == true && toSortB == false
                  ? uiData = theData
                  : toSortA == false && toSortB == true
                      ? uiData = timeData
                      : toSortA == false && toSortB == false
                          ? uiData = snapshot.data
                          : uiData = snapshot.data;

              uiData == null
                  ? reservedNotes = []
                  : reservedNotes = [
                      ...uiData!.map((e) => Note.fromMap(e)).toSet().toList()
                    ];

              return snapshot.hasData
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: ListView.separated(
                          itemCount: uiData!.length,
                          separatorBuilder: (context, index) {
                            return const Divider(
                              // thickness: 0.6,
                              height: 0.9,
                            );
                          },
                          itemBuilder: (context, index) {
                            var theContent = Note.fromMap(uiData![index]);
                            // print(theContent);

                            delMe = delItems.contains(uiData![index]);
                            var newDate =
                                DateFormat.yMEd().format(theContent.date);
                            return GestureDetector(
                              onTap: () async {
                                var newD = await Navigator.pushNamed(
                                    context, '/read',
                                    arguments: {
                                      'isEdit': true,
                                      'data': uiData![index],
                                      'isCreate': false,
                                    });
                                if (newD == null) {
                                  setState(() {});
                                }
                              },
                              onLongPress: () {
                                initializeDel();

                                delItems.clear();
                                if (delItems.isEmpty) {
                                  delItems.add(theContent);
                                }
                                // delItems.clear();
                              },
                              onDoubleTap: () {
                                setState(() {
                                  toDel = false;
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              width: 3.0,
                                              color: uiData![index]
                                                          ['category'] ==
                                                      'Uncategorized'
                                                  ? const Color(0xFF4CAF50)
                                                  : uiData![index]
                                                              ['category'] ==
                                                          'Business'
                                                      ? const Color(0xFFF44336)
                                                      : uiData![index][
                                                                  'category'] ==
                                                              'Home Affair'
                                                          ? const Color(
                                                              0xFF9C27B0)
                                                          : uiData![index]
                                                                      [
                                                                      'category'] ==
                                                                  'Study'
                                                              ? const Color(
                                                                  0xFF2196F3)
                                                              : const Color(
                                                                  0xFFE91E63)))),
                                  child: ListTile(
                                    title: Text(
                                      uiData![index]['content'].toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            uiData![index]['category']
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: uiData![index]
                                                            ['category'] ==
                                                        'Uncategorized'
                                                    ? const Color(0xFF4CAF50)
                                                    : uiData![index]
                                                                ['category'] ==
                                                            'Business'
                                                        ? const Color(
                                                            0xFFF44336)
                                                        : uiData![index]
                                                                    [
                                                                    'category'] ==
                                                                'Home Affair'
                                                            ? const Color(
                                                                0xFF9C27B0)
                                                            : uiData![index][
                                                                        'category'] ==
                                                                    'Study'
                                                                ? const Color(
                                                                    0xFF2196F3)
                                                                : const Color(
                                                                    0xFFE91E63)),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(newDate),
                                        ]),
                                    trailing: toDel
                                        ? IconButton(
                                            onPressed: () {
                                              bool existed = delItems.any(
                                                  (element) =>
                                                      element.id ==
                                                      theContent.id);
                                              setState(() {
                                                if (existed) {
                                                  delItems.removeWhere(
                                                      (element) =>
                                                          element.id ==
                                                          theContent.id);
                                                } else {
                                                  delItems.add(theContent);
                                                }
                                              });
                                              // delItems.add(uiData!![index]);
                                              // deleteData(
                                              // snapshot.data[index]['id']);
                                            },
                                            icon: Icon(
                                                delItems.any((element) =>
                                                        element.id ==
                                                        theContent.id)
                                                    ? Icons.check_circle
                                                    : Icons.circle_outlined,
                                                color: delItems.any((element) =>
                                                        element.id ==
                                                        theContent.id)
                                                    ? Colors.amber[700]
                                                    : Colors.black))
                                        : const SizedBox.shrink(),
                                  )),
                            );
                          }),
                    )
                  : const Center(
                      child: Text('No notes added yet'),
                    );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        floatingActionButton: !toDel
            ? Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    // alignment: Alignment.center,
                    constraints: BoxConstraints.expand(
                        width: MediaQuery.of(context).size.width, height: 50),
                    // width: MediaQuery.of(context).size.width,
                    height: 70,
                    color: const Color.fromRGBO(255, 255, 255, 0.8),
                    child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                              child: PopupMenuButton(
                                position: PopupMenuPosition.under,
                                icon: const Icon(Icons.more_vert),
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      onTap: () {
                                        initializeDel();
                                        selectAll = true;
                                      },
                                      child: const Text('Delete all notes'),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        showToast('Sort by modified time',
                                            context: context);
                                        setState(() {
                                          toSortB = true;
                                        });
                                        toSortA = false;
                                      },
                                      child:
                                          const Text('Sort by modified time'),
                                    ),
                                    PopupMenuItem(
                                      onTap: () {
                                        showToast('Sort by tabs',
                                            context: context);

                                        setState(() {
                                          toSortA = true;
                                          // print(toSortA);
                                          // uiData = theData;
                                          // print(uiData);
                                          // print('sort');
                                        });
                                        toSortB = false;
                                      },
                                      // value: 'Sort by tabs',
                                      child: const Text('Sort by tabs'),
                                    ),
                                  ];
                                },

                                // child: Text(dropVal.toString()),
                              )),

                          // toDel ? ElevatedButton(onPressed: , child: child)

                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: FloatingActionButton(
                              backgroundColor: Colors.amber[700],
                              onPressed: () async {
                                var expectedData = await Navigator.pushNamed(
                                    context, '/read', arguments: {
                                  'isEdit': false,
                                  'isCreate': true
                                });
                                if (expectedData == null) {
                                  setState(() {});
                                }
                              },
                              tooltip: 'Add note',
                              child: const Icon(Icons.add),
                            ),
                          )
                        ]))
              ])
            : const SizedBox.shrink(),
        persistentFooterButtons: [
          toDel
              ? Center(
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          barrierColor: Color.fromRGBO(255, 193, 7, 0.3),
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: const Text(
                                      'Are you sure you want to delete all notes?'),
                                  actions: [
                                    OutlinedButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          toDel = false;
                                        });
                                      },
                                    ),
                                    OutlinedButton(
                                      child: const Text('Delete'),
                                      onPressed: () {
                                        bulkDelete();
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ));
                      },
                      icon: const Icon(Icons.delete)),
                )
              : const SizedBox.shrink(),
        ]);
  }
}
