import 'package:chatapp/core/model/student.dart';
import 'package:chatapp/core/model/user.dart';
import 'package:chatapp/core/services/firebase_service.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  HomePageView({Key key}) : super(key: key);

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  FirebaseService service;
  @override
  void initState() {
    super.initState();
    service = FirebaseService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: studentFutureBuilder
    );
  }

    Widget get userFutureBuilder => FutureBuilder<List<User>>(
      future: service.getUsers(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData)
              return _listUser(snapshot.data);
            else
              return _notUserFound;

            break;
          default:
            return _waiting;
        }
      });

  Widget get studentFutureBuilder => FutureBuilder<List<Student>>(
      future: service.getStudents(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasData)
              return _listStudent(snapshot.data);
            else
              return _notUserFound;

            break;
          default:
            return _waiting;
        }
      });

  Widget _listUser(List<User> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => _userCard(list[index]),
    );
  }
    Widget _listStudent(List<Student> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => _studentCard(list[index]),
    );
  }

  Widget _userCard(User user) {
    return Card(
      child: ListTile(
        title: Text(user.name),
      ),
    );
  }

    Widget _studentCard(Student student) {
    return Card(
      child: ListTile(
        title: Text(student.name),
        subtitle: Text(student.number.toString()),
      ),
    );
  }

  Widget get _notUserFound => Center(
        child: Text("Kullanıcı Bulunamadı!"),
      );
  Widget get _waiting => Center(child: CircularProgressIndicator());
}
