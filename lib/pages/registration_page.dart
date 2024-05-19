import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hopelast_flutter/auth_state.dart';
import 'package:hopelast_flutter/widgets/black_text_button.dart';
import 'package:provider/provider.dart';

import '../widgets/light_gray_text_button copy.dart';

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

  // problema di overflow se tutti i validator restituiscono un messaggio

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
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
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inserisci un\'email';
                  } else if (value.length > 254) {
                    return 'La lunghezza della mail deve essere di massimo 254 caratteri';
                  } else if (!value.contains('@')) {
                    return 'Mail non valida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  errorMaxLines: 2,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inserisci una password';
                  }

                  if (value.length < 8) {
                    return 'La password deve contenere almeno 8 caratteri';
                  }

                  if (value.length > 64) {
                    return 'La password deve contenere al massimo 64 caratteri';
                  }

                  final RegExp uppercaseRegex = RegExp(r'(?=.*?[A-Z])');
                  final RegExp lowercaseRegex = RegExp(r'(?=.*?[a-z])');
                  final RegExp digitRegex = RegExp(r'(?=.*?[0-9])');
                  final RegExp specialCharRegex =
                      RegExp(r'(?=.*?[!.=-_@#\$&*~])');

                  if (!uppercaseRegex.hasMatch(value)) {
                    return 'La password deve contenere almeno una lettera maiuscola';
                  }

                  if (!lowercaseRegex.hasMatch(value)) {
                    return 'La password deve contenere almeno una lettera minuscola';
                  }

                  if (!digitRegex.hasMatch(value)) {
                    return 'La password deve contenere almeno un numero';
                  }

                  if (!specialCharRegex.hasMatch(value)) {
                    return 'La password deve contenere almeno un carattere speciale ( !.=-_@#\$&*~ )';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Ripeti password',
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
              const SizedBox(height: 40),
              BlackTextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final authState =
                        Provider.of<AuthState>(context, listen: false);
                    String name = _nameController.text;
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    authState.register(name, email, password, context);
                  }
                },
                text: 'Crea account',
              ),
              const SizedBox(height: 10),
              LightGrayTextButton(
                onPressed: () => context.go('/welcome'),
                text: "Torna indietro",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
