import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitality_hygiene_products/custom_widgets/LoadingWidget.dart';
import 'package:vitality_hygiene_products/functions/printing/PrintInvoice.dart';
import 'package:vitality_hygiene_products/services/DatabaseService.dart';
import 'package:vitality_hygiene_products/shared/constants.dart';

class ViewSales extends StatefulWidget {
  //const ViewSales({Key? key}) : super(key: key);
  final DatabaseService _dbServices = DatabaseService();
  

  @override
  _ViewSalesState createState() => _ViewSalesState();
}

class _ViewSalesState extends State<ViewSales> {
  String invoiceId;
  bool hasLoaded = false;

  @override
  Widget build(BuildContext context) {
    final double invoicesListHeight = MediaQuery.of(context).size.height * 0.22;
    final double invoicesListWidth  = MediaQuery.of(context).size.height * .5;
    final double salesViewHeight    = MediaQuery.of(context).size.height * 0.5;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /*View Proforma*/
        StreamProvider<QuerySnapshot>.value(
          value: widget._dbServices.store,

          builder: (storeContext, products){
            final products = Provider.of<QuerySnapshot>(storeContext);

            if(products == null){
              return Text(
                  "No data."
              );
            }

            if(products.docs.isNotEmpty){
              return StreamProvider<QuerySnapshot>.value(
                initialData: null,
                value: widget._dbServices.getInvoices,
                builder: (invoiceContext, invoices){
                  final invoices = Provider.of<QuerySnapshot>(invoiceContext);

                  if(invoices == null){
                    return Text(
                        "No data."
                    );
                  }

                  if(invoices.docs.length < 1){
                    return LoadingWidget("No sales.");
                  }else{
                    if(!hasLoaded && invoices.docs.length > 0)
                      invoiceId = invoices.docs.elementAt(0).id;hasLoaded = true;

                    return Column(
                      children: [
                        /*Invoices*/
                        Container(
                          height: invoicesListHeight,
                          width: invoicesListWidth,

                          margin: EdgeInsets.all(
                              10.0
                          ),

                          child: ListView.builder(
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()
                            ),

                            scrollDirection: Axis.horizontal,
                            itemCount: invoices.docs.length,

                            itemBuilder: (invoiceContext, item){
                              String customerNames = invoices.docs.elementAt(item)['customer_names'];
                              String addedBy = invoices.docs.elementAt(item)['added_by'];
                              Timestamp createdAtTimestamp = invoices.docs.elementAt(item)["created_at"];
                              DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtTimestamp.millisecondsSinceEpoch);

                              String creationDate = "${createdAt.day}/${createdAt.month}/${createdAt.year}";
                              String creationTime = "${createdAt.hour}:${createdAt.minute}";
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    invoiceId = invoices.docs.elementAt(item).id;
                                  });
                                },

                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(borderRadius),

                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: boxShadowColor,
                                        blurRadius: blurRadius,
                                        spreadRadius: spreadRadius,
                                      ),
                                    ],
                                  ) ,

                                  margin: EdgeInsets.all(
                                      formMargin
                                  ),

                                  padding: EdgeInsets.only(
                                    left: formPadding,
                                    right: formPadding,
                                  ),

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    crossAxisAlignment: CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                          "Customer Names: $customerNames"
                                      ),
                                      Text(
                                          "Added by: $addedBy"
                                      ),
                                      Text(
                                          "Date: "+creationDate
                                      ),
                                      Text(
                                          "Time: "+creationTime
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Print"
                                        ),
                                        onPressed: (){
                                          setState(() {
                                            invoiceId = invoices.docs.elementAt(item).id;
                                          });

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context){
                                                    return StreamProvider<QuerySnapshot>.value(
                                                      initialData: null,
                                                      value: DatabaseService(query: invoiceId,).getSales,

                                                      child: PrintInvoice(
                                                        invoiceId: invoiceId,
                                                        customerNames: customerNames,
                                                      ),
                                                    );
                                                  }
                                              )
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        /*Sales*/
                        Container(
                          height: salesViewHeight,

                          child: StreamProvider<QuerySnapshot>.value(
                            initialData: null,
                            value: DatabaseService(query: invoiceId).getSales,

                            builder: (saleContext, sales){
                              final sales = Provider.of<QuerySnapshot>(saleContext);

                              if(sales == null){
                                return Text(
                                    "No data."
                                );
                              }

                              if(sales.docs.isNotEmpty){

                                return ListView(
                                  children: [
                                    DataTable(
                                      horizontalMargin: 1.0,

                                      columnSpacing: 1.0,

                                      columns: <DataColumn>[
                                        DataColumn(
                                          label: Text(
                                              "Quantity"
                                          ),
                                        ),

                                        DataColumn(
                                          label: Text(
                                              "Description"
                                          ),
                                        ),

                                        DataColumn(
                                          label: Text(
                                              "Cost"
                                          ),
                                        ),

                                        DataColumn(
                                          label: Text(
                                              "Amount"
                                          ),
                                        )
                                      ],

                                      rows: sales.docs.map((sale) {
                                        String productName = "No name was assigned.";

                                        products.docs.map((product){
                                          if(product.id == sale['product_id']){
                                            productName = product['productDescription'];
                                          }
                                        }).toList();

                                        return DataRow(
                                          cells: <DataCell>[
                                            DataCell(
                                              Text(
                                                  sale['quantity']
                                              ),
                                            ),

                                            DataCell(
                                              Text(
                                                  productName
                                              ),
                                            ),

                                            DataCell(
                                              Text(
                                                  sale['cost']
                                              ),
                                            ),

                                            DataCell(
                                              Text(
                                                  (double.parse(sale['cost'])*int.parse(sale['quantity'])).toString()
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                );
                              }

                              return SizedBox(height: 0.0, width: 0.0,);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              );
            }else{
              return LoadingWidget(
                  "There was a problem loading sales."
              );
            }

            return SizedBox(height: 0.0, width: 0.0,);
          },

          initialData: null,
        ),
      ],
    );
  }
}
