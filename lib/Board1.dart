import 'package:flutter/material.dart';
import 'Tile.dart';

final GlobalKey<_BoardState> boardKey = GlobalKey<_BoardState>();

int highlighted = -1;
int selected = -1;

bool isHigh = false;
bool isSelec = false;

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
  // Define a GlobalKey
}

class _BoardState extends State<Board> {
  void triggerBuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: boardKey,
      width: 320,
      height: 400,
      color: const Color(0xffe0ddd9),
      child: GridView.count(
        crossAxisCount: 6,
        children: tiles,
      ),
    );
  }
}
