class Getpayoutpojo {
  Getpayoutpojo({
      bool? status, 
      List<Data>? data, 
      String? message,}){
    _status = status;
    _data = data;
    _message = message;
}

  Getpayoutpojo.fromJson(dynamic json) {
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _message = json['message'];
  }
  bool? _status;
  List<Data>? _data;
  String? _message;
Getpayoutpojo copyWith({  bool? status,
  List<Data>? data,
  String? message,
}) => Getpayoutpojo(  status: status ?? _status,
  data: data ?? _data,
  message: message ?? _message,
);
  bool? get status => _status;
  List<Data>? get data => _data;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['message'] = _message;
    return map;
  }

}


class Data {
  Data({
      String? name, 
      String? status, 
      String? value,}){
    _name = name;
    _status = status;
    _value = value;
}

  Data.fromJson(dynamic json) {
    _name = json['name'];
    _status = json['status'];
    _value = json['value'];
  }
  String? _name;
  String? _status;
  String? _value;
Data copyWith({  String? name,
  String? status,
  String? value,
}) => Data(  name: name ?? _name,
  status: status ?? _status,
  value: value ?? _value,
);
  String? get name => _name;
  String? get status => _status;
  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['status'] = _status;
    map['value'] = _value;
    return map;
  }

}