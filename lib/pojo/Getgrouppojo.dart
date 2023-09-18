class Getgrouppojo {
  Getgrouppojo({
      bool? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  Getgrouppojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Data>? _data;
Getgrouppojo copyWith({  bool? status,
  String? message,
  List<Data>? data,
}) => Getgrouppojo(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class Data {
  Data({
      num? id, 
      String? groupname,}){
    _id = id;
    _groupname = groupname;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _groupname = json['groupname'];
  }
  num? _id;
  String? _groupname;
Data copyWith({  num? id,
  String? groupname,
}) => Data(  id: id ?? _id,
  groupname: groupname ?? _groupname,
);
  num? get id => _id;
  String? get groupname => _groupname;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['groupname'] = _groupname;
    return map;
  }

}