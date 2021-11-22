import 'package:flutter/material.dart';

import '../const.dart';

class ButtomDoubleAction extends StatelessWidget {
  const ButtomDoubleAction({
    Key? key,
    required this.title,
    required this.title2,
    required this.onTap,
    required this.onTap2,
    required this.disable,
  }) : super(key: key);
  final String title;
  final String title2;
  final bool disable;
  final void Function()? onTap;
  final void Function()? onTap2;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        InkWell(
          onTap: disable ? () {} : onTap,
          child: Container(
            width: _width / 2 - 1,
            height: 0.065 * _height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: disable ? Colors.grey : kAccentColor2,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  // topRight: Radius.circular(10),
                )),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(color: disable ? Colors.white : kGradColor2),
            ),
          ),
        ),
        SizedBox(
          height: 0.065 * _height,
          width: 2,
        ),
        InkWell(
          onTap: onTap2,
          child: Container(
            height: 0.065 * _height,
            width: _width / 2 - 1,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: kAccentColor2,
                borderRadius: BorderRadius.only(
                  // topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
            child: Text(
              title2,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(color: disable ? Colors.white : kGradColor2),
            ),
          ),
        ),
      ],
    );
  }
}
