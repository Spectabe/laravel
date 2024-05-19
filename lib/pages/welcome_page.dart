import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hopelast_flutter/widgets/light_gray_text_button%20copy.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Benventuo in",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    color: Color.fromRGBO(135, 135, 135, 1),
                  ),
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'assets/images/text-logo.png',
                  height: 22,
                ),
              ],
            ),
            const SizedBox(height: 20),
            LightGrayTextButton(
              onPressed: () => context.go('/register'),
              text: 'Crea account',
            ),
            const SizedBox(height: 10),
            LightGrayTextButton(
              onPressed: () => context.go('/login'),
              text: 'Login',
            ),
          ],
        ),
      )),
    );
  }
}
