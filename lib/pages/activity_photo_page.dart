import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:get/get.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iterasi1/model/activity.dart';
import 'package:iterasi1/pages/activity_photo_controller.dart';
import 'package:iterasi1/pages/activity_trash_photo_page.dart';
import 'package:iterasi1/provider/itinerary_provider.dart';
import 'package:path/path.dart' as path_lib;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ActivityPhotoPage extends StatefulWidget {
  final Activity activity;
  final int dayIndex;
  const ActivityPhotoPage({
    Key? key,
    required this.activity,
    required this.dayIndex,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ActivityPhotoPageState createState() => _ActivityPhotoPageState();
}

class _ActivityPhotoPageState extends State<ActivityPhotoPage> {
  final controller = Get.put(PhotoController());

  late ItineraryProvider itineraryProvider =
      Provider.of<ItineraryProvider>(context, listen: false);

  Future<void> requestPermission() async {
    const permission = Permission.manageExternalStorage;

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
        log('Image added to activity images: ${savedImage.path}');
        itineraryProvider.addPhotoActivity(
            activity: widget.activity, pathImage: savedImage.path);
        setState(() {
          controller.loadImage();
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
          controller.image.add(savedImage);
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
    controller.dateIndex = widget.dayIndex;
    controller.itineraryProvider = itineraryProvider;
    print('widget : ${widget.activity.startDateTime}');
    print('widget 2 : ${widget.activity.startActivityTime}');
    controller.activity = widget.activity;
    controller.day = itineraryProvider.getDateTime();
    requestPermission();
    cleanUpImages(); // Bersihkan daftar gambar sebelum inisialisasi
    controller.image.value =
        controller.convertPathsToFiles(widget.activity.images!);
    log('Initial images: ${widget.activity.images}');
    controller.loadImage();
    super.initState();
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
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ActivityTrashPhotoPage(
                            activity: widget.activity,
                          )));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // Atur latar belakang putih
            ),
            child: Icon(Icons.abc),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          itineraryProvider.cleanPhotoActivity(activity: widget.activity);
          controller.image.value =
              controller.convertPathsToFiles(widget.activity.images!);
          log('Initial images: ${widget.activity.images}');
          await controller.loadImage();
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Column(
                      //   children: [
                      //     // ElevatedButton(
                      //     //   onPressed: () async {
                      //     //     var files = await loadPhotos();
                      //     //     if (files.isNotEmpty) {
                      //     //       setState(() {
                      //     //         image = files;
                      //     //       });
                      //     //     }
                      //     //   },
                      //     //   style: ButtonStyle(
                      //     //       // backgroundColor: MaterialStateProperty<Colors.black>
                      //     //       //     WidgetStateProperty.resolveWith<Color?>(
                      //     //       //   (Set<WidgetState> states) {
                      //     //       //     if (states.contains(WidgetState.pressed)) {
                      //     //       //       return Colors.grey[100];
                      //     //       //     }
                      //     //       //     return Colors.grey;
                      //     //       //   },
                      //     //       // ),
                      //     //       ),
                      //     //   child: const Text(
                      //     //     'Gallery',
                      //     //     style: TextStyle(
                      //     //       color: Colors.white,
                      //     //     ),
                      //     //   ),
                      //     // )
                      //   ],
                      // ),
                      const SizedBox(
                        height: 6,
                      ),
                      controller.isLoading.isTrue
                          ? Container(
                              child: const Text('coba loading'),
                            )
                          : controller.image.isNotEmpty
                              ? MasonryView(
                                  listOfItem: controller.image,
                                  numberOfColumn: 2,
                                  itemBuilder: (item) {
                                    final file = item as File;
                                    return GestureDetector(
                                      onTap: () {
                                        _showImageDialog(file);
                                      },
                                      onLongPress: () {
                                        controller.showDeleteConfirmationDialog(
                                            context, file);
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                          file,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
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
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
