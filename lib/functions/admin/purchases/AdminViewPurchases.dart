import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dropdown_date_picker/dropdown_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/custom_widgets/NoItemsFound.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:provider/provider.dart';

class AdminViewPurchases extends StatefulWidget {
  final AppColors _appColors = AppColors();
  final DatabaseService _databaseService = DatabaseService();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final DateTime _dateTime = DateTime.now().toUtc();

  @override
  _AdminViewPurchasesState createState() => _AdminViewPurchasesState();
}

class _AdminViewPurchasesState extends State<AdminViewPurchases> {
  String _query;
  String _parameter;

  @override
  Widget build(BuildContext context) {
    DropdownDatePicker _pickedDate = DropdownDatePicker(
      firstDate: ValidDate(
        year: widget._dateTime.year,
        month: 1,
        day: 1,
      ),

      lastDate: ValidDate(
        year: widget._dateTime.year,
        month: widget._dateTime.month,
        day: widget._dateTime.day,
      ),

      initialDate: NullableValidDate(
        year: widget._dateTime.year,
        month: widget._dateTime.month,
        day: widget._dateTime.day,
      ),
    );

    final purchases = Provider.of<QuerySnapshot>(context);

    if(purchases == null){
      return LoadingWidget("");
    }

    return purchases.docs.isEmpty?NoItemsFound("No purchases records."):
      Column(
        children: [
          SizedBox(height: FormSpecs.sizedBoxHeight,),

          Expanded(
            flex: 2,
            child: Container(
              decoration: boxDecoration.copyWith(
                color: widget._appColors.getBoxColor()
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
                  "View Purchases",
                  style: TextStyle(
                    color: widget._appColors.getFontColor(),
                    fontSize: FormSpecs.formHeaderSize,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: FormSpecs.sizedBoxHeight,),

          Container(
            height: 180.0,
            decoration: boxDecoration.copyWith(
              color: widget._appColors.getBoxColor()
            ),
            margin: EdgeInsets.only(
              left: FormSpecs.formMargin,
              right: FormSpecs.formMargin
            ),
            padding: EdgeInsets.all(
              5.0
            ),
            child: Column(
              children: [
                Form(
                  key: widget._globalKey,
                  child: Column(
                    children: [
                      _pickedDate,

                      Row(
                        children: [
                          SizedBox(width: FormSpecs.sizedBoxWidth,),
                          Expanded(
                            child: DropdownButtonFormField(
                              decoration: FormSpecs.textInputDecoration,

                              hint: Text(
                                "Select search criteria",
                                style: TextStyle(
                                  color: widget._appColors.getFontColor(),
                                ),
                              ),
                              validator: (val){
                                if(val == null){
                                  return "Please select Criteria";
                                }

                                return null;
                              },
                              value: _parameter,

                              items: [
                                DropdownMenuItem(
                                  value: "productDescription",

                                  child: Text(
                                    "Product Description",
                                  ),
                                ),

                                // DropdownMenuItem(
                                //   value: "addedBy",
                                //
                                //   child: Text(
                                //     "Added By",
                                //   ),
                                // ),
                              ],

                              onChanged: (val){
                                _parameter = val;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: FormSpecs.sizedBoxHeight,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width: FormSpecs.sizedBoxWidth,),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              decoration: FormSpecs.textInputDecoration.copyWith(
                                hintText: "John",
                                labelText: "Search",
                              ),

                              autovalidateMode: AutovalidateMode.onUserInteraction,

                              validator: (val){
                                if(val.isEmpty){
                                  return "Please fill key words.";
                                }

                                return null;
                              },

                              onChanged: (val){
                                setState((){_query = val;});
                              },
                            ),
                          ),

                          SizedBox(width: FormSpecs.sizedBoxWidth,),

                          // Expanded(
                          //   flex: 2,
                          //   child: ElevatedButton(
                          //     style: FormSpecs.btnStyle,
                          //
                          //     child: Row(
                          //       children: [
                          //         Icon(
                          //           Icons.search,
                          //         ),
                          //         Text(
                          //             "Search"
                          //         ),
                          //       ],
                          //     ),
                          //
                          //     onPressed: (){
                          //       if(widget._globalKey.currentState.validate()){
                          //         widget._globalKey.currentState.save();
                          //         List filteredList = [];
                          //         purchases.docs.map((doc) {
                          //           var pickedDate = _pickedDate.getDate('-').split('-');
                          //           DateTime dtPickedDate = DateTime(int.parse(pickedDate[0]), int.parse(pickedDate[1]), int.parse(pickedDate[2]));
                          //           //print("picked"+dtPickedDate.toString());
                          //
                          //           Timestamp temp = doc.get("createdAt");
                          //           DateTime dateTimeCreated = DateTime.fromMillisecondsSinceEpoch(temp.millisecondsSinceEpoch);
                          //           DateTime dateCreated = DateTime(dateTimeCreated.year, dateTimeCreated.month, dateTimeCreated.day);
                          //
                          //           int result = dtPickedDate.compareTo(dateCreated);
                          //
                          //           if(result < 0){
                          //             print("before");
                          //           } else if(result > 0){
                          //             print("after");
                          //           } else {
                          //             if(doc.get(_selectedFilter).toString().toUpperCase().contains(_parameter) || doc.get(_selectedFilter).toString().toLowerCase().contains(_parameter) || doc.get(_selectedFilter).toString().contains(_parameter)){
                          //
                          //               filteredList.add(doc);
                          //             }
                          //           }
                          //           //print("created"+dateCreated.toString());
                          //
                          //         }).toList();
                          //
                          //         //Navigator.popUntil(context, (route) => false);
                          //         Navigator.push(context, MaterialPageRoute(
                          //           builder: (context) => AdminPurchasesSearch(filteredList: filteredList),
                          //         ));
                          //       }
                          //     },
                          //   ),
                          // ),

                          SizedBox(width: FormSpecs.sizedBoxWidth,),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: FormSpecs.sizedBoxHeight,),
              ],
            ),
          ),

          SizedBox(height: FormSpecs.sizedBoxHeight,),
          StreamProvider<QuerySnapshot>.value(
            initialData: null,
            value: DatabaseService().getUsers,

            child: Expanded(
              flex: 11,
              child: ListView.builder(
                  itemCount: purchases.docs.length,
                  itemBuilder: (BuildContext context, int index){
                    final users = Provider.of<QuerySnapshot>(context);

                    if(users == null){
                      return LoadingWidget(
                        "Please wait..."
                      );
                    }

                    QueryDocumentSnapshot key = purchases.docs.elementAt(index);
                    Timestamp createdAt = key.get("createdAt");
                    int year = createdAt.toDate().year;
                    int month = createdAt.toDate().month;
                    int day = createdAt.toDate().day;
                    String dateCreated = day.toString()+"/"+month.toString()+"/"+year.toString();
                    String userNames;
                    users.docs.map((user) {
                      if(user.id.toString() == key.get("addedBy")){
                        userNames = user.get("lastName")+","+user.get("firstName")+" "+user.get("middleName");
                      }
                    }).toList();

                    // if(
                    //
                    // )
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            key.get("productName"),
                            style: TextStyle(
                              color: widget._appColors.getTileTitleColor(),
                              //backgroundColor: Colors.white
                            ),
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Quantity: "+key.get("quantity").toString()+" "+key.get("unit"),
                                style: TextStyle(
                                  color: widget._appColors.getTileSubtitleColor(),
                                  //backgroundColor: Colors.black
                                ),
                              ),

                              Text(
                                "Price: "+key.get("amount").toString()+" "+key.get("currency"),
                                style: TextStyle(
                                  color: widget._appColors.getTileSubtitleColor(),
                                  //backgroundColor: Colors.black
                                ),
                              ),

                              Text(
                                "Sub Total: "+key.get("subTotal").toString()+" "+key.get("currency"),
                                style: TextStyle(
                                  color: widget._appColors.getTileSubtitleColor(),
                                  //backgroundColor: Colors.black
                                ),
                              ),

                              Text(
                                "Added by: "+userNames.toString(),
                                style: TextStyle(
                                  color: widget._appColors.getTileSubtitleColor(),
                                  //backgroundColor: Colors.black
                                ),
                              ),

                              Text(
                                "Date Added: "+dateCreated,
                                style: TextStyle(
                                  color: widget._appColors.getTileSubtitleColor(),
                                  //backgroundColor: Colors.black
                                ),
                              ),
                            ]
                          ),

                          trailing: StreamProvider<QuerySnapshot>.value(
                            initialData: null,
                            value: DatabaseService().store,
                            child: TextButton(
                              child: Icon(Icons.highlight_remove),

                              onPressed: () async {
                                bool _hasConnection = await DataConnectionChecker().hasConnection;

                                if(_hasConnection){
                                  showDialog(
                                    context: context,
                                    builder:(context) => AlertDialog(
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.info,
                                            color: Colors.yellow,
                                          ),
                                          Text(
                                            "Deleting purchase!",
                                          )
                                        ],
                                      ),
                                      content: Text(
                                        "You are about to delete purchase record!",
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text("Cancel"),
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                        ),

                                        TextButton(
                                          child: Text("Ok"),
                                          onPressed: (){
                                            Navigator.pop(context);
                                            widget._databaseService.deletePurchase(key.id);

                                            int quantity = key.get("quantity");
                                            //String unit = " ";
                                            DateTime updatedAt = DateTime.now().toUtc();

                                            // if(measurement[1] == "piece(s)"){
                                            //   unit = "pieces";
                                            // } else if(measurement[1] == "dozen(s)"){
                                            //   unit = "dozens";
                                            // } else if(measurement[1] == "carton(s)"){
                                            //   unit = "cartons";
                                            // }

                                            widget._databaseService.reduceStoreQuantity(pid: key.get("productID"), quantity: quantity, updatedAt: updatedAt);

                                            Fluttertoast.showToast(msg: "Purchase was deleted successfully.");
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }else{
                                  SnackBar snackBar=CustomSnackBar(message: "No internet connection.").getSnackBar(context);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
                            ),
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
          ),
        ],
      );
  }
}