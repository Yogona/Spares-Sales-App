import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/custom_widgets/Options.dart';
import 'package:vitality_hygiene_products/custom_widgets/drawers/AdminDrawer.dart';
import 'package:vitality_hygiene_products/functions/admin/users/AdminViewUsers.dart';
import 'package:vitality_hygiene_products/models/UserModel.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/Futures.dart';
import 'package:vitality_hygiene_products/shared/TaskSelection.dart';
import 'AddUsers.dart';

class AdminUsers extends StatelessWidget {
  final AppColors _appColors = AppColors();
  final UserModel user;
  final Function toggleUsersToHome;
  final Function toggleUsersToStore;
  final Function toggleUsersToPurchases;
  final Function toggleUsersToSales;

  AdminUsers(
    {
      this.user,
      this.toggleUsersToHome,
      this.toggleUsersToStore,
      this.toggleUsersToPurchases,
      this.toggleUsersToSales,
    }
  );

  @override
  Widget build(BuildContext context) {
    TaskSelection.selection['home']         = false;
    TaskSelection.selection['users']        = true;
    TaskSelection.selection['store']        = false;
    TaskSelection.selection['purchases']    = false;
    TaskSelection.selection['sales']        = false;
    TaskSelection.selection['expenditures'] = false;

    return WillPopScope(
      onWillPop: Futures(context: context).onBackPressed,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: AdminDrawer(
            toggleUsersToHome: toggleUsersToHome,
            toggleUsersToStore: toggleUsersToStore,
            toggleUsersToPurchases: toggleUsersToPurchases,
            toggleUsersToSales: toggleUsersToSales,
          ),
          appBar: AppBar(
            backgroundColor: _appColors.getBackgroundColor(),
            title: Text(
              "Users",
              style: TextStyle(
                color: _appColors.getFontColor()
              ),
            ),

            actions: [
              Options(),
            ],
          ),

        body: TabBarView(
            children: <Widget>[
              AddUsers(user: user,),
              AdminViewUsers(),
            ]
        ),

        bottomNavigationBar: Material(
          color: _appColors.getBackgroundColor(),
          child: TabBar(
            labelPadding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 0,
            ),
            unselectedLabelColor: _appColors.getUnselectedLabelColor(),
            labelColor: _appColors.getSelectedTabColor(),
            indicatorColor: _appColors.getSelectedTabColor(),
            tabs: [
              Tab(
                text: "Add",
                icon: Icon(
                  Icons.person_add,
                ),
              ),
              Tab(
                text: "View",
                icon: Icon(
                  Icons.view_list,
                ),
              )
            ],
          ),
        ),
        ),
      ),
    );
  }
}