import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/services/AuthService.dart';

class Options extends StatelessWidget {
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
            print("pwd");
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
