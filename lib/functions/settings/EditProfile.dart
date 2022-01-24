import 'package:flutter/material.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

// class EditProfile extends StatelessWidget {
//   final AppColors _appColors = AppColors();
//
//   final String uid;
//   final String firstName;
//   final String middleName;
//   final String lastName;
//   final String address;
//   final String email;
//   final String phone;
//   final String gender;
//
//   EditProfile(this.uid, this.firstName, this.middleName, this.lastName, this.address, this.email, this.phone,  this.gender);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Edit Profile",
//           style: TextStyle(
//             color: _appColors.getFontColor(),
//           ),
//         ),
//
//         actions: [
//           Options(),
//         ],
//       ),
//
//       body: _EditProfile(uid, firstName, middleName, lastName, address, email, phone, gender),
//     );
//   }
// }


class EditProfile extends StatefulWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final AppColors _appColors = AppColors();
  final DatabaseService _databaseService = DatabaseService();

  final String uid;
  final String firstName;
  final String middleName;
  final String lastName;
  final String address;
  final String email;
  final String phone;
  final String gender;

  EditProfile({this.uid, this.firstName, this.middleName, this.lastName, this.address, this.email, this.phone,  this.gender});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _middleNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  //TextEditingController _genderController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  String _uid;
  String _firstName;
  String _middleName;
  String _lastName;
  String _address;
  String _email;
  String _phone;
  String _gender;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    _uid        = widget.uid;
    _firstName  = widget.firstName;
    _middleName = widget.middleName;
    _lastName   = widget.lastName;
    _address    = widget.address;
    _email      = widget.email;
    _phone      = widget.phone;
    _gender     = widget.gender;

    _firstNameController.text = _firstName;
    _middleNameController.text = _middleName;
    _lastNameController.text = _lastName;
    _addressController.text = _address;
    _emailController.text = _email;
    _phoneController.text = _phone;

    return _isLoading?LoadingWidget("Updating profile..."):Container(
      margin: EdgeInsets.only(
        left: FormSpecs.formMargin,
        right: FormSpecs.formMargin,
      ),
      child: ListView(
        children: [
          SizedBox(height: FormSpecs.sizedBoxHeight,),
          Center(
            child: Text(
              "Profile Settings",
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
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  decoration: FormSpecs.textInputDecoration.copyWith(
                      labelText: "First Name"
                  ),

                  controller: _firstNameController,

                  validator: (val){
                    if(val.isEmpty){
                      return "Please fill first name.";
                    } else if(val.contains(' ')){
                      return "White space is not allowed.";
                    } else if(val.contains(RegExp('[0-9]'))){
                      return "Special characters are not allowed.";
                    }

                    return null;
                  },

                  onSaved: (val){
                    _firstName = val;
                  },
                ),

                SizedBox(height: FormSpecs.sizedBoxHeight,),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  decoration: FormSpecs.textInputDecoration.copyWith(
                      labelText: "Middle Name"
                  ),

                  controller: _middleNameController,

                  validator: (val){
                    if(val.contains(' ')){
                      return "White space is not allowed.";
                    }

                    return null;
                  },

                  onSaved: (val){
                    _middleName = val;
                  },
                ),

                SizedBox(height: FormSpecs.sizedBoxHeight,),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  decoration: FormSpecs.textInputDecoration.copyWith(
                      labelText: "Last Name"
                  ),

                  controller: _lastNameController,

                  validator: (val){
                    if(val.isEmpty){
                      return "Please fill last name.";
                   }

                    return null;
                  },

                  onSaved: (val){
                    _lastName = val;
                  },
                ),

                SizedBox(height: FormSpecs.sizedBoxHeight,),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  decoration: FormSpecs.textInputDecoration.copyWith(
                      labelText: "Physical Address"
                  ),

                  controller: _addressController,

                  validator: (val){
                    if(val.isEmpty){
                      return "Please fill physical address.";
                    }

                    return null;
                  },

                  onSaved: (val){
                    _address = val;
                  },
                ),

                SizedBox(height: FormSpecs.sizedBoxHeight,),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  decoration: FormSpecs.textInputDecoration.copyWith(
                      labelText: "Email Address"
                  ),

                  controller: _emailController,

                  validator: (val){
                    if(val.isEmpty){
                      return "Please fill email address.";
                    }

                    return null;
                  },

                  onSaved: (val){
                    _email = val;
                  },
                ),

                SizedBox(height: FormSpecs.sizedBoxHeight,),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  decoration: FormSpecs.textInputDecoration.copyWith(
                      labelText: "Phone"
                  ),

                  controller: _phoneController,

                  validator: (val){
                    if(val.isEmpty){
                      return "Please fill phone numbers.";
                    }

                    return null;
                  },

                  onSaved: (val){
                    _phone = val;
                  },
                ),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Gender",
                        style: TextStyle(
                          color: widget._appColors.getFontColor(),
                          fontSize: FormSpecs.fontSize,
                        ),
                      ),
                    ),

                    Expanded(
                        flex: 2,
                        child: DropdownButtonFormField(
                          value: _gender,

                          onChanged: (val){
                            _gender = val;
                          },

                          items: [
                            DropdownMenuItem(
                              value: "M",

                              child: Text(
                                "Male",
                                style: TextStyle(
                                  color: widget._appColors.getFontColor(),
                                ),
                              ),
                            ),

                            DropdownMenuItem(
                              value: "F",

                              child: Text(
                                "Female",
                                style: TextStyle(
                                  color: widget._appColors.getFontColor(),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),

                  ],
                ),

                ElevatedButton(
                  child: Text(
                    "Save",
                  ),

                  onPressed: () async {
                    if(widget._globalKey.currentState.validate()){
                      widget._globalKey.currentState.save();
                      bool hasConnection = await DataConnectionChecker().hasConnection;
                      SnackBar snackBar;

                      if(hasConnection){
                        Map<String, dynamic> state;
                        setState(() => {_isLoading = true});
                        print(_gender);
                        state = await widget._databaseService.updateProfile(_uid, _firstName, _middleName, _lastName, _address, _email, _phone, _gender);

                        if(state['hasError']){
                          snackBar = CustomSnackBar(message: state['message']).getSnackBar(context);
                        }else{
                          snackBar = CustomSnackBar(message: state['message']).getSnackBar(context);
                        }
                        setState(() => {_isLoading = false});
                      }else{
                        snackBar = CustomSnackBar(message: "No internet connection.").getSnackBar(context);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


