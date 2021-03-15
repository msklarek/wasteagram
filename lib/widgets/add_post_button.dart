import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:wasteagram/screens/add_post.dart';

class AddPostButton extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  AddPostButton({Key key, this.analytics, this.observer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Semantics(
        button: true,
        enabled: true,
        onTapHint: 'Add a new post',
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddPost(analytics: analytics, observer: observer)));
          },
          key: Key('add_post_button'),
          tooltip: 'Add Post',
          child: Icon(Icons.camera),
        ));
  }
}
