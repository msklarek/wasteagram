import 'package:flutter/material.dart';
import 'package:wasteagram/widgets/display_image.dart';
import '../models/post_details.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  PostDetails singlePost;

  DetailScreen({Key key, @required this.singlePost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('EEEE, LLLL, dd, yyyy');
    return new Scaffold(
      appBar: new AppBar(title: new Text('Wasteagram')),
      backgroundColor: Colors.grey[800],
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  formatter.format(DateTime.fromMillisecondsSinceEpoch(
                      singlePost.date.millisecondsSinceEpoch)),
                  style: TextStyle(fontSize: 26, color: Colors.white),
                ),
                DisplayImage(singlePost: singlePost),
                SizedBox(
                  height: 15,
                ),
                Text('${singlePost.weight.toString()} items',
                    style: TextStyle(fontSize: 22, color: Colors.white)),
                Text(
                    'Location: (${singlePost.location.latitude}, ${singlePost.location.longitude})',
                    style: TextStyle(fontSize: 22, color: Colors.white))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
