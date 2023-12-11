import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));

const List<Color> colors = [
  Color(0xffbc2419),
  Color(0xff067a2d),
  Color(0xff1f0eb5),
  Colors.pink,
  Color(0xff700a7e),
  Color(0xffdca304)
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
  int timerDuration = 60; // 1 minute
  int timeRemaining = 60;

  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int highlighted = 100;
  int selected = 100;
  int score = 0;
  int goalScore = 50;
  Timer? timer;

  List<Tile> tiles = List<Tile>.filled(36, Tile());
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (widget.timeRemaining > 0) {
          widget.timeRemaining--;
        } else {
          t.cancel(); // Stop the timer when time is up
        }
      });
    });
  }

  void initState() {
    super.initState();

    for (int i = 0; i < 36; i++) {
      var random = Random();
      var randomNumber1 = random.nextInt(5);
      tiles[i] = Tile(color: colors[randomNumber1], icon: icons[randomNumber1]);
    }
    checkForMatches();

    score = 0;
    startTimer();
    // widget.audioPlayer.setAsset('assets/audio/sample_sound.mp3');
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
        score += 5;

        i = matchesArrHori[0][matchesArrHori[0].length - 1];

        for (i in matchesArrHori[0]) {
          replaceHori(i);
        }
        matchesArrHori = [];
        checkForMatches();
      }

      if (i < 24 && c[i].icon == c[i + 6].icon && c[i].icon == c[i + 12].icon) {
        matchesArrVer
            .add([i, i + 6, i + 12, ...checkAdditionalMatchesVer(i + 12)]);

        print(" matched vertical array: $matchesArrVer");
        score += 5;

        replaceVer(
            matchesArrVer[0][0], matchesArrVer[0][matchesArrVer[0].length - 1]);
        checkForMatches();

        matchesArrVer = [];
      }
    }
  }

  void replaceHori(int a) {
    if (a > 5) {
      for (int i = a - 6; i >= 0; i = i - 6) {
        c[a] = c[i];
        a = a - 6;
        var random = Random();
        var randomNumber1 = random.nextInt(6);
        c[i] = c[i] =
            Tile(color: colors[randomNumber1], icon: icons[randomNumber1]);
      }
    } else {
      for (int i = a; i <= a; i += 6) {
        var random = Random();
        var randomNumber1 = random.nextInt(6);
        c[i] = c[i] =
            Tile(color: colors[randomNumber1], icon: icons[randomNumber1]);
      }
    }
  }

  void replaceVer(int start, int end) {
    if (start > 5) {
      for (int i = start - 6; i >= 0; i -= 6) {
        c[end] = c[i];
        end -= 6;

        var random = Random();
        var randomNumber1 = random.nextInt(6);
        c[i] = Tile(color: colors[randomNumber1], icon: icons[randomNumber1]);
      }
    } else {
      for (int i = start; i <= end; i += 6) {
        var random = Random();
        var randomNumber1 = random.nextInt(6);
        c[i] = Tile(color: colors[randomNumber1], icon: icons[randomNumber1]);
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

  void showEndContainer() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 400),
          child: AlertDialog(
            backgroundColor: const Color(0xffffffff),
            title: Text(
              (score >= goalScore) ? 'Congratulations!' : 'Game Over',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: (score >= goalScore) ? Colors.amber : Colors.red,
              ),
            ),
            content: Text(
              (score >= goalScore)
                  ? 'You achieved the goal score of $goalScore!'
                  : 'Try again to reach the goal score of $goalScore.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  (score >= goalScore) ? 'Next Level' : 'Play Again',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff03355f),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();

                  setState(() {
                    widget.timeRemaining = widget.timerDuration;
                    if (score >= goalScore) {
                      goalScore = goalScore + 10;
                    }
                    score = 0;
                    tiles = createTiles();
                    startTimer();
                  });

                  // Close the dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.timeRemaining == 0) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        showEndContainer();
      });
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        title: Row(
          children: [
            const SizedBox(width: 20),
            Text(
                (widget.timeRemaining % 3 == 0)
                    ? '🕛 ${widget.timeRemaining} s'
                    : (widget.timeRemaining % 3 == 1)
                        ? '🕘 ${widget.timeRemaining} s'
                        : '🕓 ${widget.timeRemaining} s',
                style: const TextStyle(color: Color(0xff04477e))),
            const SizedBox(width: 30),
            const Text('🏆',
                style: TextStyle(color: Color(0xff04477e), fontSize: 28)),
            const SizedBox(width: 5),
            Text(' $score ',
                style: TextStyle(
                    color: score >= goalScore
                        ? const Color(0xff0a9f05)
                        : Colors.red,
                    fontSize: 20)),
            Text(': $goalScore',
                style: const TextStyle(color: Color(0xff04477e), fontSize: 20))
          ],
        ),
        centerTitle: true,
        backgroundColor: Color(0xffd9cedb),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
              Color(0xfff8f8f8),
              Color(0xffccc1cd),
              Color(0xffb4a6b7),
              Color(0xfff8f8f8),
              Color(0xffccc1cd),
              Color(0xffb4a6b7),
            ])),
        width: 380,
        height: 600,
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

  Tile({super.key, this.color, this.icon});

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
        child: Center(child: Text('${widget.icon}')));
  }
}
