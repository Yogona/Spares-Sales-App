import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';

class AddProducts extends StatefulWidget {
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final AppColors _appColors = AppColors();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();

  Map<String, dynamic> _feedback = {
    'hasError':false,
    'message':" ",
  };

  //Controllers
  TextEditingController _productNameController        = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();

  //Variables
  String _error = "";
  String _productCode;
  String _productDescription;
  String _price;
  bool _loading = false;

  // //Normal variables
  // String _barcodeNumbers;
  //
  // //Controllers
  // TextEditingController _barcodeController = TextEditingController();
  //
  // Future scanBarcode() async {
  //   try{
  //     _barcodeNumbers = await FlutterBarcodeScanner.scanBarcode(_appColors.getScanningColor(), "Cancel", true, ScanMode.BARCODE);
  //     setState((){
  //       _barcodeController.text = _barcodeNumbers;
  //     });
  //   }catch(e){
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return _loading ? LoadingWidget("Adding product...") :
       Column(
         mainAxisAlignment: MainAxisAlignment.center,

        children: [
          SizedBox(height: 20,),

          //Heading
          Center(
            child: Text(
              "Add Product",
              style: TextStyle(
                color: _appColors.getFontColor(),
                fontSize: FormSpecs.formHeaderSize,
              ),
            ),
          ),

          SizedBox(height: FormSpecs.sizedBoxHeight,),

          Container(
            margin: EdgeInsets.only(
              left: FormSpecs.formMargin,
              right: FormSpecs.formMargin,
            ),

            padding: EdgeInsets.all(
              5.0
            ),

            decoration: boxDecoration.copyWith(
              color: _appColors.getBoxColor()
            ),

            child: Form(
              key: _globalKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: FormSpecs.textInputDecoration.copyWith(
                      labelText: "Product Code",
                      hintText: "Product serial number.",
                    ),

                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                      //FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],

                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    validator: (val){
                      if(val.isEmpty){
                        return "Please enter valid product code.";
                      } else if(val.startsWith(RegExp('[ ]'))){
                        return "Product code can't start with a space.";
                      }

                      return null;
                    },

                    controller: _productNameController,

                    onSaved: (val){
                      _productCode = val;
                    },
                  ),

                  SizedBox(height: FormSpecs.sizedBoxHeight,),

                  TextFormField(
                    decoration: FormSpecs.textInputDecoration.copyWith(
                      labelText: "Description",
                      hintText: "Name of the product.",
                    ),

                    //expands: true,
                    maxLines: 3,

                    controller: _productDescriptionController,

                    validator: (val){
                      if(val.isEmpty){
                        return "Description is required.";
                      }

                      return null;
                    },

                    onSaved: (val){
                      _productDescription = val;
                    },
                  ),

                  SizedBox(height: FormSpecs.sizedBoxHeight,),

                  TextFormField(
                    decoration: FormSpecs.textInputDecoration.copyWith(
                      labelText: "Price",
                      hintText: "Price tag of the product for sale.",
                    ),

                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    validator: (val){
                      if(val.isEmpty){
                        return "Price is required.";
                      } else if(val.startsWith('0')){
                        return "Don't start with zero.";
                      }

                      return null;
                    },

                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],

                    onChanged: (val){
                      _price = val;
                    },
                  ),

                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        _appColors.getFontColor()
                      ),

                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              FormSpecs.txtFieldBorderRadius
                            )
                          ),
                        )
                      ),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_business),

                        const Text("Add Product"),
                      ],
                    ),

                    onPressed: () async {
                      if(_globalKey.currentState.validate()){
                        bool _hasConnection = await DataConnectionChecker().hasConnection;

                        if(_hasConnection){
                          _globalKey.currentState.save();

                          setState(() {
                            _loading = true;
                          });

                          DateTime dateTime = DateTime.now().toUtc();
                          _feedback = await _databaseService.addProduct(_productCode, _productDescription, _price, dateTime);

                          if(_feedback['hasError']){
                            setState(() {
                              _error = _feedback['message'];
                            });
                          }else{
                            SnackBar sb =  CustomSnackBar(message: "Product was added to the store.").getSnackBar(context);
                            ScaffoldMessenger.of(context).showSnackBar(sb);
                            setState(() {
                              _productNameController.text = "";
                              _productDescriptionController.text = "";
                            });
                          }

                          setState(() {
                            _loading = false;
                          });
                        }else{
                          SnackBar sb = CustomSnackBar(message: "No internet connection.").getSnackBar(context);
                          ScaffoldMessenger.of(context).showSnackBar(sb);
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
                  ),

                  // SizedBox(height: FormSpecs.sizedBoxHeight,),
                  // SizedBox(height: FormSpecs.sizedBoxHeight,),
                  //
                  // Center(
                  //   child: Text(
                  //     "Add Measurement",
                  //     style: TextStyle(
                  //       color: _appColors.getFontColor(),
                  //       fontSize: FormSpecs.formHeaderSize,
                  //     ),
                  //   ),
                  // ),
                  //
                  // SizedBox(height: FormSpecs.sizedBoxHeight,),
                  //
                  // TextFormField(
                  //   decoration: FormSpecs.textInputDecoration.copyWith(
                  //     labelText: "Measurement",
                  //     hintText: "km",
                  //   ),
                  // ),
                ],
              ),
            ),
          )
      ],
    );
  }
}