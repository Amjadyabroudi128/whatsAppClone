import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:open_file/open_file.dart';
File? file;
String? url;
Future pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? imageCamera = await picker.pickImage(source: ImageSource.gallery);
  if (imageCamera != null) {
    file = File(imageCamera.path);
    var imagename = basename(imageCamera.path);
    var refStorage = FirebaseStorage.instance.ref(imagename);
    await refStorage.putFile(file!);
    url = await refStorage.getDownloadURL();
    return url;
  }
  return null;
}
Future takeImage() async  {
  final ImagePicker picker = ImagePicker();
  final XFile? imageCamera = await picker.pickImage(source: ImageSource.camera);
  if (imageCamera != null) {
    file = File(imageCamera.path);
    var imagename = basename(imageCamera.path);
    var refStorage = FirebaseStorage.instance.ref(imagename);
    await refStorage.putFile(file!);
    url = await refStorage.getDownloadURL();
    return url;
  }
  return null;
}
Future<String?> pickFile() async {
  final result = await FilePicker.platform.pickFiles();
  if (result != null && result.files.single.path != null) {
    file = File(result.files.single.path!);
    var fileName = basename(file!.path);
    var refStorage = FirebaseStorage.instance.ref(fileName);
    await refStorage.putFile(file!);
    url = await refStorage.getDownloadURL();
    return url;
  }
  return null;
}