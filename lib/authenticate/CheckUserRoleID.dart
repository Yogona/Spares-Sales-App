import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/models/UserModel.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';
import 'CheckRole.dart';

class CheckUserRoleID extends StatefulWidget {
  final UserModel user;
  final AppColors _appColors = AppColors();
  final String version;

  CheckUserRoleID({this.version, this.user});

  @override
  _CheckUserRoleState createState() => _CheckUserRoleState();
}

class _CheckUserRoleState extends State<CheckUserRoleID> {
  String _userRoleID;

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<QuerySnapshot>(context);

    if (users == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: widget._appColors.getBackgroundColor(),
          title: Text(
              appTitle,
            style: TextStyle(
              color: widget._appColors.getPrimaryForeColor(),
            ),
          ),
        ),

        body: LoadingWidget("Checking user role..."),
      );
    }

    for (var doc in users.docs) {
      if (doc.id == widget.user.uid) {
        setState(() {
          _userRoleID = doc.get("roleID");
        });
        break;
      }
    }

    return StreamProvider<QuerySnapshot>.value(
        initialData: null,
        value: DatabaseService().roles,
        child: CheckRole(version: widget.version, user: widget.user, userRoleID: _userRoleID),
    );
  }
}