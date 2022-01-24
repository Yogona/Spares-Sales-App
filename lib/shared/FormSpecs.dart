import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';

class FormSpecs{

  static final AppColors _appColors  = AppColors();
  static const double textFieldWidth      = 180.0;
  static double textFieldHeight           = 0.0;
  static double fontSize                  = 18.0;

  static double formHeaderSize            = 24.0;
  static double formMargin                = 20.0;
  static const sizedBoxWidth              = 5.0;
  static const sizedBoxHeight             = 10.0;
  static const _borderWidth               = 1.0;
  static const containerHeight            = 390.0;

  //Text field configurations
  static const txtFieldBorderRadius       = 50.0;
  static const txtFieldVerticalPadding    = 0.0;
  static const txtFieldHorizontalPadding  = 20.0;

  //Button styles
  static final btnStyle  =  ButtonStyle(
    elevation: MaterialStateProperty.all(
        4.0
    ),

    enableFeedback: true,

    shadowColor: MaterialStateProperty.all(
      _appColors.getFontColor(),
    ),

    backgroundColor: MaterialStateProperty.all(
      _appColors.getFontColor(),
    ),

    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            FormSpecs.txtFieldBorderRadius,
          ),
        )
    ),
  );

  static const textInputDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(
      vertical: FormSpecs.txtFieldVerticalPadding,
      horizontal: FormSpecs.txtFieldHorizontalPadding,
    ),

    fillColor:Colors.white,

    filled: true,

    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
        Radius.circular(
          FormSpecs.txtFieldBorderRadius
        )
      ),

        borderSide: BorderSide(
          color: Color.fromARGB(255, 143, 61, 193),
          width: _borderWidth,
        )
    ),

    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            FormSpecs.txtFieldBorderRadius
          )
        ),

        borderSide: BorderSide(
          color: Color.fromARGB(255, 143, 61, 193),
          width: _borderWidth,
        )
    ),

    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(
                FormSpecs.txtFieldBorderRadius
            )
        ),

        borderSide: BorderSide(
          color: Colors.red,
          width: _borderWidth,
        )
    ),

    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            FormSpecs.txtFieldBorderRadius
          )
        ),

        borderSide: BorderSide(
          color: Colors.red,
          width: _borderWidth,
        )
    ),
  );

}