import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/authenticate/Wrapper.dart';
import 'package:vitality_hygiene_products/services/AuthService.dart';
import 'package:vitality_hygiene_products/shared/AppColors.dart';
import 'package:vitality_hygiene_products/shared/Constants.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'models/UserModel.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(_VitalityHygieneProducts());
}

class _VitalityHygieneProducts extends StatelessWidget {
  final AppColors _appColors = AppColors();
  final String version = "1.0.0";

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      initialData: null,
      value: AuthService().user,

      child: MaterialApp(
        home: Wrapper(version: version,),

        title: 'Login | Vitality Hygiene Products',

        theme: ThemeData(
          primaryColor: _appColors.getBackgroundColor(),//Color.fromARGB(255, 255, 194, 248),
          scaffoldBackgroundColor: _appColors.getScaffoldBgColor(),
          appBarTheme: AppBarTheme(
            backgroundColor: _appColors.getBackgroundColor(),//Color.fromARGB(255, 255, 194, 248),
            foregroundColor: _appColors.getPrimaryForeColor(),
            iconTheme: IconThemeData(
              color: _appColors.getFontColor(),
            )
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: FormSpecs.btnStyle,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(
                  _appColors.getFontColor()
              ),
            )
          ),
        ),
      ),
    );
  }
}