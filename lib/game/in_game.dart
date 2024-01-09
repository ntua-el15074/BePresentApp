import 'package:flutter/material.dart';
import 'call.dart';
import 'text.dart';
import 'package:camera/camera.dart';
import 'package:bepresent/main.dart';
import 'package:bepresent/models/inventory_database.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';


class AppLifecycleObserver extends WidgetsBindingObserver {
  void Function(double) updateUserPoints;

  AppLifecycleObserver({required this.updateUserPoints});

  late Timer _backgroundTimer;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _backgroundTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
        updateUserPoints(-0.1);
      });
    } else if (state == AppLifecycleState.resumed) {
      _backgroundTimer.cancel();
    }
  }
}

class InGamePage extends StatefulWidget {
  @override
  _InGamePageState createState() => _InGamePageState();
}

class _InGamePageState extends State<InGamePage> {
  ClothingItem? selectedClothingItem = AvatarInventoryDatabase.savedItem;
  double johnPoints = 0;
  double lindaPoints = 0;
  double userPoints = 0;
  late Timer _timer;

   late AppLifecycleObserver _appLifecycleObserver;

  @override
  void initState() {
    super.initState();
    _appLifecycleObserver = AppLifecycleObserver(updateUserPoints: _updateUserPoints);
    WidgetsBinding.instance.addObserver(_appLifecycleObserver);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(_appLifecycleObserver);
    super.dispose();
  }

  void _updateUserPoints(double value) {
    setState(() {
      userPoints += value;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        johnPoints += 0.01;
        lindaPoints += 0.01;
        userPoints += 0.01;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Start'),
            automaticallyImplyLeading: false,
            actions: [
              PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 'call',
                    child: ListTile(
                      leading: Icon(Icons.call),
                      title: Text('Emergency Call'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'text',
                    child: ListTile(
                      leading: Icon(Icons.message),
                      title: Text('Emergency Text'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'camera',
                    child: ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Camera'),
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'call') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CallPage()),
                    );
                  } else if (value == 'text') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TextPage()),
                    );
                  } else if (value == 'camera') {
                    _openCamera(context);
                  }
                },
              ),
            ],
          ),
          body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
    // John's section
    Positioned(
      top: -40,
      left: -75,
      child: Column(
        children: [
          Image.asset(
            'assets/Tbaotbao.png',
            width: 250,
            height: 250,
          ),
          Column(
            children: [
              Text('John'),
              Text('${johnPoints.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    ),
    // Linda's section
    Positioned(
      top: -50,
      left: 110,
      child: Column(
        children: [
          Image.asset(
            'assets/Tbaotbao.png',
            width: 250,
            height: 250,
          ),
          Column(
            children: [
              Text('Linda'),
              Text('${lindaPoints.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    ),
    // User's section
    Positioned(
      top: 0,
      child: Column(
        children: [
          Image.asset(
            'assets/Tbaotbao.png',
            width: 250,
            height: 250,
          ),
          Column(
            children: [
              Text('You'),
              Text('${userPoints.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    ),
    if (selectedClothingItem != null)
      Positioned(
        top: selectedClothingItem!.top_ingame,
        left: selectedClothingItem!.left_ingame,
        child: GestureDetector(
          child: Image.asset(
            selectedClothingItem!.imagePath,
            width: selectedClothingItem!.size,
            height: selectedClothingItem!.size,
          ),
        ),
      ),
  ],
        ),
      ),
      SizedBox(height: 20),
      ElevatedButton(
        onPressed: () {
          _showLeaveSessionDialog(context);
        },
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      primary: Color.fromARGB(
                          159, 21, 49, 106),
                    ),
        child: Text('Leave Session'),
      ),
    ],
  ),
),
        ));
  }

  void _showLeaveSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quit Session'),
          content: Text('Are you sure you want to quit?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color.fromARGB(159, 21, 49, 106),
              ),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                dispose();
                await AvatarInventoryDatabase.addMoney(userPoints);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MenuPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color.fromARGB(159, 21, 49, 106),
              ),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _openCamera(BuildContext context) async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('No cameras available on the device.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Color.fromARGB(
                    159, 21, 49, 106),
              ),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      final firstCamera = cameras.first;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(camera: firstCamera),
        ),
      );
    }
  }
}
class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

Future<void> _takePicture() async {
    await _initializeControllerFuture;

    final image = await _controller.takePicture();

    await _requestPermission();

    await _saveImageToGallery(image);
  }

  Future<void> _requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
  }

  Future<void> _saveImageToGallery(XFile image) async {
  await GallerySaver.saveImage(image.path).then((bool? success) {
    if (success != null && success) {
      print("Image saved to gallery");
    } else {
      print("Failed to save image");
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Camera')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: <Widget>[
                Expanded(child: CameraPreview(_controller)),
                FloatingActionButton(
                  onPressed: _takePicture,
                  backgroundColor:  Color.fromARGB(159, 21, 49, 106),
                  foregroundColor: Colors.white,
                  //child: Icon(Icons.camera),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

