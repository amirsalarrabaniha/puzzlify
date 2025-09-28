import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:puzzlify/models/size_model.dart';
import 'package:puzzlify/puzzlify.dart';

class PuzzlePage extends StatefulWidget {
  PuzzlePage({super.key});

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  Uint8List? file;
  final PuzzlifyController _puzzlifyController = PuzzlifyController();
  bool? result;

  @override
  void initState() {
    super.initState();
    getFileBytes();
  }

  getFileBytes({Key? key}) async {
    final response = await http.get(
      Uri.parse(
        'https://nar-dam.audi.com/adobe/assets/urn:aaid:aem:366f597c-87f7-4f00-afa9-e6dba76e539e/as/Tri1-MY23---Q3---Front---Parked---White-1920x1920.jpg?preferwebp=true',
      ),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to load image from network");
    }
    setState(() {
      file = response.bodyBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: file != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Puzzlify.local(
                    size: SizeModel(4, 4),
                    bytes: file!,
                    controller: _puzzlifyController,
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FilledButton(
                        onPressed: () {
                          _puzzlifyController.recreate();
                        },
                        child: Text('Recreate'),
                      ),
                      SizedBox(width: 10),
                      FilledButton(
                        onPressed: () {
                          _puzzlifyController.derange();
                        },
                        child: Text('Shuffle'),
                      ),
                      SizedBox(width: 10),
                      FilledButton(
                        onPressed: () {
                          result = _puzzlifyController.check();
                          setState(() {});
                        },
                        child: Text('Check'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (result != null) Text('Result: ${result.toString()}'),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

class PuzzleTabsPage extends StatelessWidget {
  const PuzzleTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6, // number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Puzzlify"),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "3x3"),
              Tab(text: "4x4"),
              Tab(text: "4x3"),
              Tab(text: "5x5"),
              Tab(text: "6x6"),
              Tab(text: "6x4"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PuzzlePageWrapper(row: 3, col: 3),
            PuzzlePageWrapper(row: 4, col: 4),
            PuzzlePageWrapper(row: 4, col: 3),
            PuzzlePageWrapper(row: 5, col: 5),
            PuzzlePageWrapper(row: 6, col: 6),
            PuzzlePageWrapper(row: 6, col: 4),
          ],
        ),
      ),
    );
  }
}

/// Wrapper widget to provide row/col size to PuzzlePage
class PuzzlePageWrapper extends StatelessWidget {
  final int row;
  final int col;

  const PuzzlePageWrapper({super.key, required this.row, required this.col});

  @override
  Widget build(BuildContext context) {
    return PuzzlePageCustom(row: row, col: col);
  }
}

/// A customizable PuzzlePage that accepts row and column count
class PuzzlePageCustom extends StatefulWidget {
  final int row;
  final int col;

  const PuzzlePageCustom({super.key, required this.row, required this.col});

  @override
  State<PuzzlePageCustom> createState() => _PuzzlePageCustomState();
}

class _PuzzlePageCustomState extends State<PuzzlePageCustom> {
  Uint8List? file;
  final PuzzlifyController _puzzlifyController = PuzzlifyController();
  bool? result;

  @override
  void initState() {
    super.initState();
    getFileBytes();
  }

  /// Load image bytes from the network
  getFileBytes() async {
    final response = await http.get(
      Uri.parse(
        'https://nar-dam.audi.com/adobe/assets/urn:aaid:aem:366f597c-87f7-4f00-afa9-e6dba76e539e/as/Tri1-MY23---Q3---Front---Parked---White-1920x1920.jpg?preferwebp=true',
      ),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to load image from network");
    }
    setState(() {
      file = response.bodyBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: file != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.row}x${widget.col}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(height: 16),

                /// The puzzle widget
                Puzzlify.local(
                  size: SizeModel(widget.row, widget.col),
                  bytes: file!,
                  controller: _puzzlifyController,
                ),
                const SizedBox(height: 16),

                /// Control buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilledButton(
                      onPressed: () => _puzzlifyController.recreate(),
                      child: const Text('Recreate'),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: () => _puzzlifyController.derange(),
                      child: const Text('Shuffle'),
                    ),
                    const SizedBox(width: 10),
                    FilledButton(
                      onPressed: () {
                        result = _puzzlifyController.check();
                        setState(() {});
                      },
                      child: const Text('Check'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                /// Show result of check()
                if (result != null) Text('Result: ${result.toString()}'),
              ],
            )
          : const CircularProgressIndicator(),
    );
  }
}
