import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:futureacademy/Models/group_model.dart';
import 'package:futureacademy/Models/student_model.dart';
import 'package:futureacademy/NotesList/notes_list.dart';
import 'package:futureacademy/Shared/buttom_action.dart';
import 'package:futureacademy/Shared/loading.dart';
import 'package:futureacademy/Shared/small_appbar.dart';
import 'package:futureacademy/Signin/custom_text_field.dart';
import 'package:futureacademy/services/groups_services.dart';
import 'package:futureacademy/services/students_services.dart';
import 'package:provider/provider.dart';

import '../const.dart';

// ignore: must_be_immutable
class EditStudentPage extends StatelessWidget {
  EditStudentPage({
    required this.groupid,
    Key? key,
    required this.studentData,
  }) : super(key: key);

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final String groupid;
  final StudentsModel studentData;

  // ignore: prefer_final_fields
  late List _studentNotes = studentData.notes;
  late String _studentName = studentData.name;
  late String _studentLocation = studentData.address;
  late String _studentAddNotes = '';
  late int _studentAmount = 0;
  late String _studentNumber = studentData.mobileNumber;
  late String _studentAge = studentData.age.toString();
  late String _studentGroup = studentData.group;
  late String _studentGroupName = '';
  late String _studentOldGroupId = '';
  late List<String> _groupsId = [];
  late List<String> _groupsNames = [];

  late String _selectedGrade = evaluationGrade[studentData.evaluation];

  bool checkIfSame() {
    return (_studentName == '' ||
        _studentLocation == '' ||
        _studentNumber == '' ||
        _studentAge == '');
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final _groups = Provider.of<List<GroupsModel>>(context);
    final _allGroups = Provider.of<List<GroupsModel>>(context);

    return FutureBuilder(
        future: GroupsDataBaseServices().checkIfEmpty(),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done &&
              snapshot.data == true) {
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
            if (_groups.length != groupid.length) {
              for (var groups in _groups) {
                if (!_groupsId.contains(groups.id)) {
                  _groupsId.add(groups.id);
                }
              }
              for (var groups in _groups) {
                if (!_groupsNames.contains(groups.groupName)) {
                  _groupsNames.add(groups.groupName);
                }
              }
            }
            _studentOldGroupId = studentData.group;
            _studentGroupName = _allGroups
                .firstWhere((element) => element.id == _studentGroup)
                .groupName;
            return Scaffold(
              backgroundColor: kBackgroundColor,
              bottomNavigationBar: ButtomAction(
                buttonType: ButtonType.big,
                disable: checkIfSame(),
                onTap: () async {
                  await StudentsDataBaseServices().updateStudentInfo(
                    uid: studentData.id,
                    context: context,
                    address: _studentLocation,
                    age: int.parse(_studentAge),
                    evaluation: evaluationGrade.indexOf(_selectedGrade),
                    mobileNumber: _studentNumber,
                    name: _studentName,
                    group: _studentGroup,
                  );

                  GroupsModel newGroup = _allGroups
                      .firstWhere((element) => element.id == _studentGroup);

                  GroupsModel oldGroup = _allGroups.firstWhere(
                      (element) => element.id == _studentOldGroupId);
                  if (_studentOldGroupId != _studentGroup &&
                      oldGroup.studentsID.contains(studentData.id)) {
                    //remove
                    oldGroup.studentsID.remove(studentData.id);
                    await GroupsDataBaseServices().addNewStudent(
                      context: context,
                      id: _studentOldGroupId,
                      studentsID: oldGroup.studentsID,
                    );
                    print('removed');

                    //add
                    newGroup.studentsID.add(studentData.id);
                    await GroupsDataBaseServices().addNewStudent(
                      context: context,
                      id: _studentGroup,
                      studentsID: newGroup.studentsID,
                    );
                    print('added');
                  } else {
                    print('no operation');
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                title: "تأكيد",
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SmallAppBar(
                      title: studentData.name,
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
                                lableText: 'إسم الطالب',
                                hintText: "محمد أحمد",
                                initialValue: studentData.name,
                                onClick: (value) {
                                  _studentName = value!;
                                },
                              ),
                              SizedBox(
                                height: _height * 0.01,
                              ),
                              CustomTextField(
                                initialValue: studentData.mobileNumber,
                                lableText: 'رقم الهاتف',
                                hintText: "01xxxxxxxxx",
                                textInputType: TextInputType.phone,
                                onClick: (value) {
                                  _studentNumber = value!;
                                },
                              ),
                              SizedBox(
                                height: _height * 0.01,
                              ),
                              CustomTextField(
                                initialValue: studentData.age.toString(),
                                lableText: 'السن',
                                hintText: "21",
                                textInputType: TextInputType.number,
                                onClick: (value) {
                                  _studentAge = value!;
                                },
                              ),
                              SizedBox(
                                height: _height * 0.01,
                              ),
                              CustomTextField(
                                lableText: 'العنوان',
                                hintText: "ش محرم بك - الأسكندرية",
                                initialValue: studentData.address,
                                onClick: (value) {
                                  _studentLocation = value!;
                                },
                              ),
                              SizedBox(
                                height: _height * 0.01,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'التقييم :',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontSize: 14),
                                  ),
                                  StatefulBuilder(builder: (context, setState) {
                                    return DropdownButton<String>(
                                      hint: const Text('إختر التقييم'),
                                      value: _selectedGrade,
                                      items:
                                          evaluationGrade.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedGrade = newValue!;
                                        });
                                      },
                                    );
                                  }),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'المجموعة',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontSize: 14),
                                  ),
                                  StatefulBuilder(
                                    builder: (context, setState) {
                                      return DropdownButton<String>(
                                        hint: const Text('إختر مجموعة'),
                                        value: _studentGroupName,
                                        items: _groupsNames.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            _studentGroupName = newValue!;
                                            _studentGroup = _allGroups
                                                .firstWhere((element) =>
                                                    element.groupName ==
                                                    newValue)
                                                .id;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _height * 0.03,
                              ),
                              Text(
                                'الملاحظات ',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(color: kHintColor, fontSize: 16),
                              ),
                              SizedBox(
                                height: _height * 0.01,
                              ),
                              CustomTextField(
                                multiline: true,
                                lableText: 'إضافة ملاحظة',
                                hintText: "أضف ملاخظتك",
                                textInputType: TextInputType.text,
                                onClick: (value) {
                                  _studentAddNotes = value!;
                                },
                              ),
                              SizedBox(
                                height: _height * 0.03,
                              ),
                              InkWell(
                                onTap: () {
                                  if (_studentAddNotes != '') {
                                    _studentNotes.add(_studentAddNotes);
                                    StudentsDataBaseServices().addStudentNote(
                                      uid: studentData.id,
                                      notes: _studentNotes,
                                      context: context,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("برجاء كتابة ملاحظتك"),
                                    ));
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  padding: EdgeInsets.symmetric(
                                    vertical: _width * 0.03,
                                    horizontal: _width * 0.03,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Text(
                                    "إضافة ملاحظة جديد",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(color: kBackgroundColor),
                                  ),
                                ),
                              ),
                              _studentNotes.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: _height * 0.03,
                                        ),
                                        Text(
                                          'الملاحظات السابقة',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              ?.copyWith(
                                                  color: kHintColor,
                                                  fontSize: 16),
                                        ),
                                        SizedBox(
                                          height: _height * 0.03,
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              vertical: _height * 0.03),
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: kShadowColor,
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                              color: kBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: _studentNotes
                                                .take(4)
                                                .map(
                                                  (e) => Container(
                                                    padding: EdgeInsets.only(
                                                        right: _width * 0.03),
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        bottom: _width * 0.01,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.circle,
                                                            size: 12,
                                                            color: kGradColor2,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                _width * 0.02,
                                                          ),
                                                          Text(
                                                            e,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .subtitle1
                                                                ?.copyWith(
                                                                    color:
                                                                        kHintColor,
                                                                    fontSize:
                                                                        16),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                        SizedBox(
                                          height: _height * 0.03,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => NotesList(
                                                  notes: studentData.notes,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.topCenter,
                                            padding: EdgeInsets.symmetric(
                                              vertical: _width * 0.03,
                                              horizontal: _width * 0.03,
                                            ),
                                            decoration: const BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            ),
                                            child: Text(
                                              "مشاهدة الكل",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  ?.copyWith(
                                                      color: kBackgroundColor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(
                                      height: 0,
                                      width: 0,
                                    ),
                              SizedBox(
                                height: _height * 0.03,
                              ),
                              Text(
                                'المدفوعات ',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(color: kHintColor, fontSize: 16),
                              ),
                              SizedBox(
                                height: _height * 0.01,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: _width * 0.6,
                                    child: CustomTextField(
                                      lableText: 'إضافة المبلغ',
                                      hintText: "أضف المبلغ",
                                      textInputType: TextInputType.number,
                                      onClick: (value) {
                                        _studentAmount = int.parse(value!);
                                      },
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (_studentAmount != 0) {
                                        Timestamp myTimeStamp =
                                            Timestamp.fromDate(DateTime.now());
                                        StudentsDataBaseServices()
                                            .addStudentPayment(
                                          uid: studentData.id,
                                          cost: _studentAmount,
                                          date: myTimeStamp,
                                          context: context,
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text("برجاء كتابة المبلغ"),
                                        ));
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                      padding: EdgeInsets.symmetric(
                                        vertical: _width * 0.03,
                                        horizontal: _width * 0.03,
                                      ),
                                      margin: const EdgeInsets.only(right: 20),
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Text(
                                        "إضافة",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            ?.copyWith(color: kBackgroundColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _height * 0.03,
                              ),
                              FutureBuilder<List<StudentsPayment>>(
                                  future: StudentsDataBaseServices()
                                      .getStudentPayment(
                                          uid: studentData.id,
                                          context: context),
                                  builder: (_, snapshot) {
                                    if (snapshot.connectionState !=
                                        ConnectionState.done) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Colors.white,
                                        ),
                                        height: 0.13392857 * _height,
                                        width: 0.90338 * _width,
                                        child: const Loading(),
                                      );
                                    } else {
                                      return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'المدفوعات السابقة',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  ?.copyWith(
                                                      color: kHintColor,
                                                      fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: _height * 0.03,
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: _height * 0.03),
                                              decoration: BoxDecoration(
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: kShadowColor,
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: kBackgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: snapshot.data!
                                                    .map(
                                                      (e) => Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: _width *
                                                                    0.03),
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            bottom:
                                                                _width * 0.01,
                                                            left: _width * 0.04,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .circle,
                                                                    size: 12,
                                                                    color:
                                                                        kGradColor2,
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        _width *
                                                                            0.02,
                                                                  ),
                                                                  Text(
                                                                    e.amount
                                                                        .toString(),
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .subtitle1
                                                                        ?.copyWith(
                                                                            color:
                                                                                kHintColor,
                                                                            fontSize:
                                                                                16),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                " ${e.date.toDate().day} / ${e.date.toDate().month} / ${e.date.toDate().year}",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .subtitle1
                                                                    ?.copyWith(
                                                                        color:
                                                                            kHintColor,
                                                                        fontSize:
                                                                            16),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ]);
                                    }
                                  })
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
        });
  }
}
