import 'package:flutter/material.dart';

class AppColors{
  final Color _fontColor = Color.fromARGB(255, 143, 61, 193);
  final Color _backgroundColor = Color.fromARGB(255, 255, 194, 248);
  final Color _scaffoldBgColor = Colors.grey;

  final Color _boxesColor           = Colors.white;

  //Tabs colors
  final Color _selectedTabColor     = Colors.black;
  final Color _unselectedLabelColor = Color.fromARGB(255, 143, 61, 193);

  //Text field colors
  final Color _txtFieldFillColor    = Colors.white;
  final Color _txtFieldBorderColor  = Colors.white;

  //List tile colors
  Color _tileTitleColor = Colors.black;
  Color _tileSubtitleColor = Colors.white;

  String _scanningColor = "#FF0000";

  //Get tab colors
  Color getSelectedTabColor(){return _selectedTabColor;}

  Color getBoxColor(){return _boxesColor;}

  //Get Text field colors
  Color getTxtFieldFillColor(){return _txtFieldFillColor;}
  Color getTxtFieldBorderColor(){return _txtFieldBorderColor;}

  Color getTileSubtitleColor(){return _tileSubtitleColor;}

  Color getTileTitleColor(){return _tileTitleColor;}

  Color getFontColor(){return _fontColor;}

  Color getBackgroundColor(){return _backgroundColor;}

  Color getScaffoldBgColor(){return _scaffoldBgColor;}

  Color getUnselectedLabelColor(){return _unselectedLabelColor;}

  String getScanningColor(){return _scanningColor;}

}