import 'package:bepresent/models/users.dart';
import 'package:flutter/material.dart';
import '../models/contacts_database.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  TextEditingController newNameController = TextEditingController();
  TextEditingController newPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Contacts')),
        body: Column(
          children: [
            Flexible(
              child: ListView.builder(
                itemCount: ContactsManager.contacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(ContactsManager.contacts[index]['name']!),
                    subtitle: Text(ContactsManager.contacts[index]['phone']!),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Add Contact'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: newNameController,
                                  decoration: InputDecoration(labelText: 'Name'),
                                ),
                                TextField(
                                  controller: newPhoneController,
                                  decoration: InputDecoration(labelText: 'Phone'),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async{
                                  await UserDatabase.addtoUserContacts(UserDatabase.user_id, newNameController.text, newPhoneController.text);
                                  setState(() {
                                    ContactsManager.addContact(
                                      newNameController.text,
                                      newPhoneController.text,
                                    );
                                    newNameController.clear();
                                    newPhoneController.clear();
                                    Navigator.pop(context);
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.white,
                                  primary: Color.fromARGB(159, 21, 49, 106),
                                ),
                                child: Text('Add'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Color.fromARGB(159, 21, 49, 106),
                    ),
                    child: Text('Add'),
                  ),
                  ElevatedButton(
  onPressed: () async {
    if (ContactsManager.contacts.isNotEmpty) {
      bool deleteConfirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this contact?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Color.fromARGB(159, 21, 49, 106),
                ),
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.white,
                  primary: Color.fromARGB(159, 21, 49, 106),
                ),
              ),
            ],
          );
        },
      ) ?? false;

      if (deleteConfirmed) {
        var deletionContact = ContactsManager.contacts[ContactsManager.contacts.length - 1];
        await UserDatabase.deleteFromUserContacts(UserDatabase.user_id, deletionContact['name'], deletionContact['phone']);
        setState(() {
          ContactsManager.contacts.removeLast();
        });
      }
    }
  },
  style: ElevatedButton.styleFrom(
    onPrimary: Colors.white,
    primary: Color.fromARGB(159, 21, 49, 106),
  ),
  child: Text('Delete'),
),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    newNameController.dispose();
    newPhoneController.dispose();
    super.dispose();
  }
}
