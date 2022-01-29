import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dropdown_date_picker/dropdown_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/custom_widgets/NoItemsFound.dart';
import 'package:vitality_hygiene_products/models/LoggedInUser.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';

class ModViewPurchases extends StatefulWidget {
  final AppColors _appColors = AppColors();
  final DatabaseService _databaseService = DatabaseService();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final QuerySnapshot _users;
  final DateTime _dateTime = DateTime.now().toUtc();


  ModViewPurchases(this._users);
  @override
  _ModViewPurchasesState createState() => _ModViewPurchasesState();
}

class _ModViewPurchasesState extends State<ModViewPurchases> {
  String _selectedFilter;
  String _parameter;


  @override
  Widget build(BuildContext context) {
    DropdownDatePicker _pickedDate = DropdownDatePicker(
      firstDate: ValidDate(
        year: widget._dateTime.year,
        month: widget._dateTime.month,
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
      return NoItemsFound("Getting purchases...");
    }

    return purchases.docs.isEmpty?NoItemsFound("No purchases records."):ListView(
      children: [
        Container(
          decoration: boxDecoration.copyWith(
            color: widget._appColors.getBoxColor(),
          ),
          margin: EdgeInsets.all(
            FormSpecs.formMargin
          ),
          padding: EdgeInsets.all(
            titleBoxPadding
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

        Container(
          decoration: boxDecoration.copyWith(
            color: widget._appColors.getBoxColor(),
          ),
          margin: EdgeInsets.only(
            left: FormSpecs.formMargin,
            right: FormSpecs.formMargin,
            bottom: FormSpecs.formMargin,
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
                            value: _selectedFilter,

                            items: [
                              DropdownMenuItem(
                                value: "productName",

                                child: Text(
                                  "Product Name",
                                ),
                              ),

                              DropdownMenuItem(
                                value: "addedBy",

                                child: Text(
                                  "Added By",
                                ),
                              ),
                            ],

                            onChanged: (val){
                              _selectedFilter = val;
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

                            onSaved: (val){
                              _parameter = val;
                            },
                          ),
                        ),

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

        Container(
          //color: Colors.red,
          height: MediaQuery.of(context).size.height*0.39,
          child: ListView.builder(
              itemCount: purchases.docs.length,
              itemBuilder: (BuildContext context, int index){
                QueryDocumentSnapshot key = purchases.docs.elementAt(index);
                Timestamp createdAt = key.get("createdAt");
                int year = createdAt.toDate().year;
                int month = createdAt.toDate().month;
                int day = createdAt.toDate().day;
                String dateCreated = day.toString()+"/"+month.toString()+"/"+year.toString();
                String _userNames;
                bool isCurrentUserPurchase = false;

                widget._users.docs.map((user) {
                  if(user.id.toString() == key.get("addedBy")){
                    _userNames = user.get("lastName")+","+user.get("firstName")+" "+user.get("middleName");
                  }

                  if(LoggedInUser.getUID() == key.get("addedBy")){
                    isCurrentUserPurchase = true;
                  }
                }).toList();

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
                              "Added by: "+_userNames,
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

                      trailing: (!isCurrentUserPurchase)?Container(height: 0.0,width:0.0,):StreamProvider<QuerySnapshot>.value(
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
                                        String unit = "pieces";
                                        DateTime updatedAt = DateTime.now().toUtc();

                                        widget._databaseService.reduceStoreQuantity(pid: key.get("productID"), quantity: quantity, updatedAt: updatedAt);

                                        SnackBar snackBar=CustomSnackBar(message: "Purchase was deleted successfully.").getSnackBar(context);
                                        Scaffold.of(context).showSnackBar(snackBar);
                                      },
                                    )
                                  ],
                                ),
                              );
                            }else{
                              SnackBar snackBar=CustomSnackBar(message: "No internet connection.").getSnackBar(context);
                              Scaffold.of(context).showSnackBar(snackBar);
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
      ],
    );
  }
}