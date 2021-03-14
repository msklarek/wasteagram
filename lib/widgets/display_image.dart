import 'package:flutter/material.dart';
import 'package:wasteagram/models/post_details.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage({
    Key key,
    @required this.singlePost,
  }) : super(key: key);

  final PostDetails singlePost;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      singlePost.imageURL,
      scale: 0.5,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    );
  }
}
