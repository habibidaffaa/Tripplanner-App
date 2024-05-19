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
  List<File>? image;

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
        if (image == null) {
          image = [File(imagePicked.path)]; // Inisialisasi list jika belum ada
        } else {
          image!.add(File(imagePicked.path)); // Tambahkan file ke dalam list
        }
      },
    );
    print(result); // Cetak hasil (path gambar yang disimpan)
    print(image.toString());
  }

  Future getImageGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicked =
        await picker.pickImage(source: ImageSource.gallery);
    if (imagePicked != null) {
      setState(
        () {
          // image = File(imagePicked.path);
          if (image == null) {
            image = [
              File(imagePicked.path)
            ]; // Inisialisasi list jika belum ada
          } else {
            image!.add(File(imagePicked.path)); // Tambahkan file ke dalam list
          }
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
                    ? GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              3, // Menentukan jumlah gambar per baris
                          crossAxisSpacing:
                              4.0, // Spasi antar gambar secara horizontal
                          mainAxisSpacing:
                              4.0, // Spasi antar gambar secara vertikal
                        ),
                        itemCount: image!.length,
                        itemBuilder: (context, index) {
                          return Image.file(
                            image![index],
                            fit: BoxFit.cover,
                          );
                        },
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
