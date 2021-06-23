import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ahorra_pe/network_api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Objetivos"),
      ),
      drawer: DrawerSide(),
      body: HomeActivity(),
    );
  }
}

class DrawerSide extends StatefulWidget {
  @override
  _DrawerSideState createState() => _DrawerSideState();
}
class _DrawerSideState extends State<DrawerSide> {
  var name;
  var email;

  @override
  // ignore: must_call_super
  void initState() {
    getData();
  }
  getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('userName');
      email = prefs.getString('userEmail');
    });
  }
  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as HomePageArguments;
    //var name = args.name;
    //var email = args.email;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(name==null?'':name,style: TextStyle(fontSize: 20,color: Colors.white),),
            accountEmail: Text(email==null?'':email,style: TextStyle(fontSize: 15,color: Colors.white),),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.payments_outlined),
            title: Text("Registrar Objetivo"),
            onTap: (){
              Navigator.of(context).pushNamed("/goal/register");
              //Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.close,color: Colors.red,),
            title: Text("Cerrar Sessión"),
            onTap: () {
              closeSession(context);
            },
          ),
        ],
      ),
    );
  }
  
}
void closeSession(context) async {
  var data={};
  var res = await Conexion().postApiAuthenticate(data, '/auth/logout');
  if(res.statusCode==200){
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
  }
  Navigator.of(context).pushNamedAndRemoveUntil("/principal", (route) => false);
}


class HomeActivity extends StatefulWidget {
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  List<dynamic> response=[];

  @override
  Widget build(BuildContext context) {
    goalList();
    return ListView.builder(
        shrinkWrap: true,
        itemCount: response.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(response[index]['description']),
              subtitle: Row(
                children: [
                  Text('Meta: ${response[index]['total']}'),
                ],
              ),
              onTap: () {
                goalId(response[index]['id']);
              },
            ),
          );
        }
    );
  }

  void goalList()async{
    var res = await Conexion().getApiAuhthenticate('/goal');
    var body = jsonDecode(res.body);
    Map<String, dynamic> rpta = body;
    if(rpta['status']==0){
      print(rpta['response']);
      setState(() {
        response = rpta['response'];
      });
    }else{
      closeSession(context);
    }
  }

  void goalId(id) async{
    Navigator.of(context).pushNamed("/movimient/register",arguments: id);
  }
}