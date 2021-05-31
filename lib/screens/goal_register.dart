import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ahorra_pe/network_api/api.dart';
import 'package:flutter/services.dart';
import 'package:ahorra_pe/components/dialogs.dart';

class GoalRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro de Objetivos"),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: size.height*0.04,),
                Text(
                  "Registrar Objetivo",
                  style: TextStyle( color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height*0.02,),
                FormRegister(),
              ],
            ),
          )
        ],
      ),
    );
  }
}


class FormRegister extends StatefulWidget {
  @override
  _FormRegisterState createState() => _FormRegisterState();
}

class _FormRegisterState extends State<FormRegister> {
  bool _isLoading=false;
  final _formKey = GlobalKey<FormState>();
  final description = TextEditingController();
  final amount = TextEditingController();
  final date = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            width: size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.teal[300],
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextFormField(
              controller: description,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 20,color: Colors.black),
              cursorColor: Colors.teal[500],
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.description,
                    color: Colors.black87,
                  ),
                  hintText: "Descripción",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            width: size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.teal[300],
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextFormField(
              controller: amount,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 20,color: Colors.black),
              cursorColor: Colors.teal[500],
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.monetization_on,
                    color: Colors.black87,
                  ),
                  hintText: "Monto",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            width: size.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.teal[300],
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextFormField(
              controller: date,
              keyboardType: TextInputType.datetime,
              style: TextStyle(fontSize: 20,color: Colors.black),
              cursorColor: Colors.teal[500],
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Colors.black87,
                  ),
                  hintText: "Fec.Límite (opc)",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
              ),
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
                  goalStore();
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

  void goalStore()async{
    setState(() {
      _isLoading = true;
    });
    var data = { 'description':description.text,'total':amount.text,'date_final':date.text};
    var res = await Conexion().postApiAuthenticate(data, '/goal');
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
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
    }
  }
}
