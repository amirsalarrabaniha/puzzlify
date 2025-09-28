import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:puzzlify/models/size_model.dart';

Future<List<SizeModel>?> checkImage(Uint8List bytes) async {
  final image = img.decodeImage(bytes);
  if (image == null) {}
  num width = image?.width ?? 0;
  num height = image?.height ?? 0;

  bool isEqual = checkEqual(width, height);
  bool isHor = checkHor(width, height);
  bool isVer = checkVer(width, height);

  if (image != null) {
    return [
      /// Equal
      if (isEqual) SizeModel(3, 3),
      if (isEqual) SizeModel(4, 4),
      if (isEqual) SizeModel(5, 5),
      if (isEqual) SizeModel(6, 6),

      ///Hor
      if (isHor) SizeModel(4, 3),
      if (isHor) SizeModel(5, 3),
      if (isHor) SizeModel(5, 4),
      if (isHor) SizeModel(6, 4),
      if (isHor) SizeModel(6, 5),
      if (isHor) SizeModel(7, 5),

      ///Ver
      if (isVer) SizeModel(3, 4),
      if (isVer) SizeModel(3, 5),
      if (isVer) SizeModel(4, 5),
      if (isVer) SizeModel(4, 6),
      if (isVer) SizeModel(5, 6),
      if (isVer) SizeModel(5, 7),
    ];
  } else {
    return null;
  }
}

bool checkEqual(width, height) {
  if (width == height ||
      (height > width && height < width + 10) ||
      (width > height && width < height + 10)) {
    return true;
  }
  return false;
}

bool checkVer(width, height) {
  if (height > width + 10) {
    return true;
  }
  return false;
}

bool checkHor(width, height) {
  if (width > height + 10) {
    return true;
  }
  return false;
}
