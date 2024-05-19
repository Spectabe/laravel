import 'package:flutter/material.dart';
import 'package:hopelast_flutter/dialogs/edit_event_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// se aggiungo un evento in data non giornaliera non compare!!!
import '../../auth_state.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  PageController pageController1 = PageController(
    viewportFraction: 0.32,
    initialPage: 25,
  );

  PageController pageController2 = PageController(
    viewportFraction: 1,
    initialPage: 25,
  );

  DateTime selectedDate = DateTime.now();
  int selectedDay = 24;
  Future<List<dynamic>>? events;

  void refreshEvents() {
    final authState = Provider.of<AuthState>(context, listen: false);
    setState(() {
      events = authState.getAllEvents(context);
    });
  }

  @override
  void initState() {
    refreshEvents();

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
    String monthName = DateFormat.MMMM('it').format(selectedDate);
    String monthNameFormatted =
        monthName[0].toUpperCase() + monthName.substring(1);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 40),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PageView.builder(
                  onPageChanged: onPageChanged1,
                  itemBuilder: (context, index) {
                    int relativeIndex = index - 24;
                    DateTime date =
                        selectedDate.add(Duration(days: relativeIndex));

                    return selectedDay == index
                        ? Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 243, 243, 243),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    "${date.day}",
                                    style: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    get3DigitDayName(date),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                width: 1,
                                color: const Color.fromRGBO(215, 215, 215, 1),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    "${date.day}",
                                    style: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(215, 215, 215, 1),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    get3DigitDayName(date),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(215, 215, 215, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                  controller: pageController1,
                  itemCount: 50,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$monthNameFormatted ${selectedDate.year}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 193, 193, 193),
                  ),
                ),
                const SizedBox(width: 5),
                IconButton(
                  padding: EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.calendar_month,
                    size: 18,
                    color: Color.fromARGB(255, 193, 193, 193),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: PageView.builder(
                  allowImplicitScrolling: true,
                  onPageChanged: onPageChanged2,
                  itemBuilder: (context, index) {
                    int relativeIndex = index - 25;
                    DateTime date =
                        selectedDate.add(Duration(days: relativeIndex));

                    return FutureBuilder<List<dynamic>>(
                      future: events,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              // child: CircularProgressIndicator()
                              child: Text(""),
                              );
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Errore nel recupero degli eventi'));
                        } else {
                          List<dynamic> currentEvents = snapshot.data!
                              .where((event) =>
                                  isSameDate(event['date_time_start'], date))
                              .toList();

                          return RefreshIndicator(
                            color: const Color.fromRGBO(66, 66, 66, 1),
                            onRefresh: () async {
                              refreshEvents();
                            },
                            child: ListView.builder(
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
                                String description = event['description'];
                                int id = event['id'];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 5,
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            EditEventDialog(
                                          notifyParent: refreshEvents,
                                          eventId: id,
                                          title: title,
                                          description: description,
                                          startDate: DateTime.parse(startDate),
                                          endDate: DateTime.parse(endDate),
                                          startTime: TimeOfDay(
                                            hour: int.parse(
                                              DateFormat.H().format(startTime),
                                            ),
                                            minute: int.parse(
                                              DateFormat.m().format(startTime),
                                            ),
                                          ),
                                          endTime: TimeOfDay(
                                            hour: int.parse(
                                              DateFormat.H().format(endTime),
                                            ),
                                            minute: int.parse(
                                              DateFormat.m().format(endTime),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 30,
                                            ),
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 223, 223, 223),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Text(
                                              startTimeString,
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 61, 61, 61),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                title,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    startTimeString,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.black54),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    width: 30,
                                                    child: const Divider(
                                                      color: Color.fromRGBO(
                                                          150, 150, 150, 1),
                                                    ),
                                                  ),
                                                  Text(
                                                    endTimeString,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.black54),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    );
                  },
                  controller: pageController2,
                  itemCount: 50,
                ),
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
  final daysOfWeek = ['LUN', 'MAR', 'MER', 'GIO', 'VEN', 'SAB', 'DOM'];

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
