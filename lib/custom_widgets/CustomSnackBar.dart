import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomSnackBar {
  String message;
  CustomSnackBar({this.message,});

  SnackBar getSnackBar(BuildContext context) {
    return SnackBar(
      dismissDirection: DismissDirection.horizontal,
      action: SnackBarAction(
        label: "DISMISS",
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      content: Text(message),
      duration: Duration(
        seconds: 3,
      ),
    );
  }
}
