class GetOrderBalance {
  String _balance ;

  GetOrderBalance({String balance
  }){
    this._balance = balance ;
  }

  String get balance => _balance;

  GetOrderBalance.fromJson(Map<String, dynamic> json){
    _balance = json['balance'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this._balance ;
  }
}