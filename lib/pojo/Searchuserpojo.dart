class Searchuserpojo {
  Searchuserpojo({
      bool? status, 
      List<Message>? message,}){
    _status = status;
    _message = message;
}

  Searchuserpojo.fromJson(dynamic json) {
    _status = json['status'];
    if (json['message'] != null) {
      _message = [];
      json['message'].forEach((v) {
        _message?.add(Message.fromJson(v));
      });
    }
  }
  bool? _status;
  List<Message>? _message;
Searchuserpojo copyWith({  bool? status,
  List<Message>? message,
}) => Searchuserpojo(  status: status ?? _status,
  message: message ?? _message,
);
  bool? get status => _status;
  List<Message>? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_message != null) {
      map['message'] = _message?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}



class Message {
  Message({
      num? id, 
      String? dname,}){
    _id = id;
    _dname = dname;
}

  Message.fromJson(dynamic json) {
    _id = json['id'];
    _dname = json['dname'];
  }
  num? _id;
  String? _dname;
Message copyWith({  num? id,
  String? dname,
}) => Message(  id: id ?? _id,
  dname: dname ?? _dname,
);
  num? get id => _id;
  String? get dname => _dname;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['dname'] = _dname;
    return map;
  }

}