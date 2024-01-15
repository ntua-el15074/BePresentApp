import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bepresent/game/in_game.dart';
import 'package:flutter/services.dart';
import '../models/sessions.dart';
import '../models/users.dart';

void copyToClipboard(String text) async {
  try {
    await Clipboard.setData(ClipboardData(text: text));
  } catch (e) {
    print("clipboard failed");
  }
}

class WaitingOnUsersPage extends StatefulWidget {
  final String sessionCode;

  WaitingOnUsersPage({required this.sessionCode});

  @override
  _WaitingOnUsersPageState createState() => _WaitingOnUsersPageState();
}

class _WaitingOnUsersPageState extends State<WaitingOnUsersPage> {
  List<String> joinedUsers = [];

  @override
  void initState() {
    super.initState();
    _simulateJoining();
  }

  void _simulateJoining() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        joinedUsers.add('John');
      });
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        joinedUsers.add('Linda');
      });
    });
  }

  Widget _buildJoinedUser(String user) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$user Joined Your Session',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Waiting'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 250,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      widget.sessionCode,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    copyToClipboard(widget.sessionCode);
                  },
                  icon: Icon(Icons.content_copy),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              children: joinedUsers.map((user) => _buildJoinedUser(user)).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InGamePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color.fromARGB(
                    159, 21, 49, 106),
              ),
              child: Text('Begin'),
            ),
          ],
        ),
      ),
    );
  }
}



class CreateSessionPage extends StatefulWidget {
  @override
  _CreateSessionPageState createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  String _sessionType = 'Work';
  String _sessionName = '';

  List<String> _sessionTypes = ['Work', 'Friends', 'Study'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Session')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _sessionName = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Name your Session',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _sessionType,
              items: _sessionTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _sessionType = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Session Type',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sessionName.isNotEmpty && _sessionType.isNotEmpty
                  ? () async {
                      String generatedCode = generateRandomCode();
                      await SessionDatabase.addSession(UserDatabase.user_id, _sessionName, generatedCode);
                      await SessionDatabase.getSessionUsers();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaitingOnUsersPage(sessionCode: generatedCode),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color.fromARGB(
                    159, 21, 49, 106),
              ),
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  String generateRandomCode() {
    final Random _random = Random();
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return String.fromCharCodes(
      Iterable.generate(
        6,
        (_) => chars.codeUnitAt(_random.nextInt(chars.length)),
      ),
    );
  }
}
