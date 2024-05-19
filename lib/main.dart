import 'package:flutter/material.dart';
import 'package:hopelast_flutter/auth_state.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthState(),
      child: Consumer<AuthState>(
        builder: (context, authState, child) {
          return MaterialApp.router(
            themeMode: ThemeMode.light,
            theme: ThemeData(
              // colorScheme: const ColorScheme(
              //   brightness: Brightness.light,
              //   primary: Color.fromARGB(255, 255, 255, 255),
              //   onPrimary: Color.fromARGB(255, 69, 69, 69),
              //   secondary: Color.fromARGB(255, 255, 255, 255),
              //   onSecondary: Color.fromARGB(255, 47, 47, 47),
              //   error: Color.fromARGB(255, 255, 255, 255),
              //   onError: Color.fromARGB(255, 54, 54, 54),
              //   background: Color.fromARGB(255, 255, 255, 255),
              //   onBackground: Color.fromARGB(255, 39, 39, 39),
              //   surface: Color.fromARGB(255, 255, 255, 255),
              //   onSurface: Color.fromARGB(255, 79, 79, 79),
              // ),
              inputDecorationTheme: InputDecorationTheme(
                filled: false,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(66, 66, 66, 1),
                    width: 2.0,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(167, 167, 167, 1),
                    width: 1.0,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 16.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(167, 167, 167, 1),
                    width: 1.0,
                  ),
                ),
                labelStyle: const TextStyle(
                  color: Color.fromRGBO(167, 167, 167, 1),
                  fontSize: 16.0,
                ),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
              scaffoldBackgroundColor: Colors.white,
              navigationBarTheme: const NavigationBarThemeData(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                indicatorColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
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
                    const ColoredBox(
                      color: Color.fromARGB(49, 129, 129, 129),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
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
