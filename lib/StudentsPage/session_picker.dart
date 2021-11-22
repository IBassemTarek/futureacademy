import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futureacademy/GroupPage/section_time.dart';
import 'package:futureacademy/Shared/buttom_action.dart';

import '../const.dart';

void sessionPicker({
  required BuildContext context,
  required Function(Timestamp) onTap,
  required List dates,
}) {
  final _height = MediaQuery.of(context).size.height;
  late Timestamp selectedDate = Timestamp.fromDate(DateTime(2020));
  showModalBottomSheet<void>(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
    backgroundColor: kBackgroundColor,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('إختر ميعاد التدريب',
                    style: Theme.of(context).textTheme.subtitle1),
              ),
              GridView.count(
                childAspectRatio: 4.0,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                children: dates
                    .map(
                      (e) => InkWell(
                        onTap: () {
                          setState(() {
                            selectedDate = e;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              selectedDate == e
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: kAccentColor2,
                              size: 25,
                            ),
                            SetionTime(
                              e: DateTime.fromMicrosecondsSinceEpoch(
                                  e.microsecondsSinceEpoch),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              ButtomAction(
                buttonType: ButtonType.small,
                // ignore: unnecessary_null_comparison
                disable: selectedDate == Timestamp.fromDate(DateTime(2020)),
                onTap: () {
                  onTap(selectedDate);
                },

                title: "تأكيد",
              ),
            ],
          ),
        );
      });
    },
  );
}
