import 'package:flutter/material.dart';
import 'package:goose_jumper/data/data.dart';
import 'package:goose_jumper/objects/goose.dart';

void showShop(List<String> skins, context, bestScore) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: SkinDialog(skins: skins, score: bestScore),
    ),
  );
}

class SkinDialog extends StatefulWidget {
  const SkinDialog({Key? key, required this.skins, required this.score})
      : super(key: key);

  final List<String> skins;
  final int score;

  @override
  State<SkinDialog> createState() => _SkinDialogState();
}

class _SkinDialogState extends State<SkinDialog> {
  int current = 0;
  List<String> availibleSkins = ["goose", "bunny", "chicken", "pineapple"];
  bool unlocked = true;

  void update(String currentSkin) {
    setState(() {
      currentSkin = availibleSkins[current];
      if (widget.skins.contains(currentSkin))
        unlocked = true;
      else
        unlocked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentSkin = availibleSkins[current];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green,
          width: 5.0,
        ),
        color: Colors.white,
      ),
      width: 300.0,
      height: 250.0,
      child: Column(
        children: <Widget>[
          SizedBox(height: 30),
          Text(
            'SKINS',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.green,
              fontSize: 20.0,
              fontFamily: 'Inconsolata',
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    if (current == 0)
                      current = availibleSkins.length - 1;
                    else
                      current -= 1;

                    update(currentSkin);
                  },
                  icon: Icon(Icons.arrow_back)),
              GestureDetector(
                child: Goose(gooseY: 0, skinId: currentSkin, visible: true),
                onTap: () async {
                  if (unlocked) {
                    saveCurrentSkin(currentSkin);
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.green,
                                width: 5.0,
                              ),
                              color: Colors.white,
                            ),
                            width: 150.0,
                            height: 75.0,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "requires a personal best of\n" +
                                      ((currentSkin == "bunny")
                                          ? "50"
                                          : ((currentSkin == "chicken")
                                              ? "100"
                                              : ((currentSkin == "pineapple")
                                                  ? "200"
                                                  : ("")))),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Inconsolata',
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  }
                },
              ),
              IconButton(
                  onPressed: () {
                    if (current == availibleSkins.length - 1)
                      current = 0;
                    else
                      current += 1;

                    update(currentSkin);
                  },
                  icon: Icon(Icons.arrow_forward)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Icon((unlocked) ? Icons.lock_open : Icons.lock_outline),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Text(
              "personal best: ${widget.score}",
              style: const TextStyle(
                fontFamily: 'Inconsolata',
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
