import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ahorra_pe/network_api/api.dart';
import 'package:ahorra_pe/components/dialogs.dart';

class Logout extends StatelessWidget {
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
            height: size.height * 0.1,
          ),
          Center(
            child:
            Column(
              children: [
                Text(
                  "REGÍSTRATE",
                  style: TextStyle( color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height*0.02,),
                FormLogout(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FormLogout extends StatefulWidget {
  @override
  _FormLogoutState createState() => _FormLogoutState();
}

class _FormLogoutState extends State<FormLogout> {
  bool _isLoading=false;
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
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
              cursorColor: Colors.tealAccent,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: Colors.black87,
                  ),
                  hintText: "Nombre",
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                  errorStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0
                  )
              ),
              controller: name,
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
              cursorColor: Colors.tealAccent,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: Colors.black87,
                ),
                hintText: "Correo Electrónico",
                hintStyle: TextStyle(color: Colors.white60),
                border: InputBorder.none,
                errorStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0
                )
              ),
              controller: email,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            width: size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.teal[700],
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextFormField(
              style: TextStyle(fontSize: 20,color: Colors.white),
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
                errorStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0
                )
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
                    userStore();
                },
                child: Text(_isLoading?"Procesando...":
                  "Registrar",
                  style: TextStyle(color: Colors.black,fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void userStore()async{
    setState(() {
      _isLoading = true;
    });
    var data = { 'name':name.text,'email':email.text,'password':password.text};
    var res = await Conexion().postApi(data, '/user');
    var body = jsonDecode(res.body);
    Map<String, dynamic> rpta = body;
    if(rpta['status']==1){
      Map<String,dynamic> response = rpta['response'];
      setState(() {
        _isLoading = false;
      });
      showDialog(
          context: context,
          builder: (_) => ErrorDialog(response)
      );
    }else{
      Navigator.of(context).pushNamedAndRemoveUntil("/principal", (route) => false);
    }
  }
}