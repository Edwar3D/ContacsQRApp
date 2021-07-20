import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GeneratorQR extends StatelessWidget {
  final Contact myContact;
  const GeneratorQR({Key? key, required this.myContact}) : super(key: key);

  getData() {
    String json = jsonEncode(myContact.toMap());
    print(json);
    return json.replaceAll('avatar', 'null');
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 325.0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Código QR'),
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Compartir datos de: ${myContact.displayName}'),
                SizedBox(height: 10),
                Center(
                  child: QrImage(
                      /*  embeddedImage: AssetImage('assets/images/cheems.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size((scanArea / 3), (scanArea / 3)),
                      ), */
                      data: getData(),
                      version: QrVersions.auto,
                      size: scanArea,
                      semanticsLabel: 'QR CODE',
                      errorStateBuilder: (cxt, err) {
                        return Container(
                          child: Center(
                            child: Text(
                              "Uh oh! hubo un error al cargar el Código QR...",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(height: 10),
                Text(
                    'Comparte este código QR y con nuestra aplicacón podra visulizar su contacto'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
