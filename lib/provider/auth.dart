import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shop/models/http_exception.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
class Auth with ChangeNotifier {

  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth{
    return token !=null;
  }
  String get token{
    if(_expireDate!=null &&_expireDate.isAfter(DateTime.now())&&_token!=null ){
      return _token;
    }
    return null;
  }
  // ignore: missing_return
//  String get userId {
//    if (_expireDate != null && _expireDate.isAfter(DateTime.now()) &&
//        _userId != null) {
//      return _userId;
//    }
//  }

  String get userId => _userId;

  Future<void> _authenticate(String email, String password, String type) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$type?key=AIzaSyBUsJ2prXqi9aY3MeSw6A0zaP8krTDohdI';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'],),),);
      //here we trigger and start the timer
      _autoLogOut();
      notifyListeners();
      final prefs=await SharedPreferences.getInstance();
      final userData=json.encode({'token':_token,'userId':_userId,'expiryDate':_expireDate.toIso8601String()});
      prefs.setString('userData', userData);
    }
    catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
   return _authenticate(email, password, 'signUp');
  }

  Future<void> logIn(String email, String password) async {
   return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logOut()async{
    _expireDate=null;
    _userId=null;
    _token=null;
    if(_authTimer!=null){
      _authTimer.cancel();
      _authTimer=null;
    }
    notifyListeners();
    final presfs=await SharedPreferences.getInstance();
    presfs.clear();
  }

  void _autoLogOut(){
    if(_authTimer!=null){
      _authTimer.cancel();
    }
    final timeOut=_expireDate.difference(DateTime.now()).inSeconds;
   _authTimer= Timer(Duration(seconds: timeOut),(){logOut();});
  }

  Future<bool> tryAutoLogin()async{
    final pref= await SharedPreferences.getInstance();
    //if the user ia log in before or not
    if(!pref.containsKey('userData')){
      return false;
    }

    // if the user is log in before ,, so we need to check about the data is it valid or not
    final extractedData=json.encode(pref.getString('userData')) as Map<String,dynamic>;
    final expiryDate=DateTime.parse(extractedData['expiryDate']);

    // if the data not valid
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }

    // the data is valid ,, retreve it and start our timer
    _token=extractedData['token'];
    _userId=extractedData['userId'];
    _expireDate=extractedData['expiryDate'];
    notifyListeners();
    _autoLogOut();
    return true;
}
}
