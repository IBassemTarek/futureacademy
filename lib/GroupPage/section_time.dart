import 'package:flutter/material.dart';

import '../const.dart';

class SetionTime extends StatelessWidget {
  const SetionTime({
    Key? key,
    required this.e,
  }) : super(key: key);

  final DateTime e;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    return GridTile(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            daysNames[e.weekday - 1],
            style: Theme.of(context).textTheme.headline1?.copyWith(
                  fontSize: 16,
                  color: kAccentColor2,
                ),
          ),
          SizedBox(
            width: _width * 0.02,
          ),
          Text(
            e.month.toString() + '/' + e.day.toString(),
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: kHintColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
