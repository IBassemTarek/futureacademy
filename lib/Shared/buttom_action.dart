import 'package:flutter/material.dart';

import '../const.dart';

enum ButtonType { big, small }

class ButtomAction extends StatelessWidget {
  const ButtomAction({
    Key? key,
    required this.title,
    required this.onTap,
    required this.buttonType,
    required this.disable,
  }) : super(key: key);
  final String title;
  final bool disable;
  final ButtonType buttonType;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Container(
      margin: buttonType == ButtonType.small ? const EdgeInsets.all(20) : null,
      child: InkWell(
        onTap: disable ? () {} : onTap,
        child: Container(
          height: 0.065 * _height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: disable ? Colors.grey : kAccentColor2,
            boxShadow: const [
              BoxShadow(
                color: kShadowColor,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: buttonType == ButtonType.big
                ? BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
                : BorderRadius.all(
                    Radius.circular(10),
                  ),
          ),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: disable ? Colors.white : kGradColor2),
          ),
        ),
      ),
    );
  }
}
