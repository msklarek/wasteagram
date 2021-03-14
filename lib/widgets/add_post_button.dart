import 'package:flutter/material.dart';
import 'package:wasteagram/screens/add_post.dart';

class AddPostButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
        button: true,
        enabled: true,
        onTapHint: 'Add a new post',
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddPost()));
          },
          tooltip: 'Add Post',
          child: Icon(Icons.camera),
        ));
  }
}
