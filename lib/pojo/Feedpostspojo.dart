class Feedpostspojo {
  Feedpostspojo({
      bool? status, 
      Message? message,}){
    _status = status;
    _message = message;
}

  Feedpostspojo.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'] != null ? Message.fromJson(json['message']) : null;
  }
  bool? _status;
  Message? _message;
Feedpostspojo copyWith({  bool? status,
  Message? message,
}) => Feedpostspojo(  status: status ?? _status,
  message: message ?? _message,
);
  bool? get status => _status;
  Message? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_message != null) {
      map['message'] = _message?.toJson();
    }
    return map;
  }

}

class Message {
  Message({
      List<Schedule>? schedule, 
      List<SaveDraft>? saveDraft, 
      List<Post>? post,}){
    _schedule = schedule;
    _saveDraft = saveDraft;
    _post = post;
}

  Message.fromJson(dynamic json) {
    if (json['Schedule'] != null) {
      _schedule = [];
      json['Schedule'].forEach((v) {
        _schedule?.add(Schedule.fromJson(v));
      });
    }
    if (json['SaveDraft'] != null) {
      _saveDraft = [];
      json['SaveDraft'].forEach((v) {
        _saveDraft?.add(SaveDraft.fromJson(v));
      });
    }
    if (json['Post'] != null) {
      _post = [];
      json['Post'].forEach((v) {
        _post?.add(Post.fromJson(v));
      });
    }
  }
  List<Schedule>? _schedule;
  List<SaveDraft>? _saveDraft;
  List<Post>? _post;
Message copyWith({  List<Schedule>? schedule,
  List<SaveDraft>? saveDraft,
  List<Post>? post,
}) => Message(  schedule: schedule ?? _schedule,
  saveDraft: saveDraft ?? _saveDraft,
  post: post ?? _post,
);
  List<Schedule>? get schedule => _schedule;
  List<SaveDraft>? get saveDraft => _saveDraft;
  List<Post>? get post => _post;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_schedule != null) {
      map['Schedule'] = _schedule?.map((v) => v.toJson()).toList();
    }
    if (_saveDraft != null) {
      map['SaveDraft'] = _saveDraft?.map((v) => v.toJson()).toList();
    }
    if (_post != null) {
      map['Post'] = _post?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class Post {
  Post({
      String? ago, 
      num? id, 
      String? url, 
      String? filetype, 
      String? text, 
      String? views, 
      String? likes, 
      String? price, 
      String? scheduledate, 
      String? unlocked, 
      String? earning, 
      String? pinned,}){
    _ago = ago;
    _id = id;
    _url = url;
    _filetype = filetype;
    _text = text;
    _views = views;
    _likes = likes;
    _price = price;
    _scheduledate = scheduledate;
    _unlocked = unlocked;
    _earning = earning;
    _pinned = pinned;
}

  Post.fromJson(dynamic json) {
    _ago = json['ago'];
    _id = json['id'];
    _url = json['url'];
    _filetype = json['filetype'];
    _text = json['text'];
    _views = json['views'];
    _likes = json['likes'];
    _price = json['price'];
    _scheduledate = json['scheduledate'];
    _unlocked = json['unlocked'];
    _earning = json['earning'];
    _pinned = json['pinned'];
  }
  String? _ago;
  num? _id;
  String? _url;
  String? _filetype;
  String? _text;
  String? _views;
  String? _likes;
  String? _price;
  String? _scheduledate;
  String? _unlocked;
  String? _earning;
  String? _pinned;
Post copyWith({  String? ago,
  num? id,
  String? url,
  String? filetype,
  String? text,
  String? views,
  String? likes,
  String? price,
  String? scheduledate,
  String? unlocked,
  String? earning,
  String? pinned,
}) => Post(  ago: ago ?? _ago,
  id: id ?? _id,
  url: url ?? _url,
  filetype: filetype ?? _filetype,
  text: text ?? _text,
  views: views ?? _views,
  likes: likes ?? _likes,
  price: price ?? _price,
  scheduledate: scheduledate ?? _scheduledate,
  unlocked: unlocked ?? _unlocked,
  earning: earning ?? _earning,
  pinned: pinned ?? _pinned,
);
  String? get ago => _ago;
  num? get id => _id;
  String? get url => _url;
  String? get filetype => _filetype;
  String? get text => _text;
  String? get views => _views;
  String? get likes => _likes;
  String? get price => _price;
  String? get scheduledate => _scheduledate;
  String? get unlocked => _unlocked;
  String? get earning => _earning;
  String? get pinned => _pinned;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ago'] = _ago;
    map['id'] = _id;
    map['url'] = _url;
    map['filetype'] = _filetype;
    map['text'] = _text;
    map['views'] = _views;
    map['likes'] = _likes;
    map['price'] = _price;
    map['scheduledate'] = _scheduledate;
    map['unlocked'] = _unlocked;
    map['earning'] = _earning;
    map['pinned'] = _pinned;
    return map;
  }

}



class SaveDraft {
  SaveDraft({
      String? ago, 
      num? id, 
      String? url, 
      String? filetype, 
      String? text, 
      String? views, 
      String? likes, 
      String? price, 
      String? scheduledate, 
      String? earning, 
      String? pinned,}){
    _ago = ago;
    _id = id;
    _url = url;
    _filetype = filetype;
    _text = text;
    _views = views;
    _likes = likes;
    _price = price;
    _scheduledate = scheduledate;
    _earning = earning;
    _pinned = pinned;
}

  SaveDraft.fromJson(dynamic json) {
    _ago = json['ago'];
    _id = json['id'];
    _url = json['url'];
    _filetype = json['filetype'];
    _text = json['text'];
    _views = json['views'];
    _likes = json['likes'];
    _price = json['price'];
    _scheduledate = json['scheduledate'];
    _earning = json['earning'];
    _pinned = json['pinned'];
  }
  String? _ago;
  num? _id;
  String? _url;
  String? _filetype;
  String? _text;
  String? _views;
  String? _likes;
  String? _price;
  String? _scheduledate;
  String? _earning;
  String? _pinned;
SaveDraft copyWith({  String? ago,
  num? id,
  String? url,
  String? filetype,
  String? text,
  String? views,
  String? likes,
  String? price,
  String? scheduledate,
  String? earning,
  String? pinned,
}) => SaveDraft(  ago: ago ?? _ago,
  id: id ?? _id,
  url: url ?? _url,
  filetype: filetype ?? _filetype,
  text: text ?? _text,
  views: views ?? _views,
  likes: likes ?? _likes,
  price: price ?? _price,
  scheduledate: scheduledate ?? _scheduledate,
  earning: earning ?? _earning,
  pinned: pinned ?? _pinned,
);
  String? get ago => _ago;
  num? get id => _id;
  String? get url => _url;
  String? get filetype => _filetype;
  String? get text => _text;
  String? get views => _views;
  String? get likes => _likes;
  String? get price => _price;
  String? get scheduledate => _scheduledate;
  String? get earning => _earning;
  String? get pinned => _pinned;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ago'] = _ago;
    map['id'] = _id;
    map['url'] = _url;
    map['filetype'] = _filetype;
    map['text'] = _text;
    map['views'] = _views;
    map['likes'] = _likes;
    map['price'] = _price;
    map['scheduledate'] = _scheduledate;
    map['earning'] = _earning;
    map['pinned'] = _pinned;
    return map;
  }

}

class Schedule {
  Schedule({
      String? ago, 
      num? id, 
      String? url, 
      String? filetype, 
      String? text, 
      String? views, 
      String? likes, 
      String? price, 
      String? scheduledate, 
      String? unlocked, 
      String? earning, 
      String? pinned,}){
    _ago = ago;
    _id = id;
    _url = url;
    _filetype = filetype;
    _text = text;
    _views = views;
    _likes = likes;
    _price = price;
    _scheduledate = scheduledate;
    _unlocked = unlocked;
    _earning = earning;
    _pinned = pinned;
}

  Schedule.fromJson(dynamic json) {
    _ago = json['ago'];
    _id = json['id'];
    _url = json['url'];
    _filetype = json['filetype'];
    _text = json['text'];
    _views = json['views'];
    _likes = json['likes'];
    _price = json['price'];
    _scheduledate = json['scheduledate'];
    _unlocked = json['unlocked'];
    _earning = json['earning'];
    _pinned = json['pinned'];
  }
  String? _ago;
  num? _id;
  String? _url;
  String? _filetype;
  String? _text;
  String? _views;
  String? _likes;
  String? _price;
  String? _scheduledate;
  String? _unlocked;
  String? _earning;
  String? _pinned;
Schedule copyWith({  String? ago,
  num? id,
  String? url,
  String? filetype,
  String? text,
  String? views,
  String? likes,
  String? price,
  String? scheduledate,
  String? unlocked,
  String? earning,
  String? pinned,
}) => Schedule(  ago: ago ?? _ago,
  id: id ?? _id,
  url: url ?? _url,
  filetype: filetype ?? _filetype,
  text: text ?? _text,
  views: views ?? _views,
  likes: likes ?? _likes,
  price: price ?? _price,
  scheduledate: scheduledate ?? _scheduledate,
  unlocked: unlocked ?? _unlocked,
  earning: earning ?? _earning,
  pinned: pinned ?? _pinned,
);
  String? get ago => _ago;
  num? get id => _id;
  String? get url => _url;
  String? get filetype => _filetype;
  String? get text => _text;
  String? get views => _views;
  String? get likes => _likes;
  String? get price => _price;
  String? get scheduledate => _scheduledate;
  String? get unlocked => _unlocked;
  String? get earning => _earning;
  String? get pinned => _pinned;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ago'] = _ago;
    map['id'] = _id;
    map['url'] = _url;
    map['filetype'] = _filetype;
    map['text'] = _text;
    map['views'] = _views;
    map['likes'] = _likes;
    map['price'] = _price;
    map['scheduledate'] = _scheduledate;
    map['unlocked'] = _unlocked;
    map['earning'] = _earning;
    map['pinned'] = _pinned;
    return map;
  }

}