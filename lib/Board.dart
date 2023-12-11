import 'package:flutter/material.dart';
import 'Tile.dart';

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
  void swapTiles() {
    // Swap the two tiles
    Tile temp = tiles[highlighted];
    tiles[highlighted] = tiles[selected];
    tiles[selected] = temp;

    highlighted = -1;
    selected = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 320,
        height: 400,
        color: const Color(0xffe0ddd9),
        child: GridView.builder(
          itemCount: 36,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6),
          itemBuilder: (context, index) {
            return GestureDetector(
              child: tiles[index],
              onTap: () {
                if (highlighted == -1) {
                  highlighted = index;
                } else if (selected == -1) {
                  selected = index;
                  setState(() {
                    swapTiles();
                  });
                }
              },
            );
          },
        ));
  }
}
