import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/models/UserModel.dart';
import 'package:vitality_hygiene_products/services/AuthService.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:vitality_hygiene_products/shared/General.dart';
import 'package:random_string/random_string.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';

class AddUsers extends StatefulWidget {
  final UserModel user;
  final AuthService _authService = AuthService();
  AddUsers({this.user});
  @override
  _AddUsersState createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  final AppColors _appColors                      = AppColors();
  final GlobalKey<FormState> _globalKey           = GlobalKey<FormState>();
  final GlobalKey<FormState> _dialogKey           = GlobalKey<FormState>();

  final DatabaseService _databaseService          = DatabaseService();
  final TextEditingController passwordController  = TextEditingController();

  //Other variables
  bool _loading       = false;
  bool _rememberAuth  = false;

  //Form inputs
  String _firstName;
  String _middleName;
  String _lastName;
  String _physicalAddr;
  String _email;
  String _phoneNo;
  String _password;
  String _selectedGender = "M";
  String _selectedRoleID;
  String _adminPwd;

  @override
  Widget build(BuildContext context) {
    setState((){
      passwordController.text = randomAlphaNumeric(8);
    });

    return _loading?LoadingWidget("Creating user..."):
       Column(
         crossAxisAlignment: CrossAxisAlignment.center,

         children: [
           //Top space
           SizedBox(height: FormSpecs.sizedBoxHeight,),
           //Heading
           Expanded(
             flex: 1,
             child: Container(
               margin: EdgeInsets.only(
                 left: FormSpecs.formMargin,
                 right: FormSpecs.formMargin,
               ),
               padding: EdgeInsets.all(
                   1.0
               ),
               decoration: boxDecoration.copyWith(
                 color: _appColors.getBoxColor(),
               ),
               child: Center(
                 child: Text(
                   "Add User",
                     style: TextStyle(
                       color: _appColors.getFontColor(),
                       fontSize: FormSpecs.formHeaderSize,
                     ),
                 ),
               ),
             ),
           ),
           //Separation space
           SizedBox(height: FormSpecs.sizedBoxHeight,),

           Expanded(
             flex: 20,
             child: Row(
               children: [
                 Expanded(flex:1, child: SizedBox(width:0.0,height:0.0,)),
                 Expanded(
                   flex:20,
                   child: Container(
                     padding: EdgeInsets.all(
                       10.0
                     ),
                     decoration: boxDecoration.copyWith(
                       color: _appColors.getBoxColor(),
                     ),
                     child: Form(
                       key: _globalKey,

                       child: ListView(
                         children: [
                           //First name field
                           TextFormField(
                             decoration: FormSpecs.textInputDecoration.copyWith(
                               labelText: "First Name",
                               hintText: "John",
                             ),

                             keyboardType: TextInputType.name,

                             inputFormatters: [
                               FilteringTextInputFormatter.allow(RegExp('[A-Za-z]')),
                             ],

                             autovalidateMode: AutovalidateMode.onUserInteraction,

                             validator: (val){
                               if(val.isEmpty){
                                 return "Please enter valid first name.";
                               }
                               return null;
                             },

                             onSaved: (val){
                               setState((){
                                 _firstName = val;
                               });
                             },

                           ),

                           SizedBox(
                             height: FormSpecs.sizedBoxHeight,
                           ),

                           //Second name field
                           TextFormField(
                             decoration: FormSpecs.textInputDecoration.copyWith(
                               labelText: "Middle Name",
                               hintText: "Connor",
                             ),

                             keyboardType: TextInputType.name,

                             inputFormatters: [
                               FilteringTextInputFormatter.allow(RegExp('[A-Za-z]')),
                             ],

                             onSaved: (val){
                               setState((){
                                 _middleName = val;
                               });
                             },
                           ),

                           SizedBox(
                             height: FormSpecs.sizedBoxHeight,
                           ),

                           //Last name field
                           TextFormField(
                             decoration: FormSpecs.textInputDecoration.copyWith(
                               labelText: "Last Name",
                               hintText: "Doe",
                             ),

                             keyboardType: TextInputType.name,

                             inputFormatters: [
                               FilteringTextInputFormatter.allow(RegExp('[A-Za-z]')),
                             ],

                             autovalidateMode: AutovalidateMode.onUserInteraction,

                             validator: (val){
                               if(val.isEmpty){
                                 return "Please enter valid last name.";
                               }
                               return null;
                             },

                             onSaved: (val){
                               setState((){
                                 _lastName = val;
                               });
                             },
                           ),

                           SizedBox(
                             height: FormSpecs.sizedBoxHeight,
                           ),

                           //Address field
                           TextFormField(
                             decoration: FormSpecs.textInputDecoration.copyWith(
                               labelText: "Physical Address",
                               hintText: "KISASA",
                             ),

                             keyboardType: TextInputType.streetAddress,

                             inputFormatters: [
                               FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9.,/()@_ -]')),
                             ],

                             autovalidateMode: AutovalidateMode.onUserInteraction,

                             validator: (val){
                               if(val.isEmpty){
                                 return "Please enter valid address.";
                               } else if(val.startsWith(RegExp('[ ]'))){
                                 return "Address can't start with a space.";
                               }
                               return null;
                             },

                             onSaved: (val){
                               setState((){
                                 _physicalAddr = val;
                               });
                             },
                           ),

                           SizedBox(
                             height: FormSpecs.sizedBoxHeight,
                           ),

                           //Email field
                           TextFormField(
                             decoration: FormSpecs.textInputDecoration.copyWith(
                               labelText: "e-Mail",
                               hintText: "contact@tansoften.com",
                             ),

                             keyboardType: TextInputType.emailAddress,

                             inputFormatters: [
                               FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9.@_-]')),
                             ],

                             autovalidateMode: AutovalidateMode.onUserInteraction,

                             validator: (val){
                               if(val.isEmpty || !val.contains(RegExp('[@]')) || !val.contains(RegExp('[.]'))){
                                 return "Please enter valid e-mail address.";
                               } else if(val.startsWith(RegExp('[@]'))){
                                 return "E-mail can't start with '@'.";
                               } else if(val.startsWith(RegExp('[.]'))){
                                 return "E-mail can't start with '.'.";
                               } else if(val.endsWith('@')){
                                 return "E-mail can't end with '@'.";
                               } else if(val.endsWith('.')){
                                 return "E-mail can't end with '.'.";
                               }
                               return null;
                             },

                             onSaved: (val){
                               setState((){
                                 _email = val;
                               });
                             },
                           ),

                           SizedBox(
                             height: FormSpecs.sizedBoxHeight,
                           ),

                           //Phone field
                           TextFormField(
                             decoration: FormSpecs.textInputDecoration.copyWith(
                               labelText: "Phone",
                               hintText: "0712500282",
                             ),

                             keyboardType: TextInputType.phone,

                             inputFormatters: [
                               FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                             ],

                             autovalidateMode: AutovalidateMode.onUserInteraction,

                             validator: (val){
                               if(val.isEmpty){
                                 return "Please enter valid phone number.";
                               }
                               return null;
                             },

                             onSaved: (val){
                               setState((){
                                 _phoneNo = val;
                               });
                             },
                           ),

                           SizedBox(
                             height: FormSpecs.sizedBoxHeight,
                           ),

                           //Password field
                           TextFormField(
                             decoration: FormSpecs.textInputDecoration.copyWith(
                               labelText: "Password",
                             ),

                             controller: passwordController,

                             obscureText: true,

                             keyboardType: TextInputType.text,

                             autovalidateMode: AutovalidateMode.onUserInteraction,

                             validator: (val){
                               if(val.isEmpty){
                                 return "Please enter password.";
                               }else if(val.length < 6){
                                 return "Password should be at least 6 characters long.";
                               }
                               return null;
                             },

                             onSaved: (val){
                               setState((){
                                 _password = val;
                               });
                             },
                           ),

                           //Gender selection
                           FormField(
                             builder: (FormFieldState state){
                               return Row(
                                 children: [
                                   Text(
                                     "Gender:",
                                     style: TextStyle(
                                       color: _appColors.getFontColor(),
                                       fontSize: FormSpecs.fontSize,
                                     ),
                                   ),

                                  Expanded(
                                    flex: 1,
                                    child: ListTile(
                                      leading: Radio(
                                        value: "M",
                                        groupValue: _selectedGender,
                                        onChanged: (val) {
                                         setState(() {
                                           _selectedGender = val;
                                         });
                                        },
                                      ),

                                      title: Text("M"),
                                    ),
                                  ),

                                   Expanded(
                                     flex: 1,
                                     child: ListTile(
                                       leading: Radio(
                                         value: "F",
                                         groupValue: _selectedGender,
                                         onChanged: (val) {
                                           setState(() {
                                             _selectedGender = val;
                                           });
                                         }
                                       ),

                                       title: Text("F"),
                                     ),
                                   ),
                                 ],
                               );
                             },
                           ),

                           //Role selection
                           DropdownButtonFormField(
                             decoration: FormSpecs.textInputDecoration,

                             hint: Text("Select role."),

                             value: _selectedRoleID,
                               items: General.roles.docs.map((role) {
                                 return DropdownMenuItem(
                                   value: role.id,
                                   child: Text(role.get("role")),
                                 );
                               }).toList(),

                             validator: (val){
                               if(val == null){
                                 return 'Please select user role.';
                               }
                               return null;
                             },

                             onChanged: (val) => _selectedRoleID = val,
                           ),

                           //Saving button
                           ElevatedButton(
                             style: FormSpecs.btnStyle,

                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: <Widget>[
                                 const Icon(Icons.person_add),

                                 const Text("Add User"),
                               ],
                             ),

                             onPressed: () async {
                               if(_globalKey.currentState.validate()){
                                 _globalKey.currentState.save();
                                 SnackBar snackBar;
                                 bool hasConnection = await DataConnectionChecker().hasConnection;

                                 if(!hasConnection){
                                   snackBar = CustomSnackBar(message: "No internet connection.").getSnackBar(context);
                                 }else
                                 {
                                   //setState((){_loading = true;});

                                   await showDialog(
                                     context: context,

                                     builder: (context){
                                       return AlertDialog(
                                         //Authentication
                                         title: Text(
                                           "Authentication",
                                           style: TextStyle(
                                             color: _appColors.getFontColor()
                                           ),
                                         ),

                                         content: Container(
                                           height: 120,
                                           child: ListView(
                                             children: [
                                               Text(
                                                 "Please confirm your identity."
                                               ),

                                               Form(
                                                 key: _dialogKey,

                                                 child: Column(
                                                   children: [
                                                     TextFormField(
                                                       autovalidateMode: AutovalidateMode.onUserInteraction,
                                                       obscureText: true,
                                                       decoration: FormSpecs.textInputDecoration.copyWith(
                                                         icon: Icon(
                                                           Icons.vpn_key,
                                                           color: _appColors.getFontColor(),
                                                         ),
                                                       ),

                                                       onChanged: (val){
                                                         _adminPwd = val;
                                                       },

                                                       validator: (val){
                                                         if(val.isEmpty){
                                                           return "Provide password.";
                                                         }

                                                         return null;
                                                       },
                                                     ),

                                                     //Remember user
                                                     // Row(
                                                     //   mainAxisAlignment: MainAxisAlignment.center,
                                                     //   children: [
                                                     //     Text(
                                                     //       "Don't ask again"
                                                     //     ),
                                                     //
                                                     //     StatefulBuilder(
                                                     //       builder: (context, setState){
                                                     //         return Checkbox(
                                                     //           value: _rememberAuth,
                                                     //
                                                     //           onChanged: (bool val){
                                                     //             setState((){
                                                     //               _rememberAuth = val;
                                                     //             });
                                                     //           },
                                                     //         );
                                                     //       },
                                                     //     ),
                                                     //   ],
                                                     // ),
                                                   ],
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ),

                                         actions: [

                                           //Cancel button
                                           ElevatedButton(
                                             child: Text(
                                               "Close",
                                             ),

                                             style: FormSpecs.btnStyle,

                                             onPressed: (){
                                               Navigator.pop(context);
                                             },
                                           ),

                                           //Confirm button
                                           ElevatedButton(
                                             style: FormSpecs.btnStyle,

                                             child: Text(
                                               "Confirm"
                                             ),

                                             onPressed: () async {
                                               FocusScope.of(context).requestFocus(FocusNode());
                                               if(_dialogKey.currentState.validate()){
                                                 bool hasConnection = await DataConnectionChecker().hasConnection;

                                                 if(!hasConnection){
                                                   Fluttertoast.showToast(msg: "No internet connection.");
                                                 }else{
                                                  bool isVerified = await widget._authService.reAuthenticate(_adminPwd);

                                                  if(isVerified){
                                                    Navigator.pop(context);

                                                     Map<String, dynamic> state;

                                                     state = await widget._authService.createUserWithEmailAndPassword(_email, _password);

                                                     if(state['hasError']){
                                                       snackBar = CustomSnackBar(message: state['message']).getSnackBar(context);
                                                     }else{

                                                       state = await _databaseService.addUser(_firstName, _middleName, _lastName, _physicalAddr, _email, _phoneNo, _selectedGender, _selectedRoleID, state['message']);

                                                       if(state['hasError']){
                                                         snackBar = CustomSnackBar(message: state['message']).getSnackBar(context);
                                                       }else{

                                                         snackBar = CustomSnackBar(message: state['message']).getSnackBar(context);

                                                         await FlutterEmailSender.send(
                                                             Email(
                                                                 recipients: [_email],
                                                                 subject: 'Account Registration',
                                                                 body: 'Your login details;\nEmail: $_email\nPassword: $_password'
                                                             )
                                                         );
                                                       }
                                                    }

                                                     //await widget._authService.signOut();
                                                     await widget._authService.switchBackToAdmin(_adminPwd);
                                                  }else{
                                                    Fluttertoast.showToast(msg: "Incorrect password.");
                                                  }
                                                 }
                                               }
                                             },
                                           ),
                                         ],
                                       );
                                     }
                                   );
                                  }

                                 //Scaffold.of(context).showSnackBar(snackBar);
                               }
                             },
                           ),
                         ],
                       ),
                     ),
                   ),
                 ),
                 Expanded(flex:1, child: SizedBox(width:0.0,height:0.0,)),
               ],
             ),
           ),

           Expanded(flex:1,child: SizedBox(height:0.0,width:0.0)),
         ],
       );
  }
}