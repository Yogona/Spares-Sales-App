import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/custom_widgets/Options.dart';
import 'package:vitality_hygiene_products/custom_widgets/drawers/AdminDrawer.dart';
import 'package:vitality_hygiene_products/functions/sales/AddSales.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:vitality_hygiene_products/shared/Futures.dart';
import 'package:vitality_hygiene_products/shared/TaskSelection.dart';
import '../sales/ViewSales.dart';

class AdminSales extends StatelessWidget {
  final AppColors _appColors = AppColors();
  final Function toggleSalesToHome;
  final Function toggleSalesToUsers;
  final Function toggleSalesToStore;
  final Function toggleSalesToPurchases;

  AdminSales(
    {
      this.toggleSalesToHome,
      this.toggleSalesToUsers,
      this.toggleSalesToStore,
      this.toggleSalesToPurchases,
    }
  );

  @override
  Widget build(BuildContext context) {
    TaskSelection.selection['home'] = false;
    TaskSelection.selection['users'] = false;
    TaskSelection.selection['store'] = false;
    TaskSelection.selection['purchases'] = false;
    TaskSelection.selection['sales'] = true;
    TaskSelection.selection['expenditures'] = false;


    return WillPopScope(
      onWillPop: Futures(context: context).onBackPressed,

      child: DefaultTabController(
        length: 2,

        child: Scaffold(
          drawer: AdminDrawer(
            toggleSalesToHome: toggleSalesToHome,
            toggleSalesToUsers: toggleSalesToUsers,
            toggleSalesToStore: toggleSalesToStore,
            toggleSalesToPurchases: toggleSalesToPurchases,
          ),

          appBar: AppBar(
            backgroundColor: _appColors.getBackgroundColor(),
            title: Text(
              "Sales",
              style: TextStyle(
                color: _appColors.getFontColor(),
                fontSize: FormSpecs.formHeaderSize,
              ),
            ),

            actions: [
              Options(),
            ],
          ),

          body: TabBarView(
            children: [
              AddSales(),
              ViewSales(),
            ],
          ),

          bottomNavigationBar: Material(
            color: _appColors.getBackgroundColor(),

            child: TabBar(
              indicatorColor: _appColors.getSelectedTabColor(),
              unselectedLabelColor: _appColors.getUnselectedLabelColor(),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.app_registration
                  ),
                  text: "Record",
                ),

                Tab(
                  icon: Icon(
                    Icons.view_list
                  ),
                  text: "View",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}