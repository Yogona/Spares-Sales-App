import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';

class Password extends StatefulWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final AppColors _appColors = AppColors();
  final DatabaseService _databaseService = DatabaseService();

  final Function togglePassword;
  //final Function toggle

  Password({this.togglePassword});
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  TextEditingController _commissionController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back
          ),

          onPressed: (){
            widget.togglePassword();
          },
        ),

        title: Text(
          "Change Password"
        ),
      ),

      body: _isLoading?LoadingWidget("Updating commission rate..."):Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.only(
            left: FormSpecs.formMargin,
            right: FormSpecs.formMargin,
          ),

          // color: ,

          decoration: boxDecoration,

          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: FormSpecs.textInputDecoration,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
