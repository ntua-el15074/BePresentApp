import 'package:flutter/material.dart';
import 'avatar/avatar.dart';
import 'store_pages/store.dart';
import 'contacts/contacts.dart';
import 'stats/stats.dart';
import 'models/users.dart';
import 'models/sessions.dart';
import 'game/start.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageViewWidget(),
      routes: {
        '/authView': (context) => PageViewWidget(),
        '/startView': (context) => MenuPage(),
      },
    );
  }

}

class PageViewWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.vertical,
      children: [
        StartingPage(),
        AuthenticationPage(),
      ],
    );
  }
}


class AuthenticationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color.fromARGB(159, 21, 49, 106),
              ),
              child: Text('Sign In'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color.fromARGB(159, 21, 49, 106),
              ),
              child: Text('Sign Up'),
            ),
          ],
        )
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final String username = usernameController.text;
                final String password = passwordController.text;
                  UserDatabase userDatabase = UserDatabase();
                bool isAuthenticated = await userDatabase.authenticateUser(username, password);
                if (isAuthenticated) {
                  Navigator.pushReplacementNamed(context, '/startView');
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Sign-In Failed'),
                        content: Text('Invalid credentials. Please try again.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color.fromARGB(159, 21, 49, 106),
              ),
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpPage extends StatelessWidget {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async{
                late String username = usernameController.text;
                late String password = passwordController.text;
                late String email = emailController.text;
                late double money = 10000000;
                  UserDatabase userDatabase = UserDatabase();
              await userDatabase.addUser(username, password, email, money);
                Navigator.pushReplacementNamed(context, '/startView');
              },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color.fromARGB(159, 21, 49, 106),
              ),
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
class StartingPage extends StatelessWidget {

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Image.asset(
        'assets/logo.png',
        width: 400.0,
        height: 400.0,
        fit: BoxFit.contain,
      ),
    ),
  );
}
}

class MenuPage extends StatefulWidget {

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Menu')),
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MenuOption(
              title: 'Start',
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StartPage()),
                );
                await SessionDatabase.getSessionUsers();
                //await userDb.updateUserContacts(UserDatabase.user_id);
                //await userDb.updateUserMoney(UserDatabase.user_id, AvatarInventoryDatabase.getMoney());
                //await userDb.updateUserInventory(UserDatabase.user_id);
              },
            ),
            MenuOption(
              title: 'Avatar',
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AvatarPage()),
                );
                await SessionDatabase.getSessionUsers();
                //await userDb.updateUserContacts(UserDatabase.user_id);
                //await userDb.updateUserMoney(UserDatabase.user_id, AvatarInventoryDatabase.getMoney());
                //await userDb.updateUserInventory(UserDatabase.user_id);
              },
            ),
            MenuOption(
              title: 'Store',
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StorePage()),
                );
                await SessionDatabase.getSessionUsers();
                //await userDb.updateUserContacts(UserDatabase.user_id);
                //await userDb.updateUserMoney(UserDatabase.user_id, AvatarInventoryDatabase.getMoney());
                //await userDb.updateUserInventory(UserDatabase.user_id);
              },
            ),
            MenuOption(
              title: 'Stats',
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StatsPage()),
                );
                await SessionDatabase.getSessionUsers();
                //await userDb.updateUserContacts(UserDatabase.user_id);
                //await userDb.updateUserMoney(UserDatabase.user_id, AvatarInventoryDatabase.getMoney());
                //await userDb.updateUserInventory(UserDatabase.user_id);
              },
            ),
            MenuOption(
              title: 'Contacts',
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactsPage()),
                );
                await SessionDatabase.getSessionUsers();
                //await userDb.updateUserContacts(UserDatabase.user_id);
                //await userDb.updateUserMoney(UserDatabase.user_id, AvatarInventoryDatabase.getMoney());
                //await userDb.updateUserInventory(UserDatabase.user_id);
              },
            ),
          ],
        ),
        ),
      ),
    );
  }
}


class MenuOption extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const MenuOption({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary:
              Color.fromARGB(159, 21, 49, 106),
        ),
      ),
    );
  }
}

