import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_app/models/contac.dart';

class ContactServices {
  void saveContact(Contac contac) async {
    Contact contact = Contact(
        givenName: contac.name,
        familyName: contac.lastName,
        emails: [Item(value: contac.email)],
        phones: [Item(value: contac.number)]);

    if (await Permission.contacts.request().isGranted) {
      try {
        await ContactsService.addContact(contact);
      } on FormOperationException catch (e) {
        switch (e.errorCode) {
          case FormOperationErrorCode.FORM_OPERATION_CANCELED:
          case FormOperationErrorCode.FORM_COULD_NOT_BE_OPEN:
          case FormOperationErrorCode.FORM_OPERATION_UNKNOWN_ERROR:
          default:
            print(e.errorCode);
        }
      }
    }
  }
}
