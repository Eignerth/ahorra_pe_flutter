import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ahorra_pe/network_api/api.dart';
import 'package:flutter/services.dart';
import 'package:ahorra_pe/components/dialogs.dart';
import 'package:intl/intl.dart';

class MovimientRegisteer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar Ingreso"),
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
                FrmRegister(id as int),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FrmRegister extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final int goal_id;

  const FrmRegister(this.goal_id);

  @override
  _FrmRegisterState createState() => _FrmRegisterState();
}

class _FrmRegisterState extends State<FrmRegister> {
  bool _isLoading=false;
  final _formKey = GlobalKey<FormState>();
  final amount = TextEditingController();
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
              controller: amount,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 20,color: Colors.black),
              cursorColor: Colors.teal[500],
              decoration: InputDecoration(
                icon: Icon(
                  Icons.description,
                  color: Colors.black87,
                ),
                hintText: "Monto a Ingresar",
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
                  mvStore(widget.goal_id);
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

  void mvStore(id)async{
    setState(() {
      _isLoading = true;
    });
    DateTime now = DateTime.now();
    String date = DateFormat('yyyy-MM-dd').format(now);
    var data = { 'amount':amount.text,'type':"I",'date':date,'goal_id':id};
    var res = await Conexion().postApiAuthenticate(data, '/movimient');
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