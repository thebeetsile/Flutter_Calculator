import 'package:flutter/material.dart';
import 'dart:math';
import 'package:math_expressions/math_expressions.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practice Math App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PracticeMath(),
    );
  }
}

class PracticeMath extends StatefulWidget {
  const PracticeMath({Key? key}) : super(key: key);

  @override
  State<PracticeMath> createState() => _PracticeMathState();
}

class _PracticeMathState extends State<PracticeMath> {
  late String question;
  late String answer;
  late String userAnswer;
  int points = 0;
  bool isAnswered = false;
  int timerSeconds = 120;
  late Timer _timer;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    generateNewQuestion();
    startTimer();
  }

  void generateNewQuestion() {
    // Generate a new random math expression for the quiz
    final int num1 = Random().nextInt(100);
    final int num2 = Random().nextInt(100);
    final List<String> operators = ['+', '-', '*', '/'];
    final String operator = operators[Random().nextInt(operators.length)];
    question = '$num1 $operator $num2';

    // Evaluate the answer for the generated expression
    final Parser p = Parser();
    final Expression exp = p.parse(question);
    final ContextModel cm = ContextModel();
    answer = exp.evaluate(EvaluationType.REAL, cm).toStringAsFixed(2); // Round to 2 decimal places

    userAnswer = '';
    isAnswered = false;
    _textEditingController.clear();
  }

  void checkAnswer() {
    try {
      final double userResult = double.tryParse(userAnswer) ?? 0.0;
      final double correctResult = double.tryParse(answer) ?? 0.0;

      if (userResult == correctResult) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Correct!'),
              content: Text('Great job! Your answer is correct.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      isAnswered = false; // Reset the isAnswered flag
                      points++; // Increase points by 1 for correct answer
                      if (points >= 10) {
                        // If user has 10 or more points, show happy emoji
                        showEmojiDialog(EmojiType.happy);
                      } else {
                        generateNewQuestion(); // Move to the next question
                      }
                    });
                  },
                  child: Text('Next'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Incorrect!'),
              content: Text('Oops! Your answer is incorrect. The correct answer is $answer.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      isAnswered = false;
                      generateNewQuestion(); // Move to the next question
                      _textEditingController.clear(); // Clear the input text box
                    });
                  },
                  child: Text('Try Again'),
                ),
              ],
            );
          },
        );
      }
      setState(() {
        isAnswered = true;
      });
    } catch (e) {
      // If the user's input cannot be parsed as a number, show an error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invalid Input'),
            content: Text('Please enter a valid number.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerSeconds > 0) {
        setState(() {
          timerSeconds--;
        });
      } else {
        _timer.cancel();
        showEmojiDialog(EmojiType.sad); // Show the sad emoji when time is up
      }
    });
  }

  void showEmojiDialog(EmojiType emojiType) {
    String emoji = emojiType == EmojiType.happy ? '🎉' : '😢';
    String message = emojiType == EmojiType.happy
        ? 'You have earned 10 or more points!'
        : 'You did not reach 10 points.';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(emojiType == EmojiType.happy ? 'Congratulations!' : 'Oops!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              SizedBox(height: 10),
              Text(
                emoji,
                style: TextStyle(fontSize: 50),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the emoji dialog
                setState(() {
                  isAnswered = false; // Reset the isAnswered flag
                  points = 0; // Reset points
                  userAnswer = ''; // Clear the user's answer
                  _textEditingController.clear(); // Clear the input text box
                });
                generateNewQuestion(); // Move to the next question
                startTimer(); // Restart the timer
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practice Math'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Solve the following expression:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              question,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _textEditingController,
              onChanged: (value) {
                userAnswer = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your Answer',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isAnswered ? null : checkAnswer,
              child: Text(isAnswered ? 'Next' : 'Submit'),
            ),
            SizedBox(height: 20),
            Text(
              'Time left: ${timerSeconds ~/ 60}:${(timerSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Points: $points',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

enum EmojiType {
  happy,
  sad,
}
