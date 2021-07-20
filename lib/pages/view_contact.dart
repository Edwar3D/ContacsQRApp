import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/pages/contacts_list.dart';
import 'package:qr_app/pages/generator_qr.dart';
import 'package:qr_app/services/contact_services.dart';

class ViewContact extends StatelessWidget {
  final Contact contact;
  final bool isNewContact;
  const ViewContact(
      {Key? key, required this.contact, required this.isNewContact})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(contact.toMap().toString());
    String _title = '';
    if (isNewContact) _title = 'Nuevo Contacto';

    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
          actions: [_buildIAction(context)],
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    heightFactor: 2,
                    child: CircleAvatar(
                        child: Icon(Icons.person, size: 100), radius: 60),
                  ),
                  Form(
                      child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: contact.displayName,
                        enabled: false,
                      ),
                      ListTile(
                        title: Text("Nombre"),
                        trailing: Text(contact.givenName ?? ""),
                      ),
                      ListTile(
                        title: Text("Segundo nombre"),
                        trailing: Text(contact.middleName ?? ""),
                      ),
                      ListTile(
                        title: Text("Apellido"),
                        trailing: Text(contact.familyName ?? ""),
                      ),
                      ListTile(
                        title: Text("Prefijo"),
                        trailing: Text(contact.prefix ?? ""),
                      ),
                      ListTile(
                        title: Text("Sufijo"),
                        trailing: Text(contact.suffix ?? ""),
                      ),
                      ListTile(
                        title: Text("Cumpleaños"),
                        trailing: Text(contact.birthday != null
                            ? DateFormat('dd-MM-yyyy').format(contact.birthday!)
                            : ""),
                      ),
                      ListTile(
                        title: Text("Empresa"),
                        trailing: Text(contact.company ?? ""),
                      ),
                      ListTile(
                        title: Text("Trabajo"),
                        trailing: Text(contact.jobTitle ?? ""),
                      ),
                      Text('Teléfono:'),
                      Column(
                          children: contact.emails!
                              .map(
                                (i) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: ListTile(
                                    title: Text(i.label ?? ""),
                                    trailing: Text(i.value ?? ""),
                                  ),
                                ),
                              )
                              .toList()),
                      Column(
                        children: contact.phones!
                            .map(
                              (i) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: ListTile(
                                  title: Text(i.label ?? ""),
                                  trailing: Text(i.value ?? ""),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      Column(
                        children: contact.emails!
                            .map(
                              (i) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: ListTile(
                                  title: Text(i.label ?? ""),
                                  trailing: Text(i.value ?? ""),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      Text('Direcciones'),
                      Column(
                        children: contact.postalAddresses!
                            .map((a) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text("Calle"),
                                        trailing: Text(a.street ?? ""),
                                      ),
                                      ListTile(
                                        title: Text("Código postal"),
                                        trailing: Text(a.postcode ?? ""),
                                      ),
                                      ListTile(
                                        title: Text("Ciudad"),
                                        trailing: Text(a.city ?? ""),
                                      ),
                                      ListTile(
                                        title: Text("Región"),
                                        trailing: Text(a.region ?? ""),
                                      ),
                                      ListTile(
                                        title: Text("País"),
                                        trailing: Text(a.country ?? ""),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ));
  }

  IconButton _buildIAction(BuildContext context) {
    if (isNewContact) {
      return IconButton(
          onPressed: () {
            saveContact(context);
          },
          icon: Icon(Icons.save));
    } else {
      return IconButton(
          onPressed: () {
            shareContact(context);
          },
          icon: Icon(Icons.share));
    }
  }

  Future<void> saveContact(BuildContext context) async {
    ContactServices contactServices = new ContactServices();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Guardar nuevo contacto', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('¿Quieres este contacto en su dispositivo?',
                    textAlign: TextAlign.center),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                try {
                  contactServices.saveContact(contact);
                  Fluttertoast.showToast(
                      msg: 'Contacto añadido',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green.shade400,
                      textColor: Colors.white);
                  Navigator.pop(context);
                } catch (e) {
                  Fluttertoast.showToast(
                      msg: 'Hubo un error al añadir contacto',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red.shade300,
                      textColor: Colors.white);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> shareContact(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Compatir Contacto', textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('¿Quieres Compatir el contacto?',
                    textAlign: TextAlign.center),
                Text(
                    '\nEscanee el código QR con nuestra aplicación para que se agrege el contacto',
                    textAlign: TextAlign.left),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GeneratorQR(
                        myContact: contact,
                      ),
                    )).then((value) => Navigator.pop(context));
              },
            ),
          ],
        );
      },
    );
  }
}
