import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoController extends GetxController {
  RxList<File> image = <File>[].obs;
  List<File> files = <File>[].obs;

  @override
  void onInit() {
    loadImage();
    super.onInit();
  }

  void loadImage() async {
    var files = await loadPhotos();
    if (files.isNotEmpty) {
      image.value = files;
    }
  }

  Future<List<File>> loadPhotos() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
      List<AssetEntity> assets =
          await albums.first.getAssetListPaged(page: 0, size: 100);
      List<File> files = [];
      for (var asset in assets) {
        var file = await asset.originFile;
        if (file != null) {
          files.add(file);
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
}
