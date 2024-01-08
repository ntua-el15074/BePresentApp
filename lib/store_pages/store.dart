import 'package:flutter/material.dart';
import 'clothingpage.dart';
import 'hatspage.dart';
import 'snoutpage.dart';
import 'glassespage.dart';

class StorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuOption(
                title: 'Clothing',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClothingPage()),
                  );
                },
              ),
              MenuOption(
                title: 'Glasses',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GlassesPage()),
                  );
                },
              ),
              MenuOption(
                title: 'Hats',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HatsPage()),
                  );
                },
              ),
              MenuOption(
                title: 'Snout',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SnoutPage()),
                  );
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
