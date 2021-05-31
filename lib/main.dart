import 'package:ahorra_pe/Auth/login.dart';
import 'package:ahorra_pe/Auth/logup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ahorra_pe/auth/principal.dart';
import 'package:ahorra_pe/screens/home.dart';
import 'package:ahorra_pe/screens/goal_register.dart';
import 'package:ahorra_pe/screens/movimient_register.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.green[900],
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Principal Activity',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: "/",
      routes: {
        "/":(BuildContext context)=> CheckAuthenticate(),
        "/principal":(BuildContext context)=> PrinciaplActivity(),
        "/home":(BuildContext context)=> Home(),
        "/login":(BuildContext context)=> Login(),
        "/logout":(BuildContext context)=> Logout(),
        "/goal/register":(BuildContext context)=>GoalRegister(),
        "/movimient/register":(BuildContext context)=>MovimientRegisteer(),
      },
    );
  }
}

class CheckAuthenticate extends StatefulWidget {
  @override
  _CheckAuthenticateState createState() => _CheckAuthenticateState();
}

class _CheckAuthenticateState extends State<CheckAuthenticate> {
  bool isAuth = false;
  @override
  void initState(){
    _verifLogin();
    super.initState();

  }

  void _verifLogin() async{
    SharedPreferences local = await SharedPreferences.getInstance();
    var token = local.getString('token');
    if(token != null){
      setState(() {
        isAuth=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if(isAuth){
      child = Home();
    }else{
      child = PrinciaplActivity();
    }
    return Scaffold(
      body: child,
    );
  }
}


