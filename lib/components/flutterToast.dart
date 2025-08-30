import 'package:fluttertoast/fluttertoast.dart';
import 'package:whatsappclone/core/MyColors.dart';

void myToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.SNACKBAR,
    backgroundColor: MyColors.toastBackGround,
    textColor: MyColors.toastMessage,
    fontSize: 17.0,
  );
}
