import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futureacademy/Shared/buttom_action.dart';

import '../const.dart';

void datePicker(
    {required BuildContext context,
    required Function(DateTime) onTap,
    required DateTime initial}) {
  final _height = MediaQuery.of(context).size.height;
  late DateTime temp = DateTime.now();
  late int iterations = 0;
  showModalBottomSheet<void>(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
    backgroundColor: kBackgroundColor,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) => SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('إختر ميعاد التدريب',
                    style: Theme.of(context).textTheme.subtitle1),
              ),
              SizedBox(
                height: _height / 4,
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initial,
                  // onDateTimeChanged: onTap,
                  onDateTimeChanged: (DateTime newDateTime) {
                    temp = newDateTime;
                    setState(() {
                      iterations++;
                    });
                  },
                ),
              ),
              ButtomAction(
                buttonType: ButtonType.small,
                // ignore: unnecessary_null_comparison
                disable: iterations == 0,
                onTap: () {
                  onTap(temp);
                  Navigator.pop(context);
                },
                title: "تأكيد",
              ),
            ],
          ),
        ),
      );
    },
  );
}
