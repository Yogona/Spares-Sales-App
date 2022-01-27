import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/custom_widgets/NoItemsFound.dart';
import 'package:vitality_hygiene_products/custom_widgets/Options.dart';
import 'package:vitality_hygiene_products/functions/settings/Password.dart';
import 'package:vitality_hygiene_products/models/LoggedInUser.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/custom_widgets/drawers/AdminDrawer.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:vitality_hygiene_products/shared/Futures.dart';
import 'package:vitality_hygiene_products/shared/TaskSelection.dart';
import 'package:vitality_hygiene_products/shared/General.dart';

class AdminHome extends StatefulWidget{
  //Navigations
  final Function toggleHomeToUsers;
  final Function toggleHomeToStore;
  final Function toggleHomeToPurchases;
  final Function toggleHomeToSales;

  //Options
  final Function togglePassword;

  AdminHome(
      {
        //Navigations
        this.toggleHomeToUsers,
        this.toggleHomeToStore,
        this.toggleHomeToPurchases,
        this.toggleHomeToSales,

        //Options
        this.togglePassword
      }
      );
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final AppColors _appColors = AppColors();
  //bool _isPasswordScreen = false;



  @override
  Widget build(BuildContext context) {
    if(TaskSelection.options['password']){
      return Password(togglePassword: widget.togglePassword,);
    }
        return WillPopScope(
      onWillPop: Futures(context: context).onBackPressed,
      child: Scaffold(
        drawer: AdminDrawer(
          toggleHomeToUsers: widget.toggleHomeToUsers,
          toggleHomeToStore: widget.toggleHomeToStore,
          toggleHomeToPurchases: widget.toggleHomeToPurchases,
          toggleHomeToSales: widget.toggleHomeToSales,
        ),

        appBar: AppBar(
          backgroundColor: _appColors.getBackgroundColor(),
          actions: [
            Options(togglePassword: widget.togglePassword,),
          ],
          title: Text(
            "Home",
            style: TextStyle(
                color: _appColors.getPrimaryForeColor()
            ),
          ),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //Heading
            SizedBox(height: FormSpecs.sizedBoxHeight,),
            Container(
              decoration: boxDecoration.copyWith(
                color: _appColors.getBoxColor(),
              ),

              margin: EdgeInsets.only(
                left: FormSpecs.formMargin,
                right: FormSpecs.formMargin,
              ),

              padding: EdgeInsets.all(
                5.0
              ),

              child: Center(
                child: Text(
                  "Administrator",
                  style: TextStyle(
                    color: _appColors.getFontColor(),
                    fontSize: FormSpecs.formHeaderSize,
                  ),
                ),
              ),
            ),
            SizedBox(height: FormSpecs.sizedBoxHeight,),

            Column(
              children: [
                StreamProvider<QuerySnapshot>.value(
                  initialData: null,
                  value: DatabaseService().getUsers,
                  child: StreamBuilder(
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      final users = Provider.of<QuerySnapshot>(context);

                      if(users == null){
                        return LoadingWidget("Users...");
                      }

                      int countAdmins = 0, countMods = 0, countWorkers = 0;

                      users.docs.map((user) {
                        General.roles.docs.map((role) {
                          if(role.id == user.get("roleID")){
                            if(role.get("role") == "Admin"){
                              ++countAdmins;
                            } else if(role.get("role") == "Mod"){
                              ++countMods;
                            }// else if(role.get("role") == "worker"){
                            //   ++countWorkers;
                            // }
                          }
                        }).toList();
                      }).toList();

                      return ListTile(
                        title: Text(
                          "Number of Users",
                          style: TextStyle(
                            color: _appColors.getTileTitleColor(),
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Administrators: "+countAdmins.toString(),
                              style: TextStyle(
                                color: _appColors.getTileSubtitleColor(),
                              ),
                            ),

                            Text(
                              "Moderators: "+countMods.toString(),
                              style: TextStyle(
                                color: _appColors.getTileSubtitleColor(),
                              ),
                            ),

                            Text(
                              "Workers: "+countWorkers.toString(),
                              style: TextStyle(
                                color: _appColors.getTileSubtitleColor(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Divider(
                  color: _appColors.getTileSubtitleColor(),
                ),

                StreamProvider<QuerySnapshot>.value(
                  initialData: null,
                  value: DatabaseService().store,
                  child: StreamBuilder(
                    builder: (BuildContext ctx, AsyncSnapshot snapshot){
                      final store = Provider.of<QuerySnapshot>(ctx);

                      if(store == null){
                        return NoItemsFound("No products were found.");
                      }

                      int countProducts = store.size;

                      return ListTile(
                        title: Text(
                          "Number of Products.",
                          style: TextStyle(
                            color: _appColors.getTileTitleColor(),
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Types:"+countProducts.toString(),
                              style: TextStyle(
                                color: _appColors.getTileSubtitleColor(),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Divider(
                  color: _appColors.getTileSubtitleColor(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}