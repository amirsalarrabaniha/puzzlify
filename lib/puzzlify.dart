import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:puzzlify/models/config_model.dart';
import 'package:puzzlify/models/pieces_gallery_model.dart';
import 'package:puzzlify/models/size_model.dart';
import 'package:puzzlify/utils/image_helper.dart';
import 'package:puzzlify/utils/shuffle_list.dart';

/// Controller
class PuzzlifyController extends ChangeNotifier {
  _PuzzlifyState? _state;

  void _attach(_PuzzlifyState state) {
    _state = state;
  }

  void derange() {
    if (_state == null) return;

    _state!.deranged();
  }

  void recreate() {
    _state!.recreate();
  }

  bool check() {
    return _state!.check();
  }
}

class Puzzlify extends StatefulWidget {
  final SizeModel size;
  final PuzzlifyConfig? config;
  final Uint8List fileBytes;
  final PuzzlifyController? controller;

  const Puzzlify._({
    super.key,
    required this.size,
    this.config,
    required this.fileBytes,
    this.controller,
  });

  factory Puzzlify.local({
    Key? key,
    required SizeModel size,
    PuzzlifyConfig? config,
    required Uint8List bytes,
    PuzzlifyController? controller,
  }) {
    return Puzzlify._(
      key: key,
      size: size,
      config: config,
      fileBytes: bytes,
      controller: controller,
    );
  }

  @override
  State<Puzzlify> createState() => _PuzzlifyState();
}

class _PuzzlifyState extends State<Puzzlify> {
  late PuzzlifyConfig _config;
  late List<PiecesGalleryModel> _orgPieces;
  late List<PiecesGalleryModel> _pieces;
  int _currentIndex = -1;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _config =
        widget.config ??
        PuzzlifyConfig(
          borderRadius: BorderRadius.circular(10),
          borderSelectColor: Colors.green,
          borderSelectWidth: 2,
        );

    // attach controller
    widget.controller?._attach(this);

    initList(widget.fileBytes);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _buildShimmerGrid();
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.size.column,
        crossAxisSpacing: _config.horizontalSpace,
        mainAxisSpacing: _config.verticalSpace,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      addAutomaticKeepAlives: false,
      itemCount: _pieces.length,
      itemBuilder: (BuildContext context, int index) {
        PiecesGalleryModel item = _pieces[index];
        return InkWell(
          onTap: () => piecesClick(index),
          child: Container(
            decoration: BoxDecoration(
              border: _currentIndex == index
                  ? Border.all(
                      color: _config.borderSelectColor,
                      width: _config.borderSelectWidth,
                    )
                  : null,
            ),
            child: Image.memory(item.item, fit: BoxFit.fill),
          ),
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.size.column,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.size.row * widget.size.column,
      itemBuilder: (_, __) {
        return Container(color: Colors.grey.shade300);
      },
    );
  }

  Future<void> initList(Uint8List file) async {
    setState(() => _loading = true);

    _orgPieces = [];
    List<Uint8List> items = await splitImage(
      file,
      widget.size.row,
      widget.size.column,
    );

    for (int index = 0; index < items.length; index++) {
      _orgPieces.add(PiecesGalleryModel(items[index], index));
    }
    _pieces = List.of(_orgPieces);
    _currentIndex = 0;

    setState(() => _loading = false);
  }

  void deranged() {
    setState(() {
      _pieces = _orgPieces.deranged();
    });
  }

  void recreate() {
    setState(() {
      _pieces = List.of(_orgPieces);
    });
  }

  bool check() {
    return _pieces.length == _orgPieces.length &&
        _pieces.asMap().entries.every(
          (entry) => entry.value == _orgPieces[entry.key],
        );
  }

  void piecesClick(int targetIndex) {
    if (_currentIndex == targetIndex) {
      _currentIndex = -1;
    } else if (_currentIndex != -1) {
      _pieces.swap(_currentIndex, targetIndex);
      check();
      _currentIndex = -1;
      targetIndex = -1;
    } else {
      _currentIndex = targetIndex;
    }
    setState(() {});
  }
}
