import 'dart:convert';
import 'dart:io';

import 'package:chatapp/core/model/student.dart';
import 'package:chatapp/core/model/user.dart';
import 'package:chatapp/core/model/user/user_auth_error.dart';
import 'package:chatapp/core/model/user/user_request.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  static const String BASE_URL = "https://chatapp-75ad6.firebaseio.com/";
  static const String AUTH_URL = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyClB2elZ0BqUz3sYk1NNhJ1tSmF0HM0_5U";

    Future postUser(UserRequest request) async {
    var jsonModel = json.encode(request.toJson());
    final res = await http.post(AUTH_URL,body:jsonModel);

    switch (res.statusCode) {
      case HttpStatus.ok:

        return true;
      default:
        var errorJson = json.decode(res.body);
        var errorModel = FirebaseAuthError.fromJson(errorJson);
        return errorModel;
    }
  }
  
  
  Future<List<User>> getUsers() async {
    final res = await http.get('$BASE_URL/users.json');

    switch (res.statusCode) {
      case HttpStatus.ok:
        final jsonModel = json.decode(res.body);
        final userList = jsonModel
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList().cast<User>();
        return userList;
      default:
        return Future.error(res.statusCode);
    }
  }

    Future<List<Student>> getStudents() async {
    final res = await http.get('$BASE_URL/students.json');

    switch (res.statusCode) {
      case HttpStatus.ok:
        final jsonModel = json.decode(res.body) as Map;
        final studentList = List<Student>();
        jsonModel.forEach((key,value){
          Student student = Student.fromJson(value);
          student.key = key;
            studentList.add(student);
        });
        
        return studentList;
      default:
        return Future.error(res.statusCode);
    }
  }
}
