import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //get colection
  final CollectionReference notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  //CREATE
  Future<void> addNote(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  //READ
  Stream<QuerySnapshot> getNoteStrem(){
    final noteStrem = notes.orderBy('timestamp', descending: true).snapshots();
    
    return noteStrem;
  }

  //UPDATE
  Future<void> updateNote(String docID, String newNote){
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now()
    });
  }


  //DELETE DATA NOTE
  Future<void> deleteNote(String docID){
    return notes.doc(docID).delete();
  }

}
