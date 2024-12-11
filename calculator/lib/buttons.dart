import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String result = '0';

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '0';
      } else if (value == 'DEL') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
        }
      } else if (value == '=') {
        try {
          Parser parser = Parser();
          Expression expression = parser.parse(input);
          ContextModel contextModel = ContextModel();
          result =
              expression.evaluate(EvaluationType.REAL, contextModel).toString();
        } catch (e) {
          result = 'Error';
        }
      } else {
        input += value;
      }
    });
  }

  Widget buildButton(String text, Color bgColor, Color textColor) {
    return ElevatedButton(
      onPressed: () => buttonPressed(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Calculator"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              input,
              style: const TextStyle(fontSize: 32, color: Colors.black54),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              result,
              style: const TextStyle(fontSize: 48, color: Colors.black),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('C', Colors.green, Colors.white),
              buildButton('DEL', Colors.red, Colors.white),
              buildButton('%', Colors.purple, Colors.white),
              buildButton('/', Colors.purple, Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('7', Colors.white, Colors.black),
              buildButton('8', Colors.white, Colors.black),
              buildButton('9', Colors.white, Colors.black),
              buildButton('*', Colors.purple, Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('4', Colors.white, Colors.black),
              buildButton('5', Colors.white, Colors.black),
              buildButton('6', Colors.white, Colors.black),
              buildButton('-', Colors.purple, Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('1', Colors.white, Colors.black),
              buildButton('2', Colors.white, Colors.black),
              buildButton('3', Colors.white, Colors.black),
              buildButton('+', Colors.purple, Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('0', Colors.white, Colors.black),
              buildButton('.', Colors.white, Colors.black),
              buildButton('=', Colors.purple, Colors.white),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
