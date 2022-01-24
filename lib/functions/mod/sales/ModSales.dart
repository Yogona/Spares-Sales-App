import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/custom_widgets/Options.dart';
import 'package:vitality_hygiene_products/custom_widgets/drawers/ModDrawer.dart';
import 'package:vitality_hygiene_products/functions/sales/AddSales.dart';
import 'package:vitality_hygiene_products/functions/sales/ViewSales.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:vitality_hygiene_products/shared/Futures.dart';

class ModSales extends StatelessWidget {
  final AppColors _appColors = AppColors();

  final Function toggleSalesToHome;
  final Function toggleSalesToStore;
  final Function toggleSalesToPurchases;

  ModSales({
    this.toggleSalesToHome,
    this.toggleSalesToStore,
    this.toggleSalesToPurchases,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Futures(context: context).onBackPressed,

      child: DefaultTabController(
        length: 2,

        child: Scaffold(
          appBar: AppBar(
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

          drawer: ModDrawer(
            toggleSalesToHome: toggleSalesToHome,
            toggleSalesToStore: toggleSalesToStore,
            toggleSalesToPurchases: toggleSalesToPurchases,
          ),

          body: TabBarView(
            children: [
              AddSales(),
              //ViewSales(),
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
