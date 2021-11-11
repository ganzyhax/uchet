import 'package:flutter/material.dart';

class AppNavigator {

  static pushToPage(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}