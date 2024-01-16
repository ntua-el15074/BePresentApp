import 'package:bepresent/models/users.dart';
import '../models/inventory_database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/foundation.dart';

class UserInSession {
  final int? user_id;
  final String? username;
  final String? path;
  final int? state;

  UserInSession({
    required this.user_id,
    required this.username,
    required this.path,
    required this.state,
  });
}

class SessionDatabase {
  static int creator_id = 0;
  static String? SessionName;
  static String? SessionPassword;
  static List<UserInSession> users_in_session = [];
  static UserInSession? bottom_user;
  static UserInSession? left_user = UserInSession(user_id: 0, username: 'Linda', path:'assets/Tbaotbao.png', state: 1);
  static UserInSession? right_user = UserInSession(user_id: 0, username: 'John', path:'assets/Tbaotbao.png', state: 1);

  static Future<void> addSession(int user_id, String? name, String? password) async {
    var url;

    if (Platform.isIOS || kIsWeb) {
      url = Uri.parse('http://127.0.0.1:9876/bepresent/addsession');
    }
    else if (Platform.isAndroid) {
      url = Uri.parse('http://10.0.2.2:9876/bepresent/addsession');
    }

    try {
      var response = await http.post(
        url,
        body: {
          'creator_id': user_id.toString(),
          'name': name,
          'password': password,
        }
      );

      if (response.statusCode == 200) {
        creator_id = UserDatabase.user_id;
        SessionName = name;
        SessionPassword = password;
        print("Session added successfully");
      } else {
        print('Failed to add Session. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> deleteSession(String? name, String? password) async {
      var url;

      if (Platform.isIOS || kIsWeb) {
        url = Uri.parse('http://127.0.0.1:9876/bepresent/deletesession');
      }
      else if (Platform.isAndroid) {
        url = Uri.parse('http://10.0.2.2:9876/bepresent/deletesession');
      }

      try {
        var response = await http.post(
          url,
          body: {
            'name': name,
            'password': password,
          }
        );

        if (response.statusCode == 200) {
          creator_id = 0;
          print("Session deleted successfully");
        } else {
          print('Failed to delete Session. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }

  }

  static Future<bool> connectToSession(String? name, String? password) async {
      var url;

      if (Platform.isIOS || kIsWeb) {
        url = Uri.parse('http://127.0.0.1:9876/bepresent/connecttosession');
      }
      else if (Platform.isAndroid) {
        url = Uri.parse('http://10.0.2.2:9876/bepresent/connecttosession');
      }

      try {
        var response = await http.post(
          url,
          body: {
            'user_id': UserDatabase.user_id.toString(),
            'name': name,
            'password': password,
          }
        );

        var body = jsonDecode(response.body);

        if (response.statusCode == 200) {
          SessionDatabase.creator_id = int.parse(body["creator_id"].toString());
          SessionDatabase.SessionName = name;
          SessionDatabase.SessionPassword = password;
          print("Connected to Session");
          return true;
        } else {
          print('Failed to connect to Session. Status code: ${response.statusCode}');
          return false;
        }
      } catch (e) {
        print('Error: $e');
        return false;
      }


  }

  static Future<void> disconnectFromSession() async {
      var url;

      if (Platform.isIOS || kIsWeb) {
        url = Uri.parse('http://127.0.0.1:9876/bepresent/disconnectfromsession');
      }
      else if (Platform.isAndroid) {
        url = Uri.parse('http://10.0.2.2:9876/bepresent/disconnectfromsession');
      }

      try {
        var response = await http.post(
          url,
          body: {
            'user_id': UserDatabase.user_id.toString(),
            'name': SessionName,
            'password': SessionPassword,
          }
        );

        if (response.statusCode == 200) {
          creator_id = 0;
          print("Disconnected from Session");
        } else {
          print('Failed to disconnect from Session. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
  }

  static Future<void> getSessionUsers() async {
    // left_user = 'Linda';
    // right_user = 'John';
    users_in_session = [];
      var url;

      if (Platform.isIOS || kIsWeb) {
        url = Uri.parse('http://127.0.0.1:9876/bepresent/getusersinsession');
      }
      else if (Platform.isAndroid) {
        url = Uri.parse('http://10.0.2.2:9876/bepresent/getusersinsession');
      }

      try {
        var response = await http.post(
          url,
          body: {
            'name': SessionName,
            'password': SessionPassword,
          }
        ); 
        
      if (response.statusCode == 200) {
      var data = json.decode(response.body);

      for (var userinSession in data['user_list']) {

        print(userinSession['image'].toString());

        if (int.parse(userinSession['id'].toString()) == UserDatabase.user_id) {

          if (userinSession['image'].toString() == 'None') {
            userinSession['image'] = 'assets/Tbaotbao.png';
            print(userinSession['image']);
            print('This above is the new path');
          }

          bottom_user = UserInSession(user_id: int.parse(userinSession['id'].toString()),
                                      username: userinSession['username'].toString(),
                                      path: userinSession['image'].toString(),
                                      state : int.parse(userinSession['userState'].toString()));

        } else {

          if (userinSession['image'].toString() == 'None') {
            userinSession['image'] = 'assets/Tbaotbao.png';
          }


          users_in_session.add(UserInSession(user_id: int.parse(userinSession['id'].toString()),
                                      username: userinSession['username'].toString(),
                                      path: userinSession['image'].toString(),
                                      state : int.parse(userinSession['userState'].toString())));
          }
      }

      try{
        left_user = users_in_session[0];
      } catch (e) {
        left_user = UserInSession(user_id: 0, username: 'Linda', path:'assets/Tbaotbao.png', state: 1);
      }

      try{
        right_user = users_in_session[1];
      } catch (e) {
        right_user = UserInSession(user_id: 0, username: 'John', path:'assets/Tbaotbao.png', state: 1);
      }

      print('Added users in session');

    } else {
      print('Failed to get users. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  }

  static Future<void> updateSavedItemDB(int user_id, String name) async {
    var url;

    if (Platform.isIOS || kIsWeb) {
      url = Uri.parse('http://127.0.0.1:9876/bepresent/updatesaveditem');
    }
    else if (Platform.isAndroid) {
      url = Uri.parse('http://10.0.2.2:9876/bepresent/updatesaveditem');
    }

    try {
      var response = await http.post(
        url,
        body: {
          'user_id': user_id.toString(),
          'savedItem': name,
        }
      ); 
      
    if (response.statusCode == 200) {
      print('SavedItem was updated successfully');
    }
    } catch (e) {
      print('Error $e');
    }
}

static Future<void> updateUserStateDB(int state) async {
    var url;

    if (Platform.isIOS || kIsWeb) {
      url = Uri.parse('http://127.0.0.1:9876/bepresent/setuserstate');
    }
    else if (Platform.isAndroid) {
      url = Uri.parse('http://10.0.2.2:9876/bepresent/setuserstate');
    }

    try {
      var response = await http.post(
        url,
        body: {
          'user_id': UserDatabase.user_id.toString(),
          'state': state.toString(),
        }
      ); 
      
    if (response.statusCode == 200) {
      print('State was updated successfully');
    } else {
      print('There was an issue with setting the state');
    }
    } catch (e) {
      print('Error $e');
    }

}
}
