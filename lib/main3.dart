import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));

const List<Color> colors = [
  Color.fromARGB(255, 219, 32, 7),
  Color.fromARGB(255, 49, 168, 1),
  Color.fromARGB(255, 11, 110, 156),
  Colors.pink,
  Color.fromARGB(255, 122, 12, 141),
  Color.fromARGB(255, 230, 123, 2)
];

const List<String> icons = ["🐞", "🐸", "🐳", "🐖", "🦄", "🐅"];

List<Tile> createTiles() {
  List<Tile> tilesList = List<Tile>.filled(
      36,
      Tile(
        color: Colors.white,
      ));
  for (int i = 0; i < 36; i++) {
    var random = Random();
    var randomNumber1 = random.nextInt(6);
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
  int score = 0;
  List<Tile> tiles = List<Tile>.filled(36, Tile());

  void initState() {
    super.initState();

    for (int i = 0; i < 36; i++) {
      var random = Random();
      var randomNumber1 = random.nextInt(5);
      tiles[i] = Tile(color: colors[randomNumber1], icon: icons[randomNumber1]);
      checkForMatches();
      score = 0;
    }
  }

  void checkForMatches() {
    List<List<int>> matchesArrHori = [];
    List<List<int>> matchesArrVer = [];
    for (int i = 0; i < c.length - 2; i++) {
      if (i % 6 < 5 &&
          c[i].icon == c[i + 1].icon &&
          c[i + 1].icon == c[i + 2].icon) {
        matchesArrHori
            .add([i, i + 1, i + 2, ...checkAdditionalMatchesHori(i + 2)]);
        print(" matched horizontal array: $matchesArrHori");
        score++;
        i = matchesArrHori[0][matchesArrHori[0].length - 1];

        for (i in matchesArrHori[0]) {
          replaceHori(i);
        }
        matchesArrHori = [];
      }

      if (i < 24 && c[i].icon == c[i + 6].icon && c[i].icon == c[i + 12].icon) {
        matchesArrVer
            .add([i, i + 6, i + 12, ...checkAdditionalMatchesVer(i + 12)]);

        print(" matched vertical array: $matchesArrVer");
        score++;
        replaceVer(
            matchesArrVer[0][0], matchesArrVer[0][matchesArrVer[0].length - 1]);

        matchesArrVer = [];
      }
    }
  }

  void replaceHori(int a) {
    if (a > 5) {
      c[a] = c[a - 6];
      a = a - 6;
      replaceHori(a);
      checkForMatches();
    } else {
      var random = Random();
      var randomNumber1 = random.nextInt(6);
      c[a] = Tile(color: colors[randomNumber1], icon: icons[randomNumber1]);
      checkForMatches();
    }
  }

  void replaceVer(int start, int end) {
    if (start > 5) {
      c[end] = c[(start - 6)];
      end = end - 6;
      start = start - 6;
      checkForMatches();
      replaceVer(start, end);
    } else {
      for (int i = end; i > -1; i = i - 6) {
        var random = Random();
        var randomNumber1 = random.nextInt(6);
        c[i] = Tile(color: colors[randomNumber1], icon: icons[randomNumber1]);
        checkForMatches();
      }
    }
  }

  List<int> checkAdditionalMatchesHori(int i) {
    List<int> result = [];

    for (i; i % 6 <= 4; i++) {
      if (c[i].color == c[i + 1].color) {
        result.add(i + 1);
      } else {
        break;
      }
    }

    return result;
  }

  List<int> checkAdditionalMatchesVer(int i) {
    List<int> result = [];

    for (i; i <= 29; i = i + 6) {
      if (c[i].color == c[i + 6].color) {
        result.add(i + 6);
      } else {
        break;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SCORE: $score'),
        centerTitle: true,
        backgroundColor: const Color(0xffbab1b1),
      ),
      body: Container(
        width: 380,
        height: 380,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6),
            itemCount: c.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  child: c[index],
                  onTap: () {
                    setState(() {
                      if (highlighted == 100) {
                        highlighted = index;
                      } else if (selected == 100) {
                        selected = index;
                        if ((highlighted - selected).abs() == 1 ||
                            (highlighted - selected).abs() == 6 &&
                                (!(highlighted % 6 == 5 && selected % 6 == 0) &&
                                    !((highlighted % 6 == 0 &&
                                        selected % 6 == 5)))) {
                          print("success");
                          selected = index;
                          Tile temp = c[highlighted];
                          c[highlighted] = c[selected];
                          c[selected] = temp;
                          highlighted = 100;
                          selected = 100;
                          checkForMatches();
                        } else {
                          highlighted = 100;
                          selected = 100;
                        }
                      }
                    });
                  });
            }),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  Color? color;
  String? icon;

  Tile({Key? key, this.color, this.icon}) : super(key: key);

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
      width: 100,
      height: 100,
      alignment: Alignment.center,
      child: Text(
        widget.icon ?? '',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
        ),
      ),
    );
  }
}
