import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/custom_widgets/Options.dart';
import 'package:vitality_hygiene_products/custom_widgets/drawers/AdminDrawer.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/Futures.dart';
import 'package:vitality_hygiene_products/shared/TaskSelection.dart';
import '../../store/AddProducts.dart';
import 'AdminViewProducts.dart';

class AdminStore extends StatelessWidget {
  final AppColors _appColors = AppColors();
  final Function toggleStoreToHome;
  final Function toggleStoreToUsers;
  final Function toggleStoreToPurchases;
  final Function toggleStoreToSales;

  AdminStore(
    {
      this.toggleStoreToHome,
      this.toggleStoreToUsers,
      this.toggleStoreToPurchases,
      this.toggleStoreToSales,
    }
  );

  @override
  Widget build(BuildContext context) {
    TaskSelection.selection['home'] = false;
    TaskSelection.selection['users'] = false;
    TaskSelection.selection['store'] = true;
    TaskSelection.selection['purchases'] = false;
    TaskSelection.selection['sales'] = false;
    TaskSelection.selection['expenditures'] = false;

    return WillPopScope(
      onWillPop: Futures(context: context).onBackPressed,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: AdminDrawer(
            toggleStoreToHome: toggleStoreToHome,
            toggleStoreToUsers: toggleStoreToUsers,
            toggleStoreToPurchases: toggleStoreToPurchases,
            toggleStoreToSales: toggleStoreToSales,
          ),

          appBar: AppBar(
            backgroundColor: _appColors.getBackgroundColor(),
            title: Text(
              "Store",
              style: TextStyle(
                color: _appColors.getFontColor(),
              ),
            ),

            actions: [
              Options(),
            ],
          ),

          body: TabBarView(
            children: [
              AddProducts(),

              StreamProvider<QuerySnapshot>.value(
                  initialData: null,
                  value: DatabaseService().store,
                  child: AdminViewProducts()
              ),

              //PickProducts(),
            ],
          ),

          bottomNavigationBar: Material(
            color: _appColors.getBackgroundColor(),
            child: TabBar(
              indicatorColor: _appColors.getSelectedTabColor(),
              unselectedLabelColor: _appColors.getUnselectedLabelColor(),
              labelColor: _appColors.getSelectedTabColor(),
              tabs: [
                Tab(
                  text: "Add",
                  icon: Icon(
                    Icons.add_business,
                  ),
                ),
                Tab(
                  text:"View",
                  icon: Icon(
                    Icons.view_list,
                  ),
                ),

                // Tab(
                //   text: "Pick",
                //   icon: Icon(
                //     Icons.transfer_within_a_station_sharp,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}