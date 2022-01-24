import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dropdown_date_picker/dropdown_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/custom_widgets/NoItemsFound.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:provider/provider.dart';

class ModViewSales extends StatefulWidget {
  final AppColors _appColors = AppColors();
  final DatabaseService _databaseService = DatabaseService();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final DateTime _dateTime = DateTime.now().toUtc();

  @override
  _ModViewSalesState createState() => _ModViewSalesState();
}

class _ModViewSalesState extends State<ModViewSales> {
  String _selectedFilter;
  String _parameter;
  bool _isLoading = false;


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

    return Column(
      children: [
        SizedBox(height: FormSpecs.sizedBoxHeight,),

        //Heading
        Expanded(
          flex: 1,
          child: Container(
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

            child: Center(
              child: Text(
                "View Sales",
                style: TextStyle(
                  color: widget._appColors.getFontColor(),
                  fontSize: FormSpecs.formHeaderSize,
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: FormSpecs.sizedBoxHeight,),

        //Searching box
        Container(
          decoration: boxDecoration.copyWith(
            color: widget._appColors.getBoxColor(),
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
                                value: "price",

                                child: Text(
                                  "Price",
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

                        Expanded(
                          flex: 2,
                          child: StreamProvider<QuerySnapshot>.value(
                            initialData: null,
                            value: DatabaseService().getSales,

                            child: StreamBuilder(
                              builder: (context, AsyncSnapshot snapshot){
                                final sales = Provider.of<QuerySnapshot>(context);

                                if(sales == null){
                                  return NoItemsFound("No sales records.");
                                }

                                return RaisedButton(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                      ),
                                      Text(
                                          "Search"
                                      ),
                                    ],
                                  ),

                                  onPressed: (){
                                    if(widget._globalKey.currentState.validate()){
                                      widget._globalKey.currentState.save();
                                      List filteredList = [];
                                      sales.docs.map((doc) {
                                        var pickedDate = _pickedDate.getDate('-').split('-');
                                        DateTime dtPickedDate = DateTime(int.parse(pickedDate[0]), int.parse(pickedDate[1]), int.parse(pickedDate[2]));
                                        //print("picked"+dtPickedDate.toString());

                                        Timestamp temp = doc.get("createdAt");
                                        DateTime dateTimeCreated = DateTime.fromMillisecondsSinceEpoch(temp.millisecondsSinceEpoch);
                                        DateTime dateCreated = DateTime(dateTimeCreated.year, dateTimeCreated.month, dateTimeCreated.day);

                                        int result = dtPickedDate.compareTo(dateCreated);

                                        if(result < 0){
                                          print("before");
                                        } else if(result > 0){
                                          print("after");
                                        } else {
                                          if(doc.get(_selectedFilter).toString().toUpperCase().contains(_parameter) || doc.get(_selectedFilter).toString().toLowerCase().contains(_parameter) || doc.get(_selectedFilter).toString().contains(_parameter)){

                                            filteredList.add(doc);
                                          }
                                        }
                                        //print("created"+dateCreated.toString());

                                      }).toList();


                                    }
                                  },
                                );
                              },
                            ),
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

        //Sales List
        Expanded(
          flex: 11,

          child: StreamBuilder(
            stream: DatabaseService().getSales,

            builder: (context, snap){
              if(snap.hasData){
                QuerySnapshot sales = snap.data;

                return ListView.builder(
                    itemCount: sales.docs.length,
                    itemBuilder: (BuildContext context, int index){
                      QueryDocumentSnapshot sale = sales.docs.elementAt(index);
                      Timestamp createdAt = sale.get("createdAt");
                      int year = createdAt.toDate().year;
                      int month = createdAt.toDate().month;
                      int day = createdAt.toDate().day;
                      String dateCreated = day.toString()+"/"+month.toString()+"/"+year.toString();
                      String _userNames;
                      // widget._users.docs.map((user) {
                      //   if(user.id.toString() == key.get("addedBy")){
                      //     _userNames = user.get("lastName")+","+user.get("firstName")+" "+user.get("middleName");
                      //   }
                      // }).toList();
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              sale.get("productName"),
                              style: TextStyle(
                                color: widget._appColors.getTileTitleColor(),
                                //backgroundColor: Colors.white
                              ),
                            ),

                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Quantity: "+sale.get("quantity").toString(),
                                    style: TextStyle(
                                      color: widget._appColors.getTileSubtitleColor(),
                                      //backgroundColor: Colors.black
                                    ),
                                  ),

                                  Text(
                                    "Price: "+sale.get("amount").toString(),
                                    style: TextStyle(
                                      color: widget._appColors.getTileSubtitleColor(),
                                      //backgroundColor: Colors.black
                                    ),
                                  ),

                                  Text(
                                    "Sub Total: "+sale.get("subTotal").toString(),
                                    style: TextStyle(
                                      color: widget._appColors.getTileSubtitleColor(),
                                      //backgroundColor: Colors.black
                                    ),
                                  ),

                                  Text(
                                    "Commission: "+sale.get("commission").toString(),
                                    style: TextStyle(
                                      color: widget._appColors.getTileSubtitleColor(),
                                      //backgroundColor: Colors.black
                                    ),
                                  ),

                                  StreamProvider<QuerySnapshot>.value(
                                    initialData: null,
                                    value: DatabaseService().getUsers,

                                    child: StreamBuilder(
                                      builder: (context, AsyncSnapshot snapshot){
                                        final users = Provider.of<QuerySnapshot>(context);

                                        if(users == null){
                                          return NoItemsFound("Tried to fetch users...");
                                        }

                                        if(users.docs.isEmpty){
                                          return NoItemsFound("No users records.");
                                        }

                                        String userNames;
                                        users.docs.map((user){
                                          if(sale.get("addedBy").toString() == user.id){
                                            userNames = user.get("lastName")+", "+user.get("firstName")+" "+user.get("middleName");
                                          }
                                        }).toList();

                                        return Text(
                                          "Added by: "+userNames,
                                          style: TextStyle(
                                            color: widget._appColors.getTileSubtitleColor(),
                                            //backgroundColor: Colors.black
                                          ),
                                        );
                                      },
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

                            trailing: FlatButton(
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
                                            "Deleting Sale!",
                                          )
                                        ],
                                      ),
                                      content: Text(
                                        "You are about to delete a sale record!",
                                      ),

                                      actions: [
                                        FlatButton(
                                          child: Text("Cancel"),
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                        ),

                                        FlatButton(
                                          child: Text("Ok"),

                                          onPressed: () async {

                                            Navigator.pop(context);

                                            Map<String, dynamic> state = await widget._databaseService.deleteSale(sale.id);

                                            Fluttertoast.showToast(msg: state['msg']);
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

                          Divider(
                            color: Colors.white,
                          ),
                        ],
                      );
                    }
                );
              } else if(snap.hasError){
                return NoItemsFound(snap.error);
              }

              return NoItemsFound("No sales records.");
            },
          ),
        ),
      ],
    );
  }
}