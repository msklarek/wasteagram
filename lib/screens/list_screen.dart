import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'add_post.dart';
import 'detail_screen.dart';
import '../models/posts.dart';
import '../models/post_details.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  // File image;
  Posts posts;

  // final picker = ImagePicker();
  // Future getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   image = File(pickedFile.path);
  //   // StorageReference storageReference =
  //   //     FirebaseStorage.instance.ref().child(Path.basename(image.path));
  //   // StorageUploadTask uploadTask = storageReference.putFile(image);
  //   // await uploadTask.onComplete;
  //   // final url = await storageReference.getDownloadURL();
  //   // print(url);
  //   setState(() {});
  // }

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
                        return Card(
                            child: ListTile(
                          title: Text(formatter
                              .format((post['date'] as Timestamp).toDate())),
                          trailing: Text(post['weight'].toString()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                        singlePost: posts.entries[index])));
                          },
                        ));
                      }),
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddPost()));
                    // getImage();
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
