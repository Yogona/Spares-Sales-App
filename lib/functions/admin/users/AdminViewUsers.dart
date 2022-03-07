import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/custom_widgets/NoItemsFound.dart';
import 'package:vitality_hygiene_products/functions/settings/EditProfile.dart';
import 'package:vitality_hygiene_products/functions/settings/Password.dart';
import 'package:vitality_hygiene_products/models/LoggedInUser.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:vitality_hygiene_products/shared/General.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';

class AdminViewUsers extends StatefulWidget {
  final AppColors _appColors = AppColors();
  final DatabaseService _databaseService = DatabaseService();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  _AdminViewUsersState createState() => _AdminViewUsersState();
}

class _AdminViewUsersState extends State<AdminViewUsers> {
  String _query = "";
  String _parameter;
  String _selectedRole;
  bool _isLoading = false;

  Map<String, dynamic> _state = {
    'hasError':false,
    'message':"",
  };

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      initialData: null,
      value: widget._databaseService.getUsers,
      child: Builder(
        builder: (context) {
          final users = Provider.of<QuerySnapshot>(context);

          if(users == null){
            return LoadingWidget("Getting users...");
          }

          return Column(
            children: [
              //Heading
              Container(
                decoration: boxDecoration.copyWith(
                  color: widget._appColors.getBoxColor()
                ),
                margin: EdgeInsets.all(
                  FormSpecs.formMargin
                ),
                padding: EdgeInsets.all(
                  titleBoxPadding,
                ),
                child: Center(
                  child: Text(
                    "View Users",
                    style: TextStyle(
                      color: widget._appColors.getFontColor(),
                      fontSize: FormSpecs.formHeaderSize,
                    ),
                  ),
                ),
              ),

              //Searching box
              Container(
                height: 160.0,

                margin: EdgeInsets.only(
                  left: FormSpecs.formMargin,
                  bottom: FormSpecs.formMargin,
                  right: FormSpecs.formMargin,
                ),
                padding: EdgeInsets.all(
                  titleBoxPadding
                ),

                decoration: boxDecoration.copyWith(
                  color: widget._appColors.getBoxColor(),
                ),

                child: Column(
                  children: [
                    Form(
                      key: widget._globalKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,

                        children: [
                          Row(
                            children: [
                              SizedBox(width: FormSpecs.sizedBoxWidth,),
                              Expanded(
                                child: DropdownButtonFormField(
                                  decoration: FormSpecs.textInputDecoration,
                                  hint: Text(
                                    "Select search criteria",
                                    style: TextStyle(
                                      color: widget._appColors.getFontColor(),
                                    ),
                                  ),
                                  validator: (val){
                                    if(val == null){
                                      return "Please select Criteria";
                                    }

                                    return null;
                                  },
                                  value: _parameter,

                                  items: [
                                    DropdownMenuItem(
                                      value: "firstName",

                                      child: Text(
                                        "First Name",
                                      ),
                                    ),

                                    DropdownMenuItem(
                                      value: "middleName",

                                      child: Text(
                                        "Middle Name",
                                      ),
                                    ),

                                    DropdownMenuItem(
                                      value: "lastName",

                                      child: Text(
                                        "Last Name",
                                      ),
                                    ),

                                    DropdownMenuItem(
                                      value: "email",

                                      child: Text(
                                        "Email",
                                      ),
                                    ),

                                    DropdownMenuItem(
                                      value: "phone",

                                      child: Text(
                                        "Phone",
                                      ),
                                    ),

                                    DropdownMenuItem(
                                      value: "address",

                                      child: Text(
                                        "Address",
                                      ),
                                    ),

                                    DropdownMenuItem(
                                      value: "gender",

                                      child: Text(
                                        "Gender",
                                      ),
                                    ),

                                    // DropdownMenuItem(
                                    //   value: "roleID",
                                    //
                                    //   child: Text(
                                    //     "Role",
                                    //   ),
                                    // ),
                                  ],

                                  onChanged: (val){
                                    _parameter = val;
                                  },
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: FormSpecs.sizedBoxHeight,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(width: FormSpecs.sizedBoxWidth,),
                              Expanded(
                                 flex: 3,
                                child: TextFormField(
                                  decoration: FormSpecs.textInputDecoration.copyWith(
                                    hintText: "John",
                                    labelText: "Search",
                                  ),

                                  autovalidateMode: AutovalidateMode.onUserInteraction,

                                  validator: (val){
                                    if(val.isEmpty){
                                      return "Please fill key words.";
                                    }

                                    return null;
                                  },

                                  onChanged: (val){
                                    setState((){
                                      _query = val;
                                    });
                                  },
                                ),
                              ),

                              SizedBox(width: FormSpecs.sizedBoxWidth,),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //Users view
              Expanded(
                flex: 11,
                child: (users.docs.length < 2)?NoItemsFound("No results."):
                ListView.builder(
                    itemCount: users.docs.length,
                    itemBuilder: (BuildContext context, int index){
                      QueryDocumentSnapshot user = users.docs.elementAt(index);
                      String roleName;

                      for(var role in General.roles.docs){
                        if(user.get("roleID") == role.id){
                          roleName = role.get("role");
                          break;
                        }
                      }

                      if(
                        _parameter == null ||
                        _query.isEmpty ||
                        (_parameter == "firstName"  && user.get("firstName").toString().contains(_query))   ||
                        (_parameter == "middleName" && user.get("middleName").toString().contains(_query))  ||
                        (_parameter == "lastName"   && user.get("lastName").toString().contains(_query))    ||
                        (_parameter == "email"      && user.get("email").toString().contains(_query))       ||
                        (_parameter == "phone"      && user.get("phone").toString().contains(_query))       ||
                        (_parameter == "address"    && user.get("address").toString().contains(_query))     ||
                        (_parameter == "gender"     && user.get("gender").toString().contains(_query))
                      )
                      {
                        return Builder(
                          builder: (BuildContext context){
                            String currentUser = LoggedInUser.getUID();

                            if(user.id != currentUser){
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      user.get("lastName")+", "+user.get("firstName")+" "+user.get("middleName"),
                                      style: TextStyle(
                                        color: widget._appColors.getTileTitleColor(),
                                      ),
                                    ),

                                    subtitle: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "E-mail: "+user.get("email"),
                                            style: TextStyle(
                                              color: widget._appColors.getTileSubtitleColor(),
                                              //backgroundColor: Colors.black
                                            ),
                                          ),

                                          Text(
                                            "Address: "+user.get("address"),
                                            style: TextStyle(
                                              color: widget._appColors.getTileSubtitleColor(),
                                              //backgroundColor: Colors.black
                                            ),
                                          ),

                                          Text(
                                            "Phone: "+user.get("phone").toString(),
                                            style: TextStyle(
                                              color: widget._appColors.getTileSubtitleColor(),
                                              //backgroundColor: Colors.black
                                            ),
                                          ),

                                          Text(
                                            "Gender: "+user.get("gender"),
                                            style: TextStyle(
                                              color: widget._appColors.getTileSubtitleColor(),
                                              //backgroundColor: Colors.black
                                            ),
                                          ),

                                          Text(
                                            "Role: "+roleName,
                                            style: TextStyle(
                                              color: widget._appColors.getTileSubtitleColor(),
                                              //backgroundColor: Colors.black
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                    children: [
                                      Expanded(flex: 1, child: SizedBox(width: 0.0, height: 0.0,)),

                                      //Editing button
                                      Expanded(
                                        flex: 10,
                                        child: ElevatedButton(
                                          style: FormSpecs.btnStyle,
                                          child: Text(
                                            "Edit Profile",
                                          ),

                                          onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => EditProfile(
                                                  uid: user.id,
                                                  firstName: user.get("firstName"),
                                                  middleName: user.get("middleName"),
                                                  lastName: user.get("lastName"),
                                                  address: user.get("address"),
                                                  email: user.get("email"),
                                                  phone: user.get("phone"),
                                                  gender: user.get("gender"),
                                                  roleId: user.get("roleID"),
                                                )
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      Expanded(flex: 1, child: SizedBox(width: 0.0, height: 0.0,)),

                                      //Password
                                      Expanded(
                                        flex: 10,

                                        child: ElevatedButton(
                                          style: btnStyle,

                                          child: Text(
                                            "Password"
                                          ),

                                          onPressed: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Password(email: user.get("email"),),
                                              )
                                            );
                                          },
                                        ),
                                      ),

                                      Expanded(flex: 1, child: SizedBox(width: 0.0, height: 0.0,)),

                                      // Expanded(
                                      //   flex: 10,
                                      //   child: ElevatedButton(
                                      //     style: FormSpecs.btnStyle,
                                      //
                                      //     child: Text(
                                      //       "Delete",
                                      //     ),
                                      //
                                      //     onPressed: () async {
                                      //       bool hasConnection = await DataConnectionChecker().hasConnection;
                                      //
                                      //       if(hasConnection){
                                      //         showDialog(
                                      //           context: context,
                                      //
                                      //           builder: (context) => AlertDialog(
                                      //             title: Row(
                                      //               children: [
                                      //                 Icon(
                                      //                   Icons.warning,
                                      //                   color: Colors.red,
                                      //                 ),
                                      //
                                      //                 Text("Deleting User!"),
                                      //               ],
                                      //             ),
                                      //
                                      //             content: Text(
                                      //                 "You're about to delete a user, this user won't be able to login once removed. Continue?"
                                      //             ),
                                      //
                                      //             actions: [
                                      //               TextButton(
                                      //                 child: Text("No"),
                                      //                 onPressed: (){
                                      //                   Navigator.pop(context);
                                      //                 },
                                      //               ),
                                      //
                                      //               TextButton(
                                      //                   child: Text("Yes"),
                                      //                   onPressed: () async {
                                      //                     Navigator.pop(context);
                                      //
                                      //                     _state = await widget._databaseService.deleteUser(user.id);
                                      //                     Fluttertoast.showToast(msg: _state['msg']);
                                      //                   }
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         );
                                      //
                                      //       }else{
                                      //         SnackBar snackBar = CustomSnackBar(message: "No internet connection.").getSnackBar(context);
                                      //         Scaffold.of(context).showSnackBar(snackBar);
                                      //       }
                                      //     },
                                      //   ),
                                      // ),

                                      //Expanded(flex: 1, child: SizedBox(width: 0.0, height: 0.0,)),
                                    ],
                                  ),

                                  Divider(
                                    color: widget._appColors.getBackgroundColor(),
                                  ),
                                ],
                              );
                            }
                            return SizedBox(height: 0.0,width: 0.0,);
                          },
                        );
                      }

                      return SizedBox(height: 0.0, width: 0.0,);
                    }
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}