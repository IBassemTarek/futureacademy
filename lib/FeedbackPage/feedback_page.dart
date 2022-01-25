import 'package:flutter/material.dart';
import 'package:futureacademy/Models/feedback_model.dart';
import 'package:futureacademy/Models/student_model.dart';
import 'package:futureacademy/Shared/loading.dart';
import 'package:futureacademy/Shared/small_appbar.dart';
import 'package:provider/provider.dart';

import '../const.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    final _feedbacks = Provider.of<List<FeedbackModel>>(context);
    final _students = Provider.of<List<StudentsModel>>(context);

    if (_feedbacks.isEmpty) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        height: _height,
        width: _width,
        child: const Loading(),
      );
    } else {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SmallAppBar(
                title: 'آراء أولياء الأمور',
              ),
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: _width * 0.045, vertical: _width * 0.045),
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: kShadowColor,
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 5), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(
                          horizontal: _width * 0.03, vertical: _height * 0.03),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _students
                                          .firstWhere((element) =>
                                              element.id ==
                                              _feedbacks[i].studentID)
                                          .name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          ?.copyWith(fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: _height * 0.01,
                                    ),
                                    SizedBox(
                                      width: _width * 0.7,
                                      child: Text(
                                        _feedbacks[i].msg,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, i) => Container(
                        height: _height * 0.02,
                      ),
                  itemCount: _feedbacks.length),
            ],
          ),
        ),
      );
    }
  }
}
