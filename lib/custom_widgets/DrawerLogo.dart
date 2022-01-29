import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';

class DrawerLogo extends StatelessWidget {
  final AppColors _appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              'lib/assets/images/vhp_loggo.png',
              fit: BoxFit.contain,
              scale: 5,
            ),
          ),

          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              appTitle,
              style: TextStyle(
                color: _appColors.getFontColor(),
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
