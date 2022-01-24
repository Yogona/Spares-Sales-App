import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/services/AuthService.dart';

class Futures{
  final AuthService _authService = AuthService();

  BuildContext context;

  Futures({this.context});

    Future<bool> onBackPressed(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "CLOSE APP",
        ),

        content: Text(
          "You will be signed out when this app closes, continue?",
        ),

        actions: [
          TextButton(
            child: Text(
                "No"
            ),

            onPressed: (){
              Navigator.of(context).pop(false);
            },
          ),

          TextButton(
            child: Text(
                "Yes"
            ),

            onPressed: (){
              _authService.signOut();
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    )??

        false;
  }
}