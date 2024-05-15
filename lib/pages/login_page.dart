import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hopelast_flutter/auth_state.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: "michelerbbt@gmail.com");
  final _passwordController = TextEditingController(text: "Michelino1#");

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
          padding: EdgeInsets.all(50),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Inserisci un\'email';
                    } else if (value.length > 254) {
                      return 'La lunghezza della mail deve essere di massimo 254 caratteri';
                    }
                    return null;
                  },
                ),
                              const SizedBox(height: 20),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Inserisci una password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final authState =
                          Provider.of<AuthState>(context, listen: false);
                          
                      String email = _emailController.text;
                      String password = _passwordController.text;
            
                      authState.login(email, password, context);
                    }
                  },
                  child: Text('Accedi'),
                ),
                TextButton(
                  onPressed: () {
                    Provider.of<AuthState>(context, listen: false);
                    context.go('/register');
                  },
                  child: Text("Registrati"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
