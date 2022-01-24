import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vitality_hygiene_products/models/LoggedInUser.dart';



class DatabaseService {
  final FirebaseAuth        _authService          = FirebaseAuth.instance;
  final FirebaseFirestore   db                    = FirebaseFirestore.instance;
  final CollectionReference _users             = FirebaseFirestore.instance.collection("users");
  final CollectionReference _allRoles             = FirebaseFirestore.instance.collection("roles");
  final CollectionReference _store                = FirebaseFirestore.instance.collection("store");
  final CollectionReference _allPurchases         = FirebaseFirestore.instance.collection("purchases");
  final CollectionReference _costsCollection      = FirebaseFirestore.instance.collection("costs");
  //final CollectionReference _productsAssignments  = FirebaseFirestore.instance.collection("productsAssignments");
  final CollectionReference _sales                = FirebaseFirestore.instance.collection("sales");
  final CollectionReference _maintenance          = FirebaseFirestore.instance.collection("maintenance");
  //final CollectionReference _salesImages          = FirebaseFirestore.instance.collection("salesImages");
  final CollectionReference  _invoices             = FirebaseFirestore.instance.collection('invoices');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Map<String, dynamic> _feedback = {
    'hasError':false,
    'message':"Product added successfully."
  };

  final String query;

  DatabaseService({this.query});

  //-----------RETRIEVING METHODS-------------//
  Stream<QuerySnapshot> get getInvoices {
    return _invoices.snapshots();
  }

  Stream<QuerySnapshot> get getUsers {//print(parameter);
    return _users.snapshots();
  }

  Stream<QuerySnapshot> get getRoles {
    return _allRoles.snapshots();
  }

  Stream<QuerySnapshot> get getMaintenance {
    return _maintenance.snapshots();
  }

  Stream<QuerySnapshot> get getSales{
    return _sales.where('invoice_id', isEqualTo: this.query).orderBy("created_at", descending: true,).snapshots();
  }

  // Stream<QuerySnapshot> get getAssignedProducts {
  //   return _productsAssignments.snapshots();
  // }

  Stream<QuerySnapshot> get getCosts {
    return _costsCollection.orderBy("createdAt", descending: true).snapshots();
  }

  Stream<QuerySnapshot> get purchases {
    return _allPurchases.orderBy("createdAt", descending: true).snapshots();
  }

  Stream<QuerySnapshot> get store {
    return _store.orderBy("createdAt", descending: true).snapshots();
  }

  Stream<QuerySnapshot> get roles {
    return _allRoles.snapshots();
  }

//-------------UPDATING METHODS---------------//
  Future<dynamic> updateSlipStatus(String status, String uri) async{
    try{
      double commissionRate = 0.0;
      String userId = "";

      if(status == "Accepted"){
        QuerySnapshot sales = await _sales.get();
        for(final sale in sales.docs){
          if(sale.get("imageUri") == uri){
            userId = sale.get("addedBy");
            break;
          }
        }

        _users.get().then((value){
          value.docs.map((user){
            if(user.id == userId){
              commissionRate = user.get("commissionRate(%)")/100;
            }
          }).toList();
        });
      }

      Map<String,dynamic> data;



      _sales.get().then((value) {
        value.docs.map((sale) {
          if(sale.get("imageUri")==uri){
            data = {
              'status':status,
              'isVerified':(status=="Rejected")?false:true,
              'commission':(status == "Rejected")?0.0:sale.get("subTotal") * commissionRate,
            };

            _sales.doc(sale.id).update(data);
          }
        }).toList();
      });


      _feedback['hasError'] = false;
      _feedback['message']  = "Status has been updated successfully.";
      return _feedback;
    }catch(e){

    }
  }
  // Future<dynamic> updateAssignedProduct(String assignedProduct, int quantity, String unit, DateTime date) async {
  //   try{
  //     DateTime updatedAt = DateTime(date.year, date.month, date.day);
  //
  //     Map<String, dynamic> data = {
  //       unit:quantity,
  //       'updatedAt':updatedAt,
  //     };
  //
  //     await _productsAssignments.doc(assignedProduct).update(data);
  //
  //     _feedback['hasError'] = false;
  //     _feedback['message'] = "Sale record has been deleted successfully.";
  //     return _feedback;
  //   }catch(e){
  //     var error = e.toString().split(']');
  //     _feedback['hasError'] = true;
  //     _feedback['message'] = error[1];
  //     return _feedback;
  //   }
  // }

  Future<dynamic> updateUserRole(String uid, String role) async {
    try{
      Map<String, dynamic> data = {
        'roleID':role,
      };

      await _users.doc(uid).update(data);

      _feedback['hasError'] = false;
      _feedback['message'] = "User role has been updated successfully.";

      return _feedback;
    }catch(e){
      var error = e.toString().split(']');
      _feedback['hasError'] = true;
      _feedback['message'] = error[1];
      return _feedback;
    }
  }

  Future<dynamic> updateProfile(String uid, String firstName, String middleName, String lastName, String address, String email, String phone, String gender) async {
    try{
      Map<String, dynamic> data = {
        'firstName':firstName,
        'middleName':middleName,
        'lastName':lastName,
        'address':address,
        'email':email,
        'phone':phone,
        'gender':gender,
      };

      await _users.doc(uid).update(data);

      _feedback['hasError'] = true;
      _feedback['message'] = "Profile was updated successfully.";

      return _feedback;
    }catch(e){
      var error = e.toString().split(']');
      _feedback['message'] = error[1];
      _feedback['hasError'] = true;
      return _feedback;
    }
  }

  // Future<dynamic> updateProductAssignment(String assignmentID, String productID, String quantity, String unit) async {
  //   try{
  //     _feedback['hasError'] = false;
  //
  //     DocumentSnapshot doc = await _store.doc(productID).get();
  //     int storeQuantity = doc.get(unit);
  //
  //     if(storeQuantity < int.parse(quantity)){
  //       if(storeQuantity == 1){
  //         String oneUnit;
  //         if(unit == "pieces"){
  //           oneUnit = "piece";
  //         }else if(unit == "cartons"){
  //           oneUnit = "carton";
  //         } else {
  //           oneUnit = "dozen";
  //         }
  //         _feedback['message'] = "Can't assign products, there is only $storeQuantity $oneUnit in the store.";
  //       }else{
  //         _feedback['message'] = "Can't assign products, there are only $storeQuantity $unit in the store.";
  //       }
  //
  //       return _feedback;
  //     }else{
  //       DateTime date = DateTime(DateTime.now().toUtc().year, DateTime.now().toUtc().month, DateTime.now().toUtc().day);
  //
  //       DocumentSnapshot doc = await _productsAssignments.doc(assignmentID).get();
  //       int tempQuantity = doc.get(unit) + int.parse(quantity);
  //       Map<String, dynamic> data = {
  //         unit:tempQuantity,
  //         'updatedAt':date,
  //       };
  //
  //       _productsAssignments.doc(assignmentID).update(data);
  //
  //       storeQuantity -= int.parse(quantity);
  //
  //       data = {
  //         unit:storeQuantity,
  //         'updatedAt':date,
  //       };
  //
  //       _store.doc(productID).update(data);
  //
  //       _feedback['hasError'] = false;
  //       _feedback['message'] = "Product assignment has completed.";
  //       return _feedback;
  //     }
  //   }catch(e){
  //     _feedback['hasError'] = true;
  //     var error = e.toString().split(']');
  //     _feedback['message'] = error[1];
  //     return _feedback;
  //   }
  // }

  Future<dynamic> updateCommissionRate(String userID, double commissionRate) async {
    Map<String, dynamic> data = {
      'commissionRate(%)':commissionRate,
    };

    try{
      await _users.doc(userID).update(data);
      _feedback['hasError'] = false;
      _feedback['message'] = "Commission rate was updated to $commissionRate%.";
      return _feedback;
    }catch(e){
      _feedback['hasError'] = true;
      _feedback['message'] = e.toString();
      return _feedback;
    }
  }

  Future<dynamic> reduceStoreQuantity({String pid, int quantity, DateTime updatedAt}) async {
    try{
      int storeQuantity=-1;
      _store.doc(pid).get().then((value) async {
        storeQuantity = value.get("pieces") - quantity;

        Map<String, dynamic> data = {
          'pieces':storeQuantity,
          'updatedAt':updatedAt,
        };

        await _store.doc(pid).update(data);

        _feedback = {
          'hasError': false,
          'msg': "Failed deducting from the store",
        };

        return _feedback;
      });
    }catch($e){
      print($e.toString());
      _feedback = {
        'hasError': true,
        'msg': $e.toString().split(']')[1],
      };
      return _feedback;
    }
  }

  Future updateStoreQuantity(String pid, String column, int quantity, DateTime dateTime) async {
    try{
      Map<String, dynamic> data = {
        column:quantity,
        'updatedAt':dateTime,
      };

      _store.doc(pid).update(data);

      _feedback['hasError'] = false;
      _feedback['message']  = "Purchase was added to the store successfully.";
      return _feedback;
    }catch(e){print(e.toString());
      _feedback['hasError'] = true;
      _feedback['message']  = e.toString();
      return _feedback;
    }
  }
//-------------UPDATING METHODS END------------//

//--------------ADDING METHODS-----------------//
  Future<dynamic> createInvoice({String customerNames}) async {
    try{
      DateTime date = DateTime.now().toUtc();

      Map<String,dynamic> invoiceData = {
        'added_by':LoggedInUser.getUID(),
        'customer_names':customerNames,
        'created_at':date,
        'updated_at':date,
      };

      var invoiceId = await _invoices.add(invoiceData);

      _feedback = {
        'hasError':false,
        'msg':invoiceId.id,
      };

      return _feedback;
    }catch($e){
      _feedback = {
        'hasError':true,
        'msg':'Error creating invoice:'+$e
      };
      print("Error creating invoice:"+$e);
      return _feedback;
    }
  }

  Future<dynamic> addSale(Map<String,dynamic> data) async {
    try{
      var saleData = await _sales.add(data);
      _feedback = {
        "hasError": false,
        "msg": saleData.id,
      };

      return _feedback;
    }catch(e){
      _feedback['hasError'] = true;
      var error = e.toString().split(']');
      _feedback['message'] = error[1];
    }
  }

  Future<dynamic> saveCosts(DateTime date, int transport, int loading, int unloading, String currency) async {
    try{
      Map<String, dynamic> costs = {
        'transport':transport,
        'loading':loading,
        'unloading':unloading,
        'currency':currency,
        'createdAt':date,
        'addedBy':_authService.currentUser.uid,
      };

      await _costsCollection.doc().set(costs);

      _feedback['hasError'] = false;
      _feedback['message'] = "Costs have been saved successfully.";
      return _feedback;
    }catch(e){
      print(e.toString());
      _feedback['hasError'] = true;
      _feedback['message'] = "Internal database error has occurred.";
      return _feedback;
    }
  }

  Future<dynamic> addPurchase(String productCode, String productDescription, int quantity, String unit, int amount, int subTotal, String currency, String productID, DateTime dateTime) async {
    Map<String, dynamic> purchase = {
      'productCode':productCode,
      'productName':productDescription,
      'quantity':quantity,
      'unit':unit,
      'amount':amount,
      'subTotal':subTotal,
      'currency':currency,
      'productID':productID,
      'createdAt':dateTime,
      'updatedAt':dateTime,
      'addedBy':_authService.currentUser.uid,
    };

    try{
      await _allPurchases.doc().set(purchase);
      _feedback['hasError'] = false;
      _feedback['message'] = "Purchase was recorded successfully.";
      return _feedback;
    }catch(e){print(e.toString());
      _feedback['hasError'] = true;
      _feedback['message'] = "Error adding purchase.";
      return _feedback;
    }
  }

  Future<dynamic> addProduct(String productCode, String productDescription, String price, DateTime dateTime) async {
    try{
     Map<String, dynamic> _productData = {
        'productCode':        productCode,
        'productDescription': productDescription,
        'price':              price,
        'pieces':             0,
        // 'dozens':0,
        // 'cartons':0,
        'addedBy':            _authService.currentUser.uid,
        'createdAt':          dateTime,
        'updatedAt':          dateTime,
      };

      await _store.doc().set(_productData);
      _feedback['hasError'] = false;
      _feedback['message']  = "Product was added successfully.";
      return _feedback;
    }catch(e){
      _feedback['hasError'] = true;
      _feedback['message']  = e.toString();
      return _feedback;
    }
  }

  Future<dynamic> addUser(String firstName, String middleName, String lastName, String address, String email, String phone, String gender, String role, String uid) async {
    try{

      Map<String, dynamic> userData = {
        'firstName':firstName,
        'middleName':middleName,
        'lastName':lastName,
        'address':address,
        'email':email,
        'phone':phone,
        'gender':gender,
        'roleID':role,
        'commissionRate(%)':0.0,
      };

      await _users.doc(uid).set(userData);

      _feedback['hasError'] = false;
      _feedback['message'] = "User was created successfully.";

      return _feedback;
    }catch(e){
      _feedback['hasError'] = true;
      var error = e.toString().split(']');
      _feedback['message'] = error[1];
      return _feedback;
    }
  }
//-------------ADDING METHODS END-----------------------//

//-----------DELETING METHODS--------------//

  Future<dynamic> deleteSlip(String slipUrl) async {
    try{
      _storage.refFromURL(slipUrl).delete();

      Map<String, dynamic> data = {
        'imageUri':"null",
      };

      _sales.get().then((value) {
        value.docs.map((doc) {
          if(doc.get("imageUri") == slipUrl){
            _sales.doc(doc.id).update(data);
          }
        }).toList();
      });

      _feedback['hasError'] = false;
      _feedback['message'] = "Slip has been detached successfully.";

      return _feedback;
    }catch(e){
      _feedback['hasError'] = true;
      _feedback['message']  = e.toString().split(']')[1];
      return _feedback;
    }
  }

  Future<dynamic> deleteSale(String saleID) async {
    try{
      await _sales.doc(saleID).delete();
      _feedback['hasError'] = false;
      _feedback['message'] = "Sale record has been deleted successfully.";
      return _feedback;
    }catch(e){
      var error = e.toString().split(']');
      _feedback['hasError'] = true;
      _feedback['message'] = error[1];
      return _feedback;
    }
  }

  Future<dynamic> deleteUser(String userUID) async {
    try{
      _users.doc(userUID).delete();
      _feedback['hasError'] = false;
      _feedback['message'] = "User has been deleted successfully.";
      return _feedback;
    }catch(e){
      _feedback['hasError'] = true;
      _feedback['message'] = "Database error occured while deleting user.";
      return _feedback;
    }
  }

  Future<dynamic> deleteCost(String costID) async {
    try{
      await _costsCollection.doc(costID).delete();
      _feedback['hasError'] = false;
      _feedback['message'] = "Costs record has been deleted successfully.";
      return _feedback;
    }catch(e){
      _feedback['hasError'] = true;
      var error = e.toString().split(']');
      _feedback['message'] = error[0];
      return _feedback;
    }
  }

  Future<dynamic> deletePurchase(String purchaseID) async {
    try{
      _allPurchases.doc(purchaseID).delete();
      _feedback['hasError'] = false;
      _feedback['message'] = "Purchase record has been deleted successfully.";
      return _feedback;
    }catch(e){
      print(e.toString());
      _feedback['hasError'] = true;
      _feedback['message'] = "Database error occurred while deleting a purchase record.";
      return _feedback;
    }
  }

  Future<dynamic> deleteProduct(String productID) async {
    try{
       _store.doc(productID).delete();
      _feedback['hasError'] = false;
      _feedback['message'] = " has been deleted successfully.";
      return _feedback;
    }catch(e){
      var error = e.toString().split(']');
      _feedback['hasError'] = true;
      _feedback['message'] = error[1];
      return _feedback;
    }
  }
//---------------DELETING METHODS END--------------//
}