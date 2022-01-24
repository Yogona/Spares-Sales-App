import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/custom_widgets/CustomSnackBar.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/models/FeedBack.dart';
import 'package:vitality_hygiene_products/models/Sale.dart';
import 'package:vitality_hygiene_products/shared/FormSpecs.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';

class AddSales extends StatefulWidget {
  final DatabaseService _dbService = DatabaseService();
  @override
  _AddSalesState createState() => _AddSalesState();
}

class _AddSalesState extends State<AddSales>{

  bool _canSave = false;
  bool _isLoading = false;
  bool viewProforma = false;//We set it to false because initially we show adding items to proforma
  String proformaBtnTxt = "Angalia Profoma";
  List<TextEditingController> qtyControllers = [];
  List<Sale> sales = [];

  String invoiceId = "";

  Future<void> addSale(Map<String, dynamic> body) async {
    try{
      var saleResponse = await widget._dbService.addSale(body);

      if(!saleResponse['hasError']){
        var storeResponse = await widget._dbService.reduceStoreQuantity(
          pid: body['product_id'],
          quantity: int.parse(body['quantity']),
          updatedAt: body['updated_at']
        );

        if(!storeResponse['hasError']){

        }
      }
    }catch($e){
      print($e.toString());
      // FeedBack = {
      //   'hasError':true,
      //   'msg': $e.toString(),
      // };
    }
  }

  Future<void> _saveProforma(String customerNames) async {
    try{
      feedBack = await widget._dbService.createInvoice(customerNames: customerNames);

      if(!feedBack['hasError']){
        DateTime date = DateTime.now().toUtc();

        for(Sale sale in sales){
          if(sale.getQuantity() > 0){
            Map<String, dynamic> body = {
              "product_id": sale.getProductId(),
              "cost":       sale.getCost().toString(),
              "quantity":   sale.getQuantity().toString(),
              "invoice_id": feedBack['msg'],
              "created_at": date,
              "updated_at": date,
            };

            await addSale(body);
          }
        }
      }

    }catch($e){
      print($e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final qtyWidth        = MediaQuery.of(context).size.height*0.2;
    final proformaHeight  = MediaQuery.of(context).size.height*0.65;

    qtyControllers.clear();

    return StreamProvider<QuerySnapshot>.value(
      initialData: null,

      value: DatabaseService().store,

      builder: (context, widget){
        final store = Provider.of<QuerySnapshot>(context);
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();

        if(store != null){

          if(!_isLoading){
            sales.clear();
            store.docs.forEach((product){
              Sale sale = new Sale();

              sale.setProductId(product.id);
              sale.setCost(double.parse(product['price']));
              sale.setQuantity(0);

              sales.add(sale);
            });
          }

          return (_isLoading)?LoadingWidget("Working on it, please wait."):
          Container(
            margin: EdgeInsets.all(5.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: btnStyle,

                        child: Row(
                          children: [
                            Icon(
                              Icons.save,
                              color: btnTxtColors,
                            ),

                            Text(
                              "Save",
                              style: TextStyle(
                                color: btnTxtColors,
                              ),
                            ),
                          ],
                        ),

                        onPressed: () async {
                          if(formKey.currentState.validate()){
                            SnackBar snackBar = CustomSnackBar(message: errorMsg).getSnackBar(context);

                            sales.forEach((sale) {
                              if(sale.getQuantity() > 0){
                                _canSave = true;
                              }
                            });

                            if(!_canSave){
                              snackBar = CustomSnackBar(message: "Please input products number.").getSnackBar(context);
                            }else{
                              setState(() {
                                _isLoading = true;
                              });

                              snackBar = CustomSnackBar(message: "It has saved successfully.").getSnackBar(context);

                              String customerNames = "No names";
                              bool canCreateInvoice = false;

                              await showDialog(
                                  context: context,
                                  builder: (context){
                                    TextEditingController customerNameCtr = TextEditingController();

                                    return AlertDialog(
                                      title: Text(
                                          "Enter customer names"
                                      ),

                                      content: TextFormField(
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        controller: customerNameCtr,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(
                                                  '[ a-zA-Z]'
                                              )
                                          ),
                                        ],

                                        validator: (val){
                                          if(val.startsWith(' ')){
                                            customerNameCtr.text = "";
                                            (customerNameCtr.text.isEmpty)?canCreateInvoice = false:canCreateInvoice = true;
                                          }

                                          return null;
                                        },

                                        onChanged: (val){
                                          customerNames = val;
                                          (customerNames.isEmpty)?canCreateInvoice = false:canCreateInvoice = true;
                                        },
                                      ),

                                      actions: [
                                        TextButton(
                                            child: Text(
                                                "DONE"
                                            ),

                                            onPressed: (){
                                              Navigator.pop(context, true);
                                            }
                                        )
                                      ],
                                    );
                                  }
                              );

                              if(canCreateInvoice){
                                await _saveProforma(customerNames);
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }else{
                                Fluttertoast.showToast(
                                  msg: "Customer name is missing!"
                                );
                              }

                              setState(() {
                                _isLoading = false;
                                _canSave = false;
                              });
                            }
                          }else{
                            Fluttertoast.showToast(
                              msg: "At least one product is required."
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  Stack(
                    children: [
                      /*Create Proforma*/
                      Container(
                        height: proformaHeight,

                        child: AnimatedOpacity(
                          duration: Duration(seconds: 1),

                          opacity: (viewProforma)?0:1,

                          child: (store.docs.length < 1)?LoadingWidget("Hakuna bidhaa."):
                          ListView.builder(
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()
                            ),

                            itemCount: store.docs.length,

                            itemBuilder: (context, index) {
                              TextEditingController controller = TextEditingController();
                              qtyControllers.add(controller);
                              qtyControllers[index].text = sales.elementAt(index).getQuantity().toString();

                              return Card(
                                shadowColor: themeColor,
                                elevation: cardsElevation,
                                child: ListTile(
                                  title: Text(
                                    store.docs.elementAt(index)['productCode'],
                                  ),

                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Description: "+store.docs.elementAt(index)['productDescription'],
                                      ),
                                      Text(
                                        "Piece(s): "+store.docs.elementAt(index)['pieces'].toString(),
                                      ),
                                      Text(
                                        "Price: "+store.docs.elementAt(index)['price'].toString(),
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          //Left button
                                          IconButton(
                                            icon: Icon(Icons.arrow_left),
                                            onPressed: (){
                                              try{
                                                int value = (int.parse(qtyControllers[index].text)-1);

                                                if(value < 0){
                                                  qtyControllers[index].text = "0";
                                                }else{
                                                  qtyControllers[index].text = value.toString();
                                                }
                                                sales.elementAt(index).setQuantity(value);
                                              }catch($e){
                                                print("Error: on left arrow:${$e.toString()}");
                                              }
                                            },
                                          ),

                                          //TextField
                                          Container(
                                            width: qtyWidth,
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              decoration: FormSpecs.textInputDecoration,
                                              controller: qtyControllers[index],
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(
                                                        r'\d'
                                                    )
                                                ),
                                              ],
                                              validator: (value){
                                                if(value.isEmpty){
                                                  return "This field is required.";
                                                }

                                                try{

                                                  String msg = "";

                                                  if(int.parse(value) < 0){
                                                    qtyControllers[index].text = "0";
                                                  }else if(int.parse(value) > store.docs.elementAt(index)['pieces']){
                                                    qtyControllers[index].text = store.docs.elementAt(index)['pieces'].toString();
                                                  }

                                                  sales.elementAt(index).setQuantity(int.parse(qtyControllers[index].text));

                                                }catch($e){
                                                  print("Error: On quantity input field; ${$e.toString()}");
                                                }

                                                return null;
                                              }
                                            ),
                                          ),

                                          //Right button
                                          IconButton(
                                            icon: Icon(Icons.arrow_right),

                                            onPressed: (){
                                              try{
                                                int value = (int.parse(qtyControllers[index].text)+1);

                                                if(value > store.docs.elementAt(index)['pieces']){
                                                  qtyControllers[index].text = store.docs.elementAt(index)['pieces'].toString();
                                                }else{
                                                  qtyControllers[index].text = value.toString();
                                                }
                                                sales.elementAt(index).setQuantity(value);
                                              }catch($e){
                                                print("Error: on right arrow:${$e.toString()}");
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }else if(store == null){
          return LoadingWidget(
              "Loading, please wait."
          );
        }

        return LoadingWidget(
            "Hakuna bidhaa."
        );
      },
    );
  }
}