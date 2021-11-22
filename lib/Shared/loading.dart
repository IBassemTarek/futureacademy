import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../const.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      color: kBackgroundColor,
      child: const Center(
        child: SpinKitChasingDots(
          color: kGradColor2,
          size: 50,
        ),
      ),
    );
  }
}
