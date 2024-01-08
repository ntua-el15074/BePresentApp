import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/contacts_database.dart';

class TextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emergency Texts')),
      body: ListView.builder(
        itemCount: ContactsManager.contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(ContactsManager.contacts[index]['name']!),
            subtitle: Text(ContactsManager.contacts[index]['phone']!),
            trailing: IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                _sendTextMessage(context, ContactsManager.contacts[index]['phone']!);
              },
            ),
          );
        },
      ),
    );
  }

  void _sendTextMessage(BuildContext context, String phoneNumber) async {
    final String smsScheme = 'sms:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(smsScheme))) {
      await launchUrl(Uri.parse(smsScheme));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Could not send the message. Please check your device settings.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color.fromARGB(
                    159, 21, 49, 106),
              ),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
