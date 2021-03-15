import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetails {
  Timestamp date;
  String imageURL;
  int weight;
  GeoPoint location;

  PostDetails({
    @required this.date,
    @required this.imageURL,
    @required this.weight,
    @required this.location,
  });

  PostDetails.fromFirestoreData(QueryDocumentSnapshot doc) {
    imageURL = doc.get('imageURL');
    date = doc.get('date');
    location = doc.get('location');
    weight = doc.get('weight');
  }

  void addPostCloud() {
    Firestore.instance.collection('posts').add({
      'date': this.date,
      'imageURL': this.imageURL,
      'weight': this.weight,
      'location': this.location
    });
  }
}
