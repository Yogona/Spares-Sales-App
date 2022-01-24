
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';

class AddPurchases extends StatefulWidget {
  @override
  _AddPurchasesState createState() => _AddPurchasesState();
}

class _AddPurchasesState extends State<AddPurchases> {
  final AppColors _appColors = AppColors();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();
  
  //Variables
  String _selectedProduct;
  String _selectedUnit = "piece(s)";
  String _selectedCurrency = "TZS";
  int _quantity;
  int _amount;
  String _error = " ";
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<QuerySnapshot>(context);
    final topSpace = MediaQuery.of(context).size.height*0.15;

    if(store == null){
      return LoadingWidget("Please wait...");
    }

    return _loading?LoadingWidget("Adding purchase..."):
       ListView(
         children: [
           SizedBox(height: topSpace,),

           Container(
             decoration: boxDecoration.copyWith(
               color: _appColors.getBoxColor()
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
                 "Add Purchase",
                 style: TextStyle(
                   color: _appColors.getFontColor(),
                   fontSize: FormSpecs.formHeaderSize,
                 ),
               ),
             ),
           ),

           SizedBox(height: FormSpecs.sizedBoxHeight,),

           Container(
             decoration: boxDecoration.copyWith(
               color: _appColors.getBoxColor()
             ),
             margin: EdgeInsets.only(
               left: FormSpecs.formMargin,
               right: FormSpecs.formMargin
             ),
             padding: EdgeInsets.all(
               5.0
             ),
             child: Form(
               key: _globalKey,
               child: Column(
                 children: [
                   DropdownButtonFormField(
                     decoration: FormSpecs.textInputDecoration,

                     autovalidateMode: AutovalidateMode.onUserInteraction,

                     hint: Text(
                       "Select product.",
                       style: TextStyle(
                         color: _appColors.getFontColor(),
                       ),
                     ),

                     value: _selectedProduct,

                     items: store.docs.map((product) {
                         return DropdownMenuItem(
                           value: product.id.toString(),

                           child: Text(
                             "${product.get("productDescription")} - ${product.get('price')}",
                             style: TextStyle(
                               color: _appColors.getFontColor(),
                             ),
                           ),
                         );
                       }
                     ).toList(),

                     validator: (val){
                       if(val == null){
                         return "Please select product.";
                       }

                       return null;
                     },

                     onChanged: (val){
                       setState(() {
                         _selectedProduct = val;
                       });
                     },
                   ),

                   SizedBox(height: FormSpecs.sizedBoxHeight,),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Expanded(
                         flex: 1,
                         child: TextFormField(
                           autovalidateMode: AutovalidateMode.onUserInteraction,

                           decoration: FormSpecs.textInputDecoration.copyWith(
                             labelText: "Quantity.",
                             hintText: "20",
                           ),

                           keyboardType: TextInputType.number,

                           inputFormatters: [
                             FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                           ],

                           validator: (String val){
                             if(val.isEmpty){
                               return "Required!";
                             }

                             return null;
                           },

                           onSaved: (val){
                               setState(() {
                                 _quantity = int.parse(val);
                               }
                             );
                           },
                         ),
                       ),

                       SizedBox(width: FormSpecs.sizedBoxWidth,),

                       Expanded(
                         flex: 1,
                         child: DropdownButtonFormField(
                           decoration: FormSpecs.textInputDecoration,

                           autovalidateMode: AutovalidateMode.onUserInteraction,

                           // hint: Text(
                           //   "Select unit.",
                           //   style: TextStyle(
                           //     color: _appColors.getFontColor(),
                           //   ),
                           // ),

                           value: _selectedUnit,

                           items: [
                             // DropdownMenuItem(
                             //   value: "carton(s)",
                             //
                             //   child: Text(
                             //     "carton(s)",
                             //     style: TextStyle(
                             //       color: _appColors.getFontColor(),
                             //     ),
                             //   ),
                             // ),

                             // DropdownMenuItem(
                             //   value: "dozen(s)",
                             //
                             //   child: Text(
                             //     "dozen(s)",
                             //     style: TextStyle(
                             //       color: _appColors.getFontColor(),
                             //     ),
                             //   ),
                             // ),

                             DropdownMenuItem(
                               value: "piece(s)",

                               child: Text(
                                 "piece(s)",
                                 style: TextStyle(
                                   color: _appColors.getFontColor(),
                                 ),
                               ),
                             ),
                           ],

                           validator: (String val){
                             if(val == null){
                               return "Please select unit.";
                             }

                             return null;
                           },

                           onChanged: (val){
                             setState(() {
                               _selectedUnit = val;
                             });
                           },
                         ),
                       ),
                     ],
                   ),

                   SizedBox(height: FormSpecs.sizedBoxHeight,),

                   Row(
                     children: [
                       Expanded(
                         flex: 4,
                         child: TextFormField(
                           autovalidateMode: AutovalidateMode.onUserInteraction,

                           decoration: FormSpecs.textInputDecoration.copyWith(
                             labelText: "Price for each.",
                             hintText: "5000",
                           ),

                           keyboardType: TextInputType.number,

                           inputFormatters: [
                             FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                           ],

                           validator: (String val){
                             if(val.isEmpty){
                               return "Please input price.";
                             }

                             return null;
                           },

                           onSaved: (val){
                             setState(() {
                               _amount = int.parse(val);
                             });
                           },
                         ),
                       ),

                       SizedBox(width: FormSpecs.sizedBoxWidth,),

                       Expanded(
                         flex: 3,
                         child: DropdownButtonFormField(
                           decoration: FormSpecs.textInputDecoration,

                           value: _selectedCurrency,
                           items: [
                             DropdownMenuItem(
                               value: "TZS",
                               child: Text(
                                 "TZS",
                                 style: TextStyle(
                                   color: _appColors.getFontColor(),
                                 ),
                               ),
                             ),
                           ],

                           onChanged: (val){
                             _selectedCurrency = "TZS";
                           },
                         ),
                       ),
                     ],
                   ),

                   SizedBox(height: FormSpecs.sizedBoxHeight,),

                   ElevatedButton(
                     style: ButtonStyle(
                       backgroundColor: MaterialStateProperty.all(
                         _appColors.getFontColor()
                       ),

                       shape: MaterialStateProperty.all(
                         RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(
                             FormSpecs.txtFieldBorderRadius
                           ),
                         )
                       ),
                     ),

                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Icon(Icons.add),

                         Text(
                           "Add Purchase",
                         ),
                       ],
                     ),

                     onPressed: () async {
                       if(_globalKey.currentState.validate()){
                         _globalKey.currentState.save();
                         DateTime dateTime = DateTime.now().toUtc();
                         String unit;
                         String productCode;
                         String productDescription;
                         int totalQuantity=0;
                         int subTotal = _quantity * _amount;
                         SnackBar snackBar;
                         Map<String, dynamic> state = {
                           'hasError':false,
                           'message':" ",
                         };
                         bool _hasConnection = await DataConnectionChecker().hasConnection;

                         if(_hasConnection){

                           store.docs.map((product) {
                             if(product.id.toString() == _selectedProduct){
                               productCode = product.get("productCode");
                               productDescription = product.get("productDescription");

                               if(_selectedUnit == "piece(s)"){
                                 totalQuantity = _quantity + product.get("pieces");
                                 unit = "pieces";
                                }// else if(_selectedUnit == "dozen(s)"){
                               //   totalQuantity = _quantity + product.get("dozens");
                               //   unit = "dozens";
                               // } else if(_selectedUnit == "carton(s)"){
                               //   totalQuantity = _quantity + product.get("cartons");
                               //   unit = "cartons";
                               // }
                             }
                           }).toList();

                           setState(() {
                             _loading = true;
                           });

                           state = await _databaseService.addPurchase(
                               productCode,
                               productDescription,
                               _quantity,
                               _selectedUnit,
                               _amount,
                               subTotal,
                               _selectedCurrency,
                               _selectedProduct,
                               dateTime
                           );

                           if(state['hasError']){
                             setState(() {
                               _error = state['message'];
                             });
                           }else{
                             snackBar = CustomSnackBar(message: state['message']).getSnackBar(context);
                             Scaffold.of(context).showSnackBar(snackBar);

                             state = await _databaseService.updateStoreQuantity(
                                 _selectedProduct,
                                 unit,
                                 totalQuantity,
                                 dateTime
                             );

                             setState(() {
                               _loading = false;
                             });

                             if(state['hasError']){
                               setState(() {
                                 _error = state['message'];
                               });
                             }else{
                               snackBar = CustomSnackBar(message: state['message']).getSnackBar(context);
                               Scaffold.of(context).showSnackBar(snackBar);
                             }
                           }
                         }else{
                           snackBar = CustomSnackBar(message: "No internet connection.").getSnackBar(context);
                           Scaffold.of(context).showSnackBar(snackBar);
                         }
                       }
                     },
                   ),

                   SizedBox(height: FormSpecs.sizedBoxHeight,),

                   Text(
                     _error,
                     style: TextStyle(
                       color: Colors.red,
                     ),
                   )
                 ],
               ),
             ),
           ),
         ],
       );
  }
}