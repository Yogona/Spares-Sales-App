import 'package:flutter/material.dart';

import 'DrawerLogo.dart';

class CustomDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Stack(
        children: <Widget>[
          Container(
            width: 900,
            color: Colors.white,
          ),

          Center(
            child: DrawerLogo(),
          ),
        ],
      ),
    );
  }
}
