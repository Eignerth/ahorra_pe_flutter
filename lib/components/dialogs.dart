import 'package:flutter/material.dart';

class ErrorDialog extends StatefulWidget {
  final Map<String,dynamic>? response;
  const ErrorDialog(this.response);

  @override
  _ErrorDialogState createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {

  @override
  Widget build(BuildContext context) {
    List<String> msgs = [];
    widget.response!.forEach((key, value) {
      for(var msg in widget.response![key]){
        print(msg);
        msgs.add(msg);
      }
    });
    return AlertDialog(
      title: new Text("Error"),
      content: Container(
        width: double.minPositive,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: msgs.length,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(msgs[index]),
                ),
              );
            }
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cerrar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class ErrorLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("Error - LogIn"),
      content: Text(
        "Email / Contraseña incorrecta.",
        style: TextStyle(
            color: Colors.red,
            fontSize: 15
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cerrar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}


