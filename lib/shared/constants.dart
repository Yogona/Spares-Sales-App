import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final boxDecoration = BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.black,
        blurRadius: 20.0,
        spreadRadius: 5.0,
      )
    ],

    borderRadius: BorderRadius.all(
        Radius.circular(
            10.0
        )
    ),
  );

/*Button Styles*/
final btnStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
);

//Title box
const double titleBoxPadding = 5.0;

/*General fixed texts*/
const String errorMsg = "Kuna tatizo, tafadhali wasiliana na mtaalamu.";
const String appTitle = "Spares Sales System";

//Decorations
const double borderRadius = 20.0;
const double formMargin   = 20.0;
const double formPadding  = 10.0;
const double subTitlePadding  = 5.0;
const double fullWidth        = 0.85;

/*Sized Box Constraint*/
const sizedHeight         = 10.0;
const sizedWidth          = 10.0;

const headFontSize        = 24.0;
const blurRadius          = 5.0;
const spreadRadius        = 5.0;
const contBorderRadius    = 10.0; //Container border radius

/*Cards Constraints*/
const cardsElevation      = 5.0;
const cardsMargin         = 10.0;
const cardsPadding        = 10.0;
const topBarElevation     = 0.0;

//Colors
const Color errorColor = Colors.red;
const Color headColor = Colors.green;
const Color boxShadowColor = Colors.blueGrey;
const Color textColor = Colors.white;
const Color btnTxtColors = Colors.white;
const Color themeColor = Colors.black;
