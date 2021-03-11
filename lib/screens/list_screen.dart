import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  File image;

  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    image = File(pickedFile.path);
    // StorageReference storageReference =
    //     FirebaseStorage.instance.ref().child(Path.basename(image.path));
    // StorageUploadTask uploadTask = storageReference.putFile(image);
    // await uploadTask.onComplete;
    // final url = await storageReference.getDownloadURL();
    // print(url);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('EEEE, LLLL, dd, yyyy');
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (content, index) {
                        var post = snapshot.data.docs[index];
                        return ListTile(
                          leading: Text(formatter.format(
                              (post['submission_date'] as Timestamp).toDate())),
                          title: Text(post['weight'].toString()),
                        );
                      }),
                ),
                FloatingActionButton(
                  onPressed: () {
                    getImage();
                    // FirebaseFirestore.instance.collection('posts').add({
                    //   'weight': 222,
                    //   'submission_date': DateTime.parse('2020-01-31')
                    // });
                  },
                  tooltip: 'Add Entry',
                  child: Icon(Icons.camera),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class Firestore {}
