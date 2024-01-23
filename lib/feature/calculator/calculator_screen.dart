import 'package:calculator_plus/native.dart';
import 'package:calculator_plus/utils/regexp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _output = "";

  performCalculation(String input) {
    setState(() {
      _output = input;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator Plus'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // performCalculation(_controller.text);
            String result = await api.calculateResult(expression: _controller.text);
            performCalculation(result);
          }
        },
        backgroundColor: Colors.purple,
        elevation: 5,
        splashColor: Colors.purpleAccent,
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 24,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Input',
                    hintText: 'Enter expression',
                    suffixIcon: IconButton(
                        onPressed: () {
                          _controller.text = "";
                          performCalculation(_controller.text);
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.grey,
                        ))),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Please enter valid input';
                  }
                  return null;
                },
                onChanged: (str) {
                  if (str.isEmpty) {
                  } else {
                    _formKey.currentState!.validate();
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.deny(invalidCalculatorRegex),
                ],
                autocorrect: false,
                enableSuggestions: false,
                controller: _controller,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Output:\n$_output",
                style: const TextStyle(fontSize: 14),
              ),
              // FutureBuilder(
              //   future: api.helloWorld(expression: _controller.text),
              //   builder: (context, data) {
              //     if (data.hasData) {
              //       return Text(data.data.toString());
              //     }
              //     return const Center(
              //       child: CircularProgressIndicator(),
              //     );
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
