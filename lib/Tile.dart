import 'package:flutter/material.dart';
import 'dart:math';
import 'Board.dart';

const List<Color> colors = [
  Color(0xff74201b),
  Color(0xff670b77),
  Color(0xff075a0a),
  Color(0xff0d6dbc),
  Color(0xffa28c0d),
  Color(0xff9d0236),
  Color(0xff012f49),
  Color(0xff08201a)
];
const List<Icon> icons = [
  Icon(Icons.star),
  Icon(Icons.heart_broken),
  Icon(Icons.square),
  Icon(Icons.rocket),
  Icon(Icons.diamond),
  Icon(Icons.square),
  Icon(Icons.rocket),
  Icon(Icons.rocket),
];
List<Tile> tiles = createTiles();
List<Tile> createTiles() {
  final ts = List<Tile>.filled(
      36, Tile(color: Colors.white, icon: const Icon(Icons.add), index: 1));
  int i = 0;
  for (; i < 36; i++) {
    Random randomC = Random();
    int colorIndex = randomC.nextInt(7);
    Random randomI = Random();
    int iconIndex = randomI.nextInt(7);

    ts[i] = Tile(color: colors[colorIndex], icon: icons[iconIndex], index: i);
  }

  return ts;
}

class Tile extends StatefulWidget {
  Color color;
  Icon icon;
  int index;
  Tile({Key? key, required this.color, required this.icon, required this.index})
      : super(key: key);

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  final double tileWidth = 4;
  final double tileHeight = 4;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: tileWidth,
        height: tileHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: widget.color,
        ),
        child: IconButton(icon: widget.icon, onPressed: () {}));
  }
}
