import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futureacademy/Models/student_model.dart';
import 'package:futureacademy/Shared/buttom_action.dart';
import 'package:futureacademy/Shared/loading.dart';
import 'package:futureacademy/Shared/small_appbar.dart';
import 'package:futureacademy/services/students_services.dart';

import '../const.dart';

class AttendeesPage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const AttendeesPage({required this.groupid, required this.date});
  final String groupid;
  final Timestamp date;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    late List<String> activeStudents = [];
    return Scaffold(
      body: FutureBuilder<List<StudentsModel>>(
          future: StudentsDataBaseServices().getStudentsGroup(
            groupId: groupid,
          ),
          builder: (_, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                height: 0.13392857 * _height,
                width: 0.90338 * _width,
                child: const Loading(),
              );
            } else {
              return Scaffold(
                backgroundColor: kBackgroundColor,
                bottomNavigationBar: StatefulBuilder(
                  builder: (context, setState) => ButtomAction(
                    buttonType: ButtonType.big,
                    disable: false,
                    onTap: () async {
                      // activeStudents.isEmpty ? print('why ') : print('oh on ');
                      // print(activeStudents);
                      if (activeStudents.isNotEmpty) {
                        for (var element in activeStudents) {
                          List newAttHistory = snapshot.data!
                              .firstWhere((x) => x.id == element)
                              .attHistory;
                          if (!newAttHistory.contains(date)) {
                            newAttHistory.add(date);
                            // ignore: avoid_print
                            print(newAttHistory);
                            int newMonthAtt = snapshot.data!
                                .firstWhere((x) => x.id == element)
                                .currentMonthAtt;
                            newMonthAtt++;
                            // ignore: avoid_print
                            print(newMonthAtt);
                            await StudentsDataBaseServices().addNewSession(
                              attHistory: newAttHistory,
                              context: context,
                              currentMonthAtt: newMonthAtt,
                              uid: element,
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            // ignore: avoid_print
                            print('already added');
                          }
                        }
                      } else {
                        // ignore: avoid_print
                        print('empty');
                      }
                    },
                    title: "تأكيد",
                  ),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SmallAppBar(
                          title: 'حضور المجموعة',
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: _width * 0.06,
                              vertical: _width * 0.045),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'كشف حضور يوم ${daysNames[DateTime.fromMicrosecondsSinceEpoch(date.microsecondsSinceEpoch).weekday - 1]}',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(color: kHintColor, fontSize: 16),
                              ),
                              SizedBox(
                                height: _height * 0.02,
                              ),
                              StatefulBuilder(
                                builder: (context, setState) =>
                                    ListView.separated(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, i) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                activeStudents.contains(
                                                        snapshot.data![i].id)
                                                    ? activeStudents.remove(
                                                        snapshot.data![i].id)
                                                    : activeStudents.add(
                                                        snapshot.data![i].id);
                                              });
                                            },
                                            child: Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    activeStudents.contains(
                                                            snapshot
                                                                .data![i].id)
                                                        ? Icons.check_box
                                                        : Icons
                                                            .check_box_outline_blank,
                                                    color: kAccentColor2,
                                                    size: 25,
                                                  ),
                                                  SizedBox(
                                                    width: _width * 0.03,
                                                  ),
                                                  Text(
                                                    snapshot.data![i].name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline1
                                                        ?.copyWith(
                                                            fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (context, i) =>
                                            Container(
                                              height: _height * 0.02,
                                            ),
                                        itemCount: snapshot.data!.length),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}
