import 'dart:typed_data';
import 'package:image/image.dart' as img;

Future<List<Uint8List>> splitImage(bytes, int rows, int columns) async {
  final img.Image image = img.decodeImage(bytes)!;

  print('image.width: ${image.width} | image.height: ${image.height}');

  int partWidth = image.width ~/ columns;
  int partHeight = image.height ~/ rows;

  List<Uint8List> parts = [];

  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < columns; x++) {
      print('object: $x');
      int xOffset = x * partWidth;
      int yOffset = y * partHeight;

      int cropWidth = (x == columns - 1) ? (image.width - xOffset) : partWidth;
      int cropHeight = (y == rows - 1) ? (image.height - yOffset) : partHeight;

      print(
        'xOffset: $xOffset | yOffset: $yOffset | cropWidth: $cropWidth | cropHeight: $cropHeight',
      );

      img.Image part = img.copyCrop(
        image,
        x: xOffset,
        y: yOffset,
        width: cropWidth,
        height: cropHeight,
      );
      parts.add(Uint8List.fromList(img.encodeJpg(part)));
    }
  }
  return parts;
}
