import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';

class CustomScaffold extends StatelessWidget {
  final AppColors _appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Vitality Hygiene Products",
          style: TextStyle(
            color: _appColors.getFontColor(),
          ),
        ),
      ),
    );
  }
}
