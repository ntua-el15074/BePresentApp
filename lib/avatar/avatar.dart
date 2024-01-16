import 'package:flutter/material.dart';
import 'package:bepresent/models/inventory_database.dart';
import '../models/sessions.dart';
import '../models/users.dart';

class AvatarPage extends StatefulWidget {

  @override
  _AvatarPageState createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  late ClothingItem? selectedClothingItem;
  @override
  void initState() {
    super.initState();
    selectedClothingItem = AvatarInventoryDatabase.savedItem;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avatar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      'assets/Tbaotbao.png',
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),
                if (selectedClothingItem != null)
                  Positioned(
                    top: selectedClothingItem!.top,
                    left: selectedClothingItem!.left,
                    child: GestureDetector(
                      child: Image.asset(
                        selectedClothingItem!.imagePath,
                        width: selectedClothingItem!.size,
                        height: selectedClothingItem!.size,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showCustomizationDialog(context);
              },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color.fromARGB(
                    159, 21, 49, 106),
              ),
              child: Text('Customize'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomizationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<ClothingItem> inventory = AvatarInventoryDatabase.getInventory();
        return AlertDialog(
          title: Text(''),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (ClothingItem item in inventory)
                  ListTile(
                    title: Image.asset(
                      item.imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    subtitle: Text('${item.name}'),
                    onTap: () async {
                      setState(() {
                        AvatarInventoryDatabase.saveClothingItem(item);
                        selectedClothingItem = item;
                        print(selectedClothingItem);
                      });
                      await SessionDatabase.updateSavedItemDB(UserDatabase.user_id, item.name);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
