import 'package:flutter/material.dart';
import 'package:futureacademy/FeedbackPage/feedback_page.dart';
import 'package:futureacademy/GroupPage/grouppage.dart';
import 'package:futureacademy/Models/feedback_model.dart';
import 'package:futureacademy/Models/group_model.dart';
import 'package:futureacademy/Models/student_model.dart';
import 'package:futureacademy/Shared/big_appbar.dart';
import 'package:futureacademy/Shared/buttom_double_action.dart';
import 'package:futureacademy/Shared/group_card.dart';
import 'package:futureacademy/services/auth_services.dart';
import 'package:futureacademy/services/feedback_services.dart';
import 'package:futureacademy/services/groups_services.dart';
import 'package:futureacademy/services/students_services.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import 'make_new_group.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final _groups = Provider.of<List<GroupsModel>>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiProvider(providers: [
                StreamProvider<List<FeedbackModel>>.value(
                  value: FeedbackDataBaseServices().feedbacksCardsData,
                  initialData: const [],
                ),
                StreamProvider<List<StudentsModel>>.value(
                  value: StudentsDataBaseServices().studentsCardsData,
                  initialData: const [],
                ),
              ], child: const FeedbackPage()),
            ),
          );
        },
        child: const Icon(Icons.feedback),
        backgroundColor: kAccentColor2,
      ),
      body: FutureBuilder(
        future: GroupsDataBaseServices().checkIfEmpty(),
        builder: (_, __) => Scaffold(
          backgroundColor: kBackgroundColor,
          bottomNavigationBar: ButtomDoubleAction(
            onTap2: () {
              AuthService().signOut();
            },
            title: "إضافة مجموعة",
            disable: false,
            onTap: () {
              makeNewGroup(context);
            },
            title2: "خروج",
          ),
          body: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const BigAppBar(
                  userName: 'كابتن السقا',
                ),
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: _width * 0.045, vertical: _width * 0.045),
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupPage(
                                group: _groups[i],
                              ),
                            ),
                          );
                        },
                        child: GroupCard(
                          group: _groups[i],
                        ),
                      );
                    },
                    separatorBuilder: (context, i) => Container(
                          height: _height * 0.02,
                        ),
                    itemCount: _groups.length),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
