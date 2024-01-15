import 'package:bepresent/models/users.dart';
import '../models/inventory_database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/foundation.dart';

class SessionDatabase {
  static int creator_id = 0;
  static String? SessionName;
  static String? SessionPassword;
  static List<String> users_in_session = [];
  static String? bottom_user;
  static String? left_user = 'Linda';
  static String? right_user = 'John';

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
        if (int.parse(userinSession['id'].toString()) == UserDatabase.user_id) {
          bottom_user = userinSession['username'].toString();
        } else {
          users_in_session.add(userinSession['username'].toString());
        }
      }

      try{
        left_user = users_in_session[0];
      } catch (e) {
        left_user = 'Linda';
      }

      try{
        right_user = users_in_session[1];
      } catch (e) {
        right_user = 'John';
      }

    } else {
      print('Failed to get users. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  }

}
