import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../const.dart';

class SmallAppBar extends StatelessWidget {
  const SmallAppBar({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: _width,
      height: _height / 8,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: kAccentColor4,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: kAccentColor3,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: _height * 0.04,
                    ),
                    alignment: Alignment.centerLeft,
                    color: kAccentColor,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            CupertinoIcons.back,
                            size: 25,
                            color: kTextColor,
                          ),
                          SizedBox(
                            width: _width * 0.03,
                          ),
                          Text(
                            title,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: kAccentColor2,
            ),
          ),
        ],
      ),
    );
  }
}
