import '../models/users.dart';

class ContactsManager {

  static List<Map<String, String>> get contacts => UserDatabase.contacts;

  static void addContact(String name, String phone) {
    contacts.add({'name': name, 'phone': phone});
  }

  static void editContact(int index, String name, String phone) {
    if (index >= 0 && index < contacts.length) {
      contacts[index] = {'name': name, 'phone': phone};
    }
  }

  static void deleteContact(int index)  {
    if (index >= 0 && index < contacts.length) {
      contacts.removeAt(index);
    }
  }
}
