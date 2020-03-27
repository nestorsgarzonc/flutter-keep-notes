import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  String title;
  String content;
  Color color;
  NoteState state;
  final DateTime createdAt;
  DateTime modifiedAt;

  /// Instance a [Note]
  Note({
    this.id,
    this.title,
    this.content,
    this.color,
    this.state,
    DateTime createdAt,
    DateTime modifiedAt,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.modifiedAt = modifiedAt ?? DateTime.now();

  static List<Note> fromQuery(QuerySnapshot snapshot) =>
      snapshot != null ? toNotes(snapshot) : [];
}

enum NoteState {
  unspecified,
  pinned,
  archived,
  deleted,
}

List<Note> toNotes(QuerySnapshot query) =>
    query.documents.map((d) => toNote(d)).where((n) => n != null).toList();

Note toNote(DocumentSnapshot doc) => doc.exists
    ? Note(
        id: doc.documentID,
        title: doc.data['title'],
        content: doc.data['content'],
        state: NoteState.values[doc.data['state'] ?? 0],
        color: _parseColor(doc.data['color']),
        createdAt:
            DateTime.fromMicrosecondsSinceEpoch(doc.data['createdAt'] ?? 0),
        modifiedAt:
            DateTime.fromMicrosecondsSinceEpoch(doc.data['modifiedAt'] ?? 0),
      )
    : null;

Color _parseColor(num colorInt) => Color(colorInt ?? 0xFFFFFFFF);
