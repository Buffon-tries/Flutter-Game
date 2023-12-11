import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MaterialApp(
      home: Home(),
    ));

// Generates a random number between 0 and 7

const List<Color> colors = [
  Color.fromARGB(255, 219, 32, 7),
  Color.fromARGB(255, 49, 168, 1),
  Color.fromARGB(255, 11, 110, 156),
  Colors.pink,
  Color.fromARGB(255, 122, 12, 141),
  Color.fromARGB(255, 230, 123, 2)
];
Tile getRandomTile() {
  // List of available colors
  List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    // Add more colors if needed
  ];

  // List of available icons
  List<IconData> icons = [
    Icons.ac_unit,
    Icons.access_alarm,
    Icons.accessibility,
    Icons.account_balance,
    // Add more icons if needed
  ];

  // Randomly select a color and an icon index
  Random random = Random();
  Color randomColor = colors[random.nextInt(colors.length)];
  int randomIconIndex = random.nextInt(icons.length);
  IconData randomIcon = icons[randomIconIndex];

  // Create and return a new Tile with the selected color and icon
  return Tile(color: randomColor, icon: Icon(randomIcon));
}

const List<Icon> icons = [
  Icon(Icons.star),
  Icon(Icons.heart_broken),
  Icon(Icons.rocket_launch),
  Icon(Icons.flood_sharp),
  Icon(Icons.monochrome_photos_rounded),
  Icon(Icons.exposure_zero),
];

List<Tile> createTiles() {
  List<Tile> tilesList = List<Tile>.filled(
      36,
      Tile(
        color: Colors.white,
      ));
  for (int i = 0; i < 36; i++) {
    var random = Random();
    var randomNumber1 = random.nextInt(5);
    tilesList[i] =
        Tile(color: colors[randomNumber1], icon: icons[randomNumber1]);
  }

  return tilesList;
}

List<Tile> c = createTiles();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int highlighted = 100;
  int selected = 100;
  List<Tile> tiles = List<Tile>.filled(36, Tile());
  @override
  void initState() {
    super.initState();

    for (int i = 0, j = -1; i < 36; i++) {
      if (i % 6 == 0) {
        j++;
      }
      var random = Random();
      var randomNumber1 = random.nextInt(5);
      tiles[i] = Tile(
          color: colors[randomNumber1],
          icon: icons[randomNumber1],
          x: j,
          y: i % 6);
    }
    if (calculateMatches1() != false) {
      initState();
    }
  }

  calculateMatches1() {
    List<int> totalMatches = [];
    for (int r = 0; r < 6; r++) {
      Color? colorToMatch = tiles[r * 6].color;
      int? matchNum = 1;
      int? c = 1;
      for (c = 1; c! < 6; c++) {
        if (tiles[r * 6 + c].color == colorToMatch) {
          matchNum = matchNum! + 1;
          print('match incremented ');
        } else {
          colorToMatch = tiles[r * 6 + c].color;

          if (matchNum! >= 3) {
            print('horizontal match detected');

            for (int x2 = (r * 6 + c) - 1;
                x2 >= (r * 6 + c) - matchNum;
                x2 = x2 - 1) {
              totalMatches.add(x2);
              print('index $x2');
            }
          }
          matchNum = 1;
        }
      }
      if (matchNum! >= 3) {
        print('horizontal match detected');

        for (int x2 = (r * 6 + c) - 1;
            x2 >= (r * 6 + c) - matchNum;
            x2 = x2 - 1) {
          totalMatches.add(x2);

          print('index $x2');
        }
      }
    }

// Vertical Matches
    for (int c = 0; c < 6; c++) {
      Color? colorToMatch = tiles[c].color;
      int? matchNum = 1;
      int r = 1;
      for (r = 1; r < 6; r++) {
        if (tiles[r * 6 + c].color == colorToMatch) {
          matchNum = matchNum! + 1;
        } else {
          colorToMatch = tiles[r * 6 + c].color;

          if (matchNum! >= 3) {
            print('Vertical match detected');

            for (int x2 = (r * 6 + c) - 6;
                x2 >= (r * 6 + c) - (matchNum * 6);
                x2 = x2 - 6) {
              totalMatches.add(x2);

              print('index $x2');
            }
          }
          matchNum = 1;
        }
      }
      if (matchNum! >= 3) {
        print('Vertical match detected');

        for (int x2 = (r * 6 + c) - 6;
            x2 >= (r * 6 + c) - (matchNum * 6);
            x2 = x2 - 6) {
          totalMatches.add(x2);

          print('index $x2');
        }
      }
    }
    // if there are no matches return false else return the list of matches.
    return totalMatches.isEmpty ? false : totalMatches;
  }

  void removeMatches(List<int> matches, List<Tile> tiles) {
    for (int i = 0; i < matches.length; i++) {
      int index = matches[i];
      Tile t = tiles[index];
      tiles[index] = Tile(color: Colors.black, x: t.x, y: t.y);
    }
  }

  void getFallingTiles() {
    for (int i = 30; i < 36; i++) {
      // loop will iterate 6 time

      for (int j = 0, c = 30; j < 6; j++, c -= 6) {
        Tile t = tiles[c];

        if (t.color == Colors.black) {
          int c2 = c - 6;

          while (c2 > i % 30) {
            if (tiles[c2].color != Colors.black) {
              Tile temp = tiles[c];
              int? tempX = tiles[c].x;
              // swap their x values
              tiles[c].x = tiles[c2].x;
              tiles[c2].x = tempX;
              // swap the tiles
              tiles[c] = tiles[c2];
              tiles[c2] = temp;
              // break out of th eloop when the swapping is done.
              break;
            }
          }
        }
      }
    }
  }

  void swap() {
    Tile h = tiles[highlighted];
    Tile s = tiles[selected];

    if (h.x == s.x) {
      if (s.y! - h.y! == 1 || s.y! - h.y! == -1) {
        Tile temp = tiles[highlighted];

        int? tempY = temp.y; // y(H)= 0  and y(S) = 1 lets say
        temp.y = tiles[selected].y;
        tiles[selected].y = tempY;

        tiles[highlighted] = tiles[selected];

        tiles[selected] = temp;
      }
    } else if (h.y == s.y) {
      if (s.x! - h.x! == 1 || s.x! - h.x! == -1) {
        Tile temp = tiles[highlighted];

        int? tempX = temp.x;
        temp.x = tiles[selected].x;
        tiles[selected].x = tempX;

        tiles[highlighted] = tiles[selected];
        tiles[selected] = temp;
      }
    }

    highlighted = 100;
    selected = 100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6),
          itemCount: tiles.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                child: tiles[index],
                onTap: () {
                  setState(() {
                    if (highlighted == 100) {
                      highlighted = index;
                    } else if (selected == 100) {
                      selected = index;
                      swap();
                    }
                  });
                  var x;
                  setState(() {
                    x = calculateMatches1();
                    print(x);
                    if (x != false) {
                      removeMatches(x, tiles);
                    }
                  });
                  setState(() {
                    if (x != false) {
                      getFallingTiles();
                    }
                  });
                });
          }),
    );
  }
}

class Tile extends StatefulWidget {
  Color? color;
  Icon? icon;
  int? x;
  int? y;
  Tile({super.key, this.color, this.icon, this.x, this.y});

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(milliseconds: 400),
        width: 10,
        height: 10,
        child: widget.icon);
  }
}
