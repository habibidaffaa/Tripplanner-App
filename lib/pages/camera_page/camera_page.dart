// // import 'package:flutter/material.dart';

// // class CameraPage extends StatefulWidget {
// //   const CameraPage({super.key});

// //   @override
// //   State<CameraPage> createState() => _CameraPageState();
// // }

// class _CameraPageState extends State<CameraPage> {
  // CameraController controller;

  // Future<void> initializeCamera() async {
  //   var cameras = await availableCameras();
  //   controller = CameraController(cameras[0], ResolutionPreset.medium);
  //   await controller.initialize();
  // };

  // @override
  // void dispose() {
  //   var controller;
  //   controller?.dispose();
  //   super.dispose();
  // }
  // Future<file> takePicture() async {
  //   Directory root = await getTemporaryDirectory();
  //   String directoryPath = '${root.path}/GuidedCamera';
  //   await Directory(directoryPath).create(recursive: true);
  //   String filePath = '$directoryPath/${DateTime.now()}.jpg';

  //   try{
  //     controller.takePicture(filePath);
  //   } catch (e) {
  //     return null;
  //   }
  //   return File(filePath);
  // }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(backgroundColor: Colors.black, body: FutureBuilder(
// //       future: initializeCamera(),
// //       builder: (, snapshot) => (snapshot.connectionState == ConnectionState.done) ? Container() :
// //       const Center(child: SizedBox(
// //         height: 20,
// //         width: 20,
// //         child: CircularProgressIndicator(),
// //       ),
// //       ),
// //       ),
// //       );
// //   }
// // }

// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import 'package:camera/camera.dart';
// // import 'package:path_provider/path_provider.dart';

// // class CameraPage extends StatefulWidget {
// //   const CameraPage({Key key}) : super(key: key);

// //   @override
// //   State<CameraPage> createState() => _CameraPageState();
// // }

// // class _CameraPageState extends State<CameraPage> {
// //   CameraController controller;

// //   Future<void> initializeCamera() async {
// //     WidgetsFlutterBinding.ensureInitialized();
// //     final cameras = await availableCameras();
// //     controller = CameraController(cameras[0], ResolutionPreset.medium);
// //     await controller.initialize();
// //   }

// //   @override
// //   void dispose() {
// //     controller?.dispose();
// //     super.dispose();
// //   }

// //   Future<File> takePicture() async {
// //     try {
// //       final Directory root = await getTemporaryDirectory();
// //       final String directoryPath = '${root.path}/GuidedCamera';
// //       await Directory(directoryPath).create(recursive: true);
// //       final String filePath = '$directoryPath/${DateTime.now()}.jpg';

// //       await controller.takePicture(filePath);
// //       return File(filePath);
// //     } catch (e) {
// //       print("Error taking picture: $e");
// //       return null;
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       body: FutureBuilder<void>(
// //         future: initializeCamera(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(
// //               child: SizedBox(
// //                 height: 20,
// //                 width: 20,
// //                 child: CircularProgressIndicator(),
// //               ),
// //             );
// //           } else {
// //             return Container(); // Return your camera preview widget here
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }


// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import 'package:camera/camera.dart';
// // import 'package:path_provider/path_provider.dart';

// // class CameraPage extends StatefulWidget {
// //   const CameraPage({Key key}) : super(key: key);

// //   @override
// //   State<CameraPage> createState() => _CameraPageState();
// // }

// // class _CameraPageState extends State<CameraPage> {
// //   CameraController controller;

// //   Future<void> initializeCamera() async {
// //     WidgetsFlutterBinding.ensureInitialized();
// //     final cameras = await availableCameras();
// //     controller = CameraController(cameras[0], ResolutionPreset.medium);
// //     await controller.initialize();
// //   }

// //   @override
// //   void dispose() {
// //     controller?.dispose();
// //     super.dispose();
// //   }

// //   Future<File> takePicture() async {
// //     try {
// //       final Directory root = await getTemporaryDirectory();
// //       final String directoryPath = '${root.path}/GuidedCamera';
// //       await Directory(directoryPath).create(recursive: true);
// //       final String filePath = '$directoryPath/${DateTime.now()}.jpg';

// //       await controller.takePicture(filePath);
// //       return File(filePath);
// //     } catch (e) {
// //       print("Error taking picture: $e");
// //       return null;
// //     }
// //   }

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:path_provider/path_provider.dart';

// class CameraPage extends StatefulWidget {
//   const CameraPage({Key key}) : super(key: key);

//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> {
//   CameraController controller;

//   Future<void> initializeCamera() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     final cameras = await availableCameras();
//     controller = CameraController(cameras[0], ResolutionPreset.medium);
//     await controller.initialize();
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   Future<File> takePicture() async {
//     try {
//       final Directory root = await getTemporaryDirectory();
//       final String directoryPath = '${root.path}/GuidedCamera';
//       await Directory(directoryPath).create(recursive: true);
//       final String filePath = '$directoryPath/${DateTime.now()}.jpg';

//       await controller.takePicture(filePath);
//       return File(filePath);
//     } catch (e) {
//       print("Error taking picture: $e");
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: FutureBuilder<void>(
//         future: initializeCamera(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           } else {
//             return CameraPreview(
//                 controller); // Return your camera preview widget here
//           }
//         },
//       ),
//     );
//   }
// }

