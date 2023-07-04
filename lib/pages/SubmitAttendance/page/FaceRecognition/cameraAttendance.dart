import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:camera/camera.dart';
import 'package:concorde_app/pages/SubmitAttendance/page/submit_attendance_success.dart';
import 'package:concorde_app/providers/face_attendance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../../net/flutterfire.dart';
import '../../../../providers/guards_face.dart';
import '../../models/user.dart';
import '../../widgets/common_widgets.dart';
import 'mlServices.dart';


List<CameraDescription>? camerasOne;

class FaceScanScreenAttendance extends StatefulWidget {
  /*final UserLocal? user;*/
  final String? name;

  const FaceScanScreenAttendance({Key? key, this.name}) : super(key: key);
  static const routeName = '/camera_attendance';

  @override
  _FaceScanScreenAttendanceState createState() => _FaceScanScreenAttendanceState();
}

class _FaceScanScreenAttendanceState extends State<FaceScanScreenAttendance> {
  TextEditingController controller = TextEditingController();
  late CameraController _cameraController;
  bool flash = false;
  String imageUrl = '';
  String name = '';
  bool isControllerInitialized = false;
  late FaceDetector _faceDetector;
  final MLService _mlService = MLService();
  List<Face> facesDetected = [];
  final AuthService _auth = AuthService();
  DateTime now = DateTime.now();
  late String date = DateFormat('yyyy-MM-dd kk:mm').format(now);
  late String guardOnDuty = 'Sam, Dave, Ryan';
  late String location = 'AMK Hub';
  List? predictedArray;
  Map<String, dynamic> guardFace = {};
  /*final user = FirebaseAuth.instance.currentUser!;*/

  List<FaceAttendance> facePerson = [];
  /*late Future<List<FaceAttendance>> facePersonStream = _auth.getFaceAttendance();*/

  /*void futureTrans() async {
    facePersonStream.then((face){
      facePerson.add(face);
    });
  }*/
  Future<List<FacePerson>> get_data() async {
    return await _auth.getFaceAttendance();
  }

  Future<int> getUserMap() async {
    /*List<FaceAttendance> facePerson = get_data();*/
    await get_data().then((face) =>

        face.forEach((person) => guardFace[person.name] = person.imageArray)
        /*for (var face in facePerson){
          guardFace[face.name] = guardFace[face.imageArray];*/
    );
    return 0;
  }


  Future initializeCamera() async {
    await _cameraController.initialize();
    isControllerInitialized = true;
    _cameraController.setFlashMode(FlashMode.off);
    setState(() {});
  }

  InputImageRotation rotationIntToImageRotation(int rotation) {
    switch (rotation) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future<void> detectFacesFromImage(CameraImage image) async {
    InputImageData _firebaseImageMetadata = InputImageData(
      imageRotation: rotationIntToImageRotation(
          _cameraController.description.sensorOrientation),
      inputImageFormat: InputImageFormat.bgra8888,
      size: Size(image.width.toDouble(), image.height.toDouble()),
      planeData: image.planes.map(
            (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );

    InputImage _firebaseVisionImage = InputImage.fromBytes(
      bytes: Uint8List.fromList(
        image.planes.fold(

            <int>[],
                (List<int> previousValue, element) =>
            previousValue..addAll(element.bytes)),
      ),
      inputImageData: _firebaseImageMetadata,
    );
    var result = await _faceDetector.processImage(_firebaseVisionImage);
    if (result.isNotEmpty) {
      facesDetected = result;
    }
  }

  Future<void> _predictFacesFromImage({required CameraImage image}) async {
    /*List<FaceAttendance> guardFace = await get_data();*/
    final _firebaseStorage = FirebaseStorage.instance;
    var snapshot;
    await getUserMap();
    await detectFacesFromImage(image);
    /*developer.log(guardFace.keys.first, name: 'my.app.category');*/
    String? user = await MLService().predict(
        image,
        facesDetected[0],
        '',
        guardFace);
    predictedArray = await MLService().getPredictedArray(
        image,
        facesDetected[0],
        '',
        guardFace);
    if (user != null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => FacialSuccess(name: user)));
      /*showDialog(
          context: context,
          builder: (context) =>
          const AlertDialog(content: Text('Picture has been successfully uploaded. ')));*/
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) =>
          const AlertDialog(content: Text('Unknown User. ')));
    }


    /*if (facesDetected.isNotEmpty) {
      String? user = await _mlService.predict(
          image,
          facesDetected[0],
          widget.name!,
          guardFace);
      predictedArray = await MLService().getPredictedArray(
          image,
          facesDetected[0],
          widget.name!,
          guardFace);
      *//*if (widget.user == null) {
        // register case
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) =>
            const AlertDialog(content: Text('Picture has been successfully uploaded. ')));
      } else {
        // login case
        if (user == null) {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (context) =>
              const AlertDialog(content: Text('Unknown User. ')));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FacialSuccess(name: widget.name!)));
        }
      }*//*
    }*/
    /*if (mounted) setState(() {});*/
    await takePicture(image);
  }

  Future<void> takePicture(CameraImage image) async {
    final _firebaseStorage = FirebaseStorage.instance;
    var snapshot;
    String? user = await MLService().predict(
        image,
        facesDetected[0],
        '',
        guardFace);
    predictedArray = await MLService().getPredictedArray(
        image,
        facesDetected[0],
        '',
        guardFace);
    if (facesDetected.isNotEmpty) {
      await _cameraController.stopImageStream();
      XFile file = await _cameraController.takePicture();
      file = XFile(file.path);
      File image = File(file.path);
      if (image != null){
        //Upload to Firebase
        if (user != null){
          snapshot = await _firebaseStorage.ref()
              .child('guards_attendance/${user}_${location}_${date}')
              .putFile(image);
          var downloadUrl = await snapshot.ref.getDownloadURL();
          imageUrl = downloadUrl;
          await _auth.addTestAttendance(user, predictedArray, location, date, imageUrl);
          /*Navigator.push(context,
              MaterialPageRoute(builder: (context) => FacialSuccess(name: user)));*/
          /*Navigator.pop(context);*/
          /*showDialog(
              context: context,
              builder: (context) =>
              const AlertDialog(content: Text('Picture has been successfully uploaded. ')));
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FacialSuccess(name: user)));*/
        }
      } else {
        showDialog(
            context: context,
            builder: (context) =>
            const AlertDialog(content: Text('Please retake picture. Attendance Submit Failed. ')));
      }
      _cameraController.setFlashMode(FlashMode.off);
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) =>
          const AlertDialog(content: Text('No face detected!')));
    }
  }

  @override
  void initState() {
    _cameraController = CameraController(camerasOne![1], ResolutionPreset.high);
    initializeCamera();
    _faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        performanceMode : FaceDetectorMode.accurate,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: isControllerInitialized
                    ? CameraPreview(_cameraController)
                    : null),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Lottie.asset("assets/loading.json",
                          width: MediaQuery.of(context).size.width * 0.7),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: CWidgets.customExtendedButton(
                            text: "Capture",
                            context: context,
                            isClickable: true,
                            onTap: (){
                              bool canProcess = false;
                              _cameraController.startImageStream((CameraImage image) async {
                                if (canProcess) return;
                                canProcess = true;
                                _predictFacesFromImage(image: image).then((value) {
                                  canProcess = false;
                                });
                                return null;
                              });
                            }),
                      ),
                      IconButton(
                          icon: Icon(
                            flash ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              flash = !flash;
                            });
                            flash
                                ? _cameraController
                                .setFlashMode(FlashMode.torch)
                                : _cameraController.setFlashMode(FlashMode.off);
                          }),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}