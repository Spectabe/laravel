import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../auth_state.dart';

// non vengono fatti controlli sulle date
class AddEventDialog extends StatefulWidget {
  const AddEventDialog({super.key, required this.notifyParent});

  final Function() notifyParent;

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  String getMonthAsLocalizedString(DateTime date, String localName) {
    String monthName = DateFormat.MMMM(localName).format(date);
    return monthName[0].toUpperCase() + monthName.substring(1);
  }

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();

  Future<DateTime> _showDatePicker(BuildContext context, DateTime date) async {
    final DateTime? picked = await showDatePicker(
        locale: const Locale('it'),
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      return picked;
    }
    return date;
  }

  Future<TimeOfDay> _showTimePicker(
      BuildContext context, TimeOfDay time) async {
    TimeOfDay? picked = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (picked != null && picked != time) {
      return picked;
    }
    return time;
  }

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      alignment: Alignment.bottomCenter,
      insetPadding: const EdgeInsets.all(0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Aggiungi evento",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Titolo',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Inserisci una titolo valido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrizione',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    _descriptionController.text = "Nessuna descrizione";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),
            // =======================================
            //        START DATE TIME
            // =======================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Da",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          startDate = await _showDatePicker(context, startDate);
                          setState(() {});
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Text(
                            "${startDate.day} / ${startDate.month} / ${startDate.year}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () async {
                          startTime = await _showTimePicker(context, startTime);
                          setState(() {});
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Text(
                            "${startTime.hour} : ${startTime.minute}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            // =======================================
            //        END DATE TIME
            // =======================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "A",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          endDate = await _showDatePicker(context, endDate);
                          setState(() {});
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Text(
                            "${endDate.day} / ${endDate.month} / ${endDate.year}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () async {
                          endTime = await _showTimePicker(context, endTime);
                          setState(() {});
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Text(
                            "${endTime.hour} : ${endTime.minute}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: IconButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final authState =
                            Provider.of<AuthState>(context, listen: false);

                        String title = _titleController.text;
                        String description = _descriptionController.text;
                        DateTime dateTimeStart = DateTime(
                          startDate.year,
                          startDate.month,
                          startDate.day,
                          startTime.hour,
                          startTime.minute,
                        );

                        DateTime dateTimeEnd = DateTime(
                          endDate.year,
                          endDate.month,
                          endDate.day,
                          endTime.hour,
                          endTime.minute,
                        );

                        context.pop();
                        authState
                            .addEvent(
                              title,
                              description,
                              dateTimeStart,
                              dateTimeEnd,
                              context,
                            )
                            .then(
                              (value) => widget.notifyParent(),
                            );
                      }
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 61, 61, 61),
                      padding: const EdgeInsets.all(15),
                    ),
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
