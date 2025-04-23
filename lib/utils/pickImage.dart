import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

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