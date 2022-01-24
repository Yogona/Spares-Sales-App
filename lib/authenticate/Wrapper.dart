import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/authenticate/CheckUserRoleID.dart';
import 'package:vitality_hygiene_products/models/LoggedInUser.dart';
import 'package:vitality_hygiene_products/models/UserModel.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/authenticate/LoginPage.dart';

class Wrapper extends StatelessWidget {
  final String version;

  Wrapper({this.version});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    if(user == null){
      return LoginPage();
    }

    LoggedInUser.setUID(user.uid);
    LoggedInUser.setEmail(user.email);
    LoggedInUser.setPhone(user.phoneNumber);

    return StreamProvider<QuerySnapshot>.value(
      initialData: null,
      value: DatabaseService().getUsers,
      child: CheckUserRoleID(version: version, user: user),
    );
  }
}