import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/functions/mod/purchases/ModViewPurchases.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';

class GetUsers extends StatelessWidget {
  final AppColors _appColors = AppColors();
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<QuerySnapshot>(context);

    if(users != null){
      return StreamProvider<QuerySnapshot>.value(
        initialData: null,
        value: DatabaseService().purchases,
        child: ModViewPurchases(users),
      );
    }
    return Container(
      color: _appColors.getScaffoldBgColor(),
    );
  }
}
