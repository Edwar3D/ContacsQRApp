import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
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
    String _title = 'Información';
    if (isNewContact) _title = 'Nuevo Contacto';

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(0, 0, 0, 0),
          title: Text(
            _title,
            style: Theme.of(context).textTheme.headline2,
          ),
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
                    heightFactor: 1.5,
                    child: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                        radius: 90),
                  ),
                  Form(
                      child: Column(
                    children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            color: Color.fromRGBO(46, 134, 193, 1),
                            child: TextFormField(
                              initialValue: contact.displayName,
                              enabled: false,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          )),
                      Container(
                          color: Colors.grey.shade200,
                          child: Column(children: [
                            buildListTile(context, 'Nombre', contact.givenName),
                            buildListTile(
                                context, 'Segundo nombre', contact.middleName),
                            buildListTile(
                                context, 'Apellido', contact.familyName),
                            buildListTile(context, 'Prefijo', contact.prefix),
                            buildListTile(context, 'Sufijo', contact.suffix),
                            buildListBithday(
                                context, 'Cumpleaño', contact.birthday),
                            buildListTile(context, 'Empresa', contact.company),
                            buildListTile(context, 'Trabajo', contact.jobTitle),
                          ])),
                      ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            color: Color.fromRGBO(46, 134, 193, 1),
                            child: TextFormField(
                              initialValue: 'Teléfono:',
                              enabled: false,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          )),
                      Container(
                        color: Colors.grey.shade200,
                        child: Column(
                            children: contact.phones!
                                .map(
                                  (i) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: ListTile(
                                      title: Text(
                                        i.label ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                      trailing: Text(i.value ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1),
                                    ),
                                  ),
                                )
                                .toList()),
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            color: Color.fromRGBO(46, 134, 193, 1),
                            child: TextFormField(
                              initialValue: 'Emails:',
                              enabled: false,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          )),
                      Container(
                        color: Colors.grey.shade200,
                        child: Column(
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
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            color: Color.fromRGBO(46, 134, 193, 1),
                            child: TextFormField(
                              initialValue: 'Dirreciones:',
                              enabled: false,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          )),
                      Container(
                        color: Colors.grey.shade200,
                        child: Column(
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
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ),
        ));
  }

  bool _isVisible(bool value) {
    return value ? false : true;
  }

  Widget buildListTile(BuildContext context, String tittle, String? data) {
    if (data != null)
      return ListTile(
        title: Text(
          tittle,
          style: Theme.of(context).textTheme.headline4,
        ),
        trailing: Text(data, style: Theme.of(context).textTheme.bodyText1),
      );
    else
      return Container();
  }

  Widget buildListBithday(BuildContext context, String tittle, DateTime? data) {
    if (data != null)
      return ListTile(
        title: Text("Cumpleaños"),
        trailing: Text(contact.birthday != null
            ? DateFormat('dd-MM-yyyy').format(contact.birthday!)
            : ""),
      );
    else
      return Container();
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
