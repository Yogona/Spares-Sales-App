import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/services/AuthService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';

class LoginPage extends StatelessWidget{
  Widget build(BuildContext context){
    Future<bool> _onBackPressed(){
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "CLOSE APP",
          ),

          content: Text(
            "Do you want to close this app?",
          ),

          actions: [
            ElevatedButton(
              style: FormSpecs.btnStyle,

              child: Text(
                  "No"
              ),

              onPressed: (){
                Navigator.of(context).pop(false);
              },
            ),

            ElevatedButton(
              style: FormSpecs.btnStyle,

              child: Text(
                  "Yes"
              ),

              onPressed: (){
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      )??

          false;
    }

    AppColors appColors = AppColors();

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 194, 248),
          title: Text(
            "Vitality Hygiene Products",
            style: TextStyle(
              color: appColors.getFontColor(),
            ),
          ),
        ),
        body: LoginForm(appColors),
      ),
    );
  }
}

class LoginForm extends StatefulWidget{
  final AppColors _appColors;
  LoginForm(this._appColors);
  _LoginForm createState() => _LoginForm(this._appColors);
}

class _LoginForm extends State<LoginForm>{
  //------------------Instance Objects---------------------//
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final AppColors _appColors;
  final AuthService _service = AuthService();

  //Instance Variables
  String _email = "";
  String _password = "";
  String _error = "";
  bool _loading = false;


  _LoginForm(this._appColors);

  Widget build(BuildContext context){
    return _loading ? LoadingWidget("Authenticating user...") : Form(
        key: _key,
        // ignore: deprecated_member_use
        child: Center(
          child:Container(
            decoration: boxDecoration.copyWith(
              color: _appColors.getBackgroundColor(),
            ),

            padding: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 30.0),
            //color: Colors.lightBlue,
            width: 300,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      "System Login",
                      style: TextStyle(
                        color: _appColors.getFontColor(),
                        fontSize: 24,
                        //fontFamily: ,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 5,
                  child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      keyboardType: TextInputType.emailAddress,

                      decoration: InputDecoration(
                          labelText: "Username",

                          hintText: "afrisoften@gmail.com",

                          icon: const Icon(Icons.account_circle_outlined),

                        contentPadding: EdgeInsets.symmetric(
                          vertical: FormSpecs.txtFieldVerticalPadding,
                          horizontal: FormSpecs.txtFieldHorizontalPadding,
                        ),

                        floatingLabelBehavior: FloatingLabelBehavior.never,

                        filled: true,

                        fillColor: _appColors.getTxtFieldFillColor(),

                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              FormSpecs.txtFieldBorderRadius,
                            ),

                            borderSide: BorderSide(
                              color: _appColors.getFontColor(),
                            )
                          ),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                FormSpecs.txtFieldBorderRadius
                            ),

                            borderSide: BorderSide(
                              color: _appColors.getFontColor(),
                            ),
                        ),

                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            FormSpecs.txtFieldBorderRadius
                          ),

                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),

                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            FormSpecs.txtFieldBorderRadius
                          ),

                          borderSide: BorderSide(
                            color: Colors.red
                          )
                        ),
                      ),

                      validator:(String value){
                        if(value.isEmpty){
                          return "Please input a valid email!";
                        }else if(!value.contains(new RegExp(("[@.]")))){
                          return "Invalid email address.";
                        }
                        return null;
                      },

                    onSaved: (val) {
                      setState(
                        () {
                          _email = val;
                          _error = "";
                        }
                      );
                    },
                  ),
                ),

                Expanded(
                  flex: 5,
                  child: TextFormField(
                      obscureText: true,

                      autovalidateMode: AutovalidateMode.onUserInteraction,

                      decoration: InputDecoration(
                        icon: const Icon(Icons.vpn_key),

                        contentPadding: EdgeInsets.symmetric(
                          vertical: FormSpecs.txtFieldVerticalPadding,
                          horizontal: FormSpecs.txtFieldHorizontalPadding,
                        ),

                        filled: true,

                        fillColor: _appColors.getTxtFieldFillColor(),

                        floatingLabelBehavior: FloatingLabelBehavior.never,

                        labelText: "Password",

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            FormSpecs.txtFieldBorderRadius,
                          ),

                          borderSide: BorderSide(
                            color: _appColors.getFontColor(),
                          )
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            FormSpecs.txtFieldBorderRadius
                          ),

                          borderSide: BorderSide(
                            color: _appColors.getFontColor(),
                          )
                        ),

                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            FormSpecs.txtFieldBorderRadius
                          ),

                          borderSide: BorderSide(
                            color: Colors.red,
                          )
                        ),

                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            FormSpecs.txtFieldBorderRadius
                          ),

                          borderSide: BorderSide(
                            color: Colors.red
                          )
                        )
                      ),

                      validator:(String value){
                        if(value.isEmpty){
                          return "Please input password!";
                        }else if(value.contains(" ")){
                          return "White spaces are not allowed.";
                        }
                        return null;
                      },

                    onSaved: (val) {
                      setState(() {
                        _password = val;
                        _error = "";
                      });
                    },
                  ),
                ),

                SizedBox(height: 5.0,),
                Text(
                  _error,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 5.0,),

                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: FormSpecs.btnStyle,

                    onPressed: () async {
                      if(_key.currentState.validate()){
                        bool _hasConnection = await DataConnectionChecker().hasConnection;

                        if(_hasConnection){
                          _key.currentState.save();
                          setState(() => _loading = true);

                          Map<String, dynamic> state = {
                            'hasError':false,
                            'message':" ",
                          };
                          state = await _service.signInByEmailAndPassword(_email, _password);

                          if(state['hasError']){
                            setState(() {
                              _error = "Incorrect username or password.";
                              _loading = false;
                            });
                          }
                        }else{
                          final SnackBar sb = SnackBar(
                            duration: Duration(
                              seconds: 5,
                            ),

                            content: Text(
                              "No internet connection.",
                            ),

                            action: SnackBarAction(
                              label: "DISMISS",

                              onPressed: (){
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              },
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(sb);
                        }
                      }
                    },

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Login",
                          style: TextStyle(
                            //color: AppColors.getFontColor(),
                          ),
                        ),
                        const Icon(Icons.login),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}