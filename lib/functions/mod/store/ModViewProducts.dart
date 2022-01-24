import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/custom_widgets/NoItemsFound.dart';
import 'package:vitality_hygiene_products/models/LoggedInUser.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/shared/General.dart';

class ModViewProducts extends StatefulWidget {
  @override
  _ModViewProductsState createState() => _ModViewProductsState();
}

class _ModViewProductsState extends State<ModViewProducts> {
  final AppColors _appColors = AppColors();
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<QuerySnapshot>(context);

    if(products == null){
      return NoItemsFound("No products records.");
    }

    return products.docs.isEmpty?NoItemsFound("No products records."):ListView(
      children: [
        SizedBox(height: FormSpecs.sizedBoxHeight,),

        Center(
          child: Text(
            "View Products",
            style: TextStyle(
              color: _appColors.getFontColor(),
              fontSize: FormSpecs.formHeaderSize,
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

                // year = createdStamp.toDate().year;
                // month = createdStamp.toDate().month;
                // day = createdStamp.toDate().day;
                // String dateUpdated = day.toString()+"/"+month.toString()+"/"+year.toString();

                return Column(
                  children: [
                    StreamProvider<QuerySnapshot>.value(
                      initialData: null,
                      value: DatabaseService().getUsers,
                      
                      child: StreamBuilder(
                        builder: (context, AsyncSnapshot snapshot){
                          final users = Provider.of<QuerySnapshot>(context);

                          if(users == null){
                            return NoItemsFound("No users records.");
                          }

                          String userName = "";
                          String roleName = "";

                          users.docs.map((user) {
                            if(key.get("addedBy").toString() == user.id){
                              userName = user.get("lastName").toString()+", "+user.get("firstName").toString()+" "+user.get("middleName").toString();
                              // General.roles.docs.map((role) {
                              //   if(role.id == user.get("roleID").toString()){
                              //     roleName = role.get("role");
                              //   }
                              // }).toList();
                            }
                          }).toList();

                          return ListTile(
                            title: Text(
                              key.get("productCode"),
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

                                // Text(
                                //   "Dozens: "+key.get("dozens").toString(),
                                //   style: TextStyle(
                                //     color: _appColors.getTileSubtitleColor(),
                                //     //backgroundColor: Colors.black
                                //   ),
                                // ),
                                //
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

                            trailing: (!(key.get("addedBy").toString() == LoggedInUser.getUID()))?Container(height: 0.0,width: 0.0,):FlatButton(
                              child: Icon(Icons.highlight_remove),

                              onPressed: () async {

                                bool hasConnection = await DataConnectionChecker().hasConnection;

                                if(hasConnection){
                                  showDialog(
                                    context: context,
                                    builder: (context) =>  AlertDialog(
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
                                            Navigator.pop(context);
                                          },
                                        ),

                                        FlatButton(
                                          child: Text("Yes"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _databaseService.deleteProduct(key.id);
                                            SnackBar snackBar = CustomSnackBar(message: "'${key.get("productName")}' was deleted successfully.").getSnackBar(context);
                                            Scaffold.of(context).showSnackBar(snackBar);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }else{
                                  SnackBar snackBar=CustomSnackBar(message: "No internet connection.").getSnackBar(context);
                                  Scaffold.of(context).showSnackBar(snackBar);
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