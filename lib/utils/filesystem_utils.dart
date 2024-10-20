import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileSystemUtils {
  static const String mediaDirectory = 'media';
  static const String avatarDirectory = 'avatar';

  static final List<String> subDirs = [mediaDirectory, avatarDirectory];

  static Future<void> createDirectories() async {
    if (kIsWeb) return;

    Directory appDocDir = await getApplicationDocumentsDirectory();

    for (String subDir in subDirs) {
      Directory directory = Directory('${appDocDir.path}/$subDir');
      if (!await directory.exists()) {
        debugPrint('$subDir (${directory.path}) does not exist. Creating');
        await directory.create(recursive: true);
      }
    }
  }

  static Future<Directory> getMediaDirectory() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    return Directory('${appDocDir.path}/$mediaDirectory');
  }

  static Future<Directory> getAvatarDirectory() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    return Directory('${appDocDir.path}/$avatarDirectory');
  }

  static Future<void> deleteFile(String filePath) async {
    File file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<void> deleteAllFilesInMediaDirectory() async {
    if (kIsWeb) {
      return;
    }
    Directory appMediaDir = await getMediaDirectory();

    if (await appMediaDir.exists()) {
      List<FileSystemEntity> files = await appMediaDir.list().toList();

      for (FileSystemEntity file in files) {
        await file.delete(recursive: true);
      }
    }
  }

  static Future<String> moveFileToMediaDirectory({
    required String sourceFilePath,
    String? newName,
  }) async {
    String filename = newName ?? path.basename(sourceFilePath);
    File file = File(sourceFilePath);
    if (!await file.exists()) {
      debugPrint('File does not exists: $sourceFilePath');
    }
    Directory appMediaDir = await getMediaDirectory();
    String newPath = '${appMediaDir.path}/$filename';
    await file.rename(newPath);

    debugPrint('Moved file to $newPath');

    return newPath;
  }

  static Future<String> moveFileToAvatarDirectory({
    required String sourceFilePath,
    String? newName,
  }) async {
    String filename = newName ?? path.basename(sourceFilePath);
    File file = File(sourceFilePath);
    if (!await file.exists()) {
      debugPrint('File does not exists: $sourceFilePath');
    }
    Directory avatarDir = await getAvatarDirectory();
    String newPath = '${avatarDir.path}/$filename';
    await file.rename(newPath);

    debugPrint('Moved file to $newPath');

    return newPath;
  }

  static Future<String> copyFileToAvatarDirectory({
    required String sourceFilePath,
    String? newName,
  }) async {
    String filename = path.basename(sourceFilePath);
    if (newName != null) {
      filename = '$newName${path.extension(sourceFilePath)}';
    }

    File file = File(sourceFilePath);
    if (!await file.exists()) {
      debugPrint('File does not exists: $sourceFilePath');
    }
    Directory appMediaDir = await getAvatarDirectory();
    String newPath = '${appMediaDir.path}/$filename';
    await file.copy(newPath);

    debugPrint('Copied file to $newPath');

    return newPath;
  }

  static Future<String?> getAvatarPath(String filename) async {
    Directory avatarDir = await getAvatarDirectory();
    File file = File('${avatarDir.path}/$filename.jpg');
    if (await file.exists()) {
      return file.path;
    }
    return null;
  }
}
