import 'package:flutter/widgets.dart';

class ModelHub extends ChangeNotifier {
  bool isLoading = false;

  changeIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
