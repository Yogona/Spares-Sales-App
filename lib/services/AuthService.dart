import 'package:firebase_auth/firebase_auth.dart';
import 'package:vitality_hygiene_products/models/UserModel.dart';
import 'package:vitality_hygiene_products/shared/General.dart';

class AuthService {
  Map<String, dynamic> _feedBack = {
    'hasError':false,
    'message':''
  };

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthService();

  Future<void> sendPasswordRecoveryEmail({String email}) async {
    try{
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    }catch($e){
      //print($e);
    }
  }

  UserModel _userFromFirebaseUser(User user){
    return user != null ? UserModel(uid:user.uid, phoneNumber:user.phoneNumber, email:user.email) : null;
  }

  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
  }

  // Future deleteUser(String uid) async {
  //   try{
  //
  //
  //     return _state;
  //   }catch(e){print(e.toString());
  //     _state['hasError'] = true;
  //     _state['message'] = e.toString();
  //     return _state;
  //   }
  // }

  Future<void> switchBackToAdmin(String pwd) async {
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: General.user.email, password: pwd);
    }catch($e){
      print("Switch to admin error: ${$e.toString()}");
    }
  }

  Future<bool> reAuthenticate(String pwd) async {
    try{
      General.user = _userFromFirebaseUser(_firebaseAuth.currentUser);
      UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(email: General.user.email, password: pwd);
      return (user == null)?false:true;
    }catch(e){
      print("Re-Authentication error:${e.toString()}");
      return false;
    }
  }

  Future createUserWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential createdUser = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      _feedBack['hasError'] = false;
      _feedBack['message'] = createdUser.user.uid;
      return _feedBack;
    }catch(e){
      _feedBack['hasError'] = true;
      var error = e.toString().split(']');
      _feedBack['message'] = error[1];
      return _feedBack;
    }
  }

  Future signOut() async {
    try{
      return await _firebaseAuth.signOut();
    }catch(e){
      print("Error signing out...\n"+e.toString());
      return null;
    }
  }

  Future signInByEmailAndPassword(String email, String password) async {
    try{
        UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        User user = result.user;
        _feedBack['hasError'] = false;
        _feedBack['message'] = _userFromFirebaseUser(user);
        return _feedBack;
    }catch(e){
      //print("Error signing in by email: ${e.toString()}");
      _feedBack['hasError'] = true;
      _feedBack["message"] = "Internal error has occurred.";
      return _feedBack;
    }
  }
}