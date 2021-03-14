import 'package:flutter/material.dart';
import '../models/post_details.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'add_post.dart';
import '../models/post_details.dart';

class DetailScreen extends StatelessWidget {
  PostDetails singlePost;

  //requiring the list of todos
  DetailScreen({Key key, @required this.singlePost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('EEEE, LLLL, dd, yyyy');

    if (singlePost == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(formatter.format(DateTime.fromMillisecondsSinceEpoch(
              singlePost.date.millisecondsSinceEpoch))),
          // Text(
          //   singlePost.imageURL,
          // ),
          Text(singlePost.weight.toString()),
          Text(
              'Location: (${singlePost.location.latitude}, ${singlePost.location.longitude}'),
        ],
      ));
    }
  }
}
