import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';

class Preferences extends StatefulWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final AppColors _appColors = AppColors();
  final DatabaseService _databaseService = DatabaseService();
  final double commissionRate;
  final String roleID;
  final String userID;
  Preferences({this.userID, this.commissionRate, this.roleID});
  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  TextEditingController _commissionController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    _commissionController.text = (widget.commissionRate*100).toString();
    return _isLoading?LoadingWidget("Updating commission rate..."):Container(
      margin: EdgeInsets.only(
        left: FormSpecs.formMargin,
        right: FormSpecs.formMargin,
      ),

      child: ListView(
        children: [
          SizedBox(height: FormSpecs.sizedBoxHeight,),
          //Heading
          Center(
            child: Text(
              "User Settings",
              style: TextStyle(
                color: widget._appColors.getFontColor(),
                fontSize: FormSpecs.formHeaderSize,
              ),
            ),
          ),
          SizedBox(height: FormSpecs.sizedBoxHeight,),

          Form(
            key: widget._globalKey,
            child: Column(
              children: [
                Text(
                  widget.commissionRate.toString()+"%",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                Slider(
                  min: 0,
                  max: 10,
                  divisions: 10,
                  value: widget.commissionRate,
                  onChanged: (val){
                    setState(() {
                      //widget.commissionRate = val;
                    });
                  },
                ),

                // DropdownButtonFormField(
                //   decoration: FormSpecs.textInputDecoration,
                //
                //   items: [
                //     DropdownMenuItem(
                //
                //     ),
                //   ],
                // ),
                SizedBox(height: FormSpecs.sizedBoxHeight,),
                ElevatedButton(
                  style: FormSpecs.btnStyle,

                  child: Text(
                    "Change Commission Rate",
                  ),

                  onPressed: () async {
                    bool hasConnection = await DataConnectionChecker().hasConnection;

                    if(hasConnection){
                      Map<String, dynamic> state = {
                        'hasError':false,
                        'message':"",
                      };
                      setState(() {
                        _isLoading = true;
                      });
                      state = await widget._databaseService.updateCommissionRate(widget.userID, widget.commissionRate);
                      setState(() {
                        _isLoading = false;
                      });

                      if(state['hasError']){
                        var error = state['message'].toString().split(']');
                        state['message'] = error[1];
                      }

                      SnackBar snackBar = CustomSnackBar(message: state['message']).getSnackBar(context);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }else{
                      SnackBar snackBar = CustomSnackBar(message: "No internet connection.").getSnackBar(context);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
