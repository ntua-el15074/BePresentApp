import 'package:flutter/material.dart';
import '../models/inventory_database.dart';
import 'package:bepresent/main.dart';
import '../models/users.dart';

class HatsPage extends StatefulWidget {
  @override
  _HatsPageState createState() => _HatsPageState();
}

class _HatsPageState extends State<HatsPage> {
  final List<ClothingItem> hatItems = [
    ClothingItem(category: 'Hats', name: 'Hat 1', imagePath: 'assets/hats/1.png', cost: 20.0, top : 15, left : 75, size : 100, top_ingame: 15, left_ingame: 95),
    ClothingItem(category: 'Hats', name: 'Hat 2', imagePath: 'assets/hats/2.png', cost: 30.0, top : 15, left : 75, size : 100, top_ingame: 15, left_ingame: 95),
  ];

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hats'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: hatItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        color: _currentPage == index ? Colors.blue[100] : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: _currentPage == index ? Colors.blue : Colors.transparent,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              hatItems[index].imagePath,
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(height: 8),
                            Text(hatItems[index].name),
                            SizedBox(height: 8),
                            Text('Cost: \$${hatItems[index].cost.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
  padding: const EdgeInsets.all(30.0),
  child: Align(
    alignment: Alignment.bottomCenter,
    child: ElevatedButton(
      onPressed: () {
        ClothingItem selectedItem = hatItems[_currentPage];
        _showConfirmationDialog(context, selectedItem);
      },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color.fromARGB(
                    159, 21, 49, 106),
              ),
      child: Text('Buy Selected Item'),
    ),
  ),
),

        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, ClothingItem selectedItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Purchase'),
          content: Text('Are you sure you want to buy ${selectedItem.name} for \$${selectedItem.cost.toStringAsFixed(2)}?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
                                  style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.white,
                                    primary: Color.fromARGB(159, 21, 49,
                                        106),
                                  ),
            ),
TextButton(
  child: Text('Yes'),
  onPressed: () async {
    await UserDatabase.addtoUserInventory(UserDatabase.user_id, selectedItem);
    purchaseItem(selectedItem, selectedItem.cost);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MenuPage()),
    );
  },
                                  style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.white,
                                    primary: Color.fromARGB(159, 21, 49,
                                        106),
                                  ),
),
          ],
        );
      },
    );
  }
}
