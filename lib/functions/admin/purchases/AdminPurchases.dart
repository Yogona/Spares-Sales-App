import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/custom_widgets/Options.dart';
import 'package:vitality_hygiene_products/custom_widgets/drawers/AdminDrawer.dart';
import 'package:vitality_hygiene_products/functions/admin/purchases/AdminViewPurchases.dart';
import 'package:vitality_hygiene_products/functions/settings/Password.dart';
import 'package:vitality_hygiene_products/models/LoggedInUser.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/Futures.dart';
import 'package:vitality_hygiene_products/shared/TaskSelection.dart';
import '../../purchases/AddPurchases.dart';

class AdminPurchases extends StatelessWidget {
  final AppColors _appColors = AppColors();

  //Navigation
  final Function togglePurchasesToHome;
  final Function togglePurchasesToUsers;
  final Function togglePurchasesToStore;
  final Function togglePurchasesToSales;

  //Options
  final Function togglePassword;

  AdminPurchases({
    //Navigation
    this.togglePurchasesToHome,
    this.togglePurchasesToUsers,
    this.togglePurchasesToStore,
    this.togglePurchasesToSales,

    //Options
    this.togglePassword,
  });

  @override
  Widget build(BuildContext context) {
    TaskSelection.selection['home'] = false;
    TaskSelection.selection['users'] = false;
    TaskSelection.selection['store'] = false;
    TaskSelection.selection['purchases'] = true;
    TaskSelection.selection['sales'] = false;
    TaskSelection.selection['expenditures'] = false;

    if(TaskSelection.options['password']){
      return Password(email: LoggedInUser.getEmail(), togglePassword: togglePassword,);
    }

    return WillPopScope(
      onWillPop: Futures(context: context).onBackPressed,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: AdminDrawer(
            togglePurchasesToHome: togglePurchasesToHome,
            togglePurchasesToUsers: togglePurchasesToUsers,
            togglePurchasesToStore: togglePurchasesToStore,
            togglePurchasesToSales: togglePurchasesToSales,
          ),
          appBar: AppBar(
            backgroundColor: _appColors.getBackgroundColor(),
            title: Text(
              "Purchases",
              style: TextStyle(color: _appColors.getPrimaryForeColor()),
            ),
            actions: [
              Options(togglePassword: togglePassword,),
            ],
          ),
          body: TabBarView(children: <Widget>[
            StreamProvider<QuerySnapshot>.value(
              initialData: null,
              value: DatabaseService().store,
              child: AddPurchases(),
            ),

            //This grabs users and insert into view purchases widget
            StreamProvider<QuerySnapshot>.value(
              initialData: null,
              value: DatabaseService().purchases,
              child: AdminViewPurchases(),
            ),

            // AddCosts(),
            //
            // AdminViewCosts(),
          ]),
          bottomNavigationBar: Material(
            color: _appColors.getBackgroundColor(),
            child: TabBar(
              unselectedLabelColor: _appColors.getUnselectedLabelColor(),
              labelColor: _appColors.getSelectedTabColor(),
              indicatorColor: _appColors.getSelectedTabColor(),
              tabs: [
                Tab(
                  icon: Icon(Icons.add_shopping_cart),
                  text: "Add",
                  //text: "Purchase",
                ),

                Tab(
                  icon: Icon(Icons.view_list),
                  text: "View",
                  //text: "Purchase",
                ),

                // Tab(
                //   icon: Icon(Icons.money),
                //   text: "Costs",
                //   //text: "Costs",
                // ),
                //
                // Tab(
                //   icon: Icon(Icons.view_list),
                //   text: "Costs",
                //   //text: "Costs",
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
