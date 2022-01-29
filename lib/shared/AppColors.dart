import 'package:flutter/material.dart';

class AppColors{
  final Color _fontColor        = Colors.black;//Color.fromARGB(255, 143, 61, 193);
  final Color _backgroundColor  = Colors.blueGrey;//Color.fromARGB(255, 255, 194, 248);
  final Color _scaffoldBgColor  = Colors.white;//Colors.grey;
  final Color _primaryForeColor     = Colors.white;
  final Color _boxesColor       = Colors.white;

  //Tabs colors
  final Color _selectedTabColor     = Colors.white;
  final Color _unselectedLabelColor = Colors.black;//Color.fromARGB(255, 143, 61, 193);

  //Text field colors
  final Color _txtFieldFillColor    = Colors.white;
  final Color _txtFieldBorderColor  = Colors.black;

  //List tile colors
  Color _tileTitleColor = Colors.blueGrey;
  Color _tileSubtitleColor = Colors.black;

  String _scanningColor = "#FF0000";

  //Primary Colors
  Color getPrimaryForeColor(){return _primaryForeColor;}

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