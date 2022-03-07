import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/custom_widgets/NoItemsFound.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';

class EditProfile extends StatefulWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final AppColors _appColors = AppColors();
  final DatabaseService _databaseService = DatabaseService();

  //User data
  final String uid;
  final String firstName;
  final String middleName;
  final String lastName;
  final String address;
  final String email;
  final String phone;
  final String gender;
  final String roleId;

  //Switch windows
  final Function toggleEditProfile;

  EditProfile(
      {
        //User data
        this.uid,
        this.firstName,
        this.middleName,
        this.lastName,
        this.address,
        this.email,
        this.phone,
        this.gender,
        this.roleId,

        //Switch windows
        this.toggleEditProfile,
      }
  );

  @override
  _EditProfileState createState() => _EditProfileState(
    uid: uid,
    firstName: firstName,
    middleName: middleName,
    lastName: lastName,
    address: address,
    email: email,
    phone: phone,
    gender: gender,
    roleId: roleId,
  );
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _middleNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  //TextEditingController _genderController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  _EditProfileState(
    {
      this.uid,
      this.firstName,
      this.middleName,
      this.lastName,
      this.address,
      this.email,
      this.phone,
      this.gender,
      this.roleId
    }
  );

  String uid;
  String firstName;
  String middleName;
  String lastName;
  String address;
  String email;
  String phone;
  String gender;
  String roleId;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // uid        = widget.uid;
    // firstName  = widget.firstName;
    // middleName = widget.middleName;
    // lastName   = widget.lastName;
    // address    = widget.address;
    // email      = widget.email;
    // phone      = widget.phone;
    // gender     = widget.gender;
    // roleId     = widget.roleId;

    _firstNameController.text = firstName;
    _middleNameController.text = middleName;
    _lastNameController.text = lastName;
    _addressController.text = address;
    _emailController.text = email;
    _phoneController.text = phone;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Profile"
        ),
      ),

      body: _isLoading?LoadingWidget("Updating profile..."):
      Center(
        child: Container(
          height: MediaQuery.of(context).size.height*0.85,
          decoration: boxDecoration.copyWith(
            color: widget._appColors.getBoxColor(),
          ),
          margin: EdgeInsets.only(
            left: FormSpecs.formMargin,
            right: FormSpecs.formMargin,
          ),
          padding: EdgeInsets.all(
            titleBoxPadding
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
                        firstName = val;
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
                        middleName = val;
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
                        lastName = val;
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
                        address = val;
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
                        email = val;
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
                        phone = val;
                      },
                    ),

                    SizedBox(height: FormSpecs.sizedBoxHeight,),

                    DropdownButtonFormField(
                      decoration: FormSpecs.textInputDecoration.copyWith(
                        labelText: "Select gender",
                      ),

                      value: gender,

                      onChanged: (val){
                        gender = val;
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
                    ),

                    SizedBox(height: FormSpecs.sizedBoxHeight,),

                    StreamProvider<QuerySnapshot>.value(
                      initialData: null,

                      value: DatabaseService().getRoles,
                      
                      builder: (context, roles) {
                        final roles = Provider.of<QuerySnapshot>(context);
                        
                        if(roles == null){
                          return NoItemsFound("Getting roles...");
                        }
                        
                        return DropdownButtonFormField(
                          decoration: FormSpecs.textInputDecoration.copyWith(
                            labelText: "Select role",
                          ),

                          value: roleId,

                          onChanged: (val){
                            roleId = val;
                          },

                          items: roles.docs.map((role) {
                            return DropdownMenuItem(
                              value: role.id,
                              
                              child: Text(
                                role.get("role")
                              ),
                            );
                          }).toList(),
                        );
                      }
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

                            state = await widget._databaseService.updateProfile(
                                uid: uid,
                                firstName: firstName,
                                middleName: middleName,
                                lastName: lastName,
                                address: address,
                                email: email,
                                phone: phone,
                                gender: gender,
                              roleId: roleId,
                            );

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
        ),
      ),
    );
  }
}


