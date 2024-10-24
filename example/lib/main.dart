import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:colorpicker_textfield/colorpicker_textfield.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Picker TextFormField Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Color Picker TextFormField Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color inputColor = const Color(0xffffffff);
  final _formKey = GlobalKey<FormState>();
  final _backgroundKey = GlobalKey<FormFieldState<String>>();

  void _onSave() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    final text = _backgroundKey.currentState?.value;
    if (text == null) return;
    setState(() {
      inputColor = text.toColor() ?? const Color(0xffffffff);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: inputColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ColorPickerTextField(
              textFieldGrobalKey: _backgroundKey,
              title: 'Background Color',
              helperText: 'helper text',
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSave,
        child: const Icon(Icons.save),
      ),
    );
  }
}
