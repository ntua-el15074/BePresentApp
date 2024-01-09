import 'package:flutter/material.dart';
import '../models/inventory_database.dart';
import 'dart:async';
class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
    late Timer _timer;
  int minutesElapsed = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        minutesElapsed++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double userMoney = AvatarInventoryDatabase.getMoney();

    return Scaffold(
      appBar: AppBar(title: Text('Stats')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.asset(
                                'assets/Tbaotbao.png',
                                width: 120,
                                height: 120,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${userMoney.toStringAsFixed(2)} points',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 3,
                          child: Text(
                            'Lucy',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AvatarInventoryDatabase.inventoryItems.length} item unlocked',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${AvatarInventoryDatabase.inventoryItems.length/8}%',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 5),
                        // Text(
                        //   '${minutesElapsed} minutes played',
                        //   style: TextStyle(fontSize: 18),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0),
              Image.asset(
                'assets/OverallScore.png',
                width: 150,
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
