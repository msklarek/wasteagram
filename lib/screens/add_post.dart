import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:wasteagram/models/post_details.dart';

class AddPost extends StatefulWidget {
  AddPost({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
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
    final imgLocation =
        await (await uploadTask.onComplete).ref.getDownloadURL();
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

  Future<void> _sendAnalyticsEvent(int num) async {
    await widget.analytics.logEvent(
      name: 'wasted_item_update',
      parameters: <String, dynamic>{
        'weight': num,
      },
    );
    print('analytics sent');
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      getImage();
      // retrieveLocation();
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
          appBar: new AppBar(title: new Text('New Post')),
          backgroundColor: Colors.grey[800],
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
                      decoration: new InputDecoration(
                          labelText: 'Number of Wasted Items'),
                      onSaved: (value) {
                        return post.weight = num.parse(value);
                      },
                      validator: Validator.validateNum,
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Semantics(
                      button: true,
                      enabled: true,
                      onTapHint: 'Upload to cloud',
                      child: RaisedButton(
                        elevation: 10.0,
                        child: Text('Upload'),
                        textColor: Colors.white,
                        color: Colors.blue[300],
                        onPressed: () async {
                          if (validateAndSave()) {
                            var currentTime = new DateTime.now();
                            var url = await uploadImage(currentTime);
                            post.imageURL = url;
                            post.date = Timestamp.fromDate(currentTime);
                            post.addPostCloud();
                            _sendAnalyticsEvent(post.weight);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ]))));
    }
  }
}

class Validator {
  static String validateNum(String value) {
    if (value.isEmpty) {
      return 'Please enter a value';
    } else {
      return null;
    }
  }
}
