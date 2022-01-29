import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/authenticate/LoginPage.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/functions/admin/AdminHome.dart';
import 'package:vitality_hygiene_products/functions/admin/AdminSales.dart';
import 'package:vitality_hygiene_products/functions/admin/purchases/AdminPurchases.dart';
import 'package:vitality_hygiene_products/functions/admin/store/AdminStore.dart';
import 'package:vitality_hygiene_products/functions/admin/users/AdminUsers.dart';
import 'package:vitality_hygiene_products/functions/mod/ModHome.dart';
import 'package:vitality_hygiene_products/functions/mod/ModPurchases.dart';
import 'package:vitality_hygiene_products/functions/mod/sales/ModSales.dart';
import 'package:vitality_hygiene_products/functions/mod/store/ModsStore.dart';
import 'package:vitality_hygiene_products/models/LoggedInUser.dart';
import 'package:vitality_hygiene_products/models/UserModel.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/General.dart';
import 'package:vitality_hygiene_products/shared/TaskSelection.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';

class CheckRole extends StatefulWidget {
  final AppColors _appColors = AppColors();
  final String version;
  final UserModel user;
  final String userRoleID;

  CheckRole({this.version, this.user, this.userRoleID});
  @override
  _CheckRoleState createState() => _CheckRoleState();
}

class _CheckRoleState extends State<CheckRole> {
  String _userRole;

  //Home to other scenarios
  void toggleHomeToUsers(){
    setState((){
      TaskSelection.selection['home'] = false;
      TaskSelection.selection['users'] = true;
    });
  }

  void toggleHomeToStore(){
    setState((){
      TaskSelection.selection['home'] = false;
      TaskSelection.selection['store'] = true;
    });
  }

  void toggleHomeToPurchases(){
    setState((){
      TaskSelection.selection['home'] = false;
      TaskSelection.selection['purchases'] = true;
    });
  }

  void toggleHomeToSales(){
    setState((){
      TaskSelection.selection['home'] = false;
      TaskSelection.selection['sales'] = true;
    });
  }


  //Users to other scenarios
  void toggleUsersToHome(){
    setState((){
      TaskSelection.selection['users'] = false;
      TaskSelection.selection['home'] = true;
    });
  }

  void toggleUsersToStore(){
    setState((){
      TaskSelection.selection['users'] = false;
      TaskSelection.selection['store'] = true;
    });
  }

  void toggleUsersToPurchases(){
    setState((){
      TaskSelection.selection['users'] = false;
      TaskSelection.selection['purchases'] = true;
    });
  }

  void toggleUsersToSales(){
    setState((){
      TaskSelection.selection['users'] = false;
      TaskSelection.selection['sales'] = true;
    });
  }

  //Store to other scenarios
  void toggleStoreToHome(){
    setState((){
      TaskSelection.selection['store'] = false;
      TaskSelection.selection['home'] = true;
    });
  }

  void toggleStoreToUsers(){
    setState((){
      TaskSelection.selection['store'] = false;
      TaskSelection.selection['users'] = true;
    });
  }

  void toggleStoreToPurchases(){
    setState((){
      TaskSelection.selection['store'] = false;
      TaskSelection.selection['purchases'] = true;
    });
  }

  void toggleStoreToSales(){
    setState((){
      TaskSelection.selection['store'] = false;
      TaskSelection.selection['sales'] = true;
    });
  }

  //Purchases to other scenarios
  void togglePurchasesToHome(){
    setState((){
      TaskSelection.selection['purchases'] = false;
      TaskSelection.selection['home'] = true;
    });
  }

  void togglePurchasesToUsers(){
    setState((){
      TaskSelection.selection['purchases'] = false;
      TaskSelection.selection['users'] = true;
    });
  }

  void togglePurchasesToStore(){
    setState((){
      TaskSelection.selection['purchases'] = false;
      TaskSelection.selection['store'] = true;
    });
  }

  void togglePurchasesToSales(){
    setState((){
      TaskSelection.selection['purchases'] = false;
      TaskSelection.selection['sales'] = true;
    });
  }

  //Sales to other scenarios
  void toggleSalesToHome(){
    setState((){
      TaskSelection.selection['sales'] = false;
      TaskSelection.selection['home'] = true;
    });
  }

  void toggleSalesToUsers(){
    setState((){
      TaskSelection.selection['sales'] = false;
      TaskSelection.selection['users'] = true;
    });
  }

  void toggleSalesToStore(){
    setState((){
      TaskSelection.selection['sales'] = false;
      TaskSelection.selection['store'] = true;
    });
  }

  void toggleSalesToPurchases(){
    setState((){
      TaskSelection.selection['sales'] = false;
      TaskSelection.selection['purchases'] = true;
    });
  }

  //Options
  void togglePassword(){
    setState((){
      TaskSelection.options['password'] = !TaskSelection.options['password'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final roles = Provider.of<QuerySnapshot>(context);

    if(roles == null){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: widget._appColors.getBackgroundColor(),
          title: Text(
              appTitle,
            style: TextStyle(
              color: widget._appColors.getPrimaryForeColor(),
            ),
          ),
        ),

        body: LoadingWidget("Checking user role..."),
      );
    }

    // final maintenance = Provider.of<QuerySnapshot>(context);
    //
    // if(maintenance == null){
    //   return NoItemsFound("");
    // }
    //
    // String newVersion = "";
    //
    // maintenance.docs.map((doc){
    //   newVersion = doc.get("appVersion");
    // }).toList();
    //
    // String userID = LoggedInUser.getUID();
    //
    // return (!(version == newVersion))?Scaffold(
    //   appBar:AppBar(
    //     actions: [Options(),],
    //     title: Text(
    //       "New Update Available",
    //       style: TextStyle(
    //           color: _appColors.getFontColor()
    //       ),
    //     ),
    //   ),
    //   body: NoItemsFound("Please update to the latest version."),
    // )

    General.roles = roles;

    for(var role in roles.docs){
      if(role.id == widget.userRoleID){
        _userRole = role.get("role");
        LoggedInUser.setRole(_userRole);

        if(_userRole == "Admin"){
          if(TaskSelection.selection['home']){
            return StreamProvider<QuerySnapshot>.value(
                initialData: null,
                value: DatabaseService().getMaintenance,
                child: AdminHome(
                  //Navigation
                  toggleHomeToUsers: toggleHomeToUsers,
                  toggleHomeToStore: toggleHomeToStore,
                  toggleHomeToPurchases: toggleHomeToPurchases,
                  toggleHomeToSales: toggleHomeToSales,

                  //Options
                  togglePassword: togglePassword,
                )
            );
          } else if(TaskSelection.selection['users']){
            return AdminUsers(
              user: widget.user,

              //Navigation
              toggleUsersToHome: toggleUsersToHome,
              toggleUsersToStore: toggleUsersToStore,
              toggleUsersToPurchases: toggleUsersToPurchases,
              toggleUsersToSales: toggleUsersToSales,

              //Options
              togglePassword: togglePassword,
            );
          } else if(TaskSelection.selection['store']){
            return AdminStore(
              //Navigation
              toggleStoreToHome: toggleStoreToHome,
              toggleStoreToUsers: toggleStoreToUsers,
              toggleStoreToPurchases: toggleStoreToPurchases,
              toggleStoreToSales: toggleStoreToSales,

              //Options
              togglePassword: togglePassword,
            );
          } else if(TaskSelection.selection['purchases']){
            return AdminPurchases(
              //Navigation
              togglePurchasesToHome: togglePurchasesToHome,
              togglePurchasesToUsers: togglePurchasesToUsers,
              togglePurchasesToStore: togglePurchasesToStore,
              togglePurchasesToSales: togglePurchasesToSales,

              //Options
              togglePassword: togglePassword,
            );
          } else if(TaskSelection.selection['sales']){
            return AdminSales(
              //Navigation
              toggleSalesToHome: toggleSalesToHome,
              toggleSalesToUsers: toggleSalesToUsers,
              toggleSalesToStore: toggleSalesToStore,
              toggleSalesToPurchases: toggleSalesToPurchases,

              //Options
              togglePassword: togglePassword,
            );
          }
        }else if(_userRole == "Mod"){
          if(TaskSelection.selection['home']){
            return StreamProvider<QuerySnapshot>.value(
                initialData: null,
                value: DatabaseService().getMaintenance,
                child: ModHome(
                  //Navigation
                  toggleHomeToStore: toggleHomeToStore,
                  toggleHomeToPurchases: toggleHomeToPurchases,
                  toggleHomeToSales: toggleHomeToSales,

                  //Options
                  togglepassword: togglePassword,
                )
            );
          } else if(TaskSelection.selection['store']){
            return ModsStore(
              //Navigation
              toggleStoreToHome: toggleStoreToHome,
              toggleStoreToPurchases: toggleStoreToPurchases,
              toggleStoreToSales: toggleStoreToSales,

              //Options
              togglePassword: togglePassword,
            );
          } else if(TaskSelection.selection['purchases']){
            return ModPurchases(
              //Navigation
              togglePurchasesToHome: togglePurchasesToHome,
              togglePurchasesToStore: togglePurchasesToStore,
              togglePurchasesToSales: togglePurchasesToSales,

              //Options
              togglePassword: togglePassword,
            );
          } else if(TaskSelection.selection['sales']){
            return ModSales(
              //Navigation
              toggleSalesToHome: toggleSalesToHome,
              toggleSalesToStore: toggleSalesToStore,
              toggleSalesToPurchases: toggleSalesToPurchases,

              //Options
              togglePassword: togglePassword,
            );
          }
        }
      }
    }

    return LoginPage();
  }
}