import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:wasteagram/models/post_details.dart';
import '../location.dart';
import 'package:path/path.dart' as Path;

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File image;
  LocationData locationData;
  final picker = ImagePicker();
  final formKey = new GlobalKey<FormState>();
  final post = PostDetails();
  String uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  //Validate if form is valid and Save
  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    image = File(pickedFile.path);
    setState(() {});
  }

  Future<String> uploadImage(DateTime currentTime) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("image");
    StorageUploadTask uploadTask =
        storageReference.child(currentTime.toString() + ".jpg").putFile(image);
    final imgLocation = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = imgLocation.toString();
    return url;
  }

  void retrieveLocation() async {
    var locationService = Location();
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
    post.location = GeoPoint(locationData.latitude, locationData.longitude);
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      getImage();
      // retrieveLocation();
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
          body: Container(
              child: Form(
                  key: formKey,
                  child: ListView(children: <Widget>[
                    Image.file(
                      image,
                      height: 330.0,
                      width: 660,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ], // Only numbers can be entered
                      decoration:
                          new InputDecoration(labelText: 'Number of Items'),
                      onSaved: (value) {
                        return post.weight = num.parse(value);
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Semantics(
                      button: true,
                      enabled: true,
                      onTapHint: 'Upload the Item',
                      child: RaisedButton(
                        elevation: 10.0,
                        child: Text('Add a new Item'),
                        textColor: Colors.white,
                        color: Colors.pink,
                        onPressed: () async {
                          if (validateAndSave()) {
                            var currentTime = new DateTime.now();
                            var url = await uploadImage(currentTime);
                            print(url);
                            post.imageURL = url;
                            post.date = Timestamp.fromDate(currentTime);
                            // print(uploadedImageUrl);
                            post.addPostCloud();
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ]))));
    }
  }
}
