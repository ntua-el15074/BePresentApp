import '../models/inventory_database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/foundation.dart';

class UserDatabase {
  static int user_id = 0;
  static double money = 0;
  static List<Map<String, String>> contacts = [];
  static List<ClothingItem> inventoryItems = [];


Future<bool> authenticateUser(String username, String password) async {
  var url;

  if (Platform.isIOS || kIsWeb) {
    url = Uri.parse('http://127.0.0.1:9876/bepresent/authenticateuser');
  }
  else if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:9876/bepresent/authenticateuser');
  }
  print(url);
  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  var body = {'username': username, 'password': password};
  var response = await http.post(url, headers: headers, body: body);
  print(response.body);
  try {

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      user_id = data['user_id'].toInt();
      money = data['money'].toDouble();
      await getUserContacts(user_id);
      print("hey");
      await getUserInventoryList(user_id);
      print("poop");
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

  Future<void> addUser(String username, String password, String email, double money) async {
  var url;

  if (Platform.isIOS || kIsWeb) {
    url = Uri.parse('http://127.0.0.1:9876/bepresent/adduser');
  }
  else if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:9876/bepresent/adduser');
  }

  try {
    var response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
        'email': email,
        'money': money.toString(),
      }
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print("User added successfully");
      UserDatabase userdatabase = UserDatabase();
      await userdatabase.authenticateUser(username, password);
    } else {
      print('Failed to add user. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  static Future<void> getUserContacts(int userId) async {
  var url;

  if (Platform.isIOS || kIsWeb) {
    url = Uri.parse('http://127.0.0.1:9876/bepresent/getusercontacts');
  }
  else if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:9876/bepresent/getusercontacts');
  }

  try {
    var response = await http.post(
      url,
      body: {'user_id': userId.toString()},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      for (var contact in data['result']) {
        contacts.add({'name': contact['name'], 'phone': contact['phone']});
      }
    } else {
      print('Failed to get contacts. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  static Future<void> addtoUserInventory(int userId, ClothingItem item) async {
  var url;

  if (Platform.isIOS || kIsWeb) {
    url = Uri.parse('http://127.0.0.1:9876/bepresent/additem');
  }
  else if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:9876/bepresent/additem');
  }

  try {
    var response = await http.post(
      url,
      body: {
        'user_id': userId.toString(),
        'category': item.category.toString(),
        'name': item.name.toString(),
        'imagepath': item.imagePath.toString(),
        'cost': item.cost.toString(),
        'postop': item.top.toString(),
        'posleft': item.left.toString(),
        'possize': item.size.toString(),
        'top_ingame': item.top_ingame.toString(),
        'left_ingame': item.left_ingame.toString(),
      },
    );

    if (response.statusCode == 200) {
      print("Item added successfully");
    } else {
      print('Failed to add item. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  static Future<void> addtoUserContacts(int userId, String name, String phone) async {
  var url;

  if (Platform.isIOS || kIsWeb) {
    url = Uri.parse('http://127.0.0.1:9876/bepresent/addcontact');
  }
  else if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:9876/bepresent/addcontact');
  }

  try {
    var response = await http.post(
      url,
      body: {
        'user_id': userId.toString(),
        'name': name,
        'phone': phone,
      },
    );

    if (response.statusCode == 200) {
      print("Contact added successfully");
    } else {
      print('Failed to add contact. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  static Future<void> deleteFromUserContacts(int userId, String? name, String? phone) async {
  var url;

  if (Platform.isIOS || kIsWeb) {
    url = Uri.parse('http://127.0.0.1:9876/bepresent/deletecontact');
  }
  else if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:9876/bepresent/deletecontact');
  }

  try {
    var response = await http.post(
      url,
      body: {
        'user_id': userId.toString(),
        'name': name,
        'phone': phone,
      },
    );

    if (response.statusCode == 200) {
      print("Contact deleted successfully");
    } else {
      print('Failed to delete contact. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

static Future<void> getUserInventoryList(int userId) async {
  var url;

  if (Platform.isIOS || kIsWeb) {
    url = Uri.parse('http://127.0.0.1:9876/bepresent/getuserinventory');
  }
  else if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:9876/bepresent/getuserinventory');
  }

  try {
    var response = await http.post(
      url,
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'user_id': userId.toString()},
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      List inventoryData = responseData['result'] as List;

      for (var item in inventoryData) {
        print(item['name']);
        inventoryItems.add(ClothingItem(
          category: item['category'], 
          name: item['name'], 
          imagePath: item['imagepath'], 
          cost: item['cost'].toDouble(), 
          top: item['postop'].toDouble(), 
          left: item['posleft'].toDouble(), 
          size: item['possize'].toDouble(), 
          top_ingame: item['top_ingame'].toDouble(), 
          left_ingame: item['left_ingame'].toDouble()
        ));
      }
    } else {
      print('Failed to get inventory. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


}
