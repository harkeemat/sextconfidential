import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';
import '/models/twilio_room_by_sid_request.dart';
import '/models/twilio_room_response.dart';
import '/models/twilio_room_token_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/twilio_list_room_request.dart';
import '../../models/twilio_list_room_response.dart';
import '../../models/twilio_room_by_unique_name_request.dart';
import '../../models/twilio_room_request.dart';
import '../../models/twilio_room_token_response.dart';
import 'package:http/http.dart' as http;

import '../../utils/Networks.dart';

abstract class BackendService {
  Future<TwilioRoomResponse> completeRoomBySid(
      TwilioRoomBySidRequest twilioRoomBySidRequest);
  Future<TwilioRoomResponse> createRoom(TwilioRoomRequest twilioRoomRequest);
  Future<TwilioRoomTokenResponse> createToken(
      TwilioRoomTokenRequest twilioRoomTokenRequest);
  Future<TwilioRoomResponse> getRoomBySid(
      TwilioRoomBySidRequest twilioRoomBySidRequest);
  Future<TwilioRoomResponse> getRoomByUniqueName(
      TwilioRoomByUniqueNameRequest twilioRoomByUniqueNameRequest);
  Future<TwilioListRoomResponse> listRooms(
      TwilioListRoomRequest twilioListRoomRequest);
}

class FirebaseFunctionsService implements BackendService {
  FirebaseFunctionsService._();

  static final instance = FirebaseFunctionsService._();

  final FirebaseFunctions cf =
      FirebaseFunctions.instanceFor(region: 'europe-west1');

  @override
  Future<TwilioRoomResponse> completeRoomBySid(
      TwilioRoomBySidRequest twilioRoomBySidRequest) async {
    try {
      // final response = await cf
      //     .httpsCallable('completeRoomBySid')
      //     .call(twilioRoomBySidRequest.toMap());
      final response = {"sid": "AC3cb58709e1454bbc0aa952eb833b6946"};
      return TwilioRoomResponse.fromMap(Map<String, dynamic>.from(response));
    } on FirebaseFunctionsException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
        details: e.details,
      );
    }
  }

  @override
  Future<TwilioRoomResponse> createRoom(
      TwilioRoomRequest twilioRoomRequest) async {
    try {
      print("create$twilioRoomRequest");
      final response =
          await cf.httpsCallable('createRoom').call(twilioRoomRequest.toMap());
      return TwilioRoomResponse.fromMap(
          Map<String, dynamic>.from(response.data));
    } on FirebaseFunctionsException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
        details: e.details,
      );
    }
  }

  @override
  Future<TwilioRoomTokenResponse> createToken(
      TwilioRoomTokenRequest twilioRoomTokenRequest) async {
    try {
      //print("create${twilioRoomTokenRequest.uniqueName}");
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      Map tokenupdate = {
        "token": sharedPreferences.getString("token").toString(),
        "id": "18",
      };
      var jsonResponse;
      var response = await http.post(
          Uri.parse(Networks.baseurl + Networks.videocalltoken),
          body: tokenupdate);
      jsonResponse = json.decode(response.body);
      jsonResponse['data'] = {
        "uniqueName": twilioRoomTokenRequest.uniqueName,
        "identity": "demo",
        "token":
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImN0eSI6InR3aWxpby1mcGE7dj0xIn0.eyJqdGkiOiJTS2E5NGQ3Mjc4OWE1YzA5NjZhZGVlMWNhZWZiOTkwNjNjLTE2OTg0OTA2ODAiLCJpc3MiOiJTS2E5NGQ3Mjc4OWE1YzA5NjZhZGVlMWNhZWZiOTkwNjNjIiwic3ViIjoiQUM3YWM2YjU5OTFmNTc4NTU3ZDg2Nzk4YmE4NWI4N2E3ZSIsImV4cCI6MTY5ODUyNjY4MCwiZ3JhbnRzIjp7ImlkZW50aXR5IjoiTWljaGFlbCIsInZpZGVvIjp7InJvb20iOiIxNTVfODUzMyJ9fX0.Lmv2FZ9Ccxk0KQw5sfhLzP1DjuX6GRaMtlwe3MjrH6c"
      };
      print("token get ${jsonResponse['data']}");
      return TwilioRoomTokenResponse.fromMap(
          Map<String, dynamic>.from(jsonResponse['data']));
    } on FirebaseFunctionsException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
        details: e.details,
      );
    }
  }

  @override
  Future<TwilioRoomResponse> getRoomBySid(
      TwilioRoomBySidRequest twilioRoomBySidRequest) async {
    try {
      print("siddd get ");
      final response = await cf
          .httpsCallable('getRoomBySid')
          .call(twilioRoomBySidRequest.toMap());
      return TwilioRoomResponse.fromMap(
          Map<String, dynamic>.from(response.data));
    } on FirebaseFunctionsException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
        details: e.details,
      );
    }
  }

  @override
  Future<TwilioRoomResponse> getRoomByUniqueName(
      TwilioRoomByUniqueNameRequest twilioRoomByUniqueNameRequest) async {
    try {
      final response = await cf
          .httpsCallable('getRoomByUniqueName')
          .call(twilioRoomByUniqueNameRequest.toMap());
      return TwilioRoomResponse.fromMap(
          Map<String, dynamic>.from(response.data));
    } on FirebaseFunctionsException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
        details: e.details,
      );
    }
  }

  @override
  Future<TwilioListRoomResponse> listRooms(
      TwilioListRoomRequest twilioListRoomRequest) async {
    try {
      final response = await cf
          .httpsCallable('listRooms')
          .call(twilioListRoomRequest.toMap());
      return TwilioListRoomResponse.fromMap(
          Map<String, dynamic>.from(response.data));
    } on FirebaseFunctionsException catch (e) {
      throw PlatformException(
        code: e.code,
        message: e.message,
        details: e.details,
      );
    }
  }
}
