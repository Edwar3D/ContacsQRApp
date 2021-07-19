import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ViewContac extends StatelessWidget {
  final Contact contac;
  const ViewContac({Key? key, required this.contac}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(contac.toMap().toString());
    return Scaffold(
        appBar: AppBar(
          title: Text('Nuevo Contacto'),
          actions: [TextButton(onPressed: () {}, child: Text('Agregar'))],
        ),
        body: Container(
          child: SafeArea(
            child: Column(
              children: <Widget>[],
            ),
          ),
        ));
  }
}
