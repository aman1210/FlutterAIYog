import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:yoga_app/main.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  HomePage(this.cameras);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController cameraController;
  @override
  void initState() {
    super.initState();
    cameraController = CameraController(
      cameras[1],
      ResolutionPreset.medium,
    );
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    print(cameraController.value.aspectRatio);
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/trikonasana.jpg',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: CameraPreview(cameraController),
            ),
          ],
        ),
      ),
    );
  }
}
