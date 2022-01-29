import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/custom_widgets/Options.dart';
import 'package:vitality_hygiene_products/custom_widgets/drawers/ModDrawer.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/Futures.dart';
import 'package:vitality_hygiene_products/shared/GetUsers.dart';
import '../purchases/AddPurchases.dart';

class ModPurchases extends StatelessWidget {
  final AppColors _appColors = AppColors();
  final Function togglePurchasesToHome;
  final Function togglePurchasesToStore;
  final Function togglePurchasesToSales;

  ModPurchases({
    this.togglePurchasesToHome,
    this.togglePurchasesToStore,
    this.togglePurchasesToSales,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Futures(context: context).onBackPressed,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: ModDrawer(
            togglePurchasesToHome: togglePurchasesToHome,
            togglePurchasesToStore: togglePurchasesToStore,
            togglePurchasesToSales: togglePurchasesToSales,
          ),
          appBar: AppBar(
            title: Text(
              "Purchases",
              style: TextStyle(color: _appColors.getPrimaryForeColor()),
            ),
            actions: [
              Options(),
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
              value: DatabaseService().getUsers,
              child: GetUsers(),
            ),

            // AddCosts(),
            //
            // AdminViewCosts(),
          ]),
          bottomNavigationBar: Material(
            color: _appColors.getBackgroundColor(),
            child: TabBar(
              indicatorColor: _appColors.getSelectedTabColor(),
              unselectedLabelColor: _appColors.getUnselectedLabelColor(),
              labelColor: _appColors.getSelectedTabColor(),
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
                //   //text: "Costs",
                // ),
                // Tab(
                //   icon: Icon(Icons.view_list),
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
