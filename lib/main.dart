import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animal_game/Helper/GenerateAnimalList.dart';

import 'Model/Animal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool finishGame = false;
  bool btnResumeVisibility = true;
  String messageTitle = "";
  Color messageColor = Colors.red;
  int wrongAnswer = 0;
  int correctAnswer = 0;
  int round = 1;
  static Random rnd = Random();

  static List<Animal> list = GenerateAnimalList().getRandomAnimal();
  String strAnimalName = (list..shuffle()).elementAt(rnd.nextInt(6)).name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.jpeg"),
                fit: BoxFit.cover)),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("درست : $correctAnswer"),
                      Text("غلط : 3 / $wrongAnswer"),
                      Text("راند : $round"),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              endGame();
                            });
                          },
                          icon: const Icon(Icons.restart_alt)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GridView.builder(
                    itemCount: list.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                          childAspectRatio: 1/1,
                          crossAxisSpacing: 10
                    ),
                    itemBuilder: (context, index) {
                      return IgnorePointer(
                        ignoring: finishGame,
                        child: Draggable(
                            feedback: Opacity(
                              opacity: 0.8,
                              child: Image.asset(
                                list[index].image,
                                width: 96,
                              ),
                            ),
                            data: list[index].name,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40))),
                              elevation: 4,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40)),
                                    color: Colors.lightGreen),
                                // color: Colors.green.shade200,
                                child: Image.asset(
                                  list[index].image,
                                  width: 32,
                                ),
                              ),
                            )),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 50),
              DragTarget(
                onWillAccept: (data) => true,
                onAccept: (data) {
                  setState(() {
                    if (data == strAnimalName) {
                      // print("Correct");
                      generateSnackbar("Correct", Colors.green);
                      correctAnswer++;
                    } else {
                      // print("Wrong");
                      generateSnackbar("Wrong", Colors.redAccent);
                      wrongAnswer++;
                      if (wrongAnswer == 3) {
                        btnResumeVisibility = false;
                        finishGame = true;
                        endGame();
                      }
                    }
                    list = GenerateAnimalList().getRandomAnimal();
                    Random rnd = Random();
                    strAnimalName =
                        (list..shuffle()).elementAt(rnd.nextInt(6)).name;
                    round++;
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/cave.png")),
                        ),
                        alignment: Alignment.center,
                        width: 250,
                        height: 200,
                      ),
                      Stack(alignment: Alignment.center, children: [
                        Image.asset("assets/images/wood_arrow.png", width: 130),
                        Positioned(
                          top: 40,
                          left: 25,
                          child: SizedBox(
                            width: 100,
                            child: Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                strAnimalName,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ],
                  );
                },
              ),
              const SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }

  void generateSnackbar(
    String message,
    Color color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 500),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 200, left: 150, right: 150),
      content: Text(message, textAlign: TextAlign.center),
    ));
  }

  void restartGame() {
    list = GenerateAnimalList().getRandomAnimal();
    strAnimalName = (list..shuffle()).elementAt(rnd.nextInt(6)).name;
    btnResumeVisibility = true;
    round = 1;
    correctAnswer = 0;
    wrongAnswer = 0;
    finishGame = false;
  }

  void endGame() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Column(
              children: [
                Center(child: const Text("Game Over")),
                Divider(
                  color: Colors.black,
                )
              ],
            ),
            content: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Max Round : ${round - 1}"),
                  Text("Your Rank : $correctAnswer"),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pop(true);
                              restartGame();
                            });
                          },
                          child: const Text("Restart")),
                      Visibility(
                          visible: btnResumeVisibility,
                          child: SizedBox(
                            width: 20,
                          )),
                      Visibility(
                        visible: btnResumeVisibility,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("Resume")),
                      )
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }
}
