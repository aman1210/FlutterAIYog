import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'models.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final String model;

  Camera(this.cameras, this.model, this.setRecognitions);

  @override
  _CameraState createState() => new _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();

    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No camera is found');
    } else {
      controller = new CameraController(
        widget.cameras[1],
        ResolutionPreset.medium,
      );
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        // controller.startImageStream((CameraImage img) {
        //   if (!isDetecting) {
        //     isDetecting = true;

        //     int startTime = new DateTime.now().millisecondsSinceEpoch;

        //     if (widget.model == mobilenet) {
        //       Tflite.runModelOnFrame(
        //         bytesList: img.planes.map((plane) {
        //           return plane.bytes;
        //         }).toList(),
        //         imageHeight: img.height,
        //         imageWidth: img.width,
        //         numResults: 2,
        //       ).then((recognitions) {
        //         int endTime = new DateTime.now().millisecondsSinceEpoch;
        //         print("Detection took ${endTime - startTime}");

        //         widget.setRecognitions(recognitions, img.height, img.width);

        //         isDetecting = false;
        //       });
        //     } else if (widget.model == posenet) {
        //       Tflite.runPoseNetOnFrame(
        //               bytesList: img.planes.map((plane) {
        //                 return plane.bytes;
        //               }).toList(), // required
        //               imageHeight: img.height, // defaults to 1280
        //               imageWidth: img.width, // defaults to 720
        //               imageMean: 125.0, // defaults to 125.0
        //               imageStd: 125.0, // defaults to 125.0
        //               rotation: 90, // defaults to 90, Android only
        //               numResults: 2, // defaults to 5
        //               threshold: 0.7, // defaults to 0.5
        //               nmsRadius: 10, // defaults to 20
        //               asynch: true)
        //           .then((recognitions) {
        //         int endTime = new DateTime.now().millisecondsSinceEpoch;
        //         print("Detection took ${endTime - startTime}");

        //         widget.setRecognitions(recognitions, img.height, img.width);

        //         isDetecting = false;
        //       });
        //     } else {
        //       Tflite.detectObjectOnFrame(
        //         bytesList: img.planes.map((plane) {
        //           return plane.bytes;
        //         }).toList(),
        //         model: widget.model == yolo ? "YOLO" : "SSDMobileNet",
        //         imageHeight: img.height,
        //         imageWidth: img.width,
        //         imageMean: widget.model == yolo ? 0 : 127.5,
        //         imageStd: widget.model == yolo ? 255.0 : 127.5,
        //         numResultsPerClass: 1,
        //         threshold: widget.model == yolo ? 0.2 : 0.4,
        //       ).then((recognitions) {
        //         int endTime = new DateTime.now().millisecondsSinceEpoch;
        //         print("Detection took ${endTime - startTime}");

        //         widget.setRecognitions(recognitions, img.height, img.width);

        //         isDetecting = false;
        //       });
        // }
        // }
        // });
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  captureImage() async {
    var file = await controller.takePicture();
    print(file.path);
    var re = await Tflite.runPoseNetOnImage(path: file.path, numResults: 1);
    print(re);
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return Container(
      child: Column(
        children: [
          CameraPreview(controller),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: captureImage,
          )
        ],
      ),
    );

    // return OverflowBox(
    //   maxHeight:
    //       screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
    //   maxWidth:
    //       screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
    //   child: CameraPreview(controller),
    // );
  }
}
