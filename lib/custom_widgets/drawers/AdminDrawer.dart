import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomDrawerHeader.dart';
import 'package:vitality_hygiene_products/shared/TaskSelection.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';

class AdminDrawer extends StatefulWidget {
  //Home to other scenarios
  final Function toggleHomeToUsers;
  final Function toggleHomeToStore;
  final Function toggleHomeToPurchases;
  final Function toggleHomeToSales;

  //Users to other scenarios
  final Function toggleUsersToHome;
  final Function toggleUsersToStore;
  final Function toggleUsersToPurchases;
  final Function toggleUsersToSales;

  //Store to other scenarios
  final Function toggleStoreToHome;
  final Function toggleStoreToUsers;
  final Function toggleStoreToPurchases;
  final Function toggleStoreToSales;

  //Purchases to other scenarios
  final Function togglePurchasesToHome;
  final Function togglePurchasesToUsers;
  final Function togglePurchasesToStore;
  final Function togglePurchasesToSales;

  //Sales to other scenarios
  final Function toggleSalesToHome;
  final Function toggleSalesToUsers;
  final Function toggleSalesToStore;
  final Function toggleSalesToPurchases;

  AdminDrawer(
    {
      //Home to other scenarios
      this.toggleHomeToUsers,
      this.toggleHomeToStore,
      this.toggleHomeToPurchases,
      this.toggleHomeToSales,

      /*Users to other scenarios*/
      this.toggleUsersToHome,
      this.toggleUsersToStore,
      this.toggleUsersToPurchases,
      this.toggleUsersToSales,

      /*Store to other scenarios*/
      this.toggleStoreToHome,
      this.toggleStoreToUsers,
      this.toggleStoreToPurchases,
      this.toggleStoreToSales,

      /*Purchases to other scenarios*/
      this.togglePurchasesToHome,
      this.togglePurchasesToUsers,
      this.togglePurchasesToStore,
      this.togglePurchasesToSales,

      /*Sales to other scenarios*/
      this.toggleSalesToHome,
      this.toggleSalesToUsers,
      this.toggleSalesToStore,
      this.toggleSalesToPurchases,
    }
  );

  @override
  _AdminDrawer createState() => _AdminDrawer();
}

class _AdminDrawer extends State<AdminDrawer> {
  final AppColors _appColors = AppColors();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          CustomDrawerHeader(),

          //Home
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
              if(!TaskSelection.selection['home']){
                if(TaskSelection.selection['users']){
                  widget.toggleUsersToHome();
                } else if(TaskSelection.selection['store']){
                  widget.toggleStoreToHome();
                } else if(TaskSelection.selection['purchases']){
                  widget.togglePurchasesToHome();
                } else if(TaskSelection.selection['sales']){
                  widget.toggleSalesToHome();
                }
              }
            },
          ),

          //Users
          ListTile(
            selected: TaskSelection.selection['users'],

            selectedTileColor: _appColors.getBackgroundColor(),

            leading: Icon(
                Icons.group_rounded,
                color: (TaskSelection.selection['users'])?_appColors.getPrimaryForeColor():_appColors.getFontColor()
            ),

            title: Text(
              "Users",
              style: TextStyle(
                  color: (TaskSelection.selection['users'])?_appColors.getPrimaryForeColor():_appColors.getFontColor()
              ),
            ),

            onTap: (){
              if(!TaskSelection.selection['users']){
                if(TaskSelection.selection['home']){
                  widget.toggleHomeToUsers();
                } else if(TaskSelection.selection['store']){
                  widget.toggleStoreToUsers();
                } else if(TaskSelection.selection['purchases']){
                  widget.togglePurchasesToUsers();
                } else if(TaskSelection.selection['sales']){
                  widget.toggleSalesToUsers();
                }
              }
            },
          ),

          //Store
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
              if(!TaskSelection.selection['store']){
                if(TaskSelection.selection['home']){
                  widget.toggleHomeToStore();
                }else if(TaskSelection.selection['users']){
                  widget.toggleUsersToStore();
                } else if(TaskSelection.selection['purchases']){
                  widget.togglePurchasesToStore();
                } else if(TaskSelection.selection['sales']){
                  widget.toggleSalesToStore();
                }
              }
            },
          ),

          //Purchases
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
              if(!TaskSelection.selection['purchases']){
                if(TaskSelection.selection['home']){
                  widget.toggleHomeToPurchases();
                } else if(TaskSelection.selection['users']){
                  widget.toggleUsersToPurchases();
                } else if(TaskSelection.selection['store']){
                  widget.toggleStoreToPurchases();
                } else if(TaskSelection.selection['sales']){
                  widget.toggleSalesToPurchases();
                }
              }
            },
          ),

          //Sales
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
                  widget.toggleHomeToSales();
                } else if(TaskSelection.selection['users']){
                  widget.toggleUsersToSales();
                } else if(TaskSelection.selection['store']){
                  widget.toggleStoreToSales();
                } else if(TaskSelection.selection['purchases']){
                  widget.togglePurchasesToSales();
                }
              }
            },
          ),
          // ListTile(
          //   selected: TaskSelection.selection['expenditures'],
          //   selectedTileColor: appColors.getBackgroundColor(),
          //   leading: Icon(
          //     Icons.monetization_on,
          //     color: appColors.getFontColor(),
          //   ),
          //   title: Text(
          //     "Expenditures",
          //     style: TextStyle(
          //         color: appColors.getFontColor()
          //     ),
          //   ),
          //   onTap: (){
          //     Navigator.pushNamed(context, '/workers/expenditures');
          //   },
          // ),
        ],
      ),
    );
  }
}