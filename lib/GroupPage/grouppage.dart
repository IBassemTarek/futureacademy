import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futureacademy/Models/group_model.dart';
import 'package:futureacademy/Models/student_model.dart';
import 'package:futureacademy/Shared/buttom_action.dart';
import 'package:futureacademy/Shared/buttom_double_action.dart';
import 'package:futureacademy/Shared/small_appbar.dart';
import 'package:futureacademy/Signin/custom_text_field.dart';
import 'package:futureacademy/StudentsPage/studentspage.dart';
import 'package:futureacademy/services/groups_services.dart';
import 'package:futureacademy/services/students_services.dart';
import 'package:provider/provider.dart';

import '../const.dart';
import 'date_picker.dart';
import 'section_time.dart';

// ignore: must_be_immutable
class GroupPage extends StatelessWidget {
  GroupPage({required this.group, Key? key}) : super(key: key);
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final GroupsModel group;

  // ignore: prefer_final_fields
  late List _groupDates = group.dates;
  late String _groupName = group.groupName;
  late String _captainName = group.captainName;
  late String _captainNumber = group.captainNumber;
  late String _selectedSport = departmentName[group.department];

  bool checkIfSame() {
    return (_groupName == '' || _captainName == '' || _captainNumber == '');
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: ButtomDoubleAction(
        onTap2: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentPage(
                group: group,
              ),
            ),
          );
        },
        title2: 'طلاب المجموعة',
        disable: checkIfSame(),
        onTap: () async {
          GroupsDataBaseServices().updategroupInfo(
            dates: _groupDates,
            captainName: _captainName,
            captainNumber: _captainNumber,
            department: departmentName.indexOf(_selectedSport),
            groupName: _groupName,
            id: group.id,
            context: context,
          );
        },
        title: "حفظ",
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SmallAppBar(
              title: group.groupName,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: _width * 0.06, vertical: _width * 0.045),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Form(
                  key: _globalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'المعلموات الأساسية',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(color: kHintColor, fontSize: 16),
                      ),
                      SizedBox(
                        height: _height * 0.02,
                      ),
                      CustomTextField(
                        lableText: 'إسم المجموعة',
                        hintText: "مجموعة أ",
                        initialValue: group.groupName,
                        onClick: (value) {
                          _groupName = value!;
                        },
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'إختر الرياضة :',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 14),
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
                      CustomTextField(
                        lableText: 'إسم الكابتن',
                        hintText: "محمد أحمد",
                        initialValue: group.captainName,
                        onClick: (value) {
                          _captainName = value!;
                        },
                      ),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      CustomTextField(
                        initialValue: group.captainNumber,
                        lableText: 'رقم الكابتن',
                        hintText: "01xxxxxxxxx",
                        textInputType: TextInputType.phone,
                        onClick: (value) {
                          _captainNumber = value!;
                        },
                      ),
                      SizedBox(
                        height: _height * 0.03,
                      ),
                      Text(
                        'مواعيد التدريبات',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            ?.copyWith(color: kHintColor, fontSize: 16),
                      ),
                      SizedBox(
                        height: _height * 0.03,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: _height * 0.03),
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: kShadowColor,
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: kBackgroundColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            return Column(
                              children: [
                                GridView.count(
                                  childAspectRatio: 4.0,
                                  mainAxisSpacing: 4.0,
                                  crossAxisSpacing: 4.0,
                                  padding: const EdgeInsets.all(0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  crossAxisCount: 2,
                                  children: _groupDates
                                      .map(
                                        (e) => Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _groupDates.remove(e);
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                                size: 25,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                datePicker(
                                                  initial: DateTime
                                                      .fromMicrosecondsSinceEpoch(
                                                          e.microsecondsSinceEpoch),
                                                  context: context,
                                                  onTap: (DateTime x) {
                                                    setState(() {
                                                      _groupDates[_groupDates
                                                              .indexOf(e)] =
                                                          Timestamp.fromDate(x);
                                                    });
                                                  },
                                                );
                                              },
                                              child: SetionTime(
                                                e: DateTime
                                                    .fromMicrosecondsSinceEpoch(
                                                        e.microsecondsSinceEpoch),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .toList(),
                                ),
                                InkWell(
                                  onTap: () {
                                    datePicker(
                                      initial: DateTime.now(),
                                      context: context,
                                      onTap: (DateTime x) {
                                        setState(() {
                                          _groupDates
                                              .add(Timestamp.fromDate(x));
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    width: _width / 2.5,
                                    padding: EdgeInsets.symmetric(
                                      vertical: _width * 0.03,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Text(
                                      "إضافة ميعاد جديد",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.copyWith(color: kBackgroundColor),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: _height * 0.03,
                      ),
                      InkWell(
                        onTap: () async {
                          await GroupsDataBaseServices().startNewMonth(
                            groupid: group.id,
                          );
                          await StudentsDataBaseServices()
                              .studentsGroupNewMonth(
                            groupId: group.id,
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('تم إعادة تهيئة المجموعة'),
                          ));
                        },
                        child: Container(
                          alignment: Alignment.topCenter,
                          width: _width / 0.7,
                          padding: EdgeInsets.symmetric(
                            vertical: _width * 0.03,
                          ),
                          decoration: const BoxDecoration(
                            color: kGradColor2,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                            "بداية شهر جديد",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                ?.copyWith(color: kBackgroundColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
