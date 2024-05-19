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

  final List<Widget> pages = [
    CalendarPage(),
    AccountPage(),
  ];

  void refreshEvents() {
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: pages[currentPageIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(30),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(221, 221, 221, 1),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: NavigationBar(
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
                          size: 30,
                        ),
                        icon: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.black38,
                          size: 30,
                        ),
                        label: 'Home',
                      ),
                      NavigationDestination(
                        selectedIcon: Icon(
                          Icons.supervised_user_circle,
                          color: Colors.black,
                          size: 30,
                        ),
                        icon: Icon(
                          Icons.supervised_user_circle_outlined,
                          color: Colors.black38,
                          size: 30,
                        ),
                        label: 'Account',
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          AddEventDialog(notifyParent: refreshEvents),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 61, 61, 61),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
