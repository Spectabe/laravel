import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../auth_state.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  PageController pageController1 = PageController(
    viewportFraction: 0.3,
    initialPage: 25,
  );

  PageController pageController2 = PageController(
    viewportFraction: 1,
    initialPage: 25,
  );

  DateTime today = DateTime.now();
  int selectedDay = 24;
  Future<List<dynamic>>? events;

  @override
  void initState() {
    final authState = Provider.of<AuthState>(context, listen: false);
    events = authState.getAllEvents(context);

    super.initState();
  }

  @override
  void dispose() {
    pageController1.dispose();
    pageController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              flex: 1,
              child: PageView.builder(
                onPageChanged: onPageChanged1,
                itemBuilder: (context, index) {
                  int relativeIndex = index - 24;
                  DateTime date = today.add(Duration(days: relativeIndex));

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: selectedDay == index
                          ? const Color.fromARGB(255, 235, 235, 235)
                          : const Color.fromARGB(31, 255, 255, 255),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${date.day}",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: selectedDay == index
                            ? Colors.black
                            : Colors.black12
                          ),
                        ),
                        Text(
                          get3DigitDayName(date),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: selectedDay == index
                            ? Colors.black
                            : Colors.black12
                          ),
                        ),
                      ],
                    ),
                  );
                },
                controller: pageController1,
                itemCount: 50,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              flex: 9,
              child: PageView.builder(
                allowImplicitScrolling: true,
                onPageChanged: onPageChanged2,
                itemBuilder: (context, index) {
                  int relativeIndex = index - 25;
                  DateTime date = today.add(Duration(days: relativeIndex));

                  return FutureBuilder<List<dynamic>>(
                    future: events,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text('Errore nel recupero degli eventi'));
                      } else {
                        List<dynamic> currentEvents = snapshot.data!
                            .where((event) =>
                                isSameDate(event['date_time_start'], date))
                            .toList();

                        return ListView.builder(
                          itemCount: currentEvents.length,
                          itemBuilder: (context, index) {
                            var event = currentEvents[index];

                            String startDate = event['date_time_start'];
                            DateTime startTime = DateTime.parse(startDate);
                            String startTimeString =
                                DateFormat.Hm().format(startTime);

                            String endDate = event['date_time_end'];
                            DateTime endTime = DateTime.parse(endDate);
                            String endTimeString =
                                DateFormat.Hm().format(endTime);

                            String title = event['title'];

                            return Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 10,
                                  ),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 223, 223, 223),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Text(
                                    startTimeString,
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 61, 61, 61),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "$startTimeString - $endTimeString",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black54),
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                  );
                },
                controller: pageController2,
                itemCount: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPageChanged1(value) {
    setState(() {
      pageController2.jumpToPage(value);
      selectedDay = value - 1;
    });
  }

  void onPageChanged2(index) {
    pageController1
        .animateToPage(
          index,
          curve: Curves.fastOutSlowIn,
          duration: Durations.short1,
        )
        .then((v) => setState(() {
              selectedDay = index - 1;
            }));
  }
}

String get3DigitDayName(DateTime date) {
  final daysOfWeek = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];

  final dayIndex = date.weekday - 1;
  final dayName = daysOfWeek[dayIndex];
  return dayName;
}

bool isSameDate(String dateString, DateTime date) {
  DateTime eventDate = DateTime.parse(dateString);
  return eventDate.year == date.year &&
      eventDate.month == date.month &&
      eventDate.day == date.day;
}
