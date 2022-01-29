import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/custom_widgets/Options.dart';
import 'package:vitality_hygiene_products/custom_widgets/drawers/ModDrawer.dart';
import 'package:vitality_hygiene_products/functions/settings/Password.dart';
import 'package:vitality_hygiene_products/models/LoggedInUser.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/Futures.dart';
import 'package:vitality_hygiene_products/shared/TaskSelection.dart';
import '../../store/AddProducts.dart';
import 'ModViewProducts.dart';

class ModsStore extends StatelessWidget {
  final AppColors _appColors = AppColors();

  //Navigation
  final Function toggleStoreToHome;
  final Function toggleStoreToPurchases;
  final Function toggleStoreToSales;

  //Options
  final Function togglePassword;

  ModsStore(
    {
      //Navigation
      this.toggleStoreToHome,
      this.toggleStoreToPurchases,
      this.toggleStoreToSales,

      //Options
      this.togglePassword
    }
  );

  @override
  Widget build(BuildContext context) {
    if(TaskSelection.options['password']){
      return Password(email: LoggedInUser.getEmail(), togglePassword: togglePassword,);
    }

    return WillPopScope(
      onWillPop: Futures(context: context).onBackPressed,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: ModDrawer(
            toggleStoreToHome: toggleStoreToHome,
            toggleStoreToPurchases: toggleStoreToPurchases,
            toggleStoreToSales: toggleStoreToSales,
          ),

          appBar: AppBar(
            title: Text(
              "Store",
              style: TextStyle(
                color: _appColors.getPrimaryForeColor(),
              ),
            ),

            actions: [
              Options(togglePassword: togglePassword,),
            ],
          ),

          body: TabBarView(
            children: [
              AddProducts(),

              StreamProvider<QuerySnapshot>.value(
                  initialData: null,
                  value: DatabaseService().store,
                  child: ModViewProducts()
              ),

              //PickProducts(),
            ],
          ),

          bottomNavigationBar: Material(
            color: _appColors.getBackgroundColor(),
            child: TabBar(
              unselectedLabelColor: _appColors.getUnselectedLabelColor(),
              labelColor: _appColors.getSelectedTabColor(),
              indicatorColor: _appColors.getSelectedTabColor(),

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