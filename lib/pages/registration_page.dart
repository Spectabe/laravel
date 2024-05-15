import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hopelast_flutter/auth_state.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: "Michele");
  final _emailController = TextEditingController(text: "michelerbbt@gmail.com");
  final _passwordController = TextEditingController(text: "Michelino1#");
  final _confirmPasswordController = TextEditingController(text: "Michelino1#");

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inserisci un nome';
                  } else if (value.length > 70) {
                    return 'La lunghezza del nome non deve superare i 70 caratteri';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
                  final RegExp pswRegex = RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!.=-_@#\$&*~]).{8,}$');
          
                  if (value!.isEmpty) {
                    return 'Inserisci una password';
                  }
                  if (!pswRegex.hasMatch(value)) {
                    // Michelino1#
                    String _text = 'Passoword non valida';
                    _text += '\nrequisiti:';
                    _text += '\n\u2022 lunghezza minima 8 caratteri';
                    _text += '\n\u2022 lunghezza massima 64 caratteri';
                    _text +=
                        '\n\u2022 almeno 1 carattere speciale ( !.=-_@#\$&*~ )';
                    _text += '\n\u2022 almeno 1 numero';
                    _text += '\n\u2022 almeno 1 maiuscola';
          
                    return _text;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Conferma Password',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inserisci la password di conferma';
                  }
                  if (value != _passwordController.text) {
                    return 'Le password non corrispondono';
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
                    String name = _nameController.text;
                    String email = _emailController.text;
                    String password = _passwordController.text;
          
                    print("name " + name);
                    print("email " + email);
                    print("password $password");
          
                    authState.register(name, email, password, context);
                  }
                },
                child: Text('Registrazione'),
              ),
              TextButton(
                onPressed: () {
                  Provider.of<AuthState>(context, listen: false);
                  context.go('/login');
                },
                child: Text("Effettua accesso"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
