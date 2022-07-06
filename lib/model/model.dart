import 'dart:convert';

class Note {
  final String content;
  final String category;
  final DateTime date;
  final int del;
  final int? id;

  Note({
    required this.content,
    required this.category,
    required this.date,
    required this.del,
    this.id,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'content': content});
    result.addAll({'category': category});
    result.addAll({'date': date.millisecondsSinceEpoch});
    result.addAll({'del': del});
    if(id != null){
      result.addAll({'id': id});
    }
  
    return result;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      content: map['content'] ?? '',
      category: map['category'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      del: map['del'] ?? 0,
      id: map['id']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));
}
