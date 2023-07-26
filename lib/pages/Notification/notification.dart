import 'dart:io';

import 'package:camera/camera.dart';
import 'package:concorde_app/pages/Profile/profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);
  static const routeName = '/notification';

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  File? _image;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(
        _cameras[0],
        ResolutionPreset.medium,
      );

      try {
        await _cameraController!.initialize();
      } catch (e) {
        print("Error: ${e}");
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    final image = await _cameraController?.takePicture();
    setState(() {
      _image = File(image!.path);
    });
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image!.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      final storage = FirebaseStorage.instance;
      final imageName = path.basename(_image!.path);
      final Reference ref = storage.ref().child('images/$imageName');
      await ref.putFile(_image!);
      final url = await ref.getDownloadURL();
      print('Image uploaded to Firebase Cloud Storage: ');
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Camera Page')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: _cameraController!.value.aspectRatio,
            child: CameraPreview(_cameraController!),
          ),
          ElevatedButton(
            onPressed: _takePicture,
            child: Text('Take Site Picture'),
          ),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Pick Image'),
          ),
          if (_image != null)
            Image.file(
              _image as File,
              height: 300,
              width: 300,
            ),
           ElevatedButton(
             onPressed: _uploadImage,
             child: Text('Upload Image to Cloud Storage'),
          ),
        ],
      ),
    );
  }
}
// class _GetNotificationState extends State<GetNotification> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Picture taken for the '),
//       ),
//       body: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.all(8.0),
//           width: double.infinity,
//           decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.teal,
//                   Colors.white,
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               )),
//           child: Column(
//             children: <Widget>[
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

