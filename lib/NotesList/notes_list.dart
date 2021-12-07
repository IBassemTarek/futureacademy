import 'package:flutter/material.dart';
import 'package:futureacademy/Shared/buttom_action.dart';
import 'package:futureacademy/Shared/small_appbar.dart';

import '../const.dart';

// ignore: must_be_immutable
class NotesList extends StatelessWidget {
  NotesList({
    required this.notes,
    Key? key,
  }) : super(key: key);

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final List notes;
  // ignore: prefer_final_fields

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SmallAppBar(
              title: "الملاحظات",
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: _width * 0.06, vertical: _width * 0.045),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'الملاحظات الحالية',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          ?.copyWith(color: kHintColor, fontSize: 16),
                    ),
                    Column(
                      children: notes
                          .map(
                            (e) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: _width * 0.03,
                                vertical: _width * 0.03,
                              ),
                              alignment: Alignment.centerRight,
                              margin:
                                  EdgeInsets.symmetric(vertical: _width * 0.03),
                              //  alignment: Alignment.center,
                              // padding:
                              //     EdgeInsets.symmetric(vertical: _height * 0.03),
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                      color: kShadowColor,
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                  color: kBackgroundColor,
                                  borderRadius: BorderRadius.circular(10)),

                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.circle,
                                    size: 12,
                                    color: kGradColor2,
                                  ),
                                  SizedBox(
                                    width: _width * 0.02,
                                  ),
                                  Text(
                                    e,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.copyWith(
                                            color: kHintColor, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
