class Sale{
  int _index = -1;
  bool _isListed = false;
  String _productId = "Empty";
  double _price = 0;
  int _quantity = 0;
  String _invoiceId = "Empty";

  //Getter methods
  bool isListed(){
    return this._isListed;
  }

  String getProductId(){
    return this._productId;
  }

  double getCost(){
    return this._price;
  }

  int getQuantity(){
    return this._quantity;
  }

  String getInvoiceId(){
    return this._invoiceId;
  }

  //Setter methods
  void toggleList(bool inList){
    this._isListed = inList;
  }

  void setProductId(String productId){
    this._productId = productId;
  }

  void setCost(double cost){
    this._price = cost;
  }

  void setQuantity(int qty){
    this._quantity = qty;
  }

  void setInvoiceId(String invoiceId){
    this._invoiceId = invoiceId;
  }
}