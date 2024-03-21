import 'package:flutter/material.dart';
import 'package:music_app/presentation/screen/form_page.dart';
import 'package:music_app/presentation/widgets/my_button.dart';

class SigninSignupPage extends StatelessWidget {
  const SigninSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey,
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
          ),
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 30),
            const Column(
              children: [
                Text(
                  'Find Music and Enjoy',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
                Text(
                  'Search, getand save your favorite \nmusic on your playlist make',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: MyButton(
                      fColor: Colors.black,
                      bColor: Colors.white,
                      name: 'Sign in',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FormPage(
                              type: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: MyButton(
                      fColor: Colors.black,
                      bColor: Colors.amber.shade300,
                      name: 'Sign up',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FormPage(
                              type: false,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
          ],
        ))
      ],
    ));
  }
}
