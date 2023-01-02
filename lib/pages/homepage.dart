import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:goose_jumper/data/data.dart';
import 'package:goose_jumper/objects/barriers.dart';
import 'package:goose_jumper/objects/goose.dart';
import 'package:goose_jumper/pages/unlockables.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double gooseY = 1.0;
  String gooseSkinId = "goose";
  List<String> skins = ["goose"];
  double initPos = gooseY;
  double height = 0;
  double time = 0;
  double gravity = -3; // how strong the gravity is
  double velocity = 2.75; // how strong the jump is

  List<double> barrierTwoLocations = [1.75, 4.75, 4, 3.5, 4.5, 2];

  double barrierOneX = 3;
  double barrierTwoX = 4.5;

  double treeX = 0.5;
  double cloudOneX = 0;
  double cloudTwoX = -0.75;

  int score = 0;
  int bestScore = 0;

  bool startScreenVisible = true;

  @override
  void initState() {
    super.initState();
    setUpData();
  }

  void setUpData() async {
    bestScore = await loadScore();
    gooseSkinId = await loadCurrentSkin();
    skins = await loadSkins();
    gooseY = 1.0;
    initPos = gooseY;
    height = 0;
    time = 0;
    score = 0;
    barrierOneX = 3;
    barrierTwoX = 4.5;
    treeX = 0.5;
    cloudOneX = 0;
    cloudTwoX = -0.75;

    //in case new skins are added later :)
    unlockSkin(bestScore);
  }

  void startGame() {
    setUpData();
    Timer.periodic(
      const Duration(milliseconds: 70),
      (timer) {
        setState(
          () {
            barrierOneX -= 0.1;
            barrierTwoX -= 0.1;

            treeX -= 0.1;
            cloudOneX -= 0.1;
            cloudTwoX -= 0.1;
          },
        );

        if (barrierOneX < -1.5) barrierOneX = 1.25;
        if (barrierTwoX < -1.5) {
          double add =
              barrierTwoLocations[Random().nextInt(barrierTwoLocations.length)];
          barrierTwoX = barrierOneX + add;
          // print(add);
        }
        if (treeX < -3) treeX = 4;
        if (cloudOneX < -3) cloudOneX = 3.25;
        if (cloudTwoX < -3) cloudTwoX = 4;

        if (checkCollision(barrierOneX) == false &&
            checkCollision(barrierTwoX) == false) {
          incrementCounter(barrierOneX, barrierTwoX);
        } else {
          setState(() {
            barrierOneX = 3;
            barrierTwoX = 5;

            startScreenVisible = true;

            treeX = 0.5;
            cloudOneX = 0;
            cloudTwoX = -0.75;
          });
          timer.cancel();
        }
      },
    );
  }

  bool checkCollision(double barrierX) {
    if (gooseY == initPos && barrierX < 0.05 && barrierX > -0.05) {
      return true;
    }

    return false;
  }

  void incrementCounter(double barrierOneX, barrierTwoX) {
    if (gooseY != initPos &&
        (barrierOneX < 0.05 && barrierOneX > -0.05 ||
            barrierTwoX < 0.05 && barrierTwoX > -0.05)) {
      setState(
        () {
          score++;
        },
      );
      if (bestScore < score) {
        saveScore();
        unlockSkin(score);
      }
    }
  }

  void jump() {
    if (gooseY == 1.0) {
      Timer.periodic(
        const Duration(milliseconds: 50),
        (timer) {
          height = gravity * time * time + velocity * time;
          setState(
            () {
              gooseY = initPos - height;
            },
          );
          // Stops the goose from falling through the ground
          if (gooseY > initPos) {
            timer.cancel();
            gooseY = 1.0;
            initPos = gooseY;
            height = 0;
            time = 0;
          }
          time += 0.075;
        },
      );
    }
  }

  void unlockSkin(int score) {
    if (score >= 50 && !skins.contains("chicken")) {
      skins.add("chicken");
      saveSkins(skins);
    }

    if (score >= 100 && !skins.contains("bunny")) {
      skins.add("bunny");
      saveSkins(skins);
    }

    if (score >= 200 && !skins.contains("pineapple")) {
      skins.add("pineapple");
      saveSkins(skins);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GestureDetector(
      onTap: () async {
        if (startScreenVisible == false) {
          jump();
        } else {
          setState(
            () {
              setUpData();
              startScreenVisible = false;
            },
          );
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        alignment: const Alignment(0.75, -0.75),
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.yellow,
                        ),
                      ),
                      Container(
                        alignment: Alignment(treeX, 1.01),
                        child: const Image(
                          image: AssetImage('images/tree.png'),
                          width: 210.0,
                          height: 200.0,
                        ),
                      ),
                      Container(
                        alignment: Alignment(cloudOneX, -0.5),
                        child: const Image(
                          image: AssetImage('images/cloud.png'),
                          width: 100.0,
                          height: 60.0,
                        ),
                      ),
                      Container(
                        alignment: Alignment(cloudTwoX, -0.7),
                        child: const Image(
                          image: AssetImage('images/cloud.png'),
                          width: 100.0,
                          height: 60.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                        child: Text(
                          'T A P   T O   P L A Y',
                          style: TextStyle(
                            fontFamily: 'Inconsolata',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: startScreenVisible
                                ? Colors.white
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                        child: Text(
                          (startScreenVisible) ? 'GOOSE JUMPER' : '',
                          style: TextStyle(
                            fontFamily: 'Inconsolata',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: startScreenVisible
                                ? Colors.white
                                : Colors.transparent,
                          ),
                        ),
                      ),
                      Goose(
                          gooseY: gooseY,
                          skinId: gooseSkinId,
                          visible: (!startScreenVisible)),
                      Barrier(
                        barrierX: barrierOneX,
                        widht: 50.0,
                        height: 40.0,
                      ),
                      Barrier(
                        barrierX: barrierTwoX,
                        widht: 30.0,
                        height: 50.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.green,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.black,
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Container(
                        color: Colors.brown,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.store_mall_directory_rounded),
                              color: (startScreenVisible)
                                  ? Colors.white
                                  : Colors.transparent,
                              onPressed: () async {
                                if (startScreenVisible) {
                                  bestScore = await loadScore();

                                  showShop(
                                      await loadSkins(), context, bestScore);
                                }
                              },
                              iconSize: 40.0,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    startScreenVisible ? "" : 'score: $score',
                                    style: const TextStyle(
                                      fontFamily: 'Inconsolata',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    startScreenVisible
                                        ? ""
                                        : 'personal best: $bestScore',
                                    style: const TextStyle(
                                      fontFamily: 'Inconsolata',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
