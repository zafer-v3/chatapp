import 'package:chatapp/core/model/user/user_auth_error.dart';
import 'package:chatapp/core/model/user/user_request.dart';
import 'package:chatapp/core/services/firebase_service.dart';
import 'package:chatapp/ui/view/home/home_page.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String userName;
  String password;
  FirebaseService service = FirebaseService();

  GlobalKey<ScaffoldState> scaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      body: Center(
        child: Padding(
          padding:  EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (val){
                  setState(() {
                    this.userName=val;
                  });
                },
                decoration: InputDecoration(border:OutlineInputBorder(),labelText: "Kullanıcı Adı"),
              ),
              SizedBox(height: 15.0,),
              TextField(
                obscureText: true,
                onChanged: (val){
                  setState(() {
                    this.password = val;
                  });
                },
                decoration: InputDecoration(border:OutlineInputBorder(),labelText: "Şifre"),
              ),
              SizedBox(height: 15.0,),
              FloatingActionButton.extended(
                onPressed: () async {
                  var result= await service.postUser(UserRequest(email: userName,password: password,returnSecureToken: true));
                  
                  if(result is FirebaseAuthError)
                  {
                   scaffold.currentState.showSnackBar(SnackBar(content: Text(result.error.message)));
                  }else{
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomePageView()));
                  }


                },
                label: Text("Giriş"),
                icon: Icon(Icons.assignment_ind),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
        ),
      ),
    );
  }
}
