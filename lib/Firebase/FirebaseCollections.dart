import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference userC = FirebaseFirestore.instance.collection("users");
final CollectionReference stars = FirebaseFirestore.instance.collection("starred-messages");
