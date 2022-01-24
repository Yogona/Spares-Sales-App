import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/custom_widgets/NoItemsFound.dart';
import 'package:vitality_hygiene_products/custom_widgets/Options.dart';
import 'package:vitality_hygiene_products/custom_widgets/drawers/ModDrawer.dart';
import 'package:vitality_hygiene_products/models/LoggedInUser.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:vitality_hygiene_products/shared/Futures.dart';
import 'package:vitality_hygiene_products/shared/TaskSelection.dart';
import 'package:vitality_hygiene_products/shared/General.dart';

class ModHome extends StatelessWidget {
  final AppColors _appColors = AppColors();

  final Function toggleHomeToStore;
  final Function toggleHomeToPurchases;
  final Function toggleHomeToSales;

  ModHome({
    this.toggleHomeToStore,
    this.toggleHomeToPurchases,
    this.toggleHomeToSales,
  });

  @override
  Widget build(BuildContext context) {

    final maintenance = Provider.of<QuerySnapshot>(context);

    if(maintenance == null){
      return Scaffold(body: LoadingWidget("Loading, please wait..."));
    }

    String newVersion = "";

    maintenance.docs.map((doc){
      newVersion = doc.get("appVersion");
    }).toList();

    String userID = LoggedInUser.getUID();

    return WillPopScope(
      onWillPop: Futures(context: context).onBackPressed,
      child: Scaffold(
        drawer: ModDrawer(
          toggleHomeToStore: toggleHomeToStore,
          toggleHomeToPurchases: toggleHomeToPurchases,
          toggleHomeToSales: toggleHomeToSales,
        ),

        appBar: AppBar(
          actions: [
            Options(),
          ],
          title: Text(
            "Home",
            style: TextStyle(
                color: _appColors.getFontColor()
            ),
          ),
        ),

        body: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: FormSpecs.sizedBoxHeight,),
                  Center(
                    child: Text(
                      "Moderator",
                      style: TextStyle(
                        color: _appColors.getFontColor(),
                        fontSize: FormSpecs.formHeaderSize,
                      ),
                    ),
                  ),
                  SizedBox(height: FormSpecs.sizedBoxHeight,),

                  Container(
                    height: 170,
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            StreamProvider<QuerySnapshot>.value(
                              initialData: null,
                              value: DatabaseService().store,
                              child: StreamBuilder(
                                builder: (BuildContext ctx, AsyncSnapshot snapshot){
                                  final store = Provider.of<QuerySnapshot>(ctx);

                                  if(store == null){
                                    return LoadingWidget("Please wait...");
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}