import 'package:flutter/material.dart';
import 'package:futureacademy/Shared/buttom_action.dart';
import 'package:futureacademy/Shared/small_appbar.dart';
import 'package:futureacademy/Signin/custom_text_field.dart';
import 'package:futureacademy/services/auth_services.dart';
import 'package:futureacademy/services/groups_services.dart';

import '../const.dart';

// ignore: must_be_immutable
class AddNewStudent extends StatelessWidget {
  AddNewStudent(
      {required this.groupid, required this.studentsgroupId, Key? key})
      : super(key: key);
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final String groupid;
  final List studentsgroupId;

  late String _studentName = '';
  late int _studentAge = 0;
  late String _studentNumber = "";
  late String _studentAddress = "";
  late String _studentEmail = "";
  late String _studentPassword = "";

  bool checkIfSame() {
    return (_studentName == '' ||
        _studentAge == 0 ||
        _studentNumber == '' ||
        _studentEmail == '' ||
        _studentPassword == '' ||
        _studentAddress == '' ||
        groupid == '');
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: ButtomAction(
        buttonType: ButtonType.big,
        disable: checkIfSame(),
        onTap: () async {
          String id = await AuthService().signUp(
            emailSignIn: _studentEmail,
            passwordSignIn: _studentPassword,
            studentName: _studentName,
            studentAge: _studentAge,
            studentNumber: _studentNumber,
            studentGroupId: groupid,
            studentAddress: _studentAddress,
            context: context,
          );
          studentsgroupId.add(id);
          await GroupsDataBaseServices().addNewStudent(
            studentsID: studentsgroupId,
            id: groupid,
            context: context,
          );
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إضافة مستخدم جديد'),
            ),
          );
        },
        title: "حفظ",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SmallAppBar(
                title: "إضافة طالب جديد",
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
                          hintText: "محمد احمد",
                          onClick: (value) {
                            _studentName = value!;
                          },
                        ),
                        SizedBox(
                          height: _height * 0.01,
                        ),
                        CustomTextField(
                          lableText: 'السن',
                          hintText: "13",
                          textInputType: TextInputType.number,
                          onClick: (value) {
                            _studentAge = int.parse(value!);
                          },
                        ),
                        SizedBox(
                          height: _height * 0.01,
                        ),
                        CustomTextField(
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
                          lableText: 'العنوان',
                          hintText: "ش محرم بك - الأسكندرية",
                          onClick: (value) {
                            _studentAddress = value!;
                          },
                        ),
                        SizedBox(
                          height: _height * 0.04,
                        ),
                        Text(
                          'بيانات المرور',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(color: kHintColor, fontSize: 16),
                        ),
                        SizedBox(
                          height: _height * 0.01,
                        ),
                        CustomTextField(
                          lableText: 'الإيميل',
                          hintText: "futureacademy@gmail.com",
                          onClick: (value) {
                            _studentEmail = value!;
                          },
                        ),
                        CustomTextField(
                          lableText: 'كلمة السر',
                          hintText: "Ss@21062020",
                          onClick: (value) {
                            _studentPassword = value!;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
