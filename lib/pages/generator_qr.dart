import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GeneratorQR extends StatefulWidget {
  const GeneratorQR({Key? key}) : super(key: key);

  @override
  _GeneratorQRState createState() => _GeneratorQRState();
}

class _GeneratorQRState extends State<GeneratorQR> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  TextEditingController mailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gengerador de QR'),
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                  child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      /* prefixIcon: Icon(
                        Icons.email,
                        color: Colors.deepPurpleAccent.shade100,
                      ), */
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      labelText: 'Nombre',
                    ),
                  ),
                  TextFormField(
                    controller: numberController,
                    decoration: InputDecoration(
                      /* prefixIcon: Icon(
                        Icons.email,
                        color: Colors.deepPurpleAccent.shade100,
                      ), */
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      labelText: 'Nombre',
                    ),
                  ),
                  TextFormField(
                    controller: mailController,
                    decoration: InputDecoration(
                      /* prefixIcon: Icon(
                        Icons.email,
                        color: Colors.deepPurpleAccent.shade100,
                      ), */
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      labelText: 'Correo',
                    ),
                  ),
                  TextButton(
                    child: Text('Generar QR'),
                    onPressed: () {},
                  )
                ],
              )),
              QrImage(
                data: '{"name": Eduardo, "number": 987989  }',
                version: QrVersions.auto,
                size: 320,
                gapless: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
