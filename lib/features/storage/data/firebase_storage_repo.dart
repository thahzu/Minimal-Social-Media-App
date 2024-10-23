import 'dart:typed_data';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/features/storage/domain/sotorage_repo.dart';
class FirebaseStorageRepo implements StorageRepo{

  /*
  PROFILE  PICTURES

   */

  final FirebaseStorage storage = FirebaseStorage.instance;

  // mobile platforms
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName){
    return _uploadFile(path, fileName, "profile_images");
  }

  // web platforms
  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName){
    return _uploadFileBytes(fileBytes, fileName, "profile_images");
  }
  /*

  POSTS IMAGES - upload image to storage

   */
  @override
  Future<String?> uploadPostImageMobile(String path, String fileName){
    return _uploadFile(path, fileName, "post_images");
  }
  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName){
    return _uploadFileBytes(fileBytes, fileName, "post_images");
  }

  /*

  HELPER METHODS - to upload file to storage

   */

  // mobile platforms (file)
  Future<String?> _uploadFile(String path, String fileName, String folder) async{
    try{
      // get file
      final file = File(path);

      // find place  to storage
      final storageRef = storage.ref().child('$folder/$fileName');

      // upload
      final uploadTask = await storageRef.putFile(file);

      // get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    }catch (e){
      return  null;
    }
  }

  // web platforms
  Future<String?> _uploadFileBytes(
      Uint8List fileBytes, String fileName, String folder) async{
    try{
      // find place to store
      final storageRef = storage.ref().child('$folder/$fileName');

      // upload
      final uploadTask = await storageRef.putData(fileBytes);

      // get image url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    }catch (e){
      return null;
    }
  }
}