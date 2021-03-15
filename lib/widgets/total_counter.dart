import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget TotalCounter(BuildContext context) {
  return AppBar(
    title: StreamBuilder(
      stream: Firestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        int count = 0;
        if (snapshot.hasData) {
          for (var i = 0; i < snapshot.data.documents.length; i++) {
            try {
              count += snapshot.data.documents[i]['weight'];
            } catch (exception) {
              // if the record has weight field missing just swallow the error
            }
          }
          return Text(
            "Wasteagram - $count",
            style: TextStyle(fontWeight: FontWeight.bold),
          );
        } else {
          return Text("Wasteagram",
              style: TextStyle(fontWeight: FontWeight.bold));
        }
      },
    ),
  );
}
