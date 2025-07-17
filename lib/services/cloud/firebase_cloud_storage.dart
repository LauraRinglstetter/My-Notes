import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firstapp/services/cloud/cloud_note.dart';
import 'package:firstapp/services/cloud/cloud_storage_constants.dart';
import 'package:firstapp/services/cloud/cloud_storage_exceptions.dart';

//Singleton-Klasse
class FirebaseCloudStorage {

  //Firestore-Collection called 'notes':
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      notes.doc(documentId).delete();
    } catch (e) {
        throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
        throw CouldNotUpdateNoteException();
    }
  }

  //gibt Live-Stream aller Notizen eines bestimmten Benutzers zurück
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
    notes.snapshots().map((event) => event.docs
      .map((doc) => CloudNote.fromSnapshot(doc))
      .where((note) => note.ownerUserId == ownerUserId));

  //holt alle Notizen eines bestimmten Nutzers auf der Firestore-Datenbank, 
  //gefiltert nach ownerUserId und gibt sie als Liste von CloudNote-Ojekten zurück
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
      .where(
        ownerUserIdFieldName,
        isEqualTo: ownerUserId
      )
      .get()
      .then(
        (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc))
      );
    } catch(e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id, 
      ownerUserId: ownerUserId, 
      text: '',
    );
  }

  //erstellt eine einzige Instanz dieser Klasse, die global verwendet werden kann
  static final FirebaseCloudStorage _shared = 
  FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}