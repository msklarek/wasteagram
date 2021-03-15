import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/screens/add_post.dart';

void main() {
  test('Empty value should return error', () {
    expect(Validator.validateNum(''), 'Please enter a value');
  });

  test('Valid value should not return error', () {
    expect(Validator.validateNum('5'), null);
  });
}
