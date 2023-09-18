class Getgroupuserpojo {
  Getgroupuserpojo({
      bool? status, 
      String? message, 
      Data? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  Getgroupuserpojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _status;
  String? _message;
  Data? _data;
Getgroupuserpojo copyWith({  bool? status,
  String? message,
  Data? data,
}) => Getgroupuserpojo(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}
class Data {
  Data({
      num? id, 
      String? groupname, 
      List<Groupmembers>? groupmembers,}){
    _id = id;
    _groupname = groupname;
    _groupmembers = groupmembers;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _groupname = json['groupname'];
    if (json['groupmembers'] != null) {
      _groupmembers = [];
      json['groupmembers'].forEach((v) {
        _groupmembers?.add(Groupmembers.fromJson(v));
      });
    }
  }
  num? _id;
  String? _groupname;
  List<Groupmembers>? _groupmembers;
Data copyWith({  num? id,
  String? groupname,
  List<Groupmembers>? groupmembers,
}) => Data(  id: id ?? _id,
  groupname: groupname ?? _groupname,
  groupmembers: groupmembers ?? _groupmembers,
);
  num? get id => _id;
  String? get groupname => _groupname;
  List<Groupmembers>? get groupmembers => _groupmembers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['groupname'] = _groupname;
    if (_groupmembers != null) {
      map['groupmembers'] = _groupmembers?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
class Groupmembers {
  Groupmembers({
      num? userid, 
      String? name,}){
    _userid = userid;
    _name = name;
}

  Groupmembers.fromJson(dynamic json) {
    _userid = json['userid'];
    _name = json['name'];
  }
  num? _userid;
  String? _name;
Groupmembers copyWith({  num? userid,
  String? name,
}) => Groupmembers(  userid: userid ?? _userid,
  name: name ?? _name,
);
  num? get userid => _userid;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userid'] = _userid;
    map['name'] = _name;
    return map;
  }

}