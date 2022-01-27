import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/functions/settings/Password.dart';
import 'package:vitality_hygiene_products/services/AuthService.dart';
import 'package:vitality_hygiene_products/shared/TaskSelection.dart';
class Options extends StatefulWidget{
  final Function togglePassword;

  Options({this.togglePassword});
  @override
  _OptionsState createState() => _OptionsState();
}
class _OptionsState extends State<Options> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
          Icons.arrow_circle_down
      ),

      itemBuilder: (BuildContext ctx) => [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.password,
              ),
              Text(
                "Password",
              ),
            ],
          ),

          onTap: (){
            widget.togglePassword();
          },
        ),

        PopupMenuItem(
          child: Row(
            children: [
              Icon(
                Icons.logout,
              ),
              Text(
                "Logout",
              )
            ],
          ),
          onTap: () async {
            await _authService.signOut();
          },
        ),
      ],
    );
  }
}