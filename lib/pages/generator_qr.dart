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
    return json.replaceAll('avatar', 'oll');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Compartir datos de: ${myContact.displayName}'),
                SizedBox(height: 25),
                Text('Escane este código QR'),
                QrImage(
                  data: getData(),
                  version: QrVersions.auto,
                  size: 320,
                  gapless: false,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
