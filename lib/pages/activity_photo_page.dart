import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iterasi1/provider/itinerary_provider.dart';
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:iterasi1/model/activity.dart';

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
  List<File> image = [];

  List<File> convertPathsToFiles(List<String> paths) {
    log('Converting paths to files: $paths');
    List<File> files = [];
    for (String path in paths) {
      if (path.isNotEmpty) {
        // Periksa jika path tidak kosong
        File file = File(path);
        if (file.existsSync()) {
          // Pastikan file ada di lokasi yang diberikan
          files.add(file);
        } else {
          log('File does not exist at path: $path');
        }
      } else {
        log('Encountered empty path in list: $paths');
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
        log('Permission granted');
      } else if (result.isDenied) {
        // Permission is denied
        log('Permission denied');
      } else if (await permission.isPermanentlyDenied) {
        // Permission is permanently denied
        log('Permission permanently denied');
      }
    }
  }

  _saveCameraImage() async {
    final picker = ImagePicker();
    final XFile? imagePicked =
        await picker.pickImage(source: ImageSource.camera);
    if (imagePicked != null && imagePicked.path.isNotEmpty) {
      log('Camera image picked: ${imagePicked.path}');
      final File imageFile = File(imagePicked.path);
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path_lib.basename(imageFile.path);
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');
      log('Image saved to: ${savedImage.path}');
      if (!widget.activity.images!.contains(savedImage.path)) {
        widget.activity.images!.add(savedImage.path);
        log('Image added to activity images: ${savedImage.path}');
        itineraryProvider.addPhotoActivity(
            activity: widget.activity, pathImage: savedImage.path);
        setState(() {
          image.add(savedImage);
          log('Image added to local image list: ${savedImage.path}');
        });
      } else {
        log('Image already exists in activity images: ${savedImage.path}');
      }
    } else {
      log('Camera image path is null or empty');
    }
  }

  _saveGalleryImage() async {
    final picker = ImagePicker();
    final XFile? imagePicked =
        await picker.pickImage(source: ImageSource.gallery);
    if (imagePicked != null && imagePicked.path.isNotEmpty) {
      log('Gallery image picked: ${imagePicked.path}');
      final File imageFile = File(imagePicked.path);
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path_lib.basename(imageFile.path);
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');
      log('Image saved to: ${savedImage.path}');
      if (!widget.activity.images!.contains(savedImage.path)) {
        widget.activity.images!.add(savedImage.path);
        log('Image added to activity images: ${savedImage.path}');
        itineraryProvider.addPhotoActivity(
            activity: widget.activity, pathImage: savedImage.path);
        setState(() {
          image.add(savedImage);
          log('Image added to local image list: ${savedImage.path}');
        });
      } else {
        log('Image already exists in activity images: ${savedImage.path}');
      }
    } else {
      log('Gallery image path is null or empty');
    }
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    cleanUpImages(); // Bersihkan daftar gambar sebelum inisialisasi
    image = convertPathsToFiles(widget.activity.images!);
    log('Initial images: ${widget.activity.images}');
  }

  void cleanUpImages() {
    log('Cleaning up images...');
    widget.activity.images = widget.activity.images!
        .where((image) => image.isNotEmpty)
        .toSet()
        .toList(); // Hapus duplikasi dan path kosong
    log('Cleaned images: ${widget.activity.images}');
  }

  void _showImageDialog(File imageFile) {
    final image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          final imageWidth = info.image.width;
          final imageHeight = info.image.height;
          final aspectRatio = imageWidth / imageHeight;
          final maxDialogWidth = MediaQuery.of(context).size.width * 0.9;
          final maxDialogHeight = MediaQuery.of(context).size.height * 0.8;

          double dialogWidth, dialogHeight;
          if (aspectRatio > 1) {
            // Landscape
            dialogWidth = maxDialogWidth;
            dialogHeight = dialogWidth / aspectRatio;
          } else {
            // Portrait
            dialogHeight = maxDialogHeight;
            dialogWidth = dialogHeight * aspectRatio;
          }

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                elevation: 0,
                backgroundColor: Colors.transparent,
                contentPadding: EdgeInsets.zero,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: SizedBox(
                        width: dialogWidth,
                        height: dialogHeight,
                        child: Ink(
                          color: Colors.transparent,
                          child: image,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
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
                        await _saveGalleryImage();
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
                image.isNotEmpty
                    ? MasonryView(
                        listOfItem: image,
                        numberOfColumn: 2,
                        itemBuilder: (item) {
                          final file = item as File;
                          return GestureDetector(
                            onTap: () {
                              _showImageDialog(file);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                file,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          "Tidak ada gambar yang ditampilkan",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
