
import 'dart:io';

import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Place { 
   Place({required this.title, required this.image}) : id = uuid.v4();
   String id; 
   String title ; 
   File image;
}