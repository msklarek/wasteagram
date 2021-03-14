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

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('EEEE, LLLL, dd, yyyy');
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('date', descending: true)
            .snapshots(),
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
                                        singlePost: PostDetails(
                                            imageURL: post['imageURL'],
                                            date: post['date'],
                                            location: post['location'],
                                            weight: post['weight']))));
                          },
                        ));
                      }),
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddPost()));
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
