import 'package:dropdown_date_picker/dropdown_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';

class AddCosts extends StatefulWidget {
  final AppColors _appColors = AppColors();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();
  final DateTime _now = DateTime.now().toUtc();

  @override
  _AddCostsState createState() => _AddCostsState();
}

class _AddCostsState extends State<AddCosts> {
  //Instance variables
  String _errorTxt = "";
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    //variables

    String _selectedCurrency = "TZS";
    int _transportCost;
    int _loadingCost;
    int _unloadingCost;

    DropdownDatePicker _dropdownDate = DropdownDatePicker(
      firstDate: ValidDate(
        year: widget._now.year,
        month: 1,
        day: 1,
      ),

      lastDate: ValidDate(
        year: widget._now.year,
        month: widget._now.month,
        day: widget._now.day,
      ),

      initialDate: NullableValidDate(
        year: widget._now.year,
        month: widget._now.month,
        day: widget._now.day,
      ),
    );


    return _isLoading?LoadingWidget("Adding costs record..."):Container(
      margin: EdgeInsets.only(
        left: FormSpecs.formMargin,
        right: FormSpecs.formMargin,
      ),

      child: Column(
        children: [
          SizedBox(height: FormSpecs.sizedBoxHeight,),

          Text(
            "Add Cost",
            style: TextStyle(
              fontSize: FormSpecs.formHeaderSize,
              color: widget._appColors.getFontColor(),
            ),
          ),

          SizedBox(height: FormSpecs.sizedBoxHeight,),

          Expanded(
            child: Container(
              //color: Colors.red,
              height: 450,
              child: Form(
                key: widget._globalKey,

                child: ListView(
                  children: [
                    _dropdownDate,

                    SizedBox(height: FormSpecs.sizedBoxHeight,),

                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            decoration: FormSpecs.textInputDecoration.copyWith(
                              labelText: "Transport",
                              hintText: "100000",
                            ),

                            keyboardType: TextInputType.number,

                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            ],

                            validator: (val){
                              if(val.isEmpty){
                                return "Please input a valid amount.";
                              }
                              return null;
                            },

                            onSaved: (amount){
                              _transportCost = int.parse(amount);
                            },
                          ),
                        ),

                        Expanded(flex: 1,child: SizedBox(width: FormSpecs.sizedBoxWidth,)),

                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField(
                            value: _selectedCurrency,
                            items: [
                              DropdownMenuItem(
                                value: _selectedCurrency,
                                child: Text(
                                  _selectedCurrency,
                                  style: TextStyle(
                                    color: widget._appColors.getFontColor(),
                                  ),
                                ),
                              ),
                            ],

                            onChanged: (val){
                              print("changing currency");
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: FormSpecs.sizedBoxHeight,),

                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            decoration: FormSpecs.textInputDecoration.copyWith(
                              labelText: "Loading",
                              hintText: "50000",
                            ),

                            keyboardType: TextInputType.number,

                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            ],

                            validator: (val){
                              if(val.isEmpty){
                                return "Please input a valid amount.";
                              }
                              return null;
                            },

                            onSaved: (amount){
                              _loadingCost = int.parse(amount);
                            },
                          ),
                        ),

                        Expanded(flex: 1,child: SizedBox(width: FormSpecs.sizedBoxWidth,)),

                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField(
                            value: _selectedCurrency,
                            items: [
                              DropdownMenuItem(
                                value: _selectedCurrency,
                                child: Text(
                                  _selectedCurrency,
                                  style: TextStyle(
                                    color: widget._appColors.getFontColor(),
                                  ),
                                ),
                              ),
                            ],

                            onChanged: (val){
                              print("changing currency");
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: FormSpecs.sizedBoxHeight,),

                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            decoration: FormSpecs.textInputDecoration.copyWith(
                              labelText: "Unloading",
                              hintText: "50000",
                            ),

                            keyboardType: TextInputType.number,

                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            ],

                            validator: (val){
                              if(val.isEmpty){
                                return "Please input a valid amount.";
                              }
                              return null;
                            },

                            onSaved: (amount){
                              _unloadingCost = int.parse(amount);
                            },
                          ),
                        ),

                        Expanded(flex: 1,child: SizedBox(width: FormSpecs.sizedBoxWidth,)),

                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField(
                            value: _selectedCurrency,
                            items: [
                              DropdownMenuItem(
                                value: _selectedCurrency,
                                child: Text(
                                  _selectedCurrency,
                                  style: TextStyle(
                                    color: widget._appColors.getFontColor(),
                                  ),
                                ),
                              ),
                            ],

                            onChanged: (val){
                              print("changing currency");
                            },
                          ),
                        ),
                      ],
                    ),

                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          widget._appColors.getFontColor()
                        ),

                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              FormSpecs.txtFieldBorderRadius
                            )
                          )
                        )
                      ),

                      child: Text("Submit"),

                      onPressed: () async {
                        if(widget._globalKey.currentState.validate()){
                          widget._globalKey.currentState.save();

                          DateTime date = DateTime(
                            _dropdownDate.year,
                            _dropdownDate.month,
                            _dropdownDate.day,
                          );

                          Map<String, dynamic> state = {
                            'hasError':false,
                            'message':"",
                          };
                          setState(() {
                            _isLoading = true;
                          });

                          state = await widget._databaseService.saveCosts(date, _transportCost, _loadingCost, _unloadingCost, _selectedCurrency);

                          setState(() {
                            _isLoading = false;
                          });

                          if(state['hasError']){
                            setState(() {
                              _errorTxt = state['message'];
                            });
                          }else{
                            SnackBar snackBar = CustomSnackBar(message: state['message']).getSnackBar(context);
                            Scaffold.of(context).showSnackBar(snackBar);
                          }

                        }
                      },
                    ),

                    SizedBox(height: FormSpecs.sizedBoxHeight,),

                    Text(
                      _errorTxt,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
