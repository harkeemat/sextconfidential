class Getprofilepojo {
  Getprofilepojo({
      bool? status, 
      Token? token, 
      String? message,}){
    _status = status;
    _token = token;
    _message = message;
}

  Getprofilepojo.fromJson(dynamic json) {
    _status = json['status'];
    _token = json['token'] != null ? Token.fromJson(json['token']) : null;
    _message = json['message'];
  }
  bool? _status;
  Token? _token;
  String? _message;
Getprofilepojo copyWith({  bool? status,
  Token? token,
  String? message,
}) => Getprofilepojo(  status: status ?? _status,
  token: token ?? _token,
  message: message ?? _message,
);
  bool? get status => _status;
  Token? get token => _token;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_token != null) {
      map['token'] = _token?.toJson();
    }
    map['message'] = _message;
    return map;
  }

}

class Token {
  Token({
      num? id, 
      dynamic slug, 
      String? stagename, 
      dynamic dname, 
      String? email, 
      String? gender, 
      String? phone, 
      dynamic dob, 
      String? proof, 
      dynamic ipaddress, 
      dynamic devicename, 
      String? image, 
      String? type, 
      String? timezone, 
      String? userStatus, 
      String? kycStatus, 
      String? keyVal, 
      String? emailVerifiedAt, 
      dynamic extra1, 
      String? bio, 
      dynamic availability, 
      dynamic intrests, 
      String? credits, 
      dynamic url1, 
      dynamic url2, 
      dynamic url3, 
      String? notificationEmail, 
      String? notificationApp, 
      String? notificationDismiss, 
      String? phoneCalls, 
      String? videoCalls, 
      String? showOnline, 
      String? hours, 
      String? processed, 
      String? endpayperiod, 
      String? onlyfanlink, 
      String? twitterlink, 
      String? instagramlink, 
      dynamic prefrences, 
      dynamic emailnew, 
      String? locationdenial, 
      String? loggedin, 
      String? verificationid, 
      String? kycIdentification, 
      String? createdAt, 
      String? updatedAt, 
      String? deletedAt, 
      num? featured, 
      String? signature, 
      dynamic camsitelink, 
      dynamic googleId, 
      dynamic twitterId, 
      num? modelAccountVerified, 
      num? emailVerified, 
      num? ondatoForceVerifyOff, 
      String? proof2,}){
    _id = id;
    _slug = slug;
    _stagename = stagename;
    _dname = dname;
    _email = email;
    _gender = gender;
    _phone = phone;
    _dob = dob;
    _proof = proof;
    _ipaddress = ipaddress;
    _devicename = devicename;
    _image = image;
    _type = type;
    _timezone = timezone;
    _userStatus = userStatus;
    _kycStatus = kycStatus;
    _keyVal = keyVal;
    _emailVerifiedAt = emailVerifiedAt;
    _extra1 = extra1;
    _bio = bio;
    _availability = availability;
    _intrests = intrests;
    _credits = credits;
    _url1 = url1;
    _url2 = url2;
    _url3 = url3;
    _notificationEmail = notificationEmail;
    _notificationApp = notificationApp;
    _notificationDismiss = notificationDismiss;
    _phoneCalls = phoneCalls;
    _videoCalls = videoCalls;
    _showOnline = showOnline;
    _hours = hours;
    _processed = processed;
    _endpayperiod = endpayperiod;
    _onlyfanlink = onlyfanlink;
    _twitterlink = twitterlink;
    _instagramlink = instagramlink;
    _prefrences = prefrences;
    _emailnew = emailnew;
    _locationdenial = locationdenial;
    _loggedin = loggedin;
    _verificationid = verificationid;
    _kycIdentification = kycIdentification;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _featured = featured;
    _signature = signature;
    _camsitelink = camsitelink;
    _googleId = googleId;
    _twitterId = twitterId;
    _modelAccountVerified = modelAccountVerified;
    _emailVerified = emailVerified;
    _ondatoForceVerifyOff = ondatoForceVerifyOff;
    _proof2 = proof2;
}

  Token.fromJson(dynamic json) {
    _id = json['id'];
    _slug = json['slug'];
    _stagename = json['stagename'];
    _dname = json['dname'];
    _email = json['email'];
    _gender = json['gender'];
    _phone = json['phone'];
    _dob = json['dob'];
    _proof = json['proof'];
    _ipaddress = json['ipaddress'];
    _devicename = json['devicename'];
    _image = json['image'];
    _type = json['type'];
    _timezone = json['timezone'];
    _userStatus = json['user_status'];
    _kycStatus = json['kyc_status'];
    _keyVal = json['key_val'];
    _emailVerifiedAt = json['email_verified_at'];
    _extra1 = json['extra1'];
    _bio = json['bio'];
    _availability = json['availability'];
    _intrests = json['intrests'];
    _credits = json['credits'];
    _url1 = json['url1'];
    _url2 = json['url2'];
    _url3 = json['url3'];
    _notificationEmail = json['notification_email'];
    _notificationApp = json['notification_app'];
    _notificationDismiss = json['notification_dismiss'];
    _phoneCalls = json['phone_calls'];
    _videoCalls = json['video_calls'];
    _showOnline = json['show_online'];
    _hours = json['hours'];
    _processed = json['processed'];
    _endpayperiod = json['endpayperiod'];
    _onlyfanlink = json['onlyfanlink'];
    _twitterlink = json['twitterlink'];
    _instagramlink = json['instagramlink'];
    _prefrences = json['prefrences'];
    _emailnew = json['emailnew'];
    _locationdenial = json['locationdenial'];
    _loggedin = json['loggedin'];
    _verificationid = json['verificationid'];
    _kycIdentification = json['kycIdentification'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    _featured = json['featured'];
    _signature = json['signature'];
    _camsitelink = json['camsitelink'];
    _googleId = json['google_id'];
    _twitterId = json['twitter_id'];
    _modelAccountVerified = json['model_account_verified'];
    _emailVerified = json['email_verified'];
    _ondatoForceVerifyOff = json['ondato_force_verify_off'];
    _proof2 = json['proof2'];
  }
  num? _id;
  dynamic _slug;
  String? _stagename;
  dynamic _dname;
  String? _email;
  String? _gender;
  String? _phone;
  dynamic _dob;
  String? _proof;
  dynamic _ipaddress;
  dynamic _devicename;
  String? _image;
  String? _type;
  String? _timezone;
  String? _userStatus;
  String? _kycStatus;
  String? _keyVal;
  String? _emailVerifiedAt;
  dynamic _extra1;
  String? _bio;
  dynamic _availability;
  dynamic _intrests;
  String? _credits;
  dynamic _url1;
  dynamic _url2;
  dynamic _url3;
  String? _notificationEmail;
  String? _notificationApp;
  String? _notificationDismiss;
  String? _phoneCalls;
  String? _videoCalls;
  String? _showOnline;
  String? _hours;
  String? _processed;
  String? _endpayperiod;
  String? _onlyfanlink;
  String? _twitterlink;
  String? _instagramlink;
  dynamic _prefrences;
  dynamic _emailnew;
  String? _locationdenial;
  String? _loggedin;
  String? _verificationid;
  String? _kycIdentification;
  String? _createdAt;
  String? _updatedAt;
  String? _deletedAt;
  num? _featured;
  String? _signature;
  dynamic _camsitelink;
  dynamic _googleId;
  dynamic _twitterId;
  num? _modelAccountVerified;
  num? _emailVerified;
  num? _ondatoForceVerifyOff;
  String? _proof2;
Token copyWith({  num? id,
  dynamic slug,
  String? stagename,
  dynamic dname,
  String? email,
  String? gender,
  String? phone,
  dynamic dob,
  String? proof,
  dynamic ipaddress,
  dynamic devicename,
  String? image,
  String? type,
  String? timezone,
  String? userStatus,
  String? kycStatus,
  String? keyVal,
  String? emailVerifiedAt,
  dynamic extra1,
  String? bio,
  dynamic availability,
  dynamic intrests,
  String? credits,
  dynamic url1,
  dynamic url2,
  dynamic url3,
  String? notificationEmail,
  String? notificationApp,
  String? notificationDismiss,
  String? phoneCalls,
  String? videoCalls,
  String? showOnline,
  String? hours,
  String? processed,
  String? endpayperiod,
  String? onlyfanlink,
  String? twitterlink,
  String? instagramlink,
  dynamic prefrences,
  dynamic emailnew,
  String? locationdenial,
  String? loggedin,
  String? verificationid,
  String? kycIdentification,
  String? createdAt,
  String? updatedAt,
  String? deletedAt,
  num? featured,
  String? signature,
  dynamic camsitelink,
  dynamic googleId,
  dynamic twitterId,
  num? modelAccountVerified,
  num? emailVerified,
  num? ondatoForceVerifyOff,
  String? proof2,
}) => Token(  id: id ?? _id,
  slug: slug ?? _slug,
  stagename: stagename ?? _stagename,
  dname: dname ?? _dname,
  email: email ?? _email,
  gender: gender ?? _gender,
  phone: phone ?? _phone,
  dob: dob ?? _dob,
  proof: proof ?? _proof,
  ipaddress: ipaddress ?? _ipaddress,
  devicename: devicename ?? _devicename,
  image: image ?? _image,
  type: type ?? _type,
  timezone: timezone ?? _timezone,
  userStatus: userStatus ?? _userStatus,
  kycStatus: kycStatus ?? _kycStatus,
  keyVal: keyVal ?? _keyVal,
  emailVerifiedAt: emailVerifiedAt ?? _emailVerifiedAt,
  extra1: extra1 ?? _extra1,
  bio: bio ?? _bio,
  availability: availability ?? _availability,
  intrests: intrests ?? _intrests,
  credits: credits ?? _credits,
  url1: url1 ?? _url1,
  url2: url2 ?? _url2,
  url3: url3 ?? _url3,
  notificationEmail: notificationEmail ?? _notificationEmail,
  notificationApp: notificationApp ?? _notificationApp,
  notificationDismiss: notificationDismiss ?? _notificationDismiss,
  phoneCalls: phoneCalls ?? _phoneCalls,
  videoCalls: videoCalls ?? _videoCalls,
  showOnline: showOnline ?? _showOnline,
  hours: hours ?? _hours,
  processed: processed ?? _processed,
  endpayperiod: endpayperiod ?? _endpayperiod,
  onlyfanlink: onlyfanlink ?? _onlyfanlink,
  twitterlink: twitterlink ?? _twitterlink,
  instagramlink: instagramlink ?? _instagramlink,
  prefrences: prefrences ?? _prefrences,
  emailnew: emailnew ?? _emailnew,
  locationdenial: locationdenial ?? _locationdenial,
  loggedin: loggedin ?? _loggedin,
  verificationid: verificationid ?? _verificationid,
  kycIdentification: kycIdentification ?? _kycIdentification,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  deletedAt: deletedAt ?? _deletedAt,
  featured: featured ?? _featured,
  signature: signature ?? _signature,
  camsitelink: camsitelink ?? _camsitelink,
  googleId: googleId ?? _googleId,
  twitterId: twitterId ?? _twitterId,
  modelAccountVerified: modelAccountVerified ?? _modelAccountVerified,
  emailVerified: emailVerified ?? _emailVerified,
  ondatoForceVerifyOff: ondatoForceVerifyOff ?? _ondatoForceVerifyOff,
  proof2: proof2 ?? _proof2,
);
  num? get id => _id;
  dynamic get slug => _slug;
  String? get stagename => _stagename;
  dynamic get dname => _dname;
  String? get email => _email;
  String? get gender => _gender;
  String? get phone => _phone;
  dynamic get dob => _dob;
  String? get proof => _proof;
  dynamic get ipaddress => _ipaddress;
  dynamic get devicename => _devicename;
  String? get image => _image;
  String? get type => _type;
  String? get timezone => _timezone;
  String? get userStatus => _userStatus;
  String? get kycStatus => _kycStatus;
  String? get keyVal => _keyVal;
  String? get emailVerifiedAt => _emailVerifiedAt;
  dynamic get extra1 => _extra1;
  String? get bio => _bio;
  dynamic get availability => _availability;
  dynamic get intrests => _intrests;
  String? get credits => _credits;
  dynamic get url1 => _url1;
  dynamic get url2 => _url2;
  dynamic get url3 => _url3;
  String? get notificationEmail => _notificationEmail;
  String? get notificationApp => _notificationApp;
  String? get notificationDismiss => _notificationDismiss;
  String? get phoneCalls => _phoneCalls;
  String? get videoCalls => _videoCalls;
  String? get showOnline => _showOnline;
  String? get hours => _hours;
  String? get processed => _processed;
  String? get endpayperiod => _endpayperiod;
  String? get onlyfanlink => _onlyfanlink;
  String? get twitterlink => _twitterlink;
  String? get instagramlink => _instagramlink;
  dynamic get prefrences => _prefrences;
  dynamic get emailnew => _emailnew;
  String? get locationdenial => _locationdenial;
  String? get loggedin => _loggedin;
  String? get verificationid => _verificationid;
  String? get kycIdentification => _kycIdentification;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get deletedAt => _deletedAt;
  num? get featured => _featured;
  String? get signature => _signature;
  dynamic get camsitelink => _camsitelink;
  dynamic get googleId => _googleId;
  dynamic get twitterId => _twitterId;
  num? get modelAccountVerified => _modelAccountVerified;
  num? get emailVerified => _emailVerified;
  num? get ondatoForceVerifyOff => _ondatoForceVerifyOff;
  String? get proof2 => _proof2;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['slug'] = _slug;
    map['stagename'] = _stagename;
    map['dname'] = _dname;
    map['email'] = _email;
    map['gender'] = _gender;
    map['phone'] = _phone;
    map['dob'] = _dob;
    map['proof'] = _proof;
    map['ipaddress'] = _ipaddress;
    map['devicename'] = _devicename;
    map['image'] = _image;
    map['type'] = _type;
    map['timezone'] = _timezone;
    map['user_status'] = _userStatus;
    map['kyc_status'] = _kycStatus;
    map['key_val'] = _keyVal;
    map['email_verified_at'] = _emailVerifiedAt;
    map['extra1'] = _extra1;
    map['bio'] = _bio;
    map['availability'] = _availability;
    map['intrests'] = _intrests;
    map['credits'] = _credits;
    map['url1'] = _url1;
    map['url2'] = _url2;
    map['url3'] = _url3;
    map['notification_email'] = _notificationEmail;
    map['notification_app'] = _notificationApp;
    map['notification_dismiss'] = _notificationDismiss;
    map['phone_calls'] = _phoneCalls;
    map['video_calls'] = _videoCalls;
    map['show_online'] = _showOnline;
    map['hours'] = _hours;
    map['processed'] = _processed;
    map['endpayperiod'] = _endpayperiod;
    map['onlyfanlink'] = _onlyfanlink;
    map['twitterlink'] = _twitterlink;
    map['instagramlink'] = _instagramlink;
    map['prefrences'] = _prefrences;
    map['emailnew'] = _emailnew;
    map['locationdenial'] = _locationdenial;
    map['loggedin'] = _loggedin;
    map['verificationid'] = _verificationid;
    map['kycIdentification'] = _kycIdentification;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    map['featured'] = _featured;
    map['signature'] = _signature;
    map['camsitelink'] = _camsitelink;
    map['google_id'] = _googleId;
    map['twitter_id'] = _twitterId;
    map['model_account_verified'] = _modelAccountVerified;
    map['email_verified'] = _emailVerified;
    map['ondato_force_verify_off'] = _ondatoForceVerifyOff;
    map['proof2'] = _proof2;
    return map;
  }

}