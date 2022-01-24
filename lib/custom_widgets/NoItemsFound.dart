import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';

class NoItemsFound extends StatelessWidget {
  final AppColors _appColors = AppColors();
  final String message;

  NoItemsFound(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _appColors.getScaffoldBgColor(),
      child: Center(
        child: Text(
          this.message,
          style: TextStyle(
            color: _appColors.getFontColor(),
            fontSize: FormSpecs.formHeaderSize,
          ),
        ),
      ),
    );
  }
}
