import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/widgets.dart';

//Klasse CloudNote repräsentiert eine Notiz aus der Cloud (Firestore) mit 4 Eigenschaften
@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final List<NoteParagraph> content;
  final List<String> sharedWith; 

  const CloudNote({
    required this.documentId, 
    required this.ownerUserId, 
    required this.content,
    required this.sharedWith,
  });

  //Methode, erzeugt neue CloudNote-Instanz aus Firestore-Dokument
  factory CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    //hier wird Feld content aus der Map geholt (Liste der Absätze)
    final contentList = data[contentFieldName] as List<dynamic>? ?? [];
    //jedes Element der Liste contentlist wird in NoteParagraph-Objekt umgewandelt
    final parsedContent = contentList
        .map((e) => NoteParagraph.fromMap(e as Map<String, dynamic>))
        .toList();
    return CloudNote(
      documentId: snapshot.id,
      ownerUserId: data[ownerUserIdFieldName] as String,
      sharedWith: List<String>.from(data[sharedWithFieldName] ?? []),
      content: parsedContent,
    );
  }
  
  //Funktion wird verwendet, wenn man ein einzelnes Dokument direkt lädt
  factory CloudNote.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    //holt Daten des Dokuments
    final data = snapshot.data()!;
    final contentList = data[contentFieldName] as List<dynamic>? ?? [];
    final parsedContent = contentList
        .map((e) => NoteParagraph.fromMap(e as Map<String, dynamic>))
        .toList();

    return CloudNote(
      documentId: snapshot.id,
      ownerUserId: data[ownerUserIdFieldName] as String,
      sharedWith: List<String>.from(data[sharedWithFieldName] ?? []),
      content: parsedContent,
    );
  }
}

//damit erkennbar, wer was und wann geschrieben hat, definiert einen einzelnen Absatz:
class NoteParagraph {
  final String author;
  final String text;
  final DateTime timestamp;

  NoteParagraph({
    required this.author,
    required this.text,
    required this.timestamp,
  });

  //wandelt NoteParagraph-Objekt in eine Map um, diese kann so in Firestore gespeichert werden
  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  //Baut ein NoteParagraph-Objekt aus einer Map, die aus Firestore kommt
  factory NoteParagraph.fromMap(Map<String, dynamic> map) {
    return NoteParagraph(
      author: map['author'] as String,
      text: map['text'] as String,
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}

