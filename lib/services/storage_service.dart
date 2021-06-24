
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
 final FirebaseStorage storage = FirebaseStorage.instance;

 void createImage() async{
   TaskSnapshot snapshot = await storage.ref().child('').putFile(File(''));
 }
}