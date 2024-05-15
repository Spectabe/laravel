import 'package:flutter/material.dart';
import 'package:hopelast_flutter/dialogs/add_event_dialog.dart';
import 'package:hopelast_flutter/pages/home_page_pages/account_page.dart';
import 'package:hopelast_flutter/pages/home_page_pages/calendar_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  final pages = [
    CalendarPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Container(
          height: 60,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AddEventDialog());
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
        body: pages[currentPageIndex],
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.calendar_month,
                color: Colors.black,
              ),
              icon: Icon(
                Icons.calendar_month_outlined,
                color: Colors.black38,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.supervised_user_circle,
                color: Colors.black,
              ),
              icon: Icon(
                Icons.supervised_user_circle_outlined,
                color: Colors.black38,
              ),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
