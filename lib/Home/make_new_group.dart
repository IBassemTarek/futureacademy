import 'package:flutter/material.dart';
import 'package:futureacademy/Shared/buttom_action.dart';
import 'package:futureacademy/services/groups_services.dart';

import '../const.dart';

void makeNewGroup(BuildContext context) {
  final _height = MediaQuery.of(context).size.height;
  final _width = MediaQuery.of(context).size.width;
  late String groupName = '';
  String _selectedSport = 'سباحة';
  showModalBottomSheet<void>(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
    backgroundColor: kBackgroundColor,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: _height * 0.45,
              padding: EdgeInsets.only(
                top: _height * 0.04,
                right: _width * 0.04,
                left: _width * 0.04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "إضافة مجموعة جديدة",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: 'مجموعة أ',
                        labelText: 'إسم المجموعة',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(color: kHintColor, fontSize: 14),
                        labelStyle:
                            Theme.of(context).textTheme.bodyText2?.copyWith(
                                  color: kHintColor,
                                )),
                    onChanged: (v) {
                      groupName = v;
                    },
                  ),
                  SizedBox(
                    height: _height * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'إختر الرياضة :',
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              color: kHintColor,
                            ),
                      ),
                      StatefulBuilder(builder: (context, setState) {
                        return DropdownButton<String>(
                          hint: const Text('إختر الرياضة'),
                          value: _selectedSport,
                          items: departmentName.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedSport = newValue!;
                            });
                          },
                        );
                      }),
                    ],
                  ),
                  const Spacer(),
                  ButtomAction(
                    buttonType: ButtonType.small,
                    disable: groupName == '',
                    onTap: () async {
                      await GroupsDataBaseServices().addNewgroupsData(
                          department: departmentName.indexOf(_selectedSport),
                          groupName: groupName,
                          studentsID: []);
                      Navigator.pop(context);
                    },
                    title: 'تأكيد',
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
