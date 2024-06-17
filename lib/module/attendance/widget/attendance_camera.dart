import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:nanyang_application/helper.dart';
import 'package:nanyang_application/provider/toast_provider.dart';
import 'package:provider/provider.dart';

class AttendanceCamera extends StatefulWidget {
  const AttendanceCamera({super.key});

  @override
  State<AttendanceCamera> createState() => _AttendanceCameraState();
}

class _AttendanceCameraState extends State<AttendanceCamera> {
  late List<CameraDescription> _camera;
  late final CameraController controller;
  late final InputImage image;
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };
  @override
  void initState() {
    super.initState();
    // camera = await availableCameras();
    initializeCamera(context);
  }

  Future<void> initializeCamera(BuildContext context) async {
    print('initializeCamera');
    _camera = await availableCameras();
    controller = CameraController(
      _camera[1],
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21 // for Android
          : ImageFormatGroup.bgra8888, // for iOS
    );

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        if (controller.value.isInitialized) {
          controller.startImageStream((CameraImage image) {
            final InputImage inputImage = _inputImageFromCameraImage(image)!;
            detectFace(inputImage);
          });
        }
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            context.read<ToastProvider>().showToast('Akses kamera tidak diberikan', 'error');
            break;
          default:
            context.read<ToastProvider>().showToast('Terjadi kesalahan, silahkan coba lagi!', 'error');
            break;
        }
      }
    });
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas
    final camera = _camera[1];
    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[controller.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;
    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    Uint8List bytes;
    if (format == null || (Platform.isAndroid && format != InputImageFormat.nv21) || (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      bytes = yuv420ToNv21(image);
    } else {
      // since format is constraint to nv21 or bgra8888, both only have one plane
      if (image.planes.length != 1) return null;
      bytes = image.planes.first.bytes;
    }

    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format!, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  Future<void> detectFace(InputImage image) async {
    print('detectFace');
    final List<Face> faces = await _faceDetector.processImage(image);
    print('Number of faces detected: ${faces.length}');

    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;

      final double? rotX = face.headEulerAngleX; // Head is tilted up and down rotX degrees
      final double? rotY = face.headEulerAngleY; // Head is rotated to the right rotY degrees
      final double? rotZ = face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

      // // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
      // // eyes, cheeks, and nose available):
      // final FaceLandmark? leftEar = face.landmarks[FaceLandmarkType];
      // if (leftEar != null) {
      //   final Point<int> leftEarPos = leftEar.position;
      //   print('Left ear position: $leftEarPos');
      // }

      // // If classification was enabled with FaceDetectorOptions:
      // if (face.smilingProbability != null) {
      //   final double? smileProb = face.smilingProbability;
      //   print('Smiling probability: $smileProb');
      // }

      // // If face tracking was enabled with FaceDetectorOptions:
      // if (face.trackingId != null) {
      //   final int? id = face.trackingId;
      //   print('Face id: $id');
      // }
      //create a new rect with the bounding box
      final Rect newRect = Rect.fromLTWH(
        boundingBox.left,
        boundingBox.top,
        boundingBox.width,
        boundingBox.height,
      );
      //draw the rect on the canvas
      // canvas.drawRect(newRect, Paint()..color = Colors.red);
      //get the embedded image
      
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    _faceDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    } else {
      return CameraPreview(controller);
    }
  }
}