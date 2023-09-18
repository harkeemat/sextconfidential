class Chatuserpojo {
  Chatuserpojo({
      bool? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  Chatuserpojo.fromJson(dynamic json) {
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
Chatuserpojo copyWith({  bool? status,
  String? message,
  List<Data>? data,
}) => Chatuserpojo(  status: status ?? _status,
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
      num? userid, 
      String? useriname, 
      String? useriimage, 
      String? messageType, 
      String? lastmessage, 
      String? lastmessagetime, 
      num? messagecount,}){
    _userid = userid;
    _useriname = useriname;
    _useriimage = useriimage;
    _messageType = messageType;
    _lastmessage = lastmessage;
    _lastmessagetime = lastmessagetime;
    _messagecount = messagecount;
}

  Data.fromJson(dynamic json) {
    _userid = json['userid'];
    _useriname = json['useriname'];
    _useriimage = json['useriimage'];
    _messageType = json['message_type'];
    _lastmessage = json['lastmessage'];
    _lastmessagetime = json['lastmessagetime'];
    _messagecount = json['messagecount'];
  }
  num? _userid;
  String? _useriname;
  String? _useriimage;
  String? _messageType;
  String? _lastmessage;
  String? _lastmessagetime;
  num? _messagecount;
Data copyWith({  num? userid,
  String? useriname,
  String? useriimage,
  String? messageType,
  String? lastmessage,
  String? lastmessagetime,
  num? messagecount,
}) => Data(  userid: userid ?? _userid,
  useriname: useriname ?? _useriname,
  useriimage: useriimage ?? _useriimage,
  messageType: messageType ?? _messageType,
  lastmessage: lastmessage ?? _lastmessage,
  lastmessagetime: lastmessagetime ?? _lastmessagetime,
  messagecount: messagecount ?? _messagecount,
);
  num? get userid => _userid;
  String? get useriname => _useriname;
  String? get useriimage => _useriimage;
  String? get messageType => _messageType;
  String? get lastmessage => _lastmessage;
  String? get lastmessagetime => _lastmessagetime;
  num? get messagecount => _messagecount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userid'] = _userid;
    map['useriname'] = _useriname;
    map['useriimage'] = _useriimage;
    map['message_type'] = _messageType;
    map['lastmessage'] = _lastmessage;
    map['lastmessagetime'] = _lastmessagetime;
    map['messagecount'] = _messagecount;
    return map;
  }

}