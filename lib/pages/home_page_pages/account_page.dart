import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth_state.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final authState = Provider.of<AuthState>(context, listen: false);
            authState.logout(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: Text(
            "Esci dall'account",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
