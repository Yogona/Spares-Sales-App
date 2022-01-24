class LoggedInUser{
  static String _uid;
  static String _email;
  static String _phone;
  static String _role;

  static void setRole(String role){
    _role = role;
  }

  static void setUID(String uid){
    _uid = uid;
  }

  static void setEmail(String email){
    _email = email;
  }

  static void setPhone(String phone){
    _phone = phone;
  }

  static String getRole(){
    return _role;
  }

  static String getUID(){
    return _uid;
  }

  static String getEmail(){
    return _email;
  }

  static String getPhone(){
    return _phone;
  }
}