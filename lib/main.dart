import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      title: 'Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SnakeGame(),
    );
  }
}

class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  List<int> snakePosition = [42, 62, 82, 102];
  int numberOfSquares = 760;

  static var randomNumber = Random();
  int food = randomNumber.nextInt(700);
  var speed = 300;
  bool playing = false;
  var direction = 'down';
  bool x1 = false;
  bool x2 = false;
  bool x3 = false;
  bool endGame = false;

  startGame() {
    setState(() {
      playing = true;
    });
    endGame = false;
    snakePosition = [42, 62, 82, 102];
    var duration = Duration(milliseconds: speed);
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (gameOver() || endGame) {
        timer.cancel();
        showGameOverDialog();
        playing = false;
        x1 = false;
        x2 = false;
        x3 = false;
      }
    });
  }

  gameOver() {
    if (snakePosition.last < 0 ||
        snakePosition.last >= numberOfSquares ||
        snakePosition.last % 20 == 0 ||
        (snakePosition.last + 1) % 20 == 0) {
      setState(() {
        playing = false;
      });
      return true;
    }

    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count += 1;
        }
        if (count == 2) {
          setState(() {
            playing = false;
          });
          return true;
        }
      }
    }
    return false;
  }

  showGameOverDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over'),
            content: Text('your score is ${snakePosition.length}'),
            actions: [
              TextButton(
                  onPressed: () {
                    startGame();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Play Again'))
            ],
          );
        });
  }

  generateNewFood() {
    setState(() {
      food = randomNumber.nextInt(700);
    });
  }

  updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last > 740) {
            snakePosition.add(snakePosition.last + 20 - 760);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;
        case 'up':
          if (snakePosition.last < 20) {
            snakePosition.add(snakePosition.last - 20 + 760);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;
        case 'left':
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;
        case 'right':
          if ((snakePosition.last + 1) % 20 == 0) {
            snakePosition.add(snakePosition.last + 1 - 20);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;
        default:
      }

      if (snakePosition.last == food) {
        generateNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(224, 247, 245, 225),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'up' && details.delta.dy > 0) {
                  direction = 'down';
                } else if (direction != 'down' && details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction = 'right';
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              child: Stack(
                children: [
                  Center(
                      child: Image.asset('images/snake.png.jpg',
                          fit: BoxFit.contain)),
                  GridView.builder(
                    itemCount: numberOfSquares,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 20,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (snakePosition.contains(index)) {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: const CircleAvatar(
                                radius: 7,
                                backgroundColor:
                                    Color.fromARGB(255, 15, 92, 28),
                              ),
                            ),
                          ),
                        );
                      }
                      if (index == food) {
                        return Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            color: Colors.red,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          !playing
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: x1
                            ? const Color.fromARGB(255, 153, 248, 153)
                            : Colors.transparent,
                      ),
                      margin: const EdgeInsets.all(10),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              x1 = true;
                              x2 = false;
                              x3 = false;
                              speed = 300;
                            });
                          },
                          child: const Text(
                            'X1',
                            style: TextStyle(
                              color: Color.fromARGB(255, 141, 6, 6),
                            ),
                          )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: x2
                            ? const Color.fromARGB(255, 147, 241, 147)
                            : Colors.transparent,
                      ),
                      margin: const EdgeInsets.all(10),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              x2 = true;
                              x1 = false;
                              x3 = false;
                              speed = 200;
                            });
                          },
                          child: const Text(
                            'X2',
                            style: TextStyle(
                              color: Color.fromARGB(255, 134, 3, 3),
                            ),
                          )),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: x3
                            ? const Color.fromARGB(255, 174, 244, 174)
                            : Colors.transparent,
                      ),
                      margin: const EdgeInsets.all(10),
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              x3 = true;
                              x1 = false;
                              x2 = false;
                              speed = 100;
                            });
                          },
                          child: const Text(
                            'X3',
                            style: TextStyle(
                              color: Color.fromARGB(255, 120, 16, 16),
                            ),
                          )),
                    )
                  ],
                )
              : const SizedBox(),
          !playing
              ? GestureDetector(
                  onTap: startGame,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    color: Colors.green,
                    child: const Text(
                      'Start Game',
                      style: TextStyle(
                          color: Color.fromARGB(255, 123, 6, 6), fontSize: 20),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
