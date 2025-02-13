import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_app/pages/view_contact.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:contacts_service/contacts_service.dart';

class ScannerQR extends StatefulWidget {
  @override
  _ScannerQRState createState() => _ScannerQRState();
}

class _ScannerQRState extends State<ScannerQR> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    var styleTxtButton = TextButton.styleFrom(
        primary: Colors.white,
        fixedSize: Size(40, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Colors.blue.shade800);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 70,
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        title: Text(
          'Escanear QR',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(8),
                child: TextButton(
                    style: styleTxtButton,
                    onPressed: () async {
                      await controller?.toggleFlash();
                      setState(() {});
                    },
                    child: FutureBuilder(
                      future: controller?.getFlashStatus(),
                      builder: (context, snapshot) {
                        if (snapshot.data == true)
                          return Icon(Icons.flashlight_on_outlined);
                        else
                          return Icon(
                            Icons.flashlight_off_outlined,
                          );
                      },
                    )),
              ),
              SizedBox(width: 50),
              Container(
                margin: EdgeInsets.all(8),
                child: TextButton(
                    style: styleTxtButton,
                    onPressed: () async {
                      await controller?.flipCamera();
                      setState(() {});
                    },
                    child: FutureBuilder(
                      future: controller?.getCameraInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          if (describeEnum(snapshot.data!) != 'front')
                            return Icon(Icons.camera_front_outlined);
                          else
                            return Icon(Icons.camera_rear_outlined);
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.amber,
                            ),
                          );
                        }
                      },
                    )),
              )
            ],
          ),
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                dataScanner(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget dataScanner() {
    String data = '';
    bool isContac = false;

    if (result != null) {
      print('-----------${result!.code}');
      try {
        Contact contact = Contact.fromMap(jsonDecode(result!.code));
        print(contact.toMap());
        isContac = true;
      } catch (e) {
        data = 'Contacto no encontrado en Código QR';
      }
      if (isContac)
        return TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ViewContact(
                      contact: Contact.fromMap(jsonDecode(result!.code)),
                      isNewContact: true,
                    )));
          },
          child: Text(
            'Ver contacto',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          style: TextButton.styleFrom(
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              backgroundColor: Colors.blue.shade800),
        );
      else
        return Text(
          data,
        );
    } else
      return Text('Escaneando', style: Theme.of(context).textTheme.bodyText1);
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permiso de camara denegada')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
