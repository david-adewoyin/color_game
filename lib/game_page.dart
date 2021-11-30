import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int trial = 3;
  int currentTrial = 1;
  int currentScore = 0;
  double initialTime = 10;
  bool missedGuessed = false;
  List<Widget> buttons = [];
  late Timer timer;

  late Color hiddenColor;

  endGame() {
    Navigator.maybeOf(context)!.pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 200),
                Text(
                  "Game Over !",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  child: Text(
                    "Score : $currentScore",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  child: TextButton(
                    onPressed: () {
                      Navigator.maybeOf(context)!.pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return GamePage();
                      }));
                    },
                    child: Text("Play Again!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  updateClock(Timer t) {
    if (initialTime - 1 < 0) {
      t.cancel();
      endGame();
    }
    initialTime = initialTime - 1;
    setState(() {
      initialTime.toStringAsFixed(2);
    });
  }

  @override
  initState() {
    hiddenColor = randomColor();
    generateColorsButton();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      updateClock,
    );

    super.initState();
  }

  Color randomColor({bool fromHidden = false}) {
    if (fromHidden) {
      var random = Random();
      return Color.fromRGBO(
        (hiddenColor.red * (random.nextDouble() + 0.1)).toInt(),
        (hiddenColor.green * (random.nextDouble() + 0.1)).toInt(),
        (hiddenColor.blue * (random.nextDouble() + 0.1)).toInt(),
        1,
      );
    }
    var random = Random();
    var r = random.nextInt(255);
    var g = random.nextInt(255);
    var b = random.nextInt(255);
    return Color.fromRGBO(r, g, b, 1);
  }

  Widget generateColorBtn({colorIsHidden = false, fromHidden = false}) {
    var random = Random();
    late Color color;
    color = colorIsHidden
        ? hiddenColor
        : randomColor(fromHidden: random.nextBool());
    return GestureDetector(
      key: UniqueKey(),
      onTap: () {
        if (colorIsHidden) {
          setState(() {
            currentScore = currentScore + 1;
          });
          setState(() {
            hiddenColor = randomColor();
            generateColorsButton();
          });
        } else {
          if (currentTrial - 1 < 0) {
            endGame();
          }
          currentTrial = currentTrial - 1;
          setState(() {
            missedGuessed = true;
          });
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              missedGuessed = false;
            });
          });
        }
      },
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  generateColorsButton() {
    List<Widget> wids = [];
    if (currentScore < 3) {
      wids.addAll([
        generateColorBtn(),
        generateColorBtn(colorIsHidden: true),
        generateColorBtn(),
      ]..shuffle());
    } else {
      wids.addAll([
        generateColorBtn(),
        generateColorBtn(colorIsHidden: true),
        generateColorBtn(),
        generateColorBtn(),
        generateColorBtn(),
        generateColorBtn(),
      ]..shuffle());
    }
    buttons.clear();
    setState(() {
      buttons.addAll(wids);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*   appBar: AppBar(
        backgroundColor: hiddenColor,
        centerTitle: true,
        title: Text(
          "WHAT COLOR IS THIS?",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ), */
      body: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            color: missedGuessed ? Colors.red : Colors.transparent,
            padding: missedGuessed ? EdgeInsets.all(3) : EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              color: hiddenColor,
              child: Center(
                child: Text(
                  "WHAT COLOR IS THIS ?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              SizedBox(width: 20),
              Text(
                "TIMER: ${initialTime.toInt()}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                "Score = $currentScore",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
          SizedBox(height: 200),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            spacing: 30,
            runSpacing: 30,
            children: buttons,
          )
        ],
      ),
    );
  }
}
