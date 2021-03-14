import 'package:flutter/material.dart';
import 'package:wasteagram/screens/add_post.dart';

class AddPostButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddPost()));
      },
      tooltip: 'Add Entry',
      child: Icon(Icons.camera),
    );
  }
}
