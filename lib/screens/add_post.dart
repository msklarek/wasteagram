import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File image;

  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    image = File(pickedFile.path);
    // StorageReference storageReference =
    //     FirebaseStorage.instance.ref().child(Path.basename(image.path));
    // StorageUploadTask uploadTask = storageReference.putFile(image);
    // await uploadTask.onComplete;
    // final url = await storageReference.getDownloadURL();
    // print(url);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      getImage();
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
          body: Container(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(image),
                  TextField(
                    decoration: InputDecoration(labelText: 'Enter weight'),
                    keyboardType: TextInputType.numberWithOptions(),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  RaisedButton(
                    child: Text('Upload'),
                    onPressed: () {},
                  )
                ],
              )));
    }
  }
}
