import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';

class LoadingWidget extends StatelessWidget {
  final AppColors _appColors = AppColors();
  final String _loadingText;
  LoadingWidget(this._loadingText);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _appColors.getScaffoldBgColor(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitCircle(
              color: _appColors.getFontColor(),
              size: 50.0,
            ),
            Text(
              this._loadingText,
              style: TextStyle(
                fontSize: 20,
                color: _appColors.getFontColor()
              ),
            ),
          ],
        ),
      ),
    );
  }
}