import 'package:flutter/material.dart';

import '../const.dart';

class BigAppBar extends StatelessWidget {
  const BigAppBar({Key? key, required this.userName}) : super(key: key);
  final String userName;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: _width,
      height: _height / 4,
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
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.only(
                      right: _height * 0.04,
                      bottom: _height * 0.02,
                    ),
                    alignment: Alignment.centerRight,
                    color: kAccentColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "أهلا بك يا",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        SizedBox(
                          height: _height * 0.02,
                        ),
                        Text(
                          // ignore: unnecessary_brace_in_string_interps
                          "${userName}    ",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
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
