import 'package:flutter/material.dart';
import 'package:futureacademy/AddNewStudent/add_new_student.dart';
import 'package:futureacademy/AttendeesPage/attendees_page.dart';
import 'package:futureacademy/EditStudentPage/edit_student_page.dart';
import 'package:futureacademy/Models/group_model.dart';
import 'package:futureacademy/Models/student_model.dart';
import 'package:futureacademy/Shared/buttom_double_action.dart';
import 'package:futureacademy/Shared/loading.dart';
import 'package:futureacademy/Shared/small_appbar.dart';
import 'package:futureacademy/services/groups_services.dart';
import 'package:futureacademy/services/students_services.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import 'session_picker.dart';

class StudentPage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const StudentPage({required this.group});
  final GroupsModel group;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder<List<StudentsModel>>(
          future: StudentsDataBaseServices().getStudentsGroup(
            groupId: group.id,
          ),
          builder: (_, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container(
                alignment: Alignment.center,
                height: _height,
                width: _width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: const Loading(),
              );
            } else {
              return Scaffold(
                backgroundColor: kBackgroundColor,
                bottomNavigationBar: ButtomDoubleAction(
                  onTap2: () {
                    sessionPicker(
                      context: context,
                      onTap: (time) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendeesPage(
                              date: time,
                              groupid: group.id,
                            ),
                          ),
                        );
                      },
                      dates: group.dates,
                    );
                  },
                  title2: 'تدوين الغياب',
                  disable: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNewStudent(
                          groupid: group.id,
                          studentsgroupId: group.studentsID,
                        ),
                      ),
                    );
                  },
                  title: "إضافة طالب",
                ),
                body: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SmallAppBar(
                        title: 'طلاب المجموعة',
                      ),
                      ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal: _width * 0.045,
                              vertical: _width * 0.045),
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MultiProvider(
                                      providers: [
                                        StreamProvider<List<GroupsModel>>.value(
                                          value: GroupsDataBaseServices()
                                              .groupsCardsData,
                                          initialData: const [],
                                        ),
                                      ],
                                      child: EditStudentPage(
                                        groupid: group.id,
                                        studentData: snapshot.data![i],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: kShadowColor,
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: Offset(
                                            0, 5), // changes position of shadow
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: _width * 0.03,
                                    vertical: _height * 0.03),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.person,
                                            color: kAccentColor2,
                                            size: 25,
                                          ),
                                          SizedBox(
                                            width: _width * 0.03,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data![i].name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline1
                                                    ?.copyWith(fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: _height * 0.01,
                                              ),
                                              Text(
                                                snapshot.data![i].mobileNumber,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    ?.copyWith(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        snapshot.data![i].currentMonthAtt
                                                .toString() +
                                            '/' +
                                            group.dates.length.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                                color: kHintColor,
                                                fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, i) => Container(
                                height: _height * 0.02,
                              ),
                          itemCount: snapshot.data!.length),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
