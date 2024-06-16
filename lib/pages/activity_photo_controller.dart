import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iterasi1/model/activity.dart';
import 'package:iterasi1/model/day.dart';
import 'package:iterasi1/provider/itinerary_provider.dart';
import 'package:native_exif/native_exif.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoController extends GetxController {
  RxList<File> image = <File>[].obs;
  List<File> files = <File>[].obs;
  List<int> dummy = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9].obs;
  RxBool isLoading = true.obs;
  late Activity activity;
  late List<Day> day;
  int dateIndex = 0;
  late ItineraryProvider itineraryProvider;

  @override
  void onInit() {
    loadImage();
    super.onInit();
  }

  void loadImage() async {
    isLoading.value = true;
    var files = await loadPhotos();
    if (files.isNotEmpty) {
      image.value = files;
      for (var i = 0; i < files.length; i++) {
        itineraryProvider.addPhotoActivity(
            activity: activity, pathImage: image[i].path);
      }
    }
    isLoading.value = false;
  }

  Future<List<File>> loadPhotos() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
      List<AssetEntity> assets =
          await albums.first.getAssetListPaged(page: 0, size: 100);
      List<File> files = [];
      for (var asset in assets) {
        bool isInDate = false;
        var file = await asset.originFile;
        if (file != null) {
          isInDate = await matchesActivityTime(file);
          if (isInDate == true) {
            files.add(file);
          }
        }
      }
      return files;
    } else {
      PhotoManager.openSetting();
      return [];
    }
  }

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

  Future<bool> matchesActivityTime(File image) async {
    var metadata = await Exif.fromPath(image.path);
    DateTime? photoDate = await metadata.getOriginalDate();
    String start = "${day[dateIndex].date} ${activity.startActivityTime}";
    DateTime startTime = DateFormat("d/M/yyyy HH:mm").parse(start);

    String end = "${day[dateIndex].date} ${activity.endActivityTime}";
    DateTime endTime = DateFormat("d/M/yyyy HH:mm").parse(end);

    DateTime activityStart = startTime;
    DateTime activityEnd = endTime;
    // DateTime activityStart = DateTime.now().subtract(Duration(days: 1));
    // DateTime activityEnd = DateTime.now().add(Duration(days: 1));
    print('date : $photoDate , start : $activityStart, end : $activityEnd');
    if (photoDate != null &&
        photoDate.isAfter(activityStart) &&
        photoDate.isBefore(activityEnd)) {
      // print('masuk');
      return true;
    } else {
      return false;
    }
  }
}
