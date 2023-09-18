class Massmassagespojo {
  Massmassagespojo({
      bool? status, 
      List<Data>? data, 
      String? message,}){
    _status = status;
    _data = data;
    _message = message;
}

  Massmassagespojo.fromJson(dynamic json) {
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
Massmassagespojo copyWith({  bool? status,
  List<Data>? data,
  String? message,
}) => Massmassagespojo(  status: status ?? _status,
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
      num? total, 
      num? seen, 
      num? percentage, 
      String? message, 
      String? messageType, 
      String? time,}){
    _total = total;
    _seen = seen;
    _percentage = percentage;
    _message = message;
    _messageType = messageType;
    _time = time;
}

  Data.fromJson(dynamic json) {
    _total = json['total'];
    _seen = json['seen'];
    _percentage = json['percentage'];
    _message = json['message'];
    _messageType = json['message_type'];
    _time = json['time'];
  }
  num? _total;
  num? _seen;
  num? _percentage;
  String? _message;
  String? _messageType;
  String? _time;
Data copyWith({  num? total,
  num? seen,
  num? percentage,
  String? message,
  String? messageType,
  String? time,
}) => Data(  total: total ?? _total,
  seen: seen ?? _seen,
  percentage: percentage ?? _percentage,
  message: message ?? _message,
  messageType: messageType ?? _messageType,
  time: time ?? _time,
);
  num? get total => _total;
  num? get seen => _seen;
  num? get percentage => _percentage;
  String? get message => _message;
  String? get messageType => _messageType;
  String? get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = _total;
    map['seen'] = _seen;
    map['percentage'] = _percentage;
    map['message'] = _message;
    map['message_type'] = _messageType;
    map['time'] = _time;
    return map;
  }

}