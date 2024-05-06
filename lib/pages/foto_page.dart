import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iterasi1/resource/custom_colors.dart';
import 'package:permission_handler/permission_handler.dart';

class FotoPage extends StatefulWidget {
  const FotoPage({Key? key}) : super(key: key);

  @override
  _FotoPageState createState() => _FotoPageState();
}

class _FotoPageState extends State<FotoPage> {
  File? image;

  Future<void> requestPermission() async {
    final permission = Permission.storage;

    if (await permission.isDenied) {
      final result = await permission.request();
      if (result.isGranted) {
        // Permission is granted
      } else if (result.isDenied) {
        // Permission is denied
      } else if (result.isPermanentlyDenied) {
        // Permission is permanently denied
      }
    }
  }

  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicked =
        await picker.pickImage(source: ImageSource.camera);
    if (imagePicked != null) {
      log(imagePicked.path);
// copy the file to a new path
      // final File newImage = await imagePicked.('$path/image1.png');
      setState(
        () {
          image = File(imagePicked.path);
        },
      );
    }
  }

  // saveImage() async {
  //   PermissionStatus result;
  //   if (Platform.isAndroid) {
  //     DeviceInfoPl deviceInfo = DeviceInfoPlugin();
  //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //     if (androidInfo.version.sdkInt >= 33) {
  //       result = await Permission.photos.request();
  //     } else {
  //       result = await Permission.storage.request();
  //     }
  //     if (result.isGranted) {
  //       var image = await boundary.toImage();
  //       var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //       var ref = FFAppState().FrameRef;
  //       final name = 'cl1box1_' + ref;
  //       await ImageGallerySaver.saveImage(byteData!.buffer.asUint8List(),
  //           name: name);
  //     }
  //   } else {
  //     await openAppSettings();
  //   }
  // }
  _saveCameraImage() async {
    final picker = ImagePicker();
    final XFile? imagePicked =
        await picker.pickImage(source: ImageSource.camera);
    if (imagePicked == null) return; // Periksa apakah gambar dipilih atau tidak
    final bytes = await imagePicked.readAsBytes(); // Baca bytes dari gambar
    final result = await ImageGallerySaver.saveFile(
      imagePicked.path, // Path gambar
    );
    setState(
      () {
        image = File(imagePicked.path);
      },
    );
    print(result); // Cetak hasil (path gambar yang disimpan)
  }

  Future getImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicked =
        await picker.pickImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      setState(
        () {
          image = File(imagePicked.path);
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Image",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'poppins_bold',
            fontSize: 24,
            fontWeight: FontWeight.normal,
            color: Color(0xFFC58940),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _saveCameraImage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Atur latar belakang putih
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Geser posisi gambar ke kiri
              children: [
                Image.asset(
                  'assets/images/Logo_camera.png',
                  width: 40,
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await getImageGallery();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.grey[100];
                            }
                            return Colors.grey;
                          },
                        ),
                      ),
                      child: const Text(
                        'Gallery',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                image != null
                    ? SizedBox(
                        height: 500,
                        width: MediaQuery.of(context).size.width,
                        child: Image.file(image!, fit: BoxFit.cover),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
