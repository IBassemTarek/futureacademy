import 'package:flutter/material.dart';
import 'package:futureacademy/Models/group_model.dart';

import '../const.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    Key? key,
    required this.group,
  }) : super(key: key);

  final GroupsModel group;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: _height * 0.03),
      decoration: BoxDecoration(boxShadow: const [
        BoxShadow(
          color: kShadowColor,
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ], color: kBackgroundColor, borderRadius: BorderRadius.circular(10)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _height * 0.03,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    departmentIcons[group.department],
                    size: 25,
                    color: kAccentColor2,
                  ),
                  SizedBox(
                    width: _width * 0.03,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.groupName,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      SizedBox(
                        height: _height * 0.015,
                      ),
                      Text(
                        departmentName[group.department],
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "عدد الطلاب : ",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    group.studentsID.length.toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
