import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/pages/contacts_list.dart';
import 'package:qr_app/services/contact_services.dart';

class ViewContact extends StatelessWidget {
  final Contact contact;
  const ViewContact({Key? key, required this.contact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(contact.toMap().toString());
    return Scaffold(
        appBar: AppBar(
          title: Text('Nuevo contactto'),
          actions: [
            IconButton(
                onPressed: () {
                  shareContact(context);
                },
                icon: Icon(Icons.save))
          ],
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
                        title: Text("Name"),
                        trailing: Text(contact.givenName ?? ""),
                      ),
                      ListTile(
                        title: Text("Middle name"),
                        trailing: Text(contact.middleName ?? ""),
                      ),
                      ListTile(
                        title: Text("Family name"),
                        trailing: Text(contact.familyName ?? ""),
                      ),
                      ListTile(
                        title: Text("Prefix"),
                        trailing: Text(contact.prefix ?? ""),
                      ),
                      ListTile(
                        title: Text("Suffix"),
                        trailing: Text(contact.suffix ?? ""),
                      ),
                      ListTile(
                        title: Text("Birthday"),
                        trailing: Text(contact.birthday != null
                            ? DateFormat('dd-MM-yyyy').format(contact.birthday!)
                            : ""),
                      ),
                      ListTile(
                        title: Text("Company"),
                        trailing: Text(contact.company ?? ""),
                      ),
                      ListTile(
                        title: Text("Job"),
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
                                        title: Text("Street"),
                                        trailing: Text(a.street ?? ""),
                                      ),
                                      ListTile(
                                        title: Text("Postcode"),
                                        trailing: Text(a.postcode ?? ""),
                                      ),
                                      ListTile(
                                        title: Text("City"),
                                        trailing: Text(a.city ?? ""),
                                      ),
                                      ListTile(
                                        title: Text("Region"),
                                        trailing: Text(a.region ?? ""),
                                      ),
                                      ListTile(
                                        title: Text("Country"),
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

  Future<void> shareContact(BuildContext context) async {
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
                } catch (e) {
                  Fluttertoast.showToast(
                      msg: 'Hubo un error al añadir contacto',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red.shade300,
                      textColor: Colors.white);
                }
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactsList(),
                    ));
              },
            ),
          ],
        );
      },
    );
  }
}
