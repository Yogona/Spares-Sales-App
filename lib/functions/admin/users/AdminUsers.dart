import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/custom_widgets/Options.dart';
import 'package:vitality_hygiene_products/custom_widgets/drawers/AdminDrawer.dart';
import 'package:vitality_hygiene_products/functions/admin/users/AdminViewUsers.dart';
import 'package:vitality_hygiene_products/functions/settings/Password.dart';
import 'package:vitality_hygiene_products/models/UserModel.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/Futures.dart';
import 'package:vitality_hygiene_products/shared/TaskSelection.dart';
import 'AddUsers.dart';

class AdminUsers extends StatefulWidget{
  final AppColors _appColors = AppColors();
  final UserModel user;

  //Navigation
  final Function toggleUsersToHome;
  final Function toggleUsersToStore;
  final Function toggleUsersToPurchases;
  final Function toggleUsersToSales;

  //Options
  final Function togglePassword;

  AdminUsers(
      {
        //Navigation
        this.user,
        this.toggleUsersToHome,
        this.toggleUsersToStore,
        this.toggleUsersToPurchases,
        this.toggleUsersToSales,

        //Options
        this.togglePassword
      }
      );

  @override
  _AdminUsersState createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {

  @override
  Widget build(BuildContext context) {
    TaskSelection.selection['home']         = false;
    TaskSelection.selection['users']        = true;
    TaskSelection.selection['store']        = false;
    TaskSelection.selection['purchases']    = false;
    TaskSelection.selection['sales']        = false;
    TaskSelection.selection['expenditures'] = false;

    if(TaskSelection.options['password']){
      return Password(togglePassword: widget.togglePassword,);
    }

    return WillPopScope(
      onWillPop: Futures(context: context).onBackPressed,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: AdminDrawer(
            toggleUsersToHome: widget.toggleUsersToHome,
            toggleUsersToStore: widget.toggleUsersToStore,
            toggleUsersToPurchases: widget.toggleUsersToPurchases,
            toggleUsersToSales: widget.toggleUsersToSales,
          ),
          appBar: AppBar(
            backgroundColor: widget._appColors.getBackgroundColor(),
            title: Text(
              "Users",
              style: TextStyle(
                color: widget._appColors.getPrimaryForeColor()
              ),
            ),

            actions: [
              Options(togglePassword: widget.togglePassword,),
            ],
          ),

        body: TabBarView(
            children: <Widget>[
              AddUsers(user: widget.user,),
              AdminViewUsers(),
            ]
        ),

        bottomNavigationBar: Material(
          color: widget._appColors.getBackgroundColor(),
          child: TabBar(
            labelPadding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 0,
            ),
            unselectedLabelColor: widget._appColors.getUnselectedLabelColor(),
            labelColor: widget._appColors.getSelectedTabColor(),
            indicatorColor: widget._appColors.getSelectedTabColor(),
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