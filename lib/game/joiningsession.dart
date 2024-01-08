import 'package:flutter/material.dart';
import 'package:bepresent/game/in_game.dart';

class JoiningGamePage extends StatelessWidget {
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Game'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'Enter Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WaitingPage(
                      password: passwordController.text,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color.fromARGB(
                    159, 21, 49, 106),
              ),
              child: Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}

class WaitingPage extends StatelessWidget {
  final String password;

  WaitingPage({required this.password});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InGamePage()),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Waiting for Host'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Password: $password'),
            SizedBox(height: 20),
            Text('Waiting for the host to start the game...'),
          ],
        ),
      ),
    );
  }
}