import 'package:flutter/material.dart';
import 'package:hopelast_flutter/auth_state.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthState(),
      child: Consumer<AuthState>(
        builder: (context, authState, child) {
          return MaterialApp.router(
            theme: ThemeData(
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 61, 61, 61),
                shape: CircleBorder(),
                elevation: 0.0,
                highlightElevation: 0.0,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 61, 61, 61),
                ),
              ),
              progressIndicatorTheme: const ProgressIndicatorThemeData(
                color: const Color.fromARGB(255, 61, 61, 61),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 219, 219, 219)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 219, 219, 219)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelStyle: TextStyle(color: Colors.grey),
                hintStyle: TextStyle(color: Colors.grey),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 61, 61, 61),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: const [
              Locale('it', ''),
            ],
            routerConfig: router,
            builder: (context, child) {
              return Stack(
                children: [
                  child!,
                  if (authState.isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
