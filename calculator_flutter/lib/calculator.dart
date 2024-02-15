import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'practice_math.dart';
import 'maths_library.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cool Calculator APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Calculator(),
        '/maths_library': (context) => const MathsLibrary(),
      },
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String userInput = "";
  String results = "0";
  List<CalculationRecord> inputHistory = [];
  bool isMinimized = false;

  int insertionPoint = 0;

  TextEditingController _textEditingController = TextEditingController();

  List<String> buttonsList = [
    'Del',
    '(',
    ')',
    '/',
    '7',
    '8',
    '9',
    '*',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    'C', 
    '0',
    '.',
    '=',
  ];

  @override
  void initState() {
    super.initState();
    inputHistory = loadData();
  }

  List<CalculationRecord> loadData() {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return isMinimized ? minimizedView() : fullView();
  }

  Widget fullView() {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Calculator'),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                showInputHistory();
              },
            ),
            IconButton(
              icon: const Icon(Icons.library_books),
              onPressed: () {
                Navigator.pushNamed(context, '/maths_library');
              },
            ),
            IconButton(
              icon: const Icon(Icons.quiz),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PracticeMath()));
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.indigo,
                Colors.purple,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: resultWidget(),
              ),
              Expanded(
                flex: 2,
                child: buttonWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget minimizedView() {
    return Positioned(
      top: 10,
      left: 10,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isMinimized = false;
          });
        },
        child: MaterialButton(
          onPressed: () {
            setState(() {
              isMinimized = true;
            });
          },
          color: Colors.blue,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Calculator',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget resultWidget() {
    return Container(
      color: Colors.grey[300],
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    insertionPoint = _textEditingController.text.length;
                  });
                },
                child: TextField(
                  controller: _textEditingController,
                  style: const TextStyle(fontSize: 32),
                  cursorColor: Colors.black,
                  cursorWidth: 2,
                  showCursor: true,
                  onChanged: (text) {
                    setState(() {
                      insertionPoint = _textEditingController.selection.baseOffset;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerRight,
              child: RichText(
                text: TextSpan(
                  children: [
                    for (int i = 0; i < results.length; i++)
                      TextSpan(
                        text: results[i],
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: rainbowColor(i),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color rainbowColor(int index) {
    const rainbowColors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];
    return rainbowColors[index % rainbowColors.length];
  }

  Widget buttonWidget() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: GridView.builder(
          itemCount: buttonsList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (BuildContext context, int index) {
            return button(buttonsList[index]);
          },
        ),
      ),
    );
  }

  Widget button(String text) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: MaterialButton(
        onPressed: () {
          onButtonPressed(text);
        },
        color: getColor(text),
        textColor: Colors.white,
        shape: const CircleBorder(),
        child: Text(
          text == '/' ? '÷' : text == '*' ? '×' : text,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  getColor(String text) {
    if (text == "/" || text == "+" || text == "*" || text == "-") {
      return Colors.orangeAccent;
    }
    if (text == "(" || text == ")") {
      return Colors.deepPurple;
    }
    return Colors.lightBlue;
  }

  void onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == "Del") {
    
        String currentText = _textEditingController.text;
        if (insertionPoint > 0 && insertionPoint <= currentText.length) {
          String newText = currentText.substring(0, insertionPoint - 1) +
              currentText.substring(insertionPoint);
          _textEditingController.text = newText;
          insertionPoint--;
        }
      } else if (buttonText == "C") {
        // Clear the entire text and reset the results to zero
        _textEditingController.text = "";
        results = "0";
        insertionPoint = 0;
      } else if (buttonText == "=") {
        try {
          Parser p = Parser();
          String processedText = _textEditingController.text.replaceAllMapped(
            RegExp(r'(?<=[0-9\)])\('),
            (match) => '*(',
          ).replaceAllMapped(
            RegExp(r'\)\('),
            (match) => ')*(',
          );
          Expression exp = p.parse(processedText);
          ContextModel cm = ContextModel();
          results = exp.evaluate(EvaluationType.REAL, cm).toString();
          addToHistory(_textEditingController.text, results);
          _textEditingController.text = "";
          insertionPoint = 0;
        } catch (e) {
          results = "Error";
        }
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "*" ||
          buttonText == "/") {
      
        if (results != "0") {
          _textEditingController.text = results;
          insertionPoint = results.length;
          results = "0";
        }
        String newText = _textEditingController.text.substring(0, insertionPoint) +
            buttonText +
            _textEditingController.text.substring(insertionPoint);
        _textEditingController.text = newText;
        insertionPoint++;
      } else {
        if (results != "0") {
          // If there is already a result, clear it before appending the new input
          _textEditingController.text = buttonText;
          results = "0";
          insertionPoint = 1;
        } else {
          // Convert ()() to *
          if (buttonText == "(" && insertionPoint > 0) {
            String lastChar = _textEditingController.text[insertionPoint - 1];
            if (!lastChar.contains(RegExp(r'[0-9\)]'))) {
              buttonText = "*";
            }
          }
          String newText = _textEditingController.text.substring(0, insertionPoint) +
              buttonText +
              _textEditingController.text.substring(insertionPoint);
          _textEditingController.text = newText;
          insertionPoint++;
        }
      }
    });
  }

  bool _isOperator(String text) {
    return text == '/' || text == '+' || text == '*' || text == '-';
  }

  void addToHistory(String input, String result) {
    if (inputHistory.length >= 3) {
      inputHistory.removeAt(0);
    }
    inputHistory.add(CalculationRecord(input: input, result: result));
  }

  void showInputHistory() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('User Input History'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: inputHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(inputHistory[index].input),
                  subtitle: Text('Result: ${inputHistory[index].result}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class CalculationRecord {
  final String input;
  final String result;

  CalculationRecord({required this.input, required this.result});
}
