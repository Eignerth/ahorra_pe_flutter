import 'dart:convert';
import 'package:ahorra_pe/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ahorra_pe/network_api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ahorra_pe/components/dialogs.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.teal,
      statusBarIconBrightness: Brightness.dark,
    ));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: size.height*0.08,),
          Image.asset("assets/images/ahorra.png",),
          SvgPicture.asset(
            "assets/images/porki.svg",
            height: size.height * 0.15,
          ),
          Center(
            child:
              Column(
                children: [
                  SizedBox(height: size.height*0.07,),
                  Text(
                    "LOGIN",
                    style: TextStyle( color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: size.height*0.03,),
                  FormLogin(),
                ],
              ),
          )
        ],
      ),
    );
  }
}


class FormLogin extends StatefulWidget {
  @override
  _FormLoginState createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  bool _isLoading=false;
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            width: size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.teal[700],
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextFormField(
              style: TextStyle(fontSize: 20,color: Colors.white),
              validator: (value){
                if(value==null || value.isEmpty){
                  return 'Por favor, ingrese un nombre';
                }
              },
              cursorColor: Colors.tealAccent,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: Colors.black87,
                ),
                hintText: "Correo Electrónico",
                hintStyle: TextStyle(color: Colors.white60),
                border: InputBorder.none,
              ),
              controller: email,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            width: size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.teal[700],
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextFormField(
              style: TextStyle(fontSize: 20,color: Colors.white),
              validator: (value){
                if(value==null || value.isEmpty){
                  return 'Por favor, ingrese un nombre';
                }
              },
              obscureText: true,
              cursorColor: Colors.tealAccent,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  color: Colors.black87,
                ),
                hintText: "Contraseña",
                hintStyle: TextStyle(color: Colors.white60),
                border: InputBorder.none,
              ),
              controller: password,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: size.width * 0.5,
            decoration: BoxDecoration(
                color: Colors.teal[300],
                borderRadius: BorderRadius.circular(29)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(29),
                child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.green,
                  elevation:20,
                ),
                onPressed: () {
                    userLogin();
                },
                child: Text(_isLoading?"Procesando...":
                  "Iniciar",
                  style: TextStyle(color: Colors.black,fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void userLogin()async {
    setState(() {
      _isLoading = true;
    });
    var data = {'email':email.text,'password':password.text};
    var res = await Conexion().postApi(data, '/auth/login');
    if(res.statusCode==200){
      var body = jsonDecode(res.body);
      //get user info
      SharedPreferences local = await SharedPreferences.getInstance();
      local.setString('token',body['access_token']);
      var dataUser ={};
      var resUser = await Conexion().postApiAuthenticate(dataUser, '/auth/me');
      if (resUser.statusCode == 200) {
        var bodyUser = jsonDecode(resUser.body);
        local.setString('userName', bodyUser['name']);
        local.setString('userEmail', bodyUser['email']);
        Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
      }
    }else{
      setState(() {
        _isLoading = false;
      });
      showDialog(
          context: context,
          builder: (_) => ErrorLogin()
      );
    }
  }
}