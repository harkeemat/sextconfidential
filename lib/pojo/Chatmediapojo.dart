class Chatmediapojo {
  Chatmediapojo({
      bool? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  Chatmediapojo.fromJson(dynamic json) {
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
Chatmediapojo copyWith({  bool? status,
  String? message,
  List<Data>? data,
}) => Chatmediapojo(  status: status ?? _status,
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
      num? fromId, 
      num? toId, 
      String? message, 
      String? messageType, 
      String? seen, 
      String? price, 
      String? type, 
      String? createdAt,}){
    _id = id;
    _fromId = fromId;
    _toId = toId;
    _message = message;
    _messageType = messageType;
    _seen = seen;
    _price = price;
    _type = type;
    _createdAt = createdAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _fromId = json['from_id'];
    _toId = json['to_id'];
    _message = json['message'];
    _messageType = json['message_type'];
    _seen = json['seen'];
    _price = json['price'];
    _type = json['type'];
    _createdAt = json['created_at'];
  }
  num? _id;
  num? _fromId;
  num? _toId;
  String? _message;
  String? _messageType;
  String? _seen;
  String? _price;
  String? _type;
  String? _createdAt;
Data copyWith({  num? id,
  num? fromId,
  num? toId,
  String? message,
  String? messageType,
  String? seen,
  String? price,
  String? type,
  String? createdAt,
}) => Data(  id: id ?? _id,
  fromId: fromId ?? _fromId,
  toId: toId ?? _toId,
  message: message ?? _message,
  messageType: messageType ?? _messageType,
  seen: seen ?? _seen,
  price: price ?? _price,
  type: type ?? _type,
  createdAt: createdAt ?? _createdAt,
);
  num? get id => _id;
  num? get fromId => _fromId;
  num? get toId => _toId;
  String? get message => _message;
  String? get messageType => _messageType;
  String? get seen => _seen;
  String? get price => _price;
  String? get type => _type;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['from_id'] = _fromId;
    map['to_id'] = _toId;
    map['message'] = _message;
    map['message_type'] = _messageType;
    map['seen'] = _seen;
    map['price'] = _price;
    map['type'] = _type;
    map['created_at'] = _createdAt;
    return map;
  }

}