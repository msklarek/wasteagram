import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/widgets/add_post_button.dart';
import 'detail_screen.dart';
import '../models/posts.dart';
import '../models/post_details.dart';
import '../widgets/add_post_button.dart';

class ListScreen extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  ListScreen({Key key, this.analytics, this.observer}) : super(key: key);
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
          if (snapshot.hasData &&
              snapshot.data.documents != null &&
              snapshot.data.documents.length > 0) {
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
                                        singlePost:
                                            PostDetails.fromFirestoreData(
                                                post))));
                          },
                        ));
                      }),
                ),
                AddPostButton(
                  analytics: widget.analytics,
                  observer: widget.observer,
                ),
              ],
            );
          } else {
            // return ;
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Center(child: CircularProgressIndicator()),
                  // SizedBox(
                  //   height: 30,
                  // ),
                  AddPostButton(
                    analytics: widget.analytics,
                    observer: widget.observer,
                  )
                ]);
          }
        });
  }
}
