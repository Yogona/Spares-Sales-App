import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/models/FeedBack.dart';
import 'package:vitality_hygiene_products/services/AuthService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';

class Password extends StatefulWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final AppColors _appColors = AppColors();
  final AuthService _auth = AuthService();

  final Function togglePassword;
  //final Function toggle

  final String email;

  Password({this.email, this.togglePassword});
  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  TextEditingController _emailCrl = TextEditingController();
  //String _oldPassword;
  String _newPassword;
  //String _confirmPassword;
  String _error;

  bool _isSendEmail = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _emailCrl.text = widget.email;
    _error = "";

    return Scaffold(
      appBar: AppBar(
        leading: (widget.togglePassword == null)?null:IconButton(
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

      body: _isLoading?LoadingWidget("Please wait..."):
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,

            child: Container(
              margin: EdgeInsets.only(
                left: FormSpecs.formMargin,
                right: FormSpecs.formMargin,
              ),

              padding: EdgeInsets.all(
                5.0
              ),

              decoration: boxDecoration.copyWith(
                color: widget._appColors.getBoxColor(),
              ),

              child: (_isSendEmail)?Form(
                child: Column(
                  children: [
                    SizedBox(height: FormSpecs.sizedBoxHeight,),

                    TextFormField(
                      decoration: FormSpecs.textInputDecoration.copyWith(
                        label: Text(
                          "Email"
                        ),

                        hintText: "Enter email address.",
                      ),

                      controller: _emailCrl,
                    ),

                    SizedBox(height: FormSpecs.sizedBoxHeight,),

                    ElevatedButton(
                      style: btnStyle,

                      child: Text(
                        "Send code"
                      ),

                      onPressed: () async {
                        final hasConnection = await DataConnectionChecker().hasConnection;

                        if(hasConnection){
                          setState(() {
                            _isLoading = true;
                          });

                          await widget._auth.sendPasswordRecoveryEmail(email: _emailCrl.text);

                          if(feedBack['hasError']){
                            Fluttertoast.showToast(msg: "There was an error sending email, contact system admin.");
                          }else{
                            Fluttertoast.showToast(msg: "Password recovery email was sent successfully.");
                          }

                          setState((){
                            //_isSendEmail = false;
                            _isLoading = false;
                          });
                        }else{
                          Fluttertoast.showToast(msg: "No internet connection.");
                        }
                      },
                    ),
                  ],
                ),
              ):
              Form(
                key: widget._globalKey,

                child: Column(
                  children: [
                    SizedBox(height: FormSpecs.sizedBoxHeight,),

                    TextFormField(
                      decoration: FormSpecs.textInputDecoration.copyWith(
                        label: Text(
                          "Old password",
                        ),

                        hintText: "Enter old password",
                      ),

                      obscureText: true,

                      validator: (val){
                        if(val.isEmpty){
                          return "Please enter current password.";
                        }

                        return null;
                      },

                      onChanged: (val){
                        //_oldPassword = val;
                      },
                    ),

                    SizedBox(height: FormSpecs.sizedBoxHeight,),

                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      decoration: FormSpecs.textInputDecoration.copyWith(
                        label: Text(
                          "New password",
                        ),

                        hintText: "Enter new password",
                      ),

                      obscureText: true,

                      validator: (val){
                        if(val.isEmpty){
                          return "Please enter new password.";
                        }else if(val.length < 6){
                          return "Should be 6 characters long.";
                        }

                        return null;
                      },

                      onChanged: (val){
                        _newPassword = val;
                      },
                    ),

                    SizedBox(height: FormSpecs.sizedBoxHeight,),

                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      decoration: FormSpecs.textInputDecoration.copyWith(
                        label: Text(
                          "Confirm new password",
                        ),

                        hintText: "Re-enter new password",
                      ),

                      obscureText: true,

                      validator: (val){
                        if(val.isEmpty){
                          return "Please confirm new password.";
                        }else
                        if(val != _newPassword){
                          return "Passwords does not match.";
                        }

                        return null;
                      },

                      onChanged: (val){
                        //_confirmPassword = val;
                      },
                    ),

                    SizedBox(height: FormSpecs.sizedBoxHeight,),

                    ElevatedButton(
                      style: btnStyle,

                      child: Text(
                        "Change password",
                      ),

                      onPressed: () async {
                        if(widget._globalKey.currentState.validate()){
                          // setState(() {
                          //   _isLoading = true;
                          // });

                          //await widget._auth.changePassword(newPassword: _newPassword);

                          if(feedBack['hasError']){
                            _error = feedBack['msg'];
                          }else{
                            Fluttertoast.showToast(msg: "Password was changed successfully.");
                          }

                          // setState(() {
                          //   _isLoading = false;
                          // });
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
          ),
        ],
      ),
    );
  }
}
