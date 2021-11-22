import 'package:flutter/material.dart';
import 'package:futureacademy/GroupPage/grouppage.dart';
import 'package:futureacademy/Models/group_model.dart';
import 'package:futureacademy/Shared/big_appbar.dart';
import 'package:futureacademy/Shared/buttom_action.dart';
import 'package:futureacademy/Shared/group_card.dart';
import 'package:futureacademy/Shared/loading.dart';
import 'package:futureacademy/services/groups_services.dart';
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
    if (_groups.isEmpty) {
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
        body: FutureBuilder(
          future: GroupsDataBaseServices().checkIfEmpty(),
          builder: (_, __) => Scaffold(
            backgroundColor: kBackgroundColor,
            bottomNavigationBar: ButtomAction(
              buttonType: ButtonType.big,
              disable: false,
              onTap: () {
                makeNewGroup(context);
              },
              title: "إضافة مجموعة",
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const BigAppBar(
                      userName: 'مدير',
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
        ),
      );
    }
  }
}
