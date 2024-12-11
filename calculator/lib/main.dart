//IM/2021/080 - Navodya Samarasinghe.
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Importing math expressions package for parsing and evaluating expressions

void main() {
  runApp(const CalculatorApp()); // Run the CalculatorApp widget
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Return a MaterialApp with the CalculatorScreen widget as the home screen
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disables the debug banner in the app
      home: CalculatorScreen(), // The main screen of the calculator
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

// Calculator screen with state
class _CalculatorScreenState extends State<CalculatorScreen> {
  // Variables to store the current input and result
  String input = '';
  String result = ''; // Start with an empty result instead of '0'
  List<String> history = []; // List to store the calculation history
  bool isNewInput =
      false; // Tracks if a new input should start after showing the result

// Function to handle button presses
  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        //in this code i handle all clear button.
        input = ''; // Clear the input
        result = ''; // Clear the result
        isNewInput = false; // Reset the new input flag
      } else if (value == 'DEL') {
        if (input.isNotEmpty) {
          input = input.substring(
              0, input.length - 1); // Delete the last character from input
        } else {
          result = ''; // If input is empty, clear the result
        }
        isNewInput = false; // Reset the new input flag
      } else if (value == '√') {
        if (isNewInput) {
          input = ''; // Clear input if starting fresh
          isNewInput = false;
        }
        input += '√'; // Add square root symbol
      } else if (value == '=') {
        _calculateResult(); // Calculate the result when '=' is pressed
        isNewInput = true; // Set the flag to true after calculating
      } else {
        if (isNewInput) {
          input = ''; // Clear input when starting fresh
          isNewInput = false;
        }
        if (input.isNotEmpty &&
            _isOperator(value) &&
            _isOperator(input[input.length - 1])) {
          // Handle ++, -- more operation.
          // Prevent consecutive operators
          input = input.substring(0, input.length - 1) + value;
        } else {
          input += value; // Add the button value to the input
        }
        _updateResult(); // Update the result based on the current input
      }
    });
  }

// Function to calculate the result
  void _calculateResult() {
    try {
      // Check for division by zero explicitly
      if (input.contains('/0')) {
        result = "Can't divide by zero";
        return; // Stop further processing
      }

      String formattedInput =
          _formatInput(input); // Replace square root symbol with "sqrt()"

      Parser parser = Parser();
      Expression expression = parser.parse(formattedInput);
      ContextModel contextModel = ContextModel();
      double evalResult =
          expression.evaluate(EvaluationType.REAL, contextModel);

      if (evalResult.isInfinite) {
        result = "Can't divide by zero"; // Handle division by zero
      } else {
        result = evalResult == evalResult.toInt()
            ? evalResult
                .toInt()
                .toString() // Display result as an integer if it is a whole number
            : evalResult
                .toString(); // Otherwise, display the result as a double
        history.add('$input = $result'); // Add the calculation to history
        input = result; // Set input to the result for the next calculation
      }
    } catch (e) {
      result = 'Error';
    }
  }

// Function to update the result as the user types
  void _updateResult() {
    try {
      String formattedInput =
          _formatInput(input); // Replace square root symbol with "sqrt()"

      if (formattedInput.isNotEmpty &&
          !_isOperator(formattedInput[formattedInput.length - 1])) {
        Parser parser = Parser();
        Expression expression = parser.parse(formattedInput);
        ContextModel contextModel = ContextModel();
        double evalResult =
            expression.evaluate(EvaluationType.REAL, contextModel);

        if (evalResult.isInfinite) {
          result = "Can't divide by zero";
        } else {
          result = evalResult == evalResult.toInt()
              ? evalResult.toInt().toString()
              : evalResult.toString();
        }
      } else {
        result = ''; // Display nothing if the input is an operator
      }
    } catch (e) {
      result = 'Error';
    }
  }

// Helper function to check if a string is an operator
  bool _isOperator(String value) {
    return value == '+' ||
        value == '-' ||
        value == '*' ||
        value == '/' ||
        value == '%' ||
        value == '√';
  }

// Function to format the input for evaluation (replace symbols like '√' with 'sqrt()')
  String _formatInput(String input) {
    String formattedInput = input.replaceAll('√', 'sqrt(');

    // Handle percentage (convert % to /100)
    formattedInput = formattedInput.replaceAll('%', '/100');

    // Ensure all "sqrt" calls are properly closed with a parenthesis
    int openCount = '('.allMatches(formattedInput).length;
    int closeCount = ')'.allMatches(formattedInput).length;
    if (openCount > closeCount) {
      formattedInput += ')' * (openCount - closeCount);
    }

    return formattedInput;
  }

// Function to show the calculation history in a modal bottom sheet
  void showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'History',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const Divider(color: Colors.grey),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: history.length, // Show all history entries
                  reverse: true, // Show latest history at the top
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        history[
                            index], // Display each calculation from the history
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// Helper function to create calculator buttons with a specific style
  Widget buildButton(String text, Color bgColor, Color textColor) {
    return SizedBox(
      width: 80,
      height: 80,
      child: ElevatedButton(
        onPressed: () => buttonPressed(text), // Handle button press
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: const CircleBorder(), // Make button circular
          padding: const EdgeInsets.all(0), // Remove padding inside the button
        ),
        child: Text(
          text, // Display the button text
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: textColor, // Set the text color
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        centerTitle: true,
        title: const Text(
          "Calculator",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () => showHistory(context), // Show history when pressed
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Input display
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              input,
              style: const TextStyle(
                  fontSize: 32, color: Color.fromARGB(255, 235, 229, 229)),
            ),
          ),
          // Result display
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              result.isEmpty
                  ? ''
                  : result, // Display empty if result is not set
              style: const TextStyle(
                  fontSize: 24, color: Color.fromARGB(255, 158, 158, 158)),
            ),
          ),
          const Divider(),
          // Button layout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton(
                  'C', Colors.white, const Color.fromARGB(255, 228, 8, 52)),
              buildButton(
                  'DEL', Colors.white, const Color.fromARGB(255, 6, 140, 39)),
              buildButton(
                  '%', const Color.fromARGB(255, 152, 159, 238), Colors.white),
              buildButton(
                  '/', const Color.fromARGB(255, 152, 159, 238), Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('7', Colors.white, Colors.black),
              buildButton('8', Colors.white, Colors.black),
              buildButton('9', Colors.white, Colors.black),
              buildButton(
                  '*', const Color.fromARGB(255, 152, 159, 238), Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('4', Colors.white, Colors.black),
              buildButton('5', Colors.white, Colors.black),
              buildButton('6', Colors.white, Colors.black),
              buildButton(
                  '-', const Color.fromARGB(255, 152, 159, 238), Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('1', Colors.white, Colors.black),
              buildButton('2', Colors.white, Colors.black),
              buildButton('3', Colors.white, Colors.black),
              buildButton(
                  '+', const Color.fromARGB(255, 152, 159, 238), Colors.white),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('√', Colors.white, Colors.black),
              buildButton('0', Colors.white, Colors.black),
              buildButton('.', Colors.white, Colors.black),
              buildButton(
                  '=', const Color.fromARGB(255, 152, 159, 238), Colors.white),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
