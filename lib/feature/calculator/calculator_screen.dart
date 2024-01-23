import 'dart:io';

import 'package:calculator_plus/native.dart';
import 'package:calculator_plus/utils/constant_strings.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _output = "";

  updateOutput(String input) {
    setState(() {
      _output = input;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          titleText,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                exit(0);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            String result = await api.calculateResult(expression: _controller.text);
            if (result.toLowerCase().contains("error")) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text(inappropriateInputText), backgroundColor: Colors.red));
            } else {
              updateOutput(result);
            }
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
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(inputHint),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: labelText,
                        hintText: hintText,
                        suffixIcon: IconButton(
                            onPressed: () {
                              _controller.text = "";
                              updateOutput(_controller.text);
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.grey,
                            ))),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return inputErrorText;
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
                      FilteringTextInputFormatter.allow(validRegExp),
                    ],
                    autocorrect: false,
                    enableSuggestions: false,
                    controller: _controller,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                Text(
                  _output,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
