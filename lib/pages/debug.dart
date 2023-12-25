import 'package:anonero/pages/debug/button_x_textfield.dart';
import 'package:anonero/widgets/long_outlined_button.dart';
import 'package:flutter/material.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("D38UG"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LongOutlinedButton(
              text: "LOButton x TextField",
              onPressed: () => ButtonTextFieldDebug.push(context),
            ),
          ],
        ),
      ),
    );
  }

  static void push(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const DebugPage();
      },
    ));
  }
}