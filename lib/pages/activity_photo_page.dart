// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iterasi1/provider/itinerary_provider.dart';
import 'package:path/path.dart' as path_lib;
// import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:iterasi1/model/activity.dart';
import 'package:provider/provider.dart';

class ActivityPhotoPage extends StatefulWidget {
  final Activity activity;
  const ActivityPhotoPage({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  _ActivityPhotoPageState createState() => _ActivityPhotoPageState();
}

class _ActivityPhotoPageState extends State<ActivityPhotoPage> {
  late ItineraryProvider itineraryProvider =
      Provider.of<ItineraryProvider>(context, listen: false);
  List<File>? image;

  List<File> convertPathsToFiles(List<String> paths) {
    log(paths.toString());
    List<File> files = [];
    for (String path in paths) {
      File file = File(path);
      if (file.existsSync()) {
        // Pastikan file ada di lokasi yang diberikan
        files.add(file);
      }
    }
    return files;
  }

  Future<void> requestPermission() async {
    final permission = Permission.manageExternalStorage;

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

    final String fileName =
        path_lib.basename(imagePicked.path); // Ambil nama file

// Dapatkan direktori penyimpanan eksternal
    final dir = await getExternalStorageDirectory();
    if (dir == null) {
      // Penanganan kesalahan jika direktori eksternal tidak ditemukan
      print('Error: External storage directory not found');
      return;
    }
    final String path = dir.path;

// Buat file baru di direktori penyimpanan eksternal
    final File newImage = File('$path/Media/$fileName');
    try {
      // Buat file baru
      await newImage.create(recursive: true);
    } catch (e) {
      // Penanganan kesalahan jika gagal membuat file baru
      print('Error creating file: $e');
      return;
    }

// Salin file gambar sementara ke lokasi yang dapat diakses secara persisten
    await File(imagePicked.path).copy(newImage.path);

// Sekarang Anda dapat menggunakan file yang sudah disalin
    final result = await ImageGallerySaver.saveFile(newImage.path,
        isReturnPathOfIOS: true);

    setState(
      () {
        if (image == null) {
          image = [newImage]; // Inisialisasi list jika belum ada
          context.read<ItineraryProvider>().addPhotoActivity(
                activity: widget.activity,
                pathImage: newImage.path,
              );
        } else {
          image!.add(newImage); // Tambahkan file ke dalam list
          context.read<ItineraryProvider>().addPhotoActivity(
                activity: widget.activity,
                pathImage: newImage.path,
              );
        }
      },
    );
    // print(result); // Cetak hasil (path gambar yang disimpan)
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
    image = convertPathsToFiles(widget.activity.images!);
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
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     await getImageGallery();
                    //   },
                    //   style: ButtonStyle(
                    //     backgroundColor:
                    //         MaterialStateProperty.resolveWith<Color?>(
                    //       (Set<MaterialState> states) {
                    //         if (states.contains(MaterialState.pressed)) {
                    //           return Colors.grey[100];
                    //         }
                    //         return Colors.grey;
                    //       },
                    //     ),
                    //   ),
                    //   child: const Text(
                    //     'Gallery',
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // )
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
