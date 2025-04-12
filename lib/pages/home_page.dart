import 'package:popluk/auth.dart';
import 'package:popluk/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:popluk/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  // text controller
  final TextEditingController textController = TextEditingController();

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('firebse Auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
  }

  void openNoteBox(String? docID) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(controller: textController),
            actions: [
              //Button Submit to save
              ElevatedButton(
                onPressed: () {
                  //check is null add data to controller
                  if (docID == null) {
                    //add a new note
                    firestoreService.addNote(textController.text);
                  } else {
                    firestoreService.updateNote(docID, textController.text);
                  }

                  //clear the text controller
                  textController.clear();

                  //close the Box
                  Navigator.pop(context);
                },
                child: Text("Add"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () async {
              await Auth().signOut(); // เรียก method signOut จาก service ของคุณ
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(null),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // เพิ่ม child อันแรกที่คุณต้องการที่นี่
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _userUid(),
              _signOutButton()
            ],
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getNoteStrem(),
              builder: (context, snapshot) {
                // if we have data, get all the docs
                if (snapshot.hasData) {
                  List notesList = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: notesList.length,
                    itemBuilder: (context, index) {
                      // get each individual doc
                      DocumentSnapshot document = notesList[index];
                      String docID = document.id;

                      // get note from each doc
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String noteText = data['note'];

                      // display as a list tile
                      return ListTile(
                        title: Text(noteText),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // update button
                            IconButton(
                              onPressed: () => openNoteBox(docID),
                              icon: const Icon(Icons.settings),
                            ),

                            //delete button
                            IconButton(
                              onPressed:
                                  () => firestoreService.deleteNote(docID),
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Text("No Note..");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
