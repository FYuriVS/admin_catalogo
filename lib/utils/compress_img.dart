import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Uint8List> compressImage(File image) async {
  final fileBytes = await image.readAsBytes();
  final result = await FlutterImageCompress.compressWithList(
    fileBytes,
    quality: 50,
    format: CompressFormat.webp,
  );
  return result;
}
