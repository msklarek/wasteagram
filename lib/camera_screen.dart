import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart' as Path;

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File image;

  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    image = File(pickedFile.path);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // StorageReference storageReference =
    //     FirebaseStorage.instance.ref().child(Path.basename(image.path));
    // StorageUpload uploadTask = storageReference.putFile(image);
    // await uploadTask.onComplete;
    // final url = await storageReference.getDownloadURL();
    // print(url);
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                          leading: Text(post['weight'].toString()),
                          title: Text('Post Title'),
                        );
                      }),
                ),
                RaisedButton(
                    child: Text('Send Data'),
                    onPressed: () {
                      getImage();
                      // FirebaseFirestore.instance.collection('posts').add({
                      //   'weight': 222,
                      //   'submission_date': DateTime.parse('2020-01-31')
                      // });
                    })
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class Firestore {}
