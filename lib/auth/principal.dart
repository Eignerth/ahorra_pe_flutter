import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class PrinciaplActivity extends StatelessWidget {
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
            child: Column(
              children: [
                SizedBox(height: size.height*0.05,),
                Container(
                  margin: EdgeInsets.symmetric(vertical: size.height*0.04),
                  width: size.width * 0.7,
                  decoration: BoxDecoration(
                      color: Colors.teal[700],
                      borderRadius: BorderRadius.circular(29)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.teal[700],
                        padding: EdgeInsets.symmetric(vertical: 18),
                        elevation:20,
                      ),
                      onPressed: () {
                        _goLogin(context);
                      },
                      child: Text(
                        "Iniciar Sesión",
                        style: TextStyle(color: Colors.white,fontSize: 20),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: size.height*0.04),
                  width: size.width * 0.7,
                  decoration: BoxDecoration(
                        color: Colors.teal[300],
                        borderRadius: BorderRadius.circular(29)
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.teal[300],
                        padding: EdgeInsets.symmetric(vertical: 18),
                        elevation:20,
                      ),
                      onPressed: () {
                        _goLogout(context);
                      },
                      child: Text(
                        "Crear Cuenta",
                        style: TextStyle(color: Colors.black,fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            )
          )
        ],
      )
    );
  }
}

void _goLogin(BuildContext context){
  Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
}

void _goLogout(BuildContext context){
  Navigator.of(context).pushNamedAndRemoveUntil("/logout", (route) => false);
}


