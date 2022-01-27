import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/custom_widgets/NoItemsFound.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';

class AdminViewProducts extends StatefulWidget {
  @override
  _AdminViewProductsState createState() => _AdminViewProductsState();
}

class _AdminViewProductsState extends State<AdminViewProducts> {
  final AppColors _appColors = AppColors();
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<QuerySnapshot>(context);

    if(products == null){
      return LoadingWidget("Getting products.");
    }

    return products.docs.isEmpty?NoItemsFound("No products."):ListView(
      children: [
        SizedBox(height: FormSpecs.sizedBoxHeight,),

        Container(
          decoration: boxDecoration.copyWith(
            color: _appColors.getBoxColor()
          ),
          margin: EdgeInsets.all(
            FormSpecs.formMargin
          ),
          width: MediaQuery.of(context).size.width*fullWidth,
          child: Center(
            child: Text(
              "View Products",
              style: TextStyle(
                color: _appColors.getFontColor(),
                fontSize: FormSpecs.formHeaderSize,
              ),
            ),
          ),
        ),

        Container(
          //color: Colors.red,
          height: 500,
          child: ListView.builder(
            itemCount: products.docs.length,
            itemBuilder: (BuildContext context, int index){
              QueryDocumentSnapshot key = products.docs.elementAt(index);
              Timestamp createdStamp = key.get("createdAt");
              // Timestamp updatedStamp = key.get("updatedAt");
              int year = createdStamp.toDate().year;
              int month = createdStamp.toDate().month;
              int day = createdStamp.toDate().day;
              String dateCreated = day.toString()+"/"+month.toString()+"/"+year.toString();

              return Column(
                children: [
                  StreamProvider<QuerySnapshot>.value(
                    initialData: null,
                    value: DatabaseService().getUsers,

                    child: StreamBuilder(
                      builder: (context, AsyncSnapshot snapshot){
                        final users = Provider.of<QuerySnapshot>(context);

                        if(users == null){
                          return LoadingWidget("Getting users.");
                        }

                        String userName = "";

                        users.docs.map((user) {
                          if(key.get("addedBy").toString() == user.id){
                            userName = user.get("lastName").toString()+", "+user.get("firstName").toString()+" "+user.get("middleName").toString();
                          }
                        }).toList();

                        return ListTile(
                          title: Text(
                            "Code: "+key.get("productCode"),
                            style: TextStyle(
                              color: _appColors.getTileTitleColor(),
                              //backgroundColor: Colors.white
                            ),
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description: "+key.get("productDescription"),
                                style: TextStyle(
                                  color: _appColors.getTileSubtitleColor(),
                                  //backgroundColor: Colors.black
                                ),
                              ),

                              Text(
                                "Pieces: "+key.get("pieces").toString(),
                                style: TextStyle(
                                  color: _appColors.getTileSubtitleColor(),
                                  //backgroundColor: Colors.black
                                ),
                              ),

                              Text(
                                "Price: "+key.get("price").toString(),
                                style: TextStyle(
                                  color: _appColors.getTileSubtitleColor(),
                                  //backgroundColor: Colors.black
                                ),
                              ),

                              // Text(
                              //   "Cartons: "+key.get("cartons").toString(),
                              //   style: TextStyle(
                              //     color: _appColors.getTileSubtitleColor(),
                              //     //backgroundColor: Colors.black
                              //   ),
                              // ),

                              Text(
                                "Date Added: "+dateCreated,
                                style: TextStyle(
                                  color: _appColors.getTileSubtitleColor(),
                                  //backgroundColor: Colors.black
                                ),
                              ),

                              // Text(
                              //   "Date Updated: "+dateUpdated.toString(),
                              //   style: TextStyle(
                              //     color: _appColors.getTileSubtitleColor(),
                              //     //backgroundColor: Colors.black
                              //   ),
                              // ),

                              Text(
                                "Added by: "+userName,
                                style: TextStyle(
                                  color: _appColors.getTileSubtitleColor(),
                                  //backgroundColor: Colors.black
                                ),
                              ),
                            ],
                          ),

                          trailing: FlatButton(
                            child: Icon(Icons.highlight_remove),

                            onPressed: () async {

                              bool hasConnection = await DataConnectionChecker().hasConnection;

                              if(hasConnection){
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) =>  AlertDialog(
                                    title: Row(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: Colors.red,
                                        ),

                                        Text(
                                          "Warning!",
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),

                                    content: Text(
                                        "If you delete this item, it wont be available for purchases and sales, continue deleting?"
                                    ),

                                    actions: [
                                      FlatButton(
                                        child: Text("No"),
                                        onPressed: (){
                                          Navigator.pop(ctx);
                                        },
                                      ),

                                      FlatButton(
                                        child: Text("Yes"),
                                        onPressed: () async {
                                          Navigator.pop(ctx);

                                          String msg = "No response";

                                          if(key.get("pieces") == 0){

                                            Map<String, dynamic> state = await _databaseService.deleteProduct(key.id);

                                            if(state['hasError']){
                                              msg = state['message'];
                                            } else {
                                              msg = key.get("productDescription").toString()+state['message'];
                                            }
                                          } else {
                                            msg = "Make sure the product you want to delete is not in the store.";
                                          }

                                          Fluttertoast.showToast(
                                            msg: msg,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }else{
                                Fluttertoast.showToast(
                                  msg: "No internet connection.",
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  Divider(
                    color: Colors.white,
                  ),
                ],
              );
            }
          ),
        ),
      ],
    );
  }
}