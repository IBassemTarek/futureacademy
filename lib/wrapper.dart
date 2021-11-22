import 'package:flutter/material.dart';
import 'package:futureacademy/Home/homepage.dart';
import 'package:futureacademy/Signin/signin.dart';
import 'package:futureacademy/services/groups_services.dart';
import 'package:futureacademy/services/students_services.dart';
import 'package:provider/provider.dart';

import 'Models/group_model.dart';
import 'Models/student_model.dart';
import 'Models/user.dart';
import 'const.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    return Builder(
      builder: (__) {
        if (user.id == "null") {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Future Academy',
            theme: textData(),
            home: SignIn(),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Future Academy',
            theme: textData(),
            home: MultiProvider(
              providers: [
                StreamProvider<List<GroupsModel>>.value(
                  value: GroupsDataBaseServices().groupsCardsData,
                  initialData: const [],
                ),
              ],
              child: const HomePage(),
            ),
          );
        }
      },
    );
  }
}
