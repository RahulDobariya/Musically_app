import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/presentation/screen/signin_signup_page.dart';

void main() {
  testWidgets('SigninSignupPage UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SigninSignupPage()));

    expect(find.text('Find Music and Enjoy'), findsOneWidget);
    expect(find.text('Search, getand save your favorite \nmusic on your playlist make'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });
}
