import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/models/post_details.dart';
import 'package:wasteagram/screens/add_post.dart';

void main() async {
  int currentTimeMs = DateTime.now().millisecondsSinceEpoch;
  final instance = MockFirestoreInstance();
  await instance.collection('posts').add({
    'imageURL': 'http://www.examle.com/myimage.jpg',
    'date': Timestamp.fromMillisecondsSinceEpoch(currentTimeMs),
    'location': GeoPoint(22.6, 23.5),
    'weight': 2
  });

  final snapshot = await instance.collection('posts').get();
  test('Test value insertion in mock', () {
    expect(snapshot.docs.length, 1); // 1
    expect(snapshot.docs.first.get('imageURL'),
        'http://www.examle.com/myimage.jpg');
    expect(snapshot.docs.first.get('date'),
        Timestamp.fromMillisecondsSinceEpoch(currentTimeMs));
    expect(snapshot.docs.first.get('location'), GeoPoint(22.6, 23.5));
    expect(snapshot.docs.first.get('weight'), 2);
  });
  test('Test Conversion', () {
    PostDetails actual = PostDetails.fromFirestoreData(snapshot.docs.first);
    expect(actual.imageURL, 'http://www.examle.com/myimage.jpg');
    expect(actual.date, Timestamp.fromMillisecondsSinceEpoch(currentTimeMs));
    expect(actual.location, GeoPoint(22.6, 23.5));
    expect(actual.weight, 2);
  });

  test('Create Post Details', () {
    PostDetails post = PostDetails(
        imageURL: "http://www.examle.com/myimage.jpg",
        date: Timestamp.fromMillisecondsSinceEpoch(currentTimeMs),
        location: GeoPoint(22.6, 23.5),
        weight: 2);

    expect(post.imageURL, 'http://www.examle.com/myimage.jpg');
    expect(post.date, Timestamp.fromMillisecondsSinceEpoch(currentTimeMs));
    expect(post.location.latitude, 22.6);
    expect(post.location.longitude, 23.5);
    expect(post.weight, 2);
  });

  test('Empty value should return error', () {
    expect(Validator.validateNum(''), 'Please enter a value');
  });

  test('Valid value should not return error', () {
    expect(Validator.validateNum('5'), null);
  });
}
