import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;
import '../../../../net/flutterfire.dart';
import '../../models/user.dart';
import 'dart:developer' as developer;

import '../../utils/local_db.dart';
import '../../utils/utils.dart';
import 'ImageConverter.dart';

class MLService {
  Interpreter? interpreter;
  List? predictedArray;
  final AuthService _auth = AuthService();

  Future<String?> predict(
      CameraImage cameraImage, Face face, String name, Map<String, dynamic> guardFace) async {

    /*final user = FirebaseAuth.instance.currentUser!;*/
    List input = _preProcess(cameraImage, face);
    input = input.reshape([1, 112, 112, 3]);

    List output = List.generate(1, (index) => List.filled(192, 0));

    await initializeInterpreter();

    late List userArray;

    interpreter!.run(input, output);
    output = output.reshape([192]);

    predictedArray = List.from(output);

    /*if (1==1) {
      LocalDB.setUserDetails(UserLocal(name: name, array: predictedArray!));
      return null;
    } else {*/
    /*UserLocal? user = LocalDB.getUser();*/
    int minDist = 999;
    double threshold = 0.5;
    double curr_min = 1000;
    String? curr_face = '';
    double dist = 0;

    for (var face in guardFace.keys){
      userArray = guardFace[face];
      dist = euclideanDistance(predictedArray!, userArray);
      if (dist <= threshold && dist < minDist) {
          if (dist < curr_min){
            curr_face = face;
            curr_min = dist;
          }
      }
    }
    if (curr_face == '') {
      return null;
    } else{
      return curr_face;
    }

  }


  Future<List?> getPredictedArray(cameraImage, face, name, guardFace) async {
    await predict(cameraImage, face, name, guardFace);
    return predictedArray;
  }


  euclideanDistance(List l1, List l2) {
    double sum = 0;
    for (int i = 0; i < l1.length; i++) {
      sum += pow((l1[i] - l2[i]), 2);
    }

    return pow(sum, 0.5);
  }

  initializeInterpreter() async {
    Delegate? delegate;
    try {
      if (Platform.isAndroid) {
        delegate = GpuDelegateV2(
            options: GpuDelegateOptionsV2(
              isPrecisionLossAllowed: false,
              inferencePreference: TfLiteGpuInferenceUsage.fastSingleAnswer,
              inferencePriority1: TfLiteGpuInferencePriority.minLatency,
              inferencePriority2: TfLiteGpuInferencePriority.auto,
              inferencePriority3: TfLiteGpuInferencePriority.auto,
            ));
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
          options: GpuDelegateOptions(
              allowPrecisionLoss: true,
              waitType: TFLGpuDelegateWaitType.active),
        );
      }
      var interpreterOptions = InterpreterOptions()..addDelegate(delegate!);

      interpreter = await Interpreter.fromAsset('mobilefacenet.tflite',
          options: interpreterOptions);
    } catch (e) {
      printIfDebug('Failed to load model.');
      printIfDebug(e);
    }
  }

  List _preProcess(CameraImage image, Face faceDetected) {
    imglib.Image croppedImage = _cropFace(image, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);

    Float32List imageAsList = _imageToByteListFloat32(img);
    return imageAsList;
  }

  imglib.Image _cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = _convertCameraImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(
        convertedImage, x.round(), y.round(), w.round(), h.round());
  }

  imglib.Image _convertCameraImage(CameraImage image) {
    var img = convertToImage(image);
    var img1 = imglib.copyRotate(img!, -90);
    return img1;
  }

  Float32List _imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }
}