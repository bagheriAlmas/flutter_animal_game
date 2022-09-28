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
      appBar: AppBar(
        title: const Text("Animal Game"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  endGame();
                });
              },
              icon: const Icon(Icons.restart_alt)),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("درست : $correctAnswer"),
                  Text("غلط : 3 / $wrongAnswer"),
                  Text("راند : $round"),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: GridView.builder(
                itemCount: list.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return Draggable(
                      feedback: Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          list[index].image,
                          width: 96,
                        ),
                      ),
                      data: list[index].name,
                      child: Card(
                        elevation: 4,
                        child: Image.asset(
                          list[index].image,
                          width: 96,
                        ),
                      ));
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
              return Container(
                decoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                alignment: Alignment.center,
                width: 150,
                height: 150,
                child: Text(
                  strAnimalName,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            },
          ),
          const SizedBox(height: 50)
        ],
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

    round = 1;
    correctAnswer = 0;
    wrongAnswer = 0;
  }

  void endGame() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Game Over"),
            content: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Max Round : ${round-1}"),
                  Text("Your Rank : $correctAnswer"),
                  const SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pop(true);
                              restartGame();
                            });
                          },
                          child: const Text("Restart")),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("Resume"))
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }
}
