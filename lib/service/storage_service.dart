import 'package:amplify_flutter/amplify_flutter.dart';

class StorageService {
  StorageService();

  Future<void> uploadFile(String name, String path) async {
    final awsFile = AWSFile.fromPath(path);
    try {
      final result = await Amplify.Storage.uploadFile(
        localFile: awsFile,
        key: name,
      ).result;
      safePrint('Successfully uploaded file: ${result.uploadedItem.key}');
    } on StorageException catch (e) {
      safePrint('Error uploading file: $e');
      rethrow;
    }
  }

  Future<List<int>> downloadToMemory(String key) async {
    try {
      final result = await Amplify.Storage.downloadData(key: key).result;
      return result.bytes;
    } on StorageException catch (e) {
      safePrint(e.message);
      return [];
    }
    // try {
    //   //StorageOpt
    //   final result = await Amplify.Storage.getUrl(
    //     key: key,
    //     options: const StorageGetUrlOptions(
    //       pluginOptions: S3GetUrlPluginOptions(
    //         validateObjectExistence: true,
    //         expiresIn: Duration(days: 1),
    //       ),
    //     ),
    //   ).result;
    //   return result.url.toString();
    // } on StorageException catch (e) {
    //   safePrint(e.message);
    //   return "";
    // }
  }
}
