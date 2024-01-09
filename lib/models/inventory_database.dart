import 'package:bepresent/models/users.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/foundation.dart';

class ClothingItem {
  final String category;
  final String name;
  final String imagePath;
  final double cost;
  final double top;
  final double left;
  final double size;
  final double top_ingame;
  final double left_ingame;

  ClothingItem({
    required this.category,
    required this.name,
    required this.imagePath,
    required this.cost,
    required this.top,
    required this.left,
    required this.size,
    required this.top_ingame,
    required this.left_ingame,
      });
}

class AvatarInventoryDatabase {
  static List<ClothingItem> get inventoryItems => UserDatabase.inventoryItems;
  static ClothingItem? savedItem;
  static double get money => UserDatabase.money;
  static double _money = money;

  static void addItem(ClothingItem item) {
    inventoryItems.add(item);
  }

  static void removeItem(ClothingItem item) {
    inventoryItems.remove(item);
  }

  static List<ClothingItem> getInventory() {
    return List.from(inventoryItems);
  }

  static Future<void> addMoney(double amount) async {
    _money += amount;
    await addMoneyToUser(UserDatabase.user_id);
  }

  static void deductMoney(double amount) {
    if (_money >= amount) {
      _money -= amount;
    }
  }

  static double getMoney() {
    return _money;
  }

  static void saveClothingItem(ClothingItem? item) { 
    print("saved item '${item!.imagePath}'");
    savedItem = item;
  }

  static ClothingItem? getSavedClothingItem() {
    print('returning item $savedItem');
    return savedItem;
  }

static Future<void> addMoneyToUser(int userId) async {
  var url;

  if (Platform.isIOS || kIsWeb) {
    url = Uri.parse('http://127.0.0.1:9876/bepresent/addmoney');
  }
  else if (Platform.isAndroid) {
    url = Uri.parse('http://10.0.2.2:9876/bepresent/addmoney');
  }

  try {
    var response = await http.post(
      url,
      body: {
        'user_id': userId.toString(),
        'money': _money.toString(),
      },
    );

    if (response.statusCode == 200) {
      print("Money added successfully");
    } else {
      print('Failed to add money. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
}


Future<void> purchaseItem(ClothingItem item, double itemCost) async {
  if (AvatarInventoryDatabase.getMoney() >= itemCost) {
    AvatarInventoryDatabase.deductMoney(itemCost);
    await AvatarInventoryDatabase.addMoneyToUser(UserDatabase.user_id);
    AvatarInventoryDatabase.addItem(item);
  } else {
    print('Insufficient funds!');
  }
}
