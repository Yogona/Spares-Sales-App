import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/TaskSelection.dart';

import '../CustomDrawerHeader.dart';

class ModDrawer extends StatelessWidget {
  final AppColors _appColors = AppColors();

  //Home to other scenarios
  final Function toggleHomeToStore;
  final Function toggleHomeToPurchases;
  final Function toggleHomeToSales;

  //Store to other scenarios
  final Function toggleStoreToHome;
  final Function toggleStoreToPurchases;
  final Function toggleStoreToSales;

  //Purchases to other scenarios
  final Function togglePurchasesToHome;
  final Function togglePurchasesToStore;
  final Function togglePurchasesToSales;

  //Sales to other scenarios
  final Function toggleSalesToHome;
  final Function toggleSalesToStore;
  final Function toggleSalesToPurchases;

  ModDrawer({
    //Home to other scenarios
    this.toggleHomeToStore,
    this.toggleHomeToPurchases,
    this.toggleHomeToSales,

    //Store to other scenarios
    this.toggleStoreToHome,
    this.toggleStoreToPurchases,
    this.toggleStoreToSales,

    //Purchases to other scenarios
    this.togglePurchasesToHome,
    this.togglePurchasesToStore,
    this.togglePurchasesToSales,

    //Sales to other scenarios
    this.toggleSalesToHome,
    this.toggleSalesToStore,
    this.toggleSalesToPurchases,

  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          CustomDrawerHeader(),

          ListTile(
            selectedTileColor: _appColors.getBackgroundColor(),
            selected: TaskSelection.selection['home'],
            leading: Icon(
              Icons.home,
              color: (TaskSelection.selection['home'])?_appColors.getPrimaryForeColor():_appColors.getFontColor(),
            ),
            title: Text(
              "Home",
              style: TextStyle(
                  color: (TaskSelection.selection['home'])?_appColors.getPrimaryForeColor():_appColors.getFontColor()
              ),
            ),
            onTap: (){
              if (!TaskSelection.selection['home']) {
                if(TaskSelection.selection['store']){
                  toggleStoreToHome();
                } else if(TaskSelection.selection['purchases']){
                  togglePurchasesToHome();
                } else if(TaskSelection.selection['sales']){
                  toggleSalesToHome();
                }
              }
            },
          ),

          ListTile(
            selected: TaskSelection.selection['store'],
            selectedTileColor: _appColors.getBackgroundColor(),
            leading: Icon(
                Icons.store,
                color: (TaskSelection.selection['store'])?_appColors.getPrimaryForeColor():_appColors.getFontColor()
            ),
            title: Text(
              "Store",
              style: TextStyle(
                  color: (TaskSelection.selection['store'])?_appColors.getPrimaryForeColor():_appColors.getFontColor()
              ),
            ),
            onTap: (){
              if (!TaskSelection.selection['store']) {
                if(TaskSelection.selection['home']){
                  toggleHomeToStore();
                } else if(TaskSelection.selection['purchases']){
                  togglePurchasesToStore();
                } else if(TaskSelection.selection['sales']){
                  toggleSalesToStore();
                }
              }
            },
          ),

          ListTile(
            selected: TaskSelection.selection['purchases'],
            selectedTileColor: _appColors.getBackgroundColor(),
            leading: Icon(
                Icons.monetization_on,
                color: (TaskSelection.selection['purchases'])?_appColors.getPrimaryForeColor():_appColors.getFontColor()
            ),
            title: Text(
              "Purchases",
              style: TextStyle(
                  color: (TaskSelection.selection['purchases'])?_appColors.getPrimaryForeColor():_appColors.getFontColor()
              ),
            ),
            onTap: (){
              if (!TaskSelection.selection['purchases']) {
                if(TaskSelection.selection['home']){
                  toggleHomeToPurchases();
                } else if(TaskSelection.selection['store']){
                  toggleStoreToPurchases();
                } else if(TaskSelection.selection['sales']){
                  toggleSalesToPurchases();
                }
              }
            },
          ),

          ListTile(
            selected: TaskSelection.selection['sales'],
            selectedTileColor: _appColors.getBackgroundColor(),
            leading: Icon(
              Icons.monetization_on,
              color: (TaskSelection.selection['sales'])?_appColors.getPrimaryForeColor():_appColors.getFontColor(),
            ),
            title: Text(
              "Sales",
              style: TextStyle(
                  color: (TaskSelection.selection['sales'])?_appColors.getPrimaryForeColor():_appColors.getFontColor()
              ),
            ),
            onTap: (){
              if(!TaskSelection.selection['sales']){
                if(TaskSelection.selection['home']){
                  toggleHomeToSales();
                } else if(TaskSelection.selection['store']){
                  toggleStoreToSales();
                } else if(TaskSelection.selection['purchases']){
                  togglePurchasesToSales();
                }
              }
            },
          ),

        ],
      ),
    );
  }
}
