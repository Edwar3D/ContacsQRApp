import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:qr_app/pages/generator_qr.dart';
import 'package:qr_app/pages/scanner.dart';
import 'package:qr_app/pages/view_contact.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  List<Contact> _contacts = [];
  @override
  void initState() {
    super.initState();
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      print('granted');
      refreshContacts();
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar =
          SnackBar(content: Text('Acceso a los contactos denegado'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar = SnackBar(
          content: Text('Datos de contacto no disponibles en el dispositivo'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> refreshContacts() async {
    var contacts = (await ContactsService.getContacts(
            withThumbnails: false, iOSLocalizedLabels: false))
        .toList();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de contactos',
        ),
      ),
      body: SafeArea(
        child: _contacts != null
            ? ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact c = _contacts.elementAt(index);
                  return ListTile(
                    onTap: () {
                      print(c.displayName);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewContact(
                                contact: c,
                                isNewContact: false,
                              )));
                    },
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text(c.displayName ?? ""),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScannerQR(),
              ));
        },
      ),
    );
  }

  void contactOnDeviceHasBeenUpdated(Contact contact) {
    this.setState(() {
      var id = _contacts.indexWhere((c) => c.identifier == contact.identifier);
      _contacts[id] = contact;
    });
  }
}
